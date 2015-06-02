//
//  FilterDetailViewController.m
//  spalor
//
//  Created by Manish on 21/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FilterDetailViewController.h"
#import "UIColor+flat.h"
#import "ServiceCategory.h"
#import "Service.h"
#import "SuggestedTableViewCell.h"

@interface FilterDetailViewController (){
    ServiceCategory *selectedCategory;
    NSMutableDictionary *selectedServicesDictionary;
    NSMutableString *selectedServiceids;
    NSMutableArray *servicesArray;
    NSArray *filteredServicesArray;
}

@end

@implementation FilterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedServicesDictionary = [NSMutableDictionary new];
    [self setAutoSuggestHidden:YES];
    selectedServiceids = [[NSMutableString alloc] initWithString:@""];
}

-(void)setAutoSuggestHidden:(BOOL)hidden{
    self.overlayView.hidden = hidden;
    self.autoSuggestTableView.hidden = hidden;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSMutableDictionary *filterDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"];
    [selectedServiceids appendFormat:filterDict[@"services"]];
    
    [self setAllCategories];
    [self hideSelectedServicesView];
}


-(void)setAllCategories{
    
    int index = 0;
    int lastX = 10;
    NSArray *selectedServiceIdsArray = [selectedServiceids componentsSeparatedByString:@","];
    servicesArray = [NSMutableArray new];
    filteredServicesArray = [NSArray new];
    for (ServiceCategory *category in self.arrayOfCategories) {
        
        NSLog(@"category name %@ id %@",category.name,category.categoryId);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:(category.name)?category.name:@"BLANK" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category-%@.png",category.categoryId]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category-%@active.png",category.categoryId]] forState:UIControlStateSelected];

        button.frame = CGRectMake(lastX+button.frame.size.width+10,self.allCategoriesScrollView.bounds.origin.y,50,52);
        lastX += button.frame.size.width + 20;
        button.tag = category.categoryId.intValue;
        [button addTarget:self action:@selector(changeSelectedCategory:) forControlEvents:UIControlEventTouchUpInside];
        self.allCategoriesScrollView.contentSize = CGSizeMake(lastX+button.frame.size.width+10, self.allCategoriesScrollView.contentSize.height);
        [self.allCategoriesScrollView addSubview:button];
        
        int serviceIndex = 0;
        for (Service *service in category.services) {
            
            [servicesArray addObject:service];
            
            if ([selectedServiceIdsArray containsObject:service.serviceId]) {
                int tag = service.serviceId.integerValue;
                NSLog(@"putting %@ as selected for category %d",service.name,index);
                
                [self createandAddServiceButtonforServiceName:tag andIndex:serviceIndex fromCategory:category];
            }
            
            serviceIndex++;
        }
        index++;

    }
    
    [self changeSelectedCategory:[self.allCategoriesScrollView viewWithTag:1]];

}

-(void)changeSelectedCategory:(UIButton *)button{
    
    
    for (ServiceCategory *category in self.arrayOfCategories) {
        if (category.categoryId.intValue == button.tag) {
            selectedCategory = category;
        }
    }
    
    for (UIButton *button in self.allCategoriesScrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = (button.tag == selectedCategory.categoryId.intValue)?YES:NO;
        }
    }
    
    [self.tableview reloadData];

}


