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
    var getData: [TaskInfo] = []
    var userDefaultKey: String = "deleteTask"
    
    var getTaskData: GetTaskData = GetTaskData()
    var postStatus: PostStatus = PostStatus()
    //var listReconstruction: ListReconstruction = ListReconstruction()
    

    @IBOutlet weak var compTaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
        
        getData = getTaskData.getArticles(status: "open")
        let addData = getTaskData.getArticles(status: "done")
        getData.append(contentsOf: addData)
        //dump(getData)
        
        ListReconstruction.sharedIntance.delegate = self
        //リストを成形
        ListReconstruction.sharedIntance.reconstruction()
        sectionList =  ListReconstruction.sharedIntance.doneSectionList
        taskList = ListReconstruction.sharedIntance.doneTaskList
        
        compTaskTableView.delegate = self
        compTaskTableView.dataSource = self
        
        configureTableViewCell()
        
        compTaskTableView.reloadData()
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
    
    //スワイプアクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //削除したデータを削除リストに追加
        ListReconstruction.sharedIntance.daleteTaskList.append(self.taskList[indexPath.section][indexPath.row])
        
        // 削除のアクションを設定する
        let deleteAction = UIContextualAction(style: .destructive, title:"delete") {
            (ctxAction, view, completionHandler) in
            //ユーザーデフォルトに削除したタスクのID登録
            var userDefaultArray: [Int] = []
            if let userDefaultData = UserDefaults.standard.array(forKey: self.userDefaultKey) {
                userDefaultArray = userDefaultData as! [Int]
            }
            //dump(userDefaultArray)
            //dump(self.taskList[indexPath.section][indexPath.row].taskID)
            userDefaultArray.append(self.taskList[indexPath.section][indexPath.row].taskID!)
            UserDefaults.standard.set(userDefaultArray, forKey: self.userDefaultKey)
            
            self.taskList[indexPath.section].remove(at: indexPath.row)
            ListReconstruction.sharedIntance.doneTaskList[indexPath.section].remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        // 削除ボタンのデザインを設定する
        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
        deleteAction.image = trashImage
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        
        // 未完了のアクションを設定する
        let shareAction = UIContextualAction(style: .normal  , title: "uncomp") {
            (ctxAction, view, completionHandler) in
            print("未完了にする")
            //chatworkのタスクを未完了にする
            let list: TaskInfo = self.taskList[indexPath.section][indexPath.row]
            self.postStatus.HttpRequest(taskInfo: list, status: "open")
            self.taskList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        // 未完了ボタンのデザインを設定する
        let shareImage = UIImage(systemName: "clock")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
        shareAction.image = shareImage
        shareAction.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)
    
        // スワイプでの削除を無効化して設定する
        let swipeAction = UISwipeActionsConfiguration(actions:[shareAction, deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
        
    }

}
