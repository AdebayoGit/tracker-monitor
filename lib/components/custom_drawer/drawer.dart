import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewer/controllers/auth_controller.dart';

import '../../utils/app_theme.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer(
      {Key? key,
      required this.screenIndex,
      required this.iconAnimationController,
      required this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  late List<DrawerList> drawerList;
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.home,
        labelName: 'Home',
        icon: const Icon(Icons.home_outlined),
      ),
      DrawerList(
        index: DrawerIndex.riders,
        labelName: 'Riders',
        icon: const Icon(Icons.sports_motorsports_outlined),
      ),
      DrawerList(
        index: DrawerIndex.records,
        labelName: 'Records',
        icon: const Icon(Icons.receipt_long_outlined),
      ),
      DrawerList(
        index: DrawerIndex.help,
        labelName: 'Help',
        icon: const Icon(Icons.support_agent_outlined),
      ),
      DrawerList(
        index: DrawerIndex.about,
        labelName: 'About',
        icon: const Icon(Icons.app_registration),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: AnimatedBuilder(
                      animation: widget.iconAnimationController,
                      builder: (BuildContext context, Widget? child) {
                        return ScaleTransition(
                          scale: AlwaysStoppedAnimation<double>(1.0 -
                              (widget.iconAnimationController.value) * 0.2),
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                        begin: 0.0, end: 24.0)
                                    .animate(CurvedAnimation(
                                        parent: widget.iconAnimationController,
                                        curve: Curves.fastOutSlowIn))
                                    .value /
                                360),
                            child: CachedNetworkImage(
                              //width: size.width * 0.35,
                              color: AppTheme.primaryColor,
                              imageUrl: 'https://bit.ly/3rFRhWH',
                              // Display when there is an error such as 404, 500 etc.
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fadeInCurve: Curves.easeIn,
                              fadeInDuration:
                                  const Duration(milliseconds: 1000),
                              fadeOutCurve: Curves.easeOut,
                              fadeOutDuration:
                                  const Duration(milliseconds: 500),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.grey.withOpacity(0.6),
                                        offset: const Offset(2.0, 4.0),
                                        blurRadius: 8),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: imageProvider,
                                ),
                              ),
                              //display while fetching image.
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Hi ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                itemCount: drawerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return inkwell(drawerList[index]);
                },
          ),
            ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppTheme.lightText,
                    letterSpacing: 3,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: const Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () async {
                  AuthController controller = Get.find();

                  controller.signOut();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: AppTheme.secondaryColor),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? AppTheme.secondaryColor
                              : AppTheme.lightText),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 3,
                      color: widget.screenIndex == listData.index
                          ? AppTheme.secondaryColor
                          : AppTheme.lightText,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {home, records, about, help, riders}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    required this.icon,
    required this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
