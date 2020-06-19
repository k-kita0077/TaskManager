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
    var getData: [TaskInfo] = []
    var batchCount: Int = 0
    var userDefaultKey: String = "deleteTask"
    
    //var listReconstruction: ListReconstruction = ListReconstruction()
    var getTaskData: GetTaskData = GetTaskData()
    var postStatus: PostStatus = PostStatus()
    
    var activityIndicatorView = UIActivityIndicatorView()
    
    var dateTime: Date!
    var unixtime: TimeInterval!

    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        
        view.addSubview(activityIndicatorView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        // アニメーション開始
        activityIndicatorView.startAnimating()

        DispatchQueue.global(qos: .default).async {
            Thread.sleep(forTimeInterval: 1.5)

            DispatchQueue.main.async {
                // アニメーション終了
                self.activityIndicatorView.stopAnimating()
            }
        }
        //APIでデータ取得
        getData = getTaskData.getArticles(status: "open")
        let addData = getTaskData.getArticles(status: "done")
        getData.append(contentsOf: addData)
        //dump(getData)
        
        ListReconstruction.sharedIntance.delegate = self
        //リストを成形
        ListReconstruction.sharedIntance.reconstruction()
        sectionList =  ListReconstruction.sharedIntance.openSectionList
        taskList = ListReconstruction.sharedIntance.openTaskList
        
        dateTime = Date()
        unixtime = TimeInterval(dateTime.timeIntervalSince1970)
        
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        
        configureTableViewCell()
        
        batchCount = 0
        for array in taskList {
            for data in array {
                guard let limitTime = data.limitTime else {return}
                let dateUnix: TimeInterval = TimeInterval(limitTime)
                if dateUnix < (unixtime + 259200) {
                    batchCount += 1
                }
            }
        }
        if let tabItem = self.tabBarController?.tabBar.items?[0] {
            tabItem.badgeValue = String(batchCount)
        }
        
        if let userDefaultData = UserDefaults.standard.array(forKey: self.userDefaultKey) {
            dump(userDefaultData)
        }
        
        taskListTableView.reloadData()
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
            if dateUnix < unixtime {
                cell.contentView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.2)
            } else if dateUnix < (unixtime + 259200) {
                cell.contentView.backgroundColor = UIColor(red: 0.0, green: 0.502, blue: 1.0, alpha: 0.2)
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
    
    //スワイプアクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 削除のアクションを設定する
        let deleteAction = UIContextualAction(style: .destructive, title:"delete") {
            (ctxAction, view, completionHandler) in
            //削除したデータを削除リストに追加
            ListReconstruction.sharedIntance.daleteTaskList.append(self.taskList[indexPath.section][indexPath.row])
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
            ListReconstruction.sharedIntance.openTaskList[indexPath.section].remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        // 削除ボタンのデザインを設定する
        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
        deleteAction.image = trashImage
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        
        // 完了のアクションを設定する
        let shareAction = UIContextualAction(style: .normal  , title: "comp") {
            (ctxAction, view, completionHandler) in
            print("完了にする")
            //chatworkのタスクを完了にする
            let list: TaskInfo = self.taskList[indexPath.section][indexPath.row]
            self.postStatus.HttpRequest(taskInfo: list, status: "done")
            self.taskList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        // 完了ボタンのデザインを設定する
        let shareImage = UIImage(systemName: "checkmark.shield.fill")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
        shareAction.image = shareImage
        shareAction.backgroundColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1)
        
        // スワイプでの削除を無効化して設定する
        let swipeAction = UISwipeActionsConfiguration(actions:[shareAction, deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
        
    }
    
}
