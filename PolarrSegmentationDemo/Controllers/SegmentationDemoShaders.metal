//
//  SegmentationDemoShaders.metal
//  PolarrSegmentationDemo
//
//  Created by Daniel Vershinin on 13/02/2019.
//  Copyright © 2019 Polarr, Inc. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void ApplySegmentationMask(
                                    texture2d<half, access::sample> inTexture [[texture(0)]],
                                    texture2d<half, access::write> outTexture [[texture(1)]],
                                    texture2d<uint, access::sample> maskTexture [[texture(2)]],
                                    uint2 gid [[thread_position_in_grid]]) {
    //Sampler to get mask value for the current pixel
    constexpr sampler s(coord::normalized, filter::linear, address::clamp_to_zero);
    
    //Obtaining the normalized coordinates for the current pixel
    float2 size = float2(inTexture.get_width(), inTexture.get_height());
    float2 coords = float2(gid) * float2(1.0 / size.x, 1.0 / size.y);
    
    //Getting the mask value from the mask texture obtained from the CoreML model
    uint maskValue = maskTexture.sample(s, coords).r;
    
    //Source image color
    half4 color = inTexture.read(gid);
    
    if (maskValue == 0) {
        //For this sample let's just replace background with red color.
        color = half4(1.0, 0.0, 0.0, 1.0);
    }
    else {
        
    }
    
    outTexture.write(color, gid);
}
