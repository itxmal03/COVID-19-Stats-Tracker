import 'package:covid_tracker/View/details_screen.dart';
import 'package:covid_tracker/services/stats_services.dart';
import 'package:covid_tracker/services/utilities/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
    searchController.clear();
    final stats = Provider.of<StatsServices>(context, listen: false);
    if (stats.countriesList.isEmpty) {
      stats.getCountriesList();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final stats = Provider.of<StatsServices>(context, listen: false);
    stats
        .resetFilteredCountries(); // Reset filtered list every time screen appears
    searchController.clear(); // Clear the search bar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Affected Countries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black54,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),

                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(50),
                  // ),
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
                if (val.errorCountries != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Text(
                        val.errorCountries.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          context.read<StatsServices>().getCountriesList();
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<StatsServices>().getCountriesList();
                        },
                        child: const Text(
                          "Retry",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  );
                }

                if (val.filteredCountriesList.isEmpty &&
                    !val.loadingCountries) {
                  return Center(child: Text("No countries found."));
                }
                return Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: val.filteredCountriesList.length,
                      itemBuilder: (context, index) {
                        String countryName =
                            val.filteredCountriesList[index]['country'];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
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
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.flag),
                                      ),
                                    ),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  title: Text(
                                    countryName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    NumberFormatter.format(
                                      double.tryParse(
                                            val.filteredCountriesList[index]['cases']
                                                    ?.toString() ??
                                                '0',
                                          ) ??
                                          0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
