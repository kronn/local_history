# LocalHistory

## Abstract

Small Ruboto App for looking up the street you are currently near.

One goal is to have it also look up further details like the history.

## Steps

Although not properly outlined in separate commits (I did `git init` a little
late), the basic steps were these:

1. find a tutorial on the ruboto-wiki on github that handles GPS
2. try to get it to work
   [the tutorial has been updated during the workshop, so it should run]

3. first success is to see GPS coordinates
4. next, we try to look up the address of the coordinates via GoogleMaps
   [the GPS tutorial has the url inside]
5. we used the apache http client instead of Net::HTTP
   [this is reflected in the tutorial]
6. we use the yaml to parse JSON
   [because since a recent YAML-version, YAML is a superset of JSON]
7. In order to load YAML, we need some `with_large_stack_do { ... }` magic
   This eludes me at the moment and is not reflected in the tutorial properly.
   JFGI...
8. next steps would be to show multiple streets in the area an display a list
9. each list-item would need to trigger a lookup further details.

In the workshop we went as far as step 7. My app does not crash when loading
YAML, so I guess that I am not testing good enough. This repo does (to my knowledge)
not contain any substantial tests.

## Development

### Setup and Tutorial

For starters, follow this tutorial to install all the necessary runtimes
- https://github.com/ruboto/ruboto/wiki/Getting-started-with-Ruboto
- https://github.com/ruboto/ruboto/wiki/Environment-setup-for-ubuntu

There is a shitload of stuff to download which is not always fun over
conference WiFi. Once you get to the point of actually installing the ruboto
gem, you're set for this app. After `gem install ruboto`, of course.

If you just started out, you need to create an emulator. I had issues with a
missing ABI-package.  Start the `android` application without any argument from
the console. It should give you a graphical package manager. At the very least
it gives you a list of available packages, sorted by Android-API Level by
default. I was able to find an ABI (ARM EABI v7a System Image) which allowed me
to build the emulator.

```
android -s create avd -f -n Android_4.1 -t android-16 --sdcard 64M
```

The final dependency is not found on the web, it is `patience`. Emulation is
slow, it gets better on actual devices.

### Emulation Environment

run the emulator. The name of the "Android Virtual Device (AVD)" needs to 
match wathever name you have it before. In doubt: see ~/.android/avd/

```
emulator -avd Android_4.1
```

If you need to set some value (like GPS-data), you can use the Dalvik Debug Monitor

```
ddms
```

### Building

```
rake                            # create a debug build
rake stop install:clean start   # restart the app, passing the code to the emulator
```

### Analysis

You can output the log (think `tail -f /var/log/syslog`) of the device.

```
adb logcat
```

You have this information also in the `ddms`, even can filter it there. But I just 
had the emulator window and the log side by side. 

## Android Permissions and Versions

Your APK needs certain permissions. Those are requested in the AndroidManifest.xml.

Also, in the AndroidManifest, the minimal and the target version of android are
set. For starters, it was mentioned that it's best to keep both the same. Once you
know how these are working, you know. Until then: both declare the version you
want it to run on.
