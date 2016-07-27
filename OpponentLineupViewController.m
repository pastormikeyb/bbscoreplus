//
//  OpponentLineupViewController.m
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import "OpponentLineupViewController.h"

@interface OpponentLineupViewController ()
{
    NSString *playerBat;
    NSString *playerThrow;
    NSString  *dictPath;
    NSDictionary *playerInfoDict, *teamDict, *gameDict;
    NSMutableArray *opponentDictionaryArray;
    NSDictionary *opponentTeamDictionary;
    NSDictionary *dict,*tempdict;
    NSArray *firstname, *lastname, *playerNumber;
    NSMutableArray *currentPitcherArray, *opponentTeam;
    NSMutableArray *firstNameArray, *lastNameArray, *playerNumberArray, *pArray;
    int pitcherArrayNumber;
    NSString *fn, *ln, *pn, *pb, *pt, *pi, *fb, *sb, *tb, *hr, *fc,*fe,*hp,*sf,*rb,*ou,*bt,*st,*wa,*str,*wap,*strp,*strValue,*cb, *pc,*hc, *th, *oh;
    BOOL isPitcher;
    UISwitch *pSwitch;

    
}

@end

@implementation OpponentLineupViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];

    // Do any additional setup after loading the view.
    editLineup = NO;
    opponentDictionaryArray = [NSMutableArray array];
    doesFileExist = NO;
    opponentTeamDictionary = [NSDictionary dictionary];
    currentPitcherArray = [NSMutableArray array];
    firstNameArray = [NSMutableArray array];
    lastNameArray = [NSMutableArray array];
    playerNumberArray = [NSMutableArray array];
    pArray = [NSMutableArray array];
    [tableView setAllowsSelection:YES];

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
    return [opponentDictionaryArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    pitcherArrayNumber = (int)indexPath.row;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *lineupTableID = @"OpponentLineupCell";
    
    OpponentLineupTableViewCell *customCell2 = [tableView2 dequeueReusableCellWithIdentifier:lineupTableID];
    
    if (customCell2 == nil) {
        customCell2 = [[OpponentLineupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lineupTableID];
    }
    
    customCell2.OpponentLineUpCustomLastName.text = [lastname objectAtIndex:indexPath.row];
    customCell2.OpponentLineUpCustomFirstName.text = [firstname objectAtIndex:indexPath.row];
    customCell2.OpponentLineUpCustomPlayerNumber.text = [playerNumber objectAtIndex:indexPath.row];
    
    pSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    pSwitch.onTintColor = [UIColor redColor];
    customCell2.accessoryView = pSwitch;
    
    [pSwitch addTarget:self action:@selector(switchChange: ) forControlEvents:UIControlEventValueChanged];
    
    if ([[currentPitcherArray objectAtIndex:indexPath.row]intValue] == 1) {
        
        [pSwitch setOn:YES];
        
    }

    
    return customCell2;
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
    NSString *stringToMove = opponentDictionaryArray[sourceIndexPath.row];
    [opponentDictionaryArray removeObjectAtIndex:sourceIndexPath.row];
    [opponentDictionaryArray insertObject:stringToMove atIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView2 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
            //deletes the row from the stringArray
        [opponentDictionaryArray removeObjectAtIndex:indexPath.row];
        
            //delete the row from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:TRUE];
        
        [self saveInfo];
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
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    opponentDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    if (opponentDictionaryArray.count >0) {
        firstname = [opponentDictionaryArray valueForKey:@"firstname"];
        lastname = [opponentDictionaryArray valueForKey:@"lastname"];
        playerNumber = [opponentDictionaryArray valueForKey:@"playernumber"];
        currentPitcherArray = [opponentDictionaryArray valueForKey:@"pitcher"];

    }else{
        [self removeFile];
    }

    
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
    NSLog(@"File Does not Exist");
    return NO;
    
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
        [opponentDictionaryArray writeToFile:dictPath atomically:YES];

    }
    
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

- (void)setOpponentPitcherDictionaryArray{
    NSLog(@"loadMyTeamDictArray\nbatterPositionNumber %li",(long)pitcherArrayNumber);
        //load
    fb = [[opponentDictionaryArray valueForKey:@"1B"]objectAtIndex:pitcherArrayNumber];
    sb = [[opponentDictionaryArray valueForKey:@"2B"]objectAtIndex:pitcherArrayNumber];
    tb = [[opponentDictionaryArray valueForKey:@"3B"]objectAtIndex:pitcherArrayNumber];
    hr = [[opponentDictionaryArray valueForKey:@"HR"]objectAtIndex:pitcherArrayNumber];
    fc = [[opponentDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:pitcherArrayNumber];
    fe = [[opponentDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:pitcherArrayNumber];
    hp = [[opponentDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:pitcherArrayNumber];
    sf = [[opponentDictionaryArray valueForKey:@"sacfly"]objectAtIndex:pitcherArrayNumber];
    rb = [[opponentDictionaryArray valueForKey:@"RBI"]objectAtIndex:pitcherArrayNumber];
    ou = [[opponentDictionaryArray valueForKey:@"out"]objectAtIndex:pitcherArrayNumber];
    bt = [[opponentDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:pitcherArrayNumber];
    st = [[opponentDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:pitcherArrayNumber];
    fn = [[opponentDictionaryArray valueForKey:@"firstname"]objectAtIndex:pitcherArrayNumber];
    ln = [[opponentDictionaryArray valueForKey:@"lastname"]objectAtIndex:pitcherArrayNumber];
    pn = [[opponentDictionaryArray valueForKey:@"playernumber"]objectAtIndex:pitcherArrayNumber];
    pb = [[opponentDictionaryArray valueForKey:@"playerbat"]objectAtIndex:pitcherArrayNumber];
    pt = [[opponentDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:pitcherArrayNumber];
    pi = [[opponentDictionaryArray valueForKey:@"pitcher"]objectAtIndex:pitcherArrayNumber];
    wap = [[opponentDictionaryArray valueForKey:@"walkspitched"]objectAtIndex:pitcherArrayNumber];
    strp = [[opponentDictionaryArray valueForKey:@"strikeoutspitched"]objectAtIndex:pitcherArrayNumber];
    pc = [[opponentDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:pitcherArrayNumber];
    hc = [[opponentDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:pitcherArrayNumber];
    wa = [[opponentDictionaryArray valueForKey:@"walks"]objectAtIndex:pitcherArrayNumber];
    str = [[opponentDictionaryArray valueForKey:@"strikeouts"]objectAtIndex:pitcherArrayNumber];
    
    NSLog(@"end of loadMyTeamDictionaryArray: %@",opponentDictionaryArray);
    
}

- (void)addMyPitcher{
    NSLog(@"addOpponentSac");
    
    [self setOpponentPitcherDictionaryArray];
    
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
    
    [opponentDictionaryArray replaceObjectAtIndex:pitcherArrayNumber withObject:tempdict];
    
    NSLog(@"opponentDictArray:\n%@",opponentDictionaryArray);
    
        //saveback
    [self saveInfo];
    
}


@end
