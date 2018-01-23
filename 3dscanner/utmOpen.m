function t = utmOpen(s)
% Returns a connection to the hokuyo upm30-lx-ew laser
% input s is a string with the ip
% output t is the tcpip object

if nargin==0
    s='192.168.0.10';
end

t = tcpip(s,10940, 'InputBufferSize', 5000);
fopen(t);

fprintf(t,'BM\n'); % measurement state
pause(0.1)
data = fread(t,t.BytesAvailable); 

fprintf(t,'II\n'); % information
pause(0.1)
data = fread(t,t.BytesAvailable);
char(data')

