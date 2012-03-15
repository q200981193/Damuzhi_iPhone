//
//  TravelNetworkConstants.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Travel_TravelNetworkConstants_h
#define Travel_TravelNetworkConstants_h

// languag 
#define LANGUAGE_SIMPLIFIED_CHINESE     1
#define LANGUAGE_TRADITIONAL_CHINESE    2 
#define LANGUAGE_ENGLISH                3

// URL
#define URL_TRAVEL_REGISTER_USER    @"http://damuzhi.com/service/registerUser?"
//query place list
#define URL_TRAVEL_QUERY_LIST       @"http://59.34.17.68:8012/service/queryList.aspx?"
#define URL_TRAVEL_QUERY_OBJECT     @"http://59.34.17.68:8012/service/queryObject.aspx?"

// Output Format
#define FORMAT_TRAVEL_JSON          1
#define FORMAT_TRAVEL_PB            2   // protocol buffer


// request & reponse parameters (HTTP / JSON)
#define PARA_TRAVEL_USER_ID         @"userId"
#define PARA_TRAVEL_TYPE            @"type"
#define PARA_TRAVEL_DEVICE_TOKEN    @"deviceToken"
#define PARA_TRAVEL_RESULT          @"result"
#define PARA_TRAVEL_DEVICE_ID       @"deviceId"
#define PARA_TRAVEL_ID              @"id"

#define PARA_TRAVEL_CITY_ID         @"cityId"
#define PARA_TRAVEL_LANG            @"lang"

// define query object type
#define OBJECT_TYPE_ALL_PLACE       1
#define OBJECT_TYPE_SPOT            21
#define OBJECT_TYPE_HOTEL           22
#define OBJECT_TYPE_RESTAURANT      23
#define OBJECT_TYPE_SHOPPING        24
#define OBJECT_TYPE_ENTERTAINMENT   25

#define OBJECT_TYPE_CITY_OVERVIEW   2
#define OBJECT_TYPE_CITY_TRAFFIC    3
#define OBJECT_TYPE_USEFUL_INFO            4
#define OBJECT_TYPE_TRAVEL_GUIDE    5
#define OBJECT_TYPE_TOURIST_RECOMMENDED      6

#define OBJECT_TYPE_APP_DATA        10


// error codes
#define ERROR_TRAVEL_SUCCESS        0

#endif
