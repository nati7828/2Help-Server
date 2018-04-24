import Foundation
import SwiftKuery
import SwiftKueryMySQL

class DBManager{
    //Using MySQLThreadSafeConnection instead of MySQLConnection because the server using handlers in threads other than the main thread
    static var dbConnection: MySQLThreadSafeConnection!
    
    static public func start(){
        if dbConnection == nil{
            let HOST = "eu-cdbr-sl-lhr-01.cleardb.net"
            let USER = "b0f35264eecf9f"
            let PASSWORD = "d9ff9302"
            let DATABASE = "ibmx_9c7dd3225c8f81b"
            let PORT = 3306
            
            dbConnection = MySQLThreadSafeConnection(host: HOST, user: USER, password: PASSWORD, database: DATABASE, port: PORT)
            
            dbConnection.connect() { error in
                if error != nil{
                    //If the connection failed
                    //start()
                }
            }
        }
    }
    
    static public func execute(_ query: String) -> [[String]]?{
        start()
        var back: [[String]]?
        dbConnection.execute(query) { queryResult in
            var b: [[String]] = []
            if let rows = queryResult.asRows{
                if(rows.count > 0){
                    for x in 0...rows.count - 1{
                        if let result = queryResult.asResultSet{
                            b.append([])
                            for str in result.titles{
                                if let any = rows[x][str]{
                                    if let a = any{
                                        b[x].append(String(describing: a))
                                    }
                                }
                            }
                        }
                    }
                }
                back = b
            }
        }
        return back
    }
    
    static public func execute(query: String, handler: @escaping ([[String]]?) -> ()){
        start()
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if queryResult.success {
                var back: [[String]] = []
                if let rows = queryResult.asRows{
                    if(rows.count > 0){
                        for x in 0...rows.count - 1{
                            if let result = queryResult.asResultSet{
                                back.append([])
                                for str in result.titles{
                                    if let any = rows[x][str]{
                                        if let a = any{
                                            back[x].append(String(describing: a))
                                        }
                                    }
                                }
                            }
                        }
                        handler(back)
                    }
                }
            } else {
                handler(nil)
            }
        })
    }
}

