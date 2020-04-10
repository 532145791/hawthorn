
//-------------------网络请求管理类---------------------//

#import "HttpTool.h"

static AFHTTPSessionManager *manager;
static NSTimeInterval kTimeoutInterval = 20;
NSString *const RACAFNResponseObjectErrorKey = @"responseObject";
@implementation HttpTool

+ (AFHTTPSessionManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"deviceType"];//系统类型
        [manager.requestSerializer setValue:@"iPhone" forHTTPHeaderField:@"deviceBrand"];//手机品牌
        [manager.requestSerializer setValue:[CommonTool deviceName] forHTTPHeaderField:@"deviceModel"];//手机型号
        [manager.requestSerializer setValue:[CommonTool appVersion] forHTTPHeaderField:@"appVersion"];//应用版本号
        //设置证书模式
        if ([BaseUrl hasPrefix:@"https"]) {
            NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"chemanman" ofType:@"cer"];
            NSData* cerData = [NSData dataWithContentsOfFile:cerPath];
            AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
            [securityPolicy setAllowInvalidCertificates:YES];
            [securityPolicy setValidatesDomainName:NO];
            manager.securityPolicy = securityPolicy;
        }
    });
    
    YYReachability *reach = [YYReachability reachability];
    switch ([reach status]) {
        case YYReachabilityStatusNone:
            [manager.requestSerializer setValue:@"None" forHTTPHeaderField:@"network"];
            break;
        case YYReachabilityStatusWiFi:
            [manager.requestSerializer setValue:@"WIFI" forHTTPHeaderField:@"network"];
            break;
        case YYReachabilityStatusWWAN:
            [manager.requestSerializer setValue:[CommonTool networkType] forHTTPHeaderField:@"network"];
            break;
            
        default:
            break;
    }
    
    if ([UserDefaults getDataWithKey:@"Token"]) {
        [manager.requestSerializer setValue:[UserDefaults getDataWithKey:@"Token"] forHTTPHeaderField:@"token"];//应用版本号
    }
    return manager;
}

+ (void)getWithUrl:(NSString *)url paras:(id )paras success:(void(^)(ResultModel *result))success failure:(void(^)(NSError *error))failure{
    [[HttpTool shareManager] GET:url parameters:paras progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"url=%@ 请求回来的结果是%@",url,responseObject);
        [HttpTool parseResponseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"url=%@ 请求回来的结果是%@",url,error);
            [SVProgressHUD showMessageWithStatus:NoKnowError];
            failure([NSError errorWithDomain:NoKnowError code:-2 userInfo:nil]);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url paras:(id )paras success:(void(^)(ResultModel *result))success failure:(void(^)(NSError *error))failure{
    [[HttpTool shareManager] POST:url parameters:paras progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"url=%@ 请求回来的结果是%@",url,responseObject);
        [HttpTool parseResponseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"url=%@ 请求回来的结果是%@",url,error);
            [SVProgressHUD showMessageWithStatus:NoKnowError];
            failure([NSError errorWithDomain:NoKnowError code:-2 userInfo:nil]);
        }
    }];
}

+ (void)postFormDataWithUrl:(NSString *)url paras:(id )paras success:(void (^)(ResultModel *result))success failure:(void (^)(NSError *error))failure{
    manager = [HttpTool shareManager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSArray *images = paras[@"files"];
    [manager POST:url parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [HttpTool parseResponseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"url=%@ 请求回来的结果是%@",url,error);
            [SVProgressHUD showMessageWithStatus:NoKnowError];
            failure([NSError errorWithDomain:NoKnowError code:-2 userInfo:nil]);
        }
    }];
}

#pragma mark - 解析返回的结果信息
+(void)parseResponseObject:(id)response success:(void (^)(ResultModel * result))success failure:(void(^)(NSError *error))failure{
    if (response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[response objectForKey:@"code"] integerValue];
            NSString *msg = [response objectForKey:@"msg"];
            if (code == 200) { //代表有数据
                id data = [response objectForKey:@"data"];
                
                if ([data isKindOfClass:[NSNull class]]) {
                    data = nil;
                }
                ResultModel *resultModel = [[ResultModel alloc] init];
                resultModel.code = code;
                resultModel.message = msg;
                resultModel.data = data;
                if (success) {
                    success(resultModel);
                }
            }else if (code >= 400 && code < 500){
                [SVProgressHUD showMessageWithStatus:[CommonTool isNull:msg]?NoKnowError:msg];
                [UserDefaults removeWithKey:@"Token"];
                [UserInfoManager deleteUserInfo];
                BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
                [AppDelegate sharedAppDelegate].window.rootViewController = nv;
            }else {
                if (failure) {
                    [SVProgressHUD showMessageWithStatus:[CommonTool isNull:msg]?NoKnowError:msg];
                    failure([NSError errorWithDomain:[CommonTool isNull:msg]?NoKnowError:msg code:code userInfo:nil]);
                }
            }
        } else {
            if (failure) {
                [SVProgressHUD showMessageWithStatus:NoKnowError];
                failure([NSError errorWithDomain:NoKnowError code:-2 userInfo:nil]);
            }
        }
    } else {
        if (failure) {
            [SVProgressHUD showMessageWithStatus:NoKnowError];
            NSError * error= [NSError errorWithDomain:NoKnowError code:-1 userInfo:nil];
            failure(error);
        }
    }
}
@end
