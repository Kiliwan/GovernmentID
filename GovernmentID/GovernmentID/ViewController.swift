//
//  ViewController.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 16.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Alamofire
import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private var cheButton: NSButton!
    @IBOutlet private var jpnButton: NSButton!
    
    @IBAction func switchCountry(_ sender: NSButton) {
        if AppDelegate.country == .che {
            cheButton.isEnabled = true
            jpnButton.isEnabled = false
            AppDelegate.country = .jpn
        } else {
            cheButton.isEnabled = false
            jpnButton.isEnabled = true
            AppDelegate.country = .che
        }
        
        print("🏳 Country: \(AppDelegate.country.rawValue)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cheButton.isEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func openAllDocuments(_ sender: NSButton) {
        let storyboard = NSStoryboard(name: "AllDocumentsViewController", bundle: nil).instantiateController(withIdentifier: "AllDocumentsViewController") as! AllDocumentsViewController
        storyboard.newWindowForTab(self)
    }

}
