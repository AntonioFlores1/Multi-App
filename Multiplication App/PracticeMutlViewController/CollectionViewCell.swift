//
//  CollectionViewCell.swift
//  Multiplication App
//
//  Created by John Doe on 9/16/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabelSetup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textLabelSetup(){
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo:topAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
