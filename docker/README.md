To build the docker image used for creating goldens, use:

```docker build --build-arg flutter_version=<flutter-version> -t docker_tests docker/```

Where **flutter-version** is obtained using `flutter --version`