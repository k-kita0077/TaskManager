//
//  GetTaskData.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/17.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetTaskData {
    static let sharedIntance = GetTaskData()
    
    var articles: [TaskInfo] = []
    
    func getArticles() {
        articles = []
        let accountID: String = "4959977"
        let roomID: String = "192783695"
        let token: String = "a7dc656db6be417b3b0c1833279b023a"
        let url: String = "https://api.chatwork.com/v2/rooms/\(roomID)/tasks?account_id=\(accountID)"
        let Auth_header: HTTPHeaders = ["X-ChatWorkToken": token, "Content-Type": "application/json"]
        AF.request(url, method: .get, headers: Auth_header)
            .responseJSON { response in
                guard let object = response.data else {return}
                //print(response)
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    guard let body = json["body"].string else {return}
                    if body.contains("##") {
                        //タスク本文の終わり位置を取得
                        let detailIndex = body.range(of: "[/qt]")
                        let detailFlag = body.distance(from: body.startIndex, to: detailIndex!.lowerBound)
                        //タスクのセクション開始位置を取得
                        let sectionIndex = body.range(of: "##")
                        let sectionFlag = body.distance(from: body.startIndex, to: sectionIndex!.lowerBound) + 2
                        //セクションの終了位置を取得
                        let sectionEndIndex = body.range(of: "$$")
                        let sectionEndFlag = body.distance(from: body.startIndex, to: sectionEndIndex!.lowerBound)
                        //タスクのタイトル開始位置を取得
                        let titleFlag = sectionEndFlag + 2
                        //タスクのタイトル終了位置を取得
                        let endIndex = body.range(of: "%%")
                        let endFlag = body.distance(from: body.startIndex, to: endIndex!.lowerBound)
                        //タスク本文
                        let bodyDetail = body[body.index(body.startIndex, offsetBy: 40)..<body.index(body.startIndex, offsetBy: detailFlag)]
                        //タスクのセクション
                        let bodySection = body[body.index(body.startIndex, offsetBy: sectionFlag)..<body.index(body.startIndex, offsetBy: sectionEndFlag)]
                        //タスクのタイトル
                        let bodyTitle = body[body.index(body.startIndex, offsetBy: titleFlag)..<body.index(body.startIndex, offsetBy: endFlag)]
                        print(bodyDetail)
                        print(bodySection)
                        print(bodyTitle)
                        
                        let article: TaskInfo =
                            TaskInfo(
                                taskID: json["task_id"].int,
                                userID: json["assigned_by_account"]["account_id"].int,
                                body: String(bodyDetail),
                                status: json["status"].string,
                                limitTime: json["limit_time"].int,
                                sectionTitle: String(bodySection),
                                taskTitle: String(bodyTitle)
                        )
                        self.articles.append(article)
                        
                    }
                }
                //                guard let taskID = self.articles[0].taskID else {return}
                //                print(taskID)
                dump(self.articles)
                
                //self.table.reloadData()
        }
    }
    
}
