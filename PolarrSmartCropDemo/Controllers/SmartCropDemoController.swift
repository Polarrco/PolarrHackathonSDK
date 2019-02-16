//
//  DemoController.swift
//  PolarrHackathonDemo
//
//  Created by Daniel Vershinin on 12/02/2019.
//  Copyright © 2019 Polarr, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import PolarrFoundation
import PolarrPhotoRendering

///Provides a fullscreen video feed view
class SmartCropDemoController: CameraViewController {

    ///Smart crop runner used to obtain smart crop models.
    let smartCropRunner = NeuralModelRunner(SmartCropModelDefinition.self)
    
    ///Rendering frames using Polarr Photo Rendering engine requires the renderer to be instantiated.
    let frameRenderer = POVideoProcessingUnit()
    
    ///Last cropping rect
    var cropRect : CGRect = .zero {
        
        didSet {
            guard cropRect != .zero else {
                return
            }
            
            DispatchQueue.main.async {
                self.smartCropBoundariesView.frame = CGRect(x: self.contentRect.origin.x + self.cropRect.origin.x * self.contentRect.width,
                                                             y: self.contentRect.origin.y + self.cropRect.origin.y * self.contentRect.height,
                                                             width: self.cropRect.width * self.contentRect.width,
                                                             height: self.cropRect.height * self.contentRect.height)
            }
        }
        
    }
    
    ///View to display smart crop boundaries
    var smartCropBoundariesView : UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 3.0
        view.layer.masksToBounds = true
        view.layer.backgroundColor = UIColor.clear.cgColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(smartCropBoundariesView)
    }
    
    ///Filters the texture and returns another one to display inside the Polarr camera view.
    override func processTexture(_ texture: MTLTexture, completion: @escaping (MTLTexture) -> Void) {
        
        /* First part is trying to get the smart crop rectangle for the current video frame */
        
        //Smart crop parameters (in this example aspect ratio is 0, which means smart cropping.
        //We also specify optional size for the smart cropping which will be used to calculate boundaries to crop
        var smartCropParameters = SmartCropParameters()
        smartCropParameters.aspectRatio = 0.0
        smartCropParameters.size = self.contentRect.size
        
        //Running Polarr segmentation model in background and discarding late results since model speed is not real-time.
        smartCropRunner.runInBackground(on: texture, parameters: smartCropParameters) { [weak self] cropRect in
            guard let rect = cropRect else {
                return
            }
            
            self?.cropRect = rect
        }
        
        /* Second part is rendering the destination image. This runs
         independently of the first part and thus we do two kind of calculations in parallel. */
        
        //Creating adjustments to make our whole image desaturated and only the cropping region satured.
        frameRenderer.renderingPassDescriptor = PORenderingDescriptor(adjustmentDescriptors: [
            
            //Whole image adjustments (desaturated everything)
            POAdjustmentsDescriptor(adjustments: ["saturation" : -1.0]),
            
            //Cropped region adjustments (saturated rectangle)
            POAdjustmentsDescriptor(adjustments: ["saturation" : 1.0], region: PORectangleRegion(rect: cropRect))
        ])
        
        //Rendering everything
        let sourceRepresentation = POImageRepresentation(texture: texture)
        
        if let resultingRepresentation = try? frameRenderer.process(sourceRepresentation) {
            completion(resultingRepresentation.texture)
        }
        else {
            completion(texture)
        }
        
        
        
    }
    
}

