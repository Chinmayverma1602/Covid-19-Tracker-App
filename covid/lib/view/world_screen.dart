import 'package:covid/services/utility/states_services.dart';
import 'package:covid/view/countries_list.dart';
import 'package:covid/view/model/worldstatesmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * .01,
      ),
      // ... (Previous code)

      FutureBuilder(
        future: statesServices.fecthWorldStatesRecords(),
        builder: (context, AsyncSnapshot<Worldstatesmodel> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
                controller: _controller,
              ),
            );
          } else {
            return Column(
              children: [
                PieChart(
                  dataMap:  {
                    "Total": double.parse(snapshot.data!.cases!.toString()),
                    "Recovered":  double.parse(snapshot.data!.recovered.toString()),
                    "Death":  double.parse(snapshot.data!.deaths.toString()),
                  },
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true
                  ),
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  legendOptions:
                      const LegendOptions(legendPosition: LegendPosition.left),
                  animationDuration: const Duration(microseconds: 1200),
                  chartType: ChartType.ring,
                  colorList: colorList,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * .06),
                  child: Card(
                    child: Column(
                      children: [
                        ReusableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                        ReusableRow(title: 'Death', value: snapshot.data!.deaths.toString()),
                        ReusableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                        ReusableRow(title: 'Active', value: snapshot.data!.active.toString()),
                        ReusableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                        ReusableRow(title: 'Today Death', value: snapshot.data!.todayDeaths.toString()),
                        ReusableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  CountriesListScreen()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff1aa260),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Track Countries'),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      )
    ])));
  }
}

// ... (Remaining code)

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider()
        ],
      ),
    );
  }
}
