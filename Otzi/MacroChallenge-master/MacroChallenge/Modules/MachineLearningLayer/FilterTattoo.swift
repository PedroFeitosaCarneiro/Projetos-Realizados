//
//  FilterTattooLayer.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 09/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import CoreML
import UIKit
import Vision
class FilterTattoo{
    
    private enum Classes: String{
        case Tattoo = "Tattoo"
        case Other = "Other"
    }
    
    static let shared = FilterTattoo()
    var isTattooClassifierModel:  IsTattooClassifier!
    
    
    private let minimunConfidence: Double = 50
   private init() {
        setupModel()
    }
    
     func setupModel(){
        let configuration = MLModelConfiguration()
        
        isTattooClassifierModel = try? IsTattooClassifier(configuration: configuration)
    }
    
    
    func isTattoo(image: UIImage)-> Bool{
        
        
//        guard let buffer = image.createBuffer() else {
//            debugPrint("Falhouu Por erro na hora de criar  CVPixelBuffer")
//            return false
//        }
        guard let buffer = image.cgImage,let i = try? IsTattooClassifierInput(imageWith: buffer) else {
            debugPrint("Falhouu Por erro na hora de criar  CVPixelBuffer")
            return false
        }
        
        guard let output = try? isTattooClassifierModel.prediction(input: i) else {return false}
        
        
        
        let results = output.classLabelProbs.sorted{$0.1 > $1.1}
        
        guard let result = results.first else {return false}
        
        
        let tattoo = Classes.Tattoo.rawValue

        if result.key.elementsEqual(tattoo){
            return true
        }
        return false
        
      
        
    }
    
}

//
//func myResultsMethod(request: VNRequest, error: Error?) {
//    guard let results = request.results as? [VNClassificationObservation]
//        else { fatalError("huh") }
//    for classification in results {
//        print(classification.identifier, // the scene label
//              classification.confidence)
//    }
//
//}
//let model = try! VNCoreMLModel(for: isTattooClassifierModel.model)
//let request = VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
//let handler = VNImageRequestHandler(url: myImageURL)
//handler.perform([request])


extension UIImage{
    func createBuffer() -> CVPixelBuffer? {
            
            let width = self.size.width
            let height = self.size.height
            let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                         kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
            var pixelBuffer: CVPixelBuffer?
            let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                             Int(width),
                                             Int(height),
                                             kCVPixelFormatType_32ARGB,
                                             attrs,
                                             &pixelBuffer)

            guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
                return nil
            }

            CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
       
            guard let context = CGContext(data: pixelData,
                                          width: Int(width),
                                          height: Int(height),
                                          bitsPerComponent: 8,
                                          bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                          space: rgbColorSpace,
                                          bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                            return nil
            }

            context.translateBy(x: 0, y: height)
            context.scaleBy(x: 1.0, y: -1.0)

            UIGraphicsPushContext(context)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

            return resultPixelBuffer

        }
}
