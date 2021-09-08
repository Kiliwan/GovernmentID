//
//  Document.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 16.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Foundation

struct Document: Decodable {
    let name: String
    let details: Details
    
    struct Details: Decodable {
        let first_name: String
        let last_name: String
        let dob: String
        let documents: [[String: String]]
        let stream: String
    }
    
    init(name: String, details: Details) {
        self.name = name
        self.details = details
    }
}
