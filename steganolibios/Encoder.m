//
//  Encoder.m
//  steganolibios
//
//  Created by TxL on 02/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import "Encoder.h"
#import "ANImageBitmapRep.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Encoder

+ (UIImage*) encode:(NSString*)message source:(UIImage*)source {

    CGImageRef cgimage = [source CGImage];
    
    size_t width = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);

    ANImageBitmapRep * ibr = [[ANImageBitmapRep alloc] initWithCGImage:cgimage];
    
    NSMutableArray *res = [self getPixels:ibr width:(int)width height:(int)height];
    
    // ENCODED
    Byte * bytes = [LSB2bit encodeMessage:res width:(int)width height:(int)height message:message];
    NSMutableArray *resEncoded = [LSB2bit byteArrayToIntArray:bytes size:(int)(width * height * 3)];
    
    NSLog(@"res: %lu",(unsigned long)[res count]);
    NSLog(@"resEncoded: %lu",(unsigned long)[resEncoded count]);
    
    ANImageBitmapRep * ibres = [self getImage:resEncoded width:(int)width height:(int)height];
    
    /*
    UIColor *aux;
    BMPixel pix;
    float red, green, blue, alpha;
    ANImageBitmapRep * ibres = [[ANImageBitmapRep alloc] initWithSize:BMPointFromSize(CGSizeMake(width, height))];
    int masterIndex = 0;
    for (int j = 0; j < height; j++)
        for (int i = 0; i < width; i++) {
            
            aux = UIColorFromRGB([[resEncoded objectAtIndex:masterIndex] intValue]);
            
            [aux getRed:&red green:&green blue:&blue alpha:&alpha];
            pix = BMPixelMake(red , green, blue, alpha);
            [ibres setPixel:BMPixelMake(red, green, blue, alpha) atPoint:BMPointMake(i, j)];
            masterIndex++;
        }
    
    // Devuelve misma imagen
    NSLog(@"%@",[res objectAtIndex:0]);
    NSLog(@"%@",[resEncoded objectAtIndex:0]);
    NSLog(@"%@", UIColorFromRGB([[res objectAtIndex:0] intValue]));
    */
   // ANImageBitmapRep * ibres = [self getImage:res width:width height:height];
    
    return ibres.image;
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






















- (unsigned char*)UIImageToByteArray:(UIImage*)image; {
    
    unsigned char *imageData = (unsigned char*)(malloc( 4*image.size.width*image.size.height));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef imageRef = [image CGImage];
    CGContextRef bitmap = CGBitmapContextCreate( imageData,
                                                image.size.width,
                                                image.size.height,
                                                8,
                                                image.size.width*4,
                                                colorSpace,
                                                kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage( bitmap, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    
    CGContextRelease( bitmap);
    CGColorSpaceRelease( colorSpace);
    
    return imageData;
}

- (int)intForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = components[3];
    int hexString = [[NSString stringWithFormat:@"%d%d%d%d", (int)r, (int)g, (int)b, (int)a] intValue];
    return hexString;
}


@end
