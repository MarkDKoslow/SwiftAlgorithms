//: Playground - noun: a place where people can play

import UIKit

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
////////////// Chapter 1: Collections /////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////
////////////// Map, Filter, Reduce, FlatMap, etc.. ////////
///////////////////////////////////////////////////////////

// Map
extension Array {
    func map2<T>(transform: Element -> T) -> [T] {
        var retArray: [T] = []
        for item in self {
            retArray.append(transform(item))
        }
        return retArray
    }
}

let intArray = [1,2,3].map2({ $0 + 3 })
intArray

let stringArray = ["Hello","my","name"].map2({ $0.characters.count })
stringArray

let isEven = [2,3,4,5,6,7,8].map2({ $0 % 2 == 0 })
isEven

// Filter 
extension Array {
    func filter2(transform: Element -> Bool) -> [Element] {
        var retArray: [Element] = []
        for item in self {
            if transform(item) == true { retArray.append(item) }
        }
        return retArray
    }
}

let isEven2 = [2,3,4,5,6,7,8].filter2({ $0 % 2 == 0 })
isEven2

// Reduce
extension Array {
    func reduce2<T>(initialValue: T, transform: (T, Element) -> T) -> T {
        var counter = initialValue
        for item in self {
            counter = transform(counter, item)
        }
        return counter
    }
}

let sum = [1,2,3,4].reduce2(0, transform: +)
sum

// Accumulate
extension Array {
    func accumulate<T>(initialValue: T, combine: (T, Element) -> T) -> [T] {
        var runningTotal = initialValue
        return self.map {
            runningTotal = combine(runningTotal, $0)
            return runningTotal
        }
    }
}

[1,2,3,4,5].accumulate(0, combine: +)

extension Array {
    // Naive implementation because you're not accounting for optionals
    func flatMap2<T>(transform: Element -> [T]) -> [T] {
        var retArray: [T] = []
        for element in self {
            retArray.appendContentsOf(transform(element))
        }
        return retArray
    }
}

extension Optional {
    func flatMap2<T>(transform: Wrapped -> T?) -> T? {
        switch self {
        case let .Some(wrapped): return transform(wrapped)
        case Optional<Wrapped>.None: return Optional<T>.None
        }
    }
}

let x = [[1,2,3],[4,5,6],[7,8,9]].flatMap2({ $0 })
x

let z = Optional.Some(1)

let y = [
    [Optional.Some(2), Optional.Some(3), Optional.None],
    [Optional.Some(4), Optional.Some(5), Optional.None],
    [Optional.Some(6), Optional.Some(7), Optional.None]
]

let flatZ = y.flatMap2 {
    $0.filter { $0 != nil }
    .map { $0! + 2 }
} // WOAH!

// All possible combinations of two arrays
let ranks = ["Jack", "Queen", "King", "Joker"]
let suits = ["Hearts", "Clubs", "Spades", "Diamonds"]
let allCombinations = ranks.flatMap2 { rank in
    suits.map { suit in
        rank + " of " + suit
    }
}
allCombinations


///////////////////////////////////////////////////////////
////////////////// Generator Type /////////////////////////
///////////////////////////////////////////////////////////

// Main Idea: In order to be called a generator, you must implement next()
// That's it!

protocol CustomGeneratorType {
    associatedtype Element
    
    mutating func next() -> Element?
}

// Example 1
class ConstantGenerator: CustomGeneratorType {
    func next() -> Int? {   // Implicitly declare Element's type
        return 1
    }
}

// Example 2
class FibsGenerator: CustomGeneratorType {
    typealias Element = Int
    
    var state = (0, 1)
    func next() -> Int? {
        let upcoming = state.0
        state = (state.1, state.0 + state.1)
        return upcoming
    }
}

let fibs = FibsGenerator()
for i in 1 ... 10 {
    fibs.next()
}
// Can only loop over once, reference semantics NOT value semantics
let fibsCopy = fibs
fibsCopy.next()
fibs.next()

// Example 3
class Node: CustomGeneratorType {
    var value: Int?
    var nextNode: Node?
    
    init(value: Int?) {
        self.value = value
    }
    
    func setNext(nextNode: Node) {
        self.nextNode = nextNode
    }
    
    func next() -> Node? {
        guard let next = self.nextNode else { return nil }
        return next
    }
}

let node1 = Node(value: Optional(1))
let node2 = Node(value: Optional(2))
let node3 = Node(value: Optional(3))
node1.setNext(node2)
node2.setNext(node3)

node1.next()?.next()?.value
node1.next()?.next()?.next()?.value

//////////////////////////////////////////////////////////
////////////////// Sequence Type /////////////////////////
//////////////////////////////////////////////////////////

// Main Idea: In order to be called a sequence, you must be able to create generators so you can iterate over your contents *more than once* (once for each generator)
// That's it!

protocol CustomSequenceType {
    associatedtype Generator: CustomGeneratorType
    func generate() -> Generator
}

class MyLinkedList: CustomSequenceType {
    let head: Node
    
    init(head: Node) {
        self.head = head
    }
    
    func generate() -> Node {
        return self.head
    }
}

let ll = MyLinkedList(head: node1)
var currentNode = ll.generate()

repeat {
    print(currentNode.value)
    currentNode = currentNode.next()!
} while currentNode.next() != nil

print(currentNode.value!)

