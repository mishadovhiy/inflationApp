//
//  ApiManager.swift
//  Inflation
//
//  Created by Misha Dovhiy on 17.09.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import Foundation

struct Api {
    func loadAppUrl(completion:@escaping(String, String)->()) {
        perfromRequest(url: "https://www.mishadovhiy.com/apps/AppsData.json", completion: { res, error in
            if res.count == 0 || error != "" {
                completion("", error == "" ? "No internet" : error)
                return
            }
            var loadedData: String = ""

            res.forEach({
                guard let jsonElement = $0 as? NSDictionary,
                      let appArr = jsonElement["inflation"] as? NSArray,
                      let app = appArr.firstObject as? [String:Any],
                      let url = app["url"] as? String
                      
                else {
                    return }
                loadedData = url
            })
            print(loadedData, " hyrgtefr")
            DispatchQueue(label: "db", qos: .userInitiated).async {
                DB.db.appUrl = loadedData
                completion(loadedData, error)
            }
        })
    }
    
    func perfromRequest(url:String, completion:@escaping(NSArray, String)->()) {
        let url: URL = URL(string: url)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("loadCPI error:", error.debugDescription)
                completion([], "Internet Error!")
                return
            } else {
                var jsonResult = NSArray()
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError {
                    print("loadCPI error 2:", error)
                    completion([], "Error loading data")
                    return
                }
                print(data?.description ?? "no description", "datadatadatadata")
                print(jsonResult, "jsonResultjsonResultjsonResultjsonResult")
                completion(jsonResult, "")

            }
        }
        DispatchQueue.main.async {
            task.resume()
        }
    }
    
    
    enum Request {
        case url
        case cpi
    }
    
    func request(url:Request, completion:@escaping(NSArray, String)->()) {
        if let url = DB.db.appUrl {
            perfromRequest(url: url, completion: completion)
        } else {
            loadAppUrl { urlStr, error in
                if urlStr != "" && error == "" {
                    self.request(url: url, completion: completion)
                } else {
                    
                }
            }
        }
    }
    
    func loadCPI(completion: @escaping ([String: Double], String) -> ()) {
    
        request(url: .cpi, completion: { res, error in
            var loadedData: [String: Double] = [:]

            res.forEach({
                guard let jsonElement = $0 as? NSDictionary,
                      let test = jsonElement["cpi"] as? NSArray,
                      let cpi = test.firstObject as? [String:Double]
                else { return }
                loadedData = cpi
            })

            completion(loadedData, "")
        })
    }
}
