//
//  ContactBackupViewController.m
//  iData
//  联系人备份
//  Created by karven on 9/25/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "ContactBackupViewController.h"

@interface ContactBackupViewController ()

@property(nonatomic,retain) NSMutableArray *contactArray;
@property(nonatomic,retain) NSDateFormatter *dateFormatter;
@property(nonatomic,retain) MBProgressHUD *hud;

@end

@implementation ContactBackupViewController
@synthesize contactArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    contactArray = [NSMutableArray array];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?20:0, ScreenWidth, 44)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:navigationView.bounds];
    [imageView setImage:[UIImage imageNamed:@"background"]];
    [navigationView addSubview:imageView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    [backBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:backBtn];
    
    ThemeLabel *titleLabel = [UIFactory createLabel:@"contact"];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFrame:CGRectMake((ScreenWidth-150)/2.0, 10, 150, 25)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:titleLabel];
    
    [self.view addSubview:navigationView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight - (VER_IS_IOS7?64:44))];
    [backgroundImageView setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backgroundImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 225)/2.0, VER_IS_IOS7?84:64, 225, 65)];
    [logoImageView setImage:[UIImage imageNamed:@"logo_image"]];
    [self.view addSubview:logoImageView];
    
    UIImageView *imageViewTo = [[UIImageView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(logoImageView.frame)+70, 27, 33)];
    [imageViewTo setImage:[UIImage imageNamed:@"backup"]];
    ThemeLabel *backupToTitle = [UIFactory createLabel:@"backupTo"];
    [backupToTitle setBackgroundColor:[UIColor clearColor]];
    [backupToTitle setFrame:CGRectMake(imageViewTo.frame.origin.x + imageViewTo.frame.size.width +5, imageViewTo.frame.origin.y-5, ScreenWidth-90, 20)];
    [backupToTitle setTextColor:[UIColor whiteColor]];
    [backupToTitle setFont:[UIFont systemFontOfSize:15]];
    ThemeLabel *backupToSubtitle = [UIFactory createLabel:@"backupToSubtitle"];
    [backupToSubtitle setBackgroundColor:[UIColor clearColor]];
    [backupToSubtitle setFrame:CGRectMake(backupToTitle.frame.origin.x, backupToTitle.frame.origin.y+25, ScreenWidth-90, 15)];
    [backupToSubtitle setTextColor:[UIColor whiteColor]];
    [backupToSubtitle setFont:[UIFont systemFontOfSize:12]];
    UIButton *backupToBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImageView.frame)+60, ScreenWidth-40, 50)];
    backupToBtn.tag = Backup_To;
    [backupToBtn setBackgroundImage:[UIImage imageNamed:@"contacts_unpress"] forState:UIControlStateNormal];
    [backupToBtn setBackgroundImage:[UIImage imageNamed:@"contacts_press"] forState:UIControlStateHighlighted];
    [backupToBtn addTarget:self action:@selector(operatorContact:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backupToBtn];
    [self.view addSubview:imageViewTo];
    [self.view addSubview:backupToTitle];
    [self.view addSubview:backupToSubtitle];
    
    UIImageView *imageViewFrom = [[UIImageView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(backupToBtn.frame)+30, 27, 33)];
    [imageViewFrom setImage:[UIImage imageNamed:@"restore"]];
    ThemeLabel *backupFromTitle = [UIFactory createLabel:@"backupFrom"];
    [backupFromTitle setBackgroundColor:[UIColor clearColor]];
    [backupFromTitle setFrame:CGRectMake(imageViewFrom.frame.origin.x + imageViewFrom.frame.size.width +5, imageViewFrom.frame.origin.y-5, ScreenWidth-90, 20)];
    [backupFromTitle setTextColor:[UIColor whiteColor]];
    [backupFromTitle setFont:[UIFont systemFontOfSize:15]];
    ThemeLabel *backupFromSubtitle = [UIFactory createLabel:@"backupFromSubtitle"];
    [backupFromSubtitle setBackgroundColor:[UIColor clearColor]];
    [backupFromSubtitle setFrame:CGRectMake(backupFromTitle.frame.origin.x, backupFromTitle.frame.origin.y+25, ScreenWidth-90, 15)];
    [backupFromSubtitle setTextColor:[UIColor whiteColor]];
    [backupFromSubtitle setFont:[UIFont systemFontOfSize:12]];
    UIButton *backupFromBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backupToBtn.frame)+20, ScreenWidth-40, 50)];
    backupFromBtn.tag = Backup_From;
    [backupFromBtn setBackgroundImage:[UIImage imageNamed:@"contacts_unpress"] forState:UIControlStateNormal];
    [backupFromBtn setBackgroundImage:[UIImage imageNamed:@"contacts_press"] forState:UIControlStateHighlighted];
    [backupFromBtn addTarget:self action:@selector(operatorContact:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backupFromBtn];
    [self.view addSubview:imageViewFrom];
    [self.view addSubview:backupFromTitle];
    [self.view addSubview:backupFromSubtitle];
    
    ThemeLabel *contactsNumber = [UIFactory createLabel:@"contactNumber"];
    [contactsNumber setBackgroundColor:[UIColor clearColor]];
    [contactsNumber setFrame:CGRectMake(backupFromBtn.frame.origin.x, CGRectGetMaxY(backupFromBtn.frame)+30, (ScreenWidth - 40)/2.0, 15)];
    [contactsNumber setTextAlignment:NSTextAlignmentLeft];
    [contactsNumber setFont:[UIFont systemFontOfSize:12]];
    [contactsNumber setTextColor:[UIColor whiteColor]];
    [self.view addSubview:contactsNumber];
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contactsNumber.frame), CGRectGetMaxY(backupFromBtn.frame)+30, (ScreenWidth - 40)/2.0, 15)];
    [countLabel setBackgroundColor:[UIColor clearColor]];
    countLabel.tag = Backup_Local_Number;
    [countLabel setTextAlignment:NSTextAlignmentRight];
    [countLabel setFont:[UIFont systemFontOfSize:12]];
    [countLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:countLabel];
    
    ThemeLabel *lastOperator = [UIFactory createLabel:@"lastOperator"];
    [lastOperator setBackgroundColor:[UIColor clearColor]];
    [lastOperator setFrame:CGRectMake(backupFromBtn.frame.origin.x, CGRectGetMaxY(contactsNumber.frame)+10, (ScreenWidth - 40)/2.0, 15)];
    [lastOperator setTextAlignment:NSTextAlignmentLeft];
    [lastOperator setFont:[UIFont systemFontOfSize:12]];
    [lastOperator setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lastOperator];
    UILabel *operatorTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lastOperator.frame), CGRectGetMaxY(contactsNumber.frame)+10, (ScreenWidth - 40)/2.0, 15)];
    [operatorTime setBackgroundColor:[UIColor clearColor]];
    operatorTime.tag = Backup_Operate_Time;
    [operatorTime setTextAlignment:NSTextAlignmentRight];
    [operatorTime setFont:[UIFont systemFontOfSize:12]];
    [operatorTime setTextColor:[UIColor whiteColor]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *operateTime = [userDefaults objectForKey:@"operateTime"];
    if (operateTime) {
        [operatorTime setText:operateTime];
    }else{
        [operatorTime setText:@"--"];
    }
    [self.view addSubview:operatorTime];
    
    [self visitContact];
}

