//
//  ViewController.m
//  拼音扩展
//
//  Created by  jason on 15/12/18.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import "ViewController.h"
#import "NSString+PinYin.h"
#import "YJSortAndIndex.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *indexArray;

@property(nonatomic, strong) NSMutableArray *sortArray;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *searchDisplayController;
/**
 *  搜索结果数组
 */
@property(nonatomic, strong) NSMutableArray *searchResultsArray;

@end

#pragma mark - viewlife
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResultsArray = [NSMutableArray array];
    [self creatTableView];
    
    
    
    
}


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        if (self.searchResultsArray.count<=section) {
            
            return 0;
        }
        return self.searchResultsArray.count;
    }
    else {
    
        NSArray *arr = [self.sortArray objectAtIndex:section];
        
        return arr.count;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return 1;
    }
    else {
    return self.indexArray.count;
    }
}


- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView  {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return nil;
    }
    else {
    
    return self.indexArray;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return nil;
    }
    else {
   return  [self.indexArray objectAtIndex:section];
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"reuseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
#warning 在这里赋值会有问题
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       
        cell.textLabel.text = [self.searchResultsArray objectAtIndex:indexPath.row];
    }
    else {
    NSArray *arr = [self.sortArray objectAtIndex:indexPath.section];
    
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    }
    
    return  cell;
}

#pragma mark UISearchBarDelegate 
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

    // 这句很关键
    searchBar.showsCancelButton = YES;
    for (UIView *view in searchBar.subviews[0].subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            
            [button setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    //改变tableView的frame
    [UIView animateWithDuration:0.25 animations:^{
       
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.origin.y = 20;
        self.tableView.frame = tableViewFrame;
        

    }];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {

    //改变tableView的frame
    [UIView animateWithDuration:0.15 animations:^{
        
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.origin.y = 64;
        self.tableView.frame = tableViewFrame;
    }];
    return YES;
}

#pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    [self.searchResultsArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd]%@",searchString];

    for (NSArray* scopeArr in self.sortArray) {
        
        [self.searchResultsArray addObjectsFromArray:[scopeArr filteredArrayUsingPredicate:predicate]];
    }
    
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

#pragma mark - 私有方法
- (void)creatTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH-64) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = self.searchBar;
    [self.view addSubview:_tableView];
}

#pragma mark - get方法
- (NSMutableArray*)sortArray {
    
    if (_sortArray == nil) {
        
        
        _sortArray = [NSMutableArray array];
        
        NSMutableArray *testArr = [@[@"广州",@"广西",@"湖南",@"湖北",@"湖东",@"桂林",@"啊里",@"abc",@"b",@"测试啊",@"什么鬼啊",@"shdfadf"] mutableCopy];
        
        _sortArray = [YJSortAndIndex sortArrayByFirstLetterWithArray:testArr];
        
    }
    return _sortArray;
}

- (NSMutableArray*)indexArray {
    
    if (_indexArray == nil) {
        
        
        _indexArray = [NSMutableArray array];
        
        _indexArray = [YJSortAndIndex getSectionIndexsArrayWithSortSecionsArray:self.sortArray];
        
    }
    return _indexArray;
}

- (UISearchBar*)searchBar {
    
    if (_searchBar == nil) {
        
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        
    }
    return _searchBar;
}

- (UISearchDisplayController*)searchDisplayController {
    
    if (_searchDisplayController == nil) {
        
        
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchDisplayController.delegate = self;
        _searchDisplayController.searchResultsTableView.delegate = self;
        _searchDisplayController.searchResultsTableView.dataSource = self;
        
    }
    return _searchDisplayController;
}

@end
