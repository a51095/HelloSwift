//
//  TreeNode.swift
//  HelloSwift
//
//  Created by macbook on 2022/11/9.
//

// 深度遍历
//             1

//          2  7   9

//      3   6      7   9

//   4  5          6    8


// 层次遍历
//level0                       P

//level1             A                   X

//level2          T    Z             M       K

//level3          Y                  L     F   C

class Queue<T> {
    var array: [T] = []
    
    // MARK: 入队列
    func enqueue(_ item: T) {
        array.append(item)
    }
    
    // MARK: 出队列
    func dequeue() -> T? {
        if array.isEmpty { return nil }
        return array.removeFirst()
    }
}

class TreeNode<T> {
    var value: T
    var children: [TreeNode] = []
    
    init(value: T) {
        self.value = value
    }
    
    func add(_ child: TreeNode) {
        children.append(child)
    }
}

extension TreeNode {
    // MARK: 深度遍历
    func forEachDepth(visit: (TreeNode) -> Void) {
        visit(self)
        
        children.forEach { child in
            child.forEachDepth(visit: visit)
        }
    }
    
    // MARK: 层级遍历
    func forEachLevel(visit: (TreeNode) -> Void) {
        visit(self)
        
        let queue = Queue<TreeNode>()
        
        children.forEach { child in
            queue.enqueue(child)
        }
        
        while let node = queue.dequeue()  {
            visit(node)
            node.children.forEach { child in
                queue.enqueue(child)
            }
        }
    }
}

extension TreeNode where T: Equatable {
    // MARK: 搜索查找
    func search(_ value: T) -> TreeNode? {
        var result: TreeNode?
        
        forEachDepth { item in
            if item.value == value { result = item }
        }
        
        return result
    }
}


//                     Drinks
//                  /            \
//                Hot            Cold
//           /    |     \         |   \
//        Tea   Coffee Cocoa    Milk   Water
//       /  |
//    Red  Green


/// 测试树状结构
class TreeNodeTest {
    
    init() {
        
        let drinks = TreeNode(value: "Drinks")
        
        let hot = TreeNode(value: "Hot")
        let cold = TreeNode(value: "Cold")
        
        let tea = TreeNode(value: "Tea")
        let coffee = TreeNode(value: "Coffee")
        let cocoa = TreeNode(value: "Cocoa")
        let milk = TreeNode(value: "Milk")
        let water = TreeNode(value: "Water")
        
        let red = TreeNode(value: "Red")
        let green = TreeNode(value: "Green")
        
        drinks.add(hot)
        drinks.add(cold)
        
        hot.add(tea)
        hot.add(coffee)
        hot.add(cocoa)
        
        cold.add(milk)
        cold.add(water)
        
        tea.add(red)
        tea.add(green)
        
        
//        // 深度遍历
//        drinks.forEachDepth { item in kPrint(item.value) }
//        // 层级遍历
//        drinks.forEachLevel { item in kPrint(item.value) }
    }
}


