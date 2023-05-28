<h1 align="center">CCEPNews</h1>
<h3 align="center">An iOS application to display list of News.</h3>

## About

This repository includes an iOS application to display the list of Short News and News in detail.
The main purpose of this project is to develop an app in MVVM-C using Combine and Coordinator frameworks. An API is integrated to fetch the list of news. Latest News are displayed in user friendly interface with ease. 

## Screens

- **News List:** displays list of news with their thumbnails, title, content and timestamp.
- **News Detail:** displays picture of a news, title, full content, author name and time.
- **Read More:** displays full details of the news in webview.
<p align="center">
  <img src="./CCEP/Screenshots/NewsListScreenshot.png" height="512">
  <img src="./CCEP/Screenshots/NewsDetailScreenshot.png" height="512">
  <img src="./CCEP/Screenshots/ReadMoreScreenshot.png" height="512">


## Architecture

This app has been developed using a MVVM-C with Coordinator framework. The app has three major layers: 
- The **Presentation** layer, which contains the views and other UIKit-related units.
- The **Domain** layer, which contains the business logic and use cases.
- The **Data** layer, which contains the models.

### Tests

This app has a bunch of unit tests. Models has been tested.
