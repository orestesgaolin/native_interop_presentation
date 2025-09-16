graph TD
    subgraph "Dart Application (Client)"
        A["1. Dart UI Code (e.g., Widget)"] --> B{"2. `platform.invokeMethod()`"};
        B --> C["3. Dart `MethodChannel`"];
        C --> D["4. Dart `MethodCodec` (e.g., `StandardMethodCodec`)"];
        D -- "Encodes MethodCall (name, args) into `ByteData`" --> E["5. Dart `BinaryMessenger` (abstract)"];
        E -- "Calls `send(channel, ByteData)`" --> F["6. Dart Runtime"];
    end

    subgraph "Flutter Engine (C++ Core)"
        F -- "Binary `ByteData` & Channel Name" --> G["7. C++ Flutter Engine Messaging System"];
        G -- "Interop via JNI (Java Native Interface)" --> H["8. Android Embedder / JNI Layer"];
    end

    subgraph "Native Android Application (Host)"
        H --> I["9. Java `DartExecutor` (implements `BinaryMessenger`)"];
        I -- "Binary `ByteBuffer` & Channel Name" --> J["10. Java `BinaryMessenger` (from `DartExecutor`)"];
        J -- "Dispatches to registered handler" --> K["11. Java `MethodChannel` (same name)"];
        K --> L["12. Java `MethodCodec` (e.g., `StandardMethodCodec`)"];
        L -- "Decodes `ByteBuffer` to `MethodCall` object" --> M["13. Java `MethodCallHandler`"];
        M -- "14. Executes Native Android API (e.g., `BatteryManager`)" --> N["15. Native Android System / APIs"];
        N -- "Native result" --> M;
        M -- "16. Sends reply via `MethodChannel.Result.success/error`" --> K;
        K --> L2["17. Java `MethodCodec`"];
        L2 -- "Encodes result/error into `ByteBuffer`" --> J2["18. Java `BinaryMessenger`"];
        J2 -- "Calls `send(channel, ByteBuffer)`" --> I2["19. Java `DartExecutor`"];
        I2 -- "Interop via JNI" --> H2["20. Android Embedder / JNI Layer"];
    end

    subgraph "Flutter Engine (C++ Core)"
        H2 --> G2["21. C++ Flutter Engine Messaging System"];
        G2 -- "Binary reply `ByteData` & Channel Name" --> F2["22. Dart Runtime"];
    end

    subgraph "Dart Application (Client)"
        F2 --> E2["23. Dart `BinaryMessenger`"];
        E2 --> D2["24. Dart `MethodCodec`"];
        D2 -- "Decodes `ByteData` to Dart value" --> C2["25. Dart `MethodChannel`"];
        C2 -- "`Future` completes with result" --> A2["26. Dart UI Code"];
    end

    style A fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style B fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style C fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style D fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style E fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style F fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;

    style G fill:#fffde7,stroke:#ffc107,stroke-width:2px;
    style H fill:#fffde7,stroke:#ffc107,stroke-width:2px;

    style I fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    style J fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    style K fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    style L fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    style M fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    style N fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;

    style L2 fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    style J2 fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;
    style I2 fill:#f3e5f5,stroke:#9c27b0,stroke-width:2px;

    style H2 fill:#fffde7,stroke:#ffc107,stroke-width:2px;
    style G2 fill:#fffde7,stroke:#ffc107,stroke-width:2px;

    style F2 fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style E2 fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style D2 fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style C2 fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
    style A2 fill:#e0f7fa,stroke:#00bcd4,stroke-width:2px;
