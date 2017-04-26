//
//  TiImagefiltersFilterProxy.h
//  titanium-image-filters
//
//  Created by Hans Knöchel on 26.04.17.
//
//

#import "TiProxy.h"
#import "GPUImage.h"

@interface TiImagefiltersFilterProxy : TiProxy {
    GPUImageFilter *filter;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andArgs:(NSDictionary *)args;

- (GPUImageFilter *)filter;

@end
