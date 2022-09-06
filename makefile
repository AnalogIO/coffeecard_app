get:
	flutter pub get
update: update_icon update_name
generate:
	flutter pub run build_runner build --delete-conflicting-outputs
format:
	flutter format .
update_icon:
	flutter pub run flutter_launcher_icons:main
update_name:
	flutter pub run flutter_app_name
analyze:
	flutter analyze
cov:
	flutter test --coverage && lcov --remove coverage/lcov.info '*/base/*' 'lib/generated/*' -o coverage/lcov.info && genhtml coverage/lcov.info -o coverage/html
