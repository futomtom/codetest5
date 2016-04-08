//
//  Item.swift
//  CodeTest2
//
//  Created by alexfu on 3/12/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import Foundation
import UIKit



//
//	Item.swift
//
//	Create by alex on 24/3/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated

import Foundation


//
//	RootClass.swift
//
//	Create by alex on 30/3/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated

import Foundation

struct Item {
    
    var caption : String!
    var original : String!
    var thumb : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        caption = dictionary["caption"] as? String
        original = dictionary["original"] as? String
        thumb = dictionary["thumb"] as? String
    }
}