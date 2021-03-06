// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class CityImage;
@class CityImageList;
@class CityImageList_Builder;
@class CityImage_Builder;
@class CityOverview;
@class CityOverview_Builder;
@class CommonOverview;
@class CommonOverview_Builder;
typedef enum {
  CommonOverviewTypeCityBasic = 1,
  CommonOverviewTypeTravelPrepration = 2,
  CommonOverviewTypeTravelUtility = 3,
  CommonOverviewTypeTravelTransportation = 4,
} CommonOverviewType;

BOOL CommonOverviewTypeIsValidValue(CommonOverviewType value);


@interface CityOverviewRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface CommonOverview : PBGeneratedMessage {
@private
  BOOL hasHtml_:1;
  NSString* html;
  NSMutableArray* mutableImagesList;
}
- (BOOL) hasHtml;
@property (readonly, retain) NSString* html;
- (NSArray*) imagesList;
- (NSString*) imagesAtIndex:(int32_t) index;

+ (CommonOverview*) defaultInstance;
- (CommonOverview*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommonOverview_Builder*) builder;
+ (CommonOverview_Builder*) builder;
+ (CommonOverview_Builder*) builderWithPrototype:(CommonOverview*) prototype;

+ (CommonOverview*) parseFromData:(NSData*) data;
+ (CommonOverview*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommonOverview*) parseFromInputStream:(NSInputStream*) input;
+ (CommonOverview*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommonOverview*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommonOverview*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommonOverview_Builder : PBGeneratedMessage_Builder {
@private
  CommonOverview* result;
}

- (CommonOverview*) defaultInstance;

- (CommonOverview_Builder*) clear;
- (CommonOverview_Builder*) clone;

- (CommonOverview*) build;
- (CommonOverview*) buildPartial;

- (CommonOverview_Builder*) mergeFrom:(CommonOverview*) other;
- (CommonOverview_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommonOverview_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) imagesList;
- (NSString*) imagesAtIndex:(int32_t) index;
- (CommonOverview_Builder*) replaceImagesAtIndex:(int32_t) index with:(NSString*) value;
- (CommonOverview_Builder*) addImages:(NSString*) value;
- (CommonOverview_Builder*) addAllImages:(NSArray*) values;
- (CommonOverview_Builder*) clearImagesList;

- (BOOL) hasHtml;
- (NSString*) html;
- (CommonOverview_Builder*) setHtml:(NSString*) value;
- (CommonOverview_Builder*) clearHtml;
@end

@interface CityOverview : PBGeneratedMessage {
@private
  BOOL hasCityBasic_:1;
  BOOL hasTravelPrepration_:1;
  BOOL hasTravelUtility_:1;
  BOOL hasTravelTransportation_:1;
  CommonOverview* cityBasic;
  CommonOverview* travelPrepration;
  CommonOverview* travelUtility;
  CommonOverview* travelTransportation;
}
- (BOOL) hasCityBasic;
- (BOOL) hasTravelPrepration;
- (BOOL) hasTravelUtility;
- (BOOL) hasTravelTransportation;
@property (readonly, retain) CommonOverview* cityBasic;
@property (readonly, retain) CommonOverview* travelPrepration;
@property (readonly, retain) CommonOverview* travelUtility;
@property (readonly, retain) CommonOverview* travelTransportation;

+ (CityOverview*) defaultInstance;
- (CityOverview*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CityOverview_Builder*) builder;
+ (CityOverview_Builder*) builder;
+ (CityOverview_Builder*) builderWithPrototype:(CityOverview*) prototype;

+ (CityOverview*) parseFromData:(NSData*) data;
+ (CityOverview*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityOverview*) parseFromInputStream:(NSInputStream*) input;
+ (CityOverview*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityOverview*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CityOverview*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CityOverview_Builder : PBGeneratedMessage_Builder {
@private
  CityOverview* result;
}

- (CityOverview*) defaultInstance;

- (CityOverview_Builder*) clear;
- (CityOverview_Builder*) clone;

- (CityOverview*) build;
- (CityOverview*) buildPartial;

- (CityOverview_Builder*) mergeFrom:(CityOverview*) other;
- (CityOverview_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CityOverview_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCityBasic;
- (CommonOverview*) cityBasic;
- (CityOverview_Builder*) setCityBasic:(CommonOverview*) value;
- (CityOverview_Builder*) setCityBasicBuilder:(CommonOverview_Builder*) builderForValue;
- (CityOverview_Builder*) mergeCityBasic:(CommonOverview*) value;
- (CityOverview_Builder*) clearCityBasic;

- (BOOL) hasTravelPrepration;
- (CommonOverview*) travelPrepration;
- (CityOverview_Builder*) setTravelPrepration:(CommonOverview*) value;
- (CityOverview_Builder*) setTravelPreprationBuilder:(CommonOverview_Builder*) builderForValue;
- (CityOverview_Builder*) mergeTravelPrepration:(CommonOverview*) value;
- (CityOverview_Builder*) clearTravelPrepration;

- (BOOL) hasTravelUtility;
- (CommonOverview*) travelUtility;
- (CityOverview_Builder*) setTravelUtility:(CommonOverview*) value;
- (CityOverview_Builder*) setTravelUtilityBuilder:(CommonOverview_Builder*) builderForValue;
- (CityOverview_Builder*) mergeTravelUtility:(CommonOverview*) value;
- (CityOverview_Builder*) clearTravelUtility;

- (BOOL) hasTravelTransportation;
- (CommonOverview*) travelTransportation;
- (CityOverview_Builder*) setTravelTransportation:(CommonOverview*) value;
- (CityOverview_Builder*) setTravelTransportationBuilder:(CommonOverview_Builder*) builderForValue;
- (CityOverview_Builder*) mergeTravelTransportation:(CommonOverview*) value;
- (CityOverview_Builder*) clearTravelTransportation;
@end

@interface CityImageList : PBGeneratedMessage {
@private
  NSMutableArray* mutableCityImagesList;
}
- (NSArray*) cityImagesList;
- (CityImage*) cityImagesAtIndex:(int32_t) index;

+ (CityImageList*) defaultInstance;
- (CityImageList*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CityImageList_Builder*) builder;
+ (CityImageList_Builder*) builder;
+ (CityImageList_Builder*) builderWithPrototype:(CityImageList*) prototype;

+ (CityImageList*) parseFromData:(NSData*) data;
+ (CityImageList*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityImageList*) parseFromInputStream:(NSInputStream*) input;
+ (CityImageList*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityImageList*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CityImageList*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CityImageList_Builder : PBGeneratedMessage_Builder {
@private
  CityImageList* result;
}

- (CityImageList*) defaultInstance;

- (CityImageList_Builder*) clear;
- (CityImageList_Builder*) clone;

- (CityImageList*) build;
- (CityImageList*) buildPartial;

- (CityImageList_Builder*) mergeFrom:(CityImageList*) other;
- (CityImageList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CityImageList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) cityImagesList;
- (CityImage*) cityImagesAtIndex:(int32_t) index;
- (CityImageList_Builder*) replaceCityImagesAtIndex:(int32_t) index with:(CityImage*) value;
- (CityImageList_Builder*) addCityImages:(CityImage*) value;
- (CityImageList_Builder*) addAllCityImages:(NSArray*) values;
- (CityImageList_Builder*) clearCityImagesList;
@end

@interface CityImage : PBGeneratedMessage {
@private
  BOOL hasCityImageId_:1;
  BOOL hasPriceCount_:1;
  BOOL hasUrl_:1;
  BOOL hasIntroduce_:1;
  BOOL hasDetail_:1;
  int32_t cityImageId;
  int32_t priceCount;
  NSString* url;
  NSString* introduce;
  NSString* detail;
}
- (BOOL) hasCityImageId;
- (BOOL) hasUrl;
- (BOOL) hasIntroduce;
- (BOOL) hasPriceCount;
- (BOOL) hasDetail;
@property (readonly) int32_t cityImageId;
@property (readonly, retain) NSString* url;
@property (readonly, retain) NSString* introduce;
@property (readonly) int32_t priceCount;
@property (readonly, retain) NSString* detail;

+ (CityImage*) defaultInstance;
- (CityImage*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CityImage_Builder*) builder;
+ (CityImage_Builder*) builder;
+ (CityImage_Builder*) builderWithPrototype:(CityImage*) prototype;

+ (CityImage*) parseFromData:(NSData*) data;
+ (CityImage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityImage*) parseFromInputStream:(NSInputStream*) input;
+ (CityImage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CityImage*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CityImage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CityImage_Builder : PBGeneratedMessage_Builder {
@private
  CityImage* result;
}

- (CityImage*) defaultInstance;

- (CityImage_Builder*) clear;
- (CityImage_Builder*) clone;

- (CityImage*) build;
- (CityImage*) buildPartial;

- (CityImage_Builder*) mergeFrom:(CityImage*) other;
- (CityImage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CityImage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCityImageId;
- (int32_t) cityImageId;
- (CityImage_Builder*) setCityImageId:(int32_t) value;
- (CityImage_Builder*) clearCityImageId;

- (BOOL) hasUrl;
- (NSString*) url;
- (CityImage_Builder*) setUrl:(NSString*) value;
- (CityImage_Builder*) clearUrl;

- (BOOL) hasIntroduce;
- (NSString*) introduce;
- (CityImage_Builder*) setIntroduce:(NSString*) value;
- (CityImage_Builder*) clearIntroduce;

- (BOOL) hasPriceCount;
- (int32_t) priceCount;
- (CityImage_Builder*) setPriceCount:(int32_t) value;
- (CityImage_Builder*) clearPriceCount;

- (BOOL) hasDetail;
- (NSString*) detail;
- (CityImage_Builder*) setDetail:(NSString*) value;
- (CityImage_Builder*) clearDetail;
@end

