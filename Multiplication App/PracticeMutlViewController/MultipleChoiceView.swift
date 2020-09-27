//
//  MultipleChoiceView.swift
//  Multiplication App
//
//  Created by John Doe on 9/16/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit

class MultipleChoiceView: UIView {
    
    lazy var multipleChoiceCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 110, height: 105)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    
    func collectionViewSetup(){
        addSubview(multipleChoiceCollectionView)
        multipleChoiceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        multipleChoiceCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        multipleChoiceCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        multipleChoiceCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        multipleChoiceCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionViewSetup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
