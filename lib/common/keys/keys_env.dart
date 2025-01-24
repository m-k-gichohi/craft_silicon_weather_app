import 'package:envied/envied.dart';

part 'keys_env.g.dart';

@Envied(path: '.env')
abstract class EnvKeys {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _EnvKeys.apiKey;



}
