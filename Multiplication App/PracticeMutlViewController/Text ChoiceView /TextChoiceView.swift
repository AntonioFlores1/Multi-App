//
//  TextChoiceView.swift
//  Multiplication App
//
//  Created by John Doe on 9/16/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit

class TextChoiceView: UIView {

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.placeholder = "Enter Answer Here"
        return textField
    }()
    
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        textFieldConstraints()
        
    }
    
    func textFieldConstraints(){
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topAnchor,constant: 22).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 100).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -100).isActive = true
        textField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
