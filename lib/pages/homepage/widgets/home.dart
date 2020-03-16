import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goldfarm/pages/business_partner_view/ui/business_partner_view.dart';
import 'package:goldfarm/pages/farmer_view/ui/farmerview.dart';
import 'package:goldfarm/pages/homepage/widgets/drawer.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';

class MainPage extends DrawerContent {
  MainPage({Key key, this.title, this.context});

  final String title;
  final BuildContext context;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TabController _tabController;
  var searchController = TextEditingController();
  String searchValue = '';
  int _value = 0;
  List<String> list;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    list = [AppLocalizations.of(widget.context).translate("name")??"Name", AppLocalizations.of(widget.context).translate("number")??"Number", AppLocalizations.of(widget.context).translate("gfCode")??"GF Code"];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: <Widget>[
                AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: widget.title == AppLocalizations.of(context).translate("homePage")?? Const.homePage
                      ? Image.asset(
                          "images/logo.png",
                          width: 40,
                          height: 40,
                        )
                      : Text(AppLocalizations.of(context).translate("homePage")?? Const.homePage),
                  leading: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black87,
                      ),
                      onPressed: widget.onMenuPressed),
                ),
                Expanded(
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Wrap(
                                      children: List<Widget>.generate(
                                        3,
                                        (int index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: ChoiceChip(
                                              backgroundColor: Colors.black26,
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              selectedColor:
                                                  Color(ColorAsset.acentColor),
                                              label: Text(list[index]),
                                              selected: _value == index,
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  _value =
                                                      selected ? index : null;
                                                  searchController.clear();
                                                  searchValue = "";
                                                  if (_value == 1) {
                                                    searchController.text = "+91${searchValue}";
                                                  }

                                                });
                                              },
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    )
                                  ],
                                ),
                                getSearchBarUI(),
                              ],
                            );
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: _SliverAppBarDelegate(TabBar(
                            controller: _tabController,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Color(ColorAsset.acentColor),
                            labelColor: Color(ColorAsset.acentColor),
                            tabs: [
                              Tab(
                                child: Text(AppLocalizations.of(context).translate("farmer")?? Const.farmer),
                              ),
                              Tab(icon: Text(AppLocalizations.of(context).translate("partner")?? Const.businessPartner)),
                            ],
                          )),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        FarmerView(
                          searchValue: searchValue,
                          type: _value,
                        ),
                        BusinessPartnerView(searchValue: searchValue,
                          type: _value,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
      child: Stack(
        alignment: const Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: Colors.black26)),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                    searchValue = value;
                });
              },
              textInputAction: TextInputAction.search,
              style: new TextStyle(
                  fontSize: 14.0, height: 1.0, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search By GF Code",
                hintStyle: TextStyle(color: Colors.black26),
                contentPadding: EdgeInsets.only(left: 10, bottom: 5),
              ),
            ),
          ),
          Container(
            height: 45,
            margin: EdgeInsets.only(
              right: 20,
            ),
            decoration: BoxDecoration(
                color: Color(ColorAsset.acentColor),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white, size: 15),
              onPressed: () {
                print("hello");
              },
            ),
          )
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
