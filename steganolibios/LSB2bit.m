//
//  LSB2bit.m
//  steganolibios
//
//  Created by TxL on 03/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import "LSB2bit.h"

@implementation LSB2bit

    int binary[] = { 16, 8, 0 };
    Byte andByte[4] = { (Byte) 0xC0, 0x30, 0x0C, 0x03 };
    int toShift[] = { 6, 4, 2, 0 };
    NSString* END_MESSAGE_CONSTANT = @"#!@";
    NSString* START_MESSAGE_CONSTANT = @"@!#";

+ (Byte*) encodeMessage:(NSMutableArray*)pixels width:(int)imgCols height:(int)imgRows message:(NSString*) message  {
    
    NSData *aux;
    
    message = [message stringByAppendingString:END_MESSAGE_CONSTANT];
    message = [NSString stringWithFormat:@"%@%@",START_MESSAGE_CONSTANT,message];
    NSLog(@"message %@",message);
    
    
    // genera array bytes inicial
    aux = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger len = [aux length];
    Byte *msg = (Byte*)malloc(len);
    memcpy(msg, [aux bytes], len);

    int channels = 3;
    int shiftIndex = 4;
    
    Byte *result = (Byte*)malloc(imgRows * imgCols * channels);
    
    int msgIndex = 0;
    int resultIndex = 0, element;
    BOOL msgEnded = NO;
    
    for (int row = 0; row < imgRows; row++) {
        for (int col = 0; col < imgCols; col++) {
            
            element = row * imgCols + col;
            Byte tmp = 0;
            
            for (int channelIndex = 0; channelIndex < channels; channelIndex++) {
                
                if (!msgEnded) {
                    
                    tmp = (Byte) (((([[pixels objectAtIndex:element] intValue] >> binary[channelIndex]) & 0xFF) & 0xFC) | ((msg[msgIndex] >> toShift[(shiftIndex++) % 4]) & 0x3));// 6
                    
                    if (shiftIndex % 4 == 0)
                        msgIndex++;
                    if (msgIndex == len)
                        msgEnded = YES;
                }
                else {
                    tmp = (Byte) (([[pixels objectAtIndex:element] intValue] >> binary[channelIndex]) & 0xFF);
                    
                }
                result[resultIndex++] = tmp;
            }
        }
    }

    return result;
}

+ (NSString*) decodeMessage:(Byte*) bytes size:(int) size {
    
    NSString *builder = @"";
    int shiftIndex = 4;
    Byte tmp = 0x00, aux;

    //NSLog(@"size: %d",size);
    
    for (int i = 0; i < size; i++) {
        
        aux = (bytes[i] << toShift[shiftIndex % 4]);
        tmp |= (aux & andByte[(shiftIndex++) % 4]);
        
        if (shiftIndex % 4 == 0) {
            
            Byte *result = (Byte*)malloc(1);
            result[0] = tmp;
            
            NSString *str = [[NSString alloc] initWithBytes:result length:1 encoding:NSUTF8StringEncoding];
            
            if ([builder hasSuffix:END_MESSAGE_CONSTANT]) {
                //NSLog(@"break 1");
                break;
            }
            else {
              
                builder = [builder stringByAppendingString:str];
    
                //NSLog(@"str: %@",str);
                //NSLog(@"builder: %@",builder);
                
                if (([builder length] == [START_MESSAGE_CONSTANT length]) && (![START_MESSAGE_CONSTANT isEqualToString:builder])) {
                    builder = nil;
                    //NSLog(@"break 2");
                    break;
                }
            }
            
            tmp = 0x00;
        }
    }
    
    if (builder != nil)
        builder = [[builder substringToIndex:[builder length] - [END_MESSAGE_CONSTANT length]] substringFromIndex:[START_MESSAGE_CONSTANT length]];
    
    return builder;
}






+ (NSMutableArray*) byteArrayToIntArray:(Byte*) bytes size:(int) size {
    
    int sizeT = size / 3;
    NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:sizeT];
    int off = 0;
    while (off < size) {
        [res addObject:[NSNumber numberWithInt:[self byteArrayToInt:bytes offset:off]]];
        off = off + 3;
    }
    return res;
}

+ (int) byteArrayToInt:(Byte*) bytes offset:(int) offset {
    
    int value = 0x00000000;
    int shift;
    
    for (int i = 0; i < 3; i++) {
        shift = (3 - 1 - i) * 8;
        value |= (bytes[i + offset] & 0x000000FF) << shift;
    }
    value = value & 0x00FFFFFF;
    
    return value;
}

+ (Byte*) convertArray:(NSMutableArray*) pixels {
    
    Byte *result = (Byte*)malloc([pixels count] * 3);
    
    for (int i = 0; i < [pixels count]; i++) {
        
        result[i * 3] = (Byte) (([[pixels objectAtIndex:i] intValue] >> 16) & 0xFF);
        result[i * 3 + 1] = (Byte) (([[pixels objectAtIndex:i] intValue] >> 8) & 0xFF);
        result[i * 3 + 2] = (Byte) ([[pixels objectAtIndex:i] intValue] & 0xFF);
    }    
    return result;
}

@end
