//
//  sendViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface selectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ABPersonViewControllerDelegate> {
    ABAddressBookRef addressBook;							//!< Reference of local AddressBook
    __weak NSMutableArray *list;                             //!< List of contacts
    __weak NSMutableArray *filteredListContent;              //!< List of contacts, filtered
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) NSMutableArray *list;
@property (weak, nonatomic) NSMutableArray *filteredListContent;
@property (weak, nonatomic) IBOutlet UILabel *recipientNameText;
@property (weak, nonatomic) IBOutlet UILabel *recipientPhoneText;

@end
