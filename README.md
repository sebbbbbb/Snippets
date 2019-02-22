# Snippets

## Swift

### String from class
```swift
String(describing: type(of: <#Class#>))
```

### Extract get parameters from URL

```swift
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
```

### Compare two class instances

```
enum Deeplink {
    case home
    case videos(Video)
    case preferences
    
    func associatedViewController() -> AnyClass {
        switch self {
            case .home:
                return KidsHomeViewController.self
            case .videos(_):
                return KidsVideoViewController.self
            case .preferences:
                return KidsPreferenceViewController.self
        }
    }
}

// Somewhere else
if myViewController.classForCoder == deeplink.associatedViewController() {
    // Some code
}
```
