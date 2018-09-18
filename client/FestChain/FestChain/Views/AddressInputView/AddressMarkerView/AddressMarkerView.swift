//
//  AddressMarkerView.swift
//  Mitwelt
//
//  Created by Rostyslav Stakhiv on 7/26/17.
//  Copyright © 2017 Rostyslav Stakhiv. All rights reserved.
//

import UIKit

class AddressMarkerView: UIView {

    @IBOutlet weak var addressLbl: UILabel!
    
    var title: String? {
        didSet {
            self.addressLbl.text = self.title
        }
    }
    
    static func loadFromXIB() -> AddressMarkerView {
        let nib = UINib(nibName: "AddressMarkerView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! AddressMarkerView
        return view
    }

}
