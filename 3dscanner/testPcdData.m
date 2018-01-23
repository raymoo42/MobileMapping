%% 3d pointcloud data
player = pcplayer([-5 5],[-5 5],[-5 5]);


% ptCloud = pcread('tuer_rahmen.pcd');
ptCloud = pcread('hokuyo.pcd');
%ptCloud = pcdownsample(ptCloud, 'gridAverage', 0.01);
%while isOpen(player)
view(player, ptCloud);
%end

disp('the end')
