//
//  ViewController.m
//  steganolibios
//
//  Created by TxL on 02/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import "ViewController.h"

#import "Base64.h"

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	
    NSLog(@"com.txl.steganolibios");
    
    UIImage *resized = [ViewController imageWithImage:[UIImage imageNamed:@"pic.jpg"] scaledToSize:CGSizeMake(90, 90)];
    [ima setImage:resized];
    
    UIImage * res = [Encoder encode:@"this is a great test" source:resized];
    [imao setImage:res];
    
    NSLog(@"%@",[Decoder decode:res]);
}

/// TESTING ANDROID COMPATIBILITY

+ (NSMutableArray*) getPixels:(ANImageBitmapRep*)ibr width:(int)width height:(int)height {
    
    NSMutableArray *oneD = [[NSMutableArray alloc] init];
    BMPixel pixel;
    UIColor * color;
    unsigned int outVal;
    NSScanner* scanner;
    
    for (int i = 0; i < width; i++)
        for (int j = 0; j < height; j++) {
            
            pixel = [ibr getPixelAtPoint:BMPointMake(i, j)];
            color = [UIColor colorWithRed:pixel.red green:pixel.green blue:pixel.blue alpha:pixel.alpha];
            scanner = [NSScanner scannerWithString:[self hexStringForColor:color]];
            [scanner scanHexInt:&outVal];
            
            [oneD addObject:[[NSNumber alloc] initWithInt:outVal]];
        }
    
    return oneD;
}

+ (NSString *)hexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = components[3];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X%02X", (int)(a * 255), (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    if (string.length > 0) {
        
        //the iPhone has base 64 decoding built in but not obviously. The trick is to
        //create a data url that's base 64 encoded and ask an NSData to load it.
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    return nil;
}


@end
