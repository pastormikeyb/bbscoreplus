//
//  AddNewOpponentViewController.h
//  BBScorePlus
//
//  Created by Michael on 11/1/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewOpponentViewController : UIViewController <UITextViewDelegate>
{
    BOOL doesFileExist;
    BOOL isPitcher;
    UIView *inputAccView;

}
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *playerNumber;
@property (weak, nonatomic) IBOutlet UISegmentedControl *batsSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *throwsSegmentControl;

- (IBAction)onClick:(id)sender;
- (IBAction)segmentedControlAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *isPitcherSwitch;
@property (nonatomic, retain)UIButton *btnDone;
@property (nonatomic, retain)UIView *inputAccView;

@end
