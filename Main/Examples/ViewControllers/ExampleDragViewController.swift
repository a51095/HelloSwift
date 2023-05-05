//
//  ExampleDragViewController.swift
//  HelloSwift
//
//  Created by well on 2023/5/5.
//

import Foundation

class ExampleDragViewController: BaseViewController, ExampleProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        super.initSubview()
        
        let dragWidth = 80
        
        let drag = ScaleAspectView()
        view.addSubview(drag)
        drag.backgroundColor = .orange
        drag.frame = CGRect(x: view.frame.width.i - (20 + dragWidth), y: view.frame.height.i - (20 + dragWidth), width: dragWidth, height: dragWidth)
    }
}
