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

/*!
 * set weight
 * weight must be 0.0 to 1.0
 */
- (void)setWeight:(float)inWeight{
    NSAssert((inWeight >= 0.0f && inWeight <= 1.0f), @"%s, Weight must be 0.0 to 1.0: %f passed", __PRETTY_FUNCTION__, inWeight);
    weight = inWeight;
}
@end
