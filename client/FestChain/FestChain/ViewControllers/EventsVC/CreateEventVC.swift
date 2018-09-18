//
//  CreateEventVC.swift
//  FestChain
//
//  Created by admin on 7/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SwiftDate
import CoreLocation

class CreateEventVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var nameTF: UITextField!
    @IBOutlet private weak var descriptionTV: KMPlaceholderTextView!
    @IBOutlet private weak var ticketPriceTF: UITextField!
    @IBOutlet private weak var maxNumberOfTicketsTF: UITextField!
    @IBOutlet private weak var startDateTF: UITextField!
    @IBOutlet private weak var endDateTF: UITextField!
    @IBOutlet private weak var addressLbl: UILabel!
    
    private var eventStartDay: TimeInterval?
    private var eventEndDay: TimeInterval?
    
    private var eventLocation: CLLocationCoordinate2D?
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        //datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: Private Methods
    private func setupUI() {
        descriptionTV.placeholder = "Event description"
        startDateTF.inputView = datePicker
        endDateTF.inputView = datePicker
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard (textField == startDateTF || textField == endDateTF) else {
            return
        }
        
        let date = datePicker.date
        
        switch textField {
        case startDateTF:
            startDateTF.text = date.toFormat("dd MMM yyyy 'at' HH:mm")
            eventStartDay = date.timeIntervalSince1970
        case endDateTF:
            endDateTF.text = date.toFormat("dd MMM yyyy 'at' HH:mm")
            eventEndDay = date.timeIntervalSince1970
        default: break
        }
    }
    
//    @objc private func datePickerValueChanged() {
//
//    }

}
