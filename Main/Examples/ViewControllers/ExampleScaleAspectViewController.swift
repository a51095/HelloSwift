//
//  ExampleScaleAspectViewController.swift
//  HelloSwift
//
//  Created by well on 2023/5/5.
//

import Foundation

class ExampleScaleAspectViewController: BaseViewController, ExampleProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        super.initSubview()
        
        let aspect = ScaleAspectView()
        view.addSubview(aspect)
        aspect.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height)
    }
}
