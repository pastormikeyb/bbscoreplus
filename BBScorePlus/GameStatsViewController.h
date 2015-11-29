//
//  GameStatsViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/19/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameStatsTableViewCell.h"

@interface GameStatsViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
//    IBOutlet UITableView *tableView;
    NSMutableArray *batterListArray,*myTeamDictionaryArray,*myOpponentTeamDictionaryArray;
    NSArray *sectionHeaders;
    NSString *firstName, *lastName, *playerNumber, *singleHits, *doubleHits, *tripleHits,*homeRuns,*batterWalks,*fieldingErros;
    NSMutableArray *loadedLastName, *loadedFirstName, *loadedPlayerNumber, *loadedPlayerThrow, *loadedSingleHit;
    NSMutableArray *loadedDoubleHit, *loadedTripleHit,*loadedHomeRun, *loadedFieldersChoice, *loadedHitByPitch, *loadedSacFly, *loadedFieldingError, *loadedRbi, *loadedWalk, *loadedPutOut, *loadedBallsThrown, *loadedStrikesThrown;

    NSString *currentPitcher;
    
    NSMutableArray *loadedOpponentLastName, *loadedOpponentFirstName, *loadedOpponentPlayerNumber, *loadedOpponentPlayerThrow, *loadedOpponentSingleHit;
    NSMutableArray *loadedOpponentDoubleHit, *loadedOpponentTripleHit,*loadedOpponentHomeRun, *loadedOpponentFieldersChoice, *loadedOpponentHitByPitch, *loadedOpponentSacFly;
    NSMutableArray *loadedOpponentFieldingError, *loadedOpponentRbi, *loadedOpponentWalk, *loadedOpponentPutOut, *loadedOpponentBallsThrown, *loadedOpponentStrikesThrown;
    
    NSString *currentOpponentPitcher;

    NSArray *loadedPitch, *loadedOpponentPitch,*myTeamFilteredPitcherLastName,*myTeamFilteredPitcherNumber, *myTeamFilteredPitcherPitchingStats,*opponentTeamFilteredPitcherLastName, *opponentTeamFilteredPitcherNumber, *opponentTeamFilteredPitcherPitchingStats;
    
    NSDictionary *boxScoreDictionary;
    NSNumber *myTeamScore, *opponentTeamScore;
    
    NSString *shareSubMessage;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)shareButton:(id)sender;

@end
