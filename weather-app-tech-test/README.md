#  iOS Tech Test Submission - Russell Warwick

Here I am going to make some notes on why I chose to use certain patterns, architectures, services and packages. I hope you enjoy reviewing my submission 😃

## Architectures

I have decided to use a MVVM approach. This is a simple app with only one screen. Has multiple cells rows which also have ViewModels for the data. This allows the ViewModels to be easily tested and mocked if need be. Ideally I would have liked the ViewModels to have a protocol wrapped around them if I had more time.

## UI and Layout

I've decided to use a Swift package for my UI layout. This is actually my own package that I built and maintained whilst working at Gymshark, it was my own idea I worked on as I began to become frustrated with repetitive tasks such as adding views to UIStackViews e.t.c. I also saw the advancements of SwiftUI and the VStack HStack syntax. I thought I could take advantage of Swifts latests ResultBuilders to extend UIViews capability to allow me to build VStack HStacks declaratively. The great part of this package is that you still have access to UIViews NSLayoutConstraints, something that SwiftUI lacks. It also omits the need to set translatesAutoresizingMaskIntoConstraints = false to every UI property within UIKit. I hope you see why I chose to use and show off this package and hopefully won't be seen as a negative to the test. Read more here: https://github.com/gymshark/ios-stack-kit

## More time

I spent a couple hours on this tasks. If I had more time I would have liked to add full test coverage for all the view models. Added snapshot tests to the Views and ViewController. I would have improved the design of the UI and included a icon for the weather. I would have also implemented dark mode to the app. A custom UI prompt for the location service would be nice too. I could have also grouped the weekly forecast by day. Having a new section for each day. Also upon tapping on a weekly forecast cell I would like to expand the view showing more details of that time frame.

I would have liked to expand the networking services to include tests and integration tests. Also adding some UITests
