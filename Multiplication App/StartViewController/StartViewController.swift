//
//  StartViewController.swift
//  Multiplication App
//
//  Created by antonio  on 7/10/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var characterButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    let transition = TransitionAnimator()
    var selectedCell = UICollectionViewCell()
    
    lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MultiplicationListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionViewSetUp()
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
//        transition.dismissCompletion = {
//            self.selectedCell.isHidden = false
//        }

    }
    
    
    @IBAction func SegmentedControlFunc(_ sender: UISegmentedControl) {
        
        let segmentedControlIndex = segmentedControl.selectedSegmentIndex
        
        switch segmentedControlIndex {
        case 0:
            settingsButton.isHidden = false
            characterButton.isHidden = false
            startButton.isHidden = false
            collectionView.isHidden = true
        case 1:
            settingsButton.isHidden = true
            characterButton.isHidden = true
            startButton.isHidden = true
            collectionView.isHidden = false
            
        default:
            print("Error")
        }
    }
    
    func CollectionViewSetUp(){
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
}


extension StartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width/2.5) , height: view.frame.width/2)
    }
    
    
}

extension StartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MultiplicationListCollectionViewCell else { return UICollectionViewCell() }
        let multiplicationOf = ["1's","2's","3's","4's","5's","6's","7's","8's","9's","10's",]
        CollectionViewCell.tag = indexPath.row + 1
        CollectionViewCell.textLabel.text = multiplicationOf[indexPath.row]
        CollectionViewCell.layer.masksToBounds = true
        CollectionViewCell.layer.cornerRadius = 8
        //        CollectionViewCell.layer.shadowColor = CGColor(UIColor.gray as! CGColorSpace)
        CollectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        CollectionViewCell.layer.shadowRadius = 5.0
        CollectionViewCell.layer.shadowOpacity = 3.0
        CollectionViewCell.layer.borderColor = UIColor.black.cgColor
        CollectionViewCell.layer.borderWidth = 1
        print(CollectionViewCell.tag)
        return CollectionViewCell
    }
    
    
}

extension StartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as! MultiplicationListCollectionViewCell
        let pokemonDetailViewController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! MultiplicationStudyViewController
        
        pokemonDetailViewController.multipleBy = selectedCell.tag
        pokemonDetailViewController.transitioningDelegate = self
        present(pokemonDetailViewController, animated: true, completion: nil)
    }
}
extension StartViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil) else {
            return transition
        }
        
        transition.originFrame = originFrame
        transition.presenting = true
        
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil) else {
                   return transition
               }
               
//        transition.originFrame = originFrame
        transition.presenting = false



        return transition
    }
    
}
