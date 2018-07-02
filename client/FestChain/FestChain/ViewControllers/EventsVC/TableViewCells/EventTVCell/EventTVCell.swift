//
//  EventTVCell.swift
//  FestChain
//
//  Created by admin on 7/2/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EventTVCell: UITableViewCell {
    
    @IBOutlet private weak var eventTitle: UILabel!
    @IBOutlet private weak var eventDesc: UILabel!
    @IBOutlet private weak var eventStartDate: UILabel!
    
    var eventTitleText: String = "" {
        didSet {
            eventTitle.text = eventTitleText
        }
    }
    
    var eventDescText: String = "" {
        didSet {
            eventDesc.text = eventDescText
        }
    }
    
    var eventStartDateString: String = "" {
        didSet {
            eventStartDate.text = eventStartDateString
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
