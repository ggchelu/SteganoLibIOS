//
//  Encoder.h
//  steganolibios
//
//  Created by TxL on 02/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSB2bit.h"

@interface Encoder : NSObject

+ (UIImage*) encode:(NSString*)message source:(UIImage*)source ;

@end
