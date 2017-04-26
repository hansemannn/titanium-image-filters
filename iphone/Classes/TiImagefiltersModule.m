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
    NSString *filterName = [args objectForKey:@"image"];
    
    UIImage *inputImage = [UIImage imageNamed:fileName];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    Class FilterClass = NSClassFromString(filterName);
    GPUImageFilter *filter = [[FilterClass alloc] init];
    
    [stillImageSource addTarget:filter];
    [filter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    UIImage *resultImage = [filter imageFromCurrentFramebuffer];
    
    return [[TiBlob alloc] initWithImage:resultImage];
}

MAKE_SYSTEM_STR(FILTER_SEPIA, @"GPUImageSepiaFilter");
MAKE_SYSTEM_STR(FILTER_HUE, @"GPUImageHueFilter");

@end
