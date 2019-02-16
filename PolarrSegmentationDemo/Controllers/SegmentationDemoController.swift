//
//  SegmentationDemoController.swift
//  PolarrSegmentationDemo
//
//  Created by Daniel Vershinin on 13/02/2019.
//  Copyright © 2019 Polarr, Inc. All rights reserved.
//

import UIKit
import Metal
import PolarrFoundation

///Demonstrated processing a single image using Polarr Segmentation neural model definition
class SegmentationDemoController: StillImageViewController {

    //Runner is responsible for processing input textures and returning the appropriate result.
    //All available labels can be found in `SegmentationModelDefinition.Labels`
    let segmentationRunner = NeuralModelRunner(SegmentationModelDefinition.self)
    
    //Setting up our metal device to apply result to texture.
    fileprivate lazy var device : MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Cannot get the device.")
        }
        
        return device
    }()
    
    //Setting up our metal queue to get command buffers.
    fileprivate lazy var commandQueue : MTLCommandQueue = {
        guard let queue = device.makeCommandQueue() else {
            fatalError("Cannot get the command queue.")
        }
        
        return queue
    }()
    
    //Library to get our Metal computation functions
    fileprivate lazy var library : MTLLibrary = {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Cannot get the library.")
        }
        
        return library
    }()
    
    fileprivate lazy var pipelineState : MTLComputePipelineState = {
        guard let function = library.makeFunction(name: "ApplySegmentationMask") else {
            fatalError("Cannot get the function.")
        }
        
        guard let state = try? device.makeComputePipelineState(function: function) else {
            fatalError("Cannot make the pipeline state.")
        }
        
        return state
    }()
    
    //When the image is selected in the UI, this method is called.
    override func processTexture(_ texture: MTLTexture, completion: @escaping (MTLTexture) -> Void) {
        
        //We run the segmentation runner and see if there is mask returned.
        //If mask exists, we process it using metal to draw a simple overlay on top of the image.
        guard let mask = segmentationRunner.run(on: texture, parameters: [:]) else {
            //No mask exists, just returning the result.
            completion(texture)
            return
        }
    
        //We need a command buffer to schedule commands on GPU
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            completion(texture)
            return
        }
        
        //We create texture from mask data returned by segmentation
        let maskTexture = makeMaskTexture(mask: mask)
        
        //And our output texture is the same as the input texture.
        let outputTexture = device.makeTextureSimilarTo(texture)
        
        //We encode our work using the pipelineState of our `ApplySegmentationMask` from `SegmentationDemoShaders.metal`.
        let encoder = commandBuffer.makeComputeCommandEncoder()
        encoder?.setComputePipelineState(pipelineState)
        encoder?.setTexture(texture, index: 0)
        encoder?.setTexture(outputTexture, index: 1)
        encoder?.setTexture(maskTexture, index: 2)
        encoder?.dispatch(pipeline: pipelineState, width: texture.width, height: texture.height)
        encoder?.endEncoding()
       
        //Committing the buffer and waiting until it's completed to return the output texture to display in the UI.
        //Please note that this is done only for demo purposes, for production applications please do this asynchronously.
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        //Returning the texture back to display in the UI.
        completion(outputTexture)
    }
    
    //Making mask texture out of the segmentation model output.
    //Mask texture is a simple one-component 2d texture with values from 0 to 17.
    //All available labels can be found in `SegmentationModelDefinition.Labels`
    fileprivate func makeMaskTexture(mask : SegmentationModelOutput) -> MTLTexture? {
        let maskTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r8Uint,
                                                                             width: mask.width,
                                                                             height: mask.height, mipmapped: false)
        
        let maskTextureRegion = MTLRegion(origin: MTLOrigin(x: 0, y: 0, z: 0), size: MTLSize(width: mask.width, height: mask.height, depth: 1))
        
        let maskTexture = device.makeTexture(descriptor: maskTextureDescriptor)
        
        maskTexture?.replace(region: maskTextureRegion, mipmapLevel: 0, withBytes: mask.data, bytesPerRow: mask.width)
        
        return maskTexture
    }
    
}

