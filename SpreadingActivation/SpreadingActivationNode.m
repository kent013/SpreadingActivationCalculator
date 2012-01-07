//
//  SpreadingActivationNode.m
//  SpreadingActivation
//
//  Created by Kentaro ISHITOYA on 12/01/07.
//  Copyright (c) 2012 Kentaro ISHITOYA. All rights reserved.
//

#import "SpreadingActivationNode.h"

@implementation SpreadingActivationNode
@synthesize externalValue;
@synthesize activationValue;
@synthesize nodeHash;

/*!
 * initializer
 * @param node hash
 * @param external value
 */
- (id)initWithNodeHash:(NSString *)inNodeHash andExternalValue:(float)inExternalValue{
    self = [super init];
    if(self){
        self.nodeHash = inNodeHash;
        self.externalValue = inExternalValue;
        self.activationValue = 0.0;
    }
    return self;
}

/*!
 * set external value
 * external value must be 0.0 to 1.0
 */
- (void)setExternalValue:(float)inExternalValue{
    NSAssert((inExternalValue >= 0.0f && inExternalValue <= 1.0f), @"%s, external value must be 0.0 to 1.0: %f passed", __PRETTY_FUNCTION__, inExternalValue);
    externalValue = inExternalValue;
}
@end
