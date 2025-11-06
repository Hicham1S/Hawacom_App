# Project Architecture

## Overview

This project follows a **feature-based modular architecture** designed for scalability and maintainability. Each feature is self-contained with its own models, services, screens, and widgets.

## Directory Structure

```
lib/
├── core/                          # Shared utilities and core functionality
│   ├── constants/                 # App-wide constants
│   │   └── colors.dart           # Color palette
│   ├── localization/             # Multi-language support (l10n)
│   │   ├── app_ar.arb            # Arabic translations
│   │   ├── app_en.arb            # English translations
│   │   ├── app_localizations.dart
│   │   ├── app_localizations_ar.dart
│   │   └── app_localizations_en.dart
│   ├── theme/                    # App themes (future)
│   └── utils/                    # Utility functions
│       └── video_validator.dart  # Video validation logic
│
├── features/                      # Feature modules
│   ├── home/                     # Home feature
│   │   ├── data/                 # Mock/API data for home
│   │   │   └── project_details.dart
│   │   ├── models/               # Home domain models
│   │   │   ├── announcement.dart
│   │   │   ├── category.dart
│   │   │   └── project.dart
│   │   ├── screens/              # Home screens
│   │   │   └── home_screen.dart
│   │   ├── services/             # Home business logic (future)
│   │   └── widgets/              # Home UI components
│   │       ├── ai_banner.dart
│   │       ├── bottom_navigation.dart
│   │       ├── categories_section.dart
│   │       ├── grid_menu_button.dart
│   │       ├── grid_menu_drawer.dart
│   │       ├── projects_gallery.dart
│   │       ├── quick_actions.dart
│   │       ├── stories_section.dart
│   │       └── top_bar.dart
│   │
│   ├── profile/                  # Profile feature
│   │   ├── models/               # Profile domain models
│   │   │   └── user_profile.dart
│   │   ├── screens/              # Profile screens
│   │   │   └── profile_screen.dart
│   │   ├── services/             # Profile business logic
│   │   │   └── profile_service.dart
│   │   └── widgets/              # Profile UI components
│   │       ├── profile_header.dart
│   │       ├── profile_info_tile.dart
│   │       └── profile_stats.dart
│   │
│   └── stories/                  # Stories feature
│       ├── data/                 # Mock/API data for stories
│       │   └── mock_data.dart
│       ├── models/               # Stories domain models
│       │   ├── story.dart
│       │   └── story_segment.dart
│       ├── screens/              # Stories screens
│       │   ├── add_story_screen.dart
│       │   └── story_view_screen.dart
│       ├── services/             # Stories business logic
│       │   ├── story_service.dart
│       │   └── video_service.dart
│       └── widgets/              # Stories UI components
│           └── story_video_player.dart
│
├── shared/                        # Shared across features
│   ├── data/                     # Shared data/models
│   │   └── dummy_users.dart
│   └── widgets/                  # Shared UI components (future)
│
└── main.dart                      # App entry point
```

## Architecture Principles

### 1. Feature-Based Modules
Each feature (home, profile, stories) is isolated in its own directory with:
- **models/**: Data structures specific to the feature
- **screens/**: Full-page UI screens
- **widgets/**: Reusable UI components for the feature
- **services/**: Business logic and data operations
- **data/**: Mock data or API interfaces

### 2. Core Module
Contains shared functionality used across all features:
- Constants (colors, sizes, durations)
- Localization (multi-language support)
- Theme configuration
- Utility functions

### 3. Shared Module
Contains resources shared between multiple features but not core to the app:
- Common data models
- Shared widgets
- Common utilities

### 4. Separation of Concerns
- **Models**: Pure data classes with no business logic
- **Services**: Business logic, data fetching, state management
- **Screens**: Page-level components that compose widgets
- **Widgets**: Reusable UI components with minimal logic

### 5. Import Strategy
- Use **relative imports** for files within the same feature
- Use **relative imports** to navigate between features
- Keep imports organized: package imports → feature imports → widget imports

### 6. Scalability
Adding a new feature is simple:
```bash
mkdir -p lib/features/new_feature/{models,screens,services,widgets,data}
```

## Dependencies Between Features

### Current Dependencies
```
home → stories (displays stories section)
home → profile (navigation to profile)
stories → home (models for categories/projects)
```

### Best Practices
- Minimize cross-feature dependencies
- Use shared/ for truly shared resources
- Consider creating a repository layer for data abstraction when connecting to backend

## Future Enhancements

### 1. Repository Pattern
When connecting to a real backend, add a `repositories/` folder in each feature:
```
features/
  └── stories/
      ├── data/
      │   ├── repositories/
      │   │   └── story_repository.dart
      │   └── sources/
      │       ├── story_local_source.dart
      │       └── story_remote_source.dart
```

### 2. State Management
Consider adding state management (Bloc, Riverpod, Provider) in each feature:
```
features/
  └── stories/
      ├── bloc/
      │   ├── story_bloc.dart
      │   ├── story_event.dart
      │   └── story_state.dart
```

### 3. Theme System
Expand core/theme/ with:
- `app_theme.dart`: Light/dark themes
- `text_styles.dart`: Typography system
- `app_sizes.dart`: Spacing, padding constants

### 4. Error Handling
Add to core/:
- `errors/exception.dart`: Custom exceptions
- `errors/failure.dart`: Failure classes
- `utils/error_handler.dart`: Global error handling

## Code Quality Guidelines

### File Organization
- Keep files under 300 lines when possible
- Extract large widgets into separate files
- One model per file
- One screen per file

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Functions/Variables**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants

### Documentation
- Add doc comments to public classes and methods
- Document complex business logic
- Keep README files in feature directories

## Testing Structure (Future)

```
test/
├── features/
│   ├── home/
│   │   ├── models/
│   │   ├── services/
│   │   └── widgets/
│   ├── profile/
│   └── stories/
├── core/
└── shared/
```

## Migration Guide

### From Old to New Structure
The project was recently migrated from a flat structure to feature-based modules.

**Old Structure:**
```
lib/
├── constants/
├── models/
├── screens/
├── services/
├── widgets/
```

**New Structure:** Feature-based (current)

All imports were updated automatically. If you have local branches, you may need to rebase.

## Performance Considerations

1. **Lazy Loading**: Features can be lazy-loaded using deferred imports
2. **Code Splitting**: Feature-based structure enables better code splitting
3. **Build Times**: Modular architecture improves incremental builds

## Team Collaboration

### Working on a Feature
1. All changes for a feature stay within its directory
2. Minimize changes to shared/ and core/
3. Document any new cross-feature dependencies

### Adding New Features
1. Create feature directory structure
2. Add models first
3. Implement services/business logic
4. Build UI (screens → widgets)
5. Update ARCHITECTURE.md if introducing new patterns

## Conclusion

This architecture balances simplicity and scalability. It's designed to grow with your application from MVP to production-scale app with multiple team members.

**Key Benefits:**
- Clear separation of concerns
- Easy to locate code
- Simple to add new features
- Testable and maintainable
- Ready for team collaboration
