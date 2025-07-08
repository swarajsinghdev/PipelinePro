# PipelinePro

A modern iOS app built with SwiftUI that provides map, location, and search functionality.

## Features

- **Interactive Map**: View and interact with maps using MapKit
- **Location Services**: Get current location and address information
- **Search Functionality**: Search for nearby places and drop pins
- **Tab-based Navigation**: Clean interface with three main tabs (Map, Address, Search)

## Architecture

The app follows MVVM (Model-View-ViewModel) architecture with clean separation of concerns:

### Structure
```
PipelinePro/
├── App/
│   └── PipelineProApp.swift
├── Features/
│   ├── Map/
│   │   ├── View/
│   │   │   ├── MapTabView.swift
│   │   │   └── MapView.swift
│   │   └── ViewModel/
│   │       └── MapViewModel.swift
│   ├── Address/
│   │   └── View/
│   │       └── AddressView.swift
│   └── Search/
│       └── View/
│           └── SearchView.swift
├── Models/
│   ├── Coordinate.swift
│   ├── CoordinateCodable.swift
│   └── Place.swift
├── Services/
│   ├── LocationManager.swift
│   └── LocationService.swift
└── Utilities/
    └── Constants.swift
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/swarajsinghdev/PipelinePro.git
```

2. Open the project in Xcode:
```bash
open PipelinePro.xcodeproj
```

3. Build and run the project on your device or simulator.

## Usage

### Map Tab
- View your current location on the map
- Interact with the map using standard gestures
- The map automatically centers on your location when available

### Address Tab
- View your current coordinates (latitude/longitude)
- See your formatted address
- Real-time updates when location changes

### Search Tab
- Search for nearby places
- View search results on the map
- Drop pins at specific locations

## Permissions

The app requires the following permissions:
- **Location Services**: To get your current location and provide address information

## Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **MapKit**: Apple's mapping framework
- **CoreLocation**: Location services
- **Combine**: Reactive programming for data binding

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Swarajmeet Singh**
- Email: swarajmeet@crebos.online
- GitHub: [@swarajsinghdev](https://github.com/swarajsinghdev)

## Acknowledgments

- Apple for providing excellent documentation and frameworks
- The SwiftUI community for inspiration and best practices 