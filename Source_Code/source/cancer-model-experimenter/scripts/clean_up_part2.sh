# remove all files from experiment folder

if [ $# -gt 0 ] ; then
  # if an argument was provided
  rm -R /data/donc-onconet/share/cancer/$1
fi
