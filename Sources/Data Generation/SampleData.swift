/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import MessageKit
import CoreLocation
import AVFoundation
import Alamofire
import SwiftyJSON


final internal class SampleData {

    static let shared = SampleData()

    private init() {}

    enum MessageTypes: String, CaseIterable {
        case Text
        case AttributedText
        case Photo
        case Video
        case Audio
        case Emoji
        case Location
        case Url
        case Phone
        case Custom
        case ShareContact
    }

    let system = MockUser(senderId: "000000", displayName: "System")
    let nathan = MockUser(senderId: "000001", displayName: "Nathan Tannar")
    let steven = MockUser(senderId: "000002", displayName: "Steven Deutsch")
    let wu = MockUser(senderId: "000003", displayName: "Wu Zhong")
    let banking = MockUser(senderId: "000004", displayName: "Acme Bank")
    let marco = MockUser(senderId: "000005", displayName: "Marco Fanti")

    lazy var senders = [nathan, steven, wu]
    
    lazy var contactsToShare = [
        MockContactItem(name: "System", initials: "S"),
        MockContactItem(name: "Nathan Tannar", initials: "NT", emails: ["test@test.com"]),
        MockContactItem(name: "Steven Deutsch", initials: "SD", phoneNumbers: ["+1-202-555-0114", "+1-202-555-0145"]),
        MockContactItem(name: "Wu Zhong", initials: "WZ", phoneNumbers: ["202-555-0158"]),
        MockContactItem(name: "+40 123 123", initials: "#", phoneNumbers: ["+40 123 123"]),
        MockContactItem(name: "test@test.com", initials: "#", emails: ["test@test.com"])
    ]

    var currentSender: MockUser {
        return marco
    }

    var now = Date()
    
    let messageImages: [UIImage] = [#imageLiteral(resourceName: "img1"), #imageLiteral(resourceName: "img2")]
    let emojis = [
        "👍",
        "😂😂😂",
        "👋👋👋",
        "😱😱😱",
        "😃😃😃",
        "❤️"
    ]
    
    let attributes = ["Font1", "Font2", "Font3", "Font4", "Color", "Combo"]
    
    let locations: [CLLocation] = [
        CLLocation(latitude: 37.3118, longitude: -122.0312),
        CLLocation(latitude: 33.6318, longitude: -100.0386),
        CLLocation(latitude: 29.3358, longitude: -108.8311),
        CLLocation(latitude: 39.3218, longitude: -127.4312),
        CLLocation(latitude: 35.3218, longitude: -127.4314),
        CLLocation(latitude: 39.3218, longitude: -113.3317)
    ]

    let sounds: [URL] = [Bundle.main.url(forResource: "sound1", withExtension: "m4a")!,
                         Bundle.main.url(forResource: "sound2", withExtension: "m4a")!
    ]

    func attributedString(with text: String) -> NSAttributedString {
        let nsString = NSString(string: text)
        var mutableAttributedString = NSMutableAttributedString(string: text)
        let randomAttribute = Int(arc4random_uniform(UInt32(attributes.count)))
        let range = NSRange(location: 0, length: nsString.length)
        
        switch attributes[randomAttribute] {
        case "Font1":
            mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: range)
        case "Font2":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: range)
        case "Font3":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Font4":
            mutableAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Color":
            mutableAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: range)
        case "Combo":
            let msg9String = "Use .attributedText() to add bold, italic, colored text and more..."
            let msg9Text = NSString(string: msg9String)
            let msg9AttributedText = NSMutableAttributedString(string: String(msg9Text))
            
