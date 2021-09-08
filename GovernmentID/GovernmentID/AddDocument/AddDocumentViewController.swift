//
//  AddDocumentViewController.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 16.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Alamofire
import Cocoa
import typealias CommonCrypto.CC_LONG
import func CommonCrypto.CC_MD5
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import Foundation

class AddDocumentViewController: NSViewController {

    @IBOutlet private var firstNameTextField: NSTextField!
    @IBOutlet private var lastNameTextField: NSTextField!
    @IBOutlet private var birthDateTextField: NSTextField!
    @IBOutlet private var expiryDateTextField: NSTextField!
    @IBOutlet private var idNumberTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        idNumberTextField.stringValue = randomString(length: 12)
    }

    @IBAction func publish(_ sender: NSButton) {
        sendAsset()
    }
}

// MARK: - Alamofire

extension AddDocumentViewController {
    func sendAsset() {
        guard firstNameTextField.stringValue != "" else {
            StaticAlert.error(text: "Please fill in the first name.")
            return
        }

        guard lastNameTextField.stringValue != "" else {
            StaticAlert.error(text: "Please fill in the last name.")
            return
        }

        guard birthDateTextField.stringValue != "" else {
            StaticAlert.error(text: "Please fill in the birthday")
            return
        }

        guard expiryDateTextField.stringValue != "" else {
            StaticAlert.error(text: "Please fill in the expiration date.")
            return
        }
        
        let firstName = firstNameTextField.stringValue
        let lastName = lastNameTextField.stringValue
        let birthDate = birthDateTextField.stringValue
        let expiryDate = expiryDateTextField.stringValue

        let md5Data = MD5(string: "\(firstName.lowercased())\(lastName.lowercased())\(birthDate.lowercased())")
        let md5Base64 = md5Data.base64EncodedString()

        let document = "[{\"id\":\"\(idNumberTextField.stringValue)\", \"expiry_date\":\"\(expiryDate)\"}]"

        postRequest(hash: md5Base64, firstName: firstName, lastName: lastName, birthDate: birthDate, documents: document, expiryDate: expiryDate) { result, error in
            if error != nil {
                print("✅ User Added")
                print("→ Adding a stream for user")
                
                self.postRequest(hash: md5Base64) { result, error in
                    if error != nil {
                        print("✅ Stream Added")
                        // Alert
                        DispatchQueue.main.async {
                            StaticAlert.successAndClose(text: "✅ The user has been successfully added to the blockchain.", view: self.view)
                        }
                    } else {
                        print("❌ Stream failed : \(error?.localizedDescription ?? "No detailed explanation.")")
                        // Alert
                        StaticAlert.error(text: "❌ An error occured. Please try again.")
                    }
                }
            } else {
                print("❌ User adding failed : \(error?.localizedDescription ?? "No detailed explanation.")")
                // Alert
                StaticAlert.error(text: "❌ An error occured. Please try again.")
            }
        }
    }

    func postRequest(hash: String, firstName: String, lastName: String, birthDate: String, documents: String, expiryDate: String, completion: @escaping ([String: Any]?, Error?) -> Void) {

        // declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["hash": hash, "stream_hash": MD5(string: hash).base64EncodedString(), "first_name": firstName, "last_name": lastName, "date_of_birth": birthDate, "documents": documents]

        // create the url with NSURL
        let url = URL(string: "\(AppDelegate.country.server_url())/new-asset")!

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

    func postRequest(hash: String, completion: @escaping ([String: Any]?, Error?) -> Void) {

        // declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["stream_hash": MD5(string: hash).base64EncodedString()]

        // create the url with NSURL
        let url = URL(string: "\(AppDelegate.country.server_url())/new-stream")!

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

extension AddDocumentViewController {
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }

    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using: .utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}
