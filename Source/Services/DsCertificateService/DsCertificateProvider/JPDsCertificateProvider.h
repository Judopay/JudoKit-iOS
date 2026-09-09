//
//  JPDsCertificateProvider.h
//  JudoKit_iOS
//
//  Copyright (c) 2026 Alternative Payments Ltd
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

#import "JPDsCertificateRepository.h"
#import <Foundation/Foundation.h>
#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Implements JP3DSDirectoryServerCertificateProvider to supply dynamic DS certificates
 * fetched from the Judo CDN. Returns nil for any DS ID not found in the cache,
 * which causes the 3DS SDK to fall back to its bundled certificates.
 */
@interface JPDsCertificateProvider : NSObject <JP3DSDirectoryServerCertificateProvider>

- (instancetype)initWithRepository:(JPDsCertificateRepository *)repository;

@end

NS_ASSUME_NONNULL_END
