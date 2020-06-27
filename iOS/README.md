### Setup instructions for MMIW AR app.

#### CocoaPods installation
If you haven't installed CocoaPods before, then you will want to follow these instructions from the [CocoaPods Guide](https://guides.cocoapods.org/using/getting-started.html):

CocoaPods is built with Ruby and it will be installable with the default Ruby available on macOS. You can use a Ruby Version manager, however we recommend that you use the standard Ruby available on macOS unless you know what you're doing.

`$ sudo gem install cocoapods`  

#### Running the project
From the /MMIWG2S/iOS directory in terminal:
1. Run `$ pod install`  
2. `$ open MMIWG2S.xcworkspace`  
3. Inside Xcode, go to `Signings & Capabilities`, you will need to choose your
personal team and change the bundle identifier to `com.[YOUR DOMAIN].MMIWG2S`  
4. You should be able to run your project now.
