//
//  ObjectiveCExampleAppUITests.m
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

#import "JPUITestConfiguration.h"
#import "JPUITestSetup.h"
#import "JPUITestGivenSteps.h"
#import "JPUITestWhenSteps.h"
#import "JPUITestThenSteps.h"
#import "Cucumberish.h"

__attribute__((constructor))

void CucumberishInit() {

    NSBundle *bundle = [NSBundle bundleForClass:[JPUITestSetup class]];
    
    JPUITestConfiguration *configuration = JPUITestConfiguration.defaultConfiguration;

    [JPUITestSetup setUpWithConfiguration:configuration];
    [JPUITestGivenSteps setUp];
    [JPUITestWhenSteps setUpWithConfiguration:configuration];
    [JPUITestThenSteps setUpWithConfiguration:configuration];

    [Cucumberish executeFeaturesInDirectory:@"JudoKit-Automation-Scenarios/features"
                                 fromBundle:bundle
                                includeTags:configuration.testsToInclude
                                excludeTags:configuration.testsToSkip];
}
