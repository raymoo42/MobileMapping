
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

ptCloud_h = pcread('ptCloud_hokuyo.pcd');
% ptCloud_zed = pcread('ptCloud_zed.pcd')
% ptCloud_zf = pcread('HM_RAUM230.pcd');
clear finalError;
clear initValues;

%% 2.) Datenstruktur definieren
% Zf
data(1,:,:) = [
    1.861400008202,-2.826200008392,0.203199997544;
    1.190400004387,-2.859100103378,0.231099992990;
    -0.587899982929,-2.951800107956,0.297399997711;
    2.613300085068,-1.737800002098,0.190099999309;
    ]; 
% Hokuyo
data(2,:,:) = [
    0.666428983212,3.350363016129,0.000000000000;
    1.218911051750,2.942709922791,0.000000000000;
    2.677495002747,1.892266988754,0.000000000000;
    -0.564918994904,2.975514888763,0.000000000000;
    ];
% Zf
data(3,:,:) = [
    1.861400008202,-2.826200008392,0.203199997544;
    1.190400004387,-2.859100103378,0.231099992990;
    -0.587899982929,-2.951800107956,0.297399997711;
    2.613300085068,-1.737800002098,0.190099999309;
    ];
% Hokuyo
data(4,:,:) = [ 
    0.666428983212,3.350363016129,0.000000000000;
    1.218911051750,2.942709922791,0.000000000000;
    2.677495002747,1.892266988754,0.000000000000;
    -0.564918994904,2.975514888763,0.000000000000;
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

save('H_hokuyo.mat','H');

for i=1:4
    p1 = [data(1,i,1),data(1,i,2),data(1,i,3), 1]'
    p2 = [data(2,i,1),data(2,i,2),data(2,i,3), 1]'
    error(i,:) = H * p1 - p2
end

points = zeros(ptCloud_h.Count,3);

for i=1:ptCloud_h.Count
    points(i,:) = R * ptCloud_h.Location(i,:)' + [tx,ty,tz]';
end

newPtCloud = pointCloud(points);
pcshow(points, [1.0,0,0]);
hold on;
pcshow(ptCloud_h);

pcwrite(newPtCloud, 'newPtCloudHokuyo.pcd');

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
