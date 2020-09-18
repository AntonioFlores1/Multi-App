//
//  ARview.swift
//  Multiplication App
//
//  Created by John Doe on 9/18/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit
import ARKit

class ARview: UIView {
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.placeholder = "Enter Answer Here"
        return textField
    }()
    
    lazy var sceneView: ARSCNView = {
        var ARscnView = ARSCNView()
        
        return ARscnView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        ARSCNConstriants()
        textFieldConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func ARSCNConstriants(){
        addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sceneView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    func textFieldConstraints(){
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 100).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -100).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -44).isActive = true
        
    }
}
