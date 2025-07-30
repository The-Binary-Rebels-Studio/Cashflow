# Development Build Tasks

This project includes automated build tasks to streamline development workflow.

## Auto-Generated Files

The project uses code generation for:
- **Isar Database**: Entity models and collections (`.g.dart` files)
- **Localization**: Multi-language support files (`app_localizations*.dart`)

## VSCode Integration

### Automatic Build on Launch
All launch configurations automatically run pre-build tasks:
1. `flutter pub get` - Updates dependencies
2. `flutter gen-l10n` - Generates localization files
3. `flutter packages pub run build_runner build --delete-conflicting-outputs` - Generates Isar database code

### Available Tasks
Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac), then type "Tasks: Run Task":

- **Build Dependencies** - Runs all build tasks in sequence
- **Generate Localizations** - Only generates localization files  
- **Build Runner** - Only runs Isar code generation
- **Clean Build Runner** - Cleans generated files
- **Watch Build Runner** - Runs build runner in watch mode
- **Get Packages** - Updates Flutter packages

### One-Click Development
Simply press F5 or click "Run and Debug" → "cashflow" to:
1. Auto-generate all required files
2. Launch the app with hot reload enabled

## Manual Commands

If you prefer running commands manually:

```bash
# Update packages
flutter pub get

# Generate localizations  
flutter gen-l10n

# Generate Isar database code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Clean generated files
flutter packages pub run build_runner clean

# Watch mode (automatically regenerates on file changes)
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

## Localization

The app supports 3 languages:
- English (en)
- Indonesian (id) 
- Malaysian (ms)

Localization files are in `lib/l10n/` and auto-generate to `lib/l10n/app_localizations*.dart`.

## Database

Uses Isar for local database storage. Entity models auto-generate collection code.