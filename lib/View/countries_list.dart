import 'package:covid_tracker/View/details_screen.dart';
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
                  Provider.of<StatsServices>(
                    context,
                    listen: false,
                  ).filterCountries(value);
                },
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search with country name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(50),
                  ),
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
                if (val.filteredCountriesList.isEmpty &&
                    !val.loadingCountries) {
                  return Center(child: Text("No countries found."));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: val.filteredCountriesList.length,
                    itemBuilder: (context, index) {
                      String countryName =
                          val.filteredCountriesList[index]['country'];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  countryName: countryName,
                                  active: val
                                      .filteredCountriesList[index]['active']
                                      .toString(),
                                  population: val
                                      .filteredCountriesList[index]['population']
                                      .toString(),
                                  todayCases: val
                                      .filteredCountriesList[index]['todayCases']
                                      .toString(),
                                  totalDeaths: val
                                      .filteredCountriesList[index]['deaths']
                                      .toString(),
                                  totalCases: val
                                      .filteredCountriesList[index]['cases']
                                      .toString(),
                                  totalRecovered: val
                                      .filteredCountriesList[index]['recovered']
                                      .toString(),
                                  image: val
                                      .filteredCountriesList[index]['countryInfo']['flag'],
                                  continent: val
                                      .filteredCountriesList[index]['continent'],
                                  crtitcal: val
                                      .filteredCountriesList[index]['critical']
                                      .toString(),
                                ),
                              ),
                            );
                          },
                          leading: SizedBox(
                            height: 35,
                            width: 50,
                            child: ClipRRect(
                              child: Image.network(
                                val.filteredCountriesList[index]['countryInfo']['flag'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.flag),
                              ),
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(
                            countryName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Text(
                            val.filteredCountriesList[index]['cases']
                                .toString(),
                          ),
                        ),
                      );
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
