//
//  TeamRosterViewController.m
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import "TeamRosterViewController.h"

@interface TeamRosterViewController ()
{
    NSString *playerBat;
    NSString *playerThrow;
    NSString  *dictPath;
    NSDictionary *playerInfoDict, *teamDict, *gameDict;
    NSMutableArray *arrayOfDictionariesMutableArray;
    NSDictionary *teamDictionary;
    NSDictionary *dict;
    NSArray *firstname, *lastname, *playerNumber;
    
}

@end

@implementation TeamRosterViewController

- (void)viewDidLoad {
    [_tableView reloadData];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayOfDictionariesMutableArray = [NSMutableArray array];
    doesFileExist = NO;
    teamDictionary = [NSDictionary dictionary];
    if ([self doesFileExist]) {
        [self LoadFromFile];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self LoadFromFile];
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (arrayOfDictionariesMutableArray.count < 1) {
        return 0;
    }else{
    return [arrayOfDictionariesMutableArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *lineupTableID = @"TeamRosterID";
    
    TeamRosterTableViewCell *customCell = [tableView2 dequeueReusableCellWithIdentifier:lineupTableID];
    
    if (customCell == nil) {
        customCell = [[TeamRosterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lineupTableID];
    }
    
    customCell.LineUpCustomLastName.text = [lastname objectAtIndex:indexPath.row];
    customCell.LineUpCustomFirstName.text = [firstname objectAtIndex:indexPath.row];
    customCell.LineUpCustomPlayerNumber.text = [playerNumber objectAtIndex:indexPath.row];
    
//    cell.textLabel.text = [lastname valueForKey:@"firstname"];

    return customCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)LoadFromFile{
    NSLog(@"LoadFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    arrayOfDictionariesMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    firstname = [arrayOfDictionariesMutableArray valueForKey:@"firstname"];
    lastname = [arrayOfDictionariesMutableArray valueForKey:@"lastname"];
    playerNumber = [arrayOfDictionariesMutableArray valueForKey:@"playernumber"];

    NSLog(@"firstname: %@",firstname);
}

- (BOOL)doesFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    NSLog(@"File Does not Exist");
    return NO;
    
}

@end
