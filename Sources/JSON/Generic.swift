//
//	Generic.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Generic : NSObject, NSCoding{

	var options : [Option]!
	var responseType : String!
	var text : String!
	var title : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		options = [Option]()
		let optionsArray = json["options"].arrayValue
		for optionsJson in optionsArray{
			let value = Option(fromJson: optionsJson)
			options.append(value)
		}
		responseType = json["response_type"].stringValue
		text = json["text"].stringValue
		title = json["title"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if options != nil{
			var dictionaryElements = [[String:Any]]()
			for optionsElement in options {
				dictionaryElements.append(optionsElement.toDictionary())
			}
			dictionary["options"] = dictionaryElements
		}
		if responseType != nil{
			dictionary["response_type"] = responseType
		}
		if text != nil{
			dictionary["text"] = text
		}
		if title != nil{
			dictionary["title"] = title
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         options = aDecoder.decodeObject(forKey: "options") as? [Option]
         responseType = aDecoder.decodeObject(forKey: "response_type") as? String
         text = aDecoder.decodeObject(forKey: "text") as? String
         title = aDecoder.decodeObject(forKey: "title") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if options != nil{
			aCoder.encode(options, forKey: "options")
		}
		if responseType != nil{
			aCoder.encode(responseType, forKey: "response_type")
		}
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}