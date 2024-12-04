# Parking Management Application

## Overview
Our parking management application is designed for paid parking in Lisbon. It provides users with a map, a list of parking locations with filters, and a section for reporting incidents. The application follows the MVVM (Model-View-ViewModel) architecture pattern, which separates business logic from the user interface, improving code maintainability and scalability.

## Features
### main.dart
The `main.dart` file is the entry point of the application. Here, we set up the necessary providers using `MultiProvider` and define the root widget of the application (`MyApp`). This allows us to efficiently inject dependencies throughout the application.

### State Management
We use the `provider` package for global state management in the application. This enables us to share information between different widgets efficiently and keeps business logic separate from presentation logic. Providers are configured in `main.dart` and passed down the widget tree using `MultiProvider`.

### Database Interaction
We implement a Repository pattern to abstract the data access layer. Repositories like `IncidentRepository.dart` handle all CRUD operations (in this case, only read and write) and communicate with a `DatabaseHelper` class, which manages the database connection.
- **DatabaseHelper**: Manages the database connection and provides methods for accessing and modifying data.
- **IncidentRepository and ParkingRepository**: Contain the logic for accessing and manipulating data related to incidents and parking, respectively.

### Implemented Best Practices
- **Decoupling**: We have decoupled UI logic and business logic through the use of ViewModels and Repositories. This facilitates unit testing and code reuse. This implementation is clearly visible in the classes within the `pages` folder, where page classes only call classes with actual functionality, enhancing code readability, maintainability, and reusability. Navigation between different pages is handled in the `main_page.dart` class.
- **Dependency Injection**: We utilize the `provider` package for dependency injection, allowing easy replacement of dependencies in unit tests and improving application modularity.
- **Error Handling**: All database and network calls are wrapped in try-catch blocks to handle errors appropriately and provide feedback to the user.
- **Performance Optimization**: We implement lazy loading techniques in lists and use the `FutureBuilder` widget to load data asynchronously without blocking the user interface.

## Conclusion
These best practices ensure that our application is robust, efficient, and easy to maintain. The separation of responsibilities, efficient state management, and performance optimization are key aspects of our architecture, facilitating the development and evolution of the application over time. The application successfully allows users to find paid parking options in Lisbon and report any incidents effectively.

## Installation
The application is developed in Android Studio. To run the project, ensure you have software that can handle the following folders: `.dart_tools`, `.idea`, `ios`, `lib`, `android`, and any other necessary configurations.

