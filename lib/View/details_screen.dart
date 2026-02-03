import 'package:covid_tracker/View/world_stats.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final String countryName;
  final String totalCases;
  final String active;
  final String todayCases;
  final String totalDeaths;
  final String totalRecovered;
  final String population;
  final String image;
  final String continent;
  final String crtitcal;
  const DetailsScreen({
    super.key,
    required this.countryName,
    required this.totalCases,
    required this.active,
    required this.todayCases,
    required this.totalDeaths,
    required this.totalRecovered,
    required this.population,
    required this.image,
    required this.continent,
    required this.crtitcal,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.countryName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.077,
              ),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Continent',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      trailing: Text(
                        widget.continent,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ReuseableRow(title: 'Active Cases', value: widget.active),
                    ReuseableRow(
                      title: 'Critical Cases',
                      value: widget.crtitcal,
                    ),
                    ReuseableRow(
                      title: 'Today Cases',
                      value: widget.todayCases,
                    ),
                    ReuseableRow(
                      title: 'Total Cases',
                      value: widget.totalCases,
                    ),
                    ReuseableRow(
                      title: 'Total Recovered',
                      value: widget.totalRecovered,
                    ),
                    ReuseableRow(
                      title: 'Total Deaths',
                      value: widget.totalDeaths,
                    ),
                    ReuseableRow(
                      title: 'Total Population',
                      value: widget.population,
                    ),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.image),
            ),
          ],
        ),
      ),
    );
  }
}
