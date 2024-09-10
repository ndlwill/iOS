//
//  main.m
//  Blocktest
//
//  Created by ws on 2020/4/2.
//

#import <Foundation/Foundation.h>

int main() {
    @autoreleasepool {
        void (^globalBlock)(void) = ^void {
        //            NSLog(@"%d", a);
        };
       NSLog(@"GlobalBlock is %@", globalBlock);
    }
    return 0;
}
