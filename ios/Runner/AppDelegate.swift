import UIKit
import Flutter
import GoogleMaps
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "com.podcast.media/duration"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCKcH-bWVaa5B2ol6NCShyi463MpqoR_44")

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, flutterResult: @escaping FlutterResult) in
      guard call.method == "getMediaDuration" else {
        flutterResult(FlutterMethodNotImplemented)
        return
      }

      guard let args = call.arguments as? [String: Any],
            let path = args["path"] as? String,
            let strongSelf = self else {
        flutterResult(FlutterError(code: "INVALID_ARGUMENT", message: "path required", details: nil))
        return
      }

      strongSelf.getMediaDuration(path: path) { dict in
        flutterResult(dict)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Media Duration Logic
  private func getMediaDuration(path: String, completion: @escaping (Any) -> Void) {
    var url: URL?
    if path.hasPrefix("file://") {
      url = URL(string: path)
    } else if path.hasPrefix("/") {
      url = URL(fileURLWithPath: path)
    } else {
      url = URL(string: path) // http(s) or others
    }

    guard let mediaURL = url else {
      completion(FlutterError(code: "INVALID_URL", message: "Invalid path", details: nil))
      return
    }

    let asset = AVURLAsset(url: mediaURL)
    let key = "duration"
    asset.loadValuesAsynchronously(forKeys: [key]) {
      var error: NSError?
      let status = asset.statusOfValue(forKey: key, error: &error)
      switch status {
      case .loaded:
        let seconds = CMTimeGetSeconds(asset.duration)
        if seconds.isNaN {
          completion(["success": false, "error": "duration is NaN"])
        } else {
          let millis = Int64(seconds * 1000.0)
          completion([
            "success": true,
            "durationMillis": millis,
            "durationSeconds": seconds,
            "durationString": self.formatDuration(durationMs: millis)
          ])
        }
      case .failed, .cancelled:
        completion(["success": false, "error": error?.localizedDescription ?? "Failed to load duration"])
      default:
        completion(["success": false, "error": "Could not load duration"])
      }
    }
  }

  private func formatDuration(durationMs: Int64) -> String {
    var seconds = Int(durationMs / 1000)
    let hours = seconds / 3600
    seconds = seconds % 3600
    let minutes = seconds / 60
    let secs = seconds % 60
    if hours > 0 {
      return String(format: "%d:%02d:%02d", hours, minutes, secs)
    } else {
      return String(format: "%02d:%02d", minutes, secs)
    }
  }
}
