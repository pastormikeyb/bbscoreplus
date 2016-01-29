//
//  GameStatsViewController.m
//  BBScorePlus
//
//  Created by Michael on 10/19/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import "GameStatsViewController.h"

@interface GameStatsViewController ()
{
    int value;
    NSArray *myPitcherArray, *opponentPitcherArray;
}

@end

@implementation GameStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTeamDictionaryArray = [[NSMutableArray alloc]init];
    opponentTeamDictionaryArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    sectionHeaders = [NSArray arrayWithObjects:@"Home", @"Hitting", @"Current Pitcher", @"Visitor", @"Hitting", @"Current Pitcher", nil];

        // 1 - LOAD MYTEAM
    [self LoadMyTeam];
        // 2 - LOAD OPPONENT TEAM
    [self LoadOpponentTeam];
        // 3 - LOAD BOXSCORE
    [self LoadBoxScore];
        // 4 - DISPLAY STATS FOR MYTEAM
    
        // 5 - DISPLAY STATS FOR OPPONENT TEAM
    
        // 6 - FILTER MYTIME PITCHERS
    
        // 6A - DISPLAY FILTER
    
        // 7 - FILTER OPPONENT PITCHERS
    
        // 7A - DISPLAY FILTER

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 

- (void)shareButton:(id)sender{
    
    [self shareContent];
}

