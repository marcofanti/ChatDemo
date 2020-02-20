//
//  NetworkAndJson.swift
//  ChatExample
//
//  Created by Marco Fanti on 2/12/20.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import SwiftyJSON

class Json {
    func getInitialMessage(responseData: Data) -> String {
        let json = try? JSON(data: responseData)
        let output = RootClass.init(fromJson: json).output
        var initial = ""

     
        for generics in output!.generic {
            let responseType = generics.responseType
            if (responseType == "text") {
                if  let text = generics.text {
                    print("generic text = " + text)
                    initial += "\n" + text
                }
            } else if (responseType == "option") {
                if  let title = generics.title {
                    print("generic title = " + title)
                    initial += " " + title
                }
                for options in generics.options {
                    if  let label = options.label {
                        print("generic options label = " + label)
                        initial += "\n    - " + label
                    }
                }
            }
            if ((output?.intents.count)! > 0) {
                 for intents in output!.intents {
                     let intent = intents.intent
                     if  let text = intent {
                         print("intent text = " + text)
                         //initial += text
                     }
                 }
            }
        }
        print("Back from initial message" + initial)
        return initial
    }
    
    func getSession(responseData: Data) -> String {
        let json = try? JSON(data: responseData)
        let sessionId = json!["session_id"].stringValue
        print("Sessionid " + sessionId)
        return sessionId
    }
}