-(void)leftBtnPressed:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)visitContact{
    UILabel *label = (UILabel *)[self.view viewWithTag:Backup_Local_Number];
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {
        //取得本地所有联系人记录
        if (tmpAddressBook==nil) {
            return ;
        };
        NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
        for(id tmpPerson in tmpPeoples)
        {
            NSMutableDictionary *contactDic = [NSMutableDictionary dictionary];
            //获取的联系人单一属性:First name
            NSString *tmpFirstName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty));
            tmpFirstName = tmpFirstName==nil?@"":tmpFirstName;
            [contactDic setValue:tmpFirstName forKey:@"firstName"];
            
            NSString *tmpLastName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty));
            tmpLastName = tmpLastName==nil?@"":tmpLastName;
            [contactDic setValue:tmpLastName forKey:@"lastName"];
            
            NSString *companyName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty));
            companyName = companyName==nil?@"":companyName;
            [contactDic setValue:companyName forKey:@"companyName"];
            
            //获取的联系人单一属性:Generic phone number
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
            NSMutableArray *phoneNumber = [NSMutableArray array];
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            {
                NSString *tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                if (tmpPhoneIndex==nil) {
                    continue;
                }
                //去除特殊字符
                tmpPhoneIndex = [[[[tmpPhoneIndex stringByReplacingOccurrencesOfString:@" " withString:@""]
                                   stringByReplacingOccurrencesOfString:@"(" withString:@""]
                                  stringByReplacingOccurrencesOfString:@")" withString:@""]
                                 stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                [phoneNumber addObject:tmpPhoneIndex];
            }
            [contactDic setValue:phoneNumber forKey:@"phone"];
            
            [contactArray addObject:contactDic];
            CFRelease(tmpPhones);
        }
        CFRelease(tmpAddressBook);
        
        [label setText:[NSString stringWithFormat:@"%lu",(unsigned long)contactArray.count]];
    }else{
        [label setText:@"--"];
    }
}

