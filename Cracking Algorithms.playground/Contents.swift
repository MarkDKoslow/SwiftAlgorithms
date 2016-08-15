//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// Space & Time
// Lots of data
// Tradeoffs
// Leverage all the info given

// ?'s, Design, Psuedo, Code, Test

///////////////////////////////////////////////////////////
//////////////////  Strings  //////////////////////////////
///////////////////////////////////////////////////////////

extension String {
    func allUnique() -> Bool {
        let count = self.characters.count
        let setCount = Set(self.characters).count
        return count == setCount
    }
    
    func reverseCStyleString() -> String {
        // check for nil cases
        guard self.characters.count > 2 else { return self }
        
        // get the array up until second to last character

        // reverse
        
        // append nil value
        
        // return
        var returnString = ""
        let lastCharacterIndex = Int(self.characters.count) - 2
        for index in lastCharacterIndex.stride(through: 0, by: -1) {
            returnString.append(self[index])
        }
        
        return returnString
    }
    
    subscript(index: Int) -> Character {
        return self[self.startIndex.advancedBy(index)]
    }
    
    
}

"hellon".reverseCStyleString()

"hello hello hello".stringByReplacingOccurrencesOfString(" ", withString: "%20")


let das = "Hello World"
let ending = das.startIndex.advancedBy(6)..<das.endIndex
das[ending]

///////////////////////////////////////////////////////////
//////////////////  Arrays  ///////////////////////////////
///////////////////////////////////////////////////////////

// Question: Rotate an N*N matrix by 90 degrees

enum RotationError: ErrorType {
    case InvalidInput
    case InvalidMatrix
}

extension RotationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .InvalidInput:
            return "Must provide an array of arrays as input."
        case .InvalidMatrix:
            return "Must provide an N*N sized matrix with N > 1"
        }
    }
}

extension Array {
    func rotate() throws -> Array<[Int]> {
        guard self.count > 1 else { throw RotationError.InvalidMatrix }
        
        guard let firstRow = self[0] as? [Int] else { throw RotationError.InvalidInput }
        
        guard firstRow.count == self.count else { throw RotationError.InvalidMatrix }
        
        // [1,2,3]  [7,4,1]
        // [4,5,6]  [8,5,2]
        // [7,8,9]  [9,6,3]
        
        // (x,y) -> (y,|length - x|)
        
        var newMatrix = [[0,0,0], [0,0,0],[0,0,0]]
        for row in 0..<self.count {
            for column in 0..<firstRow.count {
                let columnIndex = self[row] as! [Int]
                newMatrix[column][abs(self.count - 1 - row)] = columnIndex[column]
            }
        }
        return newMatrix
    }
}

let newMatrix = try [[1,2,3],[4,5,6],[7,8,9]].rotate()

let sdads = "hello"
// String //
/*  Instance Variables
    .characters -> String.CharacterView
    .endIndex   -> Index
    .isEmpty    -> Bool
    .startIndex -> Index
    .subscript  -> Character
 
    Instance Methods
    .append(Character)
    .appendContentsOf(String)
    .caseInsensitiveCompare(String) -> NSComparisonResult
    .containsString(String) -> Bool
    .hasPrefix(String)
    .hasSuffix(String)
    .insert(Character) atIndex(Index)
    .insertContentsOf(String) at(Index)
    .substringFromIndex(Index)
    .substringToIndex(Index)
*/

 // String.CharacterView //
/*  Instance Variables
    .count -> Int
    .startIndex -> Index
    .endIndex -> Index
    .first -> Character?
    .last -> Character
 
    Instance Methods
    // Same as String, plus:
    .dropFirst()
    .dropLast()
    .indexOf(Character) -> Index
    .reverse() -> CharacterView
    .sort() -> [Character]
 */

///////////////////////////////////////////////////////////
//////////////////  Linked Lists  /////////////////////////
///////////////////////////////////////////////////////////

class Node {
    let value: Int
    var nextNode: Node?
    
    init(value: Int) {
        self.value = value
        self.nextNode = nil
    }
}

struct LinkedList {
    
    var head: Node?
    
    mutating func addNode(node: Node) {
        guard let head = self.head else { self.head = node; return }
        
        var current = head
        
        while current.nextNode != nil {
            current = current.nextNode!
        }
        
        current.nextNode = node
    }
    
