clc;
clear all;
close all;

player = pcplayer([-15 15],[-15 15],[-15 15]);
player2 = pcplayer([-15 15],[-15 15],[-15 15]);

% Lod pointCloud
ptCloudDoor = pcread('tuer_rahmen.pcd');
ptCloudHokuyo = pcread('zedCloud.pcd');

%denoising
ptCloudDoorDenoised = pcdenoise(ptCloudDoor);
ptCloudHokuyoDenoised = pcdenoise(ptCloudHokuyo);

%downsampling
ptCloudDoorDownsampled = pcdownsample(ptCloudDoorDenoised,'gridAverage',0.001);
ptCloudHokuyoDownsampled = pcdownsample(ptCloudHokuyoDenoised,'gridAverage', 0.001);

%icp
[transform, ptCloudHokuyoTransformed] = pcregrigid(ptCloudHokuyoDownsampled, ptCloudDoorDownsampled);

% transform
% ptCloudHokuyoTransformed = pctransform(ptCloudHokuyo, transform);

% merge
ptCloudResultBefore = pcmerge(ptCloudDoorDownsampled, ptCloudHokuyoDownsampled, 0.001)
ptCloudResultAfter = pcmerge(ptCloudDoorDownsampled, ptCloudHokuyoTransformed, 0.001)

%displaying
view(player, ptCloudResultBefore);
view(player2, ptCloudResultAfter);