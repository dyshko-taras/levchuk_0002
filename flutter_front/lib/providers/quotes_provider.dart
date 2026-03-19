import 'package:FlutterApp/data/models/quote.dart';
import 'package:FlutterApp/data/repositories/quotes_repository.dart';
import 'package:flutter/foundation.dart';

class QuotesProvider extends ChangeNotifier {
  QuotesProvider({
    required QuotesRepository quotesRepository,
  }) : _quotesRepository = quotesRepository;

  final QuotesRepository _quotesRepository;

  bool _loaded = false;
  List<Quote> _quotes = const [];
  int _currentIndex = 0;
  final List<String> _viewedQuoteIds = <String>[];

  bool get loaded => _loaded;
  List<Quote> get quotes => _quotes;
  int get currentIndex => _currentIndex;
  List<Quote> get viewedQuotes => _viewedQuoteIds
      .map(_quoteById)
      .whereType<Quote>()
      .toList(growable: false);

  Quote? get quoteOfTheDay {
    if (_quotes.isEmpty) {
      return null;
    }
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year))
        .inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  Quote? get currentQuote {
    if (_quotes.isEmpty) {
      return null;
    }
    return _quotes[_currentIndex % _quotes.length];
  }

  Future<void> load() async {
    _quotes = await _quotesRepository.loadQuotes();
    final initialQuote = quoteOfTheDay;
    if (initialQuote != null) {
      _currentIndex = _quotes.indexWhere(
        (quote) => quote.id == initialQuote.id,
      );
      _rememberViewedQuote(initialQuote);
    }
    _loaded = true;
    notifyListeners();
  }

  void showNextQuote() {
    if (_quotes.isEmpty) {
      return;
    }
    _currentIndex = (_currentIndex + 1) % _quotes.length;
    _rememberViewedQuote(currentQuote);
    notifyListeners();
  }

  void _rememberViewedQuote(Quote? quote) {
    if (quote == null) {
      return;
    }
    _viewedQuoteIds
      ..remove(quote.id)
      ..add(quote.id);
  }

  Quote? _quoteById(String id) {
    for (final quote in _quotes) {
      if (quote.id == id) {
        return quote;
      }
    }
    return null;
  }
}
