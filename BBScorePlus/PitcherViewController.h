//
//  PitcherViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PitcherTableViewCell.h"

@interface PitcherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    NSMutableArray *batterListArray;
    BOOL editLineup;
    BOOL doesFileExist;
    BOOL isCurrentPitcher;
}

-(IBAction)onClick:(id)sender;





@end
