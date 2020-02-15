//
//	Option.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Option : NSObject, NSCoding{

	var label : String!
	var value : Value!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		label = json["label"].stringValue
		let valueJson = json["value"]
		if !valueJson.isEmpty{
			value = Value(fromJson: valueJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if label != nil{
			dictionary["label"] = label
		}
		if value != nil{
			dictionary["value"] = value.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         label = aDecoder.decodeObject(forKey: "label") as? String
         value = aDecoder.decodeObject(forKey: "value") as? Value

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if label != nil{
			aCoder.encode(label, forKey: "label")
		}
		if value != nil{
			aCoder.encode(value, forKey: "value")
		}

	}

}