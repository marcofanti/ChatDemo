//
//	Intent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Intent : NSObject, NSCoding{

	var confidence : Float!
	var intent : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		confidence = json["confidence"].floatValue
		intent = json["intent"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if confidence != nil{
			dictionary["confidence"] = confidence
		}
		if intent != nil{
			dictionary["intent"] = intent
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         confidence = aDecoder.decodeObject(forKey: "confidence") as? Float
         intent = aDecoder.decodeObject(forKey: "intent") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if confidence != nil{
			aCoder.encode(confidence, forKey: "confidence")
		}
		if intent != nil{
			aCoder.encode(intent, forKey: "intent")
		}

	}

}