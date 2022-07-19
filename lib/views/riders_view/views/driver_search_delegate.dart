import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:viewer/controllers/drivers_controller.dart';

import '../../../models/driver.dart';
import '../../../utils/app_theme.dart';

class RiderSearchView extends SearchDelegate {

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
    DriversController controller = Get.put(DriversController());
    List<Driver> drivers = controller.searchForDriver(query: query);

    if (drivers.isEmpty) {
      return const Center(
        child: Text('There are no results matching your search !'),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              Driver driver = drivers[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    driver.photoUrl == ''
                        ? 'https://bit.ly/3rFRhWH'
                        : driver.photoUrl,
                    height: 60,
                    width: 60,
                    //color: AppTheme.primaryColor,
                    // Display when there is an error such as 404, 500 etc.
                    errorBuilder: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(driver.username),
                  //subtitle: Text(getCurrency() + amt.nonSymbol),
                  subtitle: Text(
                    'Created ${timeago.format(driver.createdAt, allowFromNow: true)}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.yellow[900]),
                    ),
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
                            Text("Edit", style: GoogleFonts.lato()),
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
                            const Icon(
                              Icons.delete,
                              color: AppTheme.colorOrange,
                            ),
                            Text("Delete", style: GoogleFonts.lato()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: drivers.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    DriversController controller = Get.put(DriversController());
    List<Driver> drivers = controller.searchForDriver(query: query);

    if (drivers.isEmpty) {
      return const Center(
        child: Text('There are no suggestions matching your search !'),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              Driver driver = drivers[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    driver.photoUrl == ''
                        ? 'https://bit.ly/3rFRhWH'
                        : driver.photoUrl,
                    height: 60,
                    width: 60,
                    // Covers image with color
                    //color: AppTheme.primaryColor,
                    // Display when there is an error such as 404, 500 etc.
                    errorBuilder: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                  title: Text(driver.username),
                  //subtitle: Text(getCurrency() + amt.nonSymbol),
                  subtitle: Text(
                    'Created ${timeago.format(driver.createdAt, allowFromNow: true)}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.yellow[900]),
                    ),
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
                            Text("Edit", style: GoogleFonts.lato()),
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
                            const Icon(
                              Icons.delete,
                              color: AppTheme.colorOrange,
                            ),
                            Text("Delete", style: GoogleFonts.lato()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: drivers.length,
          ),
        ),
      ],
    );
  }
}
