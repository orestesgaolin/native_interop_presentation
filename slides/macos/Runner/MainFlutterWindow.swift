import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    let myChannel = FlutterBasicMessageChannel(name: "com.example/my_channel", binaryMessenger: flutterViewController.engine.binaryMessenger, codec: FlutterStringCodec())
    myChannel.setMessageHandler { (message: Any?, reply: @escaping FlutterReply) in
        if let messageString = message as? String {
            print("Received message from Flutter: \(messageString)")
            let responseString = "Hello from macOS!"
            reply(responseString)
        } else {
            reply(FlutterError(code: "INVALID_ARGUMENT", message: "Expected a string", details: nil))
        }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
