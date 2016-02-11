//
//  LoadSavedTeamsViewController.m
//  BBScorePlus
//
//  Created by Michael on 2/10/16.
//  Copyright © 2016 Michael Usry. All rights reserved.
//

#import "LoadSavedTeamsViewController.h"

@interface LoadSavedTeamsViewController ()
{
    NSString *opponentTeamName, *origFileName, *newFileName;
    NSArray *filePathsArray;
    int teamSelected;
    IBOutlet UITableView *tableView;
}

@end

@implementation LoadSavedTeamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self GetTeamSaveDirectory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [filePathsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *lineupTableID = @"cellid";

    LoadSavedTeamsTableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:lineupTableID];
    
    if (cell == nil) {
        cell = [[LoadSavedTeamsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lineupTableID];
    }

        cell.savedTeamLabel.text = [filePathsArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    teamSelected = (int)indexPath.row;
    NSLog(@"teamSelected: %i",teamSelected);
    [self renameSavFile];

    
    
}

- (void)GetTeamSaveDirectory{
        //Get dir of .sav
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory
                                                     error:nil];
        //--- Listing file by name sort
    NSLog(@"\n File list %@",fileList);
    
        //---- Sorting files by extension
    filePathsArray =
    [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory
                                                        error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF EndsWith '.sav'"];
    filePathsArray =  [filePathsArray filteredArrayUsingPredicate:predicate];
    NSLog(@"\n\n Sorted files by extension %@",filePathsArray);
    
}

- (void)LoadGameDefaults{
    NSLog(@"***********LoadGameDefaultsFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamedefaults.out"];
    if (filePath != nil) {
        NSDictionary *load = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        opponentTeamName = [load valueForKey:@"opponentteamname"];
        
        NSLog(@"pause");
    }else{
        NSLog(@"No file.");
    }
}

- (void)renameSavFile{
    NSString *temp = [filePathsArray objectAtIndex:teamSelected];
    
    origFileName = [temp substringToIndex:(temp.length -4)];
    NSString *opponentTeamOut = @"opponentteamdictionary.out";
    
    NSLog(@"origFileName: %@",origFileName);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *actualFilePath = [documentsDirectory stringByAppendingPathComponent:temp];
    NSString *copyFilePath = [documentsDirectory stringByAppendingPathComponent:opponentTeamOut];
    NSError *error;
    if ([fileManager copyItemAtPath:actualFilePath toPath:copyFilePath error:&error]){
        NSLog(@"Copy Success");
        
        [self showAlert];
    }
    else{
        NSLog(@"Copy error: %@", error);
    }
}

- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opponent"
                                                    message:@"Loaded"
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

@end
