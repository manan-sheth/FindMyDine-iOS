# FindMyDine-iOS
Find Near by Restaurants using Zomato API

# Screenshots:![]()
<image src= "Screenshots/1.png" height="400"/>
<image src= "Screenshots/2.png" height="400"/>
<image src= "Screenshots/3.png" height="400"/>

## Built with

* [Realm](https://realm.io/) - Local Database Management
* [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP networking library
* [SDWebImage](https://github.com/SDWebImage/SDWebImage) - Async image downloader with cache support

## Installation

### [CocoaPods]

[CocoaPods]: http://cocoapods.org
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
$ gem install cocoapods
```

To run this project, Integrate below cocoapods into your Xcode project using CocoaPods, specify it to a target in your Podfile:

```ruby
...

target 'Find My Dine' do
# Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!

    # Pods for Find My Dine
    pod 'RealmSwift'
    pod 'Alamofire', '~> 4.0'
    pod 'SDWebImage', '~> 5.0'
    
    target 'Find My DineTests' do
        inherit! :search_paths
        # Pods for testing
        pod 'RealmSwift'
        pod 'Alamofire', '~> 4.0'
        pod 'SDWebImage', '~> 5.0'
    end

    target 'Find My DineUITests' do
        # Pods for testing
        pod 'RealmSwift'
        pod 'Alamofire', '~> 4.0'
        pod 'SDWebImage', '~> 5.0'
    end
end
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `$ pod install` with CocoaPods 0.36 or newer.

You should open the `{Project}.xcworkspace` instead of the `{Project}.xcodeproj` after you installed anything from CocoaPods.

# Author:

* **Manan Sheth** - *Initial work* - [manan-sheth](https://github.com/manan-sheth)
