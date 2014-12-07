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
    NSMutableAttributedString *aboutString = [[NSMutableAttributedString alloc]initWithString:
                                              @"\n\n\n\n\nThis application is built by Said ÖZCAN (@saidozcan) using Spotify iOS SDK.\n\nFeel free to email us at info@towerlabs.co\n\n© 2014 Tower Labs. — version 1.0"];
    
    // Declare the fonts
    UIFont *aboutStringFont1 = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0];
    UIFont *aboutStringFont2 = [UIFont fontWithName:@"Helvetica-Oblique" size:14.0];
    
    // Declare the colors
    UIColor *aboutStringColor1 = [UIColor colorWithRed:0.000000 green:0.000000 blue:0.000000 alpha:0.360784];
    UIColor *aboutStringColor2 = [UIColor colorWithWhite:1.000000 alpha:1.000000];
    UIColor *aboutStringColor3 = [UIColor colorWithRed:0.109804 green:0.109804 blue:0.109804 alpha:1.000000];
    
    // Declare the paragraph styles
    NSMutableParagraphStyle *aboutStringParaStyle1 = [[NSMutableParagraphStyle alloc]init];
    aboutStringParaStyle1.alignment = 1;
    
    
    // Create the attributes and add them to the string
    [aboutString addAttribute:NSParagraphStyleAttributeName value:aboutStringParaStyle1 range:NSMakeRange(0,145)];
    [aboutString addAttribute:NSUnderlineColorAttributeName value:aboutStringColor1 range:NSMakeRange(0,145)];
    [aboutString addAttribute:NSFontAttributeName value:aboutStringFont1 range:NSMakeRange(0,145)];
    [aboutString addAttribute:NSForegroundColorAttributeName value:aboutStringColor2 range:NSMakeRange(0,145)];
    [aboutString addAttribute:NSForegroundColorAttributeName value:aboutStringColor2 range:NSMakeRange(145,1)];
    [aboutString addAttribute:NSFontAttributeName value:aboutStringFont2 range:NSMakeRange(145,1)];
    [aboutString addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:0] range:NSMakeRange(145,1)];
    [aboutString addAttribute:NSParagraphStyleAttributeName value:aboutStringParaStyle1 range:NSMakeRange(145,1)];
    [aboutString addAttribute:NSStrokeColorAttributeName value:aboutStringColor3 range:NSMakeRange(145,1)];
    [aboutString addAttribute:NSForegroundColorAttributeName value:aboutStringColor2 range:NSMakeRange(146,1)];
    [aboutString addAttribute:NSParagraphStyleAttributeName value:aboutStringParaStyle1 range:NSMakeRange(146,1)];
    [aboutString addAttribute:NSFontAttributeName value:aboutStringFont1 range:NSMakeRange(146,1)];
    [aboutString addAttribute:NSParagraphStyleAttributeName value:aboutStringParaStyle1 range:NSMakeRange(147,11)];
    [aboutString addAttribute:NSUnderlineColorAttributeName value:aboutStringColor1 range:NSMakeRange(147,11)];
    [aboutString addAttribute:NSFontAttributeName value:aboutStringFont1 range:NSMakeRange(147,11)];
    [aboutString addAttribute:NSForegroundColorAttributeName value:aboutStringColor2 range:NSMakeRange(147,11)];
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
