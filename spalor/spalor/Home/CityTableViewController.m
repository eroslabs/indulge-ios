//
//  CityTableViewController.m
//  spalor
//
//  Created by Manish on 25/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "CityTableViewController.h"
#import "NetworkHelper.h"

@interface CityTableViewController (){
    NSMutableArray *data;
}

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    data = [NSMutableArray new];

    [data addObject:@{@"stateName":@"Current Location",@"status":@(1)}];
    
    [self.tableView reloadData];
    
    [self fillCityList];
}

-(void)fillCityList{

    NSData *encodedStateList = [[NSUserDefaults standardUserDefaults] objectForKey:STATELIST];
    NSArray *stateList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedStateList];
    if(stateList.count>0){
        [data addObjectsFromArray:stateList];
        [self.tableView reloadData];
    }
    else{
        [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/loadStates" withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error) {
            if (!error) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                
                DLog(@"response string %@",responseDict);
                
                for(NSDictionary *stateObj in responseDict[@"states"]){
                    if([[stateObj objectForKey:@"status"] isEqual:@(1)]){
                        NSArray *citiesArray = stateObj[@"cities"];
                        if (citiesArray.count>0) {
                            for (NSDictionary *cityObj in citiesArray) {
                                if ([cityObj[@"status"] isEqual:@(1)]) {
                                    [data addObject:cityObj];
//                                    cityName
//                                    lat
//                                    lng
//                                    status
                                }
                            }
                        }
                    }
                }
                
                if(data.count>0){
                    NSData *encodedStateList = [NSKeyedArchiver archivedDataWithRootObject:data];
                    [[NSUserDefaults standardUserDefaults] setObject:encodedStateList forKey:STATELIST];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        
                    });
                }
                
            }
            //return data;
            
        }];
    }
    
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [data[indexPath.row] objectForKey:@"cityName"];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Push the view controller.
    NSDictionary *cityObj = [data objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"citySelected" object:nil userInfo:@{@"city":cityObj}];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
