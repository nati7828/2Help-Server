import Foundation
import Kitura
import LoggerAPI

class SecurityTwo{
    static public func postAddItemsToWarehouse(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Adds items to warehouse
        Log.debug("POST - /addItems route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToDoubleArray(data: data)
            if(Auth.clearance(array[0][0]) > 1){
                Queries.addItems(array: array, handler: {flag in
                    if flag{
                        try! response.status(.OK).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            }
        }
    }
    
    static public func postGetItemsFromWarehouse(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Returns warehouse items
        Log.debug("POST - /warehouse_items route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if(Auth.clearance(array[0]) > 1){
                DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.warehouse_items;", handler: {products in
                    if let pro = products{
                        try! response.status(.OK).send(json: pro).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            }
        }
    }
    
    static public func postAddReason(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Adds reason for exception in items count that came to the warehouse
        Log.debug("POST - /add_reason route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if Auth.clearance(array[0]) > 1{
                Queries.addReason(array: array, handler: { worked in
                    if worked{
                        try! response.status(.OK).send(json: true).end()
                    } else {
                        try! response.status(.OK).send(json: false).end()
                    }
                })
            } else {
                try response.status(.OK).end()
            }
        } else {
            try response.status(.OK).end()
        }
    }
}
