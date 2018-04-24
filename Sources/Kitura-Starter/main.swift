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

// Kitura-Starter contains examples for creating custom routes.
import Kitura
import LoggerAPI
import HeliumLogger
import Controller

// HeliumLogger disables all buffering on stdout
HeliumLogger.use(LoggerMessageType.info)

// Create Controller
let controller = Controller()
Log.info("Server will be started on '\(controller.url)'.")

// Condifure Kitura
Kitura.addHTTPServer(onPort: controller.port, with: controller.router)

// Start Kitura-Starter server
Kitura.run()
