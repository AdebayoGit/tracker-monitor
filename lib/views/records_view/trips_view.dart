import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controllers/drivers_controller.dart';
import '../../models/trip.dart';
import '../../utils/app_theme.dart';
import '../riders_view/views/driver_search_delegate.dart';


class TripsView extends GetResponsiveView<DriversController> {
  TripsView({Key? key}) : super(key: key){
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
                delegate: RiderSearchView(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.trips.isEmpty) {
          return Container();
        }
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  Trip trip = controller.trips[index];
                  return Card(
                    child: Visibility(
                      visible: trip.status == 'completed',
                      child: ListTile(
                        onTap: () {},
                        title: Text(
                          trip.id.toUpperCase(),
                          textScaleFactor: 0.7,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                              color: AppTheme.primaryDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text('Ended ${timeago.format(trip.createdAt, allowFromNow: true)}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.yellow[900]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: controller.trips.length,
              ),
            ),
          ],
        );
      }),
    );
  }
}