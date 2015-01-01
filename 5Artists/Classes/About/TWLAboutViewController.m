//
//  TWLAboutViewController.m
//  5Artists
//
//  Created by Said on 06/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import "TWLAboutViewController.h"

@interface TWLAboutViewController ()

@end

@implementation TWLAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    

    // Create the attributed string
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSString *about = [NSString stringWithFormat:@"\n\n\n\n\nThis application is built by Said ÖZCAN (@saidozcan) using Spotify iOS SDK.\n\nFeel free to email us at info@towerlabs.co\n\n© %d Tower Labs. — version %@\n\n", (int)year, version];
    NSMutableAttributedString *aboutString = [[NSMutableAttributedString alloc]initWithString:about];
    
    NSRange rangeOfAboutString = NSMakeRange(0, [aboutString length]);
    
    // Declare the fonts
    UIFont *aboutStringFont1 = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0];
    
    // Declare the colors
    UIColor *aboutStringColor1 = [UIColor colorWithWhite:1.000000 alpha:1.000000];
    
    // Declare the paragraph styles
    NSMutableParagraphStyle *aboutStringParaStyle1 = [[NSMutableParagraphStyle alloc]init];
    aboutStringParaStyle1.alignment = 1;
    
    
    // Create the attributes and add them to the string
    [aboutString addAttribute:NSLigatureAttributeName value:[NSNumber numberWithInteger:0] range:rangeOfAboutString];
    [aboutString addAttribute:NSParagraphStyleAttributeName value:aboutStringParaStyle1 range:rangeOfAboutString];
    [aboutString addAttribute:NSFontAttributeName value:aboutStringFont1 range:rangeOfAboutString];
    [aboutString addAttribute:NSForegroundColorAttributeName value:aboutStringColor1 range:rangeOfAboutString];
    _aboutLabel.attributedText = aboutString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
