Parse.com And Storyboards
=========================

Sample project to demonstration the use of the Parse SDK for iOS5 Storyboards based apps, using ARC.


Background
----------

* [parse.com](http://parse.com/) -- a frame work for asynchronous backing store for iOS (and Android) apps
* [Storyboards](http://https://developer.apple.com/technologies/ios5/) -- GUI and code framework for flow-based app design

The app allows users to register & create "video cards," which can be decorated with different frames designs. Remember the "purikura" photobooth sticker craze in Japan? Something like that, where users can "buy" a cute frame & generate an online link to their video. The backend to this app would then pull user data (frame design choice, video and optionally some messages) from the Parse.com REST api. The app creates a unique URL for the user to share. The app contains a StoreKit manager to "buy" new frames in 2x, 4x and 8x increments.


Instructions
------------

1. git clone this repo
2. register for a Parse.com account
3. download the Parse framework sdk
4. install the "parse.framework" at the root level of this project
5. edit the "MFAppDelegate.h" file to add your Parse.com api keys
6. enjoy!


Versions
--------

* 1.0 -- initial commit with basic account creation, video upload, store kit integration
* 1.1 -- minor update to the readme, adding a simple home on GitHub to demo the backend
* 1.2 -- [FIX] video upload bug due to nil image, account status segue bug



To-Do
-----

1. Clean up the frame selection, right now the Storyboard jumps to the video upload
2. Fix the 6 warnings on v1.1; related to the ARC singleton design pattern in the StoreKit manager and the ImagePicker iOS5 compatibility
3. Get some artwork!
4. Get some feedback -- come on people, say something!




