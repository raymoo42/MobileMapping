
%% ---------------------
% Prof. Dr. Thomas Abmayr
% Fakultät für Geoinformation
% Hochschule München
%% ---------------------

function [  ] = Registrierung3D3D(  )

clc;
clear all;
close all;

load('finalErr.mat');
load('initVals.mat'); 

%ptCloud_h = pcread('hokuyo_ALL_0.pcd');
ptCloud_zed = pcread('ptCloud_zed.pcd')
% ptCloud_zf = pcread('HM_RAUM230.pcd');
clear finalError;
clear initValues;

%% 2.) Datenstruktur definieren

data(1,:,:) = [
    2.005500078201,-2.573400020599,-0.392899990082 ;
    1.382200002670,-2.646199941635,-0.389499992132 ;
    -0.740000009537,-2.892600059509,-0.403400003910;
    -0.481000006199,-2.861099958420,0.332199990749 ;
    0.440299987793,-2.750799894333,0.609799981117  ;
    2.449899911880,-2.518199920654,0.426400005817  ;
    0.552399992943,-3.211499929428,-0.395200014114 ;
    ];
 
data(2,:,:) = [ 
    -1.178068995476,-0.252550989389,-2.870997905731;
    -0.562334001064,-0.253277987242,-2.766582965851;
    1.496147036552,-0.280012011528,-2.461399078369 ;
    1.236575007439,0.432135999203,-2.429591894150  ;
    0.342471987009,0.702184021473,-2.511300086975  ;
    -1.628754019737,0.558785021305,-2.885884046555 ;
    0.362868994474,-0.230547994375,-3.100752115250 ;

    ];      
data(3,:,:) = [
    2.005500078201,-2.573400020599,-0.392899990082 ;
    1.382200002670,-2.646199941635,-0.389499992132 ;
    -0.740000009537,-2.892600059509,-0.403400003910;
    -0.481000006199,-2.861099958420,0.332199990749 ;
    0.440299987793,-2.750799894333,0.609799981117  ;
    2.449899911880,-2.518199920654,0.426400005817  ;
    0.552399992943,-3.211499929428,-0.395200014114 ;
    ];
data(4,:,:) = [ 
    -1.178068995476,-0.252550989389,-2.870997905731;
    -0.562334001064,-0.253277987242,-2.766582965851;
    1.496147036552,-0.280012011528,-2.461399078369 ;
    1.236575007439,0.432135999203,-2.429591894150  ;
    0.342471987009,0.702184021473,-2.511300086975  ;
    -1.628754019737,0.558785021305,-2.885884046555 ;
    0.362868994474,-0.230547994375,-3.100752115250 ;
    ];

%% 3.) Startwerte berechnen
R(:,:,1) = eye(3);
initValues = [];
for i=2:4
    P(:,:) = data(i,:,:);
    Q(:,:) = data(1,:,:);
	[r,p,y,tx,ty,tz] = Reg_3D_3D_init( P, Q );
    initValues = [initValues,r,p,y,tx,ty,tz]; 
    
end

err = Reg_3D_3D_statistics( initValues, data );
% Transformation
R = setRPY(r, p, y);
T = [tx, ty, tz];

H = zeros(4,4);
H(1:3,1:3) = R;
H(:,4) = [tx,ty,tz,1];

save('H_zed.mat','H');

for i=1:6
    p1 = [data(1,i,1),data(1,i,2),data(1,i,3), 1]'
    p2 = [data(2,i,1),data(2,i,2),data(2,i,3), 1]'
    error(i,:) = H * p1 - p2
end

points = zeros(ptCloud_zed.Count,3);

for i=1:ptCloud_zed.Count
    points(i,:) = R * ptCloud_zed.Location(i,:)' + [tx,ty,tz]';
end

newPtCloud = pointCloud(points);
pcshow(points, [1.0,0,0]);
hold on;
pcshow(ptCloud_zed);

pcwrite(newPtCloud, 'newZED.pcd');

f = @(x) errFct( x, data);

% % options = optimset('MaxFunEvals',10000, 'TolFun', 1e-10, 'MaxIter', 4);
% options = optimset( 'MaxFunEvals',30);
% % x_optimized = lsqnonlin(f, initValues, [], [], options);
% x_optimized = fminsearch(f, initValues, options);
% 
% err = Reg_3D_3D_statistics( x_optimized, data );
% 
% N = 1;
% for i=1 : 2
%     for k=1 : 6
%         a = [err(i,k,1), err(i,k,2), err(i,k,3)];
%         finalError(N,1:3) = a';
%         N = N+1;
%     end
% end;

save('initVals.mat', 'initValues'); 
% save('finalErr.mat', 'finalError');
