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
import SAConfettiView

protocol dropMenuDisplayProtocol {
    func dropDownDisplay(tag:Int)
}


class MultiplicationViewController: UIViewController,dropMenuDisplayProtocol {
    
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    var textRecognitionRequestSecond = VNRecognizeTextRequest()
    
    var button = dropDownButton()
    
    var multiChoiceView = MultipleChoiceView()
    
    var textFieldView = TextChoiceView()
        
    var multipleChoicesAnswers = [Int]()
    
    var confetti = SAConfettiView()

    let defaultColor = UIColor.init(displayP3Red: 221/255, green: 215/255, blue: 141/255, alpha: 1)
    
    var count = 0
    
    var leftNumber: Int?
    
    var rightNumber: Int?
    
    var reconginzedText = "" {
        didSet {
            if count == 0 {
                enterButton.setTitle("Enter answer as \(reconginzedTextSecond)\(reconginzedText)", for: .normal)
            }
            enterButton.isUserInteractionEnabled = true
        }
    }
    
    var reconginzedTextSecond = "" {
        didSet {
            if count == 0 {
                enterButton.setTitle("Enter answer as \(reconginzedTextSecond)\(reconginzedText)", for: .normal)
            }
            enterButton.isUserInteractionEnabled = true
        }
    }
    
    var correctAnswer: Int? {
        didSet {
            print(correctAnswer)
            multiChoiceView.multipleChoiceCollectionView.reloadData()
            multipleChoicesAnswers = multiChoiceAnswerSetup(answer: correctAnswer)
        }
    }
    
    
    var SampleImage = UIImage.init(named: "maxresdefault")!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var sketchView: SketchView!
    
    @IBOutlet weak var sketchView2: SketchView!

    @IBOutlet weak var questionDisplayView: UIView!
    
    @IBOutlet weak var questionLabel: UILabel!
        
    @IBOutlet weak var eraserButton: UIButton!
    
    private var classifier: DigitClassifier?
    
    private var secondClassifier: DigitClassifier?
    
