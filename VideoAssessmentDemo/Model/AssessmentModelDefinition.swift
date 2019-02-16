//
//  AssessmentModelDefinition.swift
//  VideoAssessmentDemo
//
//  Created by Daniel Vershinin on 13/02/2019.
//  Copyright © 2019 Polarr, Inc. All rights reserved.
//

import Foundation
import CoreML
import MetalPerformanceShaders
import PolarrFoundation

//Sample model definition for an open-source model for photo assessment
//https://github.com/yulingtianxia/PhotoAssessment/blob/master/PhotoAssessment-Sample/Sources/PhotoMLProcessor.swift
public class AssessmentModelDefinition : NeuralModelDefinition {
   
    //Output is what will be returned by the model.
    //In our case the model will return the score—a simple double value.
    public typealias Output = Double
    
    //There are no parameters for this model so we can have anything here.
    public typealias Parameters = [String : Any]
    
    //Assessment model path is CoreML path already compiled and bundled.
    public var path: String = AssessmentModel.urlOfModelInThisBundle.path
    
    //Metal pipeline and scaling kernel
    fileprivate let device : MTLDevice
    fileprivate let queue : MTLCommandQueue
    fileprivate let scalingKernel : MPSImageBilinearScale
    
    //Scaled texture descriptor
    fileprivate let scaledTextureDescriptor : MTLTextureDescriptor = {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                               width: 224,
                                                               height: 224,
                                                               mipmapped: false)
        descriptor.usage = [.shaderWrite]
        return descriptor
    }()
    
    //Initialising supplementary preprocessing functions
    required public init() {
        device = MTLCreateSystemDefaultDevice()!
        queue = device.makeCommandQueue()!
        scalingKernel = MPSImageBilinearScale(device: device)
    }
    
    //For preprocessing we scale the input texture and return the texture as a pixel buffer as required per model.
    public func preprocess(name: String, input: MTLTexture, parameters: [String : Any]) -> AnyObject? {
        guard let commandBuffer = queue.makeCommandBuffer() else {
            return nil
        }
        
        //Scaling input texture down
        guard let outputTexture = device.makeTexture(descriptor: scaledTextureDescriptor) else {
            return nil
        }
        
        scalingKernel.encode(commandBuffer: commandBuffer, sourceTexture: input, destinationTexture: outputTexture)
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return makePixelBufferFromTexture(outputTexture)
    }
    
    //Postprocessing calculated the actual value
    public func postprocess(outputs: [String : Any], input: MTLTexture, parameters: [String : Any]) -> Double? {
        //Access the outputs relative to the model you are using
        guard let output = outputs.first?.value as? MLMultiArray else{
            return nil
        }
        
        let count = output.count
        var result = 0.0
        
        for index in 0 ..< count {
            result += output[index].doubleValue * Double(index + 1)
        }
        
        return result
    }
    
    //Creating pixel buffer from a texture data.
    fileprivate func makePixelBufferFromTexture(_ texture : MTLTexture) -> CVPixelBuffer? {
        var sourceBuffer : CVPixelBuffer?
        
        let attrs = NSMutableDictionary()
        attrs[kCVPixelBufferIOSurfacePropertiesKey] = NSMutableDictionary()
        
        CVPixelBufferCreate(kCFAllocatorDefault,
                            texture.width,
                            texture.height,
                            kCVPixelFormatType_32BGRA,
                            attrs as CFDictionary,
                            &sourceBuffer)
        
        guard let buffer = sourceBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let bufferPointer = CVPixelBufferGetBaseAddress(buffer)!
        
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        texture.getBytes(bufferPointer, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), from: region, mipmapLevel: 0)
        
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return buffer
    }
    
}
