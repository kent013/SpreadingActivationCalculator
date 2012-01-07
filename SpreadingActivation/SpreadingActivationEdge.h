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
 */
@property (nonatomic, assign) float weight;

- (id)initWithSource:(SpreadingActivationNode *)source target:(SpreadingActivationNode *)target andWeight:(float)weight;
@end
