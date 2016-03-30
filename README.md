# KiiSmartLightDemo

## Project Setup
To get the project installed, do the following

```
git clone https://github.com/cjbeauchamp/KiiSmartLightDemo.git

# If you are on a Linux machine and wanting to run the daemon, 
# continue wit the following.
# If you just want the iOS code or scripts, you can stop here

cd KiiSmartLightDemo
cd thing-if-ThingSDK
git submodule init
git submodule update
cd kii
git submodule init
git submodule update
cd ../
make
```

## Project Structure

### Hardware
The hardware is simulated by running a daemon on a Linux machine. This is the same code you could run on an actual device, but makes it easier to build and run on a VirtualBox or Linux box. Find this code in the `Linux` directory. 

The simulated device is a smart light bulb, and you can control the color, brightness and power. To display the light bulb, we have a simple Java app that reads the bulb's current state (managed by the Linux daemon) and creates the proper display. In reality, your actual device firmware would do something similar. This code is found in the `JavaBulb` directory.

### Mobile
To control the bulb, you can do this from the cloud, or you can do it from an iOS device. The app is stored within the `iOS` directory. 

### Scripts
Some pre-configured curl scripts to help you onboard devices, post commands, etc. See more about this directory within its README.