//
//  ViewController.swift
//  Taskmanager
//
//  Created by kita kensuke on 2020/06/17.
//  Copyright © 2020 kita kensuke. All rights reserved.
//

import UIKit


class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        GetTaskData.sharedIntance.getArticles()

    }

    
}
