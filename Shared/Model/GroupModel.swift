class GroupLists:Decodable{
    let results: [Group]?
    let eventList:[Group]?
    let groupList:[Group]?
}
//Hashable
class Group:Identifiable,Decodable {
    var id:Int
    var name:String
    var leaderId:Int
    var info:String
    
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
class GroupMemberList:Decodable {
    let result:[GroupMember]
    class GroupMember:Decodable,Identifiable {
        var name:String
        var role:String
        enum CodingKeys:String, CodingKey {
            case name = "member_name"
            case role = "member_role"
        }
        init(name:String, role:String) {
            self.name = name
            self.role = role
        }
    }
}
class PublicGroupList:Decodable{
    let result:[PublicGroup]
    class PublicGroup:Decodable,Identifiable {
        var name:String
        init(name:String) {
            self.name = name
        }
        
        enum CodingKeys:String, CodingKey {
            case name = "group_name"
        }
    }
}



class Message:Decodable {
    var message:String
}
