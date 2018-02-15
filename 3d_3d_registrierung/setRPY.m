%% -------------------------------
% Prof. Dr. Thomas Abmayr
% Fakultät für Geoinformation
% Hochschule München
%% -----------------------------

function R = setRPY( roll, pitch, yaw )

ca = cos(roll);
sa = sin(roll);
cb = cos(pitch);
sb = sin(pitch);
cg = cos(yaw);
sg = sin(yaw);


    R(1, 1) = cb * cg;
    R(1, 2) = cg * sa * sb - ca * sg;
    R(1, 3) = sa * sg + ca * cg * sb;
    R(2,1) = cb * sg;
    R(2,2) = sa * sb * sg + ca * cg;
    R(2,3) = ca * sb * sg - cg * sa;
    R(3,1) = -sb;
    R(3,2) = cb * sa;
    R(3,3) = ca * cb;

 end