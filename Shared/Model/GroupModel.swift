struct GroupLists:Decodable{
    let results: [Group]?
    let eventList:[Group]?
    let groupList:[Group]?
}
//Hashable
struct Group:Identifiable,Decodable {
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
    
}
struct GroupMember:Decodable {
    let result:[Member]
    class Member:Decodable,Identifiable {
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
struct PublicGroups:Decodable{
    let result:[Name]
    class Name:Decodable,Identifiable {
        var name:String
        init(name:String) {
            self.name = name
        }
        
        enum CodingKeys:String, CodingKey {
            case name = "group_name"
        }
    }
}
struct GroupNotification:Decodable {
    var result:[GroupNotification.Info]?
    var message:String
    
    init(result:[GroupNotification.Info], message:String) {
        self.result = result
        self.message = message
    }
    class Info:Decodable, Identifiable,Equatable{
        var name:String
        var sender:String
        var type:String
        var id:Int
        
        init(name:String,sender:String,type:String,id:Int) {
            self.name = name
            self.sender = sender
            self.type = type
            self.id = id
        }
        
        enum CodingKeys:String, CodingKey {
            case name = "group_name"
            case sender = "sender_name"
            case type = "group_role"
            case id = "group_id"
        }
        static func == (lhs: GroupNotification.Info, rhs: GroupNotification.Info) -> Bool {
            if lhs.id == rhs.id {
                return true
            }
            else {
                return false
            }
        }
    }
}


struct Message:Decodable {
    var message:String
}


