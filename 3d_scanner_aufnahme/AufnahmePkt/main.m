format longg
%% Taking Points
addpath('hokuyo', 'zed', 'util', 'ircam');

%% scan param
num_samples = 5;
scan_time_delta = 0.5;

%% intialize Hokuyo
if exist('hokuyo', 'var')
    fclose(hokuyo);
end
res = 0.25;
hokuyo = utmOpen('192.168.0.10');

%% initialize ZED
clear mex;
clear functions;
mexZED('create');

InitParameters.camera_resolution = 0;   %2K
InitParameters.camera_fps = 15;         %FPS
InitParameters.system_units = 2;        %METER
InitParameters.depth_mode =  2;         %Quality
InitParameters.coordinate_system = 3;   %COORDINATE_SYSTEM_RIGHT_HANDED_Z_UP

result = mexZED('open', InitParameters);

% DepthClamp value
depth_max = 5;
% Step for mesh display
data_Step = 10;
requested_mesh_size = [2560 720];

pt_X = zeros(requested_mesh_size);
pt_Y = zeros(requested_mesh_size);
pt_Z = zeros(requested_mesh_size);

mexZED('setDepthMaxRangeValue', depth_max);
% grab the current image and compute the depth
RuntimeParameters.sensing_mode = 0; %STANDARD
RuntimeParameters.enable_depth = 1;
RuntimeParameters.enable_point_cloud = 1;

%% initialize IR Cam
% TODO?

%% init List
% hokuyo_list = {};
% zed_list = {};
fid = fopen('id_table.csv','w')

%% start Recording
scanning = true;
id = 1;
while(scanning)
    % delta time
    tic 
    % generate id string
    id_string = sprintf('%08d.pcd', id);
    
    % get timestamp
    timestamp = posixtime(datetime('now'));
    
    % ZED scan
    mexZED('grab', RuntimeParameters);
    [pt_X, pt_Y, pt_Z] = mexZED('retrieveMeasure', 3, requested_mesh_size(1), requested_mesh_size(2)); %XYZ pointcloud
    pointsZed = [pt_X(:), pt_Y(:), pt_Z(:)];
    ptCloudZed = pointCloud(pointsZed);
    ptCloudZed = removeInvalidPoints(ptCloudZed);

    pcwrite(ptCloudZed, sprintf('data/zed/%06d.pcd', id));
    toc
    
    % Hokuyo scan
    [timestamp_hokuyo, ptHokuyo] = getHokuyoPointCloud(hokuyo);
    
    pcwrite(ptHokuyo, sprintf('data/hokuyo/%06d.pcd', id));
    toc
    
    % write to id_table
    fprintf(fid, '%06d, %f\n', id, timestamp); 
    
    % ensure scan_time_delta
    while toc < scan_time_delta
       pause( scan_time_delta / 1000. )
    end
    % scan for x samples
    if id >= num_samples
        scanning = false;
    else
        id = 1+id;
    end
end

%% cleanup
mexZED('close')
fclose('all');
clear mex;
disp(['end of script']);