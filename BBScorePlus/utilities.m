//
//  utilties.m
//  BBScorePlus
//
//  Created by Michael on 2/18/16.
//  Copyright © 2016 Michael Usry. All rights reserved.
//

#import "utilities.h"

@implementation utilities

- (void)showAlert:(NSString*)title msg:(NSString*)msg cancelButtonTitle:(NSString*)buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:buttonTitle
                                          otherButtonTitles:nil];
    [alert show];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
