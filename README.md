# tradinity

A Flutter application that displays a list of trading instruments along with a real-time price ticker to reflect price fluctuations.

## Key Points for Project 
- Clean code architecture
- Bloc/Cubit for state management.
- Dio for networking
- GetIT as service locator for singleton objects
- DartZ for functional programming
- web_socket_channel for socket connection
- connectivity_plus for network handling
- flutter_dotenv to load configuration file 


## Project Structure
```
core/
├── di/
│   ├── domain_container.dart
│   ├── injection_container.dart
│   └── remote_container.dart
├── error/
│   └── custom_exceptions.dart
├── network/
│   ├── network_client.dart
│   ├── network_constants.dart
│   └── network_info.dart
└── utils/
├── custom_logger.dart
└── utils.dart
features/
├── data/
│   ├── data_source/
│   │   └── trading_instruments_data_source.dart
│   ├── models/
│   │   ├── request/
│   │   └── response/
│   │       ├── instrument_model.dart
│   │       └── price_model.dart
│   └── repository_impl/
│       └── trading_instruments_repo_impl.dart
├── domain/
│   └── repository/
│       └── trading_instrument_repo.dart
└── presentation/
├── cubit/
│   ├── trading_cubit.dart
│   └── trading_state.dart
└── screens/
├── widgets/
│   ├── instrument_tile.dart
│   └── instruments_list.dart
└── trading_instruments_screen.dart
main.dart
```
                

# Tradinity Application Tests

This repository contains unit tests for the Trading Application, which implements a Flutter app using the BLoC (Business Logic Component) pattern. The tests are organized by feature and include tests for the cubits, repositories, and data sources.

## Folder Structure for Tests
```
test
│
├── cubit
│   ├── trading_cubit_test.dart          # Test cases for TradingCubit
│   └── trading_cubit_test_mocks.dart    # Mocks for TradingCubit tests
│
├── data
│   └── trading_instruments_data_source_test.dart  # Test cases for TradingInstrumentDataSource
│
└── repo
└── trading_instruments_repo_test.dart   
```

## Testing Overview

### Cubit Tests

- **File:** `test/cubit/trading_cubit_test.dart`
- **Purpose:** Contains unit tests for the `TradingCubit`, which handles the fetching of trading instruments and updates via WebSocket.
- **Mocking:** Uses mocks to simulate dependencies such as the repository and WebSocket behavior.

### Data Source Tests

- **File:** `test/data/trading_instruments_data_source_test.dart`
- **Purpose:** Contains unit tests for the `TradingInstrumentDataSource`, which handles API calls to fetch trading instruments.
- **Mocking:** Mocks the network client to simulate API responses and ensure the data source behaves correctly under different scenarios.

### Repository Tests

- **File:** `test/repo/trading_instruments_repo_test.dart`
- **Purpose:** Contains unit tests for the `TradingInstrumentsRepo`, which serves as an abstraction layer for fetching instruments from the data source.
- **Mocking:** Mocks the data source to simulate different scenarios of data fetching, including success and failure cases.

## Running Tests

To run the tests, follow these steps:

1. Ensure you have Flutter installed and set up on your machine.
2. Open a terminal in the root directory of the project.
3. Run the following command to execute all tests:

```
   flutter test
```

To run tests for a specific file, run the following command:

```
flutter test test/cubit/trading_cubit_test.dart
```

If you add/update a mock, make sure to run this command:

```
flutter pub run build_runner build
```







