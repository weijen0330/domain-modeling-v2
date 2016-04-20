//
//  main.swift
//  SimpleDomainModel
//
//  Created by Wei-Jen Chiang on 4/11/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//
import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

protocol CustomStringConvertible {
    var description: String { get }
}

protocol Mathematics {
    func add(other: Money) -> Money
    func subtract(other: Money) -> Money
}

func +(left: Money, right: Money) -> Money {
    return left.add(right)
}

func -(left: Money, right: Money) -> Money {
    return left.subtract(right)
}

extension Double {
    var USD: Money { return Money(amount: Int(self), currency: "USD") }
    var EUR: Money { return Money(amount: Int(self), currency: "EUR") }
    var GBP: Money { return Money(amount: Int(self), currency: "GBP") }
    var YEN: Money { return Money(amount: Int(self), currency: "YEN") }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    public var description: String
  
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
        self.description = "\(currency)" + "\(amount)"
    }
    
    public func convert(to: String) -> Money {
        if (self.currency != to) {
            var newAmount : Int = 0;
            if (self.currency == "USD") {
                if (to == "GBP") {
                    newAmount = self.amount / 2
                } else if (to == "EUR") {
                    newAmount = Int(Double(self.amount) * 1.5)
                } else if (to == "CAN") {
                    newAmount = Int(Double(self.amount) * 1.25)
                }
            } else if (self.currency == "GBP") {
                if (to == "USD") {
                    newAmount = self.amount * 2
                } else if (to == "EUR") {
                    newAmount = self.amount * 3
                } else if (to == "CAN") {
                    newAmount = Int(Double(self.amount) * 2.5)
                }
            } else if (self.currency == "EUR") {
                if (to == "USD") {
                    newAmount = Int(Double(self.amount) * (2.0/3.0))
                } else if (to == "GBP") {
                    newAmount = Int(Double(self.amount) * (1.0/3.0))
                } else if (to == "CAN") {
                    newAmount = Int(Double(self.amount) * (2.5/3.0))
                }
            } else if (self.currency == "CAN") {
                if (to == "USD") {
                    newAmount = Int(Double(self.amount) * (4.0/5.0))
                } else if (to == "GBP") {
                    newAmount = Int(Double(self.amount) * (1.0/2.5))
                } else if (to == "EUR") {
                    newAmount = Int(Double(self.amount) * (3.0/2.5))
                }
            }
            return Money(amount: newAmount, currency: to)
        }
        return self
    }
  
    public func add(to: Money) -> Money {
        if (self.currency == to.currency) {
            return Money(amount: self.amount + to.amount, currency: self.currency)
        } else {
            return to.add(self.convert(to.currency))
        }
    }
    
    public func subtract(from: Money) -> Money {
        if (self.currency == from.currency) {
            return Money(amount: self.amount - from.amount, currency: self.currency)
        } else {
            return self.subtract(convert(from.currency))
        }
    }
}

////////////////////////////////////
// Job
//
public class Job: CustomStringConvertible {
    public var title : String
    public var type : JobType
    public var description: String
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
  
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
        self.description = title + ", \(type)"
    }
    
    public func calculateIncome(hours: Int) -> Int {
        switch self.type {
        case .Hourly(let pay):
            return Int(pay * Double(hours))
        case .Salary(let pay):
            return pay;
        }
    }
  
    public func raise(amt : Double) {
        switch self.type {
        case .Hourly(let pay):
            self.type = JobType.Hourly(pay + amt)
        case .Salary(let pay):
            self.type = JobType.Salary(pay + Int(amt))
        }
        self.description = title + ", \(type)"
    }
}

////////////////////////////////////
// Person
//
public class Person: CustomStringConvertible {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    public var description: String = ""
    private var _job : Job? = nil
    private var _spouse: Person? = nil
   
    public var job : Job? {
        get {
            return _job;
        }
        set(value) {
            if (self.age >= 16) {
                _job = value;
                self.description += ", job: \(self.job!.description)"
            } else {
                _job = nil;
            }
        }
    }
  
    public var spouse : Person? {
        get {
            return _spouse;
        }
        set(value) {
            if (self.age >= 18) {
                _spouse = value;
                self.description += ", spouse: \(self.spouse!.firstName)"
            } else {
                _spouse = nil
            }
        }
    }
  
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.description = self.firstName + " " + self.lastName + ", age: \(self.age)"
    }
  
    public func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
    }
}

////////////////////////////////////
// Family
//
public class Family: CustomStringConvertible {
    public var description: String = "No one in this family"
    private var members : [Person] = []
    
    
    public init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            self.members.append(spouse1)
            self.members.append(spouse2)
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.description = spouse1.description + "\n" + spouse2.description
        }
    }
  
    public func haveChild(child: Person) -> Bool {
        for member in members {
            if (member.age >= 21) {
                self.members.append(child)
                self.description += "\n" + child.description
                return true;
            }
        }
        return false;
    }
  
    public func householdIncome() -> Int {
        var incomeSum : Int = 0
        for member in members {
            if (member.job != nil) {
                incomeSum += member.job!.calculateIncome(2000)
            }
        }
        return incomeSum
    }
}

let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
ted.job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))

let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

let family = Family(spouse1: ted, spouse2: charlotte)

let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))

let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
family.haveChild(mike)
family.haveChild(matt)

print(family.description)





