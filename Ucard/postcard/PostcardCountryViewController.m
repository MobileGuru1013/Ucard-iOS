//
//  PostcardCountryViewController.m
//  Ucard
//
//  Created by Conner Wu on 15/4/28.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PostcardCountryViewController.h"
#import "CountryModel.h"

@interface PostcardCountryViewController ()
{
    NSArray *_dataArray;
    NSArray *_resultArray;
    UISearchDisplayController *_searchDisplayController;
}
@end

@implementation PostcardCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"localized072", nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"public_nav_back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem.tintColor = kGreenColor;
    
    NSMutableArray *dicArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"plist"]]];
    
    // 排序
    NSSortDescriptor *keyDescriptor = [[NSSortDescriptor alloc] initWithKey:(_onlyEnglish ? @"en" : ([Constants isCNLanguage] ? @"py" : @"en")) ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:keyDescriptor, nil];
    [dicArray sortUsingDescriptors:descriptors];
    
    _dataArray = [CountryModel arrayOfModelsFromDictionaries:dicArray];
    
    _resultArray = [NSArray array];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.tableView.tableHeaderView = searchBar;
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [_searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.tableView) {
        count = _dataArray.count;
    } else {
        NSMutableArray *array = [NSMutableArray array];
        NSString *text = [_searchDisplayController.searchBar.text lowercaseString];
        if (text && text.length > 0) {
            for (CountryModel *model in _dataArray) {
                if ([(_onlyEnglish ? [model.en lowercaseString] : ([Constants isCNLanguage] ? model.cn : [model.en lowercaseString])) containsString:text]) {
                    [array addObject:model];
                }
            }
        } else {
            [array addObjectsFromArray:_dataArray];
        }
        _resultArray = [NSArray arrayWithArray:array];
        count = _resultArray.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryModel *model;
    if (tableView == self.tableView) {
        model = _dataArray[indexPath.row];
    } else {
        model = _resultArray[indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _onlyEnglish ? model.en : ([Constants isCNLanguage] ? model.cn : model.en);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryModel *model;
    if (tableView == self.tableView) {
        model = _dataArray[indexPath.row];
    } else {
        model = _resultArray[indexPath.row];
    }
    
    if (self.countryBlock) {
        self.countryBlock(model);
    }
    
    [self goBack];
}

@end
