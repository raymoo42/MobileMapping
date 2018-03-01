function [ timestamp, ptCloud ] = getHokuyoPointCloud( hokuyo_tcp )
%GETHOKYUOPOINTCLOUD Summary of this function goes here
%   Detailed explanation goes here
    %get hokyuo scan
    %%
    resolution = 0.25;
    %%
    [scan, timestamp] = utmGetScan(hokuyo_tcp, 0, 1080);
    
    angle = linspace(-135, 135, length(scan)).* pi/180;
    angleVector=((resolution*1080:-1*resolution:0*resolution)-135)'.* pi/180;
    
    rangeVector=scan;
    
    pointsHokuyo = [rangeVector.*sin(angleVector), rangeVector.*cos(angleVector), zeros(size(rangeVector))] / 1000;
    ptCloud = pointCloud(pointsHokuyo);

end

