# Dependency Injection
Shortcut Foundation provides a convenient way to access the same object anywhere in your project via dependency injection.

## Usage
To inject an object, e.g. an instance of CameraManager, use the @Inject property wrapper
```
@Inject var cameraManager: CameraManager
```
and then map it to its Type in the configure(_ injector:) method of a Config.
```
struct AppConfig: Config {
    func configure(_ injector: Injector) {
        injector.map(CameraManager.self) {
            CameraManager()
        }
    }
}
```
An instance of Config is then used to initialize a Context instance on app launch, which is held for the lifecycle of the app.
```
@main
struct MyApp: App {
    let context = Context(AppConfig())

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
```

That's it!

### Important!
When mapping objects in configure(_ injector:), the order of the mapping is important.

If the class ViewModel will inject the class ApiService, then ApiService must be mapped before ViewModel.
```
struct AppConfig: Config {
    func configure(_ injector: Injector) {
        injector.map(ApiService.self) {
            ApiService()
        }
        injector.map(ViewModel.self) {
            ViewModel()
        }
    }
}
```
Not mapping in this order can cause the app to crash.

### Mapping Protocols
In some situations it can be useful to map the type of a protocol instead of a class. By then having several classes conform to the protocol, you can add logic to load the correct instance where appropriate.

Let's say you have an ApiService class that handles all your API calls when running your app, and you have a MockApiService class that you want to use for testing. By having both ApiService and MockApiService conform to e.g. IApiService, you can map
```
injector.map(IApiService.self) {
    isRunningTests ? MockApiService() : ApiService() as IApiService
}
```
#### Example Logic
In the above example, isRunningTests is defined as
```
var isRunningTests: Bool { ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil }
```
Another situation where this approach could be useful is for SwiftUI previews. Using the same approach as above, we can define e.g. isRunningInPreview as
```
var isRunningInPreview: Bool { ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" }
```

## Variations
Along with the standard @Inject, there are four additional variations of the property wrapper, which can be used in its place when needed.
- `@InjectObject` is used to inject an @ObservableObject,
- `@OptionalInject` is used to inject an optional object,
- `@LazyInject` is used to inject lazily, i.e. the object is only initialized once needed, and
- `@WeakLazyInject`, which is similar to @LazyInject, with the difference being that since it's a weak reference, it will be automatically disposed of when no longer needed.
