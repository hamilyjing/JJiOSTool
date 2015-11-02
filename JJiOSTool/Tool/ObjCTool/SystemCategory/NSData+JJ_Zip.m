//
//  NSData+JJ_Zip.m
//  JJiOSTool
//
//  Created by JJ on 11/2/15.
//  Copyright © 2015 JJ. All rights reserved.
//

#import "NSData+JJ_Zip.h"

#import "zlib.h"

@implementation NSData (JJ_Zip)

#pragma mark - ZIP

static NSString * const s_JJZipErrorDomain = @"JJZipErrorDomain";

- (NSData *)jj_compressUseZip:(NSError**)error
{
    /* stream setup */
    z_stream stream;
    memset(&stream, 0, sizeof(stream));
    /* 31 below means generate gzip (16) with a window size of 15 (16 + 15) */
    int iResult = deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY);
    if(iResult != Z_OK)
    {
        if(error)
            *error = [NSError errorWithDomain:s_JJZipErrorDomain code:iResult userInfo:nil];
        return nil;
    }
    /* input buffer setup */
    stream.next_in = (Bytef*)self.bytes;
    stream.avail_in = (uInt)self.length;
    /* output buffer setup */
    uLong nMaxOutputBytes = deflateBound(&stream, stream.avail_in);
    NSMutableData* zipOutput = [NSMutableData dataWithLength:nMaxOutputBytes];
    stream.next_out = (Bytef*)zipOutput.bytes;
    stream.avail_out = (uInt)zipOutput.length;
    /* compress */
    iResult = deflate(&stream, Z_FINISH);
    if(iResult != Z_STREAM_END)
    {
        if(error)
            *error = [NSError errorWithDomain:s_JJZipErrorDomain code:iResult userInfo:nil];
        zipOutput = nil;
    }
    zipOutput.length = zipOutput.length - stream.avail_out;
    deflateEnd(&stream);
    return zipOutput;
}

- (NSData *)jj_uncompressZippedData:(NSError**)error
{
    if ([self length] == 0)
    {
        return self;
    }
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = full_length * 0.5;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    
    BOOL done = NO;
    int status = 0;
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        *error = [NSError errorWithDomain:s_JJZipErrorDomain code:status userInfo:nil];
        return nil;
    }
}

@end
