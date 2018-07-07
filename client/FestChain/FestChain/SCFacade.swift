//
//  SCFacade.swift
//  FestChain
//
//  Created by admin on 7/2/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SCFacade {
    
    static var isDebugMode: Bool = false {
        didSet {
            NASSmartContracts.debug(isDebugMode)
        }
    }
    
    private var serialNumber: String = NASSmartContracts.randomCode(withLength: 32)
    private var testnetContractAddress: String
    private var mainnetContractAddress: String
    
    init(testnetContractAddress: String, mainnetContractAddress: String) {
        self.testnetContractAddress = testnetContractAddress
        self.mainnetContractAddress = mainnetContractAddress
    }
    
    //MARK: Public Methods
    func callSmartContractMethod(withName methodName: String, andArgs args: [Any], payNAS amountToPay: Double, withSerialNumber serial: String?, forGoodsName goodsName: String, andDesc desc: String) -> Error? {
        if !NASSmartContracts.nasNanoInstalled() {
            NASSmartContracts.goToNasNanoAppStore()
            return nil
        }
        
        let sn = serial ?? self.serialNumber
        let contractAddress = SCFacade.isDebugMode ? testnetContractAddress : mainnetContractAddress
        let res = NASSmartContracts.call(withMethod: methodName, andArgs: args, payNas: amountToPay as NSNumber, toAddress: contractAddress, withSerialNumber: sn, forGoodsName: goodsName, andDesc: desc)
        return res
    }
}
