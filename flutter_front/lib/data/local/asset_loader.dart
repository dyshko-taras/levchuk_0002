import 'dart:convert';

import 'package:flutter/services.dart';

class AssetLoader {
  const AssetLoader();

  Future<List<dynamic>> loadList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as List<dynamic>;
  }
}
