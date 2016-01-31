//
//  ViewController.m
//  Task3
//
//  Created by chublix on 1/31/16.
//  Copyright (c) 2016 Chekhova Elena. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *logTextVIew;
@property (nonatomic, strong) NSArray *imagesURL;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesURL = @[@"http://lorempixel.com/image_output/animals-q-c-1920-1080-1.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-2.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-3.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-4.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-5.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-6.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-7.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-8.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-9.jpg",
                       @"http://lorempixel.com/image_output/animals-q-c-1920-1080-10.jpg"];
    
}

- (IBAction)test1ButtonTouch:(id)sender {
    self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString:@"Start Test 1 \n"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double fullTime = 0.0;
        for (int i = 0; i < self.imagesURL.count; i++) {
            NSString *strURL = [self.imagesURL objectAtIndex:i];
            NSURL *url = [NSURL URLWithString:strURL];
            NSDate *startDate = [NSDate date];
            NSData *data = [NSData dataWithContentsOfURL: url];
            NSDate *endDate = [NSDate date];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithData:data];
            });
            double diffTime = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *message = [NSString stringWithFormat:@"Image %d is loaded for: %.3f seconds \n", i+1, diffTime];
               self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: message];
            });
            fullTime += diffTime;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"Full time is: %.3f seconds \n", fullTime];
            self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: message];
            self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString:@"Test 1 finished \n"];
        });

    });
}

- (void) test2WithType:(NSInteger) type name:(NSString *) name {
   self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: [NSString stringWithFormat:@"Start %@ \n", name]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block double fullTime =0.0;
        __block int imagesLoadedCount = 0;
        
        for (int i = 0; i < self.imagesURL.count; i++) {
          dispatch_async(dispatch_get_global_queue(type, 0), ^{
              NSString *strURL = [self.imagesURL objectAtIndex:i];
              NSURL *url = [NSURL URLWithString:strURL];
              NSDate *startDate = [NSDate date];
              NSData *data = [NSData dataWithContentsOfURL: url];
              NSDate *endDate = [NSDate date];
              dispatch_async(dispatch_get_main_queue(), ^{
                  self.imageView.image = [UIImage imageWithData:data];
              });
              double diffTime = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970;
              fullTime += diffTime;
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSString *message = [NSString stringWithFormat:@"Image %d is loaded for: %.3f seconds \n", i+1, diffTime];
                  self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: message];
                  imagesLoadedCount++;
                  if (imagesLoadedCount == self.imagesURL.count) {
                      NSString *endMessage = [NSString stringWithFormat:@"Full time is: %.3f seconds \n", fullTime];
                      self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: endMessage];
                      self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: [NSString stringWithFormat:@"%@ Finished \n", name]];
                  }
              });

              
              
          });
        };
    });
}
- (IBAction)test21ButtonTouch:(id)sender {
    [self test2WithType:DISPATCH_QUEUE_PRIORITY_BACKGROUND name:@"Test 2 (Background)"];
}

- (IBAction)test22ButtonTouch:(id)sender {
    [self test2WithType:DISPATCH_QUEUE_PRIORITY_HIGH name:@"Test 2 (High)"];
}

- (IBAction)test3ButtonTouch:(id)sender {
    self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString:@"Start Test 3 \n"];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue setMaxConcurrentOperationCount:2];
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    NSBlockOperation *lastOdd = nil;
    NSBlockOperation *lastEven = nil;
    __block int imagesLoadedCount = 0;
    __block double fullTime = 0.0;
    for (int i = 0; i < self.imagesURL.count; i++) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSString *strURL = [self.imagesURL objectAtIndex:i];
            NSURL *url = [NSURL URLWithString:strURL];
            NSDate *startDate = [NSDate date];
            NSData *data = [NSData dataWithContentsOfURL: url];
            NSDate *endDate = [NSDate date];
            self.imageView.image = [UIImage imageWithData:data];
            double diffTime = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970;
            fullTime += diffTime;
            imagesLoadedCount++;
            NSString *message = [NSString stringWithFormat:@"Image %d is loaded for: %.3f seconds \n", i+1, diffTime];
            self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: message];
            if (imagesLoadedCount == self.imagesURL.count) {
                NSString *endMessage = [NSString stringWithFormat:@"Full time is: %.3f seconds \n", fullTime];
                self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: endMessage];
                self.logTextVIew.text = [self.logTextVIew.text stringByAppendingString: @"Test 3 finished \n"];
            }

        }];
        if ((i + 1) % 2 == 0) {
            if (lastEven) {
                [operation addDependency: lastEven];
            }
            lastEven = operation;
        } else {
            if (lastOdd) {
                [operation addDependency:lastOdd];
            }
            lastOdd = operation;
        }
        operation.qualityOfService = NSQualityOfServiceBackground;
        operation.queuePriority = NSOperationQueuePriorityLow;
        [operations addObject:operation];
    }
    [queue addOperations:operations waitUntilFinished:NO];
}
@end
