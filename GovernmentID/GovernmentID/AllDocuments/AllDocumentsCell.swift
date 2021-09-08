//
//  AllDocumentsCell.swift
//  GovernmentID
//
//  Created by Antoine Bellanger on 16.11.19.
//  Copyright © 2019 Da Boiz. All rights reserved.
//

import Cocoa

class AllDocumentsCell: NSTableCellView {
    
    @IBOutlet var documentIdLabel: NSTextField!
    @IBOutlet var documentExpirationLabel: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}

class VisaCell: NSTableCellView {
    
    @IBOutlet var countryLabel: NSTextField!
    @IBOutlet var dateLabel: NSTextField!
}