// Example from the book
class PrefixGenerator: CustomGeneratorType {
    let string: String
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    
    func next() -> String? {
        guard offset < string.endIndex else { return nil }
        offset = offset.successor()
        return string[string.startIndex..<offset]
    }
}

struct PrefixSequence: CustomSequenceType {
    let string: String
    
    func generate() -> PrefixGenerator {
        return PrefixGenerator(string: string)
    }
}

let pref = PrefixGenerator(string: "Hello World")
pref.next()
pref.next()
pref.next()

// Now I want to go back to the beginning
// ...but i can't without initializing a whole new PrefixGenerator Object
// Sequence Types to the rescue!

let prefSequence = PrefixSequence(string: "Hello World")
let prefSequenceIterator = prefSequence.generate()
prefSequenceIterator.next()
prefSequenceIterator.next()
// Now i want to go back to the beginning
let anotherIterator = prefSequence.generate()
anotherIterator.next()
anotherIterator.next()
// It works! No need to reinitialize the entire object


//////////////////////////////////////////////////////////
///////// Function-Based Generators and Sequences ////////
//////////////////////////////////////////////////////////

// Can also do this using a function with a closure!
func fibsGenerator() -> AnyGenerator<Int> {
    var state = (0,1)
    return AnyGenerator { // This inner method will be called everytime next() is called on the AnyGenerator
        let result = state.0
        state = (state.1, state.0 + state.1)
        return result
    }
}

let fibsSequence = AnyGenerator(body: fibsGenerator)


// Simpler Example
var start = 7
var end = 15
let g = AnyGenerator { start < end ? start++ : nil }
let a = Array(g)

//////////////////////////////////////////////////////////
////////////////// Collections ///////////////////////////
//////////////////////////////////////////////////////////

protocol QueueProtocol {
    associatedtype Element
    
    mutating func enqueue(element: Element)
    
    mutating func dequeue() -> Element?
}

class NaiveQueue<Element: Node> {
    var head: Element?
    var tail: Element?
    
    init(element: Element) {
        self.head = element
        self.tail = element
    }
    
    func enqueue(newElement: Element) {
        if let tail = self.tail {
            tail.setNext(newElement)
        }
        tail = newElement
    }
    
    func dequeue() -> Element? {
        guard let head = self.head else { return nil }
        
        self.head = head.next() as? Element
        return head
    }
}

let myQ = NaiveQueue(element: Node(value: Optional(5)))
myQ.enqueue(Node(value: Optional(6)))
myQ.enqueue(Node(value: Optional(7)))
myQ.enqueue(Node(value: Optional(8)))
myQ.dequeue()!.value
myQ.dequeue()!.value
myQ.dequeue()!.value
myQ.dequeue()!.value

// Example from the book
struct EfficientQueue<Element> { // O(1)
    private var popStack: [Element] // Using variables within a struct?
    private var putStack: [Element]
    
    init() {
        popStack = []
        putStack = []
    }
    
    mutating func enqueue(newElement: Element) {
        putStack.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if (popStack.isEmpty) {
            popStack = putStack.reverse() // This is an O(n) operation, but because it only needs to be done once in awhile, the *amortized* time for dequeue is still O(1)
                // This is also why appending an item to an array is O(1), even though its possible the individual operation could be O(n) if more space needs to be allocated to the array
            putStack.removeAll(keepCapacity: true)
        }
        return popStack.removeLast()
    }
}

extension EfficientQueue: CollectionType {
    var startIndex: Int { return 0 }
    var endIndex: Int { return popStack.count + putStack.count }
    
    subscript(index: Int) -> Element {
        guard (popStack.isEmpty && putStack.isEmpty) == false else { fatalError("Invalid Index") }

        guard popStack.count + putStack.count <= index else { fatalError("Invalid Index") }
        
        if index < popStack.count { return popStack[index] }
        else { return putStack[index - popStack.count] }
    }
}

extension EfficientQueue: ArrayLiteralConvertible {
    init(arrayLiteral elements: Element...) {
        self.popStack = elements.reverse()
        self.putStack = []
    }
}
var arrayLiteralInit: EfficientQueue = [1,2,3]

var myQ2 = EfficientQueue<Int>()
myQ2.enqueue(1)
myQ2.enqueue(2)
myQ2.enqueue(3)
myQ2.enqueue(4)
myQ2.dequeue()
myQ2.dequeue()
myQ2.dequeue()
myQ2.dequeue()

// Efficient Queue now inherits all of the methods for CollectionType (over 40!!!)
// Just by knowing subscript, start index, and end index, we can:
//      Iterate over its contents
//      Map, Flatmap, Filter
//      isEmpty, Count, First, Last
//      Others!

// So Why don't we need to implement the generate function() like we did above?? (CollectionType extends SequenceType)
// Something like this:
// extension EfficientQueue: CollectionType {
//    func generate() -> IndexingGenerator<EfficientQueue<T>> {
//        return IndexingGenerator(self)
//    }
// }

// We don't need the above code because Swift 2.0 added a default implementation of it to the CollectionType Protocl (Woohoo for protocol extensions!!!!)




///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
////////////// Chapter 2: Optionals ///////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////


let array = [1,2,3]
var generator = array.generate()
while let i = generator.next() {
    print(i)
}

// for...in is really just a while loop
var w: [Int] = []
var p = (1...3).generate()
var o: Optional<Int> = p.next()
while o != nil {
    let i = o! as Int
    w.append(i)
    o = p.next()
}





