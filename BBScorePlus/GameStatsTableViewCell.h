//
//  GameStatsTableViewCell.h
//  BBScorePlus
//
//  Created by Michael on 11/13/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameStatsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gameStatsPlayerLastName;
@property (weak, nonatomic) IBOutlet UILabel *gameStatsPlayerNumber;
@property (weak, nonatomic) IBOutlet UILabel *gameStatsPlayerStats;

@end
