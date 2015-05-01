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
    NSMutableDictionary *filterDict;
}

@end

@implementation FilterViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad{
    [super viewDidLoad];
    filterDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"]];

    [self pickCategoriesFromLocalStorage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    filterDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"]];
    NSLog(@"filterDict %@",filterDict);
    
    [self setFilterButtonStates];
}

-(void)setFilterButtonStates{
    if ([filterDict[@"sort"] isEqualToString:@"distance"]) {
        self.button1.selected = YES;
    }
    else{
        self.button1.selected = NO;
    }
    
    if ([filterDict[@"sort"] isEqualToString:@"rating"]) {
        self.button2.selected = YES;
    }
    else{
        self.button2.selected = NO;
    }
    
    if ([filterDict[@"sort"] isEqualToString:@"popularity"]) {
        self.button3.selected = YES;
    }
    else{
        self.button3.selected = NO;
    }
    
    if ([filterDict[@"sort"] isEqualToString:@"cost"]) {
        self.button4.selected = YES;
    }
    else{
        self.button4.selected = NO;
    }
    
    if ([filterDict[@"hs"] isEqualToString:@"1"]) {
        self.button5.selected = YES;
    }
    else{
        self.button5.selected = NO;
    }
    
    if ([filterDict[@"hs"] isEqualToString:@"0"]) {
        self.button6.selected = YES;
    }
    else{
        self.button6.selected = NO;
    }
    
    if ([filterDict[@"gender"] isEqualToString:@"0"]) {
        self.button7.selected = YES;
    }
    else{
        self.button7.selected = NO;
    }
    
    if ([filterDict[@"gender"] isEqualToString:@"1"]) {
        self.button8.selected = YES;
    }
    else{
        self.button8.selected = NO;
    }
    
    if ([filterDict[@"gender"] isEqualToString:@"2"]) {
        self.button9.selected = YES;
    }
    else{
        self.button9.selected = NO;
    }
    
    if ([filterDict[@"pt"] isEqualToString:@"500"]) {
        self.button10.selected = YES;
    }
    else{
        self.button10.selected = NO;
    }
    
    if ([filterDict[@"pt"] isEqualToString:@"1000"]) {
        self.button11.selected = YES;
    }
    else{
        self.button11.selected = NO;
    }
    
    if ([filterDict[@"pt"] isEqualToString:@"2000"]) {
        self.button12.selected = YES;
    }
    else{
        self.button12.selected = NO;
    }
    
    if ([filterDict[@"pt"] isEqualToString:@"20000"]) {
        self.button13.selected = YES;
    }
    else{
        self.button13.selected = NO;
    }

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

-(IBAction)changeButtonState:(id)sender{
    UIButton *senderButton = (UIButton *)sender;

    //@{@"hs":@"0",@"services":@"",@"page":@"0",@"limit":@"20",@"sort":@"distance",@"dir":@"asc",@"pt":@"500"}
    
    switch (senderButton.tag) {
        case 1:{
            [filterDict addEntriesFromDictionary:@{@"sort":@"distance"}];
            break;
        }
        case 2:{
            [filterDict addEntriesFromDictionary:@{@"sort":@"rating"}];
            break;
        }
        case 3:{
            [filterDict addEntriesFromDictionary:@{@"sort":@"popularity"}];
            break;
        }
        case 4:{
            [filterDict addEntriesFromDictionary:@{@"sort":@"cost"}];
            break;
        }
            
        case 5:{
            [filterDict addEntriesFromDictionary:@{@"hs":@"1"}];
            break;
        }
            
        case 6:{
            [filterDict addEntriesFromDictionary:@{@"hs":@"0"}];
            break;
        }

            
        case 7:{
            [filterDict addEntriesFromDictionary:@{@"gender":@"0"}];
            break;
        }

            
        case 8:{
            [filterDict addEntriesFromDictionary:@{@"gender":@"1"}];
            break;
        
        }
            
        case 9:{
            [filterDict addEntriesFromDictionary:@{@"gender":@"2"}];
            break;
            
        }

        case 10:{
            [filterDict addEntriesFromDictionary:@{@"pt":@"500"}];
            break;
            
        }

        case 11:{
            [filterDict addEntriesFromDictionary:@{@"pt":@"1000"}];
            break;
            
        }
            
        case 12:{
            [filterDict addEntriesFromDictionary:@{@"pt":@"2000"}];
            break;
            
        }
        case 13:{
            [filterDict addEntriesFromDictionary:@{@"pt":@"20000"}];
            break;
        }
            
        default:
            break;
    }
    
    [self setFilterButtonStates];
}

-(IBAction)saveFilter:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:filterDict forKey:@"filterDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"filter dict %@",filterDict);
    
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
