mPower App
==========

The Parkinson app is one of the first five apps built using ResearchKit.

mPower is a unique iPhone application that uses a mix of surveys and
tasks that activate phone sensors to collect and track health and
symptoms of Parkinson Disease (PD) progression - like dexterity,
balance or gait.

Our goals are to learn about the variations of PD, to improve the way
we describe these variations and to learn how mobile devices and
sensors can help us to measure PD and its progression to ultimately
improve the quality of life for people with PD.


Building the App
================

###Requirements

* Xcode 6.2
* iOS 8.2 SDK

###Getting the source

First, check out the source, including all the dependencies:

```
git clone --recurse-submodules git@github.com:ResearchKit/Parkinson.git
```

###Building it

Open the project, `Parkinson.xcodeproj`, and build and run.


Other components
================

The shipping app also uses OpenSSL to add extra data protection, which
has not been included in the published version of the AppCore
project. See the [AppCore repository](https://github.com/researchkit/AppCore) for more details.
