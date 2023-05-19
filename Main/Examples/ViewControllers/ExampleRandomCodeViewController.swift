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
        
        let frame = CGRect(x: view.center.x - 100, y: view.center.y - 33, width: 200, height: 66)
        
        let random = RandomCodeView(frame: frame) { res in
            kPrint(res)
        }
        view.addSubview(random)
    }
}
