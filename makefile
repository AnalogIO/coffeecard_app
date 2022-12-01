get:
	flutter pub get
generate:
	flutter pub run build_runner build --delete-conflicting-outputs
format:
	flutter format .
icon:
	flutter pub run flutter_launcher_icons:main
splash:
	flutter pub run flutter_native_splash:create
analyze:
	flutter analyze
cov:
	flutter test --coverage && lcov --remove coverage/lcov.info '*/base/*' '*/service_locator.dart' 'lib/generated/*' -o coverage/lcov.info && genhtml coverage/lcov.info -o coverage/html
clean:
	flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
