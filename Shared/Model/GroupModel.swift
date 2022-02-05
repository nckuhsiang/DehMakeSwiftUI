class GroupLists:Decodable{
    let results: [Group]?
    let eventList:[Group]?
    let groupList:[Group]?
}
//Hashable
class Group:Identifiable,Decodable {
    
    var id:Int
    var name:String
    var leaderId:Int?
    var info:String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case leaderId = "learderId"
        case info = "group_info"
    }
    init(id:Int,name:String, leaderId:Int, info:String) {
        self.id = id
        self.name = name
        self.leaderId = leaderId
        self.info = info
    }
}
