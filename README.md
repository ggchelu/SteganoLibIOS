# SteganoLibIOS
Steganography framework for iOS in Objective-C

Easy steganography project for ios, hidden messages on images

    // hide a message on UIImage
    UIImage * res = [Encoder encode:@"this is a great test" source:resized];

    // retrieve message from UIImage
    NSLog(@"%@",[Decoder decode:res]);

View example:


![alt tag](https://raw.githubusercontent.com/TxL1/SteganoLibIOS/master/example-screen.png)
