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
    
    
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
//    
    
    
}

//- (void)configureRestKit
//{
//    // initialize AFNetworking HTTPClient
//    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
//    
//    // initialize RestKit
//    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
//    
//    // setup object mappings
//    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
//    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
//    
//    // register mappings with the provider using a response descriptor
//    RKResponseDescriptor *responseDescriptor =
//    [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
//                                                 method:RKRequestMethodGET
//                                            pathPattern:@"/v2/venues/search"
//                                                keyPath:@"response.venues"
//                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
//    
//    [objectManager addResponseDescriptor:responseDescriptor];
//}
//

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
                                                
}


//
//- (void)loadVenues
//{
//    NSString *latLon = @"37.33,-122.03"; // approximate latLon of The Mothership (a.k.a Apple headquarters)
//    NSString *clientID = kCLIENTID;
//    NSString *clientSecret = kCLIENTSECRET;
//    
//    NSDictionary *queryParams = @{@"ll" : latLon,
//                                  @"client_id" : clientID,
//                                  @"client_secret" : clientSecret,
//                                  @"categoryId" : @"4bf58dd8d48988d1e0931735",
//                                  @"v" : @"20140118"};
//    
//    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
//                                           parameters:queryParams
//                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                  _venues = mappingResult.array;
//                                                  [self.tableView reloadData];
//                                              }
//                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
//                                              }];
//}

-(void)loadVenues
{
    NSString *latLon = @"-37.73,145.05"; //Location
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Venue *venue = _venues[indexPath.row];
    cell.textLabel.text = venue.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}






@end
