//
//  Metal-Face.h
//  Powder
//
//  Created by Daniel Vershinin on 03/08/2018.
//  Copyright © 2018 Polarr. All rights reserved.
//

#ifndef Metal_Face_h
#define Metal_Face_h

#ifdef __METAL_VERSION__

#include <metal_stdlib>
#include <simd/simd.h>
#include "POCommon.h"

#ifdef __cplusplus

namespace Powder
{
 
    /* Supplementary functions */
    
    inline float dist(float2 p, float2 v) {
        return sqrt((p.x - v.x) * (p.x - v.x) + (p.y - v.y) * (p.y - v.y));
    }
    
    // distance between point p to the line connecting points v and w.
    inline float distanceToLine(float2 p, float2 v, float2 w) {
        float len = dist(v, w);
        if(len == 0) return dist(p, v);
        
        float t = ((p[0] - v[0]) * (w[0] - v[0]) + (p[1] - v[1]) * (w[1] - v[1])) / (len * len);
        t = max(0.0, min(1.0, t));
        
        return dist(p, float2(v[0] + t * (w[0] - v[0]), v[1] + t * (w[1] - v[1])) );
    }
    
    // whether a point is inside a closed path
    inline bool intersectsPath(float2 coords, float2 points[], int count) {
        float2 pJ = points[count - 1]; // normalized coordinates
        bool contains = false;
        for (int i = 0; i < count; i++) {
            float2 pI = points[i];
            if ( ((pI.y >= coords.y) != (pJ.y >= coords.y)) &&
                (coords.x <= (pJ.x - pI.x) * (coords.y - pI.y) / (pJ.y - pI.y) + pI.x) ){
                contains = !contains;
            }
            pJ=pI;
        }
        return contains;
    }
    
    // closest distance between a point and a path (collection of line segments)
    inline float distanceToPath(float2 point, float2 points[], float4 edges, int count) {
        if(point.x > edges[0] && point.y > edges[1] && point.x < edges[2] && point.y < edges[3] ) {
            if (intersectsPath(point, points, count)) return 0;
        }
        
        float dist = 1;
        // find closest line segment
        for (int i = 0, j = count - 1; i < count; j = i++) {
            dist = min(dist, distanceToLine(point, points[i], points[j]));
        }
        
        return dist;
    }
    
}

#endif

#endif
#endif /* Metal_Face_h */
