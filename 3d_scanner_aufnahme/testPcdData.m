%% 3d pointcloud data
player = pcplayer([-5 5],[-5 5],[-5 5]);


% ptCloud = pcread('tuer_rahmen.pcd');
ptCloud = pcread('../PointCloudData/zed/point_cloud_PCD_13480_1242_01-02-2018-16-59-50.pcd');
%ptCloud = pcdownsample(ptCloud, 'gridAverage', 0.01);
%while isOpen(player)
view(player, ptCloud);
%end

disp('the end')