    mutating func addNode(node: Node, atIndex index: Int) {
        guard let head = self.head else { return }
        
        var current = head
        
        for _ in 1..<index {
            if let next = current.nextNode {
                current = next
            }
        }
        current.nextNode = node
    }
    
    // 1 -> 3 -> 1 -> 4 -> 1 - > 3 -> 5
    // 1 -> 3 -> 4 -> 5
    
    // Start at head
    // Make sure length > 1
    // While current != nil
    // Add current to set
    // Get next value
    // Check if already in set
        // if so, remove & set .next to .next.next
        // else, add to set
        // current = current.next
    mutating func removeDups() {
        guard let head = self.head else { return }
        
        var current = head
        
        guard current.nextNode != nil else { return }
        
        var numbersSet = Set<Int>()
        
        numbersSet.insert(current.value)
        while current.nextNode != nil {
            if numbersSet.contains(current.nextNode!.value) {
                current.nextNode = current.nextNode!.nextNode
            } else {
                numbersSet.insert(current.nextNode!.value)
            }
            
            current = current.nextNode!
        }
    }
    
    func printValues() -> [Int] {
        var vals: [Int] = []
        
        guard let head = self.head else { return [] }
        
        var current = head
        
        guard current.nextNode != nil else { return [current.value] }
        
        repeat {
            vals.append(current.value)
            current = current.nextNode!
        } while (current.nextNode != nil)

        vals.append(current.value)
        return vals
    }
}

var linked = LinkedList(head: Node(value: 1))
linked.addNode(Node(value: 3))
linked.addNode(Node(value: 1))
linked.addNode(Node(value: 4))
linked.addNode(Node(value: 1))
linked.addNode(Node(value: 5))
let lolol = linked.printValues()
linked.removeDups()
linked.printValues()

///////////////////////////////////////////////////////////
//////////////////  Stacks  ///////////////////////////////
///////////////////////////////////////////////////////////

struct Stack<T: Comparable> {
    var stack: [T]
    
    init(input: [T]) {
        self.stack = input
    }
    
    init() {
        self.stack = []
    }
    
    mutating func push(element: T) {
        stack.append(element)
    }
    
    mutating func pop() -> T? {
        guard !stack.isEmpty else { return nil }
        return stack.removeLast()
    }
    
    func peek() -> T? {
        guard !stack.isEmpty else { return nil }
        return stack.last
    }
    
    var isEmpty: Bool {
        return stack.isEmpty
    }
}

var stackystack = Stack(input: [5,2,1,3,4])
//print(stackystack.sorted())


struct CustomTriStack<T> {
    var array: [(Int?, T)?]
    var lastIndexOfFirstStack: Int?
    var lastIndexOfSecondStack: Int?
    var lastIndexOfThirdStack: Int?
    var unusedSpaces: [Int] = []
    
    mutating func pushToFirstStack(value: T) {
        if !unusedSpaces.isEmpty {
            let unusedIndex = unusedSpaces.removeFirst()
            array.insert((lastIndexOfFirstStack, value), atIndex: unusedIndex)
            lastIndexOfFirstStack = unusedIndex
        } else {
            array.append((lastIndexOfFirstStack, value))
            lastIndexOfFirstStack = array.count - 1
        }
    }
    
    mutating func popFromFirstStack() -> T? {
        guard let lastIndex = lastIndexOfFirstStack, poppedElement = array[lastIndex] else { return nil }
        
        array[lastIndex] = nil
        lastIndexOfFirstStack = poppedElement.0
        unusedSpaces.append(poppedElement.0!)
        
        return poppedElement.1
    }
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

struct TupleNode<T: Comparable> {
    let element: (T,T)
}

struct MinStack<T: Comparable> {
    var array: [TupleNode<T>]
    
    mutating func push(value: T) {
        guard let lastElement = array.last else { push(TupleNode(element: (value, value))); return }
        
        if lastElement.element.0 > lastElement.element.1 {
            self.push(TupleNode(element: (value, lastElement.element.1)))
        } else {
            self.push(TupleNode(element: (value, lastElement.element.0)))
        }
    }
    
    mutating private func push(node: TupleNode<T>) {
        array.append(node)
    }
    
    mutating func pop() -> TupleNode<T> {
        return array.removeLast()
    }
    
