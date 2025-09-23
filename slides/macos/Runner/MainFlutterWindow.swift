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
    
    let benchmarkChannel = FlutterMethodChannel(name: "com.example/benchmark", binaryMessenger: flutterViewController.engine.binaryMessenger)
    benchmarkChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "add" {
            if let args = call.arguments as? [String: Any],
               let a = args["a"] as? Int,
               let b = args["b"] as? Int {
                let sum = a + b
                result(sum)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected arguments 'a' and 'b'", details: nil))
            }
        } else if call.method == "blockMainThread" {
            Thread.sleep(forTimeInterval: 10)
            result("Main thread blocked for 10 seconds")
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
