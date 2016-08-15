//: Playground - noun: a place where people can play

import UIKit

///////////////     Swift Algorithms    //////////////////////

///////////////////////////////////////
//////// Chapter 2: Sorting ///////////
///////////////////////////////////////

var unsortedArray = [2,72,54,12,73,48,42,64,23,87,1]

// Insertion Sort
//

func insertionSort(numberList: [Int]) -> [Int] {
    var copyArray = numberList
    // incrementer
    for var i = 0; i < copyArray.count; i++ {
        let currentNum = copyArray[i]
        
        for (var j = i-1; j >= 0; j--) {
            let comparisonNum = copyArray[j]
            if (currentNum < comparisonNum) {
                copyArray[i] = comparisonNum
                copyArray[j] = currentNum
                i--
            }
        }
    }
    return copyArray
}

insertionSort(unsortedArray)

// Bubble Sort
//

func bubbleSort(var inputArray: [Int]) -> [Int] {

    var unresolvedLength = inputArray.count // Length that still needs to be sorted
    
    for _ in 0...inputArray.count - 1 {
        var currentIndex = 0

        for (var j = 1; j < unresolvedLength; j++) {
            if (inputArray[currentIndex] > inputArray[j]) {
                let temp = inputArray[currentIndex]
                inputArray[currentIndex] = inputArray[j]
                inputArray[j] = temp
            }
            currentIndex++
        }
        unresolvedLength--
    }
    return inputArray
}

bubbleSort(unsortedArray)
3/2

// Merge Sort
//
func mergeSort(input: [Int]) -> [Int] {
    // error handling
    let length = input.count
    
    // base case: if length == 1; return
    if (length <= 1) { return input }
    
    // split in two
    let halfwayIndex = length / 2
    let firstHalfOfArray: [Int] = Array(input[0..<halfwayIndex])
    print(firstHalfOfArray)
    let secondHalfOfArray: [Int] = Array(input[halfwayIndex..<length])
    print(secondHalfOfArray)
    
    // merge each side
    let firstHalfMerge = mergeSort(firstHalfOfArray)
    let secondHalfMerge = mergeSort(secondHalfOfArray)
    print("This was run")
    // combine
    let combinedMerge = combine(firstHalfMerge, input2: secondHalfMerge)
    
    // return
    return combinedMerge
}

func combine(input1: [Int], input2: [Int]) -> [Int] {
    print(input1)
    print(input2)
    var firstIncrementor = 0
    var secondIncrementor = 0
    
    let totalLength = input1.count + input2.count
    var retArray: [Int] = []
    
    while (firstIncrementor + secondIncrementor < totalLength) {
        if (input1[firstIncrementor] < input2[secondIncrementor]) {
            retArray.append(input1[firstIncrementor])
            firstIncrementor += 1
        } else {
            retArray.append(input2[secondIncrementor])
            secondIncrementor += 1
        }
        
        if (firstIncrementor == input1.count) {
            retArray.append(input2[secondIncrementor])
            secondIncrementor += 1
        }
    }
    return retArray
}

//mergeSort(unsortedArray)


////////////////////////////////////////////
//////// Chapter 2: Linked Lists ///////////
////////////////////////////////////////////


class Node<T> {
    var value: T
    var previousNode: Node?
    var nextNode: Node?
    
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T: Equatable> {
    var head: Node<T>?
    
    func addLink(val: T) {
        let newNode = Node(value: val)
        
        guard (self.head != nil) else {
            self.head = newNode
            return
        }
        
        var currentNode: Node = self.head!
        
        while (currentNode.nextNode != nil) {
            currentNode = currentNode.nextNode!
        }
        
        currentNode.nextNode = newNode
        newNode.previousNode = currentNode
    }
    
    func printLinkedList() -> [T] {
        guard var currentNode = self.head else { return [] }
        
        var valueArray = [T]()
        
        while (currentNode.nextNode != nil) {
            valueArray.append(currentNode.value)
            currentNode = currentNode.nextNode!
        }
        valueArray.append(currentNode.value)
        
        return valueArray
    }
    
    var count: Int {
        if head == nil { return 0 }
        
        var count = 1
        var currentNode = head
        
        while currentNode?.nextNode != nil {
            currentNode = currentNode?.nextNode
            count++
        }
        return count
    }
}

var LL = LinkedList<Int>()
LL.head = Node(value: 4)
LL.addLink(3)
LL.addLink(10)
LL.printLinkedList()
LL.count

////////////////////////////////////////////
//////// Chapter 3: Generics, Trees ////////
////////////////////////////////////////////

class TreeNode<T: Comparable> {
    var value: Int
    var leftChild: TreeNode?
    var rightChild: TreeNode?
    
    init(value: Int, leftChild: TreeNode? = nil, rightChild: TreeNode? = nil) {
        self.value = value
        self.leftChild = leftChild
        self.rightChild = rightChild
    }
}

class BST<T: Comparable> {
    var root: TreeNode<T>?
    
