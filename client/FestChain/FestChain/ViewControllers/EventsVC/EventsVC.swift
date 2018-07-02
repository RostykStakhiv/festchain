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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !NASSmartContracts.nasNanoInstalled() {
            NASSmartContracts.goToNasNanoAppStore()
        } else {
            //NASSmartContracts.call(withMethod: kGetAllEvents, andArgs: [], payNas: 0, toAddress: kSmartContractAddress, withSerialNumber: serialNumber, forGoodsName: kEventGood, andDesc: kGetAllEventsDesc)
            NASApi.callFuction(from: "n1KgUaJcRmcNBoH2xFYHCHJCgrGToeZo8m1", to: kSmartContractAddress, withValue: <#T##NSNumber!#>, andNonce: <#T##Int#>, andGasPrice: <#T##NSNumber!#>, andGasLimit: <#T##NSNumber!#>, andContract: <#T##[AnyHashable : Any]!#>, withCompletionHandler: <#T##(([AnyHashable : Any]?) -> Void)!##(([AnyHashable : Any]?) -> Void)!##([AnyHashable : Any]?) -> Void#>, errorHandler: <#T##((String?) -> Void)!##((String?) -> Void)!##(String?) -> Void#>)
        }
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
}
