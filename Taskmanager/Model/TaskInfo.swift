//
//  TaskInfo.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/17.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import Foundation

class TaskInfo {
    let taskID: Int?
    let userID: Int?
    let body: String
    let status: String?
    let limitTime: Int?
    let sectionTitle: String
    let taskTitle: String
    
    init(taskID:Int?, userID: Int?, body: String, status: String?, limitTime: Int?, sectionTitle: String, taskTitle: String) {
        self.taskID = taskID
        self.userID = userID
        self.body = body
        self.status = status
        self.limitTime = limitTime
        self.sectionTitle = sectionTitle
        self.taskTitle = taskTitle
    }
}
