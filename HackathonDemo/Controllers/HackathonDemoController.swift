//
//  HackathonDemoController.swift
//  HackathonDemo
//
//  Created by Daniel Vershinin on 14/02/2019.
//  Copyright © 2019 Polarr, Inc. All rights reserved.
//

import UIKit
import PolarrFoundation
import PolarrPhotoRendering

class HackathonDemoController: StillImageViewController {
    
    ///Create a new runner instance of your custom model definition
//    let emotionRunner = NeuralModelRunner(EmotionModelDefinition.self)
    
    ///View to display emotion of the image
//    var assessmentEmotionView : UILabel = {
//        let view = UILabel()
//        view.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
//        view.textColor = UIColor.yellow
//        view.textAlignment = .right
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup example UI views to display the output of your demo if there is text and such accompanying a resulting asset
//        self.view.addSubview(assessmentEmotionView)
//        assessmentEmotionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50.0).isActive = true
//        assessmentEmotionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
    }
    
    override func processTexture(_ texture: MTLTexture, completion: @escaping (MTLTexture) -> Void) {
        
        //Run all your models here to serve the true nature of your demo
//        emotionRunner.runInBackground(on: texture, parameters: [:]) { emotion in
//            DispatchQueue.main.async {
//                self.assessmentEmotionView.text = emotion ?? "Not detected"
//            }
//        }
        
    
        completion(texture)
        //Put your code here
    }
}

