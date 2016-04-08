//
//  WebService.swift
//  CodeTest2
//
//  Created by alexfu on 3/12/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import Foundation

class WebService {
    static var error: String?
    
    static func GetData(completion: (success: Bool, result: [Item]?) -> Void)
    {
        let url = "http://www.crunchyroll.com/mobile-tech-challenge/images.json"
        let request=NSURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            
            guard let responseData = data else {
                completion(success: false, result: nil)
                return
            }
            do {
                var items = [Item]()
                let objects = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSArray
                for object in objects {
                        let item = Item(fromDictionary: object as! NSDictionary   )
                        items.append(item)
                    }
                completion(success: true, result: items)
        
            } catch  {
                completion(success: false, result: nil)
                return
            }
        })
       task.resume() 
    }
    

}
