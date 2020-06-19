//
//  DeleteTaskViewController.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/17.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import UIKit

class DeleteTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var deleteTaskTableView: UITableView!
    
    var userDefaultKey: String = "deleteTask"
    
    var taskList: [TaskInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
       
        taskList = ListReconstruction.sharedIntance.daleteTaskList
        
        deleteTaskTableView.delegate = self
        deleteTaskTableView.dataSource = self
        
        configureTableViewCell()
        
        deleteTaskTableView.reloadData()
    }
   
    func configureTableViewCell() {
        let nib = UINib(nibName: "DeleteTableViewCell", bundle: nil)
        let cellId = "DeleteCellID"
        
        deleteTaskTableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //rowの数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    //cellの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCellID", for: indexPath) as! DeleteTableViewCell
        if let limitTime = taskList[indexPath.row].limitTime {
            let dateUnix: TimeInterval = TimeInterval(limitTime)
            let date = NSDate(timeIntervalSince1970: dateUnix)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let dateStr: String = formatter.string(from: date as Date)
            cell.limitTimeLabel.text = dateStr
        }
        cell.taskTitleLabel.text = taskList[indexPath.row].taskTitle
        let status = taskList[indexPath.row].status
        if status == "open" {
            cell.taskStatusLabel.text = "未完了"
            cell.taskStatusLabel.backgroundColor = UIColor(red: 255/255, green: 51/255, blue: 51/255, alpha: 0.5)
        } else if status == "done" {
            cell.taskStatusLabel.text = "完了"
            cell.taskStatusLabel.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 0.5)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TaskDetailViewController()
        vc.TaskInfo = taskList[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //スワイプアクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //戻したデータを削除リストから削除
        ListReconstruction.sharedIntance.daleteTaskList.remove(at: indexPath.row)
        
        // 戻した時のアクションを設定する
        let returnAction = UIContextualAction(style: .destructive, title:"return") {
            (ctxAction, view, completionHandler) in
            //ユーザーデフォルトに削除したタスクのID登録
            var userDefaultArray: [Int] = []
            if let userDefaultData = UserDefaults.standard.array(forKey: self.userDefaultKey) {
                userDefaultArray = userDefaultData as! [Int]
            }
            for (i, value) in userDefaultArray.enumerated() {
                if value == self.taskList[indexPath.row].taskID {
                    userDefaultArray.remove(at: i)
                }
            }
            UserDefaults.standard.set(userDefaultArray, forKey: self.userDefaultKey)
            
            self.taskList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        // 戻すボタンのデザインを設定する
        let trashImage = UIImage(systemName: "arrowshape.turn.up.left.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
        returnAction.image = trashImage
        returnAction.backgroundColor = UIColor.cyan
    
        let swipeAction = UISwipeActionsConfiguration(actions:[returnAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
        
    }
}

