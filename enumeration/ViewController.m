//
//  ViewController.m
//  enumeration
//
//  Created by Christian Menschel on 21/01/15.
//  Copyright (c) 2015 Christian Menschel. All rights reserved.
//

#import "ViewController.h"

static const NSUInteger kIterations = 3000000;
static const NSString *kString = @"I am a super Test string";

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [self createButtonWithTitle:@"For Loop" selector:@selector(runForLoop)];
    UIButton *button2 = [self createButtonWithTitle:@"Fast Enumeration" selector:@selector(runFastEnumeration)];
    UIButton *button3 = [self createButtonWithTitle:@"EnumerationWithBlock" selector:@selector(runEnumerationWithBlock)];
    UIButton *button4 = [self createButtonWithTitle:@"ObjectEnumerator" selector:@selector(runObjectEnumerator)];
    UIButton *button5 = [self createButtonWithTitle:@"ConcurrentEnumeration" selector:@selector(runConcurrentEnumeration)];
    UIButton *button6 = [self createButtonWithTitle:@"MakeObjectsPerformSelector" selector:@selector(runMakeObjectsPerformSelector)];
    UIButton *button7 = [self createButtonWithTitle:@"Run All" selector:@selector(runAll)];
    
    CGFloat top = 80.0;
    CGFloat height = 40.0;
    CGFloat width = self.view.bounds.size.width;
    CGFloat padding = 20.0;

    button1.frame = CGRectMake(0, top, width, height);
    button2.frame = CGRectMake(0, CGRectGetMaxY(button1.frame) + padding, width, height);
    button3.frame = CGRectMake(0, CGRectGetMaxY(button2.frame) + padding, width, height);
    button4.frame = CGRectMake(0, CGRectGetMaxY(button3.frame) + padding, width, height);
    button5.frame = CGRectMake(0, CGRectGetMaxY(button4.frame) + padding, width, height);
    button6.frame = CGRectMake(0, CGRectGetMaxY(button5.frame) + padding, width, height);
    button7.frame = CGRectMake(0, CGRectGetMaxY(button6.frame) + 2 * padding, width, height);
}

- (UIButton *)createButtonWithTitle:(NSString *)title selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:button];
    
    return button;
}

- (void)runAll {
    [self runForLoop];
    [self runFastEnumeration];
    [self runEnumerationWithBlock];
    [self runObjectEnumerator];
    [self runConcurrentEnumeration];
    [self runMakeObjectsPerformSelector];
    NSLog(@"=============================================");
}

- (void)runForLoop {
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < kIterations; i++) {
        [data addObject:kString];
    }
    NSDate *startDate = [NSDate date];
    for (int i = 0; i < [data count]; i++) {
        [(NSString *)data[i] uppercaseString];
    }
    NSLog(@"for loop  %f seconds",[[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void)runFastEnumeration {
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < kIterations; i++) {
        [data addObject:kString];
    }
    NSDate *startDate = [NSDate date];
    for (NSString *string in data) {
        [string uppercaseString];
    }
    NSLog(@"fast enumeration  %f seconds",[[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void)runEnumerationWithBlock {
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < kIterations; i++) {
        [data addObject:kString];
    }
    NSDate *startDate = [NSDate date];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(NSString *)obj uppercaseString];
    }];
    NSLog(@"enumerateObjectsUsingBlock  %f seconds",[[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void)runObjectEnumerator {
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < kIterations; i++) {
        [data addObject:kString];
    }
    NSDate *startDate = [NSDate date];
    NSEnumerator *enumerator = [data objectEnumerator];
    id obj = nil;
    while (obj = [enumerator nextObject]) {
        [(NSString *)obj uppercaseString];
    };
    NSLog(@"ObjectEnumerator  %f seconds",[[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void)runConcurrentEnumeration {
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < kIterations; i++) {
        [data addObject:kString];
    }
    NSDate *startDate = [NSDate date];
    [data enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(NSString *)obj uppercaseString];
    }];
    NSLog(@"NSEnumerationConcurrent  %f seconds",[[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void)runMakeObjectsPerformSelector {
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < kIterations; i++) {
        [data addObject:kString];
    }
    NSDate *startDate = [NSDate date];
    [data makeObjectsPerformSelector:@selector(uppercaseString)];
    NSLog(@"makeObjectsPerformSelector  %f seconds",[[NSDate date] timeIntervalSinceDate:startDate]);
}

@end
