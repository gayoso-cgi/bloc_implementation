import 'dart:convert';

import 'package:bloc_implementation/src/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/helper/constants/strings_constants.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_state.dart';

class HomeScreens extends StatefulWidget {
  static const String ROUTE_ID = "HomeScreens";
  const HomeScreens();

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  ScrollController scrollController = ScrollController();

  TextEditingController editingController = TextEditingController();

  final HomeScreenBloc? _bloc = HomeScreenBloc();

  DateTime? _lastPressedAt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc!.reset(CategoryContentEnum.RESET);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
  }

  voidStateTextSearch(String value) async {
    setState(() {
      if (_bloc!.application.currentCategory != CategoryContentEnum.SEARCH) {
        _bloc!.application.setCategoryType(CategoryContentEnum.SEARCH);
        _bloc!.application.setLihatSemuaFalse();
      }
      _bloc!.application.clearData();
      _bloc!.fetchSearchBloc(value);
      print(_bloc!.application.currentCategory);
      print(_bloc!.application.textSearch);
    });
  }

  voidStateLihatSemuaSelected(CategoryContentEnum stateEnum) async {
    setState(() {
      _bloc!.application.clearData();
      _bloc!.getContentBloc(stateEnum);

      print("--------------------------- ${stateEnum}");
    });
  }

  void _showToast(BuildContext context, title, label) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(title),
        action: SnackBarAction(
          label: label,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              setState(() {
                editingController.clear();
                if (!_bloc!.application.isLihatSemua) {
                  _bloc!.reset(CategoryContentEnum.RESET);
                } else {
                  if (_lastPressedAt == null ||
                      DateTime.now().difference(_lastPressedAt!) >
                          Duration(seconds: 1)) {
                    _showToast(context, 'Ketuk 2x untuk Keluar Aplikasi', '');
                    _lastPressedAt = DateTime.now();
                  } else {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }
                }
                voidStateLihatSemuaSelected(CategoryContentEnum.RESET);
              });
              return Future.value();
            },
            child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    editingController.clear();
                    // if(!_bloc!.application.isLihatSemua){
                    //   voidStateLihatSemuaSelected(CategoryContentEnum.RESET);
                    //   return ;
                    // } else {
                    //   voidStateLihatSemuaSelected(_bloc!.application.currentCategory);
                    // }
                    voidStateLihatSemuaSelected(
                        _bloc!.application.currentCategory);
                  });
                  return Future.value();
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      voidAppBar(),
                      voidSearch(),
                      StateHomeContent(
                        scrollController: scrollController,
                        selected: (value) => voidStateLihatSemuaSelected(value),
                        bloc: _bloc!,
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget voidAppBar() {
    return Container(
      color: primaryColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _bloc!.application.isLihatSemua == false
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                            ),
                            color: scondaryColor,
                            onPressed: () {
                              setState(() {
                                _bloc!.reset(CategoryContentEnum.RESET);
                              });
                            })
                        : Container(),
                    new Image.asset(
                      'assets/images/logo_e_repository.png',
                      fit: BoxFit.fitWidth,
                      width: 90,
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () => _showDialog(context),
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image:
                              AssetImage("assets/icons/tanda_tanya_icons.png"),
                        )),
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            child: Container(
              color: scondaryColor,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget voidSearch() {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14),
      child: TextField(
        onSubmitted: (value) {
          voidStateTextSearch(value);
        },
        textInputAction: TextInputAction.search,
        style: textStyle16PxW400,
        controller: editingController,
        decoration: InputDecoration(
            hintText: "Pencarian",
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
              iconSize: 30.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
                width: 1,
              ),
            )),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: new Image.asset(
                  'assets/images/logo_e_repository_dark.png',
                  fit: BoxFit.fitWidth,
                  width: 90,
                )),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Universitas ‘Aisyiyah Yogyakarta",
                  textAlign: TextAlign.center,
                  style:
                      new TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  amintMinim,
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontSize: 13),
                ),
              ],
            ));
      },
    );
  }
}
