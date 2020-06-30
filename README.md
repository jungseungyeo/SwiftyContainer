# SwiftyContainer

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg) ![CocoaPods](http://img.shields.io/cocoapods/v/SwiftyContainer.svg) ![License](https://img.shields.io/badge/Licence-MIT-green.svg)

## Install

```ruby
  pod 'SwiftyContainer'
```

## How to use
----

```swift
import SwiftyContainer

// crate Interactor
lazy var swiftyContainerInteractor: SwiftyContainerInteractorable = {

    struct Component: SwiftyComponentable {
        var leftMarginOffset: CGFloat { 10 }
        var rightMarginOffset: CGFloat { -10 }
        var bottomMarginOFfset: CGFloat { 10 }
    }

    let component = Component()

    let composition = SwiftyCompositionContainer.resolve(parentsView: view,
                                                         animationView: containerView,
                                                         component: component)

    let container = SwiftyContainerBuilder(dependency: composition).create()

    return container
}()

```

## Show Container

```swift
func show() {

    swiftyContainerInteractor.showDidAppear = {
      // didShowAppear
    }

    swiftyContainerInteractor.show()
}
```

## Hide Container

```swift
func hide() {

    swiftContainerInteractor.hideDidAppear = {
      // didHideAppear
    }

    swiftyContainerInteractor.hide()
}

```

<img src="/Img/ContainerGIF.gif" alt="screenshot" width="auto" height="500" />

## Catch Error

```swift
import SwiftyContainer

override func viewDidLoad() {
    super.viewDidLoad

    swiftyContainer.error = { error in

        // erorr catch
        // error type is SwiftyContainerError
        self.errorHandler(error: Error)

    }
}

func errorHandler(error: Error) {
    guard let swiftyContainerError = error as? SwiftyContainerInteractorError else { return }
    switch swiftyContainerError {
    case .alreadyShow:
        // ...
    case .alreadyHide:
        // ...
    case .duringAnimation:
        // ...
    case .unknown:
        // ...
    }
}

```

## Author

[LinSaeng](https://github.com/jungseungyeo)


## License

SwiftlyIndicator is licensed under the MIT license. Check the [LICENSE](/LICENSE) file for details./LICENSE) file for details.
