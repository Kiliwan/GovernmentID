//
//  Visa.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 17.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Foundation

struct Visa: Decodable {
    let publishers: [String]
    let data: PublisherData
    
    struct PublisherData: Decodable {
        let json: JSONData
        
        struct JSONData: Decodable {
            let country: String
            let start_date: String
            let end_date: String
        }
    }
}
