//
//  EventsVC.swift
//  FestChain
//
//  Created by admin on 7/2/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EventsVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //MARK: IBActions
    @IBAction func addEventTapped() {
        
    }

}
