import math
from typing import Tuple


def transform_microcode(x1: float, y1: float, x2: float, y2: float, 
                       u1: float, v1: float, u2: float, v2: float,
                       u_target: float, v_target: float) -> Tuple[float, float, float]:
    """
    Transform microCode coordinates from UV to XY space.
    
    This function performs coordinate transformation between two microCode
    reference frames using rotation and scaling.
    
    Args:
        x1, y1: XY position of first microCode reference point
        x2, y2: XY position of second microCode reference point
        u1, v1: UV position of first microCode reference point
        u2, v2: UV position of second microCode reference point
        u_target, v_target: Target UV coordinates to transform
        
    Returns:
        Tuple containing:
        - x_target: Transformed X coordinate
        - y_target: Transformed Y coordinate
        - scale_factor: Scale factor relative to reference value 0.505
    """
    
    # Design constant
    design_constant = 0.505
    
    # Calculate angle from first reference point to target in UV space
    ang1 = math.atan2((v_target - v1), (u_target - u1))
    
    # Calculate angle between reference points in UV space
    ang2 = math.atan2((v2 - v1), (u2 - u1))
    
    # Calculate rotation angle (theta)
    theta = (ang1 % (2 * math.pi)) - (ang2 % (2 * math.pi))
    
    # Calculate angle between reference points in XY space
    ang3 = math.atan2((y2 - y1), (x2 - x1))
    
    # Total rotation angle (alpha)
    alpha = theta + (ang3 % (2 * math.pi))
    
    # Calculate distances for scaling
    uv_target_distance = math.sqrt((u_target - u1)**2 + (v_target - v1)**2)
    xy_reference_distance = math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    uv_reference_distance = math.sqrt((u2 - u1)**2 + (v2 - v1)**2)
    
    # Calculate transformed distance with scaling
    rtxy = uv_target_distance * (xy_reference_distance / uv_reference_distance)
    
    # Transform to XY coordinates
    x_target = rtxy * math.cos(alpha) + x1
    y_target = rtxy * math.sin(alpha) + y1
    
    # Calculate scale factors
    a = xy_reference_distance / uv_reference_distance
    b = math.sqrt((x_target - x1)**2 + (y_target - y1)**2) / uv_target_distance
    
    # Scale factor relative to reference value
    scale_factor = a / design_constant
    
    return x_target, y_target, scale_factor
