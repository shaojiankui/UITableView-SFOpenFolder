# UITableView-SFOpenFolder
UITableView+SFOpenFolder,a UITableView category,(仿苹果系统文件夹展开抽屉效果）like iOS springborad folder expand。

# usage
## import
```
#import "UITableView+SFOpenFolder.h"
```

## open

```
_detail= [[DetailViewController alloc]init];
[self addChildViewController:_detail];
```


```
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
```

## manual close

```
- (void)sectionTouched:(UIButton*)sender{
    //....
    [self.myTableView sf_closeViewWithSelectedIndexPath:^(NSIndexPath *selectedIndexPath) {
          
        }];
    //....
}
```
# notice
table header view must iskindof UITableViewHeaderFooterView

# demo
![](https://raw.githubusercontent.com/shaojiankui/UITableView-SFOpenFolder/master/demo.gif)
