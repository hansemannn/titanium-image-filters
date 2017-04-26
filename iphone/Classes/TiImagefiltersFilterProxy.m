//
//  TiImagefiltersFilterProxy.m
//  titanium-image-filters
//
//  Created by Hans Knöchel on 26.04.17.
//
//

#import "TiImagefiltersFilterProxy.h"

@implementation TiImagefiltersFilterProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andArgs:(NSDictionary *)args
{
    if (self = [super _initWithPageContext:context]) {
        NSString *filterName = [args objectForKey:@"type"];
        NSDictionary *properties = [args objectForKey:@"properties"];
        NSString *shaderName = [args objectForKey:@"shader"];

        ENSURE_TYPE(filterName, NSString);
        ENSURE_TYPE_OR_NIL(properties, NSDictionary);
        
        if (shaderName == nil) {
            ENSURE_TYPE(filterName, NSString);
            _filter = [[NSClassFromString(filterName) alloc] init];
        } else if (filterName == nil) {
            ENSURE_TYPE(shaderName, NSString);
            _filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:shaderName];
        } else if (shaderName != nil && filterName != nil) {
            NSLog(@"[ERROR] Both 'type' and 'shader' property is set. Please use one of both to distinguish between build-in filters and custom filters.");
        }

        // Inject filter properties. The developer needs to ensure
        // pass the correct values here, we don't want to manually
        // validate and map all properties for the 125+ filters available.
        for (NSString *key in [properties allKeys]) {
            [_filter setValue:[properties objectForKey:key] forKey:key];
        }
    }
    
    return self;
}

@end
