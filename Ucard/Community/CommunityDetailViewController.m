//
//  CommunityDetailViewController.m
//  Ucard
//
//  Created by Conner Wu on 15/5/8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommunityDetailViewController.h"
#import "CommunityDetailCell.h"
#import "CommunityCommentCell.h"
#import "CommentModel.h"
#import "NSString+TimeAgo.h"
#import "CommunityViewController.h"
#import "CommunityDetaiModel.h"
#import "ShareOperation.h"
#import "SVProgressHUD.h"

@interface CommunityDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

{
    
    UITableView *_tableView;
    NSArray *_commentArray;
    CommunityDetaiModel *_detailModel;
    UITextField *_hiddenTextField;
    UITextField *_commentTextField;
    UIView *_inputView;
    UIView *_keyboardView;
    UIButton *_commentButton;
    UIImageView *_commentLine;
    UIRefreshControl *_refreshControl;
    
}

@end

@implementation CommunityDetailViewController
UIImageView *frontView;
UIButton *shareButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self showNavLogo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    [self getData];
    [self showCommentInput];
    [self hideRightButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc

{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)setFrame
{
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height = kScreenHeight - statusBarHeight - 44 - 44;
                         _tableView.frame = frame;
                         
                         frame = _commentButton.frame;
                         frame.origin.y = CGRectGetMaxY(_tableView.frame);
                         _commentButton.frame = frame;
                         
                         frame = _commentLine.frame;
                         frame.origin.y = CGRectGetMinY(_commentButton.frame);
                         _commentLine.frame = frame;
                     }];
}

- (void)getData
{
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            NSError *error;
            _detailModel = [[CommunityDetaiModel alloc] initWithDictionary:[result objectForKey:@"data"] error:&error];
            if (error) {
                NSLog(@"%@", error);
            } else {
                [weakself showData];
                
                _commentArray = @[];
                [weakself getComment];
            }
        }
    }];
    request.showLoading = !_refreshControl.isRefreshing;
    [request getCommunityDetail:_cardId];
}

- (void)showData
{
    if (!_tableView) {
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - statusBarHeight - 44 - 44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[CommunityDetailCell class] forCellReuseIdentifier:@"CommunityDetailCell"];
        [_tableView registerClass:[CommunityCommentCell class] forCellReuseIdentifier:@"CommunityCommentCell"];
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:_refreshControl];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), kScreenWidth, kScreenHeight - 60 - CGRectGetMaxY(_tableView.frame))];
        commentView.backgroundColor = [UIColor lightGrayColor];
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.frame = CGRectMake(30, 5 , kScreenWidth - 60, CGRectGetHeight(commentView.frame) - 20);
        _commentButton.backgroundColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
        [_commentButton setTitle:NSLocalizedString(@"localized021", nil) forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _commentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _commentButton.layer.cornerRadius = 2;

        [_commentButton addTarget:self action:@selector(showCommentInput) forControlEvents:UIControlEventTouchUpInside];
        [commentView addSubview:_commentButton];

        // 键盘输入框
        
        _hiddenTextField = [[UITextField alloc] init];
        _hiddenTextField.delegate = self;
        _hiddenTextField.placeholder = NSLocalizedString(@"localized021", nil);
        [self.view addSubview:_hiddenTextField];
        
        UIView *inputView = [UIButton buttonWithType:UIButtonTypeCustom];
        inputView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame) , kScreenWidth, 40+20);
        inputView.backgroundColor = [UIColor lightGrayColor];
        CGFloat submitWidth = [Constants isCNLanguage] ? 50 : 60;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10+10, 5, kScreenWidth - 10 - submitWidth+20, 40 - 5 * 2)];
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [UIColor colorWithRed:0.851 green:0.851 blue:0.827 alpha:1].CGColor;
        textField.layer.cornerRadius = 3;
        textField.font = [UIFont systemFontOfSize:15];
        textField.backgroundColor = [UIColor whiteColor];
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeySend;
        [inputView addSubview:textField];
        _commentTextField = textField;
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        sendButton.frame = CGRectMake(kScreenWidth - submitWidth-10, CGRectGetMinY(textField.frame), 30, 30);
        [sendButton setImage:[UIImage imageNamed:@"submit_comment.png"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
        
        [inputView addSubview:sendButton];
        [self.view addSubview:inputView];
        
        UIView *accessoryView = [[UIView alloc] initWithFrame:self.view.bounds];
        [accessoryView addSubview:inputView];
        [accessoryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn:)]];
        [_hiddenTextField setInputAccessoryView:accessoryView];
        
    }
}