    let displayBtn: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: Selector("Pressed"))
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionDisplayView.layer.cornerRadius = 46
        questionDisplayView.clipsToBounds = false
        questionDisplayView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]

        sketchView.lineWidth = 30//30 .. 10
        sketchView.backgroundColor = UIColor.black
        sketchView.lineColor = UIColor.white
        sketchView.sketchViewDelegate = self
        
        sketchView2.lineWidth = 30//30 .. 10
        sketchView2.backgroundColor = UIColor.black
        sketchView2.lineColor = UIColor.white
        sketchView2.sketchViewDelegate = self
        
        sketchView2.layer.borderWidth = 0.5
        sketchView2.layer.borderColor = UIColor.white.cgColor
        sketchView.layer.borderWidth = 0.5
        sketchView.layer.borderColor = UIColor.white.cgColor
        // Initialize a DigitClassifier instance
        
        multiChoiceView.multipleChoiceCollectionView.dataSource = self
        multiChoiceView.multipleChoiceCollectionView.delegate = self
        textFieldView.textField.delegate = self
        
        
        textFieldView.textField.addDoneButtonToKeyboard(myAction:  #selector(textFieldDonePressed))
        
        
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
        
        leftNumber = Int.random(in: 0...10)
        rightNumber = Int.random(in: 0...9)
        
        questionLabel.text = "\(leftNumber!)  x  \(rightNumber!) ="
        
        dropButtonSetUp()
        
        button.dropView.dropDownMenuDisplayProtocol = self
        multiChoiceConstraints()
        hideDrawingSetup()
        textFieldConstraints()
        hideTextSetup()
        correctAnswer = correctAnswerSolution(topInput: leftNumber, bottomInput: rightNumber)
        
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "enter", style: .done, target: self, action: #selector(textFieldDonePressed))
        toolbar.setItems([displayBtn,flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.textFieldView.textField.inputAccessoryView = toolbar
        
        confetti = SAConfettiView(frame: questionDisplayView.bounds)
        confetti.type = .Confetti
        confetti.colors = [UIColor.red, UIColor.blue, UIColor.purple, UIColor.green,UIColor.yellow]
        confetti.intensity = 0.75
        
    }
    
    
    
    func initalCorrectAnswerSolution(topInput: Int?, bottomInput: Int?) {
        correctAnswerSolution(topInput: topInput, bottomInput: bottomInput)
    }
    
    func dropDownDisplay(tag: Int) {
        switch tag{
        case 0:
            ///Multi
            hideDrawingSetup()
            hideTextSetup()
            showMutliChoiceSetup()
            print("0")
        case 1:
            ///Text
            hideMultiChoiceSetup()
            hideDrawingSetup()
            showTextFieldSetup()
            print("1")
        case 2:
            ///Drawing
            hideMultiChoiceSetup()
            hideTextSetup()
            showDrawingSetup()
            print("2")
            
        case 3:
            ///Ar
            let ARviewcontroller = ARViewController()
            navigationController?.pushViewController(ARviewcontroller,animated: false)
            ARviewcontroller.topNumber = leftNumber!
            ARviewcontroller.bottomNumber = rightNumber!
               
            print("3")
        default:
            print("None")
        }
    }
    
    
    func correctAnswerSolution(topInput: Int?,bottomInput: Int?) -> Int{
        var answer = 0
        guard let topInput = topInput, let bottomInput = bottomInput else {return 0}
        let expression = NSExpression(format: "\(topInput) * \(bottomInput)")
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            answer = Int(truncating: result)
        } else {
            enterButton.setTitle("Error Calculating Contact support", for: .normal)
        }
        return answer
    }
    
    
    
    func MultiRandomQuestion(topInput: Int?,bottomInput: Int?) {
        guard let topInput = topInput, let bottomInput = bottomInput else {return}
        let expression = NSExpression(format: "\(topInput) * \(bottomInput)")
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            guard let answer = Int("\(reconginzedTextSecond)\(reconginzedText)") else { print("error with your answer"); return }
            if Int(truncating: result) == answer {
                correctAnswerDisplay()
                reconginzedText = ""
                reconginzedTextSecond = ""
                count = 0
            } else {
                wrongAnswerDisplay()
                reconginzedTextSecond = ""
                reconginzedText = ""
                count = 0
            }
        } else {
            print("error evaluating expression")
        }
    }
    
    
    
    
    
    @IBAction func EnterAnswer(_ sender: UIButton) {
        if reconginzedText == "" && reconginzedTextSecond == "" {
            return
        }
        count = 1
        MultiRandomQuestion(topInput: leftNumber, bottomInput: rightNumber)
        sketchView.clear()
        sketchView2.clear()
    }
    
    
    
    @IBAction func clearCanvas(_ sender: UIButton) {
        
        if sender.isSelected {
            print("True")
            sketchView.drawTool = .pen
            sketchView2.drawTool = .pen
            sender.isSelected = false
            sender.setImage(UIImage.init(named: "eraser"), for: .normal)
        } else {
            sketchView.drawTool = .eraser
            sketchView2.drawTool = .eraser
            sketchView2.lineWidth = 30
            sketchView.lineWidth = 30
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
    
    
    func multiChoiceAnswerSetup(answer:Int?) -> [Int]{
        let answer = answer ?? 0
        let totalChoice = Array((answer-6)..<answer) + Array(answer+1...answer+6)
        var answerChoices = [Int]()
        answerChoices.append(answer)
        while answerChoices.count != 4 {
            let randomChoice = totalChoice.randomElement() ?? 0
            if !answerChoices.contains(randomChoice) {
                answerChoices.append(randomChoice)
            }
        }
        print("Answer right now is \(answerChoices)")
        return answerChoices.shuffled()
    }
    
    
    
    @objc func textFieldDonePressed(){
        print("thing")
        if let textFieldAnswer = textFieldView.textField.text {
            if textFieldAnswer == "" {
                displayBtn.title = "Please put in an Answer"
                return
            } else {
                if correctAnswer == Int(textFieldAnswer) {
                    self.displayBtn.title = "Correct!!!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.displayBtn.title = ""
                    }
                    correctAnswerDisplay()
                    textFieldView.textField.text = ""
                } else {
                    self.displayBtn.title = "Good Try, Correct answer was \(self.correctAnswer!)"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.displayBtn.title = ""
                    }
                    self.wrongAnswerDisplay()
                    textFieldView.textField.text = ""
                }
            }
            
        } else {
            textFieldView.textField.text = "Please put in an Answer"
        }
    }
    
    
    func correctAnswerDisplay(){
        enterButton.setTitle("Correct!! Great Job", for: .normal)
        view.backgroundColor = .systemGreen
        questionDisplayView.addSubview(confetti)
        confetti.startConfetti()
        sketchView.backgroundColor = UIColor.systemGreen
        sketchView2.backgroundColor = UIColor.systemGreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.view.backgroundColor = self.defaultColor
            self.sketchView.backgroundColor = .black
            self.sketchView2.backgroundColor = .black
            self.leftNumber = Int.random(in: 0...10)
            self.rightNumber = Int.random(in: 0...9)
            self.questionLabel.text = "\(self.leftNumber!)  x  \(self.rightNumber!) ="
            self.enterButton.setTitle("", for: .normal)
            self.correctAnswer = self.correctAnswerSolution(topInput: self.leftNumber, bottomInput: self.rightNumber)
            self.confetti.removeFromSuperview()
        }
        correctAnswer = correctAnswerSolution(topInput: leftNumber, bottomInput: rightNumber)
        print(correctAnswerSolution(topInput: leftNumber, bottomInput: rightNumber))
        
    }
    
    func wrongAnswerDisplay(){
        
        enterButton.setTitle("Good Try, Correct answer is \(self.correctAnswer!)", for: .normal)
        enterButton.isHidden = false
//        enterButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.leftNumber = Int.random(in: 0...10)
            self.rightNumber = Int.random(in: 0...9)
            self.questionLabel.text = "\(self.leftNumber!)  x  \(self.rightNumber!) ="
            self.correctAnswer = self.correctAnswerSolution(topInput: self.leftNumber, bottomInput: self.rightNumber)
            self.enterButton.setTitle("", for: .normal)
        }
    }
    
    
    
    func initalCorrectAnswerSolution(topInput:Int? , bottomInput: Int?) -> Int {
       return correctAnswerSolution(topInput: topInput, bottomInput: rightNumber)
    }
    
    
    func multiChoiceConstraints(){
        view.addSubview(multiChoiceView)
        multiChoiceView.translatesAutoresizingMaskIntoConstraints = false
        multiChoiceView.topAnchor.constraint(equalTo: questionDisplayView.bottomAnchor, constant: 33).isActive = true
        multiChoiceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14).isActive = true
        multiChoiceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14).isActive = true
        multiChoiceView.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: 5).isActive = true
    }
    
    func textFieldConstraints(){
        view.addSubview(textFieldView)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.topAnchor.constraint(equalTo: questionDisplayView.bottomAnchor, constant: 22).isActive = true
        textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14).isActive = true
        textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14).isActive = true
        
        textFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func dropButtonSetUp(){
        button = dropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        button.setTitle("Menu", for: .normal)
        
        
        button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 95).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        button.dropView.dropDownOptions = ["Multiple", "Text","Drawing","AR"]
        
    }
    
    func hideDrawingSetup(){
        sketchView.isHidden = true
        sketchView2.isHidden = true
        eraserButton.isHidden = true
    }
    
    func hideMultiChoiceSetup(){
        multiChoiceView.isHidden = true
    }
    
    func hideTextSetup(){
        textFieldView.isHidden = true
        textFieldView.textField.isEnabled = false
    }
    
    
    func showMutliChoiceSetup(){
         multiChoiceView.isHidden = false
    }
    
    func showTextFieldSetup(){
        textFieldView.isHidden = false
        textFieldView.textField.isEnabled = true
        textFieldView.textField.becomeFirstResponder()
    }
    
    func showDrawingSetup(){
        sketchView.isHidden = false
        sketchView2.isHidden = false
        eraserButton.isHidden = false
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


extension MultiplicationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return multipleChoicesAnswers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? CollectionViewCell else {return UICollectionViewCell()}
        collectionViewCell.layer.borderColor = UIColor.white.cgColor
        collectionViewCell.layer.borderWidth = 1
        collectionViewCell.layer.cornerRadius = 20
        collectionViewCell.backgroundColor = UIColor.init(displayP3Red: 221/255, green: 215/255, blue: 141/255, alpha: 1)
//            UIColor.init(displayP3Red: 244/255, green: 209/255, blue: 174/255, alpha: 1)
//            377771
//        rgb(119, 91, 89)
        collectionViewCell.textLabel.text = multipleChoicesAnswers[indexPath.row].description
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print("User tapped on item \(multipleChoicesAnswers[indexPath.row])")
        if correctAnswer ?? 0 == multipleChoicesAnswers[indexPath.row] {
            correctAnswerDisplay()
        } else {
            wrongAnswerDisplay()
        }
    }
    
}

extension MultiplicationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        if (text + string).count == 4 {
            return false
        } else {
            return true
        }
    }
}
