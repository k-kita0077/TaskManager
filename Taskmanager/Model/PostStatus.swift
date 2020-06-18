//
//  PostStatus.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/18.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PostStatus {
    
    func HttpRequest(taskInfo: TaskInfo, status: String) {
        guard let taskID = taskInfo.taskID else {return}
        let roomID: String = "192783695"
        let token: String = "a7dc656db6be417b3b0c1833279b023a"
        let url = "https://api.chatwork.com/v2/rooms/\(roomID)/tasks/\(taskID)/status"
        let headers: HTTPHeaders = [
            "X-ChatWorkToken": token,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters:[String: Any] = [
            "body": status
        ]

        AF.request(url, method: .put, parameters: parameters, headers: headers).responseJSON { response in
            switch(response.result) {
            case .success:
                print("成功")
            case .failure:
                print("エラー")
            }
        }

    }
}

