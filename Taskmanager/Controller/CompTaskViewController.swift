//
//  CompTaskViewController.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/17.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import UIKit

class CompTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListReconstructionDelegate {

    var sectionList: [String] = []
    var taskList: [[TaskInfo]] = []
    var listReconstruction: ListReconstruction = ListReconstruction()
    var getData: [TaskInfo] = []

    @IBOutlet weak var compTaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        getData = GetTaskData.sharedIntance.getArticles(status: "done")
        dump(getData)
        
        listReconstruction.delegate = self
        //リストを成形
        let reconstruction = listReconstruction.reconstruction()
        sectionList =  reconstruction.doneSectionList
        taskList = reconstruction.doneTaskList
        
        compTaskTableView.delegate = self
        compTaskTableView.dataSource = self
        
        configureTableViewCell()
    }
    
    
    func configureTableViewCell() {
        let nib = UINib(nibName: "TaskListTableViewCell", bundle: nil)
        let cellId = "TaskCellID"
        
        compTaskTableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //ListReconstructionに渡して配列を成形
    func handOver() -> [TaskInfo] {
        return getData
    }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    //セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    //rowの数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList[section].count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TaskListTableViewCell
        if let limitTime = taskList[indexPath.section][indexPath.row].limitTime {
            let dateUnix: TimeInterval = TimeInterval(limitTime)
            let date = NSDate(timeIntervalSince1970: dateUnix)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let dateStr: String = formatter.string(from: date as Date)
            cell.limitTimeLabel.text = dateStr
        }
        cell.taskTitleLabel.text = taskList[indexPath.section][indexPath.row].taskTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TaskDetailViewController()
        vc.TaskInfo = taskList[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }

}
