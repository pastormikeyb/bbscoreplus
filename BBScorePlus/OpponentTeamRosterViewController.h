//
//  OpponentTeamRosterViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpponentRosterTableViewCell.h"

@interface OpponentTeamRosterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL doesFileExist;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
