# Code generation

`CoffeeCardApiClient` is implemented using `Dio`, `JsonSerializable` and `Retrofit` which use code generation with the flutter build runner.

## Conventions

**@RestApi**
The `CoffeeCardApiClient` is made as an abstract class where the implementation is code generated. 
RestClient classes annotated with `@RestApi` using the `import 'package:retrofit/retrofit.dart'` package and declaring the partial file `part 'coffee_card_api_client.g.dart';` will be auto-generated.

**Model classes**
Model classes (de)serialized by the the RestClient are generated using the `JsonSerializableGeneator`. 
Classes (See e.g. `AppConfig.dart`) must have the `@JsonSerializable()` using the `import 'package:json_annotation/json_annotation.dart'` package and declaring the partial file `part 'AppConfig.g.dart'`.

Furthermore to de -and serialize the model class, the model class must have the two methods
```dart
factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);
Map<String, dynamic> toJson() => _$AppConfigToJson(this);
```

## Generating code

Run the build script in `scripts/.generate-code.sh` or run the command in the terminal
```bash
flutter pub run build_runner build
```

Read more in the [retrofit documentation](https://pub.dev/documentation/retrofit/latest/) .