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

        let dragSize = 80
        let drag = DragView()
        view.addSubview(drag)
        drag.frame = CGRect(x: view.frame.width.i - (4 + dragSize), y: view.frame.height.i - kSafeMarginBottom.i - dragSize, width: dragSize, height: dragSize)
    }
}
