format longg
%% load transforms /sensor -> ZF-scanner ks/
tmp = load('transform_hokuyo.mat');
transform_hokuyo = tmp.H
tmp = load('transform_zed.mat');
transform_zed = tmp.H

%% load timestamp file
idx = csvread('id_table.csv')

% get all pcd filenames in data dir
for i=1:1:length(idx)
    ph = pcread(sprintf('data/hokuyo/%06d.pcd', i ));
    pz = pcread(sprintf('data/zed/%06d.pcd', i ));
    pcshowpair(ph, pz);
    pause(0.5)
end

% Hokuyo transform (invert and apply after zed -> zF scanner transform)
%     tform = affine3d(transform_hokuyo');

% ZED transform
%     tform = affine3d(transform_zed');
%     ptCloudZed = pctransform(ptCloudZed, tform);
    