//
//  AppConstants.h
//  Travel
//
//  Created by 小涛 王 on 12-3-19.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//
//
// App dir struct 
// -----document--------download--------001_ZhHans_1.0.zip
//                |
//                |
//                 -----zip--------001_ZhHans_1.0.zip 
//                |
//                |
//                 -----cities--------1--------xxxx(这里的目录结构参考接口文档)
//                |           |
//                |           |
//                |            -------2--------xxxx
//                |  
//                 -----app---------app.dat
//                |           |
//                |           |
//                |            -----icon-------providedService-------xxx.icon
//                |                        |
//                |                        |
//                |                         ---recommendApp----------xxx.icon
//                |                        |
//                |                        |
//                |                         ---category--------------xxx.icon
//                |   
//                 -----help---------helpinfo.html
//                |   
//                 -----user---------favorite--------xxx.dat
//                            |
//                            |
//                             ------history---------xxx.dat


#ifndef Travel_AppConstants_h
#define Travel_AppConstants_h

#define FILENAME_OF_APP_DATA                @"app.dat"          // in bundle
#define FILENAME_OF_HELP_ZIP                @"help.zip"
//#define DEFAULT_CITY_ZIP                    @"1.zip"            //in bundle

#define DIR_OF_DOWNLOAD                     @"download"
#define DIR_OF_ZIP                          @"zip"   
#define DIR_OF_CITIES                       @"cities"
#define DIR_OF_APP                          @"app"
#define DIR_OF_HELP                         @"help"
#define DIR_OF_USER                         @"user"

#define DIR_OF_PROVIDED_SERVICE_ICON        @"app/icons/providedService"
#define DIR_OF_RECOMMENDED_APP_ICON         @"app/icons/recommendedApp/"
#define DIR_OF_CATEGORY_ICON                @"app/icons/category"

#define DIR_OF_FAVORITE                     @"app/user/favorite/"
#define DIR_OF_HISTORY                      @"app/user/history/"

// Under city dir, relative.
#define FLAG_OF_UNZIP_SUCCESS               @"unzip_success" 
#define FILENAME_OF_CITY_OVERVIEW_DATA      @"overview.dat"
#define FILENAME_OF_PACKAGE_DATA            @"package.dat"
#define DIR_OF_PLACE_DATA                   @"place/"
#define DIR_OF_GUIDE_DATA                   @"tips/guides/"
#define DIR_OF_ROUTE_DATA                   @"tips/routes/"

//
#define FAVORITE_PLACE_FILE         @"favorite_place.dat"
#define HISTORY_PLACE_FILE          @"history_place.dat"
#define PLACE_STORAGE_DEFAULT_DIR   @"save_place_data"

// Under help dir.
#define FILENAME_OF_HELP_HTML               @"helpinfo.html"

#define DEFAULT_CITY_ID                     1   // 1 for @"香港"
#define KEY_CURRENT_CITY                    @"current_city"

#define KEY_IS_SHOW_IMAGE                   @"KEY_IS_SHOW_IMAGE"

#define ALERT_USING_CELL_NEWORK 1
#define ALERT_DELETE_CITY 2

#define ALL_CATEGORY   (-1)

#endif