-(void)hideSelectedServicesView{
    if(selectedServicesDictionary.count == 0){
        //Move everything up and hide selected services view
        if(!self.selectedServicesScrollView.hidden){
            self.selectedServicesScrollView.hidden = YES;
            self.tableview.frame = CGRectMake(0, self.tableview.frame.origin.y-self.selectedServicesScrollView.frame.size.height, self.tableview.frame.size.width, self.tableview.frame.size.height);
            self.allCategoriesView.frame = CGRectMake(0, self.allCategoriesView.frame.origin.y-self.selectedServicesScrollView.frame.size.height, self.allCategoriesView.frame.size.width, self.allCategoriesView.frame.size.height);

        }
        
    }
    else{
        if(self.selectedServicesScrollView.hidden){
            self.selectedServicesScrollView.hidden = NO;
            self.tableview.frame = CGRectMake(0, self.tableview.frame.origin.y+self.selectedServicesScrollView.frame.size.height, self.tableview.frame.size.width, self.tableview.frame.size.height);
            self.allCategoriesView.frame = CGRectMake(0, self.allCategoriesView.frame.origin.y+self.selectedServicesScrollView.frame.size.height, self.allCategoriesView.frame.size.width, self.allCategoriesView.frame.size.height);
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)save:(id)sender{
    NSMutableDictionary *filterDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"]];
    [filterDict addEntriesFromDictionary:@{@"services":selectedServiceids}];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:filterDict forKey:@"filterDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];


}

-(IBAction)selectCategory:(UIButton *)sender{
    [self changeSelectedCategory:sender];
}

#pragma mark - Table View
#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.autoSuggestTableView]) {
        return filteredServicesArray.count;
    }
    NSLog(@"category %@ %d",selectedCategory.name,selectedCategory.services.count);
    NSInteger numOfRows = selectedCategory.services.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.autoSuggestTableView]) {
        return 44;
    }
    return 62;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.autoSuggestTableView]) {
        NSString *identifier =  @"suggestedCellIdentifier";

        SuggestedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        Service *service = filteredServicesArray[indexPath.row];

        cell.searchLabel.text = service.name;
        return cell;
    }
    
    NSString *identifier =  @"servicesCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    ServiceCategory *category = selectedCategory;
    Service *service = category.services[indexPath.row];
    if (![service.name isKindOfClass:[NSNull class]]) {
        cell.textLabel.text = [service.name capitalizedString];
    }
    else{
        cell.textLabel.text = @"Null Data From Server";
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13.0];

    cell.tag = service.serviceId.integerValue;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Put in selected service view
    
    if ([tableView isEqual:self.autoSuggestTableView]) {
        NSString *identifier =  @"suggestedCellIdentifier";
        
        SuggestedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        Service *selectedservice = filteredServicesArray[indexPath.row];
        [self addAsSelectedService:selectedservice];
        [self hideFilter:nil];

    }
    else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray *serviceTags = [selectedServicesDictionary allKeys];
        [self createandAddServiceButtonforServiceName:cell.tag andIndexPath:indexPath];
    }
    
    
    
}

-(void)createandAddServiceButtonforServiceName:(NSInteger)serviceTag andIndexPath:(NSIndexPath *)indexPath{
    
    [self createandAddServiceButtonforServiceName:serviceTag andIndex:indexPath.row fromCategory:selectedCategory];

}

-(void)createandAddServiceButtonforServiceName:(NSInteger)serviceTag andIndex:(int)index fromCategory:(ServiceCategory *)category{
    
    Service *service = category.services[index];
    
    
    [self addAsSelectedService:service];


}

