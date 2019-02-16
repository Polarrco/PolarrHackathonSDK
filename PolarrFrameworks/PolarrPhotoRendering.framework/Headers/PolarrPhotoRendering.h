//
//  Powder.h
//  Powder
//
//  Created by Daniel Vershinin on 15/06/16.
//  Copyright © 2016 Polarr. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Powder.
FOUNDATION_EXPORT double PowderVersionNumber;

//! Project version string for Powder.
FOUNDATION_EXPORT const unsigned char PowderVersionString[];

/* Declaring some types useful for Swift to be passed to Metal */

#include <stdlib.h>
#include <simd/simd.h>

#define constant const
#define float4 vector_float4
#define float3 vector_float3
#define float2 vector_float2
#define uint4  vector_uint4
#define uint3  vector_uint3
#define uint2  vector_uint2

#define float2x2 matrix_float2x2
#define float3x3 matrix_float3x3
#define float4x4 matrix_float4x4

#define float2x3 matrix_float2x3
#define float3x2 matrix_float3x2

#define float3x4 matrix_float3x4
#define float4x3 matrix_float4x3

#define float2x4 matrix_float2x4
#define float4x2 matrix_float4x2

#define constexpr

#include "POSwiftTypes.h"
