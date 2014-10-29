//
//  ContactViewController.m
//  iData
//
//  Created by karven on 7/30/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "ContactViewController.h"

@implementation ContactViewController
@synthesize contactDictionary,keyArray,contactTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"通讯录";
    
    contactDictionary = [NSMutableDictionary dictionary];
    keyArray = [NSArray array];
    
    contactTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-44)];
    contactTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    contactTable.dataSource = self;
    contactTable.delegate = self;
    [self.view addSubview:contactTable];
    
    [self fetchLocalContact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchLocalContact{
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
            //获取的联系人单一属性:First name
            NSString *tmpFirstName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty));
            tmpFirstName = tmpFirstName==nil?@"":tmpFirstName;
            
            NSString *tmpLastName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty));
            tmpLastName = tmpLastName==nil?@"":tmpLastName;
            
            NSString *companyName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty));
            companyName = companyName==nil?@"":companyName;
            
            //获取的联系人单一属性:Generic phone number
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
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
                //利用反转字符串取从后往前的11位(再次反转)，并判断是否符合手机号码规则
//                if (tmpPhoneIndex.length>=11) {
//                    tmpPhoneIndex = [[Util stringByReversed:tmpPhoneIndex] substringToIndex:11];
//                    tmpPhoneIndex = [Util stringByReversed:tmpPhoneIndex];
//                    if (![Util isMobileNumber:tmpPhoneIndex]) {
//                        continue;
//                    }
//                }else{
//                    continue;
//                }
                
                NSString *pinyin = [Util getCCToPY:[NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName]];
                NSString *pinyinFirstLetter = [pinyin substringToIndex:1]==nil?@"#":[pinyin substringToIndex:1];
                NSMutableArray *tempArray = [contactDictionary objectForKey:pinyinFirstLetter];
                if (tempArray == nil) {
                    tempArray = [NSMutableArray array];
                }
                NSString *displayName = [NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName];
                if ([displayName isEqualToString:@""]) {
                    if ([companyName isEqualToString:@""]) {
                        displayName = @"#";
                    }else{
                        displayName = companyName;
                    }
                }
                NSString *contactName = [NSString stringWithFormat:@"%@&%@&%@",pinyin,displayName,tmpPhoneIndex];
                [tempArray addObject:contactName];
                [contactDictionary setObject:tempArray forKey:pinyinFirstLetter];
            }
            CFRelease(tmpPhones);
        }
        [self dictionaryValueSort:contactDictionary];
        keyArray = [self arraySort:[contactDictionary allKeys]];
        CFRelease(tmpAddressBook);
        
//        NSMutableArray *contactList = [NSMutableArray array];
//        for (NSString *s in keyArray) {
//            [contactList addObjectsFromArray:[contactDictionary objectForKey:s]];
//        }
//        NSString *pathDoc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        NSString *homePath  = [pathDoc stringByAppendingPathComponent:@"contact.plist"];//添加储存的文件名
//        [NSKeyedArchiver archiveRootObject:contactList toFile:homePath];//归档一个字符串
    }else{
        UILabel *label = [[UILabel alloc] init];
        [label setFrame:CGRectMake(20, (ScreenHeight-60)/2, ScreenWidth-20*2, 60)];
        [label setNumberOfLines:2];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"请在iPhone的\"设置-隐私-通讯录\"选项中允许App访问你的通讯录。"];
        [self.view addSubview:label];
    }
}

-(NSArray *)arraySort:(NSArray *)array{
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        return [obj1 compare:obj2];
    };
    return [array sortedArrayUsingComparator:sort];
}

-(void)dictionaryValueSort:(NSMutableDictionary *)dictionary{
    NSArray *array = [dictionary allKeys];
    for (NSString *str in array) {
        NSArray *tempArray = [dictionary objectForKey:str];
        tempArray = [self arraySort:tempArray];
        [dictionary setObject:tempArray forKey:str];
    }
}

#pragma mark UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return keyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [keyArray objectAtIndex:section];
    NSArray *array = [contactDictionary objectForKey:key];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ContactTabelView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    while ([cell.contentView.subviews lastObject] != nil){//删除cell上的子视图
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    NSString *key = [keyArray objectAtIndex:indexPath.section];
    NSArray *array = [contactDictionary objectForKey:key];
    
    NSString *contactInfo = [array objectAtIndex:indexPath.row];
    NSArray *tempArray = [contactInfo componentsSeparatedByString:@"&"];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
    [nameLabel setText:tempArray[1]];
    [cell.contentView addSubview:nameLabel];
    if (array.count - 1 != indexPath.row || [[keyArray lastObject] isEqualToString:key]) {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, ScreenWidth, 1)];
        [lineLabel setBackgroundColor:[Util colorFromRGB:@"235,235,235"]];
        [cell.contentView addSubview:lineLabel];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return keyArray;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = [keyArray objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [headerView setBackgroundColor:[Util colorFromRGB:@"245,245,245"]];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [lineLabel setBackgroundColor:[Util colorFromRGB:@"225,225,225"]];
    [headerView addSubview:lineLabel];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, ScreenWidth - 15, 20)];
    [titleLabel setText:title];
    [headerView addSubview:titleLabel];
    return headerView;
}

@end
