//
//  TWLAboutViewController.h
//  5Artists
//
//  Created by Said on 06/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWLAboutViewController : UIViewController
- (IBAction)dismissViewController:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
