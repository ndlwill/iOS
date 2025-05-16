//
//  FVNetClientObjc.m
//  TestApp
//
//  Created by youdun on 2023/9/27.
//

#import "FVNetClientObjc.h"
#include <fvcore/fvnetclient.h>

class FVNetClientWrapper : public FVNetClient {
public:
    FVNetClientObjc *objc = nullptr;
    
    virtual void onProgress(const fvstl::shared_ptr<FVHttpClient> &httpClient) override {
        
    }
};

@implementation FVNetClientObjc
{
    fvstl::shared_ptr<FVNetClientWrapper> netClient;
}

- (id)init {
    self = [super init];
    if (self) {
        netClient.reset(new FVNetClientWrapper());
        netClient->objc = self;
    }
    return self;
}

- (void)dealloc {
    netClient.reset();
}

- (NSString *)appClientUniqueId {
    auto s = netClient->appClientUniqueId();
    return [NSString stringWithUTF8String: s.c_str()];
}

@end
