#DNSiOSLocalizationTestHelpers

Since testing your app in different languages is a giant pain in the ass, I've pulled a bunch of tools I've scraped together into a category on `XCTestCase`. 

#Prerequisite: Setting The Language In Your Scheme

To be able to use this class, you'll need to set up your build scheme to use a specific a language for its tests: 

1. Select your main build scheme in the drop-down next to the stop button. 
2. Choose `Edit Scheme...`
3. Select the `Test` task in the left sidebar.
2. Select the `Arguments` task at the top. 
3. Add two new arguments: 
	- `-AppleLanguages`
	- `"\(en\)"` (or whatever two-letter language code you use for development)

For each new language you wish to test, you should duplicate this scheme (you will need to be in `Manage Schemes...` in the Scheme drop down to do this), update the two-letter language code to what you wish to test, and make sure to rename the scheme clearly to indicate what language it's supporting.

An example of multiple schemes is included in the sample/testbed project.

##The advantage of this approach

The good news on this is that, at least on iOS 8, it works for both simulator and device without having to actually reset your sim/device's language. 

Anyone who's ever had to wait as the system killed everything on their phone so they could test in another language or tried to figure out where the hell the keyboard settings are in a a language using a different character set than the one used by their primary language will enjoy this immensely. 

##The disadvantage of this approach

You wind up with as many schemes as languages you support, all of which should be shared so anyone (especially CI bots) checking out your project can run the tests in any language. 

If you ever have to add something else to your scheme, this can get SUPER annoying because you have to update it in `n` places, where `n = # of languages supported`. 

#Installation

Recommended installation is through [CocoaPods](http://cocoapods.org/). Add the following line to your `Podfile`: 

```ruby
pod 'DNSiOSLocalizationTestHelpers', '~> 1.0'
```

If you despise dependency management and automatic updating, you can just drag the files in the `Library` folder into your test target. 
