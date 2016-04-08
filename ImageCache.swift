//
//  ImageCache.swift
//  CodeTest3
//
//  Created by alexfu on 3/17/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import UIKit

class ImageCache: NSObject {

    static let bytesPerMB = 1024 * 1024
    
    static let memoryUsage = 10 * bytesPerMB
    static let diskUsage = 200 * bytesPerMB
    static let cachePath = "ImagesCache"
    
    let cacheLockQueue = dispatch_queue_create("comm.ImageCache.urlCacheQueue", DISPATCH_QUEUE_SERIAL)
    let urlCache = NSURLCache(memoryCapacity: memoryUsage, diskCapacity: diskUsage, diskPath: cachePath)
    
    func getImageForUrlRequest(urlRequest: NSURLRequest) -> UIImage? {
        var responce: NSCachedURLResponse? = nil
        dispatch_sync(self.cacheLockQueue) { () -> Void in
            responce = self.urlCache.cachedResponseForRequest(urlRequest)
        }
        if let responce = responce {
            return UIImage(data: responce.data)
        } else {
            return nil
        }
    }
    
    func saveUrlResponce(urlResponce: NSURLResponse, withData data: NSData, forUrlRequest urlRequest: NSURLRequest) {
        let cachedResponce = NSCachedURLResponse(response: urlResponce, data: data)
        dispatch_sync(self.cacheLockQueue) { () -> Void in
            self.urlCache.storeCachedResponse(cachedResponce, forRequest: urlRequest)
        }
    }
}
