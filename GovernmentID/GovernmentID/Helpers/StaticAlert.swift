//
//  StaticAlert.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 17.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import AppKit
import Foundation

class StaticAlert {
    static func successAndClose(text: String, view: NSView) {
        let alert = NSAlert()
        alert.messageText = text
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: view.window!) { (response) in
            view.window!.close()
        }
    }
    
    static func success(text: String) {
        let alert = NSAlert()
        alert.messageText = text
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    static func error(text: String) {
        let alert = NSAlert()
        alert.messageText = text
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
