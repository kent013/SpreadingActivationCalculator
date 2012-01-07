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

//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface SpreadingActivationCalculator(PrivateImplementation)
- (void)setupInitialState;
- (BOOL)validateNodes:(NSArray *)nodes;
- (BOOL)validateEdges:(NSArray *)edges;
- (Eigen::VectorXf)createExternalValueVectorFromNodes:(NSArray *)nodes;
- (Eigen::MatrixXf)createNetworkMatrixFromNodes:(NSArray *)nodes andEdges:(NSArray *)edges;
- (Eigen::VectorXf)calculateWorkerAtNumber:(int)t propagationValue:(float)propagationValue previousSum:(float)previousSum networkMatrix:(Eigen::MatrixXf)networkMatrix activationValues:(Eigen::VectorXf)activationValues andExternalValues:(Eigen::VectorXf)externalValues;
@end

@implementation SpreadingActivationCalculator(PrivateImplementation)
/*!
 * private initializer
 */
- (void)setupInitialState{
    self.propagationValue = 0.5;
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
 * @return Eigen::VectorXf vector of external values
 */
- (Eigen::VectorXf)createExternalValueVectorFromNodes:(NSArray *)nodes{
    Eigen::VectorXf v = Eigen::VectorXf::Ones(nodes.count);
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
- (Eigen::MatrixXf)createNetworkMatrixFromNodes:(NSArray *)nodes andEdges:(NSArray *)edges{
    Eigen::MatrixXf m = Eigen::MatrixXf::Zero(nodes.count, nodes.count);
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
 * @param propagation value
 * @param previous summary
 * @param network matrix
 * @param activation values
 * @param external values
 */
- (Eigen::VectorXf)calculateWorkerAtNumber:(int)t propagationValue:(float)propagationValue previousSum:(float)previousSum networkMatrix:(Eigen::MatrixXf)networkMatrix activationValues:(Eigen::VectorXf)activationValues andExternalValues:(Eigen::VectorXf)externalValues{
    if(t >= self.maximumStep){
        return activationValues;
    }
    int size = activationValues.rows();
    Eigen::MatrixXf i = Eigen::MatrixXf::Identity(size, size);
    Eigen::VectorXf a1 = (((1.0 - propagationValue) * i) + (propagationValue * networkMatrix)) * activationValues;
    float sum = a1.sum();
    a1 /= sum;
    if(previousSum != 0 && fabsf(sum - previousSum) < 1.0){
        return a1;
    }
    for(int k = 0; k < size; k++){
        a1(k) += externalValues(k);
    }
    /*NSLog(@"at %d step", t);
    std::cout << a1 << std::endl;*/
    return [self calculateWorkerAtNumber:t + 1 propagationValue:propagationValue previousSum:sum networkMatrix:networkMatrix activationValues:a1 andExternalValues:externalValues];
}
@end

//-----------------------------------------------------------------------------
//Public Implementations
//-----------------------------------------------------------------------------
@implementation SpreadingActivationCalculator
@synthesize maximumStep;
@synthesize propagationValue;

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
    
    Eigen::VectorXf defaultActivationValues = Eigen::VectorXf::Ones(nodes.count);
    Eigen::VectorXf externalValues = [self createExternalValueVectorFromNodes:nodes];
    Eigen::MatrixXf networkMatrix = [self createNetworkMatrixFromNodes:nodes andEdges:edges];
    
    /*
    std::cout << "default activation values" << std::endl;
    std::cout << defaultActivationValues << std::endl;
    std::cout << "external values" << std::endl;
    std::cout << externalValues << std::endl;
    std::cout << "network matrix values" << std::endl;
    std::cout << networkMatrix << std::endl;*/
    
    Eigen::VectorXf activationValues = [self calculateWorkerAtNumber:0 propagationValue:self.propagationValue previousSum:0.0 networkMatrix:networkMatrix activationValues:defaultActivationValues andExternalValues:externalValues];
    for(int i = 0; i < activationValues.rows(); i++){
        SpreadingActivationNode *node = [nodes objectAtIndex:i];
        node.activationValue = activationValues(i);
    }
    return nodes;
}
@end
