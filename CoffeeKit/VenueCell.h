//
//  VenueCell.h
//  CoffeeKit
//
//  Created by Jonathan Carnie on 12/04/2014.
//  Copyright (c) 2014 Jonathan Carnie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel *checkinsLabel;


@end
