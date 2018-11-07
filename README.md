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
