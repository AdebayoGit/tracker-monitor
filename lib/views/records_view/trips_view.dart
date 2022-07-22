import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:viewer/views/records_view/views/trips_search_delegate.dart';

import '../../controllers/trips_controller.dart';
import '../../models/trip.dart';
import '../../utils/app_theme.dart';
import '../riders_view/views/driver_search_delegate.dart';

class TripsView extends GetResponsiveView<TripsController> {
  TripsView({required this.username, Key? key}) : super(key: key) {
    Get.find<TripsController>();
  }

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        centerTitle: true,
        title: Text(
          username.toUpperCase(),
          style: const TextStyle(letterSpacing: 5, fontFamily: 'WorkSans'),
        ),
        titleSpacing: 2,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: TripsSearchView(),
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
                      replacement: ListTile(
                        onTap: () {},
                        leading: const SizedBox(
                          height: 45,
                          width: 45,
                          child: Card(
                            shape: CircleBorder(),
                            color: AppTheme.primaryDarkColor,
                            child: Icon(
                              Icons.pending,
                              color: AppTheme.colorOrange,
                            ),
                          ),
                        ),
                        title: Text(
                          trip.id.toUpperCase(),
                          maxLines: 1,
                          textScaleFactor: 0.7,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            textStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                              color: AppTheme.primaryDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Ended ${timeago.format(trip.createdAt, allowFromNow: true)}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.yellow[900]),
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppTheme.secondaryColor),
                          onPressed: () {},
                          child: Text(
                            'View',
                            maxLines: 1,
                            textScaleFactor: 0.8,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.yellow[900],
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {},
                        leading: const SizedBox(
                          height: 45,
                          width: 45,
                          child: Card(
                            shape: CircleBorder(),
                            color: AppTheme.primaryDarkColor,
                            child: Icon(
                              Icons.done_all,
                              color: AppTheme.colorGreen,
                            ),
                          ),
                        ),
                        title: Text(
                          trip.id.toUpperCase(),
                          maxLines: 1,
                          textScaleFactor: 0.7,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            textStyle:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: AppTheme.primaryDarkColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        subtitle: Text(
                          'Ended ${timeago.format(trip.createdAt, allowFromNow: true)}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.yellow[900]),
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppTheme.secondaryColor),
                          onPressed: () {},
                          child: Text(
                            'View',
                            maxLines: 1,
                            textScaleFactor: 0.8,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.yellow[900],
                                letterSpacing: 2,
                              ),
                            ),
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
