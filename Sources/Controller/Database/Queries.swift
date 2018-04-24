//
//  Queries.swift
//  Controller
//
//  Created by Alona Tov on 18/02/2018.
//

import Foundation

class Queries{
//    static func getAllItemsByType(type: String, handler: @escaping (Bool)->()) -> [[String]]?{
//        return DBManager.execute("SELECT * FROM ibmx_9c7dd3225c8f81b.items WHERE category = '\(type)' ORDER BY type ASC;")
//    }
    
    static func getItemByBarcode(barcode: String, handler: @escaping ([[String]]?) -> ()){
        DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.items WHERE `barcode` = '\(barcode)';", handler: handler)
    }
    
//    static func getAllItemsTypes() -> [[String]]?{
//        return DBManager.execute("SELECT * FROM ibmx_9c7dd3225c8f81b.items_type;")
//    }
    
    static func addItems(array: [[String]], handler: @escaping (Bool)->()){
        //Adds items count from double array to warehouse database
        DBManager.start()
        itemsWarehouseBranch(array: array, index: 1, handler: handler)
    }
    
    static func itemsWarehouseBranch(array: [[String]], index: Int, handler: @escaping (Bool)->()){
        //array[0][1] = warehouse address
        //[0] = id
        //[1] = product name
        //[2] = item count to update
        let query = "UPDATE `ibmx_9c7dd3225c8f81b`.`warehouse_items` SET `count` = `count` + \(array[index][2]) WHERE `warehouse_address` = '\(array[0][1])' AND `item_name` = '\(array[index][1])'; "
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if index != array.count - 1{
                if !queryResult.success  {
                    handler(false)
                }
                self.itemsWarehouseBranch(array: array, index: index + 1, handler: handler)
            } else {
                if queryResult.success  {
                    statusUpdate(array: ["", "סיים", array[1][0]], handler: handler)
                } else {
                    handler(false)
                }
            }
        })
    }
    
    static func addItemsRequest(array: [[String]], handler: @escaping (Bool)->()){
        //Adds request and items for the request into the database
        DBManager.start()
        //array[0][0] = name
        //array[0][1] = address
        //array[0][2] = phone
        //array[0][3] = notice
        DBManager.dbConnection.execute("INSERT INTO `ibmx_9c7dd3225c8f81b`.`donators` (`name`,`address`,`phone`,`notice`,`date`) VALUES ('\(array[0][0])','\(array[0][1])','\(array[0][2])','\(array[0][3])','\(generateDate())');", onCompletion: {queryResult in
            if queryResult.success{
                DBManager.execute(query: "SELECT `donators`.`id` FROM `ibmx_9c7dd3225c8f81b`.`donators` WHERE `donators`.`name` = '\(array[0][0])' AND `donators`.`address` = '\(array[0][1])' AND `donators`.`phone` = '\(array[0][2])' AND `donators`.`notice` = '\(array[0][3])' ORDER BY `id` DESC;", handler: {idsDB in
                    if let ids = idsDB{
                        var arr = array
                        arr[0].append(ids[0][0])
                        itemsRequestBranch(array: arr, index: 1, handler: handler)
                    }
                })
            } else {
                handler(false)
            }
        })
    }
    
    static func itemsRequestBranch(array: [[String]], index: Int, handler: @escaping (Bool)->()){
        //array[0][4] = id
        //[0] = product name
        //[1] = item count to update
        let query = "INSERT INTO `ibmx_9c7dd3225c8f81b`.`donators_items` (`id`, `name`, `count`) VALUES ('\(array[0][4])', '\(array[index][0])', \(array[index][1]));"
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if index != array.count - 1{
                if !queryResult.success  {
                    handler(false)
                }
                self.itemsRequestBranch(array: array, index: index + 1, handler: handler)
            } else {
                if queryResult.success  {
                    handler(true)
                } else {
                    handler(false)
                }
            }
        })
    }
    
    static func generateDate() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: Date().addingTimeInterval(120.0 * 60.0))
    }
    
    static func createItems(array: [[String]], handler: @escaping (Bool)->()){
        //Adds items count from double array to warehouse database
        DBManager.start()
        var query = ""
        var first = true
        for product in array{
            //[0] = warehouse address
            //[1] = product name
            //[2] = item count to update
            if(first){
                first = false
            } else {
                query += "INSERT INTO `ibmx_9c7dd3225c8f81b`.`warehouse_items` (`warehouse_address`, `item_name`, `count`) VALUES (\(product[0]), \(product[1]), \(product[2]);"
            }
        }
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if queryResult.success  {
                handler(true)
            } else {
                handler(false)
            }
        })
    }
    
    static func addReason(array: [String], handler: @escaping (Bool)->()){
        //Adds items count from double array to warehouse database
        DBManager.start()
        //array[0] = token
        //array[1] = id
        //array[2] = reason
        //array[3] = items
        let query = "INSERT INTO `ibmx_9c7dd3225c8f81b`.`exception_reasons` (`id`, `reason`, `items`) VALUES (\(array[1]), '\(array[2])', '\(array[3])');"
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if queryResult.success  {
                handler(true)
            } else {
                handler(false)
            }
        })
    }
    
    static func statusUpdate(array: [String], handler: @escaping (Bool)->()){
        //Changes requests status by id
        DBManager.start()
        //array[0] = token
        //array[1] = status
        //array[2] = id
        let query = "UPDATE `ibmx_9c7dd3225c8f81b`.`donators` SET `status` = '\(array[1])', `finish_date` = '\(generateDate())' WHERE `id` = '\(array[2])';"
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if queryResult.success{
                handler(true)
            } else {
                handler(false)
            }
        })
    }
    
    static func returnRequest(array: [String], handler: @escaping (Bool)->()){
        //Changes requests status by id
        DBManager.start()
        //array[0] = token
        //array[1] = id
        let query = "UPDATE `ibmx_9c7dd3225c8f81b`.`donators` SET `status` = 'מחכה', `delivery` = '' WHERE `id` = '\(array[1])';"
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if queryResult.success  {
                handler(true)
            } else {
                handler(false)
            }
        })
    }
    
    static func updateMyRequest(array: [String], handler: @escaping (Bool)->()){
        //Changes requests status by id
        DBManager.start()
        //array[0] = token
        //array[1] = id
        DBManager.execute(query: "SELECT `users`.`username` FROM `ibmx_9c7dd3225c8f81b`.`users` WHERE token = '\(array[0])';", handler: {username in
            if let name = username{
                DBManager.execute(query: "SELECT * FROM ibmx_9c7dd3225c8f81b.donators WHERE id = '\(array[1])';", handler: {request in
                    if let req = request{
                        if req[0][6] == ""{
                            let query = "UPDATE `ibmx_9c7dd3225c8f81b`.`donators` SET `status` = '\("מחכה לשליח")', `delivery` = '\(name[0][0])' WHERE `id` = \(array[1]);"
                            DBManager.dbConnection.execute(query, onCompletion: { queryResult in
                                if queryResult.success  {
                                    handler(true)
                                } else {
                                    handler(false)
                                }
                            })
                        } else {
                            handler(false)
                        }
                    } else {
                        handler(false)
                    }
                })
            } else {
                handler(false)
            }
        })
    }
    
//    static func getRequest(id: String) -> [[String]]?{
//        return DBManager.execute("SELECT * FROM ibmx_9c7dd3225c8f81b.donators WHERE id = '\(id)';")
//    }
    
    static func userUpdate(array: [String], handler: @escaping (Bool)->()){
        //Changes requests status by id
        DBManager.start()
        //array[0] = id
        //array[1] = name
        //array[2] = password
        //array[3] = job
        //array[4] = full name
        //array[5] = phone
        //array[6] = address
        let query: String!
        if array[2] == ""{
            query = "UPDATE `ibmx_9c7dd3225c8f81b`.`users` SET `username` = '\(array[1])', `job` = '\(array[3])', `full_name` = '\(array[4])', `phone` = '\(array[5])', `address` = '\(array[6])' WHERE `id` = \(array[0]);"
        } else {
            query = "UPDATE `ibmx_9c7dd3225c8f81b`.`users` SET `username` = '\(array[1])', `password` = '\(array[2])', `job` = '\(array[3])', `full_name` = '\(array[4])', `phone` = '\(array[5])', `address` = '\(array[6])' WHERE `id` = \(array[0]);"
        }
        DBManager.dbConnection.execute(query, onCompletion: { queryResult in
            if queryResult.success  {
                handler(true)
            } else {
                handler(false)
            }
        })
    }
}
