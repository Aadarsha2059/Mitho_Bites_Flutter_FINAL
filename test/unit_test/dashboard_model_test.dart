import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/model/dashboard_model.dart';

void main() {
  group('DashboardModel', () {
    late DashboardModel model;

    setUp(() {
      model = DashboardModel();
    });

    tearDown(() {
      model.disposeControllers();
    });

    test('Initial filtered lists match original lists', () {
      expect(model.filteredCatArr, model.catArr);
      expect(model.filteredPopArr, model.popArr);
    });

    test('Filter search with empty query resets lists', () {
      model.filterSearch('');
      expect(model.filteredCatArr, model.catArr);
      expect(model.filteredPopArr, model.popArr);
      expect(model.searchStatus, '');
    });

    test('Filter search finds available category', () {
      model.filterSearch('Burger');
      expect(model.filteredCatArr.length, 1);
      expect(model.filteredCatArr.first['name'], 'Burger');
      expect(model.searchStatus, 'available');
    });

    test('Filter search finds available restaurant', () {
      model.filterSearch('Koteshwor');
      expect(model.filteredPopArr.length, 1);
      expect(model.filteredPopArr.first['name'], 'Koteshwor Rooftop');
      expect(model.searchStatus, 'available');
    });

    test('Filter search with no match sets status', () {
      model.filterSearch('xyz');
      expect(model.filteredCatArr, isEmpty);
      expect(model.filteredPopArr, isEmpty);
      expect(model.searchStatus, 'currently unavailable');
    });

    test('updateSelectedIndex updates index', () {
      model.updateSelectedIndex(2);
      expect(model.selectedIndex, 2);
    });
  });
} 