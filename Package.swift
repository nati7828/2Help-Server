// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

/**
 * Copyright IBM Corporation 2016, 2017
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

import PackageDescription

let package = Package(
    name: "KituraStarter",
    products: [
      .executable(
        name: "Kitura-Starter",
        targets:  ["Kitura-Starter", "Controller"]
      )
    ],
    dependencies: [
      .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.2.0")),
      .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMajor(from: "1.7.1")),
      .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", .upToNextMajor(from: "6.0.0")),
      .package(url: "https://github.com/IBM-Swift/Health.git", .upToNextMajor(from: "1.0.0")),
      .package(url: "https://github.com/IBM-Swift/Swift-Kuery.git", .upToNextMajor(from: "1.0.0")), //The connecting
      .package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", .upToNextMajor(from: "1.0.1")), //The connection
      .package(url: "https://github.com/IBM-Swift/CMySQL.git", .upToNextMajor(from: "0.1.2")), //Nessesry
    ],
    targets: [
      .target(
        name: "Kitura-Starter",
        dependencies: ["Kitura", "HeliumLogger", "Controller", "SwiftKuery", "SwiftKueryMySQL", "CMySQL"]
      ),
      .target(
        name: "Controller",
        dependencies: ["Kitura", "CloudEnvironment", "Health"]
      ),
      .testTarget(
        name: "ControllerTests",
        dependencies: ["Controller"]
      )
    ]
)
