//
//  UTCSLabsDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsDataSourceParser.h"
#import "UTCSLabMachine.h"

@implementation UTCSLabsDataSourceParser

- (NSDictionary *)parseValues:(NSDictionary *)values
{
    NSDictionary *third     = values[@"third"];
    NSDictionary *basement  = values[@"basement"];
    
    
    NSDictionary *thirdMachines      = [self parseDataFromDictionary:third withLabName:@"third"];
    NSDictionary *basementMachines   = [self parseDataFromDictionary:basement withLabName:@"basement"];
    
    return @{@"third" : thirdMachines,
             @"basement" : basementMachines};
}

- (NSDictionary *)parseDataFromDictionary:(NSDictionary *)dictionary withLabName:(NSString *)labName
{
    NSMutableDictionary *machines = [NSMutableDictionary new];
    
    for (NSString *machineName in dictionary) {
        NSDictionary *machineData = dictionary[machineName];
        UTCSLabMachine *machine = [UTCSLabMachine new];
        machine.lab             = @"third";
        machine.name            = machineName;
        machine.load            = [machineData[@"load"]floatValue];
        machine.occupied        = [machineData[@"occupied"]boolValue];
        machine.status          = machineData[@"status"];
        machine.uptime          = machineData[@"uptime"];
        machines[machineName] = machine;
    }
    
    return machines;
}

@end
