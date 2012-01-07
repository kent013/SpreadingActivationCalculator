//
//  SpreadingActivationTests.m
//  SpreadingActivationTests
//
//  Created by Kentaro ISHITOYA on 12/01/06.
//  Copyright (c) 2011 Kentaro ISHITOYA. All rights reserved.
//

#import "SpreadingActivationTests.h"
#import "SpreadingActivationCalculator.h"

@implementation SpreadingActivationTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCalculator
{
    SpreadingActivationCalculator *calculator = [[SpreadingActivationCalculator alloc] init];
    NSArray *nodes = 
    [NSArray arrayWithObjects:
     [[SpreadingActivationNode alloc] initWithNodeHash:@"0" andExternalValue:1.0],
     [[SpreadingActivationNode alloc] initWithNodeHash:@"1" andExternalValue:1.0],
     [[SpreadingActivationNode alloc] initWithNodeHash:@"2" andExternalValue:1.0],
     [[SpreadingActivationNode alloc] initWithNodeHash:@"3" andExternalValue:1.0],
     nil];
    NSMutableArray *edges = 
    [NSArray arrayWithObjects:
     [[SpreadingActivationEdge alloc] initWithSource:[nodes objectAtIndex:0] target:[nodes objectAtIndex:1] andWeight:1.0],
     [[SpreadingActivationEdge alloc] initWithSource:[nodes objectAtIndex:0] target:[nodes objectAtIndex:3] andWeight:1.0],
     [[SpreadingActivationEdge alloc] initWithSource:[nodes objectAtIndex:1] target:[nodes objectAtIndex:2] andWeight:1.0], nil];
    nodes = [calculator calculateNodes:nodes andEdges:edges];
    
    STAssertEquals((int)nodes.count, 4, @"nodes count");
    STAssertEqualsWithAccuracy(((SpreadingActivationNode *)[nodes objectAtIndex:0]).activationValue, 0.301637f, 0.000001f, @"assert equal");
    STAssertEqualsWithAccuracy(((SpreadingActivationNode *)[nodes objectAtIndex:1]).activationValue, 0.301637f, 0.000001f, @"assert equal");
    STAssertEqualsWithAccuracy(((SpreadingActivationNode *)[nodes objectAtIndex:2]).activationValue, 0.198363f, 0.000001f, @"assert equal");
    STAssertEqualsWithAccuracy(((SpreadingActivationNode *)[nodes objectAtIndex:3]).activationValue, 0.198363f, 0.000001f, @"assert equal");
}

@end
