/**
 * Copyright IBM Corporation 2016,2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Kitura
import Foundation
import LoggerAPI
import CloudEnvironment
import Health

struct Project: Codable {
    let framework: String
    let applicationName: String
    let company: String
    let organization: String
    let location: String
}

public class Controller {
    
    public let router: Router
    let cloudEnv: CloudEnv
    let health: Health
    
    public var port: Int {
        get { return cloudEnv.port }
    }
    
    public var url: String {
        get { return cloudEnv.url }
    }
    
    public init() {
        // Create CloudEnv instance
        cloudEnv = CloudEnv()
        
        // All web apps need a Router instance to define routes
        router = Router()
        
        // Instance of health for reporting heath check values
        health = Health()
        
        // Serve static content from "public"
        router.all("/", middleware: StaticFileServer())
        
        
        
        /////////////////////////
        //Security Normal level//
        /////////////////////////
        
        // JSON Get all items types
        router.post("/itemstypes", handler: SecurityNormal.postItemsTypes)
        
        // JSON Get items from db by type
        router.post("/items", handler: SecurityNormal.postItems)
        
        // JSON gets item by barcode
        router.post("/barcode", handler: SecurityNormal.postItemByBarcode)
        
        // JSON login for the user generate and returns user token as well retuns with it user job
        router.post("/login", handler: SecurityNormal.postLogin)
        
        // JSON login with token only returns user job
        router.post("/token_login", handler: SecurityNormal.postTokenLogin)
        
        // JSON Get locations by location type
        router.post("/locations", handler: SecurityNormal.postLocations)
        
        // JSON adds request
        router.post("/add_request", handler: SecurityNormal.postAddRequest)
        
        // JSON gets all images/video urls that stored in db for the main page
        router.post("/images", handler: SecurityNormal.postImages)
        
        
        
        //////////////////////
        //Security level one//
        //////////////////////
        
        // JSON Get requests by status
        router.post("/requests", handler: SecurityOne.postRequests)
        
        // JSON Get request by id
        router.post("/request", handler: SecurityOne.postRequest)
        
        // JSON changes the delivery and status of a request for delivery
        router.post("/add_my_request", handler: SecurityOne.postAddMyRequest)
        
        // JSON Gets delivery requests by token
        router.post("/myrequests", handler: SecurityOne.postMyRequests)
        
        // JSON Gets request items
        router.post("/request_items", handler: SecurityOne.postRequestItems)
        
        // JSON changes the status of a request
        router.post("/request_status_change", handler: SecurityOne.postRequestStatusChange)
        
        // JSON return request back to map
        router.post("/return_request", handler: SecurityOne.postReturnRequest)
        
        
        
        //////////////////////
        //Security level two//
        //////////////////////
        
        // JSON adds items to warehouse
        router.post("/addItems", handler: SecurityTwo.postAddItemsToWarehouse)
        
        // JSON adds reason
        router.post("/add_reason", handler: SecurityTwo.postAddReason)
        
        // JSON returns warehouse items
        router.post("/warehouse_items", handler: SecurityTwo.postGetItemsFromWarehouse)
        
        
        
        ////////////////////////
        //Security level three//
        ////////////////////////
        
        // JSON gets all current users in db
        router.post("/all_users", handler: SecurityThree.postAllUsers)
        
        // JSON gets all items that can be stored in a warehouse
        router.post("/all_items", handler: SecurityThree.postAllItems)
        
        // JSON gets all locations
        router.post("/all_locations", handler: SecurityThree.postAllLocations)
        
        // JSON adds user to db
        router.post("/add_user", handler: SecurityThree.postAddUser)
        
        // JSON update user data
        router.post("/update_user", handler: SecurityThree.postUpdateUser)
        
        // JSON deletes user
        router.post("/delete_user", handler: SecurityThree.postDeleteUser)
    }
    
    static func jsonToArray(data: String) throws -> [String]{
        return try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: .mutableContainers) as! [String]
    }
    
    static func jsonToDoubleArray(data: String) throws -> [[String]]{
        return try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: .mutableContainers) as! [[String]]
    }
}

