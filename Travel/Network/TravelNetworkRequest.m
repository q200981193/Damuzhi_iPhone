//
//  TravelNetworkRequest.m
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TravelNetworkRequest.h"
#import "StringUtil.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "UIDevice+IdentifierAddition.h"

@implementation TravelNetworkRequest

+ (CommonNetworkOutput*)sendRequest:(NSString*)baseURL
                constructURLHandler:(ConstructURLBlock)constructURLHandler
                    responseHandler:(TravelNetworkResponseBlock)responseHandler
                       outputFormat:(int)outputFormat
                             output:(CommonNetworkOutput*)output
{    
    
    
    
    NSURL* url = nil;    
    if (constructURLHandler != NULL)
        url = [NSURL URLWithString:[constructURLHandler(baseURL) stringByURLEncode]];
    else
        url = [NSURL URLWithString:baseURL];        
    
    if (url == nil){
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:NETWORK_TIMEOUT];
    
#ifdef DEBUG    
    int startTime = time(0);
    NSLog(@"[SEND] URL=%@", [url description]);    
#endif
    
    [request startSynchronous];
    //    BOOL *dataWasCompressed = [request isResponseCompressed]; // Was the response gzip compressed?
    //    NSData *compressedResponse = [request rawResponseData]; // Compressed data    
    //    NSData *uncompressedData = [request responseData]; // Uncompressed data
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
#ifdef DEBUG    
    NSLog(@"[RECV] : status=%d, error=%@", [request responseStatusCode], [error description]);
#endif    
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        output.resultCode = statusCode;
    }
    else{

#ifdef DEBUG
        int endTime = time(0);
        NSLog(@"[RECV] data (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)", 
              [[request responseData] length], (endTime - startTime),
              [[request rawResponseData] length], [[request responseData] length]);
#endif         

        if (outputFormat == FORMAT_TRAVEL_PB){
            responseHandler(nil, [request responseData], output.resultCode);                   
        }
        else{
            NSString *text = [request responseString];
            NSDictionary *jsonDictionary = nil;
            output.textData = text;
            if ([text length] > 0){   
                jsonDictionary = [text JSONValue];
            }
#ifdef DEBUG
            NSLog(@"[RECV] JSON string data : %@", text);
#endif            

            responseHandler(jsonDictionary, nil, output.resultCode);       
        }

        
        
        
        return output;
        
    }
    
    return output;
}

+ (CommonNetworkOutput*)registerUser:(int)type token:(NSString*)deviceToken
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        NSString* deviceId = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
        
        str = [str stringByAddQueryParameter:PARA_TRAVEL_TYPE intValue:type];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DEVICE_TOKEN value:deviceToken];
        str = [str stringByAddQueryParameter:PARA_TRAVEL_DEVICE_ID value:deviceId];
        
        return str;
    };
    
    TravelNetworkResponseBlock responseHandler = ^(NSDictionary* jsonDictionary, NSData* data, int resultCode) {  
        
        
        return;
    };
    
    return [TravelNetworkRequest sendRequest:URL_TRAVEL_REGISTER_USER
                         constructURLHandler:constructURLHandler                         
                             responseHandler:responseHandler         
                                outputFormat:FORMAT_TRAVEL_JSON
                                      output:output];
}

@end
