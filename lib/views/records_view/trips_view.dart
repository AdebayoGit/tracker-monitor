import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:viewer/views/records_view/views/inprogress_trip_info_view.dart';
import 'package:viewer/views/records_view/views/trips_search_delegate.dart';

import '../../controllers/trips_controller.dart';
import '../../models/driver.dart';
import '../../models/trip.dart';
import '../../utils/app_theme.dart';
import '../trip_view/components/calender_pop_up.dart';
import 'components/name_change_widget.dart';

class TripViewTest extends GetView<TripsController> {
  TripViewTest({Key? key}) : super(key: key);

  DateTime startDate = DateTime.now();
  DateTime? endDate;
  bool filterByStart = true;



  final Driver driver = Get.arguments['driver'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        centerTitle: true,
        title: Text(
          driver.username.toUpperCase(),
          style:
          const TextStyle(letterSpacing: 5, fontFamily: 'WorkSans'),
        ),
        titleSpacing: 2,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: Get.context!,
                delegate: TripsSearchView(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Get.dialog(
                CalendarPopupView(
                  barrierDismissible: true,
                  initialEndDate: endDate,
                  initialStartDate: startDate,
                  filterByStart: filterByStart,
                  onApplyClick: (DateTime startDate, DateTime? endDate,
                      bool start) {
                    startDate = startDate;
                    endDate = endDate;
                    filterByStart = start;
                    Get.back();
                    controller.filterTrips(
                        startDate: startDate,
                        endDate: endDate,
                        byTripStartDate: start);
                  },
                  onCancelClick: () {},
                ),
                transitionDuration: const Duration(seconds: 1),
              );
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Obx(() {
        controller.getDriversTrips(driver: driver.username);
        List<Trip> trips = controller.tripsList;
        printInfo(info: controller.tripsList.length.toString());
        if (trips.isEmpty) {
          return const Center(child: Text('No trips'));
        }
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  Trip trip = trips[index];
                  return Card(
                    child: Visibility(
                      visible: trip.status == 'completed',
                      replacement: ListTile(
                        onTap: () async {
                          await controller.prepareUnCompletedTripForViewing(trip: trip).then((value) => Get.to(() =>
                              TripProgressReport(),
                              arguments: {'trip': trip}
                          ));
                        },
                        leading: const SizedBox(
                          height: 45,
                          width: 45,
                          child: Card(
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: AppTheme.colorOrange, width: 2),
                            ),
                            color: AppTheme.primaryColor,
                            shadowColor: AppTheme.primaryLightColor,
                            elevation: 3,
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
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                              color: AppTheme.primaryDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Started ${timeago.format(trip.createdAt, allowFromNow: true)}',
                          style: GoogleFonts.lato(
                            textStyle:
                            TextStyle(color: Colors.yellow[900]),
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.colorOrange,
                          ),
                          onPressed: () async {
                            await controller.prepareUnCompletedTripForViewing(trip: trip).then((value) => Get.to(() =>
                            TripProgressReport(),
                            arguments: {'trip': trip}
                            ));
                          },
                          child: Text(
                            'View Progress',
                            maxLines: 1,
                            textScaleFactor: 0.8,
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: AppTheme.primaryColor,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          controller.prepareCompletedTripForViewing(trip: trip);
                        },
                        leading: const SizedBox(
                          height: 45,
                          width: 45,
                          child: Card(
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: AppTheme.colorGreen, width: 2),
                            ),
                            color: AppTheme.primaryDarkColor,
                            child: Icon(
                              Icons.done_all,
                              color: AppTheme.colorGreen,
                            ),
                          ),
                        ),
                        title: Text(
                          trip.name.toUpperCase(),
                          maxLines: 1,
                          textScaleFactor: 0.7,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                              color: AppTheme.primaryDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Ended ${timeago.format(trip.createdAt, allowFromNow: true)}',
                          style: GoogleFonts.lato(
                            textStyle:
                            TextStyle(color: Colors.yellow[900]),
                          ),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                controller.prepareCompletedTripForViewing(trip: trip);
                              },
                              value: 1,
                              child: Text("View Trips", style: GoogleFonts.lato()),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                Future.delayed(const Duration(microseconds: 200), () => Get.dialog(NameChange(tripId: trip.id)));
                              },
                              value: 2,
                              child: Text("Rename Trip", style: GoogleFonts.lato()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: trips.length,
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        tooltip: 'Download Report',
        child: const Icon(Icons.download),
        onPressed: () {},
      ),
    );
  }
}
