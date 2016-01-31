//
//  ViewController.m
//  Task2
//
//  Created by chublix on 1/31/16.
//  Copyright (c) 2016 Chekhova Elena. All rights reserved.
//

#import "ViewController.h"
#define magic_number 79

@interface ViewController ()
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self calcFibonacci];
}

- (void) calcFibonacci {
   NSBlockOperation *calcOperation = [NSBlockOperation blockOperationWithBlock:^{
        while (self.count < magic_number) {
            NSDecimalNumber *new = [self.number decimalNumberByAdding:self.previous];
            self.previous = self.number;
            self.number = new;
            self.index++;
            if (self.index == 10) {
                self.count++;
                self.index = 0;
                NSBlockOperation *updateOperation = [NSBlockOperation blockOperationWithBlock:^{
                    [self.tableView beginUpdates];
                    [self.numbersData addObject:new];
                    NSInteger row = self.numbersData.count - 1;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                }];
                updateOperation.qualityOfService = NSQualityOfServiceUserInteractive;
                updateOperation.queuePriority = NSOperationQueuePriorityHigh;
                [[NSOperationQueue mainQueue] addOperation:updateOperation];
                
            }
        }
    }];
    calcOperation.qualityOfService = NSQualityOfServiceBackground;
    calcOperation.queuePriority = NSOperationQueuePriorityLow;
    [[NSOperationQueue mainQueue] addOperation: calcOperation];
    
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
