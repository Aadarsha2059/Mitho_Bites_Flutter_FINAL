import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/app/shared_pref/token_shared_prefs.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart'; // Added for debugPrint

class PurchaseTrendPage extends StatefulWidget {
  const PurchaseTrendPage({super.key});

  @override
  State<PurchaseTrendPage> createState() => _PurchaseTrendPageState();
}

class _PurchaseTrendPageState extends State<PurchaseTrendPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _trend = [];
  final Dio _dio = serviceLocator<Dio>(); // Use dependency-injected Dio instance

  @override
  void initState() {
    super.initState();
    _fetchTrend();
  }

  Future<void> _fetchTrend() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final token = await _getToken();
      if (token.isEmpty) {
        setState(() {
          _error = "You are not logged in. Please log in to view your purchase trend.";
          _loading = false;
        });
        return;
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final url = ApiEndpoints.baseUrl + 'orders/trend';
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'] as List<dynamic>?; // Added type safety
        if (data != null) {
          setState(() {
            _trend = data.cast<Map<String, dynamic>>(); // Safer casting
            _loading = false;
          });
        } else {
          setState(() {
            _error = 'Invalid data format received from server.';
            _loading = false;
          });
        }
      } else {
        setState(() {
          _error = response.data['message']?.toString() ?? 'Failed to fetch purchase trend.';
          _loading = false;
        });
      }
    } catch (e, st) {
      setState(() {
        _error = 'Error fetching data: $e';
        _loading = false;
      });
      debugPrint('Error fetching trend: $e\nStack trace: $st');
    }
  }

  Future<String> _getToken() async {
    try {
      final tokenResult = await serviceLocator<TokenSharedPrefs>().getToken();
      return tokenResult.fold(
        (failure) => '',
        (token) => token ?? '',
      );
    } catch (e) {
      debugPrint('Error retrieving token: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Purchase Trend'),
        backgroundColor: Colors.deepOrange,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _trend.isEmpty
              ? const Center(child: Text('No purchase data available.'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final chartHeight = (constraints.maxHeight - 120) / 2;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'My Purchase Trend (Last 7 Days)',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            // Items Received Chart
                            Container(
                              height: chartHeight > 220 ? 220 : chartHeight,
                              constraints: const BoxConstraints(minHeight: 180, maxHeight: 260),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text('Items Received', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange)),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: LineChart(
                                      LineChartData(
                                        gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1),
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 36,
                                              getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 12)),
                                            ),
                                            axisNameWidget: const SizedBox.shrink(),
                                            axisNameSize: 0,
                                          ),
                                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                final idx = value.toInt();
                                                if (idx < 0 || idx >= _trend.length) return const SizedBox.shrink();
                                                final date = (_trend[idx]['date'] as String).substring(5); // MM-DD
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text(date, style: const TextStyle(fontSize: 12)),
                                                );
                                              },
                                              interval: 1,
                                            ),
                                            axisNameWidget: const SizedBox.shrink(),
                                            axisNameSize: 0,
                                          ),
                                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        ),
                                        borderData: FlBorderData(show: true),
                                        minX: 0,
                                        maxX: (_trend.length - 1).toDouble(),
                                        minY: 0,
                                        maxY: 5,
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: [
                                              for (int i = 0; i < _trend.length; i++)
                                                FlSpot(i.toDouble(), (_trend[i]['itemsReceived'] as num).toDouble()),
                                            ],
                                            isCurved: true,
                                            color: Colors.deepOrange,
                                            barWidth: 4,
                                            dotData: FlDotData(show: true),
                                            belowBarData: BarAreaData(show: true, color: Colors.deepOrange.withOpacity(0.15)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Indexing/axis labels below the chart
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Items', style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                                      Text('Days', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(width: 16, height: 4, color: Colors.deepOrange, margin: const EdgeInsets.only(right: 6)),
                                      const Text('Items Received', style: TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Amount Spent Chart
                            Container(
                              height: chartHeight > 220 ? 220 : chartHeight,
                              constraints: const BoxConstraints(minHeight: 180, maxHeight: 260),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.10),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text('Amount Spent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: LineChart(
                                      LineChartData(
                                        gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1),
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 48,
                                              getTitlesWidget: (value, meta) => Text('₹${value.toInt()}', style: const TextStyle(fontSize: 13, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                                            ),
                                            axisNameWidget: const SizedBox.shrink(),
                                            axisNameSize: 0,
                                          ),
                                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                final idx = value.toInt();
                                                if (idx < 0 || idx >= _trend.length) return const SizedBox.shrink();
                                                final date = (_trend[idx]['date'] as String).substring(5); // MM-DD
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text(date, style: const TextStyle(fontSize: 12)),
                                                );
                                              },
                                              interval: 1,
                                            ),
                                            axisNameWidget: const SizedBox.shrink(),
                                            axisNameSize: 0,
                                          ),
                                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        ),
                                        borderData: FlBorderData(show: true),
                                        minX: 0,
                                        maxX: (_trend.length - 1).toDouble(),
                                        minY: 0,
                                        maxY: 1500,
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: [
                                              for (int i = 0; i < _trend.length; i++)
                                                FlSpot(i.toDouble(), (_trend[i]['totalAmount'] as num).toDouble()),
                                            ],
                                            isCurved: true,
                                            color: Colors.blueAccent,
                                            barWidth: 5,
                                            dotData: FlDotData(show: true),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blueAccent.withOpacity(0.25),
                                                  Colors.blueAccent.withOpacity(0.05),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blueAccent,
                                                Colors.lightBlueAccent,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            shadow: const Shadow(
                                              color: Colors.blueGrey,
                                              blurRadius: 8,
                                              offset: Offset(2, 4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Indexing/axis labels below the chart
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Amount', style: TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                                      Text('Days', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(width: 16, height: 4, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent])), margin: const EdgeInsets.only(right: 6)),
                                      const Text('Amount Spent', style: TextStyle(fontSize: 13, color: Colors.blueAccent)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}