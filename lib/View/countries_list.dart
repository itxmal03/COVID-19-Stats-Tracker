import 'package:covid_tracker/services/stats_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({super.key});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final stats = Provider.of<StatsServices>(context, listen: false);
    if (stats.countriesList.isEmpty) {
      stats.getCountriesList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search with country name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Consumer<StatsServices>(
              builder: (ctx, val, ch) {
                if (val.loadingCountries) {
                  return Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade700,
                      highlightColor: Colors.grey.shade100,
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Container(
                                height: 35,
                                width: 50,
                                color: Colors.white,
                              ),
                              title: Container(
                                height: 10,
                                width: 89,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                height: 10,
                                width: 89,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: val.countriesList.length,
                    itemBuilder: (context, index) {
                      String countryName = val.countriesList[index]['country'];

                      if (searchController.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: SizedBox(
                              height: 35,
                              width: 50,
                              child: ClipRRect(
                                child: Image.network(
                                  val.countriesList[index]['countryInfo']['flag'],
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.flag),
                                ),
                              ),
                            ),
                            title: Text(
                              val.countriesList[index]['country'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              val.countriesList[index]['cases'].toString(),
                            ),
                          ),
                        );
                      } else if (countryName.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      )) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: SizedBox(
                              height: 35,
                              width: 50,
                              child: ClipRRect(
                                child: Image.network(
                                  val.countriesList[index]['countryInfo']['flag'],
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.flag),
                                ),
                              ),
                            ),
                            title: Text(
                              countryName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              val.countriesList[index]['cases'].toString(),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
