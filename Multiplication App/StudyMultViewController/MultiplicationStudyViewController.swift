//
//  MultiplicationStudyViewController.swift
//  Multiplication App
//
//  Created by antonio  on 7/10/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit
import AVFoundation

class MultiplicationStudyViewController: UIViewController {
    
    var multipleBy: Int?
    
    @IBOutlet var multiplicationButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("My number is \(multipleBy!)")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
        
        let multiplicationTable = ["\(multipleBy!) x 0","\(multipleBy!) x 1","\(multipleBy!) x 2","\(multipleBy!) x 3","\(multipleBy!) x 4 ","\(multipleBy!) x 5","\(multipleBy!) x 6","\(multipleBy!) x 7","\(multipleBy!) x 8","\(multipleBy!) x 9","\(multipleBy!) x 10"]
        
        fillInLabels(multiTabel: multiplicationTable)
        
//                let utterance = AVSpeechUtterance(string: "Hello world")
//                utterance.voice = AVSpeechSynthesisVoice(identifier:"com.apple.ttsbundle.siri_female_en-US_compact")
//
//                utterance.rate = 0.3
//                let synthesizer = AVSpeechSynthesizer()
//
//                synthesizer.speak(utterance)
        
        
        let voices = AVSpeechSynthesisVoice.speechVoices()
        let voiceSynth = AVSpeechSynthesizer()
        var voiceToUse = AVSpeechSynthesisVoice(identifier:"com.apple.ttsbundle.siri_female_en-US_compact")
//com.apple.ttsbundle.siri_female_en-US_compact

        func sayThis(_ phrase: String){
            let utterance = AVSpeechUtterance(string: phrase)
            utterance.voice = voiceToUse
            utterance.rate = 0.4
            utterance.pitchMultiplier = 1.4
            voiceSynth.mixToTelephonyUplink = true

            voiceSynth.speak(utterance)
        }

        for i in multiplicationTable {
            sayThis("\(i)")
        }
        
        
        
    }
    
    func fillInLabels(multiTabel:[String]){
        for index in 0..<multiTabel.count {
            
            let expressionString = multiTabel[index].replacingOccurrences(of: "x", with: "*")
            let expression = NSExpression(format: expressionString)
            if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
                
                multiplicationButton[index].setTitle("\(multiTabel[index]) = \(result)", for: .normal)
                
            } else {
                print("error evaluating expression")
            }
            
            
        }
    }
    
//    func solveMuliTabel(proble: ){
//        
//    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        //         presentingViewController?.dismiss(animated: false, completion: nil)
        dismiss(animated: false, completion: nil)
        
    }
    
    @objc func actionClose(_ tap: UITapGestureRecognizer) {
        //           presentingViewController?.dismiss(animated: false, completion: nil)
        
        //        dismiss(animated: false, completion: nil)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
