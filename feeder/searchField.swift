//
//  searchField.swift
//  feeder
//
//  Created by Karan Balakrishnan on 5/21/17.
//  Copyright © 2017 Karan Balakrishnan. All rights reserved.
//

import UIKit

class searchField: UIView {
    
    let textField : UITextField = UITextField()
    let searchButton : UIButton = UIButton()
    var searchDelegate : SearchDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp(){
//        textField.frame = wwlekkk
     textField.frame = CGRect.init(x: 5, y: 1, width: (0.65 * self.frame.width), height: self.frame.height-2)
     self.addSubview(textField)
     searchButton.frame = CGRect.init(x: textField.frame.origin.x + textField.frame.width + 10 , y: 5, width: self.frame.width - textField.frame.width - 5 - 10 - 10, height: self.frame.height - 10)
     searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = UIColor.darkGray
    self.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(didSearch), for: .touchUpInside)
        searchButton.layer.cornerRadius = 5
        searchButton.clipsToBounds = true
        self.backgroundColor = UIColor.white
        self.textField.becomeFirstResponder()
    }

    func didSearch(){
        self.searchDelegate?.didSearchFor(keyword: self.textField.text!)
    }
}
