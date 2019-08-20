import 'package:flutter/material.dart';
import '../../globals.dart';
import 'drawer_widgets/drawer_view.dart';
import 'products_screen.dart';
import '../../utils.dart';

///This class represents the first screen which
///appears to the user or when the user presses
///the (Home) tab.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  /// the main tabs.
  List<Tab> _tabs;

  /// the number of notifications
  int _notificationNumber = 100;

  /// current tab index
  int _currentTabIndex = 0;

  /// current page index. 0 for the home page, 1 for the products page
  int _pageIndex = 0;

  int _currentSectorIndex = 0;
  int _currentCategoryIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabs = _getTabs(Globals.controller.sectors);
  }

  @override
  Widget build(BuildContext context) {
    return _pageIndex == 1
        ? _products(_currentSectorIndex, _currentCategoryIndex)
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),

                // Notifications ..
                child: Stack(
                  children: <Widget>[
                    Icon(
                      Icons.notifications_none,
                      size: 45,
                      color: Color(0xff727272),
                    ),
                    _notificationNumber > 0
                        ? Container(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              maxRadius: 12,
                              child: Text(
                                _notificationNumber >= 100
                                    ? '+99'
                                    : '$_notificationNumber',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              centerTitle: true,
              title: Image(image: AssetImage('assets/home_page_title.png')),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.search,
                    size: 40,
                    color: Color(0xff727272),
                  ),
                ),
              ],
            ),
            body: DefaultTabController(
              length: _tabs.length,
              initialIndex: _currentTabIndex,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  //preferedSize
                  title: TabBar(
                    isScrollable: true,
                    //controller: TabController(length: 5, vsync: this, initialIndex: 3,),
                    indicatorColor: Colors.black,
                    onTap: (index) => _currentTabIndex = index,
                    tabs: _tabs,
                  ),
                ),
                body: TabBarView(
                  children: _generateTabViews(Globals.controller.sectors),
                ),
              ),
            ),
          );
  }

  ///Returns the category screen which contains the products list.
  Widget _products(int sectorIndex, int categoryIndex) {
    return Scaffold(
      backgroundColor: Color(0xfff1f3f2),
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: DrawerView(),
      ),
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image(image: AssetImage('assets/filter.png')),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            setState(() {
              _pageIndex = 0;
            });
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff727272),
          ),
        ),
        centerTitle: true,
        title: Text(
          Globals
              .controller.sectors[sectorIndex].categories[categoryIndex].name,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: WillPopScope(
          child: ProductsScreen(
            sectorIndex: sectorIndex,
            categoryIndex: categoryIndex,
          ),
          onWillPop: () {
            setState(() {
              _pageIndex = 0;
            });
            return null;
          }
      ),
    );
  }

  /// Returns the main tabs.
  List<Tab> _getTabs(List sectorsList) {
    List<Tab> _tabs = List();
    for (int i = 0; i < sectorsList.length; i++) {
      _tabs.add(_tab(sectorsList[i].name));
    }
    return _tabs;
  }

  ///Returns the single tab.
  Tab _tab(String title) {
    return Tab(
        child: Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    ));
  }

  ///Generates views for each tab.
  List<Widget> _generateTabViews(List sectorsList) {
    List<Widget> widgetList = [];
    for (int i = 0; i < sectorsList.length; i++) {
      widgetList.add(TabView(
        sectorIndex: i,
        imageUrl: sectorsList[i].imageUrl,
        onTap: (categoryIndex) {
          _currentSectorIndex = i;
          _currentCategoryIndex = categoryIndex;
          setState(() {
            _pageIndex = 1;
          });
        },
      ));
    }
    return widgetList;
  }
}

///The class represents how the tab view should look like.
class TabView extends StatefulWidget {
  final int sectorIndex;
  final String imageUrl;
  final void Function(int) onTap;

  TabView({@required this.sectorIndex,
    @required this.imageUrl,
    @required this.onTap});
  @override
  _TabViewState createState() =>
      _TabViewState(sectorIndex: sectorIndex, imageUrl: imageUrl, onTap: onTap);
}

class _TabViewState extends State<TabView> {
  final int sectorIndex;
  final String imageUrl;
  final void Function(int) onTap;

  _TabViewState({@required this.sectorIndex,
    @required this.imageUrl,
    @required this.onTap});
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            FutureBuilder(
                future: isImageAvailable(imageUrl),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bool isAvailable = snapshot.data;
                    if (isAvailable)
                      return Image(
                        image: NetworkImage(
                          imageUrl,
                        ),
                        fit: BoxFit.fill,
                        height: _height / 4,
                      );
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No Image Available'),
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: CircularProgressIndicator(),
                        width: 50,
                        height: 50,
                      )
                    ],
                  );
                }),
            Image.asset('assets/banner.png'),
          ]),
        ),
        SliverGrid(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          delegate: SliverChildListDelegate(List.generate(
              Globals.controller.sectors[sectorIndex].categories.length,
                  (index) {
                return _tabViewItem(
                    Globals.controller.sectors[sectorIndex].categories[index]
                        .name,
                    Globals
                        .controller.sectors[sectorIndex].categories[index]
                        .imageUrl,
                    index);
          })),
        ),
      ],
    );
  }

  Widget _tabViewItem(String title, String imageUrl, int categoryIndex) {
    return GestureDetector(
      onTap: () => onTap(categoryIndex),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FutureBuilder(
              future: isImageAvailable(imageUrl),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                              style: BorderStyle.none
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          image:
                          DecorationImage(image: NetworkImage(imageUrl),
                              fit: BoxFit.cover)),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Text(
                        'No Image available',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                }
                return Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              },
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      height: 5,
                      width: 50,
                      color: Colors.orange,
                    ),
                  ],
                ),
                alignment: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
