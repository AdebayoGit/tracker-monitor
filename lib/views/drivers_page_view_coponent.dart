import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewer/controllers/drivers_controller.dart';

import '../models/driver.dart';
import '../utils/app_theme.dart';


class DriversPageView extends GetResponsiveView<DriversController> {
  DriversPageView({Key? key}) : super(key: key){
    Get.lazyPut(() => DriversController());
  }

  @override
  Widget build(BuildContext context) {
    return  Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 78.0),
          child: SizedBox(
            height: 116, // card height
            child: Obx(() {
                    List<Driver> drivers = controller.drivers;
                return PageView.builder(
                  itemCount: controller.drivers.length,
                  controller: PageController(viewportFraction: 0.8),
                  onPageChanged: (int index) {},
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == 1 ? 1 : 0.9,
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            controller.moveMap(drivers[i].username);
                          },
                          leading: CachedNetworkImage(
                            height: 100,
                            width: 60,
                            color: AppTheme.primaryColor,
                            imageUrl: drivers[i].photoUrl == ''
                                ? 'https://bit.ly/3rFRhWH'
                                : drivers[i].photoUrl,
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
                            drivers[i].username.toUpperCase(),
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
                            textScaleFactor: 0.7,
                            overflow: TextOverflow.ellipsis,
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
                                    text: drivers[i].lastTrip,
                                    style: const TextStyle(
                                      color: AppTheme.colorOrange,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ));
  }
}
