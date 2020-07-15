//
//  DropDownView.swift
//  Multiplication App
//
//  Created by antonio  on 7/14/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import Foundation
import UIKit

class dropDownView: UIView, UITableViewDelegate,UITableViewDataSource {
    
    var dropDownOptions = [String]()
    
    var menuTabelView = UITableView()
    
//    var dropButton = dropDownButton()
    
    var delegate: dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        menuTabelView.backgroundColor = .darkGray
        menuTabelView.delegate = self
        menuTabelView.dataSource = self
        
        menuTableViewSetup()
        
        
    }
    
    
    func menuTableViewSetup(){
        menuTabelView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(menuTabelView)

        menuTabelView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        menuTabelView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        menuTabelView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        menuTabelView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(dropDownOptions)
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
//        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.imageView?.image = UIImage.init(named: "\(dropDownOptions[indexPath.row])")
        cell.imageView?.contentMode = .scaleAspectFit
        cell.backgroundColor = .darkGray
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownChoice(string: dropDownOptions[indexPath.row],tag:indexPath.row)
        
        //        print(dropDownOptions[indexPath.row])
    }
}
