//
//  Reachability.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 19.05.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import Foundation
import SystemConfiguration
public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
//        var Status:Bool = false
//        let url = NSURL(string: "http://google.com/")
//        let request = NSMutableURLRequest(URL: url!)
//        request.HTTPMethod = "HEAD"
//        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
//        request.timeoutInterval = 7
//        
//        var response: NSURLResponse?
//        
//        var data = (try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)) as NSData?
//        
//        if let httpResponse = response as? NSHTTPURLResponse {
//            if httpResponse.statusCode == 200 {
//                Status = true
//            }
//        }
//        
//        return Status // was status
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
