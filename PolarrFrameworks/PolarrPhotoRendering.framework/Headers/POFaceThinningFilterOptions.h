//
//  FaceThinningTypes.h
//  Powder
//
//  Created by Daniel Vershinin on 16/01/2019.
//  Copyright © 2019 Polarr. All rights reserved.
//

#ifndef FaceThinningTypes_h
#define FaceThinningTypes_h

#define FACE_CONTOUR_POINTS_COUNT 11
#define FOREHEAD_POINTS_COUNT 5 // set it to 5 to include forehead points in thinning
#define EYE_POINTS_COUNT 8
#define FACES_MAX 5

/* Face thinning adjustment */

typedef struct {
    float4 boundaries;
    float2 faceContour[FACE_CONTOUR_POINTS_COUNT + FOREHEAD_POINTS_COUNT];
    //float2 thinnedFaceContour[FACE_CONTOUR_POINTS_COUNT + FOREHEAD_POINTS_COUNT];
    float4 faceEdges; // [xmin, ymin, xmax, ymax] on contour
    float2 faceCenter;
    float4 eyeCenters;
    float2 rotation; // [cos, sin]
    float2 leftEye[EYE_POINTS_COUNT];
    float2 rightEye[EYE_POINTS_COUNT];
} POFace;

typedef struct {
    uint count;
    POFace faces[FACES_MAX];
} POFaces;

#endif /* FaceThinningTypes_h */
