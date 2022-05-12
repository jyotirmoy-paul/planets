import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:planets/utils/app_logger.dart';
import 'package:planets/utils/constants.dart';

// visit counter
const _webPageCounterKey = 'total_web_page_visits';
const _dashboardPageCounterKey = 'dashboard_page_visits';
const _puzzlePageCounterKey = 'puzzle_page_visits';

// action counter
const _autoSolverUsedCounterKey = 'auto_solver_used_counter';
const _viewOnGithubClickedCounterKey = 'github_link_clicked_counter';

abstract class QuickVisitCounter {
  static void _count(String counterKey) async {
    if (kDebugMode) {
      return AppLogger.log('QuickVisitCounter :: DEBUG COUNT $counterKey');
    }

    final url = 'https://api.countapi.xyz/hit/$kProjectDomain/$counterKey';
    final response = await http.get(Uri.parse(url));
    AppLogger.log('QuickVisitCounter :: $counterKey :: ${response.body}');
  }

  static void countWebPageOpened() => _count(_webPageCounterKey);

  static void countDashboardPageOpened() => _count(_dashboardPageCounterKey);

  static void countPuzzlePageOpened(String planet) {
    _count(_puzzlePageCounterKey);
    _count(_puzzlePageCounterKey + '_' + planet);
  }

  static void countAutoSolverUsed() => _count(_autoSolverUsedCounterKey);

  static void viewOnGithubClicked() => _count(_viewOnGithubClickedCounterKey);
}
