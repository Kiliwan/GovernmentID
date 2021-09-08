//
//  AppDelegate.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 16.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Alamofire
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    static var country: Countries = .che
    static var CHE_ID = ""
    static var JPN_ID = ""

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        Alamofire.request("\(AppDelegate.country.server_url())/list-publishers").responseJSON { response in
            let results = response.result.value as! [[String: Any]]
            for result in results {
                let data = result["data"] as! [String: Any]
                let json = data["json"] as! [String: String]
                let jsonData = Country(country: json["country"]!, address: json["address"]!)

                if jsonData.country == "Switzerland" {
                    AppDelegate.CHE_ID = jsonData.address
                } else if jsonData.country == "Japan" {
                    AppDelegate.JPN_ID = jsonData.address
                }
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
