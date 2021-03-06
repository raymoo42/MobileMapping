%% Testing Hokuyo
clc;
disp('=========SL_ZED_WITH_MATLAB -- Point Cloud=========');

close all;
clear mex; clear functions; clear all;


mexZED('create');

% Define Scan Parameters
InitParameters.camera_resolution = 0;
InitParameters.camera_fps = 15;
InitParameters.system_units = 2; %METER
InitParameters.depth_mode =  2; %PERFORMANCE
InitParameters.coordinate_system = 3; %COORDINATE_SYSTEM_RIGHT_HANDED_Z_UP
result = mexZED('open', InitParameters)

% DepthClamp value
depth_max = 5;
% Step for mesh display
data_Step = 10;
requested_mesh_size = [512 256];
pt_X = zeros(requested_mesh_size);
pt_Y = zeros(requested_mesh_size);
pt_Z = zeros(requested_mesh_size);


mexZED('setDepthMaxRangeValue', depth_max)


    % get camera scan
    % grab the current image and compute the depth
    RuntimeParameters.sensing_mode = 0; %STANDARD
    RuntimeParameters.enable_depth = 1;
    RuntimeParameters.enable_point_cloud = 1;
    
    for i=0:10
        mexZED('grab', RuntimeParameters)
        [pt_X, pt_Y, pt_Z] = mexZED('retrieveMeasure', 3, requested_mesh_size(1), requested_mesh_size(2)); %XYZ pointcloud

        % ZED
        pointsZed = 1 * [pt_X(:), pt_Y(:), pt_Z(:)];
        % pointsZed = pointsZed( ~any( isnan( pointsZed) | isinf( pointsZed ),2) ,:);

        ptCloudZed = pointCloud(pointsZed);
        ptCloudZed = removeInvalidPoints(ptCloudZed);

        pcwrite(ptCloudZed, 'data/zedCloud_' + num2str(i) + '.pcd');
    end
mexZED('close')
clear mex;
disp('the end')
