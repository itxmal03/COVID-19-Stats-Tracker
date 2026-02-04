import 'package:covid_tracker/models/worldstats_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AnimatedWorldStatsChart extends StatefulWidget {
  final WorldStatsModel worldStats;
  const AnimatedWorldStatsChart({super.key, required this.worldStats});

  @override
  State<AnimatedWorldStatsChart> createState() =>
      _AnimatedWorldStatsChartState();
}

class _AnimatedWorldStatsChartState extends State<AnimatedWorldStatsChart> {
  Map<String, double> dataMap = {'Total': 0, 'Recovered': 0, 'Deaths': 0};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        dataMap = {
          'Total': double.parse(widget.worldStats.cases.toString()),
          'Recovered': double.parse(widget.worldStats.recovered.toString()),
          'Deaths': double.parse(widget.worldStats.deaths.toString()),
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
      ringStrokeWidth: 15,
      chartRadius: MediaQuery.of(context).size.width / 3.5,
      animationDuration: const Duration(milliseconds: 2700),
      colorList: [Colors.blue, Colors.green, Colors.red],
      chartValuesOptions: const ChartValuesOptions(
        showChartValuesInPercentage: true,
      ),
      legendOptions: const LegendOptions(
        legendTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        legendPosition: LegendPosition.left,
      ),
    );
  }
}
