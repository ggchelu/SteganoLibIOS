//
//  Decoder.h
//  steganolibios
//
//  Created by TxL on 03/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSB2bit.h"

@interface Decoder : NSObject

+ (NSString *) decode:(UIImage *) image ;

@end
