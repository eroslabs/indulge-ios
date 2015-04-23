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
#import "FilterDetailViewController.h"

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
    [self pickCategoriesFromLocalStorage];
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

-(void)pickCategoriesFromLocalStorage{
    NSError *error = nil;
    NSData *categoryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryResponse"];
    NSDate *date1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryUpdateDate"];
    NSDate *date2 = [NSDate date];
    
    NSInteger days = [self daysBetweenDate:date1 andDate:date2];
    
    if (days>=10) {
        [self loadCategories];
        return;
    }
    
    NSDictionary *categoryDict = [NSJSONSerialization JSONObjectWithData:categoryData options:NSJSONReadingAllowFragments error:&error];
    
    if (categoryDict && !error) {
        arrayOfCategories = [self captureAllServicesandCategoriesFromResponseDict:categoryDict];
    }
    else{
        [self loadCategories];
    }
}


-(void)loadCategories{

//    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/suggestMerchant" withParameters:@{@"s":@"abc"} completionHandler:^(id response, NSString *url, NSError *error){

    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/loadCategories" withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error){
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"CategoryResponse"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"CategoryUpdateDate"];
            
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
        
        //NSLog(@"category %@ %d",category.name,category.services.count);
        
//        for(Service *service in category.services){
//            NSLog(@"service %@",service.name);
//        }
//        
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowFilterDetail"]) {
        
        FilterDetailViewController *controller = (FilterDetailViewController *)segue.destinationViewController;
        controller.arrayOfCategories  = arrayOfCategories;
    }
}


@end
