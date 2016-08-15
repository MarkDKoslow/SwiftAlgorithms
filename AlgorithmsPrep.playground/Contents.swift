// 1: Queues
// 2: Stacks
// 3: Trees
// 4. Graphs
// 5: Sorting

import UIKit

// TO DO: Replace Node with Tree.Node and put within Tree class
// Create separate Node class for Queue

/////////////////////////////////////////////////////////
///////////////////  Queue  /////////////////////////////
/////////////////////////////////////////////////////////

class LLNode {
    let value: Int
    let next: LLNode?
    
    init(value: Int, next: LLNode? = nil) {
        self.value = value
        self.next = next
    }
}

class Queue<T> {
    private var popStack: [T] = []
    private var putStack: [T] = []
    
    init() {}
    
    init(node: T) {
        popStack.append(node)
    }
    
    func enqueue(node: T) {
        putStack.append(node)
    }
    
    func dequeue() -> T? {
        if !popStack.isEmpty {
            return popStack.removeLast()
        }
        
        popStack = putStack.reverse()
        putStack = []
        
        return popStack.removeLast()
    }
    
    var isEmpty: Bool {
        return popStack.isEmpty && putStack.isEmpty
    }
}

/////////////////////////////////////////////////////////
///////////////////  Stack  /////////////////////////////
/////////////////////////////////////////////////////////

class Stack<T> {
    private var stack: [T] = []
    
    init() {}
    
    func push(value: T) {
        stack.append(value)
    }
    
    func pop() -> T? {
        guard stack.isEmpty == false else { return nil }
        
        return stack.removeLast()
    }
    
    var isEmpty: Bool { return stack.isEmpty }
}

/////////////////////////////////////////////////////////
///////////////////  Trees  /////////////////////////////
/////////////////////////////////////////////////////////

// 1. Add Node (addNode)
// 2. Print Tree (printTree)
// 3. PrintAllPaths (printAllPaths)
// 4. Depth First Search i.e. PreorderTraversal (dfs)
// 5. Breadth First Search (bfs)

class Tree {
    
    class Node {
        let value: Int
        var leftChild: Node?
        var rightChild: Node?
        
        init(value: Int) {
            self.value = value
        }

        var hasChildren: Bool {
            return self.leftChild != nil || self.rightChild != nil
        }
    }
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    func addNode(newNode: Node) {
        addNode(root, newNode: newNode)
    }
    
    private func addNode(currentNode: Node, newNode: Node) {
        if newNode.value > currentNode.value {
            if let rightChild = currentNode.rightChild {
                addNode(rightChild, newNode: newNode)
            } else {
                currentNode.rightChild = newNode
            }
        } else {
            if let leftChild = currentNode.leftChild {
                addNode(leftChild, newNode: newNode)
            } else {
                currentNode.leftChild = newNode
            }
        }
    }
    
    // Print Tree
    //
    func printTree() -> String {
        return printTree(root)
    }
    
    func printTree(currentNode: Node?) -> String {
        guard let current = currentNode else { return "" }
        
        var pieces: [String] = []
        
        if let leftChild = current.leftChild {
            var leftpiece = "("
            leftpiece.appendContentsOf(printTree(leftChild))
            leftpiece.appendContentsOf(")<-")
            pieces.append(leftpiece)
        }
        
        pieces.append("\(current.value)")
        
        if let rightChild = current.rightChild {
            var rightpiece = "->("
            rightpiece.appendContentsOf(printTree(rightChild))
            rightpiece.appendContentsOf(")")
            pieces.append(rightpiece)
        }
        
        return pieces.joinWithSeparator("")
    }
    
    // Print All Paths
    //
    func printAllPaths() {
        return printAllPaths(root, path: [])
    }
    
    private func printAllPaths(currentNode: Node?, path: [Int]) {
        guard let current = currentNode else { print(path); return }
        
        var localPath = path
        localPath.append(current.value)
        
        if !current.hasChildren {
            print(localPath)
        }
        
        if let left = current.leftChild {
            printAllPaths(left, path: localPath)
        }
        
        if let right = current.rightChild {
            printAllPaths(right, path: localPath)
        }
    }
    
    // Depth First Search (aka preOrderTraversal)
    //
    func dfs() {
        return dfs(root)
    }
    
    private func dfs(currentNode: Node?) {
        guard let current = currentNode else { return }
        
        print(current.value)
        dfs(current.leftChild)
        dfs(current.rightChild)
    }
    
    // Breadth First Search
    //
    func bfs() -> [Int] {
        return bfs(root)
    }
    
    private func bfs(currentNode: Node?) -> [Int] {
        guard let current = currentNode else { return [] }
        
        var returnArray: [Int] = []
        let queue = Queue<Tree.Node>()
        
        queue.enqueue(current)
        
        while !queue.isEmpty {
            let currentNode = queue.dequeue()!
            if let leftChild = currentNode.leftChild {
                queue.enqueue(leftChild)
            }
            
            if let rightChild = currentNode.rightChild {
                queue.enqueue(rightChild)
            }
            
            returnArray.append(currentNode.value)
        }
        
        return returnArray
    }
}



let tree = Tree(root: Tree.Node(value: 10))
tree.addNode(Tree.Node(value: 12))
tree.addNode(Tree.Node(value: 14))
tree.addNode(Tree.Node(value: 11))
tree.addNode(Tree.Node(value: 6))
tree.addNode(Tree.Node(value: 8))
tree.printTree()
tree.printAllPaths()
tree.dfs()
tree.bfs()

/////////////////////////////////////////////////////////
///////////////////  Graphs  ////////////////////////////
/////////////////////////////////////////////////////////

