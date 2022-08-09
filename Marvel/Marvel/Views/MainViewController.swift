//
//  ViewController.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private lazy var loadingView: LoadingView = {
        let loading =  LoadingView()
        loading.layer.zPosition = 999
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

