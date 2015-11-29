//
//  GameSetupViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSetupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *opponentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameStreetAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameCityAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameStateAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameZipAddressTextField;
- (IBAction)directionsOnClick:(id)sender;

@end
