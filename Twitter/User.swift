//
//  User.swift
//  Twitter
//
//  Created by Maggie Gates on 2/21/16.
//  Copyright © 2016 CodePath. All rights reserved.
//


import UIKit
var _currentUser: User?

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString!
    var profileUrl: NSURL?
    var coverString: String?
    var coverUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    let userDidTweetNotification = "userDidTweetNotification"

    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        coverString = dictionary["profile_banner_url"]  as? String
        
        
        if coverString != nil {
            
            coverUrl = NSURL(string: coverString!)!
        }
        
        let imageURLString = dictionary["profile_image_url_https"] as? String
        if imageURLString != nil {
            profileUrl = NSURL(string: imageURLString!)!
        }
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let userData = defaults.objectForKey("currentUserData") as? NSData
        
        if let userData = userData {
        let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
                
            }
            
            defaults.synchronize()
        }
    }
    func tweeted() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidTweetNotification, object: nil)
    }

}
    