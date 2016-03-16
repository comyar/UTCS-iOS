![](/Meta/readme_header.png)

[![Build Status](https://travis-ci.com/txcsmad/UTCS-iOS.svg?token=1o9Avy4mGixFuRg9knBP&branch=master)](https://magnum.travis-ci.com/utcsmad/UTCS-iOS)

# Introduction

The UTCS iOS app is a collaborative project between the Department of Computer Science and Mobile App Development (MAD). The app represents the efforts of students at a top-ten computer science institution and should attempt to achieve the same level of innovation, creativity, and perfection as the most well-made iOS apps on the App Store. Examples of such apps include [Paper | Stories from Facebook](https://www.facebook.com/paper) and [Yahoo Weather](https://itunes.apple.com/us/app/yahoo-weather/id628677149?mt=8).


### Design First

The app was built "design-first", meaning the user interface has been crafted in such a way as to provide the most immersive and beautiful experience for the user. For example, at the heart of every screen in the app is an image of the Gates-Dell Complex. The experience is very personal, the GDC is a point of pride for both students and the department alike. New features should be developed in the same manner, "design-first", to enhance the overall experience.


### Features

Currently, the app allows a user to do the following:

  * Read and share the most recent UTCS news articles
  * View upcoming events, receive notifications before they start, and share them with friends
  * Search the UTCS directory for faculty, staff, and graduate students
  * View the status of each the labs in the GDC
  * View a user's disk quota

# Building the Project

When working on the project, always open the project's workspace in Xcode rather than it's project file. The project uses [Cocoa Pods](http://cocoapods.org/) to manage project dependencies and can be installed using ```sudo gem install cocoapods```. To install all the project's dependencies, simply run ```pod install``` in the directory containing _Podfile_.

