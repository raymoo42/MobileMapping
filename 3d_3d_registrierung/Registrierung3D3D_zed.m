
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

ptCloud_zed = pcread('ptCloud_zed.pcd')
% ptCloud_zf = pcread('HM_RAUM230.pcd');
clear finalError;
clear initValues;

%% 2.) Datenstruktur definieren
%  ZF
data(1,:,:) = [
    1.861400008202,-2.826200008392,0.203199997544;
    1.190400004387,-2.859100103378,0.231099992990;
    0.381799995899,-2.899300098419,0.804300010204;
    2.401700019836,-2.796700000763,0.622900009155;
    -0.349999994040,-6.759699821472,0.269100010395;
    2.613300085068,-1.737800002098,0.190099999309;
    ];
%  zed
data(2,:,:) = [
    -0.058676000684,0.045864999294,-3.375257968903;
    0.545183002949,0.057541999966,-3.075299978256;
    1.316177964211,0.640448987484,-2.817909002304;
    -0.552239000797,0.460040003061,-3.580544948578;
    3.848575115204,0.110298000276,-6.134719848633;
    -1.208242058754,0.016813000664,-2.681303024292;
    ];
% ZF
data(3,:,:) = [
    1.861400008202,-2.826200008392,0.203199997544;
    1.190400004387,-2.859100103378,0.231099992990;
    0.381799995899,-2.899300098419,0.804300010204;
    2.401700019836,-2.796700000763,0.622900009155;
    -0.349999994040,-6.759699821472,0.269100010395;
    2.613300085068,-1.737800002098,0.190099999309;
    ];
% zed
data(4,:,:) = [
    -0.058676000684,0.045864999294,-3.375257968903;
    0.545183002949,0.057541999966,-3.075299978256;
    1.316177964211,0.640448987484,-2.817909002304;
    -0.552239000797,0.460040003061,-3.580544948578;
    3.848575115204,0.110298000276,-6.134719848633;
    -1.208242058754,0.016813000664,-2.681303024292;
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
