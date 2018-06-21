//
//  ContactsAuthority.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/15.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "ContactsAuthority.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@implementation ContactsAuthority

+ (BOOL)authorized
{
//    [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//
//    }];
    
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//        
//    });
    
    if (@available(iOS 9.0, *)) {
        return ([self authorizationStatus] == CNAuthorizationStatusAuthorized);
    } else {
        return ([self authorizationStatus] == kABAuthorizationStatusAuthorized);
    }
}

+ (NSInteger)authorizationStatus
{
    if (@available(iOS 9.0, *)) {
        return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    } else {
        return ABAddressBookGetAuthorizationStatus();
    }
}

+ (void)authorizeWithCompletion:(void (^)(BOOL granted))completion
{
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES);
                }
            }
                break;
            case CNAuthorizationStatusDenied:
            case CNAuthorizationStatusRestricted:
            {
                if (completion) {
                    completion(NO);
                }
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(granted);
                        }
                    });
                }];
            }
                break;
            default:
                break;
        }
    } else {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES);
                }
            }
                break;
            case kABAuthorizationStatusDenied:
            case kABAuthorizationStatusRestricted:
            {
                if (completion) {
                    completion(NO);
                }
            }
                break;
            case kABAuthorizationStatusNotDetermined:
            {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(granted);
                        }
                    });
                });
            }
                break;
            default:
                break;
        }
    }
}

@end
