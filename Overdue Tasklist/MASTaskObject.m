//
//  MASTaskObject.m
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "MASTaskObject.h"

@implementation MASTaskObject

/// Over-riding the initializer and passing to the new designated init
-(id)init
{
    self = [self initWithData:nil];
    return self;
}

/// Custom Designated Initializer
-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.title = data[TASK_NAME];
    self.detail = data[TASK_DETAIL];
    self.date = data[TASK_DATE];
    self.completion = [data[TASK_COMPLETION]boolValue];
    
    return self;
}

@end
