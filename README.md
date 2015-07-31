# InfPagedScrollView
Infinite scroll view with paging and dynamic reloadData capability. 
Handy for galleries and quiz games, where scroll view elements can be added or removed during the runtime and infinite scroll is a nice thing to have.

#Usage
You have to implement following dataSource methods in your ViewController:

1) `-(NSUInteger)numberOfPagesInInfPagedScrollView:(InfPagedScrollView *)infPagedScrollView`

to tell InfPagedScrollView, how many elements you have.
2) `- (UIView*)infPagedScrollView:(InfPagedScrollView *)infPagedScrollView viewAtIndex:(NSUInteger)idx reusableView:(UIView *)view`

to setup the view, which is or soon will be visisble on the screen.

#Under the hood
Only three subviews are used for all your elements. This approach helps to achieve good performance and save a lot of memory as well.
If you have zero to two elements, widget will handle this situation perfectly.

#Credits
Implementation is inspired by UITableView ideas.
