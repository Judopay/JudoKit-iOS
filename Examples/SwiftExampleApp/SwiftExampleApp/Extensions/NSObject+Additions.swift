//
//  NSObject+Additions.swift
//  SwiftExampleApp
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

import Foundation

extension NSObject {

    private var filteredProperties: [String] {
        return [
            "expiryDateFormatter",
            "hash",
            "superclass",
            "description",
            "debugDescription",
            "formattingContext",
            "dateFormat",
            "dateStyle",
            "timeStyle",
            "locale",
            "generatesCalendarDates",
            "formatterBehavior",
            "timeZone",
            "ISO8601TimeZoneOffsetFromUTC"
        ]
    }

    func parameters() -> [String: Any] {
        var results: [String: Any] = [:]

        var count: UInt32 = 0
        let myClass: AnyClass = self.classForCoder
        let properties = class_copyPropertyList(myClass, &count)

        for index in 0 ..< count {
            if let property = properties?[Int(index)] {

                let cname = property_getName(property)
                let name = String(cString: cname)

                if let value = self.value(forKey: name) {

                    if filteredProperties.contains(name) {
                        continue
                    }

                    if let nsString = value as? NSString {
                        results[name] = nsString
                        continue
                    }

                    if let nsArray = value as? NSArray {
                        results[name] = nsArray
                        continue
                    }

                    if let nsDictionary = value as? NSDictionary {
                        results[name] = nsDictionary
                        continue
                    }

                    if let nsNumber = value as? NSNumber {
                        results[name] = nsNumber.stringValue
                        continue
                    }

                    if let nsObject = value as? NSObject {
                        results[name] = nsObject.parameters()
                    }
                }
            }
        }
        free(properties)
        return results
    }
}
