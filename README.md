📰 News Intel Pro - Mini News Intelligence App
News Intel Pro is a high-performance, scalable Flutter application designed to deliver a premium news intelligence experience. Built with a focus on Clean Architecture and SOLID principles, the app provides real-time news updates across various categories with seamless offline capabilities.

🚀 Key Features
- Authentication & Persistence: Integrated a secure login flow using the DummyJSON API. The authentication state is persisted locally using Hive, ensuring users remain logged in across app restarts.
- Dynamic News Feed: Features a category-based listing (Business, Tech, Sports, etc.) using a scrollable TabBar for easy navigation.
- Infinite Scroll Pagination: Implemented an optimized pagination logic that fetches news in chunks as the user scrolls, minimizing initial load times and data usage.
- Global Search: Provides a robust search experience using the NewsAPI "everything" endpoint with efficient filtering for real-time results.
- Offline Favorites: Users can save articles for offline reading. These are stored in a local Hive database, ensuring data availability without an internet connection.
- Pull-to-Refresh: Integrated native refresh capabilities to allow users to manually trigger the latest news updates.

  🛠️ Technical Stack
Framework: Flutter 3.x (Null Safety)
State Management: Riverpod (for reactive, testable, and compile-safe state handling)
Local Storage: Hive (NoSQL database chosen for its extreme speed and lightweight footprint)
Networking: Dio (advanced HTTP client for better error handling and request management)
Architecture: Feature-First Clean Architecture


📂 Project Structure
The project follows a Feature-First approach to ensure the codebase remains maintainable and scalable as new features are added:

lib/src/
├── core/                # Global themes, constants, and shared utilities
├── features/            
│   ├── auth/            # Authentication logic, repositories, and UI
│   ├── news/            # Feed, Pagination, and API integration logic
│   ├── favorites/       # Local storage management for saved articles
│   └── search/          # API search implementation and result filtering
└── main.dart            # Application entry point and Hive initialization

💡 Architectural Decisions
- Riverpod for State Management: Chosen for its ability to handle complex states like pagination and global authentication status with minimal boilerplate and maximum safety.
- Hive for Persistence: Since the app requires storing article models, Hive was preferred over SQLite for its superior performance with NoSQL data structures.
- Pagination Strategy: Utilized a StateNotifier to manage the list of articles, appending new data to the existing state to prevent UI flickers during infinite scrolling.
- Error Handling: Implemented a comprehensive error handling layer using try-catch blocks and user-friendly SnackBars to manage API failures and connectivity issues gracefully.


⚙️ Setup & Installation
Clone the repository:
git clone <repository-url>

Install dependencies:
flutter pub get

Generate Hive Adapters:
dart run build_runner build

Run the application:
flutter run
