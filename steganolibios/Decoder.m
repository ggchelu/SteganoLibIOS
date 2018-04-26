//
//  Decoder.m
//  steganolibios
//
//  Created by TxL on 03/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import "Decoder.h"
#import "ANImageBitmapRep.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Decoder

+ (NSString *) decode:(UIImage *) image {
    
    CGImageRef cgimage = [image CGImage];
    
    size_t width = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    
    ANImageBitmapRep * ibr = [[ANImageBitmapRep alloc] initWithCGImage:cgimage];
    NSMutableArray *pixels = [self getPixels:ibr width:(int)width height:(int)height];
    
    Byte* bytes = [LSB2bit convertArray:pixels];
    NSLog(@"count: %d",(int)[pixels count] * 3);

    NSString *res = [LSB2bit decodeMessage:bytes size:((int)[pixels count] * 3)];

    // proof
    NSMutableArray *resDecoded = [LSB2bit byteArrayToIntArray:bytes size:(int)(width * height * 3)];
    NSLog(@"resDecoded: %lu",(unsigned long)[resDecoded count]);
    
    return res;
}



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

+ (ANImageBitmapRep*) getImage:(NSMutableArray*)pixels width:(int)width height:(int)height {
    
    ANImageBitmapRep * ibres = [[ANImageBitmapRep alloc] initWithSize:BMPointMake(width, height)];
    UIColor *aux;
    BMPixel pix;
    CGFloat red, green, blue, alpha;
    
    for (int i = 0; i < width;i++)
        for (int j = 0; j < height; j++){
            
            //indexY * arrayHeight + indexX;
            aux = UIColorFromRGB([[pixels objectAtIndex:i * height + j] intValue]);
            
            [aux getRed:&red green:&green blue:&blue alpha:&alpha];
            pix = BMPixelMake(red , green, blue, alpha);
            [ibres setPixel:pix atPoint:BMPointMake(i,j)];
        }
    
    return ibres;
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






@end
