//
//  OpponentLineupTableViewCell.h
//  BBScorePlus
//
//  Created by Michael on 11/4/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpponentLineupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OpponentLineUpCustomLastName;
@property (weak, nonatomic) IBOutlet UILabel *OpponentLineUpCustomFirstName;
@property (weak, nonatomic) IBOutlet UILabel *OpponentLineUpCustomPlayerNumber;


@end
