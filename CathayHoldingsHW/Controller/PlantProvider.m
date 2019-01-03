//
//  PlantProvider.m
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import "PlantProvider.h"
#import "HTTPManager.h"

@interface PlantProvider () {
    NSString *_resourceId;
    NSInteger _count;
    NSMutableArray<Plant *> *_plants;
}
@property (weak, nonatomic) id<PlantProviderDelegate> delegate;
@end

@implementation PlantProvider

- (instancetype) initWithDelegate:(id<PlantProviderDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _state = PlantProviderStatePreparing;
        _count = -1;
        _plants = [NSMutableArray new];
        __weak PlantProvider *weakS = self;
        [[HTTPManager sharedInstance] httpGetJSONWithUrl:[NSURL URLWithString:@"https://data.taipei/opendata/datalist/apiAccess?scope=datasetMetadataSearch&q=id:48c4d6a7-4b09-4d1f-9739-ee837d302bd1"]
                                               onSuccess:^(id result) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [weakS onDatasetSearchResponse:result];
                                                   });
                                               }
                                                 failure:^(NSError * error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [weakS onDatasetSearchFailed:error];
                                                     });
                                                 }];
    }
    return self;
}

- (NSArray<Plant *> *)plants {
    @synchronized (self) {
        return [_plants copy];
    }
}

/***
{
  "result": {
    "limit": 100,
    "offset": 0,
    "count": 1,
    "sort": "",
    "results": [
      {
        "id": "48c4d6a7-4b09-4d1f-9739-ee837d302bd1",
        "title": "臺北市立動物園_植物資料",
        ...
        "tag": "動物園,植物,臺北市立動物園",
        "resources": [
          {
            "resourceId": "f18de02f-b6c9-47c0-8cda-50efad621c14",
            ...
          }
        ]
      }
    ]
  }
}

 ***/
- (void)onDatasetSearchResponse:(NSDictionary *)response {
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    NSDictionary *resultEntry = response[@"result"];
    if (resultEntry == nil || ![resultEntry isKindOfClass:[NSDictionary class]]) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    NSArray *resultsEntry = resultEntry[@"results"];
    if (resultsEntry == nil || ![resultsEntry isKindOfClass:[NSArray class]]) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    if (resultsEntry.count <= 0) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"No result"
                                    }]];
        return;
    }
    NSDictionary *firstResult = resultsEntry[0];
    if (firstResult == nil || ![firstResult isKindOfClass:[NSDictionary class]]) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    NSArray *resourcesEntry = firstResult[@"resources"];
    if (resourcesEntry == nil || ![resourcesEntry isKindOfClass:[NSArray class]]) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    if (resourcesEntry.count <= 0) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"No resource"
                                    }]];
        return;
    }
    NSDictionary *firstResources = resourcesEntry[0];
    if (firstResources == nil || ![firstResources isKindOfClass:[NSDictionary class]]) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    NSString *resourceId = firstResources[@"resourceId"];
    if (resourceId == nil || ![resourceId isKindOfClass:[NSString class]]) {
        [self onDatasetSearchFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    _resourceId = resourceId;
    @synchronized (self) {
        _state = PlantProviderStateIdle;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate onProviderReady];
    });
}

- (void) onDatasetSearchFailed:(NSError *)error {
    @synchronized (self) {
        _state = PlantProviderStateFatalError;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate onProviderSetupFailed:error];
    });
}

- (void)query {
    @synchronized (self) {
        if (self.state != PlantProviderStateIdle && self.state != PlantProviderStateQueryFailed) {
            return;
        }
        if (_count >= 0 && _plants.count >= _count) {
            _state = PlantProviderStateEnd;
            return;
        }
        _state = PlantProviderStateQuerying;
    }
    NSString *urlStr =
    [NSString stringWithFormat:@"https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=%@&limit=20&offset=%lu", _resourceId, _plants.count];
    __weak PlantProvider *weakS = self;
    [[HTTPManager sharedInstance] httpGetJSONWithUrl:[NSURL URLWithString:urlStr]
                                           onSuccess:^(id result) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [weakS onQueryResponse:result];
                                               });
                                           }
                                             failure:^(NSError * error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [weakS onQueryFailed:error];
                                                 });
                                             }];
}


/***
{
  "result": {
    "limit": 10,
    "offset": 20,
    "count": 100,
    "sort": "",
    "results": [
      ...
    ]
  }
}
 ***/
- (void) onQueryResponse:(NSDictionary *)response {
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        [self onQueryFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    NSDictionary *resultEntry = response[@"result"];
    if (resultEntry == nil || ![resultEntry isKindOfClass:[NSDictionary class]]) {
        [self onQueryFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }

    NSNumber *countEntry = resultEntry[@"count"];
    if (countEntry == nil || ![countEntry isKindOfClass:[NSNumber class]]) {
        [self onQueryFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    NSArray *resultsEntry = resultEntry[@"results"];
    if (resultsEntry == nil || ![resultsEntry isKindOfClass:[NSArray class]]) {
        [self onQueryFailed:
         [NSError errorWithDomain:@"PlantProvider"
                             code:1
                         userInfo:@{
                                    NSLocalizedDescriptionKey: @"invalid response"
                                    }]];
        return;
    }
    NSMutableArray *ps = [NSMutableArray new];
    for (id item in resultsEntry) {
        Plant *p = [Plant parseWithJSON:item];
        if (!p) {
            [self onQueryFailed:
             [NSError errorWithDomain:@"PlantProvider"
                                 code:1
                             userInfo:@{
                                        NSLocalizedDescriptionKey: @"invalid response"
                                        }]];
            return;
        }
        [ps addObject:p];
    }
    @synchronized (self) {
        _count = countEntry.integerValue;
        [_plants addObjectsFromArray:ps];
        if (_count <= _plants.count) {
            _state = PlantProviderStateEnd;
        } else {
            _state = PlantProviderStateIdle;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate onQuerySuccess];
    });
}

- (void) onQueryFailed:(NSError *)error {
    @synchronized (self) {
        _state = PlantProviderStateQueryFailed;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate onQueryFailed:error];
    });
}
@end
