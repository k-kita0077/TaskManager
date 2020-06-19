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

    static let sharedIntance = ListReconstruction()
    
    weak var delegate: ListReconstructionDelegate?

    var openSectionList: [String] = []
    var openTaskList: [[TaskInfo]] = []
    var doneSectionList: [String] = []
    var doneTaskList: [[TaskInfo]] = []
    var daleteTaskList: [TaskInfo] = []
    
    var userDefaultKey: String = "deleteTask"
    
    //ユーザーデフォルトの削除リストと合致するものを省く、削除リストに追加
    func deleteTaskRemove() -> ([TaskInfo]) {
        self.daleteTaskList = []
        var returnList: [TaskInfo] = []
        if var list = self.delegate?.handOver() {
            let userDefaultData: [Int]? = UserDefaults.standard.array(forKey: userDefaultKey) as? [Int]
            if !(userDefaultData?.isEmpty ?? true){
                if let deleteTaskID = userDefaultData {
                    for taskID in deleteTaskID {
                        for (i, data) in list.enumerated() {
                            if taskID == data.taskID {
                                self.daleteTaskList.append(data)
                                list.remove(at: i)
                            }
                        }
                    }
                }
                
            }
            returnList = list
        }
        return returnList
    }
    //渡されたリストを完了、未完に振り分け
    func separation(task: [TaskInfo])  -> (openTask: [TaskInfo], doneTask: [TaskInfo]){
        var openTask: [TaskInfo] = []
        var doneTask: [TaskInfo] = []
        
        //振り分け
        for data in task {
            if data.status == "open" {
                openTask.append(data)
            } else if data.status == "done" {
                doneTask.append(data)
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
    func reconstruction() {
        let del = deleteTaskRemove()
        
        let sep = separation(task: del)
        let openTask: [TaskInfo] = sep.openTask
        let doneTask: [TaskInfo] = sep.doneTask
        
        let open = molding(task: openTask)
        self.openSectionList = open.sectionList
        self.openTaskList = open.taskList
        
        let done = molding(task: doneTask)
        self.doneSectionList = done.sectionList
        self.doneTaskList = done.taskList
        
    }
    
   
    
}
