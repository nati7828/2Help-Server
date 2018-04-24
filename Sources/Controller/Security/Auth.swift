import Foundation

public class Auth{
    
    public static func clearance(_ token: String) -> Int{
        var back = -1
        if let array = DBManager.execute("SELECT `users`.`job` FROM `ibmx_9c7dd3225c8f81b`.`users` WHERE token = '\(token)';"){
            if array.count > 0{
                switch(array[0][0]){
                case "שליח":
                    back = 1
                    break
                case "מחסנאי":
                    back = 2
                    break
                case "מנהל רשת":
                    back = 3
                    break
                default:
                    break
                }
            }
        }
        return back
    }
    
    public static func insertToken(token: String, username: String, handler: @escaping (Bool)->()){
        DBManager.start()
        DBManager.dbConnection.execute("UPDATE `ibmx_9c7dd3225c8f81b`.`users` SET `token` = \(token) WHERE `username` = '\(username)';", onCompletion: { queryResult in
            if queryResult.success  {
                handler(true)
            } else {
                handler(false)
            }
        })

    }
    
    public static func generateToken() -> String{
        var token: String = "-1"
        DBManager.start()
        for _ in 1...3{
            let temp = (String(Int(drand48() * 1000000000) + 999999) + String(Int(drand48() * 1000000000) + 999999))
            if let tokens = DBManager.execute("SELECT token FROM ibmx_9c7dd3225c8f81b.users WHERE token = '\(temp)';"){
                if tokens.count <= 0{
                    token = temp
                    break
                }
            }
        }
        return token
    }
}
