# Earthquakes
Earthquakes is an open source iOS Application built in Swift 3. It uses [open API](http://earthquake.usgs.gov/fdsnws/event/1/) to fetch the catalog of earthquakes.


![table View](https://cloud.githubusercontent.com/assets/18245585/20769663/2a49aa22-b743-11e6-8cef-18ba9a5ab19d.png)    ![details View](https://cloud.githubusercontent.com/assets/18245585/20769667/2c351a74-b743-11e6-986d-6a7f82eaaa35.png)

## Features
- Uses Alamofire for making requests to API
- Pull to Refresh earthquakes 
- SwiftyJSON for easier JSON parse 
- Saves favourite earthquakes to Core Data
- NSFetchedResultsController to update favourite earthquakes list 
- MapKit to show an earthquake location

##Requirements
- Swift 3.0 & Xcode 8
- iOS 10.0+ 

## Getting started 
- Clone the project
- cd into the project folder
- Run `pod install`
- Open `Earthquakes.xcworkspace`
