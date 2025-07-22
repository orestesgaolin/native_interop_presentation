# android_intent

Plugin to send Android Intents from Flutter.

## Usage


## Contributing

### Regenerating Bindings

Before regenerating bindings you need to build the example app in release at lest once.

```
cd example
flutter build apk --release
```

Then you can regenerate bindings with:

```
flutter pub run jnigen --config jnigen.yaml
```

### Code Style

- use conventional commits
- see analysis_options.yaml for code style rules