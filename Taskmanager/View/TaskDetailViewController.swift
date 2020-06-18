//
//  TaskDetailViewController.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/18.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var limitTimeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    
    var TaskInfo: TaskInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let taskInfo = TaskInfo else {return}
        
        sectionLabel.text = taskInfo.sectionTitle
        titleLabel.text = taskInfo.taskTitle
        let dateUnix: TimeInterval = TimeInterval(taskInfo.limitTime!)
        let date = NSDate(timeIntervalSince1970: dateUnix)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateStr: String = formatter.string(from: date as Date)
        limitTimeLabel.text = dateStr
        detailLabel.text = taskInfo.body
    }


    

}
