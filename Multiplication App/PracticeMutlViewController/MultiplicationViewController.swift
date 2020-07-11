//
//  ViewController.swift
//  Multiplication App
//
//  Created by antonio  on 7/4/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit
import VisionKit
import Vision

class MultiplicationViewController: UIViewController {
    
    
    var textRecognitionRequest = VNRecognizeTextRequest()
    var reconginzedText = ""
    
    //    var drawingToTextImage: UIImage!
    var SampleImage = UIImage.init(named: "maxresdefault")!
    
    
    @IBOutlet weak var CanvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self.reconginzedText = ""
                    for observation in requestResults {
                        guard let candidate = observation.topCandidates(1).first else { return }
                        self.reconginzedText += candidate.string
                        self.reconginzedText += "\n"
                    }
                    print(self.reconginzedText)
                    print("here")
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .fast
        textRecognitionRequest.usesLanguageCorrection = true
//        textRecognitionRequest.
//        textRecognitionRequest.
//        textRecognitionRequest.minimumTextHeight = 80
        textRecognitionRequest.customWords = ["1","2","3","4","5","6","7","8","9","0"]
//        textRecognitionRequest.
//        textRecognitionRequest.usesLanguageCorrection = false
    }
    
    
    @IBAction func EnterAnswer(_ sender: UIButton) {
//        SampleImage.cgImage!
        let myImage = CanvasView.asImage()
        let handler = VNImageRequestHandler(cgImage: myImage.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func clearCanvas(_ sender: UIButton) {
        CanvasView.clearCanvas()
    }
    
    func updateDrawing(image:UIImage) {
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
}
