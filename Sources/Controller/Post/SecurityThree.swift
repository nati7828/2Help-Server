import Foundation
import Kitura
import LoggerAPI

class SecurityThree{
    static public func postAllUsers(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Get all users in db
        Log.debug("POST - /all_users route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if Auth.clearance(array[0]) > 2{
                DBManager.execute(query: "SELECT `users`.`id`, `users`.`username`, `users`.`job`, `users`.`full_name`, `users`.`phone`, `users`.`address` FROM `ibmx_9c7dd3225c8f81b`.`users`;", handler: {array in
                    if let arr = array{
                        try! response.status(.OK).send(json: arr).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            } else {
                try response.status(.OK).end()
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postAllItems(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Get all items in db
        Log.debug("POST - /all_items route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if Auth.clearance(array[0]) > 2{
                DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.items;", handler: {array in
                    if let arr = array{
                        try! response.status(.OK).send(json: arr).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            } else {
                //"Security level to low
                try response.status(.OK).end()
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postAllLocations(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Gets all locations in db
        Log.debug("POST - /all_locations route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if Auth.clearance(array[0]) > 2{
                DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.locations;", handler: {array in
                    if let arr = array{
                        try! response.status(.OK).send(json: arr).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            } else {
                //"Security level to low
                try response.status(.OK).end()
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postAddUser(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Adds user to db
        Log.debug("POST - /add_reason route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToDoubleArray(data: data)
            if Auth.clearance(array[0][0]) > 2{
                DBManager.dbConnection.execute("INSERT INTO `ibmx_9c7dd3225c8f81b`.`users` (`username`, `password`, `job`, `full_name`, `phone`, `address`) VALUES ('\(array[1][0])', '\(array[1][1])', '\(array[1][2])', '\(array[1][3])', '\(array[1][4])', '\(array[1][5])');", onCompletion: {queryResult in
                    if queryResult.success{
                        try! response.status(.OK).send(json: true).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            } else {
                //"Security level to low
                try response.status(.OK).send(json: "Security level to low.").end()
            }
        } else {
            try response.status(.OK).send(json: "Error failed to add items.").end()
        }
    }
    
    static public func postUpdateUser(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Updates user info
        Log.debug("POST - /add_reason route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToDoubleArray(data: data)
            if Auth.clearance(array[0][0]) > 2{
                Queries.userUpdate(array: array[1], handler: {works in
                    if works{
                        try! response.status(.OK).send(json: true).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            } else {
                //Security level to low
                try response.status(.OK).end()
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postDeleteUser(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Delets user from db
        //Must never be done but because its only a demo and our time is limited its exists
        Log.debug("POST - /delete_user route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToDoubleArray(data: data)
            if Auth.clearance(array[0][0]) > 2{
                DBManager.dbConnection.execute("DELETE FROM `ibmx_9c7dd3225c8f81b`.`users` WHERE `id` = \(array[1][0]);", onCompletion: {queryResult in
                    if queryResult.success{
                        try! response.status(.OK).send(json: true).end()
                    } else {
                        try! response.status(.OK).send(json: "Faield").end()
                    }
                })
            } else {
                //Security level to low
                try response.status(.OK).end()
            }
        } else {
            try response.status(.OK).end()
        }
    }
}
