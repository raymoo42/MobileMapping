classdef Scan
    %SCAN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        timestamp = 0;
    end
    
    properties
        ptCloud = pcread('teapot.ply');
    end
    
    methods
        function obj = Scan(t, ptc)
            timestamp = t;
            ptCloud = ptc;
        end
    end
    
end