- (void)reloadDetail
{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _commentTextField) {
        if (_commentTextField.text.length > 0) {
            [self submitComment:_commentTextField.text];
        }
    }
    
    [_hiddenTextField resignFirstResponder];
    [_commentTextField resignFirstResponder];
    
    if (_hiddenTextField.isFirstResponder) {
        [_hiddenTextField resignFirstResponder];
    }
    
    if (_commentTextField.isFirstResponder) {
        [_commentTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [_commentTextField becomeFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [_hiddenTextField resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _commentTextField.text = nil;
}

- (void)showCommentInput
{
    [_hiddenTextField becomeFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    switch (section) {
        case 0:
            count = 1;
            break;
            
        case 1:
            count = _commentArray.count;
            break;
            
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    switch (indexPath.section) {
        case 0:
            height = [CommunityDetailCell height];
            
            break;
            
        case 1: {
            CommentModel *model = [_commentArray objectAtIndex:indexPath.row];
            height = [CommunityCommentCell height:model.comment];
            
            break;
        }
            
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    UITableViewCell *theCell;
    switch (indexPath.section) {
        case 0: {
            
            CommunityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityDetailCell" forIndexPath:indexPath];
            shareButton = [cell getShareButton];
            cell.praiseBlock = ^() {
                [weakself submitPraise];
            };
            cell.commentBlock = ^() {
                [weakself showCommentInput];
            };
            cell.shareBlock = ^() {
                [weakself share:shareButton];
            };
            frontView = [cell setContent:_detailModel];
            theCell = cell;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            break;
            
        }
            
        case 1: {
            
            CommentModel *model = [_commentArray objectAtIndex:indexPath.row];
            
            CommunityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityCommentCell" forIndexPath:indexPath];
            cell.nameLabel.text = model.user_nickname;
            cell.contentLabel.text = model.comment;
            cell.timeLabel.text = [model.time timeAgo];
            [Constants setHeaderImageView:cell.headerImageView path:model.user_icon];
            [cell setContentHeight:cell.contentLabel.text];
            
            theCell = cell;
            
            break;
            
        }
            
        default:
            break;
    }
    return theCell;
}

- (void)submitComment:(NSString *)string
{
    NSString *text;
    if ([string isKindOfClass:[UIButton class]]) {
        text = _commentTextField.text;
        _commentTextField.text = nil;
        if (!text || text.length == 0) {
            return;
        }
        
        [self textFieldShouldReturn:_commentTextField];
    } else {
        text = string;
    }
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [weakself getComment];
            
            _detailModel.comment_number++;
            [weakself reloadDetail];
            
            _listModel.postcard_comment_number = _detailModel.comment_number;
            [weakself reloadList];
        }
    }];
    [request commentCard:_cardId comment:text];
}

- (void)getComment
{
    
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        [_refreshControl endRefreshing];
        if (succ) {
            NSArray *array = [result objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                _commentArray = [CommentModel arrayOfModelsFromDictionaries:array];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }];
    request.showLoading = !_refreshControl.isRefreshing;
    [request getCardComment:_cardId];
    
}

- (void)submitPraise
{
    
    if ([CommunityDetaiModel isPraised:_cardId]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"localized023", nil)];
        return;
    }
    
    __weak typeof(self) weakself = self;
    NetworkRequest *request = [[NetworkRequest alloc] initWithLoadingSuperView:self.view];
    [request completion:^(id result, BOOL succ) {
        if (succ) {
            [CommunityDetaiModel praiseCard:_cardId];
            
            _detailModel.like_number = [[result objectForKey:@"data"] integerValue];
            [weakself reloadDetail];
            
            _listModel.like_number = _detailModel.like_number;
            [weakself reloadList];
        }
    }];
    [request praiseCard:_cardId];
}

- (void)share:(UIButton *)button
{
    
    [ShareOperation shareInstance].viewController = self;
    [[ShareOperation shareInstance] showShareView:button imagePath:_detailModel.postcard_head image:frontView.image complete:nil];
}

- (void)reloadList

{
    CommunityViewController *viewController = (CommunityViewController *)[self.navigationController.viewControllers firstObject];
    [viewController.collectionView reloadData];
}

@end