    mutating func minElement() -> T? {
        return array.last?.element.1 ?? nil
    }
}

let emptyArray: [TupleNode<Int>] = []
var stack = MinStack(array: emptyArray)

stack.push(3)
stack.pop().element
stack.push(3)
stack.push(4)
stack.push(1)
stack.push(2)
stack.minElement()
stack.pop()
stack.pop()
stack.minElement()

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

struct InnerStack {
    var capacity: Int = 3
    var array: [Int]
    
    init(array: [Int]) {
        self.array = array
    }
    
    mutating func push(value: Int) {
        array.append(value)
    }
    
    mutating func pop() -> Int {
        return array.removeLast()
    }
}

struct CapacityStack {
    var contents: [InnerStack] = []
    
//    func peek() -> Int? {
//        guard let topStack = self.contents.last else { return nil }
//    }
    
    mutating func push(value: Int) {
        guard let top = self.contents.last else { return }
        var topStack = top

        if topStack.array.count < topStack.capacity {
            topStack.push(value)
        } else {
            contents.append(InnerStack(array: [value]))
        }
    }
    
    mutating func pop() -> Int? {
        guard let top = self.contents.last else { return nil }
        var topStack = top
        
        if topStack.array.isEmpty { contents.removeLast() }
        
        let popValue = topStack.array.removeLast()
        if topStack.array.isEmpty { contents.removeLast() }
        
        return popValue
    }
}

var capStack = CapacityStack()
capStack.pop()
capStack.push(1)
capStack.push(2)
capStack.push(3)
capStack.pop()

struct Queue<T> {
    var popStack: [T]
    var putStack: [T]
    
    init() {
        popStack = []
        putStack = []
    }
    
    mutating func push(newValue: T) {
        putStack.append(newValue)
    }
    
    mutating func pop() -> T? {
        if !popStack.isEmpty {
            return popStack.removeLast()
        }
        
        if !putStack.isEmpty {
            popStack = putStack.reverse()
            putStack = []
            return popStack.removeLast()
        }
        
        return nil
    }
    
    func peek() -> T? {
        if let lastItem = popStack.last {
            return lastItem
        }
        
        if let firstFromPushStack = putStack.first {
            return firstFromPushStack
        }
        
        return nil
    }
    
    func isEmpty() -> Bool {
        return peek() == nil
    }
}

var q = Queue<Int>()
q.push(0)
q.push(1)
q.push(2)
q.push(3)
q.pop()
q.push(4)
q.push(5)
q.putStack // 4,5
q.popStack // 3,2,1
q.pop()
q.pop()
q.pop()
q.pop()
q.putStack // nil
q.popStack // 5
q.pop()
q.pop()

///////////////////////////////////////////////////////////
//////////////////  Trees  ////////////////////////////////
///////////////////////////////////////////////////////////

class Tree {
    private var root: TreeNode
    
    init(root: TreeNode) {
        self.root = root
    }
    
    // Print Tree
    func printTree() -> String {
        return printTree(root)
    }
    
    func printTree(currentNode: TreeNode) -> String {
        var s = ""
        
        if let left = currentNode.leftNode {
            s = "(\(printTree(left))) <- " + s
        }
        s += "\(currentNode.value)"
        if let right = currentNode.rightNode {
            s += "-> (\(printTree(right)))"
        }
        return s
    }
    
    // AddNode
    func addNode(value: Int) {
        addNode(TreeNode(value: value))
    }
    
    private func addNode(newNode: TreeNode) {
        addNode(newNode, currentNode: root)
    }
    
    private func addNode(newNode: TreeNode, currentNode: TreeNode) {
        if newNode.value > currentNode.value {
            if let rightChild = currentNode.rightNode {
                addNode(newNode, currentNode: rightChild)
            } else {
                currentNode.rightNode = newNode
            }
        } else {
            if let leftChild = currentNode.leftNode {
                addNode(newNode, currentNode: leftChild)
            } else {
                currentNode.leftNode = newNode
            }
        }
    }
    
    // Build Tree
    func buildTree() {
        addNode(4)
        addNode(1)
        addNode(8)
        addNode(6)
        addNode(9)
    }
    
    // In Order
    func inOrderTraversal() {
        inOrderTraversal(root)
    }
    
    private func inOrderTraversal(currentNode: TreeNode?) {
        guard let current = currentNode else { return }
        
        if current.leftNode != nil { inOrderTraversal(current.leftNode) }
        print(current.value)
        if current.rightNode != nil { inOrderTraversal(current.rightNode) }
    }
    
