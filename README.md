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

### Check if string start with specials char
```swift
guard !isEmpty, let firstChar = first else { return false }
return String(firstChar).range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) != nil
```
### Compare two class instances

```swift
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

### Prettry print JSON Data
```swift
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
    let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
    let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
    return prettyPrintedString
    }
}
```
