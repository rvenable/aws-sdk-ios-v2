/*
 * Copyright 2010-2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#if AWS_TEST_ERS


#import <XCTest/XCTest.h>
#import "AWSCore.h"
#import "AWSTestUtility.h"

@interface AWSERSTests : XCTestCase

@end

@implementation AWSERSTests

- (void)setUp
{
    [super setUp];
    [AWSTestUtility setupCognitoCredentialsProvider];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPutEvents
{
    AWSEventRecorderService *ers = [AWSEventRecorderService defaultEventRecorderService];
    
    AWSEventRecorderServicePutEventsInput *putEventInput = [AWSEventRecorderServicePutEventsInput new];

    
    AWSEventRecorderServiceEvent *eventOne = [AWSEventRecorderServiceEvent new];
    
    eventOne.attributes = @{};
    eventOne.version = @"v2.0";
    eventOne.eventType = @"_session.start";
    eventOne.timestamp = [[NSDate date] az_stringValue:AZDateISO8601DateFormat3];
    
    AWSEventRecorderServiceSession *serviceSession = [AWSEventRecorderServiceSession new];
    serviceSession.id = @"SMZSP1G8-21c9ac01-20140604-171714026";
    serviceSession.startTimestamp = [[NSDate date] az_stringValue:AZDateISO8601DateFormat3];
    
    eventOne.session = serviceSession;
    
    putEventInput.events = @[eventOne];
    
    NSDictionary *clientContext = @{@"client": @{@"app_package_name": @"MT3T3XMSMZSP1G8",
                                                 @"app_version_name":@"v1.2",
                                                 @"app_version_code":@"3",
                                                 @"app_title":[NSNull null],
                                                 @"client_id":@"0a877e9d-c7c0-4269-b138-cb3f21c9ac01"
                                                 },
                                    @"env" : @{@"model": @"iPhone Simulator",
                                               @"make":@"Apple",
                                               @"platform":@"IOS",
                                               @"platform_version":@"4.3.1",
                                               @"locale":@"en-US"},
                                    @"custom" : @{},
                                    };
    NSString *clientContextJsonString = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject:clientContext options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    putEventInput.clientContext = clientContextJsonString;
    
    [[[ers putEvents:putEventInput] continueWithBlock:^id(BFTask *task) {
        XCTAssertNil(task.error, @"The request failed. error: [%@]", task.error);

        return nil;
        
    }] waitUntilFinished ];
}

@end

#endif