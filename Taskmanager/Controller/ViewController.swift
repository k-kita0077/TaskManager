//
//  ViewController.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/17.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListReconstructionDelegate {
    
    var sectionList: [String] = []
    var taskList: [[TaskInfo]] = []
    var listReconstruction: ListReconstruction = ListReconstruction()
    var getData: [TaskInfo] = []
    
    var dateTime: Date!
    var unixtime: TimeInterval!

    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        //APIでデータ取得
        getData = GetTaskData.sharedIntance.getArticles(status: "open")
        dump(getData)
        
        listReconstruction.delegate = self
        //リストを成形
        let reconstruction = listReconstruction.reconstruction()
        sectionList =  reconstruction.openSectionList
        taskList = reconstruction.openTaskList
        
        dateTime = Date()
        unixtime = TimeInterval(dateTime.timeIntervalSince1970)
        
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        
        configureTableViewCell()
    }
    
    func configureTableViewCell() {
        let nib = UINib(nibName: "TaskListTableViewCell", bundle: nil)
        let cellId = "TaskCellID"
        
        taskListTableView.register(nib, forCellReuseIdentifier: cellId)
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
            print(unixtime!)
            print(dateUnix)
            if dateUnix < unixtime {
                cell.contentView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
            } else if dateUnix < (unixtime + 259200) {
                cell.contentView.backgroundColor = UIColor(red: 0.0, green: 0.502, blue: 1.0, alpha: 0.5)
            } else {
                cell.contentView.backgroundColor = UIColor.white
            }
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
