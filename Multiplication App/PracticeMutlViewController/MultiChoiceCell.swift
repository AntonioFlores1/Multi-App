//
//  MultiChoiceCell.swift
//  Multiplication App
//
//  Created by antonio  on 7/15/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit

class MultiChoiceCell: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 28)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        textLabelSetup()
        backgroundColor = .white
        
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    func textLabelSetup(){
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}
