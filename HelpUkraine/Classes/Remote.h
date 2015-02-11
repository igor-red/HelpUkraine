//
//  Remote.h
//  HelpUkraine
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 Igor Zhariy. All rights reserved.
//


// Macro for accessing remote files and their paths
#ifdef DEBUG
#define _webFilePrefix @"http://helpua.com.ua/appdata/debug"
#else
#define _webFilePrefix @"http://helpua.com.ua/appdata/production"
#endif
