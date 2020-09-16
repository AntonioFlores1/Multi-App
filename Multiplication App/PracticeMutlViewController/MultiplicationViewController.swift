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
import Sketch


protocol dropMenuDisplayProtocol {
    func dropDownDisplay(tag:Int)
}

//Default answer choice is Mutiple Choice
//
//0 is Multiple choice
//
//1 is Text
//
//2 is Drawing
//
//3 is Ar





class MultiplicationViewController: UIViewController,dropMenuDisplayProtocol {
    
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    var textRecognitionRequestSecond = VNRecognizeTextRequest()

    
    var reconginzedText = "" {
        didSet {
            enterButton.setTitle("Enter answer as \(reconginzedTextSecond)\(reconginzedText)", for: .normal)
            enterButton.isUserInteractionEnabled = true
        }
    }
    
    var reconginzedTextSecond = "" {
        didSet {
        enterButton.setTitle("Enter answer as \(reconginzedTextSecond)\(reconginzedText)", for: .normal)
            enterButton.isUserInteractionEnabled = true
        }
    }

    
    var button = dropDownButton()
    
    
    //    var drawingToTextImage: UIImage!
    var SampleImage = UIImage.init(named: "maxresdefault")!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var sketchView: SketchView!
    
    @IBOutlet weak var sketchView2: SketchView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bottomlabel: UILabel!
    
    
    private var classifier: DigitClassifier?
    
    private var secondClassifier: DigitClassifier?
    
    var lastPoint = CGPoint.zero
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.isUserInteractionEnabled = true
        // Setup sketch view.
        sketchView.lineWidth = 10//30
        sketchView.backgroundColor = UIColor.black
        sketchView.lineColor = UIColor.white
        sketchView.sketchViewDelegate = self
        
        sketchView2.lineWidth = 10//30
        sketchView2.backgroundColor = UIColor.black
        sketchView2.lineColor = UIColor.white
        sketchView2.sketchViewDelegate = self
        
        
        
        // Initialize a DigitClassifier instance
        
        
        
        DigitClassifier.newInstance { result in
            switch result {
            case let .success(classifier):
                self.secondClassifier = classifier
                self.classifier = classifier
            case .error(_):
                print("Failed to initialize.")
                //            self.resultLabel.text = "Failed to initialize."
            }
        }

        topLabel.text = Int.random(in: 0...10).description
        bottomlabel.text = Int.random(in: 0...9).description
        
        dropButtonSetUp()
        
        button.dropView.dropDownMenuDisplayProtocol = self

    }
    
    
    func dropButtonSetUp(){
        button = dropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        button.setTitle("Menu", for: .normal)
        
        
        button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 16).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.dropView.dropDownOptions = ["Multiple", "Drawing","Text","AR"]
        
    }
    
    
    func dropDownDisplay(tag: Int) {
              switch tag{
                   case 0:
                       print("0")
                   case 1:
                       print("1")
                   case 2:
                       print("2")
                   case 3:
                       print("3")
                   default:
                       print("None")
                   }
       }
    

    func MultiRandomQuestion(topInput: String?,bottomInput: String?) {
        
        guard let topInput = topInput, let bottomInput = bottomInput else {return}
        
        let expression = NSExpression(format: "\(topInput) * \(bottomInput)")
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            
            
            guard let answer = Int("\(reconginzedTextSecond)\(reconginzedText)") else { print("error with your answer"); return }
            
            if Int(truncating: result) == answer {
                
                enterButton.setTitle("Correct !! Great Job", for: .normal)
                view.backgroundColor = .systemGreen
                sketchView.backgroundColor = .systemGreen
                sketchView2.backgroundColor = .systemGreen
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    
                    self.view.backgroundColor = .black
                    self.sketchView.backgroundColor = .black
                    self.sketchView2.backgroundColor = .black
                    self.topLabel.text = Int.random(in: 0...10).description
                    self.bottomlabel.text = Int.random(in: 0...9).description
                    self.enterButton.setTitle("", for: .normal)
                }
                
                
            } else {
                enterButton.isUserInteractionEnabled = false
                enterButton.setTitle("The Correct answer is \(result)", for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.topLabel.text = Int.random(in: 0...10).description
                    self.bottomlabel.text = Int.random(in: 0...9).description
                    self.enterButton.setTitle("", for: .normal)

                }
            }
             
        } else {
            print("error evaluating expression")
        }
        
        
    }
    
    

    
    @IBAction func EnterAnswer(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        print("Your answer is")
        print("\(reconginzedTextSecond)\(reconginzedText)")
        
        MultiRandomQuestion(topInput: topLabel.text, bottomInput: bottomlabel.text)
        sketchView.clear()
        sketchView2.clear()
    }



    @IBAction func clearCanvas(_ sender: UIButton) {

        if sender.isSelected {
            print("True")
            sketchView.drawTool = .pen
            sketchView2.drawTool = .pen
            sketchView.lineWidth = 10
            sketchView2.lineWidth = 10
            sender.isSelected = false
            sender.setImage(UIImage.init(named: "eraser"), for: .normal)
        } else {
            sketchView.drawTool = .eraser
            sketchView2.drawTool = .eraser
            sketchView2.lineWidth = 26
            sketchView.lineWidth = 26
            print("False")
            sender.isSelected = true
            sender.setImage(UIImage.init(named: "pencil"), for: .normal)

        }
        
    }
    
    func updateDrawing(image:UIImage) {
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])

            try handler.perform([textRecognitionRequestSecond])

        } catch {
            print(error)
        }
    }
    
    
    func hideDrawingSetup(){
        
    }
    
    func hideMultiChoiceSetup(){
        
    }
    
    func hideARsetUp(){
        
    }
    
    func hideTextSetup(){
        
    }
    
    
}


