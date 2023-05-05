//
//  ExampleRandomCodeViewController.swift
//  HelloSwift
//
//  Created by well on 2023/5/5.
//

import UIKit
import Foundation

class ExampleRandomCodeViewController: BaseViewController, ExampleProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        super.initSubview()
        
        let random = RandomCodeView()
        view.addSubview(random)
        random.frame = CGRect(x: 0, y: 0, width: 200, height: 66)
        random.center = view.center
    
    }
}
