//
//  saveData.h
//  sol1
//
//  Created by F T on 30/05/2015.
//  Copyright (c) 2015 F T. All rights reserved.
//

#ifndef sol1_saveData_h
#define sol1_saveData_h


/*

http://www.accella.net/nsuserdefaults-some-pretty-good-practices/

[[NSUserDefaults standardUserDefaults] setObject:@"GreatPlayer" forKey:@"displayName"];
[[NSUserDefaults standardUserDefaults] setInteger:31415962 forKey:@"level1Score"];
[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"level1completed"];



SString* name = [[NSUserDefaults standardUserDefaults] stringForKey:@"displayName"];
NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:@"level1Score"];
BOOL completed = [[NSUserDefaults standardUserDefaults] boolForKey:@"level1compelted"];





Many coders write something like the above in the app delegate file in the application:didFinishLaunchingWithOptions: method. They will check to see if all the default preference values have been set, and if not, set them. This isn’t necessarily a bad approach, but there is a better approach fully supported by NSUserDefaults.

NSUserDefaults has a method called registerDefaults: that takes an NSDictionary of key-value pairs as a parameter. It will then use those key-value pairs to create an in-memory representation of default values for all those preferences and store them in the registration domain of the defaults system. Continuing the above example, we could code the following in the app delegate file in the application:didFinishLaunchingWithOptions: method.

*/


#endif
