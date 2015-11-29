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
    NSArray *myPitcherArray;
}

@end

@implementation GameStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTeamDictionaryArray = [[NSMutableArray alloc]init];
    myOpponentTeamDictionaryArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    sectionHeaders = [NSArray arrayWithObjects:@"Home", @"Hitting", @"Pitching", @"Visitor", @"Hitting", @"Pitching", nil];

        // 1 - LOAD MYTEAM
    [self LoadMyTeam];
        // 2 - LOAD OPPONENT TEAM
    [self LoadOpponentTeam];
        // 3 - LOAD BOXSCORE
    
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
        NSLog(@"section 2-pitcher");//pitcher
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

        NSLog(@"count: %lu",(unsigned long)myOpponentTeamDictionaryArray.count);
        
        return myOpponentTeamDictionaryArray.count;
    }
    
    if (section == 5) {
        NSLog(@"section 5-pitcher");//pitcher

        NSLog(@"count: %lu",(unsigned long)loadedOpponentPitch.count);
    
        
        return loadedOpponentPitch.count;

    }

//    NSLog(@"section total ");
//
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
        int fb = [(NSNumber *)[loadedSingleHit objectAtIndex:indexPath.row]intValue];
        int sb = [(NSNumber *)[loadedDoubleHit objectAtIndex:indexPath.row]intValue];
        int tb = [(NSNumber *)[loadedTripleHit objectAtIndex:indexPath.row]intValue];
        int hr = [(NSNumber *)[loadedTripleHit objectAtIndex:indexPath.row]intValue];
        int fe = [(NSNumber *)[loadedFieldingError objectAtIndex:indexPath.row]intValue];
        int po = [(NSNumber *)[loadedPutOut objectAtIndex:indexPath.row]intValue];
        int rb = [(NSNumber *)[loadedRbi objectAtIndex:indexPath.row]intValue];
        
        float hits =(fb + sb + tb + hr);
        float atBats = (fb + sb + tb + hr +fe + po);
        float avg = hits/atBats;
        if (isnan(avg)) {
            avg = 0;
            NSString *stats = [NSString stringWithFormat:@"Avg:%.03f HR:%i RBI:%i", avg,hr,rb];
            
            cell.gameStatsPlayerStats.text = stats;
            

        }
    }
    
    if ([indexPath section] == 2) {
        

        cell.gameStatsPlayerLastName.text = [[loadedPitch valueForKey:@"lastname"] objectAtIndex:indexPath.row];
        cell.gameStatsPlayerNumber.text = [[loadedPitch valueForKey:@"playernumber"] objectAtIndex:indexPath.row];
        int balls = [(NSNumber *)[loadedBallsThrown objectAtIndex:indexPath.row]intValue];
        int strikes = [(NSNumber *)[loadedStrikesThrown objectAtIndex:indexPath.row]intValue];
        
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

    if ([indexPath section] == 4) {
            //visitor players
        cell.gameStatsPlayerLastName.text = [loadedOpponentLastName objectAtIndex:indexPath.row];
        cell.gameStatsPlayerNumber.text = [loadedOpponentPlayerNumber objectAtIndex:indexPath.row];
        int fb = [(NSNumber *)[loadedOpponentSingleHit objectAtIndex:indexPath.row]intValue];
        int sb = [(NSNumber *)[loadedOpponentDoubleHit objectAtIndex:indexPath.row]intValue];
        int tb = [(NSNumber *)[loadedOpponentTripleHit objectAtIndex:indexPath.row]intValue];
        int hr = [(NSNumber *)[loadedOpponentTripleHit objectAtIndex:indexPath.row]intValue];
        int fe = [(NSNumber *)[loadedOpponentFieldingError objectAtIndex:indexPath.row]intValue];
        int po = [(NSNumber *)[loadedOpponentPutOut objectAtIndex:indexPath.row]intValue];
        int rb = [(NSNumber *)[loadedOpponentRbi objectAtIndex:indexPath.row]intValue];
        
        float hits =(fb + sb + tb + hr);
        float atBats = (fb + sb + tb + hr +fe + po);
        float avg = hits/atBats;
        if (isnan(avg)) {
            avg = 0;
        }
            NSString *stats = [NSString stringWithFormat:@"Avg:%.03f HR:%i RBI:%i", avg,hr,rb];
            
            cell.gameStatsPlayerStats.text = stats;
            
    }
    
    if ([indexPath section] == 5) {
            //visitor pitchers

        
        cell.gameStatsPlayerLastName.text = [[loadedOpponentPitch valueForKey:@"lastname"] objectAtIndex:indexPath.row];
        cell.gameStatsPlayerNumber.text = [[loadedOpponentPitch valueForKey:@"playernumber"] objectAtIndex:indexPath.row];
        int balls = [(NSNumber *)[loadedOpponentBallsThrown objectAtIndex:indexPath.row]intValue];
        int strikes = [(NSNumber *)[loadedOpponentStrikesThrown objectAtIndex:indexPath.row]intValue];
        
        int pitches =(balls + strikes);
        if (isnan(pitches)) {
            pitches = 0;
            balls = 0;
            strikes = 0;
            NSString *stats = [NSString stringWithFormat:@"Balls:%i Strikes:%i Total Pitches:%i", balls,strikes,pitches];
            
            cell.gameStatsPlayerStats.text = stats;
            
            
        }else{            NSString *stats = [NSString stringWithFormat:@"Balls:%i Strikes:%i Total Pitches:%i", balls,strikes,pitches];
            
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
        //testing
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


    
    NSLog(@"myTeamDictionaryArray:\n%@",myTeamDictionaryArray);
    
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
    
    myOpponentTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    loadedOpponentLastName = [ myOpponentTeamDictionaryArray valueForKey:@"lastname"];
    loadedOpponentFirstName = [myOpponentTeamDictionaryArray valueForKey:@"firstname"];
    loadedOpponentPitch = [myOpponentTeamDictionaryArray valueForKey:@"pitcher"];
    loadedOpponentPlayerNumber = [myOpponentTeamDictionaryArray valueForKey:@"playernumber"];
    loadedOpponentPlayerThrow = [myOpponentTeamDictionaryArray valueForKey:@"playerthrow"];
    loadedOpponentSingleHit = [myOpponentTeamDictionaryArray valueForKey:@"1B"];
    loadedOpponentSingleHit = [myOpponentTeamDictionaryArray valueForKey:@"1B"];
    loadedOpponentDoubleHit= [myOpponentTeamDictionaryArray valueForKey:@"2B"];
    loadedOpponentTripleHit= [myOpponentTeamDictionaryArray valueForKey:@"3B"];
    loadedOpponentHomeRun = [myOpponentTeamDictionaryArray valueForKey:@"HR"];
    loadedOpponentFieldersChoice = [myOpponentTeamDictionaryArray valueForKey:@"fielderschoice"];
    loadedOpponentFieldingError = [myOpponentTeamDictionaryArray valueForKey:@"fieldingerror"];
    loadedOpponentHitByPitch = [myOpponentTeamDictionaryArray valueForKey:@"hitbypitch"];
    loadedOpponentSacFly = [myOpponentTeamDictionaryArray valueForKey:@"sacfly"];
    loadedOpponentRbi = [myOpponentTeamDictionaryArray valueForKey:@"RBI"];
    loadedOpponentWalk = [myOpponentTeamDictionaryArray valueForKey:@"walk"];
    loadedOpponentPutOut = [myOpponentTeamDictionaryArray valueForKey:@"out"];
    loadedOpponentBallsThrown = [myOpponentTeamDictionaryArray valueForKey:@"ballspitched"];
    loadedOpponentStrikesThrown = [myOpponentTeamDictionaryArray valueForKey:@"strikesthrown"];

    
    
    NSLog(@"value %@",[loadedOpponentSingleHit objectAtIndex:0]);
    
    NSLog(@"myOpponentTeamDictionaryArray:\n%@",myOpponentTeamDictionaryArray);
    
        //ORIGINAL
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    loadedOpponentPitch = [myOpponentTeamDictionaryArray filteredArrayUsingPredicate:cp];
    NSLog(@"filter %@",loadedOpponentPitch);
    
    opponentTeamFilteredPitcherLastName = [loadedOpponentPitch valueForKey:@"lastname"];
    opponentTeamFilteredPitcherNumber = [loadedOpponentPitch valueForKey:@"playernumber"];
    opponentTeamFilteredPitcherPitchingStats = [loadedOpponentPitch valueForKey:@"firstname"];
    
    currentOpponentPitcher = [opponentTeamFilteredPitcherLastName objectAtIndex:0];
    
    NSLog(@"opponentTeamFilteredPitcher: %@",currentOpponentPitcher);
    NSLog(@"lastname: %@",[loadedOpponentPitch valueForKeyPath:@"lastname"]);

    
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
        
        
@end