    // Pre Order
    func preOrderTraversal() {
        preOrderTraversal(root)
    }
    
    private func preOrderTraversal(currentNode: TreeNode?) {
        guard let current = currentNode else { return }
        
        print(current.value)
        if current.leftNode != nil { preOrderTraversal(current.leftNode) }
        if current.rightNode != nil { preOrderTraversal(current.rightNode) }
    }
    
    // Post Order
    func postOrderTraversal() {
        postOrderTraversal(root)
    }
    
    private func postOrderTraversal(currentNode: TreeNode?) {
        guard let current = currentNode else { return }
        
        if current.leftNode != nil { postOrderTraversal(current.leftNode) }
        if current.rightNode != nil { postOrderTraversal(current.rightNode) }
        print(current.value)
    }
    
    // Is BST?
    func isBST() -> Bool {
        return isBST(root, lowerBound: Int.min, upperBound: Int.max)
    }
    
    private func isBST(currentNode: TreeNode?, lowerBound: Int, upperBound: Int) -> Bool {
        guard let current = currentNode else { return true }
        
        if lowerBound > current.value || current.value > upperBound {
            return false
        }
        
        let isLeftBST = isBST(current.leftNode, lowerBound: lowerBound, upperBound: current.value)
        
        let isRightBST = isBST(current.rightNode, lowerBound: current.value, upperBound: upperBound)
        
        return isLeftBST && isRightBST
    }
    
    // Is Balanced?
    func isBalanced() -> Bool {
        return maxDepth(root) - minDepth(root) <= 1
    }
    
    func maxDepth(currentNode: TreeNode?) -> Int {
        guard let current = currentNode else { return 0 }
        
        return 1 + max(maxDepth(current.leftNode), maxDepth(current.rightNode))
    }
    
    func minDepth(currentNode: TreeNode?) -> Int {
        guard let current = currentNode else { return 0 }
        
        return 1 + min(minDepth(current.leftNode), minDepth(current.rightNode))
    }

    // [0,1,2,3,4,5,6,7,8,9,10]
    // 4.3 - Sorted Array -> Tree of shortest possible depth
    func arrayToTree(array: [Int]) -> TreeNode? {
        guard array.count > 0 else { print("hit it"); return nil }
        
        guard array.count > 1 else { print("yolo"); return TreeNode(value: array[0]) }
        print(array)
        
        let middleIndex = array.count / 2
        let middleNode = TreeNode(value: array[middleIndex])
        
        middleNode.leftNode = arrayToTree(Array(array[0..<middleIndex]))
        middleNode.rightNode = arrayToTree(Array(array[middleIndex + 1..<array.count]))
        
        return middleNode
    }
    
    // Next node (in terms of value)
    func nextNode(value: Int) -> Int? {
        let nodeOptional = findNode(value)
        
        guard let node = nodeOptional else { return nil }
        print(node.value)
        // Find minimum node starting at current.right
        if let rightChild = node.rightNode {
            return minimumChildStartingAtNode(rightChild)
        }
        else { // Otherwise find parent node
            let parentValue = findParentNodeForValue(value)
            return parentValue > value ? parentValue : nil
        }
    }
    
    func findNode(value: Int) -> TreeNode? {
        return findNode(self.root, value: value)
    }
    
    func findNode(currentNode: TreeNode?, value: Int) -> TreeNode? {
        print(value)
        guard let current = currentNode else { return nil }
        print(current.value)
        if current.value == value { return currentNode }
        
        if current.value < value {
            if let rightChild = current.rightNode {
                return findNode(rightChild, value: value)
            } else {
                return nil
            }
        }
        else {
            if let leftChild = current.leftNode {
                return findNode(leftChild, value: value)
            } else {
                return nil
            }
        }
    }
    
    func findParentNodeForValue(value: Int) -> Int? {
        return findParentNodeForValue(self.root, value: value)
    }
    
    func findParentNodeForValue(currentNode: TreeNode, value: Int) -> Int? {
        print(currentNode.value)
        if value > currentNode.value {
            if let rightChild = currentNode.rightNode {
                return (rightChild.value == value) ? currentNode.value : findParentNodeForValue(rightChild, value: value)
            } else {
                return nil
            }
        } else {
            if let leftChild = currentNode.leftNode {
                return (leftChild.value == value) ? currentNode.value : findParentNodeForValue(leftChild, value: value)
            } else {
                return nil
            }
        }
    }
    
