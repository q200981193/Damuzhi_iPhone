//
//  TravelNetworkConstants.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Travel_TravelNetworkConstants_h
#define Travel_TravelNetworkConstants_h

// URL
#define URL_TRAVEL_REGISTER_USER    @"http://damuzhi.com/service/registerUser?"
//query place list
#define URL_TRAVEL_QUERY_LIST        @"http://59.34.17.68:8012/service/queryList.aspx?"

// Output Format
#define FORMAT_TRAVEL_JSON          1
#define FORMAT_TRAVEL_PB            2   // protocol buffer


// request & reponse parameters (HTTP / JSON)
#define PARA_TRAVEL_USER_ID         @"userId"
#define PARA_TRAVEL_TYPE            @"type"
#define PARA_TRAVEL_DEVICE_TOKEN    @"deviceToken"
#define PARA_TRAVEL_RESULT          @"result"
#define PARA_TRAVEL_DEVICE_ID       @"deviceId"

#define PARA_TRAVEL_CITY_ID         @"cityId"
#define PARA_TRAVEL_LANG            @"lang"

// error codes
#define ERROR_TRAVEL_SUCCESS        0

#endif