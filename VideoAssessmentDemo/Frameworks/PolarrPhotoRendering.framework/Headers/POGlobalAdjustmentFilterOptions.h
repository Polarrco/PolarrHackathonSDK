//
//  POGlobalAdjustmentFilterOptions.h
//  Powder
//
//  Created by Daniel Vershinin on 16/01/2019.
//  Copyright © 2019 Polarr. All rights reserved.
//

#ifndef POGlobalAdjustmentTypes_h
#define POGlobalAdjustmentTypes_h

/* Global adjustment definition */

#define ADJUSTMENTS_MAX_COUNT 50

typedef struct {
    float fillHue;
    float fillSaturation;
    float fillBrightness;
    float fillAlpha;
    
    float sharpen;
    float sharpenZoom;
    
    float denoiseColor;
    float denoiseLuminance;
    
    float diffuse;
    
    float clarity;
    float clarityZoom;
    
    float dehaze;
    
    float blacks;
    float whites;
    
    float shadows;
    float highlights;
    
    float exposure;
    float gamma;
    
    float temperature;
    float tint;
    
    float contrast;
    
    uint8_t hasCurves;
    uint8_t hasHsl;
    
    float splittoneHighlightsHue;
    float splittoneHighlightsSaturation;
    float splittoneShadowsHue;
    float splittoneShadowsSaturation;
    float splittoneBalance;
    
    float saturation;
    float vibrance;
    
    float grainScale;
    float grainAmount;
    float grainSize;
    
    float vignetteAmount;
    float vignetteSpread;
    float vignetteHighlights;
    float vignetteExposure;
    float vignetteRoundness;
    float vignetteSize;
    
    float mix;
    
    int version;
} POGlobalAdjustmentFilterOptions;

#endif /* POGlobalAdjustmentFilterOptions */
