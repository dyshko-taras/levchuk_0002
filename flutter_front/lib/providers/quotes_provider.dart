import 'package:flutter/foundation.dart';

import '../data/models/quote.dart';
import '../data/repositories/quotes_repository.dart';

class QuotesProvider extends ChangeNotifier {
  QuotesProvider({
    required QuotesRepository quotesRepository,
  }) : _quotesRepository = quotesRepository;

  final QuotesRepository _quotesRepository;

  bool _loaded = false;
  List<Quote> _quotes = const [];
  int _currentIndex = 0;

  bool get loaded => _loaded;
  List<Quote> get quotes => _quotes;
  int get currentIndex => _currentIndex;

  Quote? get quoteOfTheDay {
    if (_quotes.isEmpty) {
      return null;
    }
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  Quote? get currentQuote {
    if (_quotes.isEmpty) {
      return null;
    }
    return _quotes[_currentIndex % _quotes.length];
  }

  Future<void> load() async {
    if (_loaded) {
      return;
    }

    _quotes = await _quotesRepository.loadQuotes();
    _loaded = true;
    notifyListeners();
  }

  void showNextQuote() {
    if (_quotes.isEmpty) {
      return;
    }
    _currentIndex = (_currentIndex + 1) % _quotes.length;
    notifyListeners();
  }
}
