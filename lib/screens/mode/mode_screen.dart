import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:toeicking2021/config/ui_const.dart';
import 'package:toeicking2021/screens/mode/widgets/widgets.dart';
import 'package:toeicking2021/screens/screens.dart';
import 'package:toeicking2021/widgets/custom_elevated_button.dart';

class ModeScreen extends StatefulWidget {
  static const String routeName = '/mode';
  // nav_item的頁面不用寫route()方法
  // 開發階段用的route方法，之後要刪掉
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ModeScreen(),
    );
  }

  const ModeScreen({Key key}) : super(key: key);

  @override
  _ModeScreenState createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  bool showWrap = true;
  @override
  Widget build(BuildContext context) {
    // 螢幕size
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      // appBar: AppBar(
      //   title: Text('學習模式'),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       // 先導到ModeResultScreen
      //       onPressed: () => Navigator.of(context).pushNamed(
      //         ModeResultScreen.routeName,
      //         // 路由參數先給空的map
      //         arguments: ModeResultScreenArgs(
      //           searchConditions: {},
      //         ),
      //       ),
      //       icon: Icon(Icons.forward),
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            height: size.height * 0.4,
            color: Theme.of(context).primaryColor,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        // 先導到ModeResultScreen
                        onPressed: () => Navigator.of(context).pushNamed(
                          ModeResultScreen.routeName,
                          // 路由參數先給空的map
                          arguments: ModeResultScreenArgs(
                            searchConditions: {},
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '篩選您要學習的內容',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.0),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29.5),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "關鍵字搜尋",
                          icon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: [
                          GridCard(
                            imageSrc: 'assets/images/scenario.png',
                            title: '情境',
                            press: _showDropDown(context),
                          ),
                          GridCard(
                            imageSrc: 'assets/images/test.png',
                            title: '大題',
                            press: _showMultiSelect(context),
                          ),
                          GridCard(
                            imageSrc: 'assets/images/grammar.png',
                            title: '文法',
                            press: _showNestedDropdown(context),
                          ),
                          GridCard(
                            imageSrc: 'assets/images/vocabulary.png',
                            title: '字彙',
                            press: () {},
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: GridView.count(
                    //     padding: EdgeInsets.only(bottom: 10.0),
                    //     // physics: AlwaysScrollableScrollPhysics(),
                    //     // 一列2個griditem
                    //     crossAxisCount: 2,
                    //     // 每個griditem的"寬長比"，.85代表寬度是長度的0.85倍
                    //     // ***gridview item的大小要從這裡調整***
                    //     // ***寬度是看一列有幾個griditem決定，長度就從比例來調整***
                    //     childAspectRatio: 1.1,
                    //     // 每個griditem的"水平間隔"
                    //     crossAxisSpacing: 20,
                    //     // 每個griditem的"垂直間隔"
                    //     mainAxisSpacing: 20,
                    //     children: [
                    //       GridCard(
                    //         imageSrc: 'assets/images/scenario.png',
                    //         title: '情境',
                    //         press: () {},
                    //       ),
                    //       GridCard(
                    //         imageSrc: 'assets/images/test.png',
                    //         title: '大題',
                    //         press: () {},
                    //       ),
                    //       GridCard(
                    //         imageSrc: 'assets/images/grammar.png',
                    //         title: '文法',
                    //         press: () {},
                    //       ),
                    //       GridCard(
                    //         imageSrc: 'assets/images/vocabulary.png',
                    //         title: '字彙',
                    //         press: () {},
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // 篩選條件+查詢按鈕(有選擇條件後才顯示)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showWrap
                            ? Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10.0,
                                // runSpacing: 5.0,
                                children: [
                                  // 篩選條件標籤
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //       color: Theme.of(context).primaryColor,
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(8.0),
                                  //     color: Color(0xFFF8F8F8),
                                  //   ),
                                  //   padding: EdgeInsets.all(5.0),
                                  //   child: Text(
                                  //     '篩選條件',
                                  //     style: TextStyle(
                                  //       fontSize: 16.0,
                                  //       color: Theme.of(context).primaryColor,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Chip標籤
                                  // Chip(
                                  //   label: Text('大題：Part 3'),
                                  // ),
                                  // Chip(
                                  //   label: Text('文法：現在簡單式'),
                                  // ),
                                  // Chip(
                                  //   label: Text('大題：Part 3'),
                                  // ),
                                  // Chip(
                                  //   label: Text('文法：現在簡單式'),
                                  // ),
                                ],
                              )
                            : SizedBox.shrink(),
                        // Accordion
                        // GFAccordion(
                        //     title: 'GF Accordion',
                        //     content:
                        //         'GetFlutter is an open source library that comes with pre-build 1000+ UI components.',
                        //     collapsedIcon: Text('Show'),
                        //     expandedIcon: Text('Hide')),
                        SizedBox(
                          height: 10.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: CustomElevatedButton(
                              fontSize: 18.0,
                              edgeInset: EdgeInsets.symmetric(
                                horizontal: 120,
                                vertical: 10.0,
                              ),
                              text: '查詢',
                              onPressed: () {}),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  VoidCallback _showDropDown(BuildContext context) {
    return () {
      showModalBottomSheet(
        // 設此屬性，長度為100%
        // isScrollControlled: true,
        shape: kBottomSheetTopRoundedCorner,
        context: context,
        builder: (_) => ScenarioBottomSheet(),
      );
    };
  }

  VoidCallback _showMultiSelect(BuildContext context) {
    return () {
      showModalBottomSheet(
        // 設此屬性，長度為100%
        // isScrollControlled: true,
        shape: kBottomSheetTopRoundedCorner,
        context: context,
        builder: (_) => CategoryBottomSheet(),
      );
    };
  }

  VoidCallback _showNestedDropdown(BuildContext context) {
    return () {
      showModalBottomSheet(
        // 設此屬性，長度為100%
        // isScrollControlled: true,
        shape: kBottomSheetTopRoundedCorner,
        context: context,
        builder: (_) => GrammarBottomSheet(),
      );
    };
  }
}
