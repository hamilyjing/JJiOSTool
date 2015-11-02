//
//  NSData+JJ_Zip.h
//  JJiOSTool
//
//  Created by JJ on 11/2/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (JJ_Zip)

#pragma mark - ZIP

- (NSData *)jj_compressUseZip:(NSError**)error;
- (NSData *)jj_uncompressZippedData:(NSError**)error;

@end
