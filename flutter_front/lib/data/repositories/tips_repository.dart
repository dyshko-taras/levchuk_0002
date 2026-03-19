import 'package:FlutterApp/data/local/asset_loader.dart';
import 'package:FlutterApp/data/models/wellness_topic.dart';

class TipsRepository {
  TipsRepository({
    AssetLoader? assetLoader,
  }) : _assetLoader = assetLoader ?? const AssetLoader();

  static const _assetPath = 'assets/data/tips.json';
  final AssetLoader _assetLoader;

  Future<List<WellnessTopic>> loadTopics() async {
    final rawList = await _assetLoader.loadList(_assetPath);
    return rawList
        .map((item) => WellnessTopic.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
