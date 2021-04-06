# ProgressNavigationController
Simple subclass of UINavigationController that displays navigation progress under NavBar

## Usage

```
    /// - Parameter progressOffset: Responsable for including VCs in progress. Available values:
    ///
    ///     1: include root in progress display
    ///
    ///     0: not include root in progress display
    ///
    ///     -1: not include the first 2 VCs (root + the next one)
    ///
    ///     and so on...
    ///
    /// - Parameter progressElements: max count of elements in progress
    /// - Parameter root: root ViewController for UINavigationController
    init(root: UIViewController, progressElements: Int = 4, progressOffset: Int = 0)
```

## Demo

![ezgif com-gif-maker](https://user-images.githubusercontent.com/22365403/113731651-9f66ad80-9701-11eb-8314-cafb7765c37d.gif)