// MARK: Sketch Delegate

extension MultiplicationViewController: SketchViewDelegate {
    
    func drawView(_ view: SketchView, didEndDrawUsingTool tool: AnyObject) {
        if view == sketchView2 {
            
            func updateDrawing(image:UIImage) {
                let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
                do {

                    try handler.perform([textRecognitionRequestSecond])

                } catch {
                    print(error)
                }
            }

            classifySecondDrawing()

            
        } else if view == sketchView {
            
            
            func updateDrawing(image:UIImage) {
                let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
                do {
                    try handler.perform([textRecognitionRequest])

                } catch {
                    print(error)
                }
            }
            
            classifyFirstDrawing()

        }
      
    }
 
    
    private func classifyFirstDrawing() {
        
      guard let classifier = self.classifier else { return }
      // Capture drawing to RGB file.
      UIGraphicsBeginImageContext(sketchView.frame.size)
        
      sketchView.layer.render(in: UIGraphicsGetCurrentContext()!)

        
      let drawing = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext();

        
      guard drawing != nil else {
        print("Invalid drawing.")
//        resultLabel.text = "Invalid drawing."
        return
      }

        
      // Run digit classifier.
      classifier.classify(image: drawing!) { result in
        // Show the classification result on screen.
        switch result {
        case let .success(classificationResult):
            
            let rightAnswer = classificationResult.split(separator: "\n").first
            if let rightAnswer = rightAnswer?.last {
                self.reconginzedText = rightAnswer.description
                print(rightAnswer)
            } else {
              self.reconginzedText = "Error"
            }
            
            
        case .error(_):
            print("Failed to classify drawing.")
//          self.resultLabel.text = "Failed to classify drawing."
        }
      }

    }
    
    
    
    private func classifySecondDrawing() {
         guard let secondClassifier = self.secondClassifier else { return }
          // Capture drawing to RGB file.
          UIGraphicsBeginImageContext(sketchView2.frame.size)
          sketchView2.layer.render(in: UIGraphicsGetCurrentContext()!)

            
            
          let drawing = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext();

          guard drawing != nil else {
            print("Invalid drawing.")
    //        resultLabel.text = "Invalid drawing."
            return
          }
            secondClassifier.classify(image: drawing!) { result in
                    // Show the classification result on screen.
                    switch result {
                    case let .success(classificationResult):
                        let leftAnswer = classificationResult.split(separator: "\n").first
                        
                        if let leftAnswer = leftAnswer?.last {
                            self.reconginzedTextSecond = leftAnswer.description
                            print(leftAnswer)
                        } else {
                          self.reconginzedTextSecond = "Error i dont know that number"
                        }
                    case .error(_):
                        print("Failed to classify drawing.")
            //          self.resultLabel.text = "Failed to classify drawing."
                    }
                  }
        }
}