-(void)addAsSelectedService:(Service *)service{
    if ([service.name isKindOfClass:[NSNull class]]) {
        return;
    }
    
    int currentTotalButtons = [self numberOfbuttonsinScrollView:self.selectedServicesScrollView];
    
    [selectedServicesDictionary addEntriesFromDictionary:@{[@(service.serviceId.intValue) stringValue]:@(currentTotalButtons)}];
    
    [self hideSelectedServicesView];
    
    
    if ([selectedServiceids rangeOfString:service.serviceId].location==NSNotFound) {
        if (selectedServiceids.length == 0) {
            [selectedServiceids appendFormat:service.serviceId];
            
        }
        else
            [selectedServiceids appendFormat:[NSString stringWithFormat:@",%@",service.serviceId]];
        
    }
    

    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceButton setTitle:[NSString stringWithFormat:@"   %@   X   ",service.name] forState:UIControlStateNormal];
    
    serviceButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next Demi Bold" size:12.0f];
    serviceButton.layer.borderWidth = 3.0f;
    [serviceButton.layer setBorderColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.png"]].CGColor];
    [serviceButton sizeToFit];
    serviceButton.titleLabel.textColor = [UIColor colorWithHexCode:@"45B09E"];
    
    if(currentTotalButtons == 0){
        
        CGRect newFrame = serviceButton.frame;
        newFrame.origin.x = 20;
        newFrame.origin.y = self.selectedServicesScrollView.bounds.origin.y+20;
        //newFrame.size.width += 20;
        serviceButton.frame = newFrame;
        
    }
    else{
        UIButton *lastButton = [self buttonWithHighestTaginScrollView:self.selectedServicesScrollView];
        
        CGRect frame = lastButton.frame;
        
        CGRect newFrame = serviceButton.frame;
        
        newFrame.origin.x = frame.origin.x+frame.size.width+20;
        
        newFrame.origin.y = self.selectedServicesScrollView.bounds.origin.y+20;
        
        //newFrame.size.width += 20;
        
        serviceButton.frame = newFrame;
    }
    
    serviceButton.tag = currentTotalButtons;
    
    [serviceButton addTarget:self action:@selector(removeThisService:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.selectedServicesScrollView addSubview:serviceButton];
    
    [self.selectedServicesScrollView setContentOffset:CGPointMake(serviceButton.frame.origin.x+serviceButton.frame.size.width+10, 0)];
    
    self.selectedServicesScrollView.contentSize = CGSizeMake(serviceButton.frame.origin.x+serviceButton.frame.size.width+10, self.selectedServicesScrollView.contentSize.height);

}


-(void)removeThisService:(UIButton *)sender{
    
    NSInteger touchedButtonTag = sender.tag;
    
    //First hide it
    sender.hidden = YES;
    
    //Reset the entire scrollview beyond this button
    for (UIView *subview in [self.selectedServicesScrollView subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            if(subview.tag > touchedButtonTag){
                UIButton *buttonToMove = (UIButton *)subview;
                CGRect newFrame = buttonToMove.frame;
                newFrame.origin.x -= sender.frame.size.width;
                newFrame.origin.x -= 20;
                buttonToMove.frame = newFrame;
            }
        }
    }
    
    NSArray *allKeys = selectedServicesDictionary.allKeys;
    
    NSString *keyToRemove = nil;
    
    selectedServiceids = [NSMutableString stringWithString:@""];
    for(NSString *serviceHashKey in allKeys){
        if([selectedServicesDictionary[serviceHashKey] isEqualToNumber:@(touchedButtonTag)]){
            keyToRemove = serviceHashKey;
        }
        else{
            if ([selectedServiceids rangeOfString:serviceHashKey].location==NSNotFound) {
                if (selectedServiceids.length == 0) {
                    [selectedServiceids appendFormat:serviceHashKey];
                    
                }
                else
                    [selectedServiceids appendFormat:[NSString stringWithFormat:@",%@",serviceHashKey]];
                
            }

        }
    }
    
    if(keyToRemove)
        [selectedServicesDictionary removeObjectForKey:keyToRemove];
    
    
    //Finally remove from superview
    [sender removeFromSuperview];
    
    UIButton *lastButton = [self buttonWithHighestTaginScrollView:self.selectedServicesScrollView];
    
    self.selectedServicesScrollView.contentSize = CGSizeMake(lastButton.frame.origin.x+lastButton.frame.size.width, self.selectedServicesScrollView.contentSize.height);
    //CGPoint bottomOffset = CGPointMake( self.selectedServicesScrollView.contentSize.width - self.selectedServicesScrollView.bounds.size.width,0);
    //[self.selectedServicesScrollView setContentOffset:bottomOffset animated:YES];

    [self hideSelectedServicesView];

}

-(int)numberOfbuttonsinScrollView:(UIScrollView *)scrollView{
    int count = 0;
    for (UIView *subview in [scrollView subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            count++;
        }
    }
    
    return count;
}


-(UIButton *)buttonWithHighestTaginScrollView:(UIScrollView *)scrollView{
    
    int tag = -2;
    for (UIView *subview in [scrollView subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            if(subview.tag > tag){
                tag = subview.tag;
            }
        }
    }
    
    return [scrollView viewWithTag:tag];
}



#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length>0) {
        [self setAutoSuggestHidden:NO];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", newString];
        filteredServicesArray = [servicesArray filteredArrayUsingPredicate:predicate];
        [self.autoSuggestTableView reloadData];

    }
    else{
        [self setAutoSuggestHidden:NO];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.text = @"";
    [textField resignFirstResponder];
    [self setAutoSuggestHidden:YES];
    return YES;
}


-(IBAction)hideFilter:(id)sender{
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = @"";
    [self setAutoSuggestHidden:YES];
}

- (IBAction)filterSearchTextField:(id)sender {
}
@end
