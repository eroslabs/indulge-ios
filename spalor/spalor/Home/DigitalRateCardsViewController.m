//
//  DigitalRateCardsViewController.m
//  spalor
//
//  Created by Manish on 22/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DigitalRateCardsViewController.h"
#import "Merchant.h"
#import "MerchantService.h"
#import "TypeTableViewCell.h"

@interface DigitalRateCardsViewController (){
    NSMutableDictionary *servicesDictionary;
}
@end

@implementation DigitalRateCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self restructreservices];
}

-(void)restructreservices{
    servicesDictionary = [NSMutableDictionary new];
    for(MerchantService *serviceObj in self.merchant.services){
        
        NSMutableArray *serviceCategory = nil;
        BOOL newServiceCategory = NO;
        if([[servicesDictionary allKeys] containsObject:serviceObj.categoryName]){
            //Add this service to the existing category
            serviceCategory = servicesDictionary[serviceObj.categoryName];
        }
        else{
            //Create a New category
            serviceCategory = [NSMutableArray  new];
            newServiceCategory = YES;
            [serviceCategory addObject:@{@"name":serviceObj.serviceName,@"primary":@YES}];
        }
        
        NSMutableDictionary *typeDict = [NSMutableDictionary new];
        NSString *gender = @"Unisex";
        if([serviceObj.gender isEqual:@(0)]){
            gender = @"Male";
        }
        else if([serviceObj.gender isEqual:@(1)]){
            gender = @"Female";
        }
        [typeDict addEntriesFromDictionary:@{@"name":serviceObj.type,@"gender":gender,@"price":serviceObj.price,@"primary":@NO}];
//        NSMutableArray *servicesArray = nil;
        
//        if([[serviceCategory allKeys] containsObject:serviceObj.serviceName]){
//            //Add to the esting Service Category
//            servicesArray = serviceCategory[serviceObj.serviceName];
//            
//            
//        }
//        else{
//            //Create a New Service in the category
//            servicesArray = [NSMutableArray new];
//            
//        }
        
        [serviceCategory addObject:typeDict];
        [servicesDictionary addEntriesFromDictionary:@{serviceObj.categoryName:serviceCategory}];
        
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = [servicesDictionary allKeys];

    NSArray *services =  servicesDictionary[keys[section]];
    
    return services.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [servicesDictionary allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"Table Cell Data");
    NSArray *keys = [servicesDictionary allKeys];
    
    NSArray *serviceCategory = servicesDictionary[keys[indexPath.section]];
    
    NSDictionary *service = serviceCategory[indexPath.row];
    
    NSString *CellIdentifier = ([service[@"primary"] isEqual:@YES])?@"ServiceCell":@"TypeCell";

    
    if([service[@"primary"] isEqual:@YES]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",service[@"name"]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext Medium" size:11.0f];
        return cell;

    }
    else{
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.typeName.text = service[@"name"];
        cell.genderName.text = service[@"gender"];
        cell.priceName.text = [NSString stringWithFormat:@"%@",service[@"price"]];
        return cell;

    }
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    NSArray *keys = [servicesDictionary allKeys];
    
    NSString *sectionName = keys[section];
    
    UIButton *viewAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewAllButton setTitle:@"View All" forState:UIControlStateNormal];
    
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 5, 150, 20);
    myLabel.font = [UIFont fontWithName:@"Avenir Next Demi Bold" size:20.0f];
    myLabel.textColor = [UIColor whiteColor];
    
    myLabel.text = sectionName;
    
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor lightTextColor];
    [headerView addSubview:myLabel];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0f;
}

@end
