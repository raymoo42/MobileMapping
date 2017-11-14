%% Projekt Mobile Mapping
clc;
disp('=========SL_ZED_WITH_MATLAB -- Point Cloud=========');
close all;
clear mex; clear functions; clear all;

mexZED('create');

% parameter struct, the same as sl::InitParameters
% values as enum number, defines in : sl/GlobalDefine.hpp 
% or from https://www.stereolabs.com/developers/documentation/API/
% 1: true, 0: false for boolean

InitParameters.camera_resolution = 2; %HD720
InitParameters.camera_fps = 60;
InitParameters.system_units = 2; %METER
InitParameters.depth_mode = 3; %QUALITY
%param.svo_filename = '../mySVOfile.svo'; % Enable SVO playback
result = mexZED('open', InitParameters)

% DepthClamp value
depth_max = 10;
% Step for mesh display
data_Step = 10;

if(strcmp(result,'Error code:  Success'))
    mexZED('setDepthMaxRangeValue', depth_max)
    % Create Figure
    f = figure('name','ZED SDK : Point Cloud','NumberTitle','off');
    %create 2 sub figure
    %ha1 = axes('Position',[0.05,0.7,0.9,0.25]);
    %ha2 = axes('Position',[0.05,0.05,0.9,0.6]);
    axis([-depth_max, depth_max, 0, depth_max, -depth_max ,depth_max])
    xlabel('X');
    ylabel('Z');
    zlabel('Y');
    grid on;
    hold on;
    
    % init mesh data
    size = mexZED('getResolution')
    pt_X = zeros(size(1),size(2));
    pt_Y = zeros(size(1),size(2));
    pt_Z = zeros(size(1),size(2));
    mlimit = [-depth_max, depth_max];
    player = pcplayer(mlimit, mlimit, mlimit);
    ok = 1;
    % loop over frames
    while ok
        % grab the current image and compute the depth
        RuntimeParameters.sensing_mode = 0; %STANDARD
        RuntimeParameters.enable_depth = 1;
        RuntimeParameters.enable_point_cloud = 1;
        mexZED('grab', RuntimeParameters)
        
%         % retrieve the point cloud
%         [pt_X, pt_Y, pt_Z] = mexZED('retrieveMeasure', 3); %XYZ pointcloud
%         p3d = [pt_X(:), pt_Y(:),pt_Z(:)];

        p3d = mexZED('retrieveMeasure', point
        p3d_cloud = pointCloud(p3d);
        p3d_down = pcdownsample(p3d_cloud,'gridAverage',0.01);
        
        %displays it
        
        view(player, p3d_down);
                
        drawnow; %this checks for interrupts
        ok = ishandle(f); %does the figure still exist
    end
end

% Make sure to call this function to free the memory before use this again
mexZED('close')

        