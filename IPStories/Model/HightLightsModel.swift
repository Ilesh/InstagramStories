
import Foundation

public class HightLightsModel {
	public var author_id : Int?
	public var name : String?
    public var totalPage : Int?    
	public var avatar_url : String?
    public var isSeen : Bool = true
	var activities : [Activity]?

    init(authorId:Int,name:String,avatar_url:String,activity:[Activity],isSeen:Bool) {
        self.author_id = authorId
        self.name = name
        self.avatar_url = avatar_url
        self.activities = activity
        self.isSeen = isSeen
    }
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [HightLightsModel]
    {
        var models:[HightLightsModel] = []
        for item in array
        {
            models.append(HightLightsModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
		author_id = dictionary["author_id"] as? Int
        totalPage = dictionary["total_pages"] as? Int
		name = dictionary["name"] as? String
		avatar_url = dictionary["avatar_url"] as? String
        isSeen = dictionary["seen"] as? Bool ?? true
        if (dictionary["activities"] != nil) { activities = Activity.modelsFromDictionaryArray(array: dictionary["activities"] as! NSArray) }
	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.author_id, forKey: "author_id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.avatar_url, forKey: "avatar_url")
        dictionary.setValue(self.isSeen, forKey: "seen")
        dictionary.setValue(self.totalPage, forKey: "total_pages")
		return dictionary
	}

}
