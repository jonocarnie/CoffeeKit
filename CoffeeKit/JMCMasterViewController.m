//
//  JMCMasterViewController.m
//  CoffeeKit
//
//  Created by Jonathan Carnie on 12/04/2014.
//  Copyright (c) 2014 Jonathan Carnie. All rights reserved.
//

#import "JMCMasterViewController.h"

#import <RestKit/RestKit.h>
#import "Venue.h"
#import "Location.h"
#import "VenueCell.h"
#import "Stats.h"

#define kCLIENTID @"G2WO2PR4O2EQJRSVBLGZ1WWMEDHQINVZM2ZKD2PSEY12KV4W"
#define kCLIENTSECRET @"3E25125KQSYIYAD133AY2QGWFR12MGNJYP3EKAMKWZOOWWVP"


@interface JMCMasterViewController ()
@property (nonatomic, strong) NSArray *venues;
@end

@implementation JMCMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureRestKit];
    [self loadVenues];
    

    
    
}


-(void)configureRestKit
{
    // initialise afnetworking httpclient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // init aft restkit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    //setup object mappings
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    
    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
    
    //register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:venueMapping method:RKRequestMethodGET pathPattern:@"/v2/venues/search" keyPath:@"response.venues" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    //define location object mapping
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
    
    //define relationship mapping
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
    
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];
    
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping]];
                                                
}


-(void)loadVenues
{
    NSString *latLon = @"-37.44,145.3"; //Location
    NSString *clientID = kCLIENTID;
    NSString *clientSecret = kCLIENTSECRET;
    
    NSDictionary *queryParams = @{@"ll" : latLon,
                                  @"client_id" : clientID,
                                  @"client_secret": clientSecret,
                                  @"categoryId" : @"4bf58dd8d48988d1e0931735",
                                  @"v" : @"20140118"};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _venues = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
    
    // melb -37.813611, 144.963056
    // heidelberg @"-37.73,145.05"
    // apple.  @"37.33,-122.03"
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_venues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];

    Venue *venue = _venues[indexPath.row];
    cell.nameLabel.text = venue.name;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.0fm", venue.location.distance.floatValue];
    cell.checkinsLabel.text = [NSString stringWithFormat:@"%d checkins", venue.stats.checkins.intValue];
    
    
//    cell.textLabel.text = venue.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm", venue.location.distance.floatValue];
 //   NSLog(@"Other Stuff: %@\n%@\n%@\n%@", venue.location.address, venue.location.distance, venue.location.lat, venue.location.lng);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}






@end
