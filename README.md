# WeatherDashboard

A SwiftUI weather dashboard application for iOS and macOS, built with the MVVM architecture pattern.

## Overview

WeatherDashboard is a native Apple platform app built with SwiftUI. It provides a clean, intuitive interface for viewing current weather, a multi-day forecast, an interactive map with points of interest, and a history of visited locations. The project follows the **MVVM (Model-View-ViewModel)** pattern and uses an **Atomic Design** component hierarchy for its views.

## Features

- 🌤 Current weather conditions (temperature, description, feels-like, humidity, wind speed, UV index)
- 📅 Multi-day weather forecast
- 🗺 Interactive map with nearby points of interest (POIs)
- 📍 Search for any location worldwide
- 🕐 Visited places history with persistent storage (SwiftData)
- 🔄 Automatic load of the most recently visited location on launch

## Architecture — MVVM

The app is structured around the **MVVM** (Model-View-ViewModel) pattern:

| Layer | Responsibility |
|-------|---------------|
| **Model** | Data structures (`WeatherResponse`, `Place`) and business/domain logic |
| **ViewModel** | `MainAppViewModel` — drives all app state, handles networking, location, and persistence |
| **View** | SwiftUI views organised with Atomic Design (Atoms → Molecules → Organisms) |

### Atomic Design Component Hierarchy

```
View/
├── Components/
│   ├── Atoms/          # Smallest reusable UI elements (labels, icons, …)
│   │   ├── Forecast/
│   │   └── Weather/
│   ├── Molecules/      # Combinations of atoms (cards, rows, …)
│   │   ├── Map/
│   │   ├── Places/
│   │   └── Weather/
│   └── Organisms/      # Full sections composed of molecules
│       ├── Forecast/
│       ├── Map/
│       └── Places/
├── CurrentWeatherView.swift
├── ForecastView.swift
├── MapView.swift
├── NavBarView.swift
└── VisitedPlacesView.swift
```

## Technologies & Frameworks

| Technology | Usage |
|------------|-------|
| **SwiftUI** | Declarative UI framework |
| **SwiftData** | Persistent local storage of visited places |
| **MapKit** | Interactive map and geocoding |
| **Combine** | Reactive data binding |
| **OpenWeatherMap API** | Live weather data (One Call API 3.0) |

## Requirements

- Xcode 15 or later
- iOS 17+ / macOS 14+
- Swift 5.9+
- An [OpenWeatherMap](https://openweathermap.org/) API key (One Call API 3.0)

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/Dulneth-Bernard/WeatherDashboard.git
   ```
2. Open `WeatherApp.xcodeproj` in Xcode.
3. Add your OpenWeatherMap API key in `WeatherApp/Configuration/APIConfig.swift`:
   ```swift
   static let weatherAPIKey: String = "YOUR_API_KEY_HERE"
   ```
4. Select your target device or simulator.
5. Build and run the project (`⌘R`).

## Project Structure

```
WeatherDashboard/
├── WeatherApp/
│   ├── WeatherAppApp.swift          # App entry point
│   ├── Configuration/
│   │   └── APIConfig.swift          # Base URL and API key
│   ├── Model/
│   │   ├── Place.swift              # SwiftData model for visited places
│   │   └── WeatherResponse.swift    # Decodable weather API response
│   ├── ViewModel/
│   │   ├── MainAppViewModel.swift   # Central ObservableObject / app state
│   │   └── LocationManager.swift    # Geocoding and POI lookup
│   ├── Core/
│   │   └── Networking/
│   │       ├── NetworkService.swift      # Networking protocol
│   │       ├── DefaultNetwork.swift      # URLSession implementation
│   │       └── WeatherService.swift      # Weather API calls
│   ├── Domain/
│   │   └── Errors/
│   │       ├── APIError.swift            # Low-level network errors
│   │       └── WeatherMapError.swift     # App-level error type
│   ├── View/
│   │   ├── Components/              # Atomic Design components
│   │   │   ├── Atoms/
│   │   │   ├── Molecules/
│   │   │   └── Organisms/
│   │   ├── CurrentWeatherView.swift
│   │   ├── ForecastView.swift
│   │   ├── MapView.swift
│   │   ├── NavBarView.swift
│   │   └── VisitedPlacesView.swift
│   ├── Utility/
│   │   ├── AppStatus.swift
│   │   ├── DateFormatter.swift
│   │   ├── WeatherAdviceCategory.swift
│   │   └── PreviewHelper.swift
│   └── Assets.xcassets              # Image and color assets
└── WeatherApp.xcodeproj             # Xcode project file
```

## Author

Dulneth Bernard

## License

This project is available for personal and educational use.
