//
//  Venue.h
//  CoffeeKit
//
//  Created by Jonathan Carnie on 12/04/2014.
//  Copyright (c) 2014 Jonathan Carnie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;
@class Stats;

@interface Venue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Stats *stats;

@end
