//
//  JPCardNetworkType.h
//  JudoKit_iOS
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

#import <Foundation/Foundation.h>

/**
 *  The JPCardNetworkType enum depicts the Card Network type of a given Card object
 */
typedef NS_OPTIONS(NSUInteger, JPCardNetworkType) {
    /**
     * Unknown
     */
    JPCardNetworkTypeUnknown = 0,
    /**
     * Visa Network
     */
    JPCardNetworkTypeVisa = 1 << 0,
    /**
     * MasterCard Network
     */
    JPCardNetworkTypeMasterCard = 1 << 1,
    /**
     * Maestro Network
     */
    JPCardNetworkTypeMaestro = 1 << 2,
    /**
     * American Express Network
     */
    JPCardNetworkTypeAMEX = 1 << 3,
    /**
     * China Union Pay Network
     */
    JPCardNetworkTypeChinaUnionPay = 1 << 4,
    /**
     * JCB Network
     */
    JPCardNetworkTypeJCB = 1 << 5,
    /**
     * Discover Network
     */
    JPCardNetworkTypeDiscover = 1 << 6,
    /**
     * Diners Club Network
     */
    JPCardNetworkTypeDinersClub = 1 << 7,
    /**
     * All card networks
     */
    JPCardNetworkTypeAll,
};