- (void)shareContent{
    if ([myTeamScore intValue] > [opponentTeamScore intValue]) {
        shareSubMessage = @"We're winning.";
    }else if ([myTeamScore intValue] < [opponentTeamScore intValue]){
        shareSubMessage = @"We're down.";
    }else{
        shareSubMessage = @"We're tied all up! ";
    }
    
    NSString *message = [NSString stringWithFormat:@"%@ The current score is %d - %d.",shareSubMessage,[myTeamScore intValue],[opponentTeamScore intValue]];
    UIImage * image = [UIImage imageNamed:@"BBScoreIcon"];
    NSArray * shareItems = @[message, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {//header
        NSLog(@"section 0");
        NSLog(@"BLANK");

        return 0;
    }
    if (section == 1) {
        NSLog(@"section 1-team");//team
        NSLog(@"count: %lu",(unsigned long)myTeamDictionaryArray.count);

        return myTeamDictionaryArray.count;
    }
    if (section == 2) {
        NSLog(@"section 2-pitcher");//my pitcher
        NSLog(@"count: %lu",(unsigned long)loadedPitch.count);


        return loadedPitch.count;
    }
    
    if (section == 3) {
        NSLog(@"section 3-header");//header
        
        NSLog(@"BLANK");

        return 0;
    }
    
    if (section == 4) {
        NSLog(@"section 4-header");//header

        NSLog(@"count: %lu",(unsigned long)opponentTeamDictionaryArray.count);
        
        return opponentTeamDictionaryArray.count;
    }
    
    if (section == 5) {
        NSLog(@"section 5-pitcher");//opponent pitcher

        NSLog(@"count: %lu",(unsigned long)loadedOpponentPitcher.count);
        
        return loadedOpponentPitcher.count;

    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *lineupTableID = @"GameStatsCell";
    
    GameStatsTableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:lineupTableID];

    
    if (cell == nil) {
        cell = [[GameStatsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lineupTableID];
    }
    
    if ([indexPath section] == 1) {
            //home players
        cell.gameStatsPlayerLastName.text = [loadedLastName objectAtIndex:indexPath.row];
        cell.gameStatsPlayerNumber.text = [loadedPlayerNumber objectAtIndex:indexPath.row];
        int fb = [[loadedSingleHit objectAtIndex:indexPath.row]intValue];
        int sb = [[loadedDoubleHit objectAtIndex:indexPath.row]intValue];
        int tb = [[loadedTripleHit objectAtIndex:indexPath.row]intValue];
        int hr = [[loadedHomeRun objectAtIndex:indexPath.row]intValue];
        int fe = [[loadedFieldingError objectAtIndex:indexPath.row]intValue];
        int po = [[loadedPutOut objectAtIndex:indexPath.row]intValue];
        int rb = [[loadedRbi objectAtIndex:indexPath.row]intValue];
        int balls = [[loadedBallsThrown objectAtIndex:indexPath.row]intValue];
        int strikes = [[loadedStrikesThrown objectAtIndex:indexPath.row]intValue];

                
        float hits =(fb + sb + tb + hr);
        float atBats = (fb + sb + tb + hr +fe + po);
        float avg = hits/atBats;
        if (isnan(avg)) {
            avg = 0;
            NSString *stats = [NSString stringWithFormat:@"BATTING: Avg:%.03f  HR:%i  RBI:%i\nPITCHING: Balls Thrown:%i  Strikes Thrown:%i", avg,hr,rb,balls,strikes];
            
            cell.gameStatsPlayerStats.text = stats;
            

        }
    }
    
    if ([indexPath section] == 2) {
            //Home Pitcher

        cell.gameStatsPlayerLastName.text = [[loadedPitch valueForKey:@"lastname"] objectAtIndex:indexPath.row];
        
        cell.gameStatsPlayerNumber.text = [[loadedPitch valueForKey:@"playernumber"] objectAtIndex:indexPath.row];
        
        int balls = [[[loadedPitch valueForKey:@"ballspitched"] objectAtIndex:indexPath.row]intValue];
        int strikes = [[[loadedPitch valueForKey:@"strikesthrown"] objectAtIndex:indexPath.row]intValue];
        
        int pitches =(balls + strikes);
        if (isnan(pitches)) {
            pitches = 0;
            balls = 0;
            strikes = 0;
            NSString *stats = [NSString stringWithFormat:@"Balls:%li Strikes:%i Total Pitches:%i", (long)balls,strikes,pitches];
            
            cell.gameStatsPlayerStats.text = stats;
            
            
        }else{
            NSString *stats = [NSString stringWithFormat:@"Balls:%li Strikes:%i Total Pitches:%i", (long)balls,strikes,pitches];
            
            cell.gameStatsPlayerStats.text = stats;

        }
    }

    if ([indexPath section] == 4) {
            //visitor players
        cell.gameStatsPlayerLastName.text = [loadedOpponentLastName objectAtIndex:indexPath.row];
        cell.gameStatsPlayerNumber.text = [loadedOpponentPlayerNumber objectAtIndex:indexPath.row];
        int fb = [[loadedOpponentSingleHit objectAtIndex:indexPath.row]intValue];
        int sb = [[loadedOpponentDoubleHit objectAtIndex:indexPath.row]intValue];
        int tb = [[loadedOpponentTripleHit objectAtIndex:indexPath.row]intValue];
        int hr = [[loadedOpponentHomeRun objectAtIndex:indexPath.row]intValue];
        int fe = [[loadedOpponentFieldingError objectAtIndex:indexPath.row]intValue];
        int po = [[loadedOpponentPutOut objectAtIndex:indexPath.row]intValue];
        int rb = [[loadedOpponentRbi objectAtIndex:indexPath.row]intValue];
        int balls = [[loadedOpponentBallsThrown objectAtIndex:indexPath.row]intValue];
        int strikes = [[loadedOpponentStrikesThrown objectAtIndex:indexPath.row]intValue];

        
        float hits =(fb + sb + tb + hr);
        float atBats = (fb + sb + tb + hr +fe + po);
        float avg = hits/atBats;
        if (isnan(avg)) {
            avg = 0;
        }
        NSString *stats = [NSString stringWithFormat:@"BATTING: Avg:%.03f  HR:%i  RBI:%i\nPITCHING: Balls Thrown:%i  Strikes Thrown:%i", avg,hr,rb,balls,strikes];
        
            cell.gameStatsPlayerStats.text = stats;
            
    }
    
    if ([indexPath section] == 5) {
            //visitor pitchers

        
        cell.gameStatsPlayerLastName.text = [[loadedOpponentPitcher valueForKey:@"lastname"] objectAtIndex:indexPath.row];
        cell.gameStatsPlayerNumber.text = [[loadedOpponentPitcher valueForKey:@"playernumber"] objectAtIndex:indexPath.row];
        
        int balls = [[[loadedOpponentPitcher valueForKey:@"ballspitched"] objectAtIndex:indexPath.row]intValue];
        int strikes = [[[loadedOpponentPitcher valueForKey:@"strikesthrown"] objectAtIndex:indexPath.row]intValue];
        
        
        int pitches =(balls + strikes);
        if (isnan(pitches)) {
            pitches = 0;
            balls = 0;
            strikes = 0;
            NSString *stats = [NSString stringWithFormat:@"Balls:%i Strikes:%i Total Pitches:%i", balls,strikes,pitches];
            
            cell.gameStatsPlayerStats.text = stats;
            
            
        }else{
            NSString *stats = [NSString stringWithFormat:@"Balls:%i Strikes:%i Total Pitches:%i", balls,strikes,pitches];
            
            cell.gameStatsPlayerStats.text = stats;

            
        }
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Default is 1 if not implemented
    NSLog(@"sectionHeaders count: %lu",(unsigned long)[sectionHeaders count]);
    return [sectionHeaders count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"section number: %li",(long)section);
        return [sectionHeaders objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    float rd = 143.00/255.00;
    float gr = 117.00/255.00;
    float bl = 75.00/255.00;

    if (section == 0) {
        UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
        headerview.contentView.backgroundColor = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
        headerview.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (section == 3) {
        UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
        headerview.contentView.backgroundColor = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
        headerview.textLabel.textColor = [UIColor whiteColor];
    }
    if (section == 1) {
        UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
        headerview.contentView.backgroundColor = [UIColor lightGrayColor];
        headerview.textLabel.textColor = [UIColor blackColor];
    }
    if (section == 2) {
        UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
        headerview.contentView.backgroundColor = [UIColor lightGrayColor];
        headerview.textLabel.textColor = [UIColor blackColor];
    }
    
    if (section == 4) {
        UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
        headerview.contentView.backgroundColor = [UIColor lightGrayColor];
        headerview.textLabel.textColor = [UIColor blackColor];
    }

    if (section == 5) {
        UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
        headerview.contentView.backgroundColor = [UIColor lightGrayColor];
        headerview.textLabel.textColor = [UIColor blackColor];
    }


}

- (void)LoadMyTeam{
    NSLog(@"LoadMyTeamFromFile");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    myTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    loadedLastName = [myTeamDictionaryArray valueForKey:@"lastname"];
    loadedFirstName = [myTeamDictionaryArray valueForKey:@"firstname"];
    loadedPitch = [myTeamDictionaryArray valueForKey:@"pitcher"];
    loadedPlayerNumber = [myTeamDictionaryArray valueForKey:@"playernumber"];
    loadedPlayerThrow = [myTeamDictionaryArray valueForKey:@"playerthrow"];
    loadedSingleHit = [myTeamDictionaryArray valueForKey:@"1B"];
    loadedDoubleHit= [myTeamDictionaryArray valueForKey:@"2B"];
    loadedTripleHit= [myTeamDictionaryArray valueForKey:@"3B"];
    loadedHomeRun = [myTeamDictionaryArray valueForKey:@"HR"];
    loadedFieldersChoice = [myTeamDictionaryArray valueForKey:@"fielderschoice"];
    loadedFieldingError = [myTeamDictionaryArray valueForKey:@"fieldingerror"];
    loadedHitByPitch = [myTeamDictionaryArray valueForKey:@"hitbypitch"];
    loadedSacFly = [myTeamDictionaryArray valueForKey:@"sacfly"];
    loadedRbi = [myTeamDictionaryArray valueForKey:@"RBI"];
    loadedWalk = [myTeamDictionaryArray valueForKey:@"walk"];
    loadedPutOut = [myTeamDictionaryArray valueForKey:@"out"];
    loadedBallsThrown = [myTeamDictionaryArray valueForKey:@"ballspitched"];
    loadedStrikesThrown = [myTeamDictionaryArray valueForKey:@"strikesthrown"];
    
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    loadedPitch = [myTeamDictionaryArray filteredArrayUsingPredicate:cp];
    
    NSLog(@"filter %@",loadedPitch);
    
    myTeamFilteredPitcherLastName = [loadedPitch valueForKey:@"lastname"];
    myTeamFilteredPitcherNumber = [loadedPitch valueForKey:@"playernumber"];
    myTeamFilteredPitcherPitchingStats = [loadedPitch valueForKey:@"firstname"];
    
    currentPitcher = [myTeamFilteredPitcherLastName objectAtIndex:0];
    
    NSLog(@"currentPitcher: %@",currentPitcher);
    NSLog(@"loadedPitch: %@", [loadedPitch valueForKey:@"lastname"]);
    
    
}

- (void)LoadOpponentTeam{
    NSLog(@"LoadOpponentTeam From File");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    opponentTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    loadedOpponentLastName = [opponentTeamDictionaryArray valueForKey:@"lastname"];
    loadedOpponentFirstName = [opponentTeamDictionaryArray valueForKey:@"firstname"];
    loadedOpponentPitcher = [opponentTeamDictionaryArray valueForKey:@"pitcher"];
    loadedOpponentPlayerNumber = [opponentTeamDictionaryArray valueForKey:@"playernumber"];
    loadedOpponentPlayerThrow = [opponentTeamDictionaryArray valueForKey:@"playerthrow"];
    loadedOpponentSingleHit = [opponentTeamDictionaryArray valueForKey:@"1B"];
    loadedOpponentSingleHit = [opponentTeamDictionaryArray valueForKey:@"1B"];
    loadedOpponentDoubleHit= [opponentTeamDictionaryArray valueForKey:@"2B"];
    loadedOpponentTripleHit= [opponentTeamDictionaryArray valueForKey:@"3B"];
    loadedOpponentHomeRun = [opponentTeamDictionaryArray valueForKey:@"HR"];
    loadedOpponentFieldersChoice = [opponentTeamDictionaryArray valueForKey:@"fielderschoice"];
    loadedOpponentFieldingError = [opponentTeamDictionaryArray valueForKey:@"fieldingerror"];
    loadedOpponentHitByPitch = [opponentTeamDictionaryArray valueForKey:@"hitbypitch"];
    loadedOpponentSacFly = [opponentTeamDictionaryArray valueForKey:@"sacfly"];
    loadedOpponentRbi = [opponentTeamDictionaryArray valueForKey:@"RBI"];
    loadedOpponentWalk = [opponentTeamDictionaryArray valueForKey:@"walk"];
    loadedOpponentPutOut = [opponentTeamDictionaryArray valueForKey:@"out"];
    loadedOpponentBallsThrown = [opponentTeamDictionaryArray valueForKey:@"ballspitched"];
    loadedOpponentStrikesThrown = [opponentTeamDictionaryArray valueForKey:@"strikesthrown"];

    
    
    NSLog(@"value %@",[loadedOpponentSingleHit objectAtIndex:0]);
    
    NSLog(@"myOpponentTeamDictionaryArray:\n%@",opponentTeamDictionaryArray);
    
        //ORIGINAL
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    loadedOpponentPitcher = [opponentTeamDictionaryArray filteredArrayUsingPredicate:cp];
    NSLog(@"opponent pitcher filter %@",loadedOpponentPitcher);
    
    opponentTeamFilteredPitcherLastName = [loadedOpponentPitcher valueForKey:@"lastname"];
    opponentTeamFilteredPitcherNumber = [loadedOpponentPitcher valueForKey:@"playernumber"];
    opponentTeamFilteredPitcherPitchingStats = [loadedOpponentPitcher valueForKey:@"firstname"];
    
    currentOpponentPitcher = [opponentTeamFilteredPitcherLastName objectAtIndex:0];
    
    NSLog(@"opponentTeamFilteredPitcher: %@",currentOpponentPitcher);
    NSLog(@"lastname: %@",[loadedOpponentPitcher valueForKeyPath:@"lastname"]);

    
}

- (void)LoadBoxScore{
    NSLog(@"LoadBoxScore");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"boxscore.out"];
    
    boxScoreDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //    arrayOfDictionariesMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    myTeamScore = [boxScoreDictionary valueForKey:@"homeruns"];
    opponentTeamScore = [boxScoreDictionary valueForKey:@"visitorruns"];
    
    NSLog(@"home Score: %@",myTeamScore);
    
}

- (void)setGamePitchersIndex{
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    myPitcherArray = [myTeamDictionaryArray filteredArrayUsingPredicate:cp];
    
    if (myPitcherArray.count > 0) {
        id item = [myPitcherArray objectAtIndex:0];
        myPitcherIndex = [myTeamDictionaryArray indexOfObject:item];
        NSLog(@"my pitcher filter %@",[myTeamDictionaryArray objectAtIndex:myPitcherIndex]);
    }
    
    NSPredicate *cp1 = [NSPredicate predicateWithFormat:@"pitcher = true"];
    opponentPitcherArray = [opponentTeamDictionaryArray filteredArrayUsingPredicate:cp1];
    if (opponentPitcherArray.count > 0) {
        id item2 = [opponentPitcherArray objectAtIndex:0];
        opponentPitcherIndex = [opponentPitcherArray indexOfObject:item2];
        NSLog(@"opponent filter %@",[opponentTeamDictionaryArray objectAtIndex:opponentPitcherIndex]);
    }
    
}

@end
