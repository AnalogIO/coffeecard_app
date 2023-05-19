get:
	flutter pub get
generate:
	dart run build_runner build --delete-conflicting-outputs
format:
	dart format . && dart analyze
icon:
	dart run flutter_launcher_icons:main
splash:
	dart run flutter_native_splash:create
analyze:
	flutter analyze && \
	dart run dart_code_metrics:metrics analyze lib
update_icon:
	dart run flutter_launcher_icons:main
update_name:
	dart run flutter_app_name
cov:
	flutter test --coverage && lcov --remove coverage/lcov.info 'lib/base/*' 'lib/widgets/*' 'lib/features/*/presentation/widgets/*' 'lib/service_locator.dart' 'lib/generated/*' -o coverage/lcov.info && genhtml coverage/lcov.info -o coverage/html
clean:
	flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
upgrade:
	flutter pub upgrade --major-versions