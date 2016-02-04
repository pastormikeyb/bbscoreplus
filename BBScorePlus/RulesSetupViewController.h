//
//  RulesSetupViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/20/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulesSetupViewController : UIViewController
{
    BOOL isTrackingPitchCount, isTimerStarted;
    BOOL isContinousLineup;
    BOOL isHomeTeam;
    BOOL batting;
    BOOL isTopOfInning;
}
@property (weak, nonatomic) IBOutlet UISwitch *trackPitchCountSwitch;
@property (weak, nonatomic) IBOutlet UITextField *maxNumberOfPitchesTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfHoursRestTextField;
@property (weak, nonatomic) IBOutlet UISwitch *continousLineupSwitch;
@property (weak, nonatomic) IBOutlet UITextField *gameTimeLimitTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isHomeTeamSwitch;
@property (weak, nonatomic) IBOutlet UITextField *opponentNameTextField;

- (IBAction)onClick:(id)sender;
- (IBAction)onSwitch:(id)sender;

@end
