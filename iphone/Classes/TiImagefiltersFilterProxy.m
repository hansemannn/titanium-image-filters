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

        ENSURE_TYPE(filterName, NSString);
        ENSURE_TYPE_OR_NIL(properties, NSDictionary);

        filter = [[NSClassFromString(filterName) alloc] init];
        
        // Inject filter properties. The developer needs to ensure
        // pass the correct values here, we don't want to manually
        // validate and map all properties for the 125+ filters available.
        for (NSString *key in [properties allKeys]) {
            [filter setValue:[properties objectForKey:key] forKey:key];
        }
    }
    
    return self;
}

- (GPUImageFilter *)filter
{
    return filter;
}

@end
