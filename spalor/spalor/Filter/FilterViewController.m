//
//  FilterViewController.m
//  spalor
//
//  Created by Manish on 18/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FilterViewController.h"
#import "NetworkHelper.h"
#import "ServiceCategory.h"

@interface FilterViewController (){
    NSArray *arrayOfCategories;
}

@end

@implementation FilterViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadCategories];
}


-(void)loadCategories{

//    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/suggestMerchant" withParameters:@{@"s":@"abc"} completionHandler:^(id response, NSString *url, NSError *error){

    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/loadCategories" withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error){
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"CategoryResponse"];
            
            
            if (responseDict) {
                arrayOfCategories = [self captureAllServicesandCategoriesFromResponseDict:responseDict];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
              //  [self.tableview reloadData];
            });
            
        }
        else{
            NSLog(@"error %@",[error localizedDescription]);
        }

    }];
}


-(NSArray *)captureAllServicesandCategoriesFromResponseDict:(NSDictionary *)dictionary{
    
    NSArray *resultArray = dictionary[@"categories"];
    NSMutableArray *categoryArray = [NSMutableArray new];
    
    for (NSDictionary *categoryDict in resultArray) {
        
        ServiceCategory *category = [[ServiceCategory alloc] init];
        [category readFromDictionary:categoryDict];
        
        NSLog(@"category %@",category.name);
        
        for(Service *service in category){
            NSLog(@"service %@",service.name);
        }
        
        [categoryArray addObject:category];
        
    }
    
    return categoryArray;
}

#pragma mark -
#pragma mark UITableViewDatasource

//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSInteger numOfRows = 10;
//    return numOfRows;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return 50;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
//    cell.textLabel.text = @"Sample";
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"detailSegue" sender:self];
//    
//}

#pragma mark - User Actions

-(IBAction)saveFilter:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)closeFilter:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