    func minimumChildStartingAtNode(node: TreeNode) -> Int {
        var minimumChildOfSubstree = node
        while minimumChildOfSubstree.leftNode != nil {
            minimumChildOfSubstree = minimumChildOfSubstree.leftNode!
        }
        return minimumChildOfSubstree.value
    }
    
    func commonAncestor(v1: Int, v2: Int) -> Int? {
        return commonAncestor(self.root, v1: v1, v2: v2)
    }
    
    // Common Ancestor
    func commonAncestor(currentNode: TreeNode?, v1: Int, v2: Int) -> Int? {
        guard let current = currentNode else { return nil }
        
        if let leftNode = current.leftNode {
            if leftNode.contains(v1, v2: v2) {
                return commonAncestor(leftNode, v1: v1, v2: v2)
            }
        }
        
        if let rightNode = current.rightNode {
            if rightNode.contains(v1, v2: v2) {
                return commonAncestor(rightNode, v1: v1, v2: v2)
            }
        }
        
        if current.contains(v1, v2: v2) {
            return current.value
        }
        
        return nil
    }
    
    // Find Path with Sum
    func findAllPathsWithSum(target: Int) -> [[Int]] {
        return findAllPathsWithSum(self.root, target: target)
    }
    
    func findAllPathsWithSum(currentNode: TreeNode, target: Int) -> [[Int]] {
        let paths = findAllPaths(currentNode)
        var matches: [[Int]] = []
        
        for path in paths {
            var localPath = path
            if localPath.sum() == target { matches.append(localPath) }
            var popArray: [Int] = []
            while !localPath.isEmpty {
                popArray.append(localPath.popLast()!)
                if popArray.sum() == target { matches.append(popArray) }
                if localPath.sum() == target { matches.append(localPath) }
            }
        }
        
        return matches
    }
    
    func findAllPaths(root: TreeNode) -> [[Int]] {
        return findAllPaths(root, paths: [[root.value]])
    }
    
    func findAllPaths(currentNode: TreeNode?, var paths: [[Int]] ) -> [[Int]] {
        guard let current = currentNode else { return [] }
        
        let leftPath = findAllPaths(current.leftNode, paths: paths)
        
        let rightPath = findAllPaths(current.rightNode, paths: paths)
        
        var paths = rightPath + leftPath
        
        if paths.isEmpty {
            paths = [[current.value]]
        }
        
        var returnPaths: [[Int]] = []
        for path in paths {
            returnPaths.append(path + [current.value])
        }
        
        return returnPaths
    }
    
}

class BinaryTree: Tree {
    // Randomly adds nodes
    override private func addNode(newNode: TreeNode, currentNode: TreeNode) {
        if 0.5 < drand48() {
            if let rightChild = currentNode.rightNode {
                addNode(newNode, currentNode: rightChild)
            } else {
                currentNode.rightNode = newNode
            }
        } else {
            if let leftChild = currentNode.leftNode {
                addNode(newNode, currentNode: leftChild)
            } else {
                currentNode.leftNode = newNode
            }
        }
    }
    
}

extension Array {
    func sum() -> Int {
        var sum: Int = 0
        for element in self where element is Int {
            sum += element as! Int
        }
        return sum
    }
}

class TreeNode {
    var leftNode: TreeNode?
    var rightNode: TreeNode?
    var value: Int
    
    init(value: Int) {
        self.leftNode = nil
        self.rightNode = nil
        self.value = value
    }
    
    func contains(v1: Int, v2: Int) -> Bool {
        return contains(self, value: v1) && contains(self, value: v2)
    }
    
    func contains(currentNode: TreeNode?, value: Int) -> Bool {
        guard let current = currentNode else { return false }
        
        if current.value == value { return true }
        
        return contains(current.leftNode, value: value) || contains(current.rightNode, value: value)
    }
}

let tree = Tree(root: TreeNode(value: 5))
tree.buildTree()
tree.printTree()
tree.inOrderTraversal()
tree.preOrderTraversal()
tree.postOrderTraversal()
tree.isBST()
tree.isBalanced()
tree.nextNode(1)
tree.commonAncestor(4, v2: 6)
tree.findAllPathsWithSum(14)

let errorTree = BinaryTree(root: TreeNode(value: 10))
errorTree.buildTree()
errorTree.printTree()
errorTree.isBalanced()

///////////////////////////////////////////////////////////
//////////////////  Graphs  ///////////////////////////////
///////////////////////////////////////////////////////////

struct Graph {
    let root: Vertex
    var vertices: [Vertex]
    
