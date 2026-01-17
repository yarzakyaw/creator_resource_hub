# Creator Resource Hub

This Flutter monorepo contains the following components:

## Apps

### Mobile App
- Located in `apps/mobile_app`
- A Flutter app targeting Android and iOS platforms.
- Placeholder `main.dart` file included.

### Web Admin App
- Located in `apps/web_admin`
- A Flutter web app for administrative purposes.
- Placeholder `main.dart` file included.

## Shared Packages

### Core
- Located in `packages/core`
- Contains shared logic and utilities.

### Models
- Located in `packages/models`
- Contains shared data models.

### Localization
- Located in `packages/localization`
- Handles internationalization (i18n) with support for English and Burmese.

### Firebase Services
- Located in `packages/firebase_services`
- Contains Firebase-related logic and services.

## Project Structure

This project follows clean architecture principles:
- **Presentation**: UI and widgets.
- **Application**: State management and Riverpod integration.
- **Domain**: Business logic and use cases.
- **Data**: Repositories and data sources.

## Notes
- Firebase integration is prepared but not configured.
- Riverpod is included with support for Riverpod Generator.
- Placeholder files are provided for all components.

## Getting Started
1. Navigate to the desired app or package directory.
2. Run `flutter pub get` to fetch dependencies.
3. Start developing your app or package.

## Future Work
- Add Firebase configuration files.
- Implement authentication logic.
- Build UI screens for both apps.# creator_resource_hub
