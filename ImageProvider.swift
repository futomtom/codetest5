
//  ImageProvider.swift
//  CodeTest3
//
//  Created by alexfu on 3/17/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import UIKit

class ImageProvider: NSObject {

    var loader: ImageLoader
    var cache: ImageCache
    
    override init() {
        self.loader = ImageLoader()
        self.cache = ImageCache()
        super.init()
    }
    
    public class var sharedInstance: ImageProvider {
        get {
            struct Static {
                static var onceToken : dispatch_once_t = 0
                static var instance : ImageProvider? = nil
            }
            dispatch_once(&Static.onceToken) {
                Static.instance = ImageProvider()
            }
            return Static.instance!
        }
    }
    
    typealias ProvideImageCompletition = (image: UIImage?, error: NSError?) -> Void
    
    func provideImage(imageUrl: NSURL, completition: ProvideImageCompletition) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            let urlRequest = NSURLRequest(URL: imageUrl)
            if let image = self.cache.getImageForUrlRequest(urlRequest) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completition(image: image, error: nil)
                })
                return
            } else {
                self.loader.loadImage(urlRequest, completition: { (responce, data, error) -> Void in
                    guard let responce = responce, let data = data else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completition(image: nil, error: error)
                        })
                        return
                    }
                    
                    self.cache.saveUrlResponce(responce, withData: data, forUrlRequest: urlRequest)
                    completition(image: UIImage(data: data), error: nil)
                })
            }
        }
    }
}
