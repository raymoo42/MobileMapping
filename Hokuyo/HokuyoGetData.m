%% Testing Hokuyo
format long


if exist('hokuyo', 'var')
    fclose(hokuyo);
end

hokuyo = utmOpen('192.168.0.10');

player = pcplayer([-5000 5000],[-5000 5000],[-5000 5000]);
% Define Scan Parameters
res = 0.25;
% create position vector
pos = [0 0 0 1]
figure(2)
while isOpen(player)
    
    [scan, timestamp] = utmGetScan(hokuyo, 0, 1080);

    angle = linspace(-135, 135, length(scan)) .* pi/180;

    angleVector=((res*0:res:1080*res)-135)'.*pi/180;
    rangeVector=scan;

    % points = [cos(angle) .* scan'; sin(angle) .* scan'; zeros(size(angle))]';
    points = [rangeVector.*sin(angleVector), rangeVector.*cos(angleVector), zeros(size(rangeVector))];
    
    % into pointcloud
    ptCloud = pointCloud(points);
    
    % Denoise
    denoised = pcdenoise(ptCloud);
    
    % downsample
    downsampled = pcdownsample(ptCloud,'gridAverage',25);
    %downsampled = ptCloud;
    view(player, downsampled);
    
    % diff to previous cloud
%     if j > 1
% %         figure(1)
% 
% %         plot (downsampled.Location(:,1),downsampled.Location(:,2),'k.');
% %         hold on;
% %         plot (old_downsampled.Location(:,1),old_downsampled.Location(:,2),'r.');
%         transform = pcregrigid(downsampled, old_downsampled,'Extrapolate',true);
%         pos(j,:) = transform.T' * pos(j-1,:)';
%         pause(0.1);
%         
%     end
%     old_downsampled = denoised;
end
fclose(hokuyo);
disp('the end')
