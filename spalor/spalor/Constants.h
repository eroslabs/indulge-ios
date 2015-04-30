//
//  Constants.h
//  spalor
//
//  Created by Manish on 30/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#ifndef spalor_Constants_h
#define spalor_Constants_h
#define DEBUGMODE

#ifdef DEBUGMODE
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

#define TIMEOUTINTERVAL 60
#define INDULGE_URL @"http://192.168.0.6/indulge"
#define INDULGE_API_VERSION 1.0
#define INDULGE_API_VERSION_STRING @"1.0"



#endif


