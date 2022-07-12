//
//  Analytics.swift
//  Budget Tracker
//
//  Created by Misha Dovhiy on 16.05.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit

struct AnalyticModel {
    static var shared = AnalyticModel()
    
    var analiticStorage:[Analitic] {
        get {
            let all = UserDefaults.standard.value(forKey: "analiticStorage") as? [[String:Any]] ?? []
            var result:[Analitic] = []
            for element in all {
                result.append(.init(dict: element))
            }
            return result
        }
        set {
            var result:[[String:Any]] = []
            for element in newValue {
                result.append(element.dict)
            }
            UserDefaults.standard.setValue(result, forKey: "analiticStorage")
        }
    }

    func checkData() {
        let all = UserDefaults.standard.value(forKey: "analiticStorage") as? [[String:Any]] ?? []
        let first = UserDefaults.standard.value(forKey: "firstAnalyticSent") as? Bool ?? false
        if (all.count > 30) || !first {
            if !first {
                UserDefaults.standard.setValue(true, forKey: "firstAnalyticSent")
            }
            sendData(all)
        }
    }
    
    
    private func createData(_ dataOt:[[String:Any]]?) -> String {
        var all = dataOt ?? (UserDefaults.standard.value(forKey: "analiticStorage") as? [[String:Any]] ?? [])
        all.append([
            "id":(UIDevice.current.identifierForVendor?.description ?? "unknown"),
        ])
        guard let data = try? JSONSerialization.data(withJSONObject: all, options: []) else {
            return ""
        }
        return ((String(data: data, encoding: .utf8) ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    private func sendData(_ dataOt:[[String:Any]]?) {
        let analyticsData = createData(dataOt)
        if analyticsData != "" {
            SaveToDB.shared.sendAnalytics(data: analyticsData) { error in
                if error {
                    print("ERRor sending data")
                } else {
                    UserDefaults.standard.setValue([], forKey: "analiticStorage")
                }
            }
        }
        
    }
    
    
    class Analitic {
        let key:String
        let action:String
        let time:String
        let dict:[String:Any]
        
        init(dict:[String:Any]) {
           
            if let timee = dict["time"] as? String {
                self.time = timee
                self.dict = dict
            } else {
                let time = Date().iso8601withFractionalSeconds
                var resultDict = dict
                resultDict.updateValue(time, forKey: "time")
                self.time =  time
                self.dict = resultDict
            }
            
            self.key = dict["key"] as? String ?? ""
            self.action = dict["vc"] as? String ?? ""
            
        }
        init(key:String, action:String) {
            let time = Date().iso8601withFractionalSeconds
            let dict = ["key":key, "vc":action, "time": time]
            
            self.dict = dict
            self.time = time
            self.key = dict["key"] ?? ""
            self.action = dict["vc"] ?? ""
            print("newAnalitic: ", dict)
        }

    }
}

struct SaveToDB {
    static var shared = SaveToDB()
    
    func sendAnalytics(data:String, completion:@escaping (Bool) -> ()) {
        let doDataString = "applicationName=Inflation&data=\(data)"
        let url = "https://www.dovhiy.com/apps/other-apps-db/analyticsDB/" + "newAnalytic.php?"
        save(dbFileURL: url, toDataString: doDataString, secretWord: false, error: completion)
    }
    
    private func save(dbFileURL: String, httpMethod: String = "POST", toDataString: String, secretWord:Bool = true, error: @escaping (Bool) -> ()) {
        if let urlData = dbFileURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        let url = NSURL(string: urlData)
        if let reqUrl = url as URL? {
        var request = URLRequest(url: reqUrl)
        request.httpMethod = httpMethod
            var dataToSend = secretWord ? ("secretWord=" + "44fdcv8jf3") : ""
                
        dataToSend = dataToSend + toDataString
            
        let dataD = dataToSend.data(using: .utf8)

        do {
            print("dbModel: dbFileURL", dbFileURL)
            print("dbModel: dataToSend", dataToSend)

            let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD) { data, response, errr in
                
                if errr != nil {
                    print("save: internet error")
                    error(true)
                    return
                    
                } else {
                    if let unwrappedData = data {
                        let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)

                        if returnedData == "1" {
                            print("save: sended \(dataToSend)")
                            error(false)
                        } else {
                            let r = returnedData?.trimmingCharacters(in: .whitespacesAndNewlines)
                            if r == "1" {
                                print("save: sended \(dataToSend)")
                                error(false)
                            } else {
                                print("save: db error for (cats, etc)")
                                error(true)
                            }
                            
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
            DispatchQueue.main.async {
                uploadJob.resume()
            }
        }
            } else {
                print("url data error")
                error(true)
            }
        } else {
            print("error creating url")
            error(true)
        }
            
    }
}

extension Date {
    var iso8601withFractionalSeconds: String {
        return Formatter.iso8601withFractionalSeconds.string(from: self)
        
    }
}
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
