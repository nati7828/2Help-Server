import Foundation
import Kitura
import LoggerAPI

class SecurityOne{
    static public func postRequests(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Get requests by status
        Log.debug("POST - /requests route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            //array[0] = token
            //array[1] = request status
            //a מחכה
            //b מחכה לשליח
            //c נלקח
            //d סיים
            //e בוטל
            if Auth.clearance(array[0]) > 0{
                DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.donators WHERE status = '\(array[1])';", handler: {requests in
                    if let req = requests{
                        try! response.status(.OK).send(json: req).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postRequest(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Get request by id
        Log.debug("POST - /request route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            //array[0] = token
            //array[1] = id
            if Auth.clearance(array[0]) > 0{
                DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.donators WHERE id = '\(array[1])';", handler: { requestsArray in
                    if let requests = requestsArray{
                        try! response.status(.OK).send(json: requests).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postAddMyRequest(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Changes the delivery and status of a request for delivery
        Log.debug("POST - /add_my_request route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            //array[0] = token
            //array[1] = request id
            if Auth.clearance(array[0]) > 0{
                Queries.updateMyRequest(array: array, handler: {flag in
                    if flag{
                        try! response.status(.OK).send(json: true).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postMyRequests(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Gets delivery requests by token
        Log.debug("POST - /requests route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if Auth.clearance(array[0]) > 0{
                DBManager.execute(query: "SELECT donators.id, donators.name, donators.address, donators.phone, donators.notice, donators.status, donators.date FROM ibmx_9c7dd3225c8f81b.donators LEFT JOIN users ON donators.delivery = users.username WHERE users.token = '\(array[0])' AND NOT donators.status = 'בוטל' AND NOT donators.status = 'סיים';", handler: {donatorsArray in
                    if let donators = donatorsArray{
                        try! response.status(.OK).send(json: donators).end()
                    }
                })
            }
        }
    }
    
    static public func postRequestItems(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Gets the items of the request
        Log.debug("POST - /request_items route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            //array[0] = token
            //array[1] = request id
            if Auth.clearance(array[0]) > 0{
                DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.donators_items WHERE id = '\(array[1])';", handler: {requests in
                    if let req = requests{
                        try! response.status(.OK).send(json: req).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postRequestStatusChange(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Changes the status of a request
        Log.debug("POST - /request_status_change route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if Auth.clearance(array[0]) > 0{
                Queries.statusUpdate(array: array, handler: { queryResult in
                    if queryResult  {
                        try! response.status(.OK).send(json: true).end()
                    } else {
                        try! response.status(.OK).send(json: "Update failied.").end()
                    }
                })
            }
        } else {
            try response.status(.OK).end()
        }
    }
    
    static public func postReturnRequest(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        //Changes request status and removes the delivery name from it, by that returning the request to the map
        Log.debug("POST - /return_request route handler...")
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        if let data = try request.readString(){
            let array = try Controller.jsonToArray(data: data)
            if Auth.clearance(array[0]) > 0{
                Queries.returnRequest(array: array, handler: { queryResult in
                    if queryResult  {
                        try! response.status(.OK).send(json: true).end()
                    } else {
                        try! response.status(.OK).end()
                    }
                })
            }
        } else {
            try response.status(.OK).end()
        }
    }
}
