/*: Create a bulleted list of animals
## Swift Practice Playground
##### Sections
* Generics
* Generic Protocols
* Associated Values in an Enumeration
* Generic Structs
* Map & Flatmap
* Protocols
* Closures
* Error Handling
*/

////////////////////////////////////////////////////////////////////////////////
////////// **** MARK: Generics Practice ***** //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

import UIKit

struct User {
    var name: String
    var experience: Int
}

struct SpaceShip {
    var captain: User
    var topSpeed: Double
}

let newUser = User(name: "Mark", experience: 2)

struct GenericUser<T> {
    var name: T
    var experience: T
}


let genericUser = GenericUser(name: "Cat", experience: "Dog")
let genericUser2 = GenericUser(name: 2,experience: 4)

struct VeryGenericUser<T, U> {
    var name: T
    var experience: U
}

let veryGenericUser = VeryGenericUser(name: "Cat", experience: "Dog") // Look Here
let veryGenericUser2 = VeryGenericUser(name: 2,experience: 2)
let veryGenericUser3 = VeryGenericUser(name: "Cat", experience: 2)
let veryGenericUser4 = VeryGenericUser(name: VeryGenericUser(name: "bob", experience: 2), experience: 3)
//WOAH Generic inception^^^

var animal: String
var dog: String
var cat = "Cat"

// Generic Functions
//
func genericSort<T: Comparable>(v1: T, v2: T) -> Bool {
    return v1 < v2
}

genericSort(2, v2: 1)
genericSort("David", v2: "Bob")

////////////////////////////////////////////////////////////////////////////////
////////// **** MARK: Generic Protocols ***** //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// http://www.russbishop.net/swift-associated-types

protocol GenericProtocol {
    associatedtype T // Use associated type instead of <T> syntax
    
    init(title: T)
}

struct exampleStruct: GenericProtocol {
    var title: String
    
    init(title: String) {      // Key Idea: The type is selected when you adopt the protocol, NOT when you instantiate it
        self.title = title     // Search for 'Look Here" for counter example
    }
}

struct exampleStruct2: GenericProtocol {
    var title: Double
    
    init(title: Double) {
        self.title = title
    }
}

protocol MoreSpecificGenericProtocol: GenericProtocol { // Protocol inheriting another protocol
    init (title: String)
}

// More concrete example
class Grass { }
class Salt { }

protocol Animal {
    associatedtype Food
    associatedtype Supplement
    
    func eat(f: Food)
    func supplement(s: Supplement)
}

struct Cow: Animal {
    func eat(f: Grass) { print("Implementation Here") }
    func supplement(s: Salt) { print("Implementation Here") }
}


/////////////////////////////////////////////////////////////////////////////////////////////
////////// **** MARK: Associated Values in an Enumeration ***** //////////
////////////////////////////////////////////////////////////////////////////////////////////

enum SplashTypeface {
    case GothamMedium
    case GothamBook
    
    var name: String {
        switch self {
        case GothamMedium: return "GothamMedium"
        case GothamBook: return "GothamBook"
        }
    }
}

extension UIButton {
    
    enum ButtonStyle {
        case BottomConfirmationButton(background: UIColor, textColor: UIColor)
        case MinorButton(textColor: UIColor)
        case RoundedRect(background: UIColor, textColor: UIColor)
        case TranslucentRoundedRect
        
        var backgroundColor: UIColor{
            switch self {
            case let .BottomConfirmationButton(color, _): return color
            case let .RoundedRect(color, _): return color
            case .MinorButton, .TranslucentRoundedRect(_): return .clearColor()
            }
        }
        
        var textColor: UIColor {
            switch self {
            case let .BottomConfirmationButton(_, color): return color
            case let .MinorButton(color): return color
            case let .RoundedRect(_, color): return color
            case .TranslucentRoundedRect: return .whiteColor()
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .BottomConfirmationButton(_,_), .MinorButton: return 0
            case .RoundedRect, .TranslucentRoundedRect: return 10 // TO DO: Change based on button height?
            }
        }
        
