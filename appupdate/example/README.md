# App Update Example

This example demonstrates how to implement Google Play In-App Updates using Flutter and JNI bindings.

## Features

- **Check for Updates**: Query Google Play for available app updates
- **Flexible Updates**: Download updates in the background while the app continues to run
- **Immediate Updates**: Force users to update before continuing to use the app
- **Real-time Progress**: Monitor download progress and installation status
- **Error Handling**: Handle update failures and cancellations

## How it works

The app uses Google Play Core's App Update API through JNI bindings to:

1. Check if an update is available
2. Determine which update types are allowed (flexible or immediate)
3. Start the update flow with progress monitoring
4. Complete the installation process

The example provides a simple UI with buttons to trigger different update flows and displays detailed logs of the update process.
