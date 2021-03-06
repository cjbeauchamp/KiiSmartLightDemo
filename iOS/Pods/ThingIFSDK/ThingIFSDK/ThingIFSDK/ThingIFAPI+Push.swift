//
//  ThingIFAPI+Push.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

extension ThingIFAPI {
    func _installPush(
        deviceToken:NSData,
        development:Bool?=false,
        completionHandler: (String?, ThingIFError?)-> Void
        )
    {
        let requestURL = "\(baseURL)/api/apps/\(appID)/installations"
        
        // genrate body
        let requestBodyDict = NSMutableDictionary()
        
        requestBodyDict["installationRegistrationID"] = deviceToken.hexString()
        requestBodyDict["deviceType"] = "IOS"
        requestBodyDict["development"] = NSNumber(bool: development!)
        kiiVerboseLog("Request body",requestBodyDict)
        // generate header
        var requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)"]
        
        requestHeaderDict["Content-type"] = "application/vnd.kii.InstallationCreationRequest+json"
        
        do{
            let requestBodyData = try NSJSONSerialization.dataWithJSONObject(requestBodyDict, options: NSJSONWritingOptions(rawValue: 0))
            // do request
            let request = buildDefaultRequest(.POST,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: requestBodyData, completionHandler: { (response, error) -> Void in
                
                if let installationID = response?["installationID"] as? String{
                    self._installationID = installationID
                }
                self.saveToUserDefault()
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(self._installationID, error)
                }
            })
            let operation = IoTRequestOperation(request: request)
            operationQueue.addOperation(operation)
            
        }catch(let e){
            kiiSevereLog(e)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(nil, ThingIFError.JSON_PARSE_ERROR)
            }
        }

    }

    func _uninstallPush(
        installationID:String?,
        completionHandler: (ThingIFError?)-> Void
        )
    {
        let idParam = installationID != nil ? installationID : self._installationID
        let requestURL = "\(baseURL)/api/apps/\(appID)/installations/\(idParam!)"
        
        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(owner.accessToken)"]
        
        let request = buildDefaultRequest(.DELETE,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            
            if error == nil{
                self._installationID = nil
            }
            self.saveToUserDefault()
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler( error)
            }
        })
        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)

    }
}