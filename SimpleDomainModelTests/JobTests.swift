//
//  JobTests.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import XCTest

import SimpleDomainModel

class JobTests: XCTestCase {
    let guestLecturer = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
    let janitor = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
  
    func testCreateSalaryJob() {
        XCTAssert(guestLecturer.calculateIncome(50) == 1000)
    }

    // New unit test for domain-modeling v2
    func testDescription() {
        XCTAssert(guestLecturer.description == "Guest Lecturer, Salary(1000)")
        XCTAssert(janitor.description == "Janitor, Hourly(15.0)")
    }
    
    func testCreateHourlyJob() {
        XCTAssert(janitor.calculateIncome(10) == 150)
    }
  
    func testSalariedRaise() {
        XCTAssert(guestLecturer.calculateIncome(50) == 1000)
    
        guestLecturer.raise(1000)
        XCTAssert(guestLecturer.calculateIncome(50) == 2000)
        // New unit test for domain-modeling v2
        XCTAssert(guestLecturer.description == "Guest Lecturer, Salary(2000)")
    }
  
    func testHourlyRaise() {
        XCTAssert(janitor.calculateIncome(10) == 150)
    
        janitor.raise(1.0)
        XCTAssert(janitor.calculateIncome(10) == 160)
        // New unit test for domain-modeling v2
        XCTAssert(janitor.description == "Janitor, Hourly(16.0)")
    }
}
