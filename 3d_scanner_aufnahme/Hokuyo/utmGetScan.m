function [data timestamp] = utmGetScan(t,start,stop);
% Returns a scan from hokuyo utm30-lx-ew laser
% t = tcpip object created with utmOpen
% start = starting point
% stop = end point of laser reading
%
% skipping and groupin is both zero

if nargin==1
    start=0;
    stop=1080;
end

noPoints=(stop-start+1);

cmd=sprintf('GD%04d%04d%02d\n',start,stop,0);
fprintf(t,'%s', cmd);
timestamp=etime(clock,[1970 1 1 0 0 0]);

% we only read DATA, the header is retreived by fscanf
noBlocks=ceil( noPoints*3/64 );
bytesToGet=noPoints*3+noBlocks*2+1;

header=fscanf(t);
status=fscanf(t);
time=fscanf(t);

if ~strcmp(cmd,header) || ~strncmp('00P',status,3)
    error('HOKUYO UTM-30-LX-EW returned a wrong status');
end

scan = fread(t,bytesToGet);
data=[];

%% Extract data from scan
for i=1:noBlocks-1
    data=[data; scan( (i-1)*66+1 : (i-1)*66 + 64 )];
    
    %% CHECK CODE
    %cc=scan( (i-1)*66+65);   
    %ss=dec2bin(sum(dataBuf));
    %check=bin2dec(ss(end-5:end))+48;
    %if check~=cc
        %error('UTM30-LX-EW returned an wrong  check code. Probable communications problem.');
    %end
    %lf=scan( (i-1)*66+66)
end
data=[data; scan( (noBlocks-1)*66+1:end-3)];

if size(data,1)/3~=noPoints
    error('HOKUYO UTM30-LX-EW: There was an error reading the scan, the no. of bytes must be a multiple of 3');
end

data=utmDecode(data);
%% Decode data to distance readings

%  for i=1:noPoints
% %     i
%      data_out(i)=utmDecode(data(1+(i-1)*3), data(2+ (i-1)*3), data(3 + (i-1)*3));
%      %c=c-48;
%      %data(i)=utmDecode
%      %c=c-48;
%  end