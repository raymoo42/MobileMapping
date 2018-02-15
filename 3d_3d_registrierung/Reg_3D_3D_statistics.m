%% ---------------------
% Prof. Dr. Thomas Abmayr
% Fakultät für Geoinformation
% Hochschule München
%% ---------------------

function [err] = Reg_3D_3D_statistics( x, P )

sz = size(P);
N = sz(1);
K = sz(2);

  % Homogene Matrizen berechnen
  M(1,:,:) = [1 0 0 0 ; 0 1 0 0; 0 0 1 0; 0 0 0 1];  % Master 
  for i=2:N % andere VP
      k = (i - 2) * 6;
      M(i,:,:) = [1 0 0 0 ; 0 1 0 0; 0 0 1 0; 0 0 0 1];    
      R = setRPY(x(k+1), x(k+2), x(k+3));
      M(i,1,:) = [R(1,:), x(k+4)];
      M(i,2,:) = [R(2,:), x(k+5)];
      M(i,3,:) = [R(3,:), x(k+6)];    
  end

  err = [];
  cnt = 1;
  % jeder VP mit jedem VP
  for i=1:N-1
      for j=i+1:N
        % Iteration über die K korr. Punkte
        for k = 1:K
            % Punkte (x,y,z,1) auslesen
            p(1,1) = P(i, k, 1);
            p(1,2) = P(i, k, 2);
            p(1,3) = P(i, k, 3);
            p(1,4) = 1;
            
            q(1,1) = P(j, k, 1);
            q(1,2) = P(j, k, 2);
            q(1,3) = P(j, k, 3);
            q(1,4) = 1;

            % if no pair of points ..
            if( p(1,1) == 0 || q(1,1) == 0 )
                continue;
            end

            % Transformation von VP i in VP j
            for t=1:4
                for s=1:4
                    Mi(t,s) = M(i,t,s);
                    Mj(t,s) = M(j,t,s);
                end
            end
            
            p_trans = inv(Mj) * Mi * p';
            
            % Fehler zwischen dem Punkt des Masterviewpoints und dem
            % transformierten Punkt
            err(j, k, 1) = q(1,1) - p_trans(1,1);
            cnt = cnt + 1;
            
            err(j, k, 2) = q(1,2) - p_trans(2,1);
            cnt = cnt + 1;
            
            err(j, k, 3) = q(1,3) - p_trans(3,1);
            cnt = cnt + 1;
            
        end
      end;
  end
  
  
end

