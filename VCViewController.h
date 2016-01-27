//
//  VCViewController.h
//  BBScorePlus
//
//  Created by Michael on 1/26/16.
//  Copyright © 2016 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface VCViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;


@end
