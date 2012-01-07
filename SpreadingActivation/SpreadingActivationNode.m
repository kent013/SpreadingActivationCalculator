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
@end
