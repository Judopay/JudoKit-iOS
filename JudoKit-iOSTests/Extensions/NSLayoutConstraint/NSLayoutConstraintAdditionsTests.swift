//
//  NSLayoutConstraintAdditionsTests.swift
//  JudoKit-iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest
@testable import JudoKit_iOS

class NSLayoutConstraintAdditionsTests: XCTestCase {
    
    /*
    * GIVEN: NSLayoutConstraint Additions for priotiry
    *
    * WHEN: constraint is changing priority
    *
    * THEN: it should be activated and with right priority value
    */
    
    func test_ActivateConstraints_WhenActivateWithPriotiry_ShouldChangePriority() {
        let view1 = UIView()
        let view2 = UIView()
        
        let xCenterConstraint = NSLayoutConstraint(item: view1, attribute: .centerX, relatedBy: .equal, toItem: view2, attribute: .centerX, multiplier: 1, constant: 0)
        view1.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1, constant: 0)
        view1.addConstraint(yCenterConstraint)
        
        NSLayoutConstraint.activate([xCenterConstraint, yCenterConstraint], withPriority: UILayoutPriority(2))
        XCTAssertEqual(xCenterConstraint.priority.rawValue, 2.0)
        XCTAssertEqual(yCenterConstraint.priority.rawValue, 2.0)
    }
}
