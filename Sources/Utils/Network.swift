//
//  Network.swift
//  ChatExample
//
//  Created by Marco Fanti on 2/15/20.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final internal class Network {
    static var sessionId = ""
    
    func getSessionId(timingData: String, text: String) -> Void {
        let sessionEndpoint: String = "http://192.168.7.165:6666/assistant/api/v2/assistants/b7d8c8fe-0e39-4fd5-bfc0-e9b22868c1cb/sessions"
        guard let url = URL(string: sessionEndpoint) else {
            print("Error: cannot create URL " + sessionEndpoint)
            return
        }
        
        let session = URLSession.shared
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                // check for any errors
                guard error == nil else {
                    print("error calling get session id")
                    print(error!)
                    return
                }
                
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                // check the status code
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error: It's not a HTTP URL response")
                    return
                }
                
                // Reponse status
                print("Response status code: \(httpResponse.statusCode)")
                print("Response status debugDescription: \(httpResponse.debugDescription)")
                print("Response status localizedString: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                
                let json = Json()
                Network.sessionId = json.getSession(responseData: responseData)
                print ("SessionId = " + Network.sessionId)
            }
        }
        task.resume()
    }
    
    func getResponse(timingData: String, text: String) -> String {
        var responseString = ""
        let sessionEndpoint2: String = "http://192.168.7.165:6666/assistant/api/v2/assistants/b7d8c8fe-0e39-4fd5-bfc0-e9b22868c1cb/sessions/260b23f9-a9dc-4d2a-a200-66fbc8dd160d/"
        guard let url2 = URL(string: sessionEndpoint2) else {
            print("Error: cannot create URL " + sessionEndpoint2)
            return "Error: cannot create URL " + sessionEndpoint2
        }
        
        let session2 = URLSession.shared
        let urlRequest2 = URLRequest(url: url2)
        
        let task2 = session2.dataTask(with: urlRequest2) { (data, response, error) in
            
            DispatchQueue.main.async {
                // check for any errors
                guard error == nil else {
                    print("error calling GET on /todos/1")
                    print(error!)
                    return
                }
                
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                // check the status code
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error: It's not a HTTP URL response")
                    return
                }
                
                // Reponse status
                print("Response status code: \(httpResponse.statusCode)")
                print("Response status debugDescription: \(httpResponse.debugDescription)")
                print("Response status localizedString: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                
                let json = Json()
                responseString = json.getInitialMessage(responseData: responseData)
            }
        }
        task2.resume()
        return responseString
    }
    func callNetwork(timingData: String, text: String, completion: @escaping (String) -> ()) -> Void {
        if (Network.sessionId == "") {
            print("Creating session id")
            getSessionIdAF(timingData: timingData, text: text, completion: completion)
        } else {
            print ("SessionId already set to = " + Network.sessionId)
            self.postResponseAF(timingData: timingData, text: text, completion: completion)
        }
    }
    
    func getSessionIdAF(timingData: String, text: String, completion: @escaping (String) -> ()) -> Void {
        let urlString = "http://192.168.7.165:6666/assistant/api/v2/assistants/b7d8c8fe-0e39-4fd5-bfc0-e9b22868c1cb/sessions"
        AF.request(urlString).responseJSON { response in
            guard let value = response.value else {
                print("Error while fetching tags: \(String(describing: response.error))")
                return
            }
            
            let json = try? JSON(value)
            let sessionId = json!["session_id"].stringValue
            print("Sessionid " + sessionId)
            print("Sessionid2 " + sessionId)
            Network.sessionId = sessionId
            self.postResponseAF(timingData: timingData, text: text, completion: completion)
        }
    }
    // {"input":{"message_type":"text","text":"I want to open an account","bdata":"
    
    /* {"input":{"message_type":"text","text":"Credit card payment"}}  */
    
    func postResponseAF(timingData: String, text: String, completion: @escaping  (String) -> ()) {
        
        let parameters: [String: [String: String]] = [
            "input": [
            "message_type":"text",
            "text":text,
            "bdata":timingData
            ]
        ]
        
        struct Login: Encodable {
            let message_type: String
            let text: String
        }

        let login = Login(message_type: "text", text: text)
        
        let urlString = "http://192.168.7.165:6666/assistant/api/v2/assistants/b7d8c8fe-0e39-4fd5-bfc0-e9b22868c1cb/sessions/260b23f9-a9dc-4d2a-a200-66fbc8dd160d/messages"
        var responseString = ""
        AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.prettyPrinted).responseData { response in
            guard let value = response.value else {
                print("Error while fetching tags: \(String(describing: response.error))")
                return
            }
            
            let responseData = try? Data(value)
            let json = Json()
            responseString = json.getInitialMessage(responseData: responseData!)
            print("responseString " + responseString)
            completion(responseString)
            print("responseString2 " + responseString)
        }
    }

    func getResponseAF(timingData: String, text: String, completion: @escaping  (String) -> ()) {
        let urlString = "http://192.168.7.165:6666/assistant/api/v2/assistants/b7d8c8fe-0e39-4fd5-bfc0-e9b22868c1cb/sessions/260b23f9-a9dc-4d2a-a200-66fbc8dd160d/"
        var responseString = ""
        AF.request(urlString).responseData { response in
            guard let value = response.value else {
                print("Error while fetching tags: \(String(describing: response.error))")
                return
            }
            
            let responseData = try? Data(value)
            let json = Json()
            responseString = json.getInitialMessage(responseData: responseData!)
            print("responseString " + responseString)
            completion(responseString)
            print("responseString2 " + responseString)
        }
    }
}
