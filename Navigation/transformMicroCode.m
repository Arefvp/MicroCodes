function [xTarget, yTarget, ScaleFactorForx1x2] = transformMicroCode(x1, y1, x2, y2, u1, v1, u2, v2, uTarget, vTarget)
% TRANSFORMMICROCODE Transforms microCode coordinates from UV to XY space
%
% This function performs coordinate transformation between two microCode
% reference frames using rotation and scaling.
%
% INPUTS:
%   x1, y1     - XY position of first microCode reference point
%   x2, y2     - XY position of second microCode reference point
%   u1, v1     - UV position of first microCode reference point
%   u2, v2     - UV position of second microCode reference point
%   uTarget, vTarget - Target UV coordinates to transform
%
% OUTPUTS:
%   xTarget, yTarget - Transformed XY coordinates
%   ScaleFactorForx1x2 - Scale factor relative to reference value 0.505
    
    % design constant:
    designConstant = 0.505;

    % Calculate angle from first reference point to target in UV space
    ang1 = atan2((vTarget - v1), (uTarget - u1));
    
    % Calculate angle between reference points in UV space
    ang2 = atan2((v2 - v1), (u2 - u1));
    
    % Calculate rotation angle (theta)
    theta = mod(ang1, 2*pi) - mod(ang2, 2*pi);
    
    % Calculate angle between reference points in XY space
    ang3 = atan2((y2 - y1), (x2 - x1));
    
    % Total rotation angle (alpha)
    alpha = theta + mod(ang3, 2*pi);
    
    % Calculate distances for scaling
    uv_target_distance = sqrt((uTarget - u1)^2 + (vTarget - v1)^2);
    xy_reference_distance = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    uv_reference_distance = sqrt((u2 - u1)^2 + (v2 - v1)^2);
    
    % Calculate transformed distance with scaling
    Rtxy = uv_target_distance * (xy_reference_distance / uv_reference_distance);
    
    % Transform to XY coordinates
    xTarget = Rtxy * cos(alpha) + x1;
    yTarget = Rtxy * sin(alpha) + y1;
    
    % Calculate scale factors
    a = xy_reference_distance / uv_reference_distance;
    b = sqrt((xTarget - x1)^2 + (yTarget - y1)^2) / uv_target_distance;
    
    % Scale factor relative to reference value
    ScaleFactorForx1x2 = a / designConstant;
    
end