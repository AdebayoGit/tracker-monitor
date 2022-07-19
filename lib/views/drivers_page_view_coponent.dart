import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            child: Obx(
                  () => PageView.builder(
                    itemCount: controller.drivers.length,
                    controller: PageController(viewportFraction: 0.9),
                    onPageChanged: (int index) {

                    },
                    itemBuilder: (_, i) {
                      List<Driver> drivers = controller.drivers;
                      return Transform.scale(
                        scale: i == 1 ? 1 : 0.9,
                        child: Container(
                          height: Get.height * 0.3,
                          width: Get.width * 0.9,
                          decoration: BoxDecoration(
                            color: AppTheme.nearlyWhite,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0.5, 0.5),
                                color:
                                AppTheme.nearlyBlack.withOpacity(0.12),
                                blurRadius: 20,
                              ),
                            ],
                            //borderRadius: BorderRadius.circular(10.00),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: CachedNetworkImage(
                                  height: Get.height * 0.13,
                                  width: Get.height * 0.15,
                                  color: AppTheme.primaryColor,
                                  imageUrl: drivers[i].photoUrl,
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
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, right: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Wrap(
                                        alignment: WrapAlignment.start,
                                        spacing: 2,
                                        direction: Axis.vertical,
                                        children: <Widget>[
                                          Text(
                                            drivers[i].username,
                                            style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 15,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 230,
                                            child: Text(
                                              "",
                                              overflow:
                                              TextOverflow.ellipsis,
                                              maxLines: 4,
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 10,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
        ));
  }
}
