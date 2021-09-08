//
//  AddVisaViewController.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 17.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Cocoa

class AddVisaViewController: NSViewController {
    
    @IBOutlet private var countryTextField: NSTextField!
    @IBOutlet private var startDateTextField: NSTextField!
    @IBOutlet private var endDateTextField: NSTextField!
    @IBOutlet private var identifierTextField: NSTextField!

    var streamHash: String = ""
    var documentIdentifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentIdentifier = UserDefaults.standard.string(forKey: "document_identifier") ?? ""
        UserDefaults.standard.set("", forKey: "document_identifier")
        identifierTextField.stringValue = documentIdentifier
        
        streamHash = UserDefaults.standard.string(forKey: "stream") ?? ""
    }
    
    @IBAction func publish(_ sender: NSButton) {
        sendStream()
    }
    
}

// MARK: - Alamofire

extension AddVisaViewController {
    func sendStream() {
        guard countryTextField.stringValue != "" else {
            StaticAlert.error(text: "Please fill in the country.")
            return
        }

        guard startDateTextField.stringValue != "" else {
            StaticAlert.error(text: "Please fill in the start date.")
            return
        }

        guard endDateTextField.stringValue != "" else {
            StaticAlert.error(text: "Please fill in the end date.")
            return
        }
        
        let uniqueId = randomString(length: 50)
        
        let data = "{\"json\": {\"country\": \"\(countryTextField.stringValue)\", \"start_date\": \"\(startDateTextField.stringValue)\", \"end_date\": \"\(endDateTextField.stringValue)\"}}"
        
        postRequest(streamHash: streamHash, uniqueId: uniqueId, data: data) { result, error in
            if error != nil {
                print("✅ Data added to stream")
                // Alert
                DispatchQueue.main.async {
                    StaticAlert.successAndClose(text: "✅ The visa has been successfully added to the user's profile on the blockchain.", view: self.view)
                }
            } else {
                print("❌ Stream failed : \(error?.localizedDescription ?? "No detailed explanation.")")
                // Alert
                StaticAlert.error(text: "❌ An error occured. Please try again.")
            }
        }
    }
    
    func postRequest(streamHash: String, uniqueId: String, data: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        let parameters = ["stream_hash": streamHash, "id": uniqueId, "data": data]

        // create the url with NSURL
        let url = URL(string: "\(AppDelegate.country.server_url())/new-publication")!

        // create the session object
        let session = URLSession.shared

        // now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch {
            print(error.localizedDescription)
            completion(nil, error)
        }

        // HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, _, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                // create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print(json)
                completion(json, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })

        task.resume()
    }
}

// MARK: - Helpers

extension AddVisaViewController {
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}
