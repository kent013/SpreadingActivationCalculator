//
//  SpreadingActivationNode.h
//  SpreadingActivation
//
//  Created by Kentaro ISHITOYA on 12/01/07.
//  Copyright (c) 2012 Kentaro ISHITOYA. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * Node for spreading activation
 */
@interface SpreadingActivationNode : NSObject
/*!
 * external default value
 * value must be 0.0 to 1.0
 */
@property (nonatomic, assign) float externalValue;

/*!
 * calculated activation value.
 */ 
@property (nonatomic, assign) float activationValue;

/*!
 * hash
 */
@property (nonatomic, strong) NSString *nodeHash;

- (id)initWithNodeHash:(NSString *)nodeHash andExternalValue:(float)externalValue;
@end 
