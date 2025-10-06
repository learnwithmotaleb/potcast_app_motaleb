# App Lifecycle Audio Control

## Feature
Stop audio playback when the app is **terminated/closed**, but allow it to continue when the app is in the **background**.

## Implementation

### 1. Lifecycle States
Flutter provides different app lifecycle states:

- **`paused`** - App is in background (home button pressed, app switcher)
  - ✅ Audio continues playing
  - User can control via lock screen/notification

- **`resumed`** - App comes back to foreground
  - ✅ Audio continues playing
  - UI syncs with current state

- **`detached`** - App is being terminated/closed
  - 🛑 Audio stops playing
  - Resources are cleaned up

- **`inactive`** - App is transitioning (e.g., during phone call)
  - ✅ Audio continues playing

- **`hidden`** - App is hidden but not paused
  - ✅ Audio continues playing

### 2. Code Changes

#### `audio_play_screen.dart`
Added lifecycle detection in `didChangeAppLifecycleState()`:

```dart
case AppLifecycleState.detached:
  debugPrint('🔄 App detached - Stopping audio playback');
  feedController.stopAudioOnAppClose();
  break;
```

#### `podcast_play_controller.dart`
Added `stopAudioOnAppClose()` method:

```dart
void stopAudioOnAppClose() {
  try {
    debugPrint('🛑 Stopping audio playback - App is closing');
    _audioPlayer.stop();
    _videoPlayerController.value?.pause();
    isPlaying.value = false;
  } catch (e) {
    debugPrint('⚠️ Error stopping audio on app close: $e');
  }
}
```

## Behavior

### Background Playback (App Minimized)
1. User presses home button or switches apps
2. App state: `paused`
3. ✅ Audio continues playing
4. User can control via:
   - Lock screen media controls
   - Notification controls
   - Control center (iOS) / Quick settings (Android)

### App Termination (App Closed)
1. User swipes app away from app switcher
2. App state: `detached`
3. 🛑 Audio stops immediately
4. Resources are cleaned up

## Testing

### Test Background Playback
1. Start playing audio
2. Press home button
3. ✅ Audio should continue
4. Check lock screen - controls should be visible
5. Return to app - audio still playing

### Test App Termination
1. Start playing audio
2. Open app switcher
3. Swipe app away to close it
4. 🛑 Audio should stop immediately

## Platform Differences

### iOS
- `detached` is called when app is terminated
- Background audio requires proper capabilities in `Info.plist`

### Android
- `detached` is called when app is killed
- Background audio requires foreground service

## Notes

- The `just_audio` package handles background playback automatically
- We only intervene on app termination to stop playback
- This provides a good user experience:
  - Background playback for multitasking
  - Clean stop when user explicitly closes the app
