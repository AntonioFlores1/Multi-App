//
//  ARViewController.swift
//  Multiplication App
//
//  Created by John Doe on 9/18/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit
import ARKit
import SAConfettiView

protocol QuestionUpdateProtocol {
    func updateQuestion(leftInput:Int?,rightInput:Int?)
}

class ARViewController: UIViewController,ARSCNViewDelegate {

    var delegate: QuestionUpdateProtocol!
    
    let arView = ARview()
    
    let config = ARWorldTrackingConfiguration()
    
    var confetti = SAConfettiView()

    var topleftNumber:Int?
    
    var bottomrightNumber: Int?
    
    let displayBtn: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: Selector("Pressed"))
    
    var topText = SCNText(string: "", extrusionDepth: 2)
    
    var bottomText = SCNText(string: "", extrusionDepth: 2)
    
    var correctAnswer = 0
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            delegate?.updateQuestion(leftInput: topleftNumber, rightInput: bottomrightNumber)
            print("I do action")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        ARviewConstraints()
        arView.sceneView.delegate = self
//        arView.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        arView.sceneView.session.run(config)
      
        
        topText.string = "   \(topleftNumber!)"
        bottomText.string = "x \(bottomrightNumber!)"
        
        self.correctAnswer = self.correctAnswerSolution(topInput: topleftNumber,bottomInput: bottomrightNumber)
        
        let vinculumText = SCNText(string: "___", extrusionDepth: 2)
        
        let material = SCNMaterial()
        let vinculumMaterial = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        vinculumMaterial.diffuse.contents = UIColor.white

        topText.materials = [material]
        bottomText.materials = [material]
        vinculumText.materials = [vinculumMaterial]
        
        let topNode = SCNNode()
        topNode.position = SCNVector3(-0.2, -0.2,-2)
        topNode.scale =  SCNVector3(0.03, 0.03, 0.03)
        topNode.geometry = topText
        
        let bottomNode = SCNNode()
        bottomNode.position = SCNVector3(-0.2, -0.5,-2)
        bottomNode.scale =  SCNVector3(0.03, 0.03, 0.03)
        bottomNode.geometry = bottomText
        
        let vinculumNode = SCNNode()
        vinculumNode.position = SCNVector3(-0.2, -0.5,-2)
        vinculumNode.scale =  SCNVector3(0.03, 0.03, 0.03)
        vinculumNode.geometry = vinculumText
        
        arView.sceneView.scene.rootNode.addChildNode(topNode)
        arView.sceneView.scene.rootNode.addChildNode(bottomNode)
        arView.sceneView.scene.rootNode.addChildNode(vinculumNode)

        arView.sceneView.autoenablesDefaultLighting = true
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter", style: .done, target: self, action: #selector(textFieldDonePressed))
        toolbar.setItems([displayBtn,flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.arView.textField.inputAccessoryView = toolbar
        
        
        arView.textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        confetti = SAConfettiView(frame: view.bounds)
        confetti.type = .Confetti
        confetti.colors = [UIColor.red, UIColor.blue, UIColor.purple, UIColor.green]
        confetti.intensity = 0.85

        print(correctAnswer)
    }
    
      
    
    @objc func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -340
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func textFieldDonePressed(){
        print("thing")
        if let textFieldAnswer = arView.textField.text {
            if textFieldAnswer == "" {
                displayBtn.title = "Please put in an Answer"
                return
            } else {
                
//                self.correctAnswer = self.correctAnswerSolution(topInput: topNumber,bottomInput: bottomNumber)
                
                print(correctAnswer)
                
                if Int(textFieldAnswer) == correctAnswer {
                    view.addSubview(confetti)
                    confetti.startConfetti()
                    displayBtn.title = "Correct !!!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                        
                        
                        
                  ///Correct Response
                      let topNumber = Int.random(in: 0...9)
                      let bottomNumber = Int.random(in: 0...10)
                        self.topleftNumber = topNumber
                        self.bottomrightNumber = bottomNumber
                        self.topText.string = "   \(topNumber)"
                        self.bottomText.string = "x \(bottomNumber)"
                        self.correctAnswer = self.correctAnswerSolution(topInput: topNumber,bottomInput: bottomNumber)
                        self.confetti.removeFromSuperview()
                        self.confetti.stopConfetti()
                        
                    }
                } else {
                    
                    displayBtn.title = "Good Try, Answer was \(correctAnswer)"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                  ///Correct Response
                        
                      let topNumber = Int.random(in: 0...10)
                      let bottomNumber = Int.random(in: 0...9)
                        
                        self.topleftNumber = topNumber
                        self.bottomrightNumber = bottomNumber
                        self.topText.string = "   \(topNumber)"
                        self.bottomText.string = "x \(bottomNumber)"
                        
                        self.displayBtn.title = ""

                        self.correctAnswer = self.correctAnswerSolution(topInput: topNumber,bottomInput: bottomNumber)

                    }
                }
                 
                
//                correctAnswer = correctAnswerSolution(topInput: topLabel.text, bottomInput: bottomlabel.text)
//                if correctAnswer == Int(textFieldAnswer) {
//                    self.displayBtn.title = "Correct!!!"
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                        self.displayBtn.title = ""
//                    }
//                    correctAnswerDisplay()
//                    textFieldView.textField.text = ""
//                } else {
//                    self.displayBtn.title = "Good Try, Correct answer was \(self.correctAnswer!)"
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        self.displayBtn.title = ""
//                    }
//                    self.wrongAnswerDisplay()
//                    textFieldView.textField.text = ""
//                }
            }
            
        } else {
            self.arView.textField.text = "Please put in an Answer"
        }
        arView.textField.text = ""
    }

    func correctAnswerSolution(topInput: Int?,bottomInput: Int?) -> Int{
        var answer = 0
        guard let topInput = topInput, let bottomInput = bottomInput else {return 0}
        let expression = NSExpression(format: "\(topInput) * \(bottomInput)")
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            answer = Int(truncating: result)
        } else {
            displayBtn.title = "Error Calculating Contact support"
        }
        print("its")
        print(answer)
        return answer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
    
    func ARviewConstraints(){
        self.view.addSubview(arView)
        arView.translatesAutoresizingMaskIntoConstraints = false
        arView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        arView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        arView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        arView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    

    

}


extension ARViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = arView.textField.text else {return false}
        if (text + string).count == 4 {
            return false
        } else {
            return true
        }
    }
}
