//
//  AllDocumentsViewController.swift
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

class AllDocumentsViewController: NSViewController {

    private var documents = [Document]()
    private var toDisplayDocuments = [Document]()
    private var visas = [Visa]()

    private var queryDocumentNumber: Bool = false

    @IBOutlet private var firstNameTextField: NSTextField!
    @IBOutlet private var secondNameTextField: NSTextField!
    @IBOutlet private var dateBirthTextField: NSTextField!
    @IBOutlet private var documentNumberTextField: NSTextField!
    @IBOutlet private var tableView: NSTableView!
    @IBOutlet private var addButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        addButton.isEnabled = false
    }

    @IBAction func search(_ sender: NSButton) {
        
        if documentNumberTextField.stringValue != "" {
            downloadAllDocuments()
        } else {
            guard firstNameTextField.stringValue != "" else {
                StaticAlert.error(text: "Please fill in the first name.")
                return
            }

            guard secondNameTextField.stringValue != "" else {
                StaticAlert.error(text: "Please fill in the last name.")
                return
            }

            guard dateBirthTextField.stringValue != "" else {
                StaticAlert.error(text: "Please fill in the birthday")
                return
            }
            
            downloadAllDocuments()
        }
    }

    @IBAction func addVisa(_ sender: NSButton) {
        UserDefaults.standard.set(toDisplayDocuments[0].details.documents[0]["id"], forKey: "document_identifier")
        UserDefaults.standard.set(toDisplayDocuments[0].details.stream, forKey: "stream")
        performSegue(withIdentifier: "showVisa", sender: self)
    }
}

// MARK: - Alamofire

extension AllDocumentsViewController {
    func downloadAllDocuments() {

        documents.removeAll()

        Alamofire.request("\(AppDelegate.country.server_url())/list-assets").responseJSON { response in
            let results = response.result.value as! [[String: Any]]
            for result in results {
                let details = result["details"] as! [String: Any]
                let detail = Document.Details(first_name: details["first_name"] as! String, last_name: details["last_name"] as! String, dob: details["dob"] as! String, documents: details["documents"] as! [[String: String]], stream: details["stream"] as! String)
                self.documents.append(Document(name: result["name"] as! String, details: detail))
            }
            DispatchQueue.main.async {
                self.toDisplayDocuments.removeAll()
                self.handleQuery()
            }
        }
    }
    
    func downloadPublication(streamHash: String) {
        visas.removeAll()
        
        let parameters: Parameters = ["stream_hash": streamHash]
        
        Alamofire.request("\(AppDelegate.country.server_url())/list-publications", parameters: parameters).responseJSON { response in
            let results = response.result.value as! [[String: Any]]
            for result in results {
                let data = result["data"] as! [String: Any]
                let json = data["json"] as! [String: String]
                let jsonData = Visa.PublisherData.JSONData(country: json["country"]!, start_date: json["start_date"]!, end_date: json["end_date"]!)
                self.visas.append(Visa(publishers: result["publishers"] as! [String], data: Visa.PublisherData(json: jsonData)))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Data

extension AllDocumentsViewController {
    func handleQuery() {
        let searchQuery = "\(firstNameTextField.stringValue.lowercased())\(secondNameTextField.stringValue.lowercased())\(dateBirthTextField.stringValue.lowercased())"
        if documentNumberTextField.stringValue != "" {
            for document in documents {
                if documentNumberTextField.stringValue == document.details.documents[0]["id"] {
                    toDisplayDocuments.append(document)
                }
            }
        } else {
            let hash = MD5(string: searchQuery).base64EncodedString()
            for document in documents {
                if hash == document.name {
                    toDisplayDocuments.append(document)
                }
            }
        }
        
        guard !toDisplayDocuments.isEmpty else {
            StaticAlert.error(text: "❌ No results for this query.")
            addButton.isEnabled = false
            return
        }

        DispatchQueue.main.async {
            self.addButton.isEnabled = true
            self.downloadPublication(streamHash: self.toDisplayDocuments[0].details.stream)
        }
    }
}

// MARK: - NSTableViewDataSource

extension AllDocumentsViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDisplayDocuments.count + visas.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if row == 0 {
            let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AllDocumentsCell"), owner: self) as! AllDocumentsCell
            result.documentIdLabel.stringValue = toDisplayDocuments[0].details.documents[0]["id"]!
            result.documentExpirationLabel.stringValue = toDisplayDocuments[0].details.documents[0]["expiry_date"]!
            return result
        } else {
            let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "VisaCell"), owner: self) as! VisaCell
            
            var issuedBy = ""
            let publisherCountryAddress = visas[row-1].publishers[0]
            if publisherCountryAddress == AppDelegate.CHE_ID {
                issuedBy = "Issued by Switzerland"
            } else if publisherCountryAddress == AppDelegate.JPN_ID {
                issuedBy = "Issued by Japan"
            }
            
            result.countryLabel.stringValue = "\(visas[row-1].data.json.country) | \(issuedBy)"
            result.dateLabel.stringValue = "\(visas[row-1].data.json.start_date) - \(visas[row-1].data.json.end_date)"
            return result
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
}

// MARK: - Helpers

extension AllDocumentsViewController {

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
