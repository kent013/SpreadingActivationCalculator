//
//  SpreadingActivationEdge.m
//  SpreadingActivation
//
//  Created by Kentaro ISHITOYA on 12/01/07.
//  Copyright (c) 2012 Kentaro ISHITOYA. All rights reserved.
//

#import "SpreadingActivationEdge.h"

@implementation SpreadingActivationEdge
@synthesize source;
@synthesize target;
@synthesize weight;

/*!
 * initializer
 * @param source node
 * @param target node
 * @param weight of the edge
 */
- (id)initWithSource:(SpreadingActivationNode *)inSource target:(SpreadingActivationNode *)inTarget andWeight:(float)inWeight{
    self = [super init];
    if(self){
        self.source = inSource;
        self.target = inTarget;
        self.weight = inWeight;
    }
    return self;
}
@end
