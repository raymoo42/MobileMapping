%% Testing Hokuyo
clc;
disp('=========SL_ZED_WITH_MATLAB -- Point Cloud=========');

if exist('hokuyo', 'var')
    fclose(hokuyo);
end
close all;
clear mex; clear functions; clear all;


mexZED('create');
hokuyo = utmOpen('192.168.0.10');

player = pcplayer([-5000 5000],[-5000 5000],[-5000 5000]);


% Define Scan Parameters
InitParameters.camera_resolution = 2; %HD720
InitParameters.camera_fps = 30;
InitParameters.system_units = 2; %METER
InitParameters.depth_mode =  1; %PERFORMANCE
InitParameters.coordinate_system = 3; %COORDINATE_SYSTEM_RIGHT_HANDED_Z_UP
result = mexZED('open', InitParameters)

% DepthClamp value
depth_max = 5;
% Step for mesh display
data_Step = 10;
requested_mesh_size = [100 64];
pt_X = zeros(requested_mesh_size);
pt_Y = zeros(requested_mesh_size);
pt_Z = zeros(requested_mesh_size);

%Hokuyo resolution
res = 0.25;

mexZED('setDepthMaxRangeValue', depth_max)

while isOpen(player)
    %get hokyuo scan
    [scan, timestamp] = utmGetScan(hokuyo, 0, 1080);
    angle = linspace(-135, 135, length(scan)) .* pi/180;
    angleVector=((res*0:res:1080*res)-135)'.*pi/180;
    rangeVector=scan;
    pointsHokuyo = [rangeVector.*sin(angleVector), rangeVector.*cos(angleVector), zeros(size(rangeVector))];
    
    % get camera scan
    % grab the current image and compute the depth
    RuntimeParameters.sensing_mode = 0; %STANDARD
    RuntimeParameters.enable_depth = 1;
    RuntimeParameters.enable_point_cloud = 1;
    mexZED('grab', RuntimeParameters)
    [pt_X, pt_Y, pt_Z] = mexZED('retrieveMeasure', 3, requested_mesh_size(1), requested_mesh_size(2)); %XYZ pointcloud
    
    % PointClouds
    ptCloudHokuyo = pointCloud(pointsHokuyo);
    
    pointsZed = 1000 * [pt_X(:), pt_Y(:), pt_Z(:)];
    pointsZed = pointsZed( ~any( isnan( pointsZed) | isinf( pointsZed ),2) ,:);
    ptCloudZed = pointCloud(pointsZed);
    
    %denoising
    denoisedHokuyo = pcdenoise(ptCloudHokuyo);
    denoisedZed = pcdenoise(ptCloudZed);
    
    %downsampling
    downsampledHokuyo = pcdownsample(denoisedHokuyo,'gridAverage',0.1);
    downsampledZed = pcdownsample(denoisedZed,'gridAverage', 0.1);
    
    %icp
    transform = pcregrigid(downsampledZed, downsampledHokuyo,'Metric','pointToPoint');
    
    % transform Zed Cloud
    transformedPtCloud = pctransform(ptCloudZed, transform);
    
    % merge
    ptResult = pcmerge(ptCloudHokuyo, transformedPtCloud, 0.015)
   
    %displaying
    view(player, transformedPtCloud);
    pause(0.5)
end

mexZED('close')
clear mex;
fclose(hokuyo);
disp('the end')
