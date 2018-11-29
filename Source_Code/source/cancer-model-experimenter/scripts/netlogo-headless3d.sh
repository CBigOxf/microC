#!/bin/sh
cd "`dirname "$0"`"             # the copious quoting is for handling paths with spaces
# Ken Kahn added -Dorg.nlogo.is3d=true for 3D
# -Xmx1024m                     use up to 1GB RAM (edit to increase)
# -Dfile.encoding=UTF-8         ensure Unicode characters in model files are compatible cross-platform
# -classpath NetLogo.jar        specify main jar
# org.nlogo.headless.Main       specify we want headless, not GUI
# "$@"                          pass along any command line arguments

# this works for Netlogo 6.0.0 (in later versions there is going to fix Netlogo.Jar --> netlogo-6.0.0)
# getting error with is3d argument
# cd /system/software/linux-x86_64/netlogo/6.0.0/app
# /system/software/linux-x86_64/java/jdk-1.8.0/bin/java -Dorg.nlogo.is3d=true -Xmx32g -Dfile.encoding=UTF-8 -classpath netlogo-6.0.0.jar org.nlogo.headless.Main "$@"

# this works for Netlogo 5.3.1

 cd /system/software/linux-x86_64/netlogo/5.3.1/app
 /system/software/linux-x86_64/java/jdk-1.8.0/bin/java -Dorg.nlogo.is3d=true -Xmx32g -Dfile.encoding=UTF-8 -classpath NetLogo.jar org.nlogo.headless.Main "$@"


# following works for NetLogo 5.2
# cd /system/software/linux-x86_64/netlogo/5.2.1
# java -Dorg.nlogo.is3d=true -Xmx32g -Dfile.encoding=UTF-8 -classpath NetLogo.jar org.nlogo.headless.Main "$@"
