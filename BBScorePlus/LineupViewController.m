//
//  LineupViewController.m
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import "LineupViewController.h"

@interface LineupViewController ()
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

@implementation LineupViewController


- (void)viewDidLoad {
    [tableView reloadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    editLineup = NO;
    arrayOfDictionariesMutableArray = [NSMutableArray array];
    doesFileExist = NO;
    teamDictionary = [NSDictionary dictionary];
    if ([self doesFileExist]) {
        [self LoadFromFile];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [self LoadFromFile];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfDictionariesMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *lineupTableID = @"PlayerCell";
    
    LineUpTableViewCell *customCell = [tableView2 dequeueReusableCellWithIdentifier:lineupTableID];
    
    if (customCell == nil) {
        customCell = [[LineUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lineupTableID];
    }
    
    customCell.LineUpCustomLastName.text = [lastname objectAtIndex:indexPath.row];
    customCell.LineUpCustomFirstName.text = [firstname objectAtIndex:indexPath.row];
    customCell.LineUpCustomPlayerNumber.text = [playerNumber objectAtIndex:indexPath.row];
    return customCell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) // Don't move the first row
//        return NO;
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = arrayOfDictionariesMutableArray[sourceIndexPath.row];
    [arrayOfDictionariesMutableArray removeObjectAtIndex:sourceIndexPath.row];
    [arrayOfDictionariesMutableArray insertObject:stringToMove atIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView2 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
            //deletes the row from the stringArray
        [arrayOfDictionariesMutableArray removeObjectAtIndex:indexPath.row];
        
            //delete the row from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:TRUE];
    }
}


-(IBAction)onClick:(id)sender{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;

    switch (button.tag) {
        case 0:
            NSLog(@"Edit button");
                // Edit
                    if (editLineup == NO) {
                        editLineup = YES;
                        [tableView setEditing:TRUE];
                
                    }else{
                        editLineup = NO;
                        [tableView setEditing:NO];
                    }
                
            break;
            
        case 1:
                // Save
            NSLog(@"Save button");
            NSLog(@"arrayOfDictionariesMutableArray: %@",arrayOfDictionariesMutableArray);
            [self saveInfo];
            [self showAlert];
            [tableView setEditing:NO];

            break;
            
        default:
            break;
    }
}

- (void)showAlert {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Team Roster"
    message:@"Saved"
    delegate:self
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil];
    [alert show];

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

-(void)saveInfo{
        //PUT PLAYER INFO INTO OBJECT
    if ([self doesFileExist]) {
        NSLog(@"fileExist");
        
            //load file
        [self removeFile];
        
    }
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"teamdictionary.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [arrayOfDictionariesMutableArray writeToFile:dictPath atomically:YES];
    }
    
}

- (void)removeFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"teamdictionary.out"];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"File removed");
    }
    else
    {
        NSLog(@"Could not remove file");
    }
}


@end
