//
//  MASTaskObject.h
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MASTaskObject : NSObject


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL completion;


/// Custom Designated Initializer
-(id)initWithData:(NSDictionary *)data;

@end
