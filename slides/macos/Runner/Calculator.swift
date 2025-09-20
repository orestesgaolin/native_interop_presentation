import Foundation
import UserNotifications

@_cdecl("add")
func add(_ a: Int, _ b: Int) -> Int {
  return a + b
}

@_cdecl("showNotification")
public func showNotification() {
  let center = UNUserNotificationCenter.current()
  center.requestAuthorization(options: [.alert, .sound]) { granted, error in
    if let error = error {
      print("Error requesting notification authorization: \(error)")
    }
  }
  let content = UNMutableNotificationContent()
  content.title = "Message to Flutter"
  content.body = "Hello from the macOS side!"
  // time sensitive
  content.interruptionLevel = .timeSensitive
  // banner
  content.categoryIdentifier = "banner"
  
  let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
  UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
