import 'dart:convert';

import 'package:coffeecard/features/session/data/models/session_details_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

class SessionLocalDataSource {
  static const _sessionKey = 'session';

  final FlutterSecureStorage storage;
  final Logger logger;

  const SessionLocalDataSource({
    required this.storage,
    required this.logger,
  });

  Future<void> saveSessionDetails(SessionDetailsModel sessionDetails) async {
    await storage.write(
      key: _sessionKey,
      value: json.encode(sessionDetails),
    );

    logger.d('$sessionDetails added to storage');
  }

  Future<Option<SessionDetailsModel>> getSessionDetails() async {
    final jsonString = await storage.read(key: _sessionKey);

    if (jsonString == null) {
      return none();
    }

    final sessionDetails = SessionDetailsModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );

    return some(sessionDetails);
  }
}
