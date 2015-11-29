//
//  OpponentRosterTableViewCell.h
//  BBScorePlus
//
//  Created by Michael on 11/4/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpponentRosterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OpponentPlayerLastNameLabel
;
@property (weak, nonatomic) IBOutlet UILabel *OpponentPlayerFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *OpponentPlayerNumberLabel;


@end
