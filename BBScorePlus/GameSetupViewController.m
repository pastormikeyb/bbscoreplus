//
//  GameSetupViewController.m
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import "GameSetupViewController.h"

@interface GameSetupViewController ()

@end

@implementation GameSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)directionsOnClick:(id)sender {
    NSString *street = _gameStreetAddressTextField.text;
    NSString *city = _gameCityAddressTextField.text;
    NSString *state = _gameStateAddressTextField.text;
    NSString *zip = _gameZipAddressTextField.text;
    NSString *search = [[NSString stringWithFormat:@"http://maps.apple.com/?q=%@ %@ %@ %@",street,city,state,zip]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *addressURL = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@",search];
    
    
    if (street.length < 1 || city.length <1) {
        NSLog(@"required has something missing");

    }else{
        NSURL *url = [NSURL URLWithString:search];
        [[UIApplication sharedApplication] openURL:url];

    }
    

}
@end
