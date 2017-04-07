# AllScrollView
A demo contain scrollView、tableView、collectionView

## UIScrollView+AutoLayout
[iOS中Xcode使用UIScrollView+AutoLayout轻松实现滚动布局](http://www.2cto.com/kf/201604/503132.html)

实际上只要我们往UIScrollView中添加的containerView，能够依靠自己知道宽、高即可。比如

## CJBadgeImageView
包含Badge的ImageView,该类直接继承于UIImageView

## CJBaseTableViewCell
基本UITableViewCell继承而来的自己的各种基本TableView

## FriendCircle
实现类似微信朋友圈或者QQ空间，评论回复，贴吧盖楼，九宫格布局。处理键盘弹出后定位到当前点击的被评论人处。

## CJSearchUtil
搜索功能的工具类


#### Screenshots
![Example](./Screenshots/Demo.gif "Demo")
![Example](./Screenshots/Demo.png "Demo")

#### TableView多选
[UITableView的多选在选中时有一层View将cell 盖住了。怎么将它设置成透明，或者去掉](http://www.cocoachina.com/bbs/read.php?tid-249017.html)
正确答案是：

```
cell.multipleSelectionBackgroundView = [[UIView alloc] init];
cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
```

##### 点赞
功能有：

* 点击点赞按钮，能点赞/取消点赞
* 点击点赞列表里的用户名，能进入相应操作
* 点赞增加、删除成功时候：点赞表高及内容cell高的同时更新

###### 评论增删
功能有:

* 点击评论按钮，能增加评论；
* 点击评论列表中不同评论能进行增加评论和删除评论
* 增加评论时候弹出键盘的处理： 
（1）点击评论则定位在当前点击的评论按钮下方
（2）点击评论内容所在cell，则直接定位在点击的评论内容的cell的下方
（3）完美兼容系统键盘和搜狗键盘
* 评论增加、删除成功时候：评论表高及内容cell高的同时更新

