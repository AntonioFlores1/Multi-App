//
//  DropDownButton.swift
//  Multiplication App
//
//  Created by antonio  on 7/14/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import Foundation
import UIKit

protocol dropDownProtocol {
    func dropDownChoice(string:String,tag:Int)
}



class dropDownButton: UIButton,dropDownProtocol {
    

    func dropDownChoice(string: String, tag: Int) {
         self.setTitle(string, for: .normal)
         self.tag = tag
         dismissDropDown()
        
    }

    
    
    var dropView = dropDownView()
    
    
    var height = NSLayoutConstraint()
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .darkGray
        
        dropView = dropDownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
        
    }
    
    
    var isOpen = false
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.menuTabelView.contentSize.height > 150 {
                self.height.constant = 150
                
            } else {
                
                self.height.constant = self.dropView.menuTabelView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height/2
            }, completion: nil)
            
        } else {
            
            print("rgfsdsd")
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height/2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    func dismissDropDown(){
                   isOpen = false
                   
                   NSLayoutConstraint.deactivate([self.height])
                   self.height.constant = 0
                   NSLayoutConstraint.activate([self.height])

                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                       self.dropView.center.y -= self.dropView.frame.height/2
                       self.dropView.layoutIfNeeded()
                   }, completion: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