        var typeface: SplashTypeface {
            return .GothamMedium
        }
    }
    
    class func createButtonWithStyle(style: ButtonStyle, title: String? = nil) -> UIButton {
        let button = UIButton()
        button.backgroundColor = style.backgroundColor
        button.contentHorizontalAlignment = .Center;
        button.layer.cornerRadius = style.cornerRadius
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(style.textColor, forState: .Normal)
        button.titleLabel?.font = UIFont(name: style.typeface.name, size: 12) // TO DO: Scale font size for iPad
        
        return button
    }
}


let button = UIButton.createButtonWithStyle(.RoundedRect(background: UIColor.purpleColor(), textColor: UIColor.whiteColor()))
let minorButton = UIButton.createButtonWithStyle(.MinorButton(textColor: .blueColor()))
print(minorButton.titleLabel!.textColor)

/////////////////////////////////////////////////////////////////////////////////////////////
////////// **** MARK: Generic struct ***** ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

struct GenericRandomGenerator<T> {
    let items: [T]
    
    init(items: [T]) {
        self.items = items
    }
    
    func getRandom() -> T {
        let randomIndex = Int(arc4random_uniform(UInt32(items.count)))
        return items[randomIndex]
    }
}

var randomString = GenericRandomGenerator(items: ["Hello", "Goodbye", "Farewell", "See you later"]).getRandom()
var randomInt = GenericRandomGenerator(items: [1,2,3,4,5]).getRandom()
var randomBool = GenericRandomGenerator(items: [true, false]).getRandom()


//////////////////////////////////////////////////////////////////////////////////
////////////////// **** MARK: Map & FlatMap ***** ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

enum Optional<T> {
    case Some(T)
    case None
    
    init (_ value: T) {
        self = .Some(value)
    }
    
    init () {
        self = .None
    }
}

enum Result<T> {
    case Success(T)
    case Failure
    
    init(value: T) {
        self = .Success(value)
    }
    
    init () {
        self = .Failure
    }
}

var arr: [String] = ["3","2","1","hi"]
var arr2 = arr
    .map({ Int($0) })
    .filter({ $0 != nil })
    .map({ $0! * 2 })
arr2

//let optionalString = Optional.Some("123")

func isEven(value: Int) -> Bool {
    return value % 2 == 0
}

let optionalString: String?
optionalString = .None

let optionalInt = optionalString.map({ Int($0)! })
optionalInt

let optionalArray: [Int?] = [2,4,5,.None,1,.None,9]

let evenNumbers = optionalArray.flatMap({ $0 })
evenNumbers

let evens = evenNumbers.map({ $0 % 2 == 0 })
let evens2 = evenNumbers.flatMap({ $0 % 2 == 0 })
evens
evens2


//let evenNumbers = optionalArray.map({ })


//var optionalArray: [Int?] = [.Some(4), .None, .Some(3)]
//var sdas: [Int] = optionalArray.flatMap(({ (opt: Int) -> Int in return opt + 3 }))


// Map for Optionals
//func map<U>(f: (Wrapped) throws -> U) rethrows -> U?
// Map for SequenceTypes
//func map<T>(@noescape transform: (Self.Generator.Element) throws -> T) rethrows -> [T]

//////////////////////////////////////////////////////////////////////////////////
////////////////// **** MARK: Protocols ***** ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

protocol ProtocolA {
    var instanceProperty1: Int { get }
    var instanceProperty2: String { get }
    var instanceProperty3: [Int] { get }
    
    static var typeProperty1: String { get } // Type properties are shared across all instances of a class
}

struct ExampleObject: ProtocolA {
    var instanceProperty1: Int
    var instanceProperty2: String
    var instanceProperty3: [Int]
    
    static var typeProperty1: String = "Hello"
    
    // Don't need an initializer for structs !!
}

