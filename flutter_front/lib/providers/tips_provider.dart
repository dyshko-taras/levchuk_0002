import 'package:flutter/foundation.dart';

import '../data/models/wellness_tip.dart';
import '../data/models/wellness_topic.dart';
import '../data/repositories/tips_repository.dart';

class TipsProvider extends ChangeNotifier {
  TipsProvider({
    required TipsRepository tipsRepository,
  }) : _tipsRepository = tipsRepository;

  final TipsRepository _tipsRepository;

  bool _loaded = false;
  List<WellnessTopic> _topics = const [];

  bool get loaded => _loaded;
  List<WellnessTopic> get topics => _topics;

  Future<void> load() async {
    if (_loaded) {
      return;
    }

    _topics = await _tipsRepository.loadTopics();
    _loaded = true;
    notifyListeners();
  }

  WellnessTopic? topicById(String topicId) {
    for (final topic in _topics) {
      if (topic.id == topicId) {
        return topic;
      }
    }
    return null;
  }

  WellnessTip? tipOfTheDay() {
    if (_topics.isEmpty) {
      return null;
    }
    final topic = _topics[DateTime.now().day % _topics.length];
    if (topic.tips.isEmpty) {
      return null;
    }
    return topic.tips[DateTime.now().day % topic.tips.length];
  }
}
