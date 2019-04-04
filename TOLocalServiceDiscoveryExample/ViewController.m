//
//  ViewController.m
//  TOLocalServiceDiscoveryExample
//
//  Created by Tim Oliver on 4/4/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "ViewController.h"
#import "TOLocalServiceDiscovery.h"

@interface ViewController ()

@property (nonatomic, strong) TOLocalServiceDiscovery *serviceDiscovery;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    NSArray *serviceTypes = @[@"_smb._tcp.",
                              @"_ftp._tcp.",
                              @"_sftp-ssh._tcp.",
                              ];
    self.serviceDiscovery = [[TOLocalServiceDiscovery alloc] initWithSearchServiceTypes:serviceTypes];
    self.serviceDiscovery.serviceListUpdatedHandler = ^{
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.serviceDiscovery startDiscovery];
}

#pragma mark - Table View Delegate + Data Source -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceDiscovery.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    NSNetService *service = self.serviceDiscovery.services[indexPath.row];
    cell.textLabel.text = service.name;
    cell.detailTextLabel.text = service.type;

    return cell;
}

@end
