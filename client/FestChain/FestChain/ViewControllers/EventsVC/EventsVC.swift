//
//  EventsVC.swift
//  FestChain
//
//  Created by admin on 7/2/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EventsVC: UITableViewController {
    
    private let serialNumber = NASSmartContracts.randomCode(withLength: 32) ?? ""
    private let festChainSCFacade = SCFacade(testnetContractAddress: kTestnetSmartContractAddress, mainnetContractAddress: kMainnetSmartContractAddress)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //MARK: IBActions
    @IBAction func getEventsTapped() {
        let error = festChainSCFacade.callSmartContractMethod(withName: kGetAllEvents, andArgs: [], payNAS: 0, withSerialNumber: nil, forGoodsName: kEventGood, andDesc: kGetAllEventsDesc)
        
        guard error == nil else {
            print("Error occured: \(String(describing: error))")
            return
        }
    }
}
