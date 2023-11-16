//
//  MTLImage.h
//  TestMetal
//
//  Created by youdun on 2023/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGAImage : NSObject

// Initialize this image by loading a *very* simple TGA file. Will not load compressed, paletted, or color mapped images.
- (nullable instancetype)initWithTGAFileFromUrl:(nonnull NSURL *)url;

// Initialize the image by loading an `NSData` object with tightly packed `BGRA8Unorm` data and dimensions.
- (nullable instancetype)initWithBGRA8UnormData:(nonnull NSData *)data
                                          width:(NSUInteger)width
                                         height:(NSUInteger)height;

// Save the image to a TGA file at the given location.
- (void)saveToTGAFileAtLocation:(nonnull NSURL *)location;

// Width of image in pixels
@property (nonatomic, readonly) NSUInteger width;

// Height of image in pixels
@property (nonatomic, readonly) NSUInteger height;

// Image data in 32-bits-per-pixel (bpp) BGRA form (which is equivalent to MTLPixelFormatBGRA8Unorm)
@property (nonatomic, readonly, nonnull) NSData *data;

@end

NS_ASSUME_NONNULL_END
