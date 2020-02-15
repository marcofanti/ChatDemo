//
//	Output.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Output : NSObject, NSCoding{

	var entities : [Entity]!
	var generic : [Generic]!
	var intents : [Intent]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		entities = [Entity]()
		let entitiesArray = json["entities"].arrayValue
		for entitiesJson in entitiesArray{
			let value = Entity(fromJson: entitiesJson)
			entities.append(value)
		}
		generic = [Generic]()
		let genericArray = json["generic"].arrayValue
		for genericJson in genericArray{
			let value = Generic(fromJson: genericJson)
			generic.append(value)
		}
		intents = [Intent]()
		let intentsArray = json["intents"].arrayValue
		for intentsJson in intentsArray{
			let value = Intent(fromJson: intentsJson)
			intents.append(value)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if entities != nil{
			var dictionaryElements = [[String:Any]]()
			for entitiesElement in entities {
				dictionaryElements.append(entitiesElement.toDictionary())
			}
			dictionary["entities"] = dictionaryElements
		}
		if generic != nil{
			var dictionaryElements = [[String:Any]]()
			for genericElement in generic {
				dictionaryElements.append(genericElement.toDictionary())
			}
			dictionary["generic"] = dictionaryElements
		}
		if intents != nil{
			var dictionaryElements = [[String:Any]]()
			for intentsElement in intents {
				dictionaryElements.append(intentsElement.toDictionary())
			}
			dictionary["intents"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         entities = aDecoder.decodeObject(forKey: "entities") as? [Entity]
         generic = aDecoder.decodeObject(forKey: "generic") as? [Generic]
         intents = aDecoder.decodeObject(forKey: "intents") as? [Intent]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if entities != nil{
			aCoder.encode(entities, forKey: "entities")
		}
		if generic != nil{
			aCoder.encode(generic, forKey: "generic")
		}
		if intents != nil{
			aCoder.encode(intents, forKey: "intents")
		}

	}

}