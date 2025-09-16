import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:intl/intl.dart';
import 'package:slides/download_stats.dart';

class StatsSlide extends FlutterDeckSlideWidget {
  StatsSlide({
    super.key,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: '/stats-slide',
           speakerNotes: '',
           title: 'Download Stats',
           header: FlutterDeckHeaderConfiguration(
             title: 'Download Stats - jnigen vs pigeon',
           ),
           steps: 3,
         ),
       );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: FlutterDeckSlideStepsBuilder(
          builder: (context, stepNumber) {
            final minDate = jniGenDowloads.keys.followedBy(pigeonDownloads.keys).reduce((a, b) => a.isBefore(b) ? a : b);
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: stepNumber > 1 ? 1 : 0,
                child: Column(
                  spacing: 32,
                  children: [
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: FlGridData(
                            drawVerticalLine: false,
                            drawHorizontalLine: true,
                            horizontalInterval: stepNumber > 2 ? 10000 : 1000,
                          ),

                          lineBarsData: [
                            LineChartBarData(
                              spots: jniGenDowloads.entries.map((entry) {
                                final date = entry.key;
                                final downloads = entry.value;
                                final days = date.difference(minDate).inDays;

                                return FlSpot(
                                  days.toDouble(),
                                  downloads.toDouble(),
                                );
                              }).toList(),
                              isCurved: true,
                              barWidth: 4,
                              color: const Color(0xFFFFA726),
                            ),
                            if (stepNumber > 2)
                              LineChartBarData(
                                spots: pigeonDownloads.entries.map((entry) {
                                  final date = entry.key;
                                  final downloads = entry.value;
                                  final days = date.difference(minDate).inDays;

                                  return FlSpot(
                                    days.toDouble(),
                                    downloads.toDouble(),
                                  );
                                }).toList(),
                                isCurved: true,
                                barWidth: 4,
                                color: const Color(0xFF42A5F5),
                              ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 60,
                                maxIncluded: false,

                                getTitlesWidget: (value, meta) {
                                  final date = minDate.add(
                                    Duration(days: value.toInt()),
                                  );
                                  final format = DateFormat('MMM yyyy');
                                  return Text(format.format(date));
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),

                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: stepNumber > 2 ? 10000 : 1000,
                                minIncluded: false,
                                reservedSize: 80,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          minY: 0,
                        ),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOutCubic,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          color: const Color(0xFFFFA726),
                        ),
                        const SizedBox(width: 8),
                        const Text('jnigen'),
                        AnimatedCrossFade(
                          firstChild: Row(
                            children: [
                              const SizedBox(width: 32),
                              Container(
                                width: 32,
                                height: 32,
                                color: const Color(0xFF42A5F5),
                              ),
                              const SizedBox(width: 8),
                              const Text('pigeon'),
                            ],
                          ),
                          alignment: Alignment.topLeft,
                          secondChild: const SizedBox(width: 0, height: 32),
                          crossFadeState: stepNumber > 2 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
