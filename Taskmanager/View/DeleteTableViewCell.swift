//
//  DeleteTableViewCell.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/19.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import UIKit

class DeleteTableViewCell: UITableViewCell {
    @IBOutlet weak var limitTimeLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
