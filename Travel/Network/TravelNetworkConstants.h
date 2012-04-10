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

// for test service
#define URL_SERVICE                 @"http://59.34.17.68:8012/service/"

// for formal service
//#define URL_SERVICE                 @"http://api.trip8888.com/service/"


// URL
#define URL_TRAVEL_REGISTER_USER    (URL_SERVICE@"RegisterUser.aspx?")

//query place list
#define URL_TRAVEL_QUERY_LIST       (URL_SERVICE@"queryList.aspx?")
#define URL_TRAVEL_QUERY_OBJECT     (URL_SERVICE@"queryObject.aspx?")

#define URL_TRAVEL_ADD_FAVORITE     (URL_SERVICE@"addFavorite.aspx?")

#define URL_TRAVEL_DELETE_FAVORITE  (URL_SERVICE@"deleteFavorite.aspx?") 
#define URL_TRAVEL_QUERY_PLACE      (URL_SERVICE@"queryPlace.aspx?") 

#define URL_TRAVEL_QUERY_VERSION    (URL_SERVICE@"iphoneVersion.txt")

#define URL_TRAVEL_SUBMIT_FEEKBACK  (URL_SERVICE@"feedback.aspx?")


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

#define PARA_TRAVEL_CONTACT         @"contact"
#define PARA_TRAVEL_CONTENT         @"content"

#define PARA_TRAVEL_CITY_ID         @"cityId"
#define PARA_TRAVEL_ID              @"id"
#define PARA_TRAVEL_LANG            @"lang"

#define PARA_TRAVEL_PLACEID         @"placeId"
#define PARA_TRAVEL_LONGITUDE       @"longitude"
#define PARA_TRAVEL_LATITUDE        @"latitude"

#define PARA_TRAVEL_PLACE_FAVORITE_COUNT  @"placeFavoriteCount"
#define PARA_TRAVEL_APP_VERSION           @"app_version"
#define PARA_TRAVEL_APP_DATA_VERSION      @"app_data_version"

// define query object type
// for place
#define OBJECT_TYPE_ALL_PLACE       1
#define OBJECT_TYPE_SPOT            21
#define OBJECT_TYPE_HOTEL           22
#define OBJECT_TYPE_RESTAURANT      23
#define OBJECT_TYPE_SHOPPING        24
#define OBJECT_TYPE_ENTERTAINMENT   25

// for top favorite
#define OBJECT_TYPE_TOP_FAVORITE_ALL                40
#define OBJECT_TYPE_TOP_FAVORITE_SPOT               41
#define OBJECT_TYPE_TOP_FAVORITE_HOTEL              42
#define OBJECT_TYPE_TOP_FAVORITE_RESTAURANT         43
#define OBJECT_TYPE_TOP_FAVORITE_SHOPPING           44
#define OBJECT_TYPE_TOP_FAVORITE_ENTERTAINMENT      45

// for city overview
#define OBJECT_TYPE_CITY_BASIC                  2
#define OBJECT_TYPE_CITY_CONFIG                 3
#define OBJECT_TYPE_TRAVEL_TRANSPORTATION       4     
#define OBJECT_TYPE_TRAVEL_UTILITY              5
#define OBJECT_TYPE_TRAVEL_GUIDE                6
#define OBJECT_TYPE_TOURIST_RECOMMENDED         7
#define OBJECT_TYPE_HELP_INOF                   8

// for app
#define OBJECT_TYPE_APP_DATA        10


// error codes
#define ERROR_TRAVEL_SUCCESS        0

#endif
