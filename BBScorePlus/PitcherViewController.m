    //
    //  LineupViewController.m
    //  BBScorePlus
    //
    //  Created by Michael on 10/15/15.
    //  Copyright © 2015 Michael Usry. All rights reserved.
    //

#import "PitcherViewController.h"

@interface PitcherViewController ()
{
    NSString *playerBat;
    NSString *playerThrow;
    NSString  *dictPath;
    NSDictionary *playerInfoDict, *teamDict, *gameDict;
    NSMutableArray *myTeamDictionaryArray;
    NSDictionary *teamDictionary;
    NSDictionary *dict, *tempdict;
    NSMutableArray *firstNameArray, *lastNameArray, *playerNumberArray, *pArray;
    NSMutableArray *currentPitcherArray;
    int pitcherArrayNumber;
    NSString *fn, *ln, *pn, *pb, *pt, *pi, *fb, *sb, *tb, *hr, *fc,*fe,*hp,*sf,*rb,*ou,*bt,*st,*wa,*str,*wap,*strp,*strValue,*cb, *pc,*hc, *th, *oh;
    BOOL isPitcher;
    UISwitch *pSwitch;
    
    
}


@end

@implementation PitcherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
        // Do any additional setup after loading the view.
    editLineup = NO;
    myTeamDictionaryArray = [NSMutableArray array];
    currentPitcherArray = [NSMutableArray array];
    firstNameArray = [NSMutableArray array];
    lastNameArray = [NSMutableArray array];
    playerNumberArray = [NSMutableArray array];
    pArray = [NSMutableArray array];
    [tableView setAllowsSelection:YES];
    
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
    return [myTeamDictionaryArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    pitcherArrayNumber = (int)indexPath.row;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *lineupTableID = @"PlayerCell";
    
    PitcherTableViewCell *customCell = [tableView2 dequeueReusableCellWithIdentifier:lineupTableID];
    
    if (customCell == nil) {
        customCell = [[PitcherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lineupTableID];
    }
    
    customCell.LineUpCustomLastName.text = [lastNameArray objectAtIndex:indexPath.row];
    customCell.LineUpCustomFirstName.text = [firstNameArray objectAtIndex:indexPath.row];
    customCell.LineUpCustomPlayerNumber.text = [playerNumberArray objectAtIndex:indexPath.row];
    
    pSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    pSwitch.onTintColor = [UIColor redColor];
    customCell.accessoryView = pSwitch;
    
    [pSwitch addTarget:self action:@selector(switchChange: ) forControlEvents:UIControlEventValueChanged];
    
    if ([[currentPitcherArray objectAtIndex:indexPath.row]intValue] == 1) {
        
        [pSwitch setOn:YES];
        
    }
    
    return customCell;
}

- (void) switchChange:(id)sender {
    
    CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:switchPositionPoint];
    
    pitcherArrayNumber = (int)indexPath.row;
    NSLog(@"pitcherArrNum: %i",pitcherArrayNumber);
    
    if ([[currentPitcherArray objectAtIndex:pitcherArrayNumber]intValue] == 1) {
        NSLog(@"currentPitcher = YES");
        
        isPitcher = NO;
        
    }else{
        NSLog(@"currentPitcher = NO");
            //replace currentPitcher to true
        isPitcher = YES;
        
    }
    
    
    [self addMyPitcher];
    
    [self viewDidLoad];
}



-(IBAction)onClick:(id)sender{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    
    switch (button.tag) {
        case 0:
            NSLog(@"Done button");
                // Done
            
                //Save
            NSLog(@"Save button");
            NSLog(@"myTeamDictionaryArray: %@",myTeamDictionaryArray);
            [self saveInfo];
            [self showAlert];
            
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"PitchChartID"];
            
            [self presentViewController:vc animated:true completion:nil];
            
            
            
            break;
            
    }
}


- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Team Pitcher"
                                                    message:@"has been updated"
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
    
    myTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSLog(@"arrayofDict: %@",myTeamDictionaryArray);
    firstNameArray = [myTeamDictionaryArray valueForKey:@"firstname"];
    lastNameArray = [myTeamDictionaryArray valueForKey:@"lastname"];
    playerNumberArray = [myTeamDictionaryArray valueForKey:@"playernumber"];
    currentPitcherArray = [myTeamDictionaryArray valueForKey:@"pitcher"];
    
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
            //        [self removeFile];
        
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
        [myTeamDictionaryArray writeToFile:dictPath atomically:YES];
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

- (void)setMyTeamPitcherDictionaryArray{
    NSLog(@"loadMyTeamDictArray\nbatterPositionNumber %li",(long)pitcherArrayNumber);
        //load
    fb = [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:pitcherArrayNumber];
    sb = [[myTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:pitcherArrayNumber];
    tb = [[myTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:pitcherArrayNumber];
    hr = [[myTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:pitcherArrayNumber];
    fc = [[myTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:pitcherArrayNumber];
    fe = [[myTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:pitcherArrayNumber];
    hp = [[myTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:pitcherArrayNumber];
    sf = [[myTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:pitcherArrayNumber];
    rb = [[myTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:pitcherArrayNumber];
    ou = [[myTeamDictionaryArray valueForKey:@"out"]objectAtIndex:pitcherArrayNumber];
    bt = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:pitcherArrayNumber];
    st = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:pitcherArrayNumber];
    fn = [[myTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:pitcherArrayNumber];
    ln = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:pitcherArrayNumber];
    pn = [[myTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:pitcherArrayNumber];
    pb = [[myTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:pitcherArrayNumber];
    pt = [[myTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:pitcherArrayNumber];
    pi = [[myTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:pitcherArrayNumber];
    wap = [[myTeamDictionaryArray valueForKey:@"walkspitched"]objectAtIndex:pitcherArrayNumber];
    strp = [[myTeamDictionaryArray valueForKey:@"strikeoutspitched"]objectAtIndex:pitcherArrayNumber];
    pc = [[myTeamDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:pitcherArrayNumber];
    hc = [[myTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:pitcherArrayNumber];
    wa = [[myTeamDictionaryArray valueForKey:@"walks"]objectAtIndex:pitcherArrayNumber];
    str = [[myTeamDictionaryArray valueForKey:@"strikeouts"]objectAtIndex:pitcherArrayNumber];
    
    NSLog(@"end of loadMyTeamDictionaryArray: %@",myTeamDictionaryArray);
    
}

- (void)addMyPitcher{
    NSLog(@"addOpponentSac");
    
    [self setMyTeamPitcherDictionaryArray];
    
    NSNumber *pitch = @(isPitcher);
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pitch,@"pitcher",
                fb,@"1B",
                sb,@"2B",
                tb,@"3B",
                hr,@"HR",
                fc,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    NSLog(@"tempdict:\n%@",tempdict);
    
    [myTeamDictionaryArray replaceObjectAtIndex:pitcherArrayNumber withObject:tempdict];
    
    NSLog(@"myTeamDictionaryArray:\n%@",myTeamDictionaryArray);
    
        //saveback
    [self saveInfo];
    
}


@end
