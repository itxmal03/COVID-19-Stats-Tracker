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
                left: MediaQuery.of(context).size.height * 0.007,
                right: MediaQuery.of(context).size.height * 0.007,
              ),
              child: Card(
                elevation: 3,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          'Continent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          widget.continent,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
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
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Hero(
                    tag: 'countryImage_${widget.countryName}',
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 10),
                            ],
                          ),
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'countryImage_${widget.countryName}',
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