    init(root: Vertex) {
        self.root = root
        self.vertices = [root]
    }
    
    class Vertex {
        let value: Int
        var neighbors: [Vertex] = [Vertex]()
        var wasVisited = false
        
        internal init(value: Int, neighbors: [Vertex] = []) {
            self.value = value
            self.neighbors = neighbors
        }
        
        func addConnection(vertex: Vertex) {
            addConnections([vertex])
        }
        
        func addConnections(vertex: [Vertex]) {
            neighbors.appendContentsOf(vertex)
        }
    }
    
    // Depth First Search
    func dfs() {
        return dfs(root, valueStack: Stack(input: []))
    }
    
    private func dfs(vertex: Vertex, valueStack: Stack<Int>) {
        print(vertex.value)
        var localValueStack = valueStack
        
        for i in vertex.neighbors {
            if i.wasVisited == false {
                i.wasVisited = true
                localValueStack.push(i.value)
                dfs(i, valueStack: localValueStack)
            }
        }
    }
    
    // Breadth First Search
    func bfs() {
        return bfs(root)
    }
    
    func bfs(vertex: Vertex) {
        var q = Queue<Vertex>()
        q.push(vertex)
        
        while !q.isEmpty() {
            let current = q.pop()!
            print(current.value)
            
            for i in current.neighbors where !i.wasVisited {
                i.wasVisited = true
                q.push(i)
            }
        }
    }
    
    // Create graph
    static func createGraph() -> Graph {
        let graph = Graph(root: Graph.Vertex(value: 1, neighbors: []))
        
        let vertex2 = Graph.Vertex(value: 2)
        let vertex3 = Graph.Vertex(value: 3)
        let vertex4 = Graph.Vertex(value: 4)
        let vertex5 = Graph.Vertex(value: 5)
        let vertex6 = Graph.Vertex(value: 6)
        let vertex7 = Graph.Vertex(value: 7)
        
        graph.root.addConnection(vertex2)
        vertex2.addConnections([vertex4, vertex5])
        vertex3.addConnection(vertex6)
        vertex4.addConnection(vertex7)
        vertex5.addConnection(vertex3)
        vertex6.addConnection(vertex7)
        
        return graph
    }
}

let graph1 = Graph.createGraph()
let graph2 = Graph.createGraph()

graph1.bfs()
graph2.dfs()


///////////////////////////////////////////////////////////
//////////////////  OOD  ////////////////////////////////
///////////////////////////////////////////////////////////

// Deck of Cards

class Deck {
    var availableCards: [Card]
    let unavailableCards: [Card]
    
    var totalDeck: [Card] {
        return availableCards + unavailableCards
    }
    
    init() {
        self.unavailableCards = []
        self.availableCards = []
        createDeck()
        print(availableCards)
    }
    
    func createDeck() {
        let suitValues = Card.Suit.allValues
        let rankValues = Card.Rank.allValues
        
        self.availableCards = rankValues.flatMap { rank in
            suitValues.map { suit in
                return Card(rank: rank, suit: suit)
            }
        }
    }
}

class Card {
    let suit: Suit
    let rank: Rank
    
    init(rank: Rank, suit: Suit) {
        self.suit = suit
        self.rank = rank
    }
    
    enum Suit: String{
        case Diamond = "diamond", Heart = "heart", Spade = "spade", Club = "club"
        
        static let allValues = [Diamond, Heart, Spade, Club]
    }
    
    enum Rank: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace
        
        static let allValues = [Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace]
    }
}

let jackOfHearts = Card(rank: .Jack, suit: .Heart)
jackOfHearts.rank.rawValue


let deck = Deck()
deck.availableCards

// Chess
//

// Combinations
//
func allCombinations(values: [String]) -> [String] {
    var retArray: [String] = []
    if values.count == 1 { return values }
    
//    for i in 0..<values.count {
        var localValues = values
        let currentValue = localValues.removeFirst()
        let subsets = allCombinations(localValues)
        for j in subsets {
            retArray.append(currentValue + j)
        }
//    }
    return retArray
}

let allCombos = allCombinations(["1","2","3","4"])

