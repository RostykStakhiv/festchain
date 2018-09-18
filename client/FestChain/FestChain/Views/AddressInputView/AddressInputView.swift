//
//  AddressInputView.swift
//  Mitwelt
//
//  Created by Rostyslav Stakhiv on 7/22/17.
//  Copyright © 2017 Rostyslav Stakhiv. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

typealias AddressSelectionHandler = (_ addressModel: GMSAddress) -> Void
typealias AddressClearedHandler = () -> Void

enum AddressInputViewState {
    case searching
    case normal
}

class AddressInputView: IBDesignableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    static let addressCellHeight: CGFloat = 40.0
    static let maxAddressCellCount = 4
    
    @IBOutlet private weak var addressTF: UITextField!
    @IBOutlet private weak var resultsTV: UITableView!
    
    @IBOutlet private weak var addressTFHeight: NSLayoutConstraint!
    @IBOutlet private weak var bottomSeparatorHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var deleteButtonWidth: NSLayoutConstraint!
    
    @IBOutlet private weak var height: NSLayoutConstraint!
    
    var addressInputChangeHandler: ((String?) -> Void)?
    
    private var addressPredictionModels: [GMSAutocompletePrediction] = [GMSAutocompletePrediction]() {
        didSet {
            self.recalculateViewHeight(animated: true)
            self.resultsTV.reloadData()
        }
    }
    
    private var state: AddressInputViewState = .normal {
        didSet {
            switch self.state {
            case .normal:
                self.deleteButtonWidth.constant = 0
            case .searching:
                self.deleteButtonWidth.constant = 24
            }
            
            self.recalculateViewHeight(animated: true)
        }
    }
    
    var mapsCoordinateBounds: GMSCoordinateBounds?
    var filter: GMSAutocompleteFilter?
    
    var selectedAddressModel: GMSAddress? {
        didSet {
            self.addressTF.text = self.selectedAddressModel?.lines?.first
        }
    }
    
    var addressSelectionHandler: AddressSelectionHandler?
    var addressClearedHandler: AddressClearedHandler?
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    //MARK: Custom Actions
    @objc internal func addressInputDidChange() {
        //Send Request to get new addresses and set addressModels array
        if let querry = self.addressTF.text {
            
            self.addressInputChangeHandler?(querry)
//            let placesClient = GMSPlacesClient()
//            placesClient.autocompleteQuery(querry, bounds: self.mapsCoordinateBounds, filter: self.filter, callback: {(results, error) -> Void in
//                if let error = error {
//                    print("Autocomplete error \(error)")
//                    return
//                }
//                if let results = results {
//                    self.addressPredictionModels = results
//                }
//            })
        }
    }
    
    internal func recalculateViewHeight(animated: Bool) {
        var newHeight: CGFloat = 0.0
        
        switch self.state {
        case .normal:
            newHeight = self.addressTFHeight.constant
        case .searching:
            if addressPredictionModels.count <= AddressInputView.maxAddressCellCount {
                newHeight = self.addressTFHeight.constant + AddressInputView.addressCellHeight * CGFloat(addressPredictionModels.count)
                self.resultsTV.isScrollEnabled = false
            } else {
                newHeight = self.addressTFHeight.constant + AddressInputView.addressCellHeight * CGFloat(AddressInputView.maxAddressCellCount)
                self.resultsTV.isScrollEnabled = true
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.height.constant = newHeight
                self.superview?.layoutIfNeeded()
            })
        } else {
            self.height.constant = newHeight
        }
    }
    
    //MARK: IBActions
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.addressTF.text = nil
        
        self.addressClearedHandler?()
    }
    
    //MARK: Internal Methods
    internal func setupUI() {
        self.addressTF.addTarget(self, action: #selector(addressInputDidChange), for: .editingChanged)
        self.addressTF.delegate = self
        
        self.state = .normal
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressPredictionModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let predictionModel = self.addressPredictionModels[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = predictionModel.attributedFullText.string
        cell!.imageView?.image = UIImage(named: "geolocation_icon")
        cell!.imageView?.contentMode = .center
        cell!.imageView?.tintColor = .lightGray
        
        return cell!
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddressInputView.addressCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.resultsTV {
            if let selectedPlaceID = self.addressPredictionModels[indexPath.row].placeID {
                self.resultsTV.allowsSelection = false
                
                GMSPlacesClient.shared().lookUpPlaceID(selectedPlaceID, callback: { (place, error) -> Void in
                    
                    if let coords = place?.coordinate {
                        GMSGeocoder().reverseGeocodeCoordinate(coords, completionHandler: { (response, error) in
                            self.resultsTV.allowsSelection = true
                            
                            if let model = response?.results()?.first {
                                self.endEditing(false)
                                self.resultsTV.deselectRow(at: indexPath, animated: false)
                                
                                self.selectedAddressModel = model
                                self.addressSelectionHandler?(model)
                            }
                        })
                    } else {
                       self.resultsTV.allowsSelection = true
                    }
                })
            }
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.state = .searching
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.state = .normal
    }
}
