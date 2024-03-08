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
        let drag = DragView()
        view.addSubview(drag)
        drag.frame = CGRect(x: view.frame.width.i - (4 + dragWidth), y: view.frame.height.i - (4 + dragWidth), width: dragWidth, height: dragWidth)
    }
}
