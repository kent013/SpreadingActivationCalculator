//
//  SpreadingActivation.h
//  SpreadingActivation
//
//  Created by Kentaro ISHITOYA on 11/12/21.
//  Copyright (c) 2011 Kentaro ISHITOYA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpreadingActivationNode.h"
#import "SpreadingActivationEdge.h"

/*!
 * spreading activation calculator
 */
@interface SpreadingActivationCalculator : NSObject
/*!
 * maximum iteration steps
 */
@property (nonatomic, assign) int maximumStep;

/*!
 * propagation value
 */
@property (nonatomic, assign) float propagationValue;

- (NSArray *)calculateNodes:(NSArray *)nodes andEdges:(NSArray *)edges;
@end
