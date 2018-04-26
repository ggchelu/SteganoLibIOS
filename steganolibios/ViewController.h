//
//  ViewController.h
//  steganolibios
//
//  Created by TxL on 02/09/14.
//  Copyright (c) 2014 txl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANImageBitmapRep/ANImageBitmapRep.h"

#import "Encoder.h"
#import "Decoder.h"
#import "LSB2bit.h"

@interface ViewController : UIViewController {
    
    IBOutlet UIImageView * ima, * imao;
}

@end
