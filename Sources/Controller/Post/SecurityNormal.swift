import Foundation
import Kitura
import LoggerAPI

class SecurityNormal{
    static public func postItemsTypes(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Get all items types
        Log.debug("POST - /items route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.items_type;", handler: {itemsTypes in
            if let items = itemsTypes{
                try! response.status(.OK).send(json: items).end()
            }
        })
    }
    
    static public func postItems(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Get items from db by type
        //array[0] = type
        Log.debug("POST - /items route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.items WHERE category = '\(array[0])' ORDER BY type ASC;", handler: {itemsArray in
                if let items = itemsArray{
                    try! response.status(.OK).send(json: items).end()
                }
            })
        }
    }
    
    static public func postItemByBarcode(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Returns item by barcode
        //array[0] = barcode
        Log.debug("POST - /barcode route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            Queries.getItemByBarcode(barcode: array[0], handler: {items in
                try! response.status(.OK).send(json: items).end()
            })
        }
    }
    
    static public func postLogin(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Login for the users generate and returns user token as well retun users job
        Log.debug("POST - /login route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            DBManager.execute(query: "SELECT `users`.`job` FROM `ibmx_9c7dd3225c8f81b`.`users` WHERE username = '\(array[0])' AND password = '\(array[1])';", handler: {userArray in
                if let arr = userArray{
                    if(arr.count > 0){
                        let token = Auth.generateToken()
                        if(token != "-1"){
                            Auth.insertToken(token: token, username: array[0], handler: {flag in
                                if flag{
                                    try! response.status(.OK).send(json: [token, arr[0][0]]).end()
                                } else {
                                    try! response.status(.OK).end()
                                }
                            })
                        } else {
                            try! response.status(.OK).end()
                        }
                    } else {
                        try! response.status(.OK).end()
                    }
                } else {
                    try! response.status(.OK).end()
                }
            })
        }
    }
    
    static public func postTokenLogin(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Login with token only returns user job
        Log.debug("POST - /token_login route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            DBManager.execute(query: "SELECT `users`.`job` FROM `ibmx_9c7dd3225c8f81b`.`users` WHERE token = '\(array[0])';", handler: {userArray in
                if let arr = userArray{
                    if(arr.count > 0){
                        try! response.status(.OK).send(json: arr).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                }
            })
        }
    }
    
    static public func postLocations(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Get locations by location type
        Log.debug("POST - /locations route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.locations WHERE type = '\(array[0])';", handler: {locationsArray in
                if let locations = locationsArray{
                    try! response.status(.OK).send(json: locations).end()
                }
            })
        }
    }
    
    static public func postAddRequest(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Adds donators request
        Log.debug("POST - /add_request route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToDoubleArray(data: data)
            Queries.addItemsRequest(array: array, handler: {flag in
                if flag{
                    try! response.status(.OK).send(json: true).end()
                } else {
                    try! response.status(.OK).end()
                }
            })
        }
    }
    
    static public func postImages(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Gets all images in urls db
        Log.debug("POST - /all_locations route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.images;", handler: {array in
            if let arr = array{
                try! response.status(.OK).send(json: arr).end()
            } else {
                try! response.status(.OK).end()
            }
        })
    }
}
