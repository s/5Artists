//
//  UIImageView+Resize.m
//  5Artists
//
//  Created by Said on 10/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import "UIImageView+Resize.h"

@implementation UIImageView (Resize)

- (void)resizeWithImage:(UIImage *)image
{
    float width;
    float height;
    
    if (image.size.width > image.size.height)
    {
        
        height = 200;
        width  = height * image.size.width / image.size.height;
    }
    else
    {
        width = 200;
        height = width * image.size.height / image.size.width;
    }
    
    CGSize newSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.image = resizedImage;
}
@end
