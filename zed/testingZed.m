%% Testing Hokuyo
clc;
disp('=========SL_ZED_WITH_MATLAB -- Point Cloud=========');
close all;
clear mex; clear functions; clear all;

mexZED('create');

player = pcplayer([-5000 5000],[-5000 5000],[-5000 5000]);


% Define Scan Parameters
InitParameters.camera_resolution = 1; %1 = 1080p
InitParameters.camera_fps = 30;
InitParameters.system_units = 2; %METER
InitParameters.depth_mode =  1; %PERFORMANCE
InitParameters.coordinate_system = 3; %COORDINATE_SYSTEM_RIGHT_HANDED_Z_UP
result = mexZED('open', InitParameters)

% DepthClamp value
depth_max = 5;

% Step for mesh display
data_Step = 5;

requested_mesh_size = [200 128];

pt_X = zeros(requested_mesh_size);
pt_Y = zeros(requested_mesh_size);
pt_Z = zeros(requested_mesh_size);

mexZED('setDepthMaxRangeValue', depth_max)

while isOpen(player)
    % get camera scan
    % grab the current image and compute the depth
    RuntimeParameters.sensing_mode = 0; %STANDARD
    RuntimeParameters.enable_depth = 1;
    RuntimeParameters.enable_point_cloud = 1;
    mexZED('grab', RuntimeParameters)
    [pt_X, pt_Y, pt_Z] = mexZED('retrieveMeasure', 3, requested_mesh_size(1), requested_mesh_size(2)); %XYZ pointcloud
    
    % PointCloud    
    pointsZed = 1000 * [pt_X(:), pt_Y(:), pt_Z(:)];
    pointsZed = pointsZed( ~any( isnan( pointsZed) | isinf( pointsZed ),2) ,:);
    ptCloudZed = pointCloud(pointsZed);
    
    %denoising
    denoisedZed = pcdenoise(ptCloudZed);
    
    %downsampling
    downsampledZed = pcdownsample(denoisedZed,'gridAverage', 0.1);
    
    %displaying
    view(player, downsampledZed);
    pause(0.1)
end

mexZED('close')
clear mex;
disp('the end')
