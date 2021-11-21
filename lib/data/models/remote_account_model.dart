import 'package:fordev/domain/helpers/helpers.dart';

import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;
  final String name;

  RemoteAccountModel(this.accessToken, this.name);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) throw DomainError.unexpected;
    return RemoteAccountModel(json['accessToken'], json['name']);
  }

  AccountEntity toEntity() => AccountEntity(accessToken, name);
}