            msg9AttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSRange(location: 0, length: msg9Text.length))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: msg9Text.range(of: ".attributedText()"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "bold"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "italic"))
            msg9AttributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: msg9Text.range(of: "colored"))
            mutableAttributedString = msg9AttributedText
        default:
            fatalError("Unrecognized attribute for mock message")
        }
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }

    func dateNow() -> Date {
        return Date()
    }
    

    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }
    
    func randomMessageType() -> MessageTypes {
        var messageTypes = [MessageTypes]()
        for type in MessageTypes.allCases {
            if UserDefaults.standard.bool(forKey: "\(type.rawValue)" + " Messages") {
                messageTypes.append(type)
            }
        }
        return messageTypes.random()!
    }

    // swiftlint:disable cyclomatic_complexity
    func randomMessage(allowedSenders: [MockUser]) -> MockMessage {
        let randomNumberSender = Int(arc4random_uniform(UInt32(allowedSenders.count)))
        
        let uniqueID = UUID().uuidString
        let user = allowedSenders[randomNumberSender]
        let date = dateAddingRandomTime()

        switch randomMessageType() {
        case .Text:
            let randomSentence = Lorem.sentence()
            return MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
        case .AttributedText:
            let randomSentence = Lorem.sentence()
            let attributedText = attributedString(with: randomSentence)
            return MockMessage(attributedText: attributedText, user: user, messageId: uniqueID, date: date)
        case .Photo:
            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
            let image = messageImages[randomNumberImage]
            return MockMessage(image: image, user: user, messageId: uniqueID, date: date)
        case .Video:
            let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
            let image = messageImages[randomNumberImage]
            return MockMessage(thumbnail: image, user: user, messageId: uniqueID, date: date)
        case .Audio:
            let randomNumberSound = Int(arc4random_uniform(UInt32(sounds.count)))
            let soundURL = sounds[randomNumberSound]
            return MockMessage(audioURL: soundURL, user: user, messageId: uniqueID, date: date)
        case .Emoji:
            let randomNumberEmoji = Int(arc4random_uniform(UInt32(emojis.count)))
            return MockMessage(emoji: emojis[randomNumberEmoji], user: user, messageId: uniqueID, date: date)
        case .Location:
            let randomNumberLocation = Int(arc4random_uniform(UInt32(locations.count)))
            return MockMessage(location: locations[randomNumberLocation], user: user, messageId: uniqueID, date: date)
        case .Url:
            return MockMessage(text: "https://github.com/MessageKit", user: user, messageId: uniqueID, date: date)
        case .Phone:
            return MockMessage(text: "123-456-7890", user: user, messageId: uniqueID, date: date)
        case .Custom:
            return MockMessage(custom: "Someone left the conversation", user: system, messageId: uniqueID, date: date)
        case .ShareContact:
            let randomContact = Int(arc4random_uniform(UInt32(contactsToShare.count)))
            return MockMessage(contact: contactsToShare[randomContact], user: user, messageId: uniqueID, date: date)
        }
    }
    // swiftlint:enable cyclomatic_complexity

    func getMessages1(initial: String, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        let uniqueID = UUID().uuidString
        let user = SampleData.shared.banking
        let date = dateNow()
        let randomSentence = initial
        let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
        messages.append(message)
        completion(messages)
    }
    
    func getMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var initial = "AWelcome"
        //self.callNetworkAF(completion: initial)
        
        var messages: [MockMessage] = []
        let uniqueID = UUID().uuidString
        let user = SampleData.shared.banking
        let date = dateAddingRandomTime()
        let randomSentence = initial
        let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
        messages.append(message)
        completion(messages)
    }
    
    func callNetworkAF(completion: @escaping (String) -> Void) {
        let urlString = "http://192.168.7.165:6666/assistant/api/v2/assistants/b7d8c8fe-0e39-4fd5-bfc0-e9b22868c1cb/sessions"
        AF.request(urlString).responseJSON { response in
            guard let value = response.value else {
                        print("Error while fetching tags: \(String(describing: response.error))")
                        completion("")
                        return
                }
                
                let json = try? JSON(value)
                let sessionId = json!["session_id"].stringValue
                print("Sessionid " + sessionId)
                completion(sessionId)
                print("Sessionid2 " + sessionId)

         }
     }
    
    func callNetwork() -> String {
        var initial = "not set"
        let sessionEndpoint: String = "http://192.168.7.165:6666/assistant/api/v2/assistants/b7d8c8fe-0e39-4fd5-bfc0-e9b22868c1cb/sessions"
        guard let url = URL(string: sessionEndpoint) else {
            print("Error: cannot create URL " + sessionEndpoint)
            return "Error: cannot create URL " + sessionEndpoint
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
                
                let networkAndJosn = NetworkAndJson()
                initial = networkAndJosn.getSession(responseData: responseData)
            }
        }
        task.resume()
        
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
                
                let networkAndJosn = NetworkAndJson()
                initial = networkAndJosn.getInitialMessage(responseData: responseData)
            }
        }
        task2.resume()
        return initial
    }

    func getAdvancedMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Enable Custom Messages
        UserDefaults.standard.set(true, forKey: "Custom Messages")
        for _ in 0..<count {
            let message = randomMessage(allowedSenders: senders)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getMessages(count: Int, allowedSenders: [MockUser], completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        // Disable Custom Messages
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = senders.random()!
            let date = dateAddingRandomTime()
            let randomSentence = Lorem.sentence()
            let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getBankingMessages(completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        let uniqueID = UUID().uuidString
        let user = SampleData.shared.banking
        let date = dateAddingRandomTime()
        let randomSentence = "Welcome Marco"
        let message = MockMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
    }

    func getAvatarFor(sender: SenderType) -> Avatar {
        let firstName = sender.displayName.components(separatedBy: " ").first
        let lastName = sender.displayName.components(separatedBy: " ").first
        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
        switch sender.senderId {
        case "000001":
            return Avatar(image: #imageLiteral(resourceName: "Nathan-Tannar"), initials: initials)
        case "000002":
            return Avatar(image: #imageLiteral(resourceName: "Steven-Deutsch"), initials: initials)
        case "000003":
            return Avatar(image: #imageLiteral(resourceName: "Wu-Zhong"), initials: initials)
        case "000004":
            return Avatar(image: #imageLiteral(resourceName: "mkorglogo"), initials: initials)
        case "000005":
            return Avatar(image: #imageLiteral(resourceName: "Marco-Fanti"), initials: initials)
        case "000000":
            return Avatar(image: nil, initials: "SS")
        default:
            return Avatar(image: nil, initials: initials)
        }
    }

}