let exampleObject = ExampleObject(instanceProperty1: 3, instanceProperty2: "Mark", instanceProperty3: [1,2,3])
exampleObject.instanceProperty1
exampleObject.instanceProperty2
exampleObject.instanceProperty3
ExampleObject.typeProperty1

// Example 2

enum Gender {
    case Male
    case Female
}

protocol Human {
    var firstName: String { get }
    var lastName: String { get }
    var gender: Gender { get }
    
    static var limbs: Int { get }
}

struct Male: Human {
    var firstName: String
    var lastName: String
    var gender: Gender
    
    static var limbs: Int = 4
}


let MarkObject = Male(firstName: "Mark", lastName: "Koslow", gender: .Male)
MarkObject.firstName
MarkObject.lastName
MarkObject.gender
Male.limbs


//////////////////////////////////////////////////////////////////////////////////
////////////////// **** MARK: Closures ***** /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//Example 1
//
let names = ["Mark","Dan","Rach","Mike","Denise"]

let alphabetical = names.sort({ (s1: String, s2: String) -> Bool in return s1 < s2 })
alphabetical
let reversed = names.sort({ (s1: String, s2: String) -> Bool in return s1 > s2})
reversed

// The parameter types and the return type can be inferred from sorted's method signature
// Can also omit "return" because the closure's body contains a single boolean expression (no ambiguity)
let alphabetical2 = names.sort({ s1, s2 in s1 < s2 })
alphabetical2
let reversed2 = names.sort({ s1, s2 in s1 > s2 })
reversed2

// The names of the arguments can also be omitted in favor of unnamed arguments
let alphabetical3 = names.sort({ $0 < $1 })
alphabetical3
let reversed3 = names.sort({ $0 > $1 })
reversed3

// WAT: Can be further shortened because compiler can infer you want the string implementation of '>'
let alphabetical4 = names.sort(>)
alphabetical4
let reversed4  = names.sort(<)
reversed4

