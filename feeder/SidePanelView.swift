//
//  sidePanelView.swift
//  feeder
//
//  Created by Karan Balakrishnan on 5/20/17.
//  Copyright © 2017 Karan Balakrishnan. All rights reserved.
//

import UIKit

class sidePanelView: UIView {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var searchView: UIView!
    @IBOutlet var tableView: UITableView!
    public var masterDelegate : MasterViewDelegate?
    
    func setUp(username : String,userInterests : Array<String>){
        //add tap gesture to search view
        let tapGesture = UITapGestureRecognizer.init(target: self, action: Selector(("searchTapped")))
        self.searchView.addGestureRecognizer(tapGesture)
        
        //set username
        self.usernameLabel.text = username
        
        //set up table
    }
    
    func searchTapped(){
        self.masterDelegate!.showSearchPanel()
    }
}