#pragma mark UIButton Action
-(void)operatorContact:(UIButton *)sender{
    NSInteger tag = sender.tag;
    switch (tag) {
        case Backup_To:{
            [self backupContactsToiData];
        }
            break;
        case Backup_From:{
            [self restoreContactsFromiData];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 访问通讯录并把数据上传到iData
-(void)backupContactsToiData{
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {
        UILabel *label = (UILabel *)[self.view viewWithTag:Backup_Operate_Time];
        [_hud show:YES];
        [kFMServer setDestination:RootURL];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:contactArray];
        NSString *operateTime = [_dateFormatter stringFromDate:[NSDate date]];
        [kFTPManager deleteFileNamed:@"contact.plist" fromServer:kFMServer];
        BOOL isSuccess = [kFTPManager uploadData:data withFileName:@"contact.plist" toServer:kFMServer];
        if (isSuccess) {
            [_hud hide:YES];
            [label setText:operateTime];
            [[NSUserDefaults standardUserDefaults] setValue:operateTime forKey:@"operateTime"];
        }else{
            [_hud hide:YES];
            [self.view makeToast:@"backupToTips"];
        }
    }else{
        [self.view makeToast:@"visitContacts"];
    }
}
#pragma mark 访问通讯录并把iData联系人数据保存到手机
-(void)restoreContactsFromiData{
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {
        [_hud show:YES];
        NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [documentPath objectAtIndex:0];
        [kFMServer setDestination:RootURL];
        BOOL isSuccess = [kFTPManager downloadFile:@"contact.plist" toDirectory:[NSURL URLWithString:filePath] fromServer:kFMServer];
        if (isSuccess) {
            [self saveContact:[filePath stringByAppendingString:@"/contact.plist"]];
            [_hud hide:YES];
        }else{
            [_hud hide:YES];
            [self.view makeToast:@"backupFromTips"];
        }
    }else{
        [self.view makeToast:@"visitContacts"];
    }
}

-(void)saveContact:(NSString *)filePath{
    UILabel *label = (UILabel *)[self.view viewWithTag:Backup_Operate_Time];
    
    NSMutableArray *contact = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    @try {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,NULL);
        for (NSDictionary *dic in contact) {
            NSString *companyName = [dic objectForKey:@"companyName"];
            NSString *firstName = [dic objectForKey:@"firstName"];
            NSString *lastName = [dic objectForKey:@"lastName"];
            NSArray *phoneList = [dic objectForKey:@"phone"];
            ABRecordRef person = ABPersonCreate();
            ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)firstName, NULL);
            ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)lastName, NULL);
            ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef)companyName, NULL);
            
            ABMultiValueRef mv =ABMultiValueCreateMutable(kABMultiStringPropertyType);
            // 添加电话号码与其对应的名称内容
            for (int i = 0; i < [phoneList count]; i ++) {
                ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv,(__bridge CFStringRef)[phoneList objectAtIndex:i], (CFStringRef)@"phone", &mi);
            }
            // 设置phone属性
            ABRecordSetValue(person, kABPersonPhoneProperty, mv, NULL);
            // 释放该数组
            if (mv) {
                CFRelease(mv);
            }
            // 将新建的联系人添加到通讯录中
            ABAddressBookAddRecord(addressBook, person, NULL);
        }
        // 保存通讯录数据
        ABAddressBookSave(addressBook, NULL);
        // 释放通讯录对象的引用
        if (addressBook) {
            CFRelease(addressBook);
        }
    }
    @catch (NSException *exception) {
        [_hud hide:YES];
        [self.view makeToast:@"backupFromTips"];
        return;
    }
    NSString *operateTime = [_dateFormatter stringFromDate:[NSDate date]];
    [label setText:operateTime];
    [[NSUserDefaults standardUserDefaults] setValue:operateTime forKey:@"operateTime"];
}

@end




















