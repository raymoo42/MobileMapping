%% ---------------------
% Prof. Dr. Thomas Abmayr
% Fakultät für Geoinformation
% Hochschule München
%% ---------------------

function [ roll, pitch, yaw ] = getRPY( R )

    yaw = atan2 (R(2,1), R(1,1));

    cg = cos(yaw);
    sg = sin(yaw);

    pitch = atan2 (-R(3,1), R(1,1) * cg + R(2,1) * sg);
    roll = atan2 ( R(1,3) * sg - R(2,3) * cg, R(2,2) * cg - R(1,2) * sg);
    
 end