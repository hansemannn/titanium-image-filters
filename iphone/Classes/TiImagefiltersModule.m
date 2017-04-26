/**
 * titanium-image-filters
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "TiImagefiltersModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "GPUImage.h"

@implementation TiImagefiltersModule

#pragma mark Internal

- (id)moduleGUID
{
	return @"bc72ce9b-ad0d-41cc-a38a-99d2527460dc";
}

- (NSString *)moduleId
{
	return @"ti.imagefilters";
}

#pragma mark Lifecycle

- (void)startup
{
	[super startup];

	NSLog(@"[DEBUG] %@ loaded", self);
}

#pragma Public APIs

- (id)filteredImage:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString *fileName = [args objectForKey:@"image"];
    NSString *filterName = [args objectForKey:@"filter"];
    NSString *shaderName = [args objectForKey:@"shader"];
    KrollCallback *callback = [args objectForKey:@"callback"];
    
    ENSURE_TYPE(fileName, NSString);
    ENSURE_TYPE_OR_NIL(shaderName, NSString);
    ENSURE_TYPE(callback, KrollCallback);
    
    // Create image buffer
    UIImage *inputImage = [TiUtils toImage:fileName proxy:self];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    // Generate filter
    GPUImageFilter *filter;
    
    if (shaderName != nil) {
        filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:shaderName];
    } else {
        ENSURE_TYPE(filterName, NSString);
        
        Class FilterClass = NSClassFromString(filterName);
        filter = [[FilterClass alloc] init];
    }
    
    // Process image
    [stillImageSource addTarget:filter];
    [filter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    // Receive result image
    UIImage *resultImage = [filter imageFromCurrentFramebuffer];
    
    // Dispatch callback
    [callback call:@[@{@"image": [[TiBlob alloc] initWithImage:resultImage]}] thisObject:self];
    
    // Cleanup
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    resultImage = nil;
}

MAKE_SYSTEM_STR(FILTER_SEPIA, @"GPUImageSepiaFilter");
MAKE_SYSTEM_STR(FILTER_HUE, @"GPUImageHueFilter");

@end
