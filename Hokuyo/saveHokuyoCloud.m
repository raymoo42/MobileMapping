%% Testing Hokuyo
if exist('hokuyo', 'var')
    fclose(hokuyo);
end

hokuyo = utmOpen('192.168.0.10');

% Step for mesh display
data_Step = 10;

%Hokuyo resolution
res = 0.25;

    %get hokyuo scan
    [scan, timestamp] = utmGetScan(hokuyo, 0, 1080);
    angle = linspace(-135, 135, length(scan)).* pi/180;
    angleVector=((res*1080:-1*res:0*res)-135)'.* pi/180;
    rangeVector=scan;
    pointsHokuyo = [rangeVector.*sin(angleVector), rangeVector.*cos(angleVector), zeros(size(rangeVector))] / 1000;
    
    ptCloudHokuyo = pointCloud(pointsHokuyo);
    pcwrite(ptCloudHokuyo, 'hokuyo.pcd');  

fclose(hokuyo);
disp('the end')
