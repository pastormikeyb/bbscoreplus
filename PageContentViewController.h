//
//  PageContentViewController.h
//  BBScorePlus
//
//  Created by Michael on 1/26/16.
//  Copyright © 2016 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;


@end
