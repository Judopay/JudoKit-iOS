//
//  JPUITestSetup.m
//  ObjectiveCExampleAppUITests
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

#import "JPUITestSetup.h"
#import "JPTagHandlers.h"
#import "JPAfterHandlers.h"
#import <Cucumberish/Cucumberish.h>

@implementation JPUITestSetup

+ (void)setUp {
    
    /**
     * A handler that ensures that the application is executed before the test scenarios start running.
     */
    beforeStart(^{
        [[XCUIApplication new] launch];
    });

    /**
     * [TAG] require-non-3ds-config
     *
     * A tag that is used to specify that non-3DS credentials (Judo ID, Token & Secret) must be set before the
     * scenario executes.
     */
    beforeTagged(@[@"require-non-3ds-config"], ^(CCIScenarioDefinition *scenario) {
        handleRequireNon3DSConfig();
    });
    
    /**
     * [TAG] require-3ds-config
     *
     * A tag that is used to specify that 3DS credentials (Judo ID, Token & Secret) must be set before the
     * scenario executes.
     */
    beforeTagged(@[@"require-3ds-config"], ^(CCIScenarioDefinition *scenario) {
        handleRequire3DSConfig();
    });

    /**
     * [TAG] require-all-card-networks
     *
     * A tag that is used to specify that all card networks must be accepted before the scenario executes.
     */
    beforeTagged(@[@"require-all-card-networks"], ^(CCIScenarioDefinition *scenario) {
        handleRequireAllCardNetworks();
    });

    /**
     * [TAG] require-avs
     *
     * A tag that is used to specify that AVS must be enabled before the scenario executes
     */
    beforeTagged(@[@"require-avs"], ^(CCIScenarioDefinition *scenario) {
        handleRequireAVS();
    });

    /**
     * [TAG] require-button-amount
     *
     * A tag that is used to specify that the amount on the "Submit Transaction" button on the Judo UI widget must be
     * enabled before the scenario executes.
     */
    beforeTagged(@[@"require-button-amount"], ^(CCIScenarioDefinition *scenario) {
        handleRequireButtonAmount();
    });

    /**
     * [TAG] require-card-payment-method
     *
     * A tag that is used to specify that the Judo wallet should support Card transactions.
     */
    beforeTagged(@[@"require-card-payment-method"], ^(CCIScenarioDefinition *scenario) {
        handleRequireCardPaymentMethod();
    });

    /**
     * [TAG] require-ideal-payment-method
     *
     * A tag that is used to specify that the Judo wallet should support iDEAL transactions.
     */
    beforeTagged(@[@"require-ideal-payment-method"], ^(CCIScenarioDefinition *scenario) {
        handleRequireIDEALPaymentMethod();
    });

    /**
     * [TAG] require-apple-pay-payment-method
     *
     * A tag that is used to specify that the Judo wallet should support Apple Pay transactions.
     */
    beforeTagged(@[@"require-apple-pay-payment-method"], ^(CCIScenarioDefinition *scenario) {
        handleRequireApplePayPaymentMethod();
    });

    /**
     * [TAG] require-pbba-payment-method
     *
     * A tag that is used to specify that the Judo wallet should support PBBA transactions.
     */
    beforeTagged(@[@"require-pbba-payment-method"], ^(CCIScenarioDefinition *scenario) {
        handleRequirePBBAPaymentMethod();
    });

    /**
     * [TAG] require-all-payment-methods
     *
     * A tag that is used to specify that the Judo wallet should support all transaction methods.
     */
    beforeTagged(@[@"require-all-payment-methods"], ^(CCIScenarioDefinition *scenario) {
        handleRequireAllPaymentMethods();
    });

    /**
     * [TAG] require-currency-gbp
     *
     * A tag that is used to specify that the selected currency should be GBP
     */
    beforeTagged(@[@"require-currency-gbp"], ^(CCIScenarioDefinition *scenario) {
        handleRequireCurrencyGBP();
    });

    /**
     * [TAG] require-currency-eur
     *
     * A tag that is used to specify that the selected currency should be EUR
     */
    beforeTagged(@[@"require-currency-eur"], ^(CCIScenarioDefinition *scenario) {
        handleRequireCurrencyEUR();
    });

    /**
     * A code block that is going to execute after each transaction.
     * Used to reset the app to a clean state.
     */
    after(^(CCIScenarioDefinition *scenario) {
        cleanUp();
    });
}

@end
