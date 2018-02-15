%%  hokyuo utm30-lx-ew

if ~exist('t','var')
    t=utmOpen;
end

start=0;
stop=1080;
skip=0;

res=0.25;        %URG-30LX-EW

angleVector=((res*start:res:stop*res)-135)'.*pi/180;
 
%clear data
nscans=40;



tic
while (true)   
    rangeVector= utmGetScan(t,start,stop);
    plot(rangeVector.*cos(angleVector)/1000,rangeVector.*sin(angleVector)/1000,'.b')
    pause(0.1);
end
toc


%fclose(t)
%delete(t)
%clear t