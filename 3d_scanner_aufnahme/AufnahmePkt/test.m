addpath('util')

mkdir('data')
fid = fopen('test.csv','w')
%id_table = cell2table(cell(0,2));
%id_table.Properties.VariableNames ={'id', 'timestamp'} ;
scanning = true;
id = 1;
num_samples = 25;
scan_time_delta = 0.5;
ptCloud = pcread('teapot.ply');

tmp = load('transform_zed.mat');
transform_hokuyo = tmp.H

while(scanning)
    % scan_time_delta
    delta = tic;
    
    % Scan
    ptCloud = pcread('teapot.ply');
    % id list
    timestamp = posixtime(datetime('now'));
    fprintf(fid, '%06d, %f\n', id, timestamp);    
    a = Scan(timestamp, ptCloud);
    
    A = transform_hokuyo';
    tform = affine3d(A);
    % randomness
    ptCloud = pctransform(a.ptCloud, tform);
    
    % write data
    pcwrite(ptCloud, sprintf('data/test/%09d.pcd', id));
    
    % ensure scan_time_delta minimum
    toc(delta)
    while toc(delta) < scan_time_delta
       pause( scan_time_delta / 1000. );
    end
    % scan for x samples
    if id >= num_samples
        scanning = false;
    else
        id = id+1;
    end
end

disp(['end'])
fclose('all');