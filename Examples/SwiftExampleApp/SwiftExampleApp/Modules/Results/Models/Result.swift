//
//  Results.swift
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

struct Result {

    // MARK: - Variables

    let title: String
    let items: [ResultItem]

    // MARK: - Initialization

    init(with title: String, and items: [ResultItem]) {
        self.title = title
        self.items = items
    }

    init(from object: NSObject) {
        title = String(describing: type(of: object))
        let parameters = object.parameters()

        items = parameters.map {

            if let stringValue = $0.value as? String {
                return ResultItem(with: $0.key, value: stringValue)
            }

            if let dictionaryValue = $0.value as? NSDictionary {
                let subResult = Result(with: $0.key, from: dictionaryValue)
                return ResultItem(with: $0.key, value: "", and: subResult)
            }

            if let arrayValue = $0.value as? NSArray {
                let subResult = Result(with: $0.key, from: arrayValue)
                return ResultItem(with: $0.key, value: "", and: subResult)
            }

            return ResultItem(with: $0.key, value: "No value")
        }
    }

    // MARK: - Helpers

    private init(with title: String, from dictionary: NSDictionary) {
        self.title = title

        items = dictionary.map {
            if let value = $0.value as? String {
                return ResultItem(with: $0.key as? String ?? "",
                                  value: value)
            }

            if let arrayValue = $0.value as? NSArray {
                let subResult = Result(with: $0.key as? String ?? "",
                                       from: arrayValue)

                return ResultItem(with: $0.key as? String ?? "",
                                  value: "",
                                  and: subResult)
            }

            if let dictionaryValue = $0.value as? NSDictionary {
                let subResult = Result(with: $0.key as? String ?? "",
                                       from: dictionaryValue)

                return ResultItem(with: $0.key as? String ?? "",
                                  value: "",
                                  and: subResult)
            }

            return ResultItem(with: $0.key as? String ?? "",
                              value: "No value")
        }
    }

    private init(with title: String, from array: NSArray) {
        self.title = title
        items = array.map {
            return ResultItem(with: $0 as? String ?? "", value: "")
        }
    }
}
