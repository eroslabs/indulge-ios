//
//  FilterDetailViewController.m
//  spalor
//
//  Created by Manish on 21/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FilterDetailViewController.h"
#import "UIColor+flat.h"

@interface FilterDetailViewController (){
    int selectedCategory;
    NSMutableArray *selectedServicesArray;
}

@end

@implementation FilterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedServicesArray = [NSMutableArray new];
    [self hideSelectedServicesView];
}

-(void)hideSelectedServicesView{
    if(selectedServicesArray.count == 0){
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

-(IBAction)selectCategory:(UIButton *)sender{
    selectedCategory = sender.tag;
    [self.tableview reloadData];
}

#pragma mark - Table View
#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = selectedCategory * 5;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =  @"servicesCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [NSString stringWithFormat:@"service %d",selectedCategory*10+indexPath.row+1];
    cell.tag = selectedCategory*10+indexPath.row+1;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Put in selected service view
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self createandAddServiceButtonforServiceName:cell.tag];
    
}

-(void)createandAddServiceButtonforServiceName:(NSInteger)serviceTag{
    
    if([selectedServicesArray containsObject:@(serviceTag)]){
        return;
    }
    
    [selectedServicesArray addObject:@(serviceTag)];
    
    [self hideSelectedServicesView];
    
    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceButton setTitle:[NSString stringWithFormat:@"Service %d X",serviceTag] forState:UIControlStateNormal];
    serviceButton.layer.borderWidth = 3.0f;
    [serviceButton.layer setBorderColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"border.png"]].CGColor];
    [serviceButton sizeToFit];
    serviceButton.titleLabel.textColor = [UIColor colorWithHexCode:@"45B09E"];
    int currentTotalButtons = [self numberOfbuttonsinScrollView:self.selectedServicesScrollView];
    
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
    
    serviceButton.tag = serviceTag;
    
    [serviceButton addTarget:self action:@selector(removeThisService:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.selectedServicesScrollView addSubview:serviceButton];
    
    self.selectedServicesScrollView.contentSize = CGSizeMake(serviceButton.frame.origin.x+serviceButton.frame.size.width, self.selectedServicesScrollView.contentSize.height);



    //[self.selectedServicesScrollView scrollRectToVisible:serviceButton.frame animated:YES];
    //CGPoint bottomOffset = CGPointMake( self.selectedServicesScrollView.contentSize.width - self.selectedServicesScrollView.bounds.size.width,0);
    //[self.selectedServicesScrollView setContentOffset:bottomOffset animated:YES];

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
    
    [selectedServicesArray removeObject:@(sender.tag)];
    
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



@end
