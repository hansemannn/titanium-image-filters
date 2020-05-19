/**
 * titanium-image-filters
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "TiImagefiltersModule.h"
#import "TiImagefiltersFilterProxy.h"

#import "TiBlob.h"
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

- (id)createFilter:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    return [[TiImagefiltersFilterProxy alloc] _initWithPageContext:[self pageContext] andArgs:args];
}

- (void)generateFilteredImage:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    id image = [args objectForKey:@"image"];
    id filterProxy = [args objectForKey:@"filter"];
    id callback = [args objectForKey:@"callback"];
    
    ENSURE_TYPE(callback, KrollCallback);
    ENSURE_TYPE(filterProxy, TiImagefiltersFilterProxy);
    
    // Create image buffer
    UIImage *inputImage = [TiUtils toImage:image proxy:self];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    // Receive filter
    GPUImageFilter *filter = [(TiImagefiltersFilterProxy *)filterProxy filter];
    
    // Process image
    [stillImageSource addTarget:filter];
    [filter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    // Receive result image
    UIImage *resultImage = [filter imageFromCurrentFramebufferWithOrientation:inputImage.imageOrientation];
    
    // Dispatch callback
    [callback call:@[@{
        @"image": [[TiBlob alloc] initWithImage:resultImage],
        @"size": @{
            @"height": NUMFLOAT([filter sizeOfFBO].height),
            @"width": NUMFLOAT([filter sizeOfFBO].width)
        }
    }] thisObject:self];
    
    // Cleanup
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
}

MAKE_SYSTEM_STR(FILTER_SEPIA, @"GPUImageSepiaFilter");
MAKE_SYSTEM_STR(FILTER_HUE, @"GPUImageHueFilter");

@end
