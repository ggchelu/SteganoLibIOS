//
//  LSB2bit.h
//  steganolibios
//
//  Created by TxL on 03/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSB2bit : NSObject

+ (Byte*) encodeMessage:(NSMutableArray*)pixels width:(int)imgCols height:(int)imgRows message:(NSString*) message  ;

+ (NSString*) decodeMessage:(Byte*) bytes size:(int) size ;

+ (NSMutableArray*) byteArrayToIntArray:(Byte*) bytes size:(int) size ;

+ (int) byteArrayToInt:(Byte*) bytes offset:(int) offset ;

+ (Byte*) convertArray:(NSMutableArray*) pixels ;

@end
