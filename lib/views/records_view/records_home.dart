import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewer/controllers/trips_controller.dart';
import 'package:viewer/views/records_view/views/records_search_delegate.dart';

import '../../controllers/drivers_controller.dart';
import '../../models/driver.dart';
import '../../utils/app_theme.dart';

class RecordsHome extends GetResponsiveView<DriversController> {
  RecordsHome({Key? key}) : super(key: key) {
    Get.find<DriversController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        centerTitle: true,
        title: const Text(
          "Records",
          style: TextStyle(letterSpacing: 5, fontFamily: 'WorkSans'),
        ),
        titleSpacing: 2,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: RecordsSearchView(),
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
                  TripsController tripsController = Get.put(TripsController());
                  return Card(
                    child: ListTile(
                      onTap: () {
                        tripsController.getDriversTrips(driver: driver);
                      },
                      leading: CachedNetworkImage(
                        height: 60,
                        width: 60,
                        color: AppTheme.primaryColor,
                        imageUrl: driver.photoUrl == ''
                            ? 'https://bit.ly/3rFRhWH'
                            : driver.photoUrl,
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
                      title: Text(
                        driver.username.toUpperCase(),
                        textScaleFactor: 0.7,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.lato(
                          textStyle:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: AppTheme.primaryDarkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      //subtitle: Text(getCurrency() + amt.nonSymbol),
                      subtitle: RichText(
                        maxLines: 1,
                        textScaleFactor: 0.8,
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color: AppTheme.primaryDarkColor,
                                  ),
                            ),
                            children: [
                              const TextSpan(
                                text: 'Last Trip: ',
                              ),
                              TextSpan(
                                text: driver.lastTrip,
                                style: const TextStyle(
                                  color: AppTheme.colorOrange,
                                ),
                              ),
                            ]),
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              Future.delayed(const Duration(microseconds: 200), () => tripsController.getDriversTrips(driver: driver));

                            },
                            value: 1,
                            child: Text("View Records", style: GoogleFonts.lato()),
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
