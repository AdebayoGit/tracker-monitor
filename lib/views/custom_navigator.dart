import 'package:flutter/material.dart';
import 'package:viewer/views/records_view/records_home.dart';
import 'package:viewer/views/riders_view/dashboard.dart';

import '../components/custom_drawer/drawer.dart';
import '../components/custom_drawer/drawer_controller.dart';
import '../utils/app_theme.dart';
import 'home_view.dart';

class CustomNavigator extends StatefulWidget {
  const CustomNavigator({Key? key}) : super(key: key);

  static const String id = 'navigator';

  @override
  CustomNavigatorState createState() => CustomNavigatorState();
}

class CustomNavigatorState extends State<CustomNavigator> {
  late Widget screenView;
  late DrawerIndex drawerIndex;
  late bool home;
  late Color color;


  @override
  void initState() {
    drawerIndex = DrawerIndex.home;
    home = false;
    screenView = const Home();
    color = AppTheme.nearlyBlack;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawerUserController(
        color: color,
        screenIndex: drawerIndex,
        drawerWidth: MediaQuery.of(context).size.width * 0.75,
        onDrawerCall: (DrawerIndex drawerIndexdata) {
          changeIndex(drawerIndexdata);
          //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
        },
        screenView: screenView,
        // ignore: avoid_types_as_parameter_names
        drawerIsOpen: (bool ) {  },
        //We replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.home) {
        setState(() {
          screenView = const Home();
          color = AppTheme.nearlyBlack;
        });
      } else if (drawerIndex == DrawerIndex.riders){
        setState(() {
          screenView = RidersDashboard();
          color = AppTheme.nearlyBlack;
        });
      } else if (drawerIndex == DrawerIndex.records){
        setState(() {
          screenView = RecordsHome();
          color = AppTheme.nearlyBlack;
        });
      } else if (drawerIndex == DrawerIndex.about){
        setState(() {
          screenView = Container();
          color = AppTheme.nearlyWhite;
        });
      } else if (drawerIndex == DrawerIndex.help){
        setState(() {
          screenView = const Home();
          color = AppTheme.nearlyBlack;
        });
      } else {
        //do in your way......
      }
    }
  }
}
