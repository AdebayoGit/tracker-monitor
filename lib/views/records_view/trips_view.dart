import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:viewer/views/records_view/views/trips_search_delegate.dart';

import '../../controllers/trips_controller.dart';
import '../../models/trip.dart';
import '../../utils/app_theme.dart';
import '../trip_view/components/calender_pop_up.dart';

class TripsView extends GetResponsiveView<TripsController> {
  TripsView({required this.username, Key? key}) : super(key: key) {
    Get.find<TripsController>();
  }

  final String username;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool filterByStart = true;

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
          IconButton(
            onPressed: () {
              Get.dialog(
                CalendarPopupView(
                  barrierDismissible: true,
                  initialEndDate: _endDate,
                  initialStartDate: _startDate,
                  filterByStart: filterByStart,
                  onApplyClick: (DateTime startDate, DateTime? endDate, bool start) {
                    _startDate = startDate;
                    _endDate = endDate;
                    filterByStart = start;
                    Get.back();
                    controller.filterTrips(startDate: startDate, endDate: endDate, byTripStartDate: start);
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
        RxList<Trip> trips = controller.trips;
        if (trips.isEmpty) {
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
                        onTap: () {

                        },
                        leading: const SizedBox(
                          height: 45,
                          width: 45,
                          child: Card(
                            shape: CircleBorder(
                              side: BorderSide(color: AppTheme.colorOrange, width: 2),
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
                            textStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                              color: AppTheme.primaryDarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Started ${timeago.format(trip.createdAt, allowFromNow: true)}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.yellow[900]),
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppTheme.colorOrange,
                          ),
                          onPressed: () {},
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
                              side: BorderSide(color: AppTheme.colorGreen, width: 2),
                            ),
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
                              primary: AppTheme.colorGreen,
                          ),
                          onPressed: () {
                            controller.prepareCompletedTripForViewing(trip: trip);
                          },
                          child: Text(
                            'View',
                            maxLines: 1,
                            textScaleFactor: 0.8,
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: AppTheme.primaryDarkColor,
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
