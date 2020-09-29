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
    
    var toggle: Bool = true
    
    var multiplicationToSpeech = ""

    let voiceSynth = AVSpeechSynthesizer()
    
    let voices = AVSpeechSynthesisVoice.speechVoices()

    var voiceToUse = AVSpeechSynthesisVoice(identifier:"com.apple.ttsbundle.siri_female_en-US_compact")

    var table = [String]()
    
    @IBOutlet weak var speakerButton: UIButton!
    
    @IBOutlet var multiplicationButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("My number is \(multipleBy!)")
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
        
         let multiplicationTable = ["\(multipleBy!) x 0","\(multipleBy!) x 1","\(multipleBy!) x 2","\(multipleBy!) x 3","\(multipleBy!) x 4 ","\(multipleBy!) x 5","\(multipleBy!) x 6","\(multipleBy!) x 7","\(multipleBy!) x 8","\(multipleBy!) x 9","\(multipleBy!) x 10"]
        
        table = multiplicationTable
        
        fillInLabels(multiTabel: multiplicationTable)
        
        
        for i in multiplicationTable {
            let answer = solveMuliTabel(problem: i)
            let iteration = problemTextToSpeech(problem: i, answer: answer)
            print(i)
            print(iteration)
            multiplicationToSpeech += iteration
        }
        
        for voice in voices {
              if voice.name == "Samantha (Enhanced)"  && voice.quality == .enhanced {
                voiceToUse = voice
              }
            }
        
        
        
        //                let utterance = AVSpeechUtterance(string: "Hello world")
        //                utterance.voice = AVSpeechSynthesisVoice(identifier:"com.apple.ttsbundle.siri_female_en-US_compact")
        //
        //                utterance.rate = 0.3
        //                let synthesizer = AVSpeechSynthesizer()
        //
        //                synthesizer.speak(utterance)
        
        
//        let Voice = AVSpeechSynthesizer()
//
//        let utterance = AVSpeechUtterance(string: "Welcome back. The database should still be up for you")
//                       utterance.voice = AVSpeechSynthesisVoice(identifier:" com.apple.speech.voice.Alex")
////        com.apple.ttsbundle.siri_female_en-US_compact
//        let TilteSpeakingText1 = AVSpeechUtterance(string: "Welcome back. The database should still be up for you")
////        Voice.voice = AVSpeechSynthesisVoice(identifier:"com.apple.ttsbundle.siri_female_en-US_compact")
////        synthesizer.speak(utterance)
//        Voice.speak(utterance)
//                   TilteSpeakingText1.rate = 0.003
//                   TilteSpeakingText1.pitchMultiplier = 0.60
//                   TilteSpeakingText1.volume = 0.75
//                   TilteSpeakingText1.postUtteranceDelay = 0.01

    }
    
    
    func sayThis(_ phrase: String){
        
// AVSpeechSynthesisVoice(identifier:"VOICEID:com.apple.speech.synthesis.voice.custom.siri.aaron.premium_1")
        let utterance = AVSpeechUtterance(string: phrase)

        utterance.voice = voiceToUse
        utterance.rate = 0.40
//        utterance.postUtteranceDelay = 0.2
        utterance.pitchMultiplier = 1.20
//AVSpeechSynthesisVoice(identifier:"com.apple.ttsbundle.siri_female_en-US_compact")
//        com.apple.ttsbundle.siri_female_en-US_compact
        
        voiceSynth.mixToTelephonyUplink = true
        
        voiceSynth.speak(utterance)
    }
    
    @IBAction func speaker(_ sender: UIButton) {
        
        
        if toggle {
            sender.setImage(UIImage.init(systemName: "speaker.slash"), for: .normal)
            sender.tintColor = .systemBlue
            print(multiplicationToSpeech)
            sender.setImage(UIImage.init(systemName: "speaker.wave.2"), for: .normal)
            sayThis(multiplicationToSpeech)
            toggle = false
        } else {
            voiceSynth.stopSpeaking(at: .immediate)
            sender.setImage(UIImage.init(systemName: "speaker.slash"), for: .normal)
            toggle = true
            sender.tintColor = .systemRed

        }
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func buttonSelection(_ sender: UIButton) {
        speakerButton.setImage(UIImage.init(systemName: "speaker.slash"), for: .normal)
        speakerButton.tintColor = .systemRed
        
        voiceSynth.stopSpeaking(at: .immediate)
        print(sender.currentTitle)
        let iteration = singleProblemTextToSpeech(problem: sender.currentTitle!)
        print(iteration)
        sayThis(iteration)
        
    }
    
    
    func singleProblemTextToSpeech(problem:String) -> String {
        let expressionString = problem.replacingOccurrences(of: "x", with: "times")
        return expressionString
    }
    
    
    
    func problemTextToSpeech(problem:String, answer:String) -> String {
        let expressionString = problem.replacingOccurrences(of: "x", with: "times")
        return "\(expressionString) is \(answer); "
    }
    
    func fillInLabels(multiTabel:[String]){
        print(multiTabel.count)
        for index in 0..<multiTabel.count {
            
            let answer = solveMuliTabel(problem: multiTabel[index])

            multiplicationButton[index].setTitle("\(multiTabel[index]) = \(answer)", for: .normal)
        }
    }
    
    func solveMuliTabel(problem: String) -> String {
        
        let expressionString = problem.replacingOccurrences(of: "x", with: "*")
        let expression = NSExpression(format: expressionString)
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            
            return result.description
            
        } else {
            print("error evaluating expression")
            return "error evaluating expression"
        }
    }
    
    
}
