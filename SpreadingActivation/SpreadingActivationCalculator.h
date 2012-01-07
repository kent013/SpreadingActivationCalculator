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
 * decay value
 */
@property (nonatomic, assign) float decayValue;

/*!
 * show debug output
 */
@property (nonatomic, assign) BOOL showDebugOutput;

- (NSArray *)calculateNodes:(NSArray *)nodes andEdges:(NSArray *)edges;
@end
