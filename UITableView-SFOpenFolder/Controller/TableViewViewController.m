//
//  TableViewViewController.m
//  SFOpenFolder
//
//  Created by Jakey on 2017/3/28.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "TableViewViewController.h"
#import "TableViewCell.h"
#import "DetailViewController.h"
#import "UITableView+SFOpenFolder.h"

#import "TableHeader.h"
@interface TableViewViewController ()
{
    NSMutableArray *_items;
    DetailViewController *_detail;
}
@property (strong, nonatomic) NSMutableDictionary *allHeaders;

@end

@implementation TableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myTableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TableHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TableHeader"];
    _detail= [[DetailViewController alloc]init];
    [self addChildViewController:_detail];
    
    _items = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j=0; j<(i+1)*6; j++) {
            [array addObject:[NSString stringWithFormat:@"i%zd j%zd",i,j]];
        }
        NSDictionary *dic =   @{@"items":array,@"expand":@(YES)};
        [_items addObject:dic];
        
    }
    [self.myTableView reloadData];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sectionTouched:(UIButton*)sender{
    NSMutableDictionary *item = [[_items objectAtIndex:sender.tag] mutableCopy];
    BOOL expand = [[item objectForKey:@"expand"] boolValue];
    
    if (self.myTableView.sf_selectedIndexPath.section != sender.tag)
    {
        [self.myTableView sf_closeViewWithSelectedIndexPath:^(NSIndexPath *selectedIndexPath) {
            NSMutableDictionary *selectItem = [[_items objectAtIndex:selectedIndexPath.section] mutableCopy];
            [selectItem setObject:@(NO) forKey:@"expand"];
            [_items replaceObjectAtIndex:selectedIndexPath.section withObject:selectItem];
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
            
            [item setObject:@(!expand) forKey:@"expand"];
            [_items replaceObjectAtIndex:sender.tag withObject:item];
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }else{
        [self.myTableView sf_closeViewWithSelectedIndexPath:^(NSIndexPath *selectedIndexPath) {
            [item setObject:@(!expand) forKey:@"expand"];
            [_items replaceObjectAtIndex:sender.tag withObject:item];
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}
#pragma mark -
#pragma -mark TableView Delegate
//- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section {
//
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
{
    TableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableHeader"];
    
    header.button.backgroundColor = [UIColor redColor];
    [header.button setTitle:[@(section) description] forState:UIControlStateNormal];
    [header.button addTarget:self action:@selector(sectionTouched:) forControlEvents:UIControlEventTouchUpInside];
    header.button.tag = section;

    return header;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_items  count];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *item = [_items objectAtIndex:section];
    if (![[item objectForKey:@"expand"] boolValue]) {
        return 0;
    }else{
        return [[item objectForKey:@"items"] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    //config the cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.laebl.backgroundColor = [self jk_randomColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView sf_openFolderAtIndexPath:indexPath contentBlock:^UIView *(id item) {
        _detail.view.frame = CGRectMake(0, 0, tableView.frame.size.width, _detail.view.frame.size.height);
        return _detail.view;
    } beginningBlock:^(SFTableOpenStatus openStatus) {
        if (openStatus == SFTableOpenStatusOpening) {
            NSLog(@"begin opening");
        }
        if (openStatus == SFTableOpenStatusClosing) {
            NSLog(@"begin closing");
        }
        
    } completionBlock:^(SFTableOpenStatus openStatus) {
        if (openStatus == SFTableOpenStatusOpened) {
            NSLog(@"completion open");
        }
        if (openStatus == SFTableOpenStatusClose) {
            NSLog(@"completion  close");
        }
    }];
}



- (UIColor *)jk_randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}
@end
