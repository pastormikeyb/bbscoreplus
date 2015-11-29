    //
    //  AddNewPlayerViewController.m
    //  BBScorePlus
    //
    //  Created by Michael on 10/22/15.
    //  Copyright © 2015 Michael Usry. All rights reserved.
    //

#import "AddNewPlayerViewController.h"

@interface AddNewPlayerViewController ()
{
    NSString *playerBat;
    NSString *playerThrow;
    NSString  *dictPath;
    NSDictionary *playerInfoDict, *teamDict, *gameDict;
    NSMutableArray *arrayOfDictionariesMutableArray;
    NSDictionary *teamDictionary;
    NSDictionary *dict;
    
}


@end

@implementation AddNewPlayerViewController
@synthesize batsSegmentControl, throwsSegmentControl;

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    _myScrollView.bounces = NO;
    _myScrollView.alwaysBounceVertical = YES;
    playerBat = @"R";
    playerThrow = @"R";
    doesFileExist = NO;
    teamDictionary = [NSDictionary dictionary];
    arrayOfDictionariesMutableArray = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
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

- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
            
            NSLog(@"Add another");
            
                //            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            [self addToTeamDictionary];
        
            _firstName.text = @"";
            _lastName.text = @"";
            _playerNumber.text = @"";
            playerBat = @"";
            playerThrow = @"";
            [_isPitcherSwitch setOn:NO animated:YES];
            [batsSegmentControl setSelectedSegmentIndex:0];
            [throwsSegmentControl setSelectedSegmentIndex:0];
            [_firstName becomeFirstResponder];

            NSLog(@"clear complete");
            
            break;
            
        case 1:
            
            NSLog(@"Save and Done");
            [self addToTeamDictionary];
            [self saveInfo];
            
            break;
            
        case 2:
            [self LoadFromFile];
            
        default:
            NSLog(@"default");
            
            break;
            
    }
}

- (IBAction)segmentedControlAction:(id)sender{
    if(batsSegmentControl.selectedSegmentIndex == 0)
            // Checking which segment is selected using the segment index value
        
    {
        
        NSLog(@"Bats Right");
        playerBat = @"R";
    }
    
    else
        
        if(batsSegmentControl.selectedSegmentIndex == 1)
            
        {
            
            NSLog(@"Bats Left");
            playerBat = @"L";
            
        }
    
        else
            
            if(batsSegmentControl.selectedSegmentIndex == 2)
                
            {
                
                NSLog(@"Bats Switch");
                playerBat = @"S";
                
            }
    
    if (throwsSegmentControl.selectedSegmentIndex == 0) {
        NSLog(@"Throws Switch Right");
        playerThrow = @"R";
        
    }else if (throwsSegmentControl.selectedSegmentIndex == 1){
        NSLog(@"Throws Switch Left");
        playerThrow = @"L";
        
    }
}

- (IBAction)onSwitch:(id)sender {
    if (_isPitcherSwitch.on) {
        isPitcher = YES;
        NSLog(@"pitch yes");
    }else{
         isPitcher= NO;
        NSLog(@"pitch no");
    }
}

- (void)addToTeamDictionary {
    
    NSNumber *pitch = @(isPitcher);
    NSString *junk = @"0";
    NSMutableArray *ma = [NSMutableArray arrayWithObjects:@"0", @"0", nil];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            _firstName.text,@"firstname",
            _lastName.text,@"lastname",
            _playerNumber.text,@"playernumber",
            playerBat,@"playerbat",
            playerThrow,@"playerthrow",
            pitch,@"pitcher",
            junk,@"1B",
            junk,@"2B",
            junk,@"3B",
            junk,@"HR",
            junk,@"fielderschoice",
            junk,@"fieldingerror",
            junk,@"hitbypitch",
            junk,@"sacfly",
            junk,@"RBI",
            junk,@"out",
            junk,@"ballspitched",
            junk,@"strikesthrown",
            ma,@"hittingchart",
            ma,@"pitchingchart",
            junk,@"myteambattingpositionnumber",
            junk,@"opponentbattingpositionnumber",
            nil];
    
    [arrayOfDictionariesMutableArray addObject:dict];
    
    NSLog(@"arrayOfDictionariesMutableArray: %@",arrayOfDictionariesMutableArray);
    NSLog(@"array count: %lu",(unsigned long)[arrayOfDictionariesMutableArray count]);


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

-(void)LoadFromFile{
    NSLog(@"LoadFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];

    arrayOfDictionariesMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSArray *firstname = [arrayOfDictionariesMutableArray valueForKey:@"firstname"];
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
