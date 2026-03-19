import 'package:FlutterApp/data/local/asset_loader.dart';
import 'package:FlutterApp/data/models/quote.dart';

class QuotesRepository {
  QuotesRepository({
    AssetLoader? assetLoader,
  }) : _assetLoader = assetLoader ?? const AssetLoader();

  static const _assetPath = 'assets/data/quotes.json';
  final AssetLoader _assetLoader;

  Future<List<Quote>> loadQuotes() async {
    final rawList = await _assetLoader.loadList(_assetPath);
    return rawList
        .map((item) => Quote.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
