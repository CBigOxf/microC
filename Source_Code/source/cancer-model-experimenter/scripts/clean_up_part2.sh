# remove all files from experiment folder

if [ $# -gt 0 ] ; then
   rm -R /data/donc-onconet/share/cancer/$1
fi
