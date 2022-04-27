# WalkJourney
<p align="center">
  <img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/WalkJourney_logo.png" width="200" height="200"/>
</p>

<p align="center">
   <img src="https://img.shields.io/github/license/Naereen/StrapDown.js.svg"> 
   <img src="https://cocoapod-badges.herokuapp.com/p/NSStringMask/badge.svg"> 
</p>

<p align="justify">
  <b>WalkJourney</b> is a health and fitness application about promoting “walk and life” balance which providing user not only to <b>trace their steps and route</b> but also can walk with <b>challenge map</b> then share to social group. Hopefully everyone can find fun in fitness and reap the benefits of a healthier, active lifestyle.
</p>

<p align="center">
  <a href="https://apps.apple.com/tw/app/id1594812042 ">
    <img src="https://i.imgur.com/X9tPvTS.png" width="120" height="40"/>
  </a>
</p>

## Table of Contents
* [Features](#Features)
* [Highlights](#Highlights)
* [Libraries](#Libraries)
* [Requirement](#Requirement)
* [ReleaseNotes](#ReleaseNotes)
* [Contact](#Contact)

## Features
- Real-time display walking steps, time, and route.
- Provide two different walking mode including "walk your way" and "walk with challenge map".
- Record walking information with different mode.
- Display user's daily stpes by monthly. 
- Share challenge map with other users in social group.

#### HomePage
- Choose how to walk
  - walk your way
  - walk with challenge map
 <p align="center">
<img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/1_homePage.png?raw=true" width="200" height="400"/>
<img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/2_startToWalk.png?raw=true" width="200" height="400"/>
<img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/3_challengeMap.png?raw=true" width="200" height="400"/>
</p>

#### RecordPage
 - Record user's own walking history
 <p align="center">
<img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/4_recordPage.png?raw=true" width="200" height="400"/>
</p>

#### SocialGroupPage
 - View all users challenge route if they share to social wall
 <p align="center">
<img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/5_socialPage.png?raw=true" width="200" height="400"/>
<img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/6_socialShare.png?raw=true" width="200" height="400"/>
</p>

#### ProfilePage
 - Invite friends, display friends list and blocks list
 <p align="center">
<img src="https://github.com/zoeliauh/WalkJourney/blob/main/Screenshot/7_profilePage.png?raw=true" width="200" height="400"/>
</p>


## Highlights
- Created an API key to install Google Maps SDK for iOS and setup Google map for better and more complete user experience feature.
- Imported Core Motion to process accelerometer, gyroscope, pedometer, and environment-related events.
- Imported Core Location to obtain the geographic location and orientation of the device after asking user’s permission.
- Utilized MVC as core architectural design and managed third party dependencies through CocoaPods.
- Built user interfaces both in a storyboard and in programming.
- Implemented Sign in with Apple and integrated with Firebase Authentication which provide back-end services and a secure way to manage user private information.
- Built Firestore Database to create, read, update and delete data and built Storage to upload images. 
- Utilized Firebase Crashlytics to track how and when crashes happened as well as fixed the crash issue.
- Utilised Lottie to ship animations in a JSON-based animation file format while uploading images to Firebase Storage.
- Used Kingfisher for downloading and caching images.
- Used JGProgressHUD to display a progress indicator for user easily to know what's on going.


## Libraries
- [Google Maps](https://developers.google.com/maps/documentation/ios-sdk/overview)
- [Firebase](https://firebase.google.com)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [Charts](https://github.com/danielgindi/Charts)
- [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
- [lottie-ios](https://github.com/airbnb/lottie-ios)
- [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager)
- [SwiftLint](https://github.com/realm/SwiftLint)

## Requirement
- Xcode 13.0 or higher version
- Swift 5.0 or higher version
- iOS 14.0 or higher version

## ReleaseNotes
| Version | Date | Description                                                                                     |
| :-------| :----|:------------------------------------------------------------------------------------------------|
| 1.1.0   | 2021.12.08 | Improved performance. |
| 1.0.0   | 2021.11.25 | Launched in App Store|
## Contact
Zoe Liauh <br>woanjwuliauh@gmail.com</br>
