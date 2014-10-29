//
//  ContactBackupViewController.h
//  iData
//
//  Created by karven on 9/25/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "ThemeLabel.h"
#import "UIFactory.h"
#import "Util.h"
#import "UIView+Toast.h"
#import "FTPManager.h"
#import "MBProgressHUD.h"

typedef enum{
    Backup_To,
    Backup_From,
    Backup_Local_Number,
    Backup_Operate_Time
} EContact;

@interface ContactBackupViewController : UIViewController

@end
