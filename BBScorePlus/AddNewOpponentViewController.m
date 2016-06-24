//
//  AddNewOpponentViewController.m
//  BBScorePlus
//
//  Created by Michael on 11/1/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import "AddNewOpponentViewController.h"

@interface AddNewOpponentViewController ()
{
    NSString *playerBat;
    NSString *playerThrow;
    NSString  *dictPath;
    NSDictionary *playerInfoDict, *teamDict, *gameDict;
    NSMutableArray *arrayOfDictionariesMutableArray;
    NSDictionary *dict;
    BOOL isPitcherSet;
    CGFloat screenWidth;
}


@end

@implementation AddNewOpponentViewController
@synthesize batsSegmentControl, throwsSegmentControl,firstName,lastName,playerNumber;
@synthesize btnDone,inputAccView;

- (void)getScreenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    _myScrollView.bounces = NO;
    _myScrollView.alwaysBounceVertical = YES;
    [_isPitcherSwitch setOn:NO animated:NO];
    playerBat = @"R";
    playerThrow = @"R";
    doesFileExist = NO;
    
    dict = [NSDictionary dictionary];
    arrayOfDictionariesMutableArray = [NSMutableArray array];
    
    if ([self doesFileExist]) {
        [self LoadFromFile];
    }
    [self getScreenSize];

    [self createInputAccessoryView];
    [playerNumber setInputAccessoryView:inputAccView];
    
//    playerNumber.delegate.self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
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

- (IBAction)goBack:(id)sender{
    UIBarItem *but = (UIBarItem*)sender;
    
    switch (but.tag) {
        case 0:
            NSLog(@"Done Button");
            [self performSegueWithIdentifier:@"AddOpponentSegue" sender:@2];
            
            
        default:
            NSLog(@"default");
            
            break;
    }
}

- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
            
            NSLog(@"Add another");
            
            [self addToTeamDictionary];
            
            firstName.text = @"";
            lastName.text = @"";
            playerNumber.text = @"";
            playerBat = @"";
            playerThrow = @"";
            [_isPitcherSwitch setOn:NO animated:NO];
            [batsSegmentControl setSelectedSegmentIndex:0];
            [throwsSegmentControl setSelectedSegmentIndex:0];
            [firstName becomeFirstResponder];

            NSLog(@"add Complete");
            
            break;
            
        case 1:
            
            NSLog(@"Save");
            [self addToTeamDictionary];
            [self saveInfo];
            [self showAlert:@"Roster" msg:@"has been saved."];

            break;
            
        default:
            NSLog(@"default");
            
            break;
            
    }
}

- (IBAction)onSwitch:(id)sender {
    if (_isPitcherSwitch.on) {
        if (isPitcherSet) {
            
            [self showAlert:@"The pitcher" msg:@"has already been set."];
            isPitcher = NO;
            [_isPitcherSwitch setOn:NO animated:NO];
            
            
        }else{
            isPitcher = YES;
            isPitcherSet = YES;
            NSLog(@"pitch yes");
        }
    }else{
        isPitcher= NO;
        NSLog(@"pitch no");
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

- (void)addToTeamDictionary {
    
        //dictionary #1
    NSNumber *pitch = @(isPitcher);
    NSString *junk = @"0";
    NSArray *j1 = [NSArray array];
    
    NSString *fn = firstName.text;
    NSString *ln = lastName.text;
    NSString *pn = playerNumber.text;

    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            fn,@"firstname",
            ln,@"lastname",
            pn,@"playernumber",
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
            junk,@"walks",
            junk,@"strikeouts",
            junk,@"walkspitched",
            junk,@"strikeoutspitched",
            j1,@"hittinghchart",
            j1,@"pitchingchart",
            nil];
    
    if (fn && ln && pn && playerBat && playerThrow != nil) {
        NSLog(@"nothing empty.  adding to array");
        [arrayOfDictionariesMutableArray addObject:dict];
        
    }
    
    NSLog(@"arrayOfDictionariesMutableArray: %@",arrayOfDictionariesMutableArray);
    NSLog(@"array count: %lu",(unsigned long)[arrayOfDictionariesMutableArray count]);
    
    isPitcher = NO;
    
}

-(void)saveInfo{
        //PUT PLAYER INFO INTO OBJECT
    if ([self doesFileExist]) {
        NSLog(@"fileExist");
        
        
    }
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
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
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    arrayOfDictionariesMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
}

- (BOOL)doesFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    return NO;
}

- (void)removeFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"opponentteamdictionary.out"];
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

-(void)createInputAccessoryView{
        // Extra view for the done button to dismiss the keyboard
    
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, screenWidth, 25)];
    
    [inputAccView setBackgroundColor:[UIColor darkGrayColor]];
    
    [inputAccView setAlpha: 0.6];
    
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(screenWidth-80, 0.0f, 80.0f, 25)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor darkTextColor]];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone setAlpha:0.7];
    [btnDone addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
        // Now that our buttons are ready we just have to add them to our view.
    [inputAccView addSubview:btnDone];
}

- (IBAction)dismiss:(id)sender
{
    // dismiss the KB
    
    NSLog(@"dismiss KB");
    [self.view endEditing:YES];
    
}

@end