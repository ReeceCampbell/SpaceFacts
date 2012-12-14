//
//  Utility.m
//  Space Facts
//
//  Created by Shafi Jami on 11/21/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(CGRect)CGRectMake:(CGPoint)point size:(CGSize)size{
    return CGRectMake(point.x, point.y, size.width, size.height);
}

+ (UIImage *)retina4ImageNamed:(NSString *)imageName {
    NSLog(@"Loading image named => %@", imageName);
    NSMutableString *imageNameMutable = [imageName mutableCopy];
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
    if (retinaAtSymbol.location != NSNotFound) {
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    } else {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
            } else {
                [imageNameMutable appendString:@"-568h@2x"];
            }
        }
    }
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
//    if (imagePath) {
//        return [UIImage retina4ImageNamed:imageNameMutable];
//    } else {
//        return [UIImage retina4ImageNamed:imageName];
//    }
    if (imagePath) {
        return [UIImage imageNamed:imageNameMutable];
    } else {
        return [UIImage imageNamed:imageName];
    }
    return nil;
}

@end