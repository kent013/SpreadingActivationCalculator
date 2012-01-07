//
//  SpreadingActivation.m
//  SpreadingActivation
//
//  Created by Kentaro ISHITOYA on 11/12/21.
//  Copyright (c) 2011 Kentaro ISHITOYA. All rights reserved.
//

#import "SpreadingActivationCalculator.h"
#include "Eigen/Core"
#include <iostream>

using namespace std;
using namespace Eigen;

//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface SpreadingActivationCalculator(PrivateImplementation)
- (void)setupInitialState;
- (BOOL)validateNodes:(NSArray *)nodes;
- (BOOL)validateEdges:(NSArray *)edges;
- (VectorXf)createExternalValueVectorFromNodes:(NSArray *)nodes;
- (MatrixXf)createNetworkMatrixFromNodes:(NSArray *)nodes andEdges:(NSArray *)edges;
- (VectorXf)calculateWorkerAtNumber:(int)t decayValue:(float)decayValue previousSum:(float)previousSum networkMatrix:(MatrixXf)networkMatrix activationValues:(VectorXf)activationValues andExternalValues:(VectorXf)externalValues;
@end

@implementation SpreadingActivationCalculator(PrivateImplementation)
/*!
 * private initializer
 */
- (void)setupInitialState{
    self.decayValue = 0.5;
    self.maximumStep = 100;
}

/*!
 * validate nodes
 * at least one node must have an external value
 * @param nodes array of SpreadingActivationNode
 */
- (BOOL)validateNodes:(NSArray *)nodes{
    for(SpreadingActivationNode *node in nodes){
        if(node.externalValue){
            return YES;
        }
    }
    return NO;
}

/*!
 * validate edges
 * edges must not be null, empty.
 * @param edges two dimantional array of SpreadingActivationEdge
 */
- (BOOL)validateEdges:(NSArray *)edges{
    if(edges == nil || edges.count == 0){ //|| [[edges objectAtIndex:0] isKindOfClass:[NSArray class]] == NO){
        return NO;
    }
    //if(edges.count != ((NSArray *)[edges objectAtIndex:0]).count){
    //    return NO;
    //}
    return YES;
}

/*!
 * create external value vector from nodes array
 * @param nodes array of SpreadingActivationNode
 * @return VectorXf vector of external values
 */
- (VectorXf)createExternalValueVectorFromNodes:(NSArray *)nodes{
    VectorXf v = VectorXf::Ones(nodes.count);
    int i = 0;
    for(SpreadingActivationNode *node in nodes){
        v(i) = node.externalValue;
        i++;
    }
    return v;
}

/*!
 * create network matrix from nodes and edges
 * @param nodes array of SpreadingActivationNode
 * @param edges two dimentional array of SpreadingActivationEdge
 */
- (MatrixXf)createNetworkMatrixFromNodes:(NSArray *)nodes andEdges:(NSArray *)edges{
    MatrixXf m = MatrixXf::Zero(nodes.count, nodes.count);
    for(SpreadingActivationEdge *edge in edges){
        int s = [nodes indexOfObject: edge.source];
        int t = [nodes indexOfObject: edge.target];
        if(s != t){
            m(s, t) = edge.weight;
            m(t, s) = edge.weight;
        }
    }
    return m;
}

/*!
 * calculate one step of spreading activation
 * @param step number
 * @param decay value
 * @param previous summary
 * @param network matrix
 * @param activation values
 * @param external values
 */
- (VectorXf)calculateWorkerAtNumber:(int)t decayValue:(float)decayValue previousSum:(float)previousSum networkMatrix:(MatrixXf)networkMatrix activationValues:(VectorXf)activationValues andExternalValues:(VectorXf)externalValues{
    if(t >= self.maximumStep){
        return activationValues;
    }
    int size = activationValues.rows();
    MatrixXf i = MatrixXf::Identity(size, size);
    VectorXf a1 = (((1.0 - decayValue) * i) + (decayValue * networkMatrix)) * activationValues;
    float sum = a1.sum();
    a1 /= sum;
    if(previousSum != 0 && fabsf(sum - previousSum) < 1.0){
        return a1;
    }
    for(int k = 0; k < size; k++){
        a1(k) += externalValues(k);
    }
    if(self.showDebugOutput){
        cout << "----------------------------------" << endl;
        cout << "step " << t << ", sum is " << sum << endl;
        cout << a1 << endl;
    }
    return [self calculateWorkerAtNumber:t + 1 decayValue:decayValue previousSum:sum networkMatrix:networkMatrix activationValues:a1 andExternalValues:externalValues];
}

@end

//-----------------------------------------------------------------------------
//Public Implementations
//-----------------------------------------------------------------------------
@implementation SpreadingActivationCalculator
@synthesize maximumStep;
@synthesize decayValue;
@synthesize showDebugOutput;

/*!
 * initializer
 */
- (id)init
{
    self = [super init];
    if (self) {
        [self setupInitialState];
    }
    
    return self;
}

/*!
 * decay value must be 0.0 to 1.0
 */
- (void)setdecayValue:(float)indecayValue{
    NSString *error = [NSString stringWithFormat:@"%s, decay value must be 0.0 to 1.0: %f passed", __PRETTY_FUNCTION__, indecayValue];
    NSAssert((indecayValue >= 0.0f && indecayValue <= 1.0f), error);
    decayValue = indecayValue;
}

/*!
 * calculate spreading activation
 * @param nodes array of SpreadingActivationNode
 * @param edges two dimentional array of SpreadingActivationEdge
 */
- (NSArray *) calculateNodes:(NSArray *)nodes andEdges:(NSArray *)edges{
    if([self validateNodes:nodes] == NO){
        NSLog(@"%s: invalid nodes.", __PRETTY_FUNCTION__);
        return nil;
    }
    if([self validateEdges:edges] == NO){
        NSLog(@"%s: invalid edges.", __PRETTY_FUNCTION__);
        return nil;
    }
    
    VectorXf defaultActivationValues = VectorXf::Ones(nodes.count);
    VectorXf externalValues = [self createExternalValueVectorFromNodes:nodes];
    MatrixXf networkMatrix = [self createNetworkMatrixFromNodes:nodes andEdges:edges];
    
    if(self.showDebugOutput){
        cout << "==================================" << endl;
        cout << "decayValue: " << self.decayValue << endl;
        cout << "----------------------------------" << endl;
        cout << "default activation values" << endl;
        cout << defaultActivationValues << endl;
        cout << "external values" << endl;
        cout << externalValues << endl;
        cout << "network matrix values" << endl;
        cout << networkMatrix << endl;
    }
    
    VectorXf activationValues = [self calculateWorkerAtNumber:0 decayValue:self.decayValue previousSum:0.0 networkMatrix:networkMatrix activationValues:defaultActivationValues andExternalValues:externalValues];
    for(int i = 0; i < activationValues.rows(); i++){
        SpreadingActivationNode *node = [nodes objectAtIndex:i];
        node.activationValue = activationValues(i);
    }
    
    if(self.showDebugOutput){
        cout << "==================================" << endl;
        cout << "spreading activation result" << endl;
        cout << activationValues << endl;
        cout << "----------------------------------" << endl;
    }
    return nodes;
}
@end
