import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewer/views/riders_view/views/add_driver_view.dart';

import 'package:viewer/views/riders_view/views/driver_search_delegate.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controllers/drivers_controller.dart';
import '../../models/driver.dart';
import '../../utils/app_theme.dart';

class RidersDashboard extends GetResponsiveView<DriversController> {
  RidersDashboard({Key? key}) : super(key: key) {
    Get.lazyPut(() => DriversController());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.bottomSheet(
              AddNewDriver(),
            backgroundColor: AppTheme.nearlyWhite,
            ignoreSafeArea: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.zero,
                elevation: 10,
                shadowColor: AppTheme.grey,
                color: AppTheme.primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Container(
                  height: Get.height * 0.3,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                        color: const Color(0xFFB0CCE1).withOpacity(0.32),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Obx(() {
                    if (controller.drivers.isEmpty) {
                      return Container();
                    }
                    return CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              Driver driver = controller.drivers[index];
                              return Card(
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    color: AppTheme.primaryColor,
                                    imageUrl: driver.photoUrl == '' ? 'https://bit.ly/3rFRhWH' : driver.photoUrl,
                                    // Display when there is an error such as 404, 500 etc.
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration: const Duration(milliseconds: 1000),
                                    fadeOutCurve: Curves.easeOut,
                                    fadeOutDuration: const Duration(milliseconds: 500),
                                    imageBuilder: (context, imageProvider) => SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image(
                                        image: imageProvider,
                                      ),
                                    ),
                                    //display while fetching image.
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress)),
                                  ),
                                  title: Text(driver.username),
                                  //subtitle: Text(getCurrency() + amt.nonSymbol),
                                  subtitle: Text('Created ${timeago.format(driver.createdAt, allowFromNow: true)}',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(color: Colors.yellow[900]),),
                                  ),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        onTap: () {},
                                        value: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.edit,
                                              color: AppTheme.secondaryLightColor,
                                            ),
                                            Text(
                                                "Edit",
                                                style: GoogleFonts.lato()
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () async {
                                          await controller.delete(username: driver.username);
                                        },
                                        value: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(Icons.delete, color: AppTheme.colorOrange,),
                                            Text("Delete", style: GoogleFonts.lato()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: controller.drivers.length,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
          Positioned(
            top: 38,
            right: 10,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppTheme.nearlyWhite,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.6),
                      offset: const Offset(2.0, 4.0),
                      blurRadius: 8),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: RiderSearchView(),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 20,
            child: FittedBox(
              child: Text(
                "Hello, Viewer!",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.nearlyWhite,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 70,
              child: Card(
                elevation: 10,
                shadowColor: AppTheme.primaryLightColor,
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FittedBox(
                      child: Text(
                        'Total Drivers',
                        style: GoogleFonts.roboto(
                          textStyle: AppTheme.headline,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Get.height * 0.01),
                      child: FittedBox(
                        child: Obx(
                          () => Text(
                            '${controller.drivers.length}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontFamily: 'DIGITAL-7',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