// Permutations
//
func allPermutations(values: [String]) -> [String] {
    var retArray: [String] = []
    if values.count == 1 { return values }
    for i in 0..<values.count {
        var localValues = values
        localValues.removeAtIndex(i)
        let otherValueCombinations = allPermutations(localValues)
        for j in otherValueCombinations {
            let addedValue = values[i] + j
            retArray.append(addedValue)
        }
    }
    
    return retArray
}

let allPerms = allPermutations(["1","2","3","4"])

// All Parenthesis Combinations
//

// Naive Approach
func allParens(count: Int) -> [String] {
    if count == 1 { return ["()"] }
    
    var returnSet: Set = Set<String>()
    let allParenValues = allParens(count - 1)
    
    for value in allParenValues {
        returnSet.insert("()" + value)
        returnSet.insert("(" + value + ")")
        returnSet.insert(value + "()")
    }
    
    return Array(returnSet)
}

let allValues = allParens(4)

// Better Approach
func allParens2(count: Int) -> [String] {
    return allParens2(["("], leftParensRemaining: count - 1, rightParensRemaining: count)
}

func allParens2(configurations: [String], leftParensRemaining: Int, rightParensRemaining: Int) -> [String] {
    guard leftParensRemaining > 0 || rightParensRemaining > 0 else { return configurations }
    
    guard leftParensRemaining <= rightParensRemaining else { return [] }
    
    var returnArray: [String] = []
    if leftParensRemaining > 0 {
        let localConfigs = configurations
        let leftSubTree = allParens2(localConfigs.map{ $0 + "(" }, leftParensRemaining: leftParensRemaining - 1, rightParensRemaining: rightParensRemaining)
        returnArray.appendContentsOf(leftSubTree)
    }
    if rightParensRemaining > 0 {
        let localConfigs = configurations
        let rightSubtree = allParens2(localConfigs.map{ $0 + ")" }, leftParensRemaining: leftParensRemaining, rightParensRemaining: rightParensRemaining - 1)
        print(rightSubtree)
        returnArray.appendContentsOf(rightSubtree)
    }
    return returnArray
}

let returnedvalues = allParens2(3)

// Base Case then Generalize
// Pseudocode step by step
// Function Signature

// Naive Implementation
func numCombos(sum: Int) -> Int {
    var totalCombinations = 0
    
    let numQuarters = (sum / 25) + 1
    
    for q in 0..<numQuarters {
        let runningSum = sum - (25 * q)
        let numDimes = (runningSum / 10) + 1
        
        for d in 0..<numDimes {
            let runningSum2 = runningSum - (10 * d)
            let numNickels = (runningSum2 / 5) + 1
            
            for _ in 0..<numNickels {
                totalCombinations += 1
            }
        }
    }
    return totalCombinations
}

numCombos(5)
numCombos(10)
numCombos(11)
numCombos(25)
numCombos(89)

// MUCH Better Implementation
enum CoinValues: Int {
    case Penny = 1
    case Nickel = 5
    case Dime = 10
    case Quarter = 25
}
func numCombinations(sum: Int) -> Int {
    return numCombinations(sum, denom: .Quarter)
}

func numCombinations(sum: Int, denom: CoinValues) -> Int {
    var combinations = 0
    switch denom {
    case .Quarter:
        let numQuarters = sum / 25 + 1
        for q in 0..<numQuarters {
            combinations += numCombinations(sum - q * 25, denom: .Dime)
        }
    case .Dime:
        let numDimes = sum / 10 + 1
        for d in 0..<numDimes {
            combinations += numCombinations(sum - d * 10, denom: .Nickel)
        }
    case .Nickel:
        let numNickels = sum / 5 + 1
        for n in 0..<numNickels {
            combinations += numCombinations(sum - n * 5, denom: .Penny)
        }
    case .Penny:
        combinations += 1
    }
    
    return combinations
}

numCombinations(25)
numCombinations(89)

extension Tree {
    func isBST2() -> Bool {
        return isBST2(self.root, min: Int.min, max: Int.max)
    }
    
    func isBST2(currentNode: TreeNode?, min: Int, max: Int) -> Bool {
        guard let current = currentNode else { return true }
        
        guard current.value > min && current.value < max else { return false }
        
        return isBST2(current.leftNode, min: min, max: current.value) && isBST2(current.rightNode, min: current.value, max: max)
    }
}

tree.isBST2()