    init(node: TreeNode<T>) {
        root = node
    }
    
    func addNode(newNode: TreeNode<T>) {
        if let root = root {
            addNode(newNode, withRootNode: root)
        } else {
            root = newNode
        }
    }
    
    func addNode(newNode: TreeNode<T>, withRootNode currentNode: TreeNode<T>) {
        
        if currentNode.value > newNode.value {
            if let leftChild = currentNode.leftChild {
                addNode(newNode, withRootNode: leftChild)
            } else {
                currentNode.leftChild = newNode
            }
        } else {
            if let rightChild = currentNode.rightChild {
                addNode(newNode, withRootNode: rightChild)
            } else {
                currentNode.rightChild = newNode
            }
        }
    }
    
    func printTree() {
        if let root = root {
            printTree(root, retArray: [])
        } else {
            print("Tree is empty")
        }
    }
    
    func printTree(currentNode: TreeNode<T>?, var retArray: [Int]) {
        if (currentNode == nil) {
            return
        }
        
        // recurse left
        if let leftChild = currentNode?.leftChild {
            printTree(leftChild, retArray: retArray)
        }
        // print current node
        
        if let currentNode = currentNode {
            retArray.append(currentNode.value)
            print(retArray)
        }
        
        // recurse right
        if let rightChild = currentNode?.rightChild {
            printTree(rightChild, retArray: retArray)
        }
    }
}
let node: TreeNode<Int> = TreeNode(value: 5)
let myBST = BST(node: node)
myBST.root?.value

myBST.addNode(TreeNode(value: 4))
myBST.addNode(TreeNode(value: 5))
myBST.addNode(TreeNode(value: 8))
myBST.addNode(TreeNode(value: 3))
myBST.addNode(TreeNode(value: 1))
myBST.printTree()

////////////////////////////////////////////
//////////// Chapter 4: Tries //////////////
////////////////////////////////////////////

class TrieNode {
    var key: String?
    var children: [TrieNode]?
    let final: Bool?
    let level: Int?
    
    init(key: String, children: [TrieNode], final: Bool, level: Int){
        self.key = key
        self.children = children
        self.final = final
        self.level = level
    }
}

class TrieTree {
    var root: TrieNode = TrieNode(key: "", children: [], final: true, level: 0)
    
    func addTrieNode(keyword: String) {
        addTrieNode(keyword, currentNode: root, currentLevel: 0)
    }
    
    func addTrieNode(keyword: String, currentNode: TrieNode, currentLevel: Int) {
        // if node == keyword, return
        if currentNode.key == keyword { return } // Key already exists
        
        // does the node have a child with key == keyword[0,currentLevel]
        while (currentNode.level != currentLevel) {

            var key = keyword[keyword.startIndex..<keyword.startIndex.advancedBy(currentLevel)]
//            newNode?.key =
            guard let children = currentNode.children else { break }
            
            for childNode in children {
                if childNode.key == key {
                    addTrieNode(keyword, currentNode: childNode, currentLevel: currentLevel+1)
                    break
                }
            }
            
            currentNode.children?.append(TrieNode(key: key, children: [], final: true, level: currentLevel))
        }
    }
    
    func printTrie() {
        printTrie(self.root)
    }
    
    func printTrie(node: TrieNode) {
        print(node.key)
        
        if let children = node.children {
            for child in children {
                printTrie(child)
            }
        }
    }
}

let trie = TrieTree()
trie.addTrieNode("A")
trie.printTrie()


////////////////////////////////////////////
//////////// Queues & Stacks ///////////////
////////////////////////////////////////////

struct Stack<T> {
    var values: [T]
    
    init(values: [T]) {
        self.values = values
    }
    
    init() {
        self.values = []
    }
    
//    init(stringLiteral: StringLiteralType) {
//        self.values = stringLiteral
//    }
    
    func pop() -> T? {
        return values.last
    }
    
    mutating func push(value: T) {
        values.append(value)
    }
    
    mutating func push(newValues: [T]) {
        values.appendContentsOf(newValues)
    }
}


var myStack = Stack(values: [1,2,3])
myStack.pop()
myStack.push(4)
myStack.pop()
myStack.push([5,6,7])
myStack.pop()

struct Queue<T> {
    private var pushStack: [T] = []
    private var popStack: [T] = []
    
    init(value: T) {
        popStack.append(value)
    }
    
    mutating func dequeue() -> T? {
        if !popStack.isEmpty {
            return popStack.removeLast()
        }
        
        popStack = pushStack.reverse()
        pushStack = []
        
        return popStack.removeLast()
    }
    
    mutating func enqueue(value: T) {
        pushStack.append(value)
    }
}

var myQ = Queue(value: 0)
myQ.enqueue(1)
myQ.enqueue(2)
myQ.enqueue(3)
myQ.dequeue()
myQ.dequeue()
myQ.dequeue()
myQ.dequeue()
myQ.enqueue(4)
myQ.enqueue(5)
myQ.dequeue()
myQ.dequeue()







