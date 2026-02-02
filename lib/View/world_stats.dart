import 'package:covid_tracker/View/countries_list.dart';
import 'package:covid_tracker/services/stats_services.dart';
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
    stats.getWorldStats();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4A90E2),
    const Color(0xff34a0a4),
    const Color(0xff7ED321),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<StatsServices>(
            builder: (ctx, val, ch) {
              if (val.loading) {
                return SpinKitFadingCircle(
                  color: Colors.green,
                  controller: _controller,
                  size: 50,
                );
              }
              if (val.worldStats == null) {
                return Text('No data found!');
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      PieChart(
                        dataMap: {
                          'Total': double.parse(
                            val.worldStats!.cases.toString(),
                          ),
                          'Deaths': double.parse(
                            val.worldStats!.deaths.toString(),
                          ),
                          'Recovered': double.parse(
                            val.worldStats!.recovered.toString(),
                          ),
                        },
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        colorList: colorList,
                        animationDuration: const Duration(milliseconds: 1200),
                        chartRadius: MediaQuery.of(context).size.width / 3,
                        legendOptions: const LegendOptions(
                          legendPosition: .left,
                        ),
                        chartType: .ring,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03,
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
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
                      GestureDetector(
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
                            color: const Color(0xff34a0a4),
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
      title: Text(title, style: TextStyle(fontWeight: .bold)),
      trailing: Text(value),
    );
  }
}
