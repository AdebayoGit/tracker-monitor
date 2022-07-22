import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:viewer/controllers/trips_controller.dart';

import '../../../controllers/trips_controller.dart';
import '../../../models/trip.dart';
import '../../../utils/app_theme.dart';

class TripsSearchView extends SearchDelegate {

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: AppTheme.colorOrange),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    TripsController controller = Get.find<TripsController>();
    List<Trip> trips = controller.searchForTrip(query: query);

    if (trips.isEmpty) {
      return const Center(
        child: Text('There are no results matching your search !'),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              Trip trip = trips[index];
              return Card(
                child: ListTile(
                  onTap: () {

                  },
                  title: Text(trip.id),
                  //subtitle: Text(getCurrency() + amt.nonSymbol),
                  subtitle: Text(
                    'Created ${timeago.format(trip.createdAt, allowFromNow: true)}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.yellow[900]),
                    ),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {

                        },
                        value: 1,
                        child: Text("View Records", style: GoogleFonts.lato()),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: trips.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    TripsController controller = Get.find<TripsController>();
    List<Trip> trips = controller.searchForTrip(query: query);

    if (trips.isEmpty) {
      return const Center(
        child: Text('There are no suggestions matching your search !'),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              Trip trip = trips[index];
              return Card(
                child: ListTile(
                  onTap: () {

                  },
                  title: Text(trip.id),
                  //subtitle: Text(getCurrency() + amt.nonSymbol),
                  subtitle: Text(
                    'Created ${timeago.format(trip.createdAt, allowFromNow: true)}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.yellow[900]),
                    ),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {

                        },
                        value: 1,
                        child: Text("View Records", style: GoogleFonts.lato()),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: trips.length,
          ),
        ),
      ],
    );
  }
}
