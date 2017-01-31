//
//  NSUserDefaults+Helpers.h

//
//  Created by Reejo Samuel on 8/2/13.
//  Copyright (c) 2013 Reejo Samuel | m[at]reejosamuel.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Helpers)

/* convenience method to save a given object for a given key */
+ (void)saveObject:(id)object forKey:(NSString *)key;

/* convenience method to return an object for a given key */
+ (id)retrieveObjectForKey:(NSString *)key;

/* convenience method to delete a value for a given key */
+ (void)deleteObjectForKey:(NSString *)key;

@end
