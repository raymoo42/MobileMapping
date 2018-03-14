a{1} = pcread('00_hokuyo_050318.pcd')
a{2} = pcread('01_hokuyo_050318.pcd')
a{3} = pcread('02_hokuyo_050318.pcd')
a{4} = pcread('03_hokuyo_050318.pcd')
a{5} = pcread('04_hokuyo_050318.pcd')
a{6} = pcread('05_hokuyo_050318.pcd')

b = a{1}.Location
for j=2:6
   b = b + a{j}.Location 
end
b = b ./ 6
new = pointCloud(b)
pcshowpair(new, a{1})

pcwrite(new, 'ptCloud_hokuyo.pcd');
