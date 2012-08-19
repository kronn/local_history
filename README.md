# LocalHistory

Small Ruboto App for looking up the street you are currently near.

One goal is to have it also look up further details like the history.


## Development

### Setup and Tutorial

For starters, follow this tutorial to install all the necessary runtimes
- https://github.com/ruboto/ruboto/wiki/Getting-started-with-Ruboto
- https://github.com/ruboto/ruboto/wiki/Environment-setup-for-ubuntu

There is a shitload of stuff to download. Once you get to the point of actually
installing the ruboto gem, you're set for this app. After `gem install ruboto`,
of course.

If you just started out, you need to create an emulator. I had issues with a
missing ABI-package.  Start the `android` application without any argument from
the console. It should give you a graphical package manager. At the very least
it gives you a list of available packages, sorted by Android-API Level by
default. I was able to find a ABI (ARM EABI v7a System Image) which allowed me
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

### Building

```
rake                            # create a debug build
rake stop install:clean start   # restart the app, passing the code to the emulator
```

### Analysis

```
adb logcat
```
