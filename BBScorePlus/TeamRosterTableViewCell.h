//
//  TeamRosterTableViewCell.h
//  BBScorePlus
//
//  Created by Michael on 11/2/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamRosterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LineUpCustomLastName
;
@property (weak, nonatomic) IBOutlet UILabel *LineUpCustomFirstName;
@property (weak, nonatomic) IBOutlet UILabel *LineUpCustomPlayerNumber;

@end
