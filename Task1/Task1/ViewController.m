//
//  ViewController.m
//  Task1
//
//  Created by chublix on 1/28/16.
//  Copyright (c) 2016 Elena Chekhova. All rights reserved.
//

#import "ViewController.h"
#define magic_number 79

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *numbersData;
@property (nonatomic, strong) NSDecimalNumber *previous;
@property (nonatomic, strong) NSDecimalNumber *number;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numbersData = [[NSMutableArray alloc] init];
    self.previous = [[NSDecimalNumber alloc] initWithInteger:0];
    self.number = [[NSDecimalNumber alloc] initWithInteger:1];
    self.index = 2;
    self.count = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self calcFibonacci];
}

- (void) calcFibonacci {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        while (self.count < magic_number) {
            NSDecimalNumber *new = [self.number decimalNumberByAdding:self.previous];
            self.previous = self.number;
            self.number = new;
            self.index++;
            if (self.index == 10) {
                self.index = 0;
                self.count++;
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.tableView beginUpdates];
                    [self.numbersData addObject:new];
                    NSInteger row = self.numbersData.count - 1;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                    
                });
            }
        }
    });
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numbersData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.numbersData objectAtIndex:indexPath.row] stringValue];
    return cell;
}

@end
