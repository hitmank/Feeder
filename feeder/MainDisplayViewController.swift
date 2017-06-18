//
//  MainDisplayViewController.swift
//  feeder
//
//  Created by Karan Balakrishnan on 5/20/17.
//  Copyright © 2017 Karan Balakrishnan. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import TwitterKit

class MainDisplayViewController: UIViewController,MasterViewDelegate,SearchDelegate {
    
    public var username : String?
    @IBOutlet var mainView: mainDisplayView!
    var searchPanel : searchField?
    let sidePanelOpenSwitch : UIButton = UIButton()
    var isSidePanelOpen : Bool = true
    var isSearchFieldOPen : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.sideView.masterDelegate = self
        self.mainView.sideView.setUp(username: username!, userInterests: Array())
        self.addSidePanelOpenSwitch()
        
        
        struct MyProfileRequest: GraphRequestProtocol {
            struct Response: GraphResponseProtocol {
                init(rawResponse: Any?) {
                    // Decode JSON from rawResponse into other properties here.
                }
            }
            
            var graphPath = "/me"
            var parameters: [String : Any]? = ["fields": "id, name"]
            var accessToken = AccessToken.current
            var httpMethod: GraphRequestHTTPMethod = .GET
            var apiVersion: GraphAPIVersion = .defaultVersion
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showSearchPanel() {
        if self.isSearchFieldOPen {
            return
        }
        self.isSearchFieldOPen = true
         searchPanel = searchField.init(frame: CGRect.init(x: self.mainView.sideView.frame.width + 5, y: self.mainView.sideView.searchView.frame.origin.y, width: self.mainView.masterView.frame.width - 10, height: 50))
        searchPanel?.layer.cornerRadius = 5.0
        searchPanel?.layer.masksToBounds = true
        searchPanel?.searchDelegate = self
        let finalCenter : CGPoint = searchPanel!.center
        searchPanel?.center = CGPoint.init(x: self.mainView.sideView.frame.width, y: finalCenter.y)
        searchPanel?.transform = CGAffineTransform(scaleX: 0.0, y: 1.0);
        self.mainView.addSubview(searchPanel!)
        UIView.animate(withDuration: 0.7, animations: {
            self.searchPanel!.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0);
            self.searchPanel!.center = finalCenter
        })
    }
    func didSearchFor(keyword: String) {
        
        self.hideSidePanel()
        
        let client = TWTRAPIClient()
        var statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
         statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json?q=manchester&since_id=24012619984051000&max_id=250126199840518145&result_type=mixed&count=4"
        let params = ["id": "20"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    func hideSidePanel(){
        if isSearchFieldOPen{
            self.searchPanel?.removeFromSuperview()
            self.isSearchFieldOPen = false
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.mainView.sideView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
            self.mainView.masterView.frame = CGRect.init(x: 0, y: 0, width: self.mainView.frame.width, height: self.mainView.frame.height)
            self.sidePanelOpenSwitch.center = CGPoint.init(x: 0, y: self.sidePanelOpenSwitch.center.y)
        },completion:{ _ in
        
            self.isSidePanelOpen = false;
        
        
        })
    }
    
    func addSidePanelOpenSwitch(){
        self.sidePanelOpenSwitch.frame = CGRect.init(x: 0, y: 0, width: 20, height: 10)
        self.sidePanelOpenSwitch.center = CGPoint.init(x: self.mainView.sideView.frame.width , y: self.mainView.frame.height/2)
        self.sidePanelOpenSwitch.backgroundColor = UIColor.red
        self.sidePanelOpenSwitch.addTarget(self, action: #selector(toggleSidePanel), for: .touchUpInside)
        self.mainView.addSubview(self.sidePanelOpenSwitch)
        self.mainView.bringSubview(toFront: self.sidePanelOpenSwitch)
        self.isSidePanelOpen = true;
    }
    
    func toggleSidePanel(){
        if self.isSidePanelOpen {
            self.hideSidePanel()
        }
        else{
            self.showSidePanel()
        }
    }
    
    func showSidePanel(){
        let widthOfSidePanel = (39.855 * self.mainView.frame.width)/100;
        UIView.animate(withDuration: 0.5, animations: {
            self.mainView.sideView.frame = CGRect.init(x: 0, y: 0, width: widthOfSidePanel, height: self.mainView.frame.height)
            self.mainView.masterView.frame = CGRect.init(x: widthOfSidePanel, y: 0, width: self.mainView.frame.width - widthOfSidePanel, height: self.mainView.frame.height)
            self.sidePanelOpenSwitch.center = CGPoint.init(x: widthOfSidePanel, y: self.sidePanelOpenSwitch.center.y)
        },completion:{ _ in
            
            self.isSidePanelOpen = true;

        })
    }
}

