<p align="center">
  <img src="readme_logo.png" alt="Coffee Card App Logo" width="200">
</p>

<p align="center">
  <a href="https://github.com/AnalogIO/coffeecard_app/actions">
    <img alt="Build and test" src="https://github.com/AnalogIO/coffeecard_app/actions/workflows/build.yml/badge.svg">
  </a>
  <a href="https://codecov.io/gh/AnalogIO/coffeecard_app">
    <img alt="codecov" src="https://codecov.io/gh/AnalogIO/coffeecard_app/branch/develop/graph/badge.svg">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT">
  </a>
</p>

---

<p align="center">
  Brew the best coffee experience at <a href="https://cafeanalog.dk">Cafe Analog</a> with our new cross-platform app, designed and coded in Flutter.
  Buy and use digital clip cards at our cafe located at the <a href="https://itu.dk">IT University of Copenhagen</a>.
</p>

<p align="center">
  <strong>Contact AnalogIO at: </strong><em>support [at] analogio.dk</em>
</p>

---

## 🛠️ SDKs

The application is brewed using these SDK versions:

| SDK     | Version        |
| ------- | -------------- |
| Dart    | >=3.0.0 <4.0.0 |
| Flutter | 3.13.1         |

## 📚 Documentation

For more details, please refer to our documentation:

- [Contribution Guidelines](CONTRIBUTING.md)
- [Testing Guidelines](test/README.md)
- [Generated CoffeeCard API](lib/data/api/README.md)

## 🔧 Getting Started

This project relies on autogenerated files for environment configuration and testing. Follow the steps below to get started:

1. Ensure a `.env.develop` file is present in the root directory. This file should contain the URI of the backend API in the format `coffeeCardUrl="https://the-url"`.

2. Run the command `make generate` to generate necessary files.

## 📬 Contact

For any queries, feel free to reach us at: <em>support [at] analogio.dk</em>
