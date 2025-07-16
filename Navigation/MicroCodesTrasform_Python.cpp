#include <cmath>
#include <iostream>
#include <tuple>

using namespace std;

/**
 * @brief Transform microCode coordinates from UV to XY space
 * 
 * This function performs coordinate transformation between two microCode
 * reference frames using rotation and scaling.
 * 
 * @param x1 X position of first microCode reference point
 * @param y1 Y position of first microCode reference point
 * @param x2 X position of second microCode reference point
 * @param y2 Y position of second microCode reference point
 * @param u1 U position of first microCode reference point
 * @param v1 V position of first microCode reference point
 * @param u2 U position of second microCode reference point
 * @param v2 V position of second microCode reference point
 * @param uTarget Target U coordinate to transform
 * @param vTarget Target V coordinate to transform
 * @return tuple<double, double, double> containing xTarget, yTarget, and scaleFactor
 */
tuple<double, double, double> transformMicroCode(
    double x1, double y1, double x2, double y2,
    double u1, double v1, double u2, double v2,
    double uTarget, double vTarget) {
    
    // Design constant
    const double designConstant = 0.505;
    
    // Calculate angle from first reference point to target in UV space
    double ang1 = atan2((vTarget - v1), (uTarget - u1));
    
    // Calculate angle between reference points in UV space
    double ang2 = atan2((v2 - v1), (u2 - u1));
    
    // Calculate rotation angle (theta)
    double theta = fmod(ang1, 2 * M_PI) - fmod(ang2, 2 * M_PI);
    
    // Calculate angle between reference points in XY space
    double ang3 = atan2((y2 - y1), (x2 - x1));
    
    // Total rotation angle (alpha)
    double alpha = theta + fmod(ang3, 2 * M_PI);
    
    // Calculate distances for scaling
    double uvTargetDistance = sqrt(pow(uTarget - u1, 2) + pow(vTarget - v1, 2));
    double xyReferenceDistance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
    double uvReferenceDistance = sqrt(pow(u2 - u1, 2) + pow(v2 - v1, 2));
    
    // Calculate transformed distance with scaling
    double rtxy = uvTargetDistance * (xyReferenceDistance / uvReferenceDistance);
    
    // Transform to XY coordinates
    double xTarget = rtxy * cos(alpha) + x1;
    double yTarget = rtxy * sin(alpha) + y1;
    
    // Calculate scale factors
    double a = xyReferenceDistance / uvReferenceDistance;
    double b = sqrt(pow(xTarget - x1, 2) + pow(yTarget - y1, 2)) / uvTargetDistance;
    
    // Scale factor relative to reference value
    double scaleFactor = a / designConstant;
    
    return make_tuple(xTarget, yTarget, scaleFactor);
}
