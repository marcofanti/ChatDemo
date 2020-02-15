//
//	Entity.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Entity : NSObject, NSCoding{

	var entityname : String!
	var entityvalue : Float!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		entityname = json["entityname"].stringValue
		entityvalue = json["entityvalue"].floatValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if entityname != nil{
			dictionary["entityname"] = entityname
		}
		if entityvalue != nil{
			dictionary["entityvalue"] = entityvalue
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         entityname = aDecoder.decodeObject(forKey: "entityname") as? String
         entityvalue = aDecoder.decodeObject(forKey: "entityvalue") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if entityname != nil{
			aCoder.encode(entityname, forKey: "entityname")
		}
		if entityvalue != nil{
			aCoder.encode(entityvalue, forKey: "entityvalue")
		}

	}

}