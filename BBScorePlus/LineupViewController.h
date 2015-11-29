//
//  LineupViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineUpTableViewCell.h"

@interface LineupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    NSMutableArray *batterListArray;
    BOOL editLineup;
    BOOL doesFileExist;
}
-(IBAction)onClick:(id)sender;


@end
