//
//  ListReconstruction.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/17.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import Foundation

protocol ListReconstructionDelegate: class {
    func handOver() -> [TaskInfo]
}

class ListReconstruction {

    weak var delegate: ListReconstructionDelegate?

    
    //渡されたリストを完了、未完に振り分け
    func separation()  -> (openTask: [TaskInfo], doneTask: [TaskInfo]){
        var openTask: [TaskInfo] = []
        var doneTask: [TaskInfo] = []
        if let list = self.delegate?.handOver() {
            for data in list {
                if data.status == "open" {
                    openTask.append(data)
                } else {
                    doneTask.append(data)
                }
            }
        }
        return (openTask, doneTask)
    }

    //リストを成形
    func molding(task: [TaskInfo]) -> (sectionList: [String], taskList: [[TaskInfo]]){
        var sectionList: [String] = []
        var sectionMolding: [String] = []
        var taskList: [[TaskInfo]] = []
        
        for data in task {
            sectionList.append(data.sectionTitle)
        }
        //重複を削除
        var set = Set<String>()
        sectionMolding = sectionList.filter { set.insert($0).inserted }
        //リストを振り分け
        var num: Int = -1
        for (i, value) in sectionMolding.enumerated() {
            for data in task {
                if data.sectionTitle == value {
                    if num == i {
                        taskList[i].append(data)
                    } else {
                        taskList.append([])
                        taskList[i].append(data)
                        num += 1
                    }
                }
            }
        }
        return (sectionMolding, taskList)
    }
    
    //実行
    func reconstruction() -> (openSectionList: [String], openTaskList: [[TaskInfo]], doneSectionList: [String], doneTaskList: [[TaskInfo]]) {
        let sep = separation()
        let openTask: [TaskInfo] = sep.openTask
        let doneTask: [TaskInfo] = sep.doneTask
        
        let open = molding(task: openTask)
        let openSectionList: [String] = open.sectionList
        let openTaskList: [[TaskInfo]] = open.taskList
        
        let done = molding(task: doneTask)
        let doneSectionList: [String] = done.sectionList
        let doneTaskList: [[TaskInfo]] = done.taskList
        
        return (openSectionList, openTaskList, doneSectionList, doneTaskList)
    }
    
   
    
}
