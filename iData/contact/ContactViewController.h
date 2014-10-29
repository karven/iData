//
//  ContactViewController.h
//  iData
//
//  Created by karven on 7/30/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Util.h"
#import "BaseViewController.h"

@interface ContactViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) NSMutableDictionary *contactDictionary;
@property(nonatomic,retain) NSArray *keyArray;
@property(nonatomic,retain) UITableView *contactTable;

@end
