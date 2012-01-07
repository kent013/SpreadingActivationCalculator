//
//  SpreadingActivationEdge.h
//  SpreadingActivation
//
//  Created by Kentaro ISHITOYA on 12/01/07.
//  Copyright (c) 2012 Kentaro ISHITOYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpreadingActivationNode.h"

/*!
 * spreading activation edge
 */
@interface SpreadingActivationEdge : NSObject
/*!
 * source node
 */
@property (nonatomic, strong) SpreadingActivationNode *source;

/*!
 * target node
 */
@property (nonatomic, strong) SpreadingActivationNode *target;

/*!
 * edge weight
 * value must be 0.0 to 1.0
 */
@property (nonatomic, assign) float weight;

- (id)initWithSource:(SpreadingActivationNode *)source target:(SpreadingActivationNode *)target andWeight:(float)weight;
@end