// 1. Add Vertex
// 2. Add Edge
// 3. Reset Edges
// 4. DFS
// 5. BFS

class Graph {
    let root: Vertex
    var vertices: [Vertex] = []
    let isDirected: Bool
    
    init(vertex: Vertex, isDirected: Bool) {
        self.root = vertex
        self.vertices = [root]
        self.isDirected = isDirected
    }
    
    func addVertex(name: String) -> Vertex {
        let newVertex = Vertex(name: name)
        vertices.append(newVertex)
        return newVertex
    }
    
    func addVertices(names: [String]) -> [Vertex] {
        let newVertices = names.map { Vertex(name:$0) }
        vertices.appendContentsOf(newVertices)
        return newVertices
    }
    
    func addEdge(source: Vertex, neighbor: Vertex, weight: Int) {
        let newEdge = Edge(weight: weight, neighbor: neighbor)
        source.edges.append(newEdge)
        
        if !self.isDirected {
            let reverseEdge = Edge(weight: weight, neighbor: source)
            neighbor.edges.append(reverseEdge)
        }
    }
    
    func resetVisited() {
        for vertex in self.vertices {
            vertex.visited = false
        }
    }
    
    class Vertex {
        let name: String
        var edges: [Edge] = []      // Adjacency List
        var visited: Bool = false
        
        init(name:String, withEdges edges: [Edge]) {
            self.name = name
            self.edges = edges
        }
        
        init(name: String) {
            self.name = name
        }
    }
    
    class Edge {
        var weight: Int = 0
        let neighbor: Vertex
        
        init(weight: Int, neighbor: Vertex) {
            self.weight = weight
            self.neighbor = neighbor
        }
    }
}

extension Graph {
    
    func dfs() -> [String] {
        let root = self.root

        var returnArray: [String] = []
        let stack = Stack<Vertex>()
        stack.push(root)
        
        while !stack.isEmpty {
            let currentVertex = stack.pop()!
            currentVertex.visited = true
            
            // Add unvisited neighbors to stack
            for edge in currentVertex.edges {
                if edge.neighbor.visited == false {
                    stack.push(edge.neighbor)
                }
            }
            
            returnArray.append(currentVertex.name)
        }
        
        return returnArray
    }
    
    func bfs() -> [String] {
        var returnArray: [String] = []
        let root = self.root
        let q = Queue<Vertex>()
        
        q.enqueue(root)
        while !q.isEmpty {
            let current = q.dequeue()!
            current.visited = true
            
            for edge in current.edges {
                if edge.neighbor.visited == false {
                    edge.neighbor.visited = true
                    q.enqueue(edge.neighbor)
                }
            }
            
            returnArray.append(current.name)
        }
        
        return returnArray
    }
}

let rootVertex = Graph.Vertex(name: "A")
let graph = Graph(vertex: rootVertex, isDirected: true)

let vertexB = graph.addVertex("B")
let vertexC = graph.addVertex("C")
let vertexD = graph.addVertex("D")
let vertexE = graph.addVertex("E")
let vertexF = graph.addVertex("F")
let vertexG = graph.addVertex("G")
let vertexH = graph.addVertex("H")

graph.addEdge(rootVertex, neighbor: vertexB, weight: 5)
graph.addEdge(rootVertex, neighbor: vertexC, weight: 3)
graph.addEdge(vertexB, neighbor: vertexD, weight: 2)
graph.addEdge(vertexC, neighbor: vertexD, weight: 1)
graph.addEdge(vertexC, neighbor: vertexF, weight: 4)
graph.addEdge(vertexD, neighbor: vertexE, weight: 7)
graph.addEdge(vertexE, neighbor: vertexG, weight: 5)
graph.addEdge(vertexF, neighbor: vertexG, weight: 8)
graph.dfs()
graph.resetVisited()
print(graph.vertices)
graph.bfs()


/////////////////////////////////////////////////////////
///////////////////  Sorting  ///////////////////////////
/////////////////////////////////////////////////////////

// 1. MergeSort
// 2. InsertionSort

func mergeSort(input: [Int]) -> [Int] {
    guard input.count > 1 else { return input }
    
    let minIndex = input.startIndex
    let maxIndex = input.endIndex
    let midIndex = (minIndex + maxIndex) / 2
    
    let left = mergeSort(Array<Int>(input[minIndex..<midIndex]))
    let right = mergeSort(Array<Int>(input[midIndex..<maxIndex]))
    
    return combine(left, r: right)
}

func combine(l: [Int], r:[Int]) -> [Int] {
    
    var returnArray: [Int] = []
    
    var leftIncrementor = 0
    var rightIncrementor = 0
    
    while leftIncrementor < l.count && rightIncrementor < r.count {
        if l[leftIncrementor] < r[rightIncrementor] {
            returnArray.append(l[leftIncrementor])
            leftIncrementor += 1
        } else if (l[leftIncrementor] > r[rightIncrementor]) {
            returnArray.append(r[rightIncrementor])
            rightIncrementor += 1
        } else {
            returnArray.append(l[leftIncrementor])
            leftIncrementor += 1
            returnArray.append(r[rightIncrementor])
            rightIncrementor += 1
        }
    }
    
    while leftIncrementor < l.count {
        returnArray.append(l[leftIncrementor])
        leftIncrementor += 1
    }
    
    while rightIncrementor < r.count {
        returnArray.append(r[rightIncrementor])
        rightIncrementor += 1
    }
    
    return returnArray
}

let sorted = mergeSort([6,3,1,5,4,2])
sorted





