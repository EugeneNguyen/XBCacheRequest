//
//  UIImageView+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 9/6/15.
//
//

#import "UIImageView+XBExtension.h"

@implementation UIImageView (XBExtension)
@dynamic imageName;

- (void)setImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName]];
}

- (NSString *)imageName
{
    return nil;
}

@end
