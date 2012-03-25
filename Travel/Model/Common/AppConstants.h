//
//  AppConstants.h
//  Travel
//
//  Created by 小涛 王 on 12-3-19.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

// App dir struct 
// -----document--------download--------001_ZhHans_1.0.zip
//                |
//                |
//                 -----zip--------001_ZhHans_1.0.zip 
//                |
//                |
//                 -----city--------1--------data--------overview.dat
//                            |
//                            |
//                            ------2--------data--------


#ifndef Travel_AppConstants_h
#define Travel_AppConstants_h

#define DIR_OF_APP                          @"app"
#define DIR_OF_ZIP                          @"zip"   
#define DIR_OF_CITY                         @"cities"
#define DIR_OF_DOWNLOAD                     @"download"

#define DEFAULT_CITY_ZIP                    @"1.zip"     //in bundle
#define FLAG_OF_UNZIP_SUCCESS               @"unzip_success" 
    
#define FILENAME_OF_CITY_OVERVIEW_DATA      @"data/overview.dat"
#define FILENAME_OF_PACKAGE_DATA            @"data/package.dat"
#define FILENAME_OF_APP_DATA                @"app.dat"
#define DIR_OF_PLACE_DATA                   @"data/place"
#define DIR_OF_TIPS_DATA                    @"data/tips"

#define DIR_OF_PROVIDED_SERVICE_IMAGE       @"app/image/providedService"
#define DIR_OF_CATEGORY_IMAGE               @"app/image/category"

#define DEFAULT_CITY_ID                     1   // 1 for @"香港"
#define DEFAULT_CITY_NAME                   NSLS(@"香港")
#define KEY_CURRENT_CITY                    @"current_city"

#endif
