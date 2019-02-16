//
//  EmotionModelDefinition.swift
//  HackathonDemo
//
//  Created by Ritesh Pakala on 2/14/19.
//  Copyright © 2019 Polarr, Inc. All rights reserved.
//

import Foundation
import PolarrFoundation
import CoreML
import MetalPerformanceShaders

class EmotionModelDefinition : NeuralModelDefinition {
    /*
        https://github.com/likedan/Awesome-CoreML-Models
     
        You can download the example model used in this demo above "EmotionNet"
    */
    var path: String = ""//CNNEmotions.urlOfModelInThisBundle.path
//
    typealias Output = String

    typealias Parameters = [String : Any]
    
//    fileprivate let device : MTLDevice
//    fileprivate let queue : MTLCommandQueue
//    fileprivate let scalingKernel : MPSImageBilinearScale

    //Scaled texture descriptor
//    fileprivate let scaledTextureDescriptor : MTLTextureDescriptor = {
//        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
//                                                                  width: 224,
//                                                                  height: 224,
//                                                                  mipmapped: false)
//        descriptor.usage = [.shaderWrite]
//        return descriptor
//    }()
    
    //Initialising supplementary preprocessing functions
    required public init() {
//        device = MTLCreateSystemDefaultDevice()!
//        queue = device.makeCommandQueue()!
//        scalingKernel = MPSImageBilinearScale(device: device)
    }
    
    func preprocess(name: String, input: MTLTexture, parameters: [String : Any]) -> AnyObject? {
//        guard let commandBuffer = queue.makeCommandBuffer() else {
//            return nil
//        }
//
//        guard let outputTexture = device.makeTexture(descriptor: scaledTextureDescriptor) else {
//            return nil
//        }
//
//        scalingKernel.encode(commandBuffer: commandBuffer, sourceTexture: input, destinationTexture: outputTexture)
//
//        commandBuffer.commit()
//        commandBuffer.waitUntilCompleted()
//
//        return makePixelBufferFromTexture(outputTexture)
        
        return nil
    }
    
    func postprocess(outputs: [String : Any], input: MTLTexture, parameters: [String : Any]) -> String? {
//        guard let label = outputs["classLabel"] as? String else{
//            return nil
//        }
//
//        return label
        
        return nil
    }
    
    //Creating pixel buffer from a texture data.
//    fileprivate func makePixelBufferFromTexture(_ texture : MTLTexture) -> CVPixelBuffer? {
//        var sourceBuffer : CVPixelBuffer?
//
//        let attrs = NSMutableDictionary()
//        attrs[kCVPixelBufferIOSurfacePropertiesKey] = NSMutableDictionary()
//
//        CVPixelBufferCreate(kCFAllocatorDefault,
//                            texture.width,
//                            texture.height,
//                            kCVPixelFormatType_32BGRA,
//                            attrs as CFDictionary,
//                            &sourceBuffer)
//
//        guard let buffer = sourceBuffer else {
//            return nil
//        }
//
//        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
//
//        let bufferPointer = CVPixelBufferGetBaseAddress(buffer)!
//
//        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
//        texture.getBytes(bufferPointer, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), from: region, mipmapLevel: 0)
//
//        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
//
//        return buffer
//    }
}

