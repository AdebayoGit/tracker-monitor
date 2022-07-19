import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;


import 'package:viewer/controllers/drivers_controller.dart';

import '../../../models/driver.dart';
import '../../../utils/app_theme.dart';
import 'driver_search_delegate.dart';

class DriversCatalogue extends GetResponsiveView<DriversController> {
  DriversCatalogue({Key? key}) : super(key: key) {
    Get.find<DriversController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        centerTitle: true,
        title: const Center(
            child: Text(
          "Drivers' Catalogue",
          style: TextStyle(letterSpacing: 5, fontFamily: 'WorkSans'),
        )),
        titleSpacing: 2,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: RiderSearchView(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.drivers.isEmpty) {
          return Container();
        }
        return CustomScrollView(
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
    );
  }
}