// Example 2
//
let digitNames = [0:"Zero", 1:"One", 2: "Two", 3: "Three", 4: "Four", 5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"]
let randomNumbers = [423,689,157]

let randomNumbersAsStrings = randomNumbers.map { (var number: Int) -> String in
    var retString = ""
    
    while number >= 1 {
        var remainder = number % 10
        number = number / 10
        retString = digitNames[remainder]! + retString
    }
    return retString
}
randomNumbersAsStrings

// Example 3
//
func makeIncrementor(increment amount: Int) -> () -> Int {
    var runnningTotal = 0
    // Captures surrounding context
    // Can do this because functions and closures are reference types
    func incrementer() -> Int {
        runnningTotal += amount
        return runnningTotal
    }
    return incrementer
}

let incrementBy10 = makeIncrementor(increment: 10)
incrementBy10()

5 + incrementBy10()
incrementBy10() // Adds 10 to 'value'
5 + incrementBy10()

let incrementBy7 = makeIncrementor(increment: 7)
for index in 1...10 {
    incrementBy7()
}
incrementBy7()
incrementBy10()

// Closures as reference types
let alsoIncrementBy10 = incrementBy10
alsoIncrementBy10() // This also increments the value of incrementBy10
incrementBy10()

// Example 4
//
func squared() -> () -> Int {
    var value = 2
    
    func square() -> Int {
        value = value * value
        return value
    }
    return square
}

let powerLaw = squared()
powerLaw
powerLaw()
powerLaw()

// Example 5
//
func slope(x: Double) -> Double {
    return 2*x + 1
}

let f = slope   // Can imagine this now as f(x) = 2x + 1
f(0.5)          // f(x) = 2(0.5) + 1

// Example 6
//

func isEvenNumber(value: Int) -> Bool {
    return value % 2 == 0
}

let isEven = isEvenNumber

let numbers = [0,1,2,3,4,5,6,7,8,9]
numbers.filter(isEven)



//////////////////////////////////////////////////////////////////////////////////
////////////////// **** MARK: Error Handling ***** ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

struct Friend {
    var firstName: String
    var lastName: String
    var age: String?
}

enum FriendError: ErrorType {
    case InvalidFirstName(String)
    case InvalidLastName(String)
}

func parseFriend(dict: [String : String]) throws -> Friend {
    guard let first = dict["firstName"] else {
        throw FriendError.InvalidFirstName("No first name")
    }
    
    guard let last = dict["lastName"] else {
        throw FriendError.InvalidLastName("No last name")
    }
    
    let age = dict["age"]
    
    return Friend(firstName: first, lastName: last, age: age)
}

// Example 1

let friendJSON = ["firstName" : "Mark", "lastName" : "Koslow", "age" : "22"]

do {
    let friend1 = try parseFriend(friendJSON)
    print(friend1)
} catch FriendError.InvalidFirstName(let x) {
    print(x)
} catch FriendError.InvalidLastName(let y) {
    print(y)
}

// Example 2

let invalidFriendJSON = ["firstName" : "Mark", "age" : "22"]

do {
    let invalidFriend = try? parseFriend(invalidFriendJSON) // the "try?" keyword turns the value into an optional and returns nil if there is an error
} // cannot call a catch because no errors can be thrown, try? returns nil instead

// Note: Use the "try!" keyword when you know that no error will be thrown, like when you are loading an asset that was shipped with the application

// Example 3

enum VendingMachineError: ErrorType {
    case InsufficientFunds(String)
    case InvalidSelection
    case OutOfStock(String)
}

struct Item {
    var price: Int
    var quantity: Int
}

class VendingMachine {
    
    var inventory = [String: Item]()
    var coins: Int
    
    init() {
        inventory = ["Cookies": Item(price: 2, quantity: 3), "Chips": Item(price: 3, quantity: 4), "Fruit Snacks": Item(price: 4, quantity: 1)]
        coins = 0
    }
    
    func vend(selection: String) throws {
        guard inventory.keys.contains(selection) else {
            throw VendingMachineError.InvalidSelection
        }
        
        guard inventory[selection]?.quantity > 0 else {
            throw VendingMachineError.OutOfStock("We are out of \(selection)")
        }
        
        guard inventory[selection]?.price >= coins else {
            throw VendingMachineError.InsufficientFunds("Please insert \(inventory[selection]?.price >= coins)")
        }
        
        if let price = inventory[selection]?.price, quant = inventory[selection]?.quantity {
            coins -= price
            
            let item = Item(price: price, quantity: quant - 1)
            inventory[selection] = item
        }
    }
}

let vendo = VendingMachine()
vendo.inventory

try vendo.vend("Chips")
try vendo.vend("Cookies")
try vendo.vend("Fruit Snacks")

vendo.inventory

// Invalid Selection
do {
    try vendo.vend("High")
} catch {
    print(error)
}

// Out of Stock
do {
    try vendo.vend("Fruit Snacks")
} catch {
    print(error)
}
 
do {
    try vendo.vend("Cookies")
} catch {
    print(error)
}

let lol = "hello"
lol.capitalizedString

let array = ["A","B","C","D","E","F","G","H","I"]

func splitIntoTwos(array: [String]) -> [[String]] {
    let length = array.count
    var arrayOfArrays: [[String]] = []
    
    for (var i = 0; i < length - 1; i+=2) {
        let subArray = [array[i], array[i+1]]
        arrayOfArrays.append(subArray)
    }
    if (length % 2 == 1) { arrayOfArrays.append([array[length-1]]) }
    return arrayOfArrays
}

func splitIntoTwos2(array: [String]) -> [Array<String>.SubSequence] {
    var arrayOfArrays: [Array<String>.SubSequence] = []
    var i = array.startIndex
    while i != array.endIndex {
        let j = i.advancedBy(2, limit: array.endIndex)
        arrayOfArrays.append(array[i..<j])
        i = j
    }
    
    return arrayOfArrays
}

splitIntoTwos2(array)

extension Array {
    func accumulate2<U>(initial: U, operation: (U, Element) -> U) -> [U] {
        var runningTotal = initial
        return self.map { value in
            runningTotal = operation(runningTotal, value)
            return runningTotal
        }
    }
}

[1,2,3,4,5,6,7,8,9,10].accumulate2(0, operation: +)

class Apartment {
    var numberOfRooms: Int
    var tenant: Hooman?
    
    init(numberOfRooms: Int, tenant: Hooman? = nil) {
        self.numberOfRooms = numberOfRooms
        self.tenant = tenant
    }
    
    deinit {
        print("Apartment deinitialized")
    }
}

class Hooman {
    var name: String = "Mark"
    var address: String = "448 W 19th St"
    var city: String = "New York"
    weak var apartment: Apartment?
    
    init(apartment: Apartment? = nil) {
        self.apartment = apartment
    }
    
    deinit {
        print("HOoman deinitialized")
    }
}

//extension Hooman: CustomDebugStringConvertible {
//    var debugDescription: String {
//        return String(format: "Hooman object has a name of \(name) and lives at \(address) in \(city).")
//    }
//}
//human.debugDescription

var apartment: Apartment? = Apartment(numberOfRooms: 4)
var human: Hooman? = Hooman()

// Both objects are deinitialized
apartment = nil
human = nil

var anotherApartment: Apartment? = Apartment(numberOfRooms: 10)
var anotherHuman: Hooman? = Hooman()

anotherApartment?.tenant = anotherHuman
anotherHuman?.apartment = anotherApartment

anotherApartment = nil // ARC reduces the reference count to 0, can be safely deinitialized
anotherHuman = nil
// Neither object can be deinitialized because they hold strong references to one another
// Must make one of their references weak


let abc = "abc"
String(abc.characters.first)

let firstName: String? = "  Mark "
let lastName: String? = "   Koslow  "

let first = firstName.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
first

let lastConcatted = lastName.flatMap { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
lastConcatted

if let lastName2 = lastName?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) where lastName2.characters.count > 0 {
}

// Workout Protocol 

protocol Workout {
    associatedtype Minutes
    var duration: Minutes { get }
    var color: UIColor { get }
}

// Cardio Workout

struct CardioWorkout: Workout {
    typealias Miles = Int
    
    let duration: Int
    let distance: Miles
    let color: UIColor = .redColor()
}

// Lift Workout

struct LiftWorkout: Workout {
    let duration: Int
    let muscleGroups: [MuscleGroup]
    let color: UIColor = .orangeColor()
}

enum MuscleGroup {
    case Shoulders, Biceps, Triceps, Chest, Back, Abs, Legs, Calves
}

// Class Workout

struct ClassWorkout: Workout {
    let duration: Int
    let title: ClassWorkoutOptions
    let color: UIColor = .blueColor()
}

enum ClassWorkoutOptions {
    case Spinning, Yoga, Pilates, Crossfit
}

// Sports

struct SportsWorkout: Workout {
    let duration: Int
    let title: Sport
    let color: UIColor = .greenColor()
}

enum Sport {
    case Basketball, Soccer, Football, Golf
}



enum Ticket {
    case TicketType
    case OtherType
}

let selectedFilters: [Ticket] = [.OtherType, .TicketType, .OtherType]
let selectedFilters2: [Ticket] = [.OtherType, .OtherType, .OtherType]

let ans = selectedFilters.filter { if case .TicketType = $0 { return true }; return false }.isEmpty
let ans2 = selectedFilters2.filter { if case .TicketType = $0 { return true }; return false }.isEmpty

ans
ans2

let ans3 = selectedFilters.filter { $0 == .TicketType }.isEmpty
let ans4 = selectedFilters2.filter { $0 == .TicketType }.isEmpty
ans3
ans4





