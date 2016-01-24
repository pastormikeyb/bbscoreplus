//
//  LineUpTableViewCell.h
//  BBScorePlus
//
//  Created by Michael on 11/3/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PitcherTableViewCell : UITableViewCell
{
    UISwitch *currentPitcherSwitch;
}
@property (weak, nonatomic) IBOutlet UILabel *LineUpCustomLastName;
@property (weak, nonatomic) IBOutlet UILabel *LineUpCustomFirstName;
@property (weak, nonatomic) IBOutlet UILabel *LineUpCustomPlayerNumber;

@end
