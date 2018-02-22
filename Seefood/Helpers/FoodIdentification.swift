//
//  FoodIdentification.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class FoodIdentification: NSObject{
    
    var queue = 0
    var foodsIdentified: (()->())?
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage, index: Int) {
        
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            do {
                let classificationRequest: VNCoreMLRequest = {
                    do {
                        /*
                         Use the Swift class `MobileNet` Core ML generates from the model.
                         To use a different Core ML classifier model, add it to the project
                         and replace `MobileNet` with that model's generated Swift class.
                         */
                        let model = try VNCoreMLModel(for: coreml().model)
                        
                        let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
                            self.processClassifications(for: request, error: error, index: index)
                        })
                        request.imageCropAndScaleOption = .centerCrop
                        return request
                    } catch {
                        fatalError("Failed to load Vision ML model: \(error)")
                    }
                }()
                try handler.perform([classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?, index: Int) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            let result = results[0] as! VNCoreMLFeatureValueObservation
            let items = result.featureValue.multiArrayValue!
            self.queue = self.queue - 1
            
            let foodNames = FoodsKnown().foodLabels
            var identifiedItem = foodNames[0]
            var confidence = items[0].doubleValue
            for i in 0 ..< foodNames.count {
                let currentConfidence = items[i].doubleValue
                if currentConfidence > confidence {
                    confidence = currentConfidence
                    identifiedItem = foodNames[i]
                }
            }
            
            FoodData.currentPictures[index].name = identifiedItem.capitalizingFirstLetter()
            
            if self.queue <= 0 {
                self.foodsIdentified?()
            }
        }
    }
    
}
