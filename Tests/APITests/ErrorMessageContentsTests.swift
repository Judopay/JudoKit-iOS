//
//  ErrorMessageContentsTests.swift
//  JudoKitObjC
//
//  Created by Ashley Barrett on 08/04/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import XCTest

class ErrorMessageContentsTests: JudoTestCase {
    
    let UnableToProcessRequestErrorDesc = "Sorry, we're currently unable to process this request.";
    
    let ErrorRequestFailed = "The request responded without data";
    let ErrorPaymentMethodMissing = "The payment method (card details, token or PKPayment) has not been set for a transaction that requires it (custom UI)";
    let ErrorAmountMissing = "The amount has not been set for a transaction that requires it (custom UI)";
    let ErrorReferenceMissing = "The reference has not been set for a transaction that requires it (custom UI)";
    let ErrorResponseParseError = "An error with a response from the backend API";
    let ErrorUserDidCancel = "Received when user cancels the payment journey";
    let ErrorParameterError = "A parameter entered into the dictionary (request body to Judo API) is not set";
    let ErrorFailed3DSRequest = "After receiving the 3DS payload, when the payload has faulty data, the WebView fails to load the 3DS Page or the resolution page";
    
    let Error3DSRequest = "Error when routing to 3DS";
    let ErrorUnderlyingError = "An error in the iOS system with an enclosed underlying error";
    let ErrorTransactionDeclined = "A transaction that was sent to the backend returned declined";
    
    func test_ErrorRequestFailed() {
        let actual = NSError.judoRequestFailedError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, self.UnableToProcessRequestErrorDesc);
        XCTAssertEqual(devDescription, self.ErrorRequestFailed);
    }
    
    func test_ErrorPaymentMethodMissing() {
        let actual = NSError.judoPaymentMethodMissingError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, self.UnableToProcessRequestErrorDesc);
        XCTAssertEqual(devDescription, self.ErrorPaymentMethodMissing);
    }
    
    func test_ErrorAmountMissing() {
        let actual = NSError.judoAmountMissingError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, self.UnableToProcessRequestErrorDesc);
        XCTAssertEqual(devDescription, self.ErrorAmountMissing);
    }
    
    func test_ErrorReferenceMissing() {
        let actual = NSError.judoReferenceMissingError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, self.UnableToProcessRequestErrorDesc);
        XCTAssertEqual(devDescription, self.ErrorReferenceMissing);
    }
    
    func test_ErrorResponseParseError() {
        let actual = NSError.judoResponseParseError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, self.UnableToProcessRequestErrorDesc);
        XCTAssertEqual(devDescription, self.ErrorResponseParseError);
    }
    
    func test_ErrorUserDidCancel() {
        let actual = NSError.judoUserDidCancelError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, "");
        XCTAssertEqual(devDescription, self.ErrorUserDidCancel);
    }
    
    func test_ErrorParameterError() {
        let actual = NSError.judoParameterError();
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, self.UnableToProcessRequestErrorDesc);
        XCTAssertEqual(devDescription, self.ErrorParameterError);
    }
    
    func test_ErrorFailed3DSRequest() {
        let actual = NSError.judo3DSRequestFailedErrorWithUnderlyingError(nil);
        
        let errorDescription = actual.userInfo[NSLocalizedDescriptionKey] as? String
        let devDescription = actual.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        
        XCTAssertEqual(errorDescription, self.UnableToProcessRequestErrorDesc);
        XCTAssertEqual(devDescription, self.ErrorFailed3DSRequest);
    }
}
