import 'package:covid_tracker/View/countries_list.dart';
import 'package:covid_tracker/services/chart.dart';
import 'package:covid_tracker/services/stats_services.dart';
import 'package:covid_tracker/services/theme_provider.dart';
import 'package:covid_tracker/services/utilities/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({super.key});

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    final stats = Provider.of<StatsServices>(context, listen: false);
    if (stats.worldStats == null && !stats.loading) {
      stats.getWorldStats();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // final colorList = <Color>[
  //   const Color(0xff1E88E5),
  //   const Color(0xff43A047),
  //   const Color(0xffFF5252),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<StatsServices>(
            builder: (ctx, val, child) {
              if (val.loading) {
                return SpinKitFadingCircle(
                  color: const Color(0xff1E88E5),
                  controller: _controller,
                  size: 50,
                );
              }
              if (val.errorStats != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        val.errorStats.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          context.read<StatsServices>().getWorldStats();
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<StatsServices>().getWorldStats();
                        },
                        child: const Text(
                          "Retry",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (val.worldStats == null) {
                return Text('No data found!');
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Consumer<ThemeProvider>(
                                builder: (ct, theme, c) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Dark Mode'),
                                    Transform.scale(
                                      scale: 0.7, // 70% of original size
                                      child: Switch(
                                        value: theme.isDark,
                                        onChanged: (value) {
                                          theme.updateTheme(value);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Consumer<StatsServices>(
                        builder: (context, val, child) {
                          if (val.worldStats != null) {
                            return AnimatedWorldStatsChart(
                              worldStats: val.worldStats!,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  ReuseableRow(
                                    title: 'Total',
                                    value: double.parse(
                                      val.worldStats!.cases.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Deaths',
                                    value: double.parse(
                                      val.worldStats!.deaths.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Recovered',
                                    value: double.parse(
                                      val.worldStats!.recovered.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Active',
                                    value: double.parse(
                                      val.worldStats!.active.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Critical',
                                    value: double.parse(
                                      val.worldStats!.critical.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Today Cases',
                                    value: double.parse(
                                      val.worldStats!.todayCases.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Today Deaths',
                                    value: double.parse(
                                      val.worldStats!.todayDeaths.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Recovered Today',
                                    value: double.parse(
                                      val.worldStats!.todayRecovered.toString(),
                                    ).toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Effected Countries',
                                    value: double.parse(
                                      val.worldStats!.affectedCountries
                                          .toString(),
                                    ).toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountriesList(),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: const Color(0xff1E88E5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Track Countries",
                                style: TextStyle(fontWeight: .bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  final String title, value;
  const ReuseableRow({super.key, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      trailing: Text(
        NumberFormatter.format(double.parse(value)),
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }
}
