%% ---------------------
% Prof. Dr. Thomas Abmayr
% Fakultät für Geoinformation
% Hochschule München
%% ---------------------

function [ roll,pitch,yaw,tx,ty,tz, err_x, err_y, err_z  ] = Reg_3D_3D_init( p, q )

% ########################
% calc mean
% ########################
sz = size(q);
sum_Xq = 0;
sum_Yq = 0;
sum_Zq = 0;
sum_Xp = 0;
sum_Yp = 0;
sum_Zp = 0;
N=0;

for i=1:sz(1)
    if q(i,1)*p(i,1) + q(i,2)*p(i,2) + q(i,3)*p(i,3)  ~= 0
        sum_Xq = sum_Xq + q(i,1);
        sum_Yq = sum_Yq + q(i,2);
        sum_Zq = sum_Zq + q(i,3);
        
        sum_Xp = sum_Xp + p(i,1);
        sum_Yp = sum_Yp + p(i,2);
        sum_Zp = sum_Zp + p(i,3);
        
        N = N+1;
        
    end
    
    if q(i,1)*p(i,1) + q(i,2)*p(i,2) + q(i,3)*p(i,3)  == 0
        a=5;
    end;
    
end

mean_Xp = sum_Xp / N;
mean_Yp = sum_Yp / N;
mean_Zp = sum_Zp / N;

mean_Xq = sum_Xq / N;
mean_Yq = sum_Yq / N;
mean_Zq = sum_Zq / N;

% ########################
% set LSQ System
% ########################
K = 1;
for i=1 : sz(1)
    if q(i,1)*p(i,1) + q(i,2)*p(i,2) + q(i,3)*p(i,3)  ~= 0
        A(K,1) = p(i,1) - mean_Xp;
        A(K,2) = p(i,2) - mean_Yp;
        A(K,3) = p(i,3) - mean_Zp;
        A(K,4) = 0;
        A(K,5) = 0;
        A(K,6) = 0;
        A(K,7) = 0;
        A(K,8) = 0;
        A(K,9) = 0;
        b(K,1) = q(i,1) - mean_Xq;
        
        K = K+1;
        
        A(K,1) = 0;
        A(K,2) = 0;
        A(K,3) = 0;
        A(K,4) = p(i,1) - mean_Xp;
        A(K,5) = p(i,2) - mean_Yp;
        A(K,6) = p(i,3) - mean_Zp;;
        A(K,7) = 0;
        A(K,8) = 0;
        A(K,9) = 0;
        b(K,1) = q(i,2) - mean_Yq;;
        
        K = K+1;
        
        A(K,1) = 0;
        A(K,2) = 0;
        A(K,3) = 0;
        A(K,4) = 0;
        A(K,5) = 0;
        A(K,6) = 0;
        A(K,7) = p(i,1) - mean_Xp;;
        A(K,8) = p(i,2) - mean_Yp;;
        A(K,9) = p(i,3) - mean_Zp;;
        b(K,1) = q(i,3) - mean_Zq;;
        
        K = K+1;
        
    end;
end;

% ########################
% solve LSQ System
% ########################

x = A\b;

for i=1 : sz(1)
    qx = q(i,1)-mean_Xq;
    qy = q(i,2)-mean_Yq;
    qz = q(i,3)-mean_Zq;
    
    px = p(i,1)-mean_Xp;
    py = p(i,2)-mean_Yp;
    pz = p(i,3)-mean_Zp;
    
    err_x = qx - (x(1)*px + x(2)*py + x(3)*pz);
    err_y = qy - (x(4)*px + x(5)*py + x(6)*pz);
    err_z = qz - (x(7)*px + x(8)*py + x(9)*pz);
end;


% ########################
% erzwinge Drehung
% ########################

% Create a matrix from a vector.
R_tmp = [ x(1) x(2) x(3); x(4) x(5) x(6); x(7) x(8) x(9)];

% Create the SVD of the rotation matrix.
[U D_real V] = svd(R_tmp);
V = transpose(V);

% Set D to the identy matrix
D_ideal = eye(3,3);
D_ideal(3,3) = det (U * V);
R = U * D_ideal * V;

% ########################
% calc Trans
% ########################

T = [mean_Xq, mean_Yq, mean_Zq]' - R * [mean_Xp, mean_Yp, mean_Zp]';

[roll,pitch,yaw] = getRPY(R);
tx=T(1,1);
ty=T(2,1);
tz=T(3,1);


% ########################
% Test
% ########################
N=1;
for i=1 : sz(1)
    err_x(i) = q(i,1) - (R(1,1)*p(i,1) + R(1,2)*p(i,2) + R(1,3)*p(i,3) + T(1,1));
    err_y(i) = q(i,2) - (R(2,1)*p(i,1) + R(2,2)*p(i,2) + R(2,3)*p(i,3) + T(2,1));
    err_z(i) = q(i,3) - (R(3,1)*p(i,1) + R(3,2)*p(i,2) + R(3,3)*p(i,3) + T(3,1));
end;