sparseAMAViaModelEZ
=============


INSTALLATION:

obtain ma50ad.f 
(See page 9 of ftp://ftp.numerical.rl.ac.uk/pub/oldhsl/hsl2002.pdf)


cd modelEZ
make -f makeToCJar %this should produce modelEZtoC.jar in the modelEZ directory
cd ..
cp pathTo/ma50ad.f  ./sparseAMA/src/main/fortran/
chmod +x ./generateModelCode.sh 


TO RUN:

./generateModelCode.sh stickywage %this should create the program RUNstickwage
./RUNstickywage  runs the program with all parameters set to zero producing errors

./generateModelCode.sh stickywage reasonableParams %this should create the program RUNstickwage 
./RUNstickywage  runs the program with all parameters set by the rzero producing no errors and no output

A NOTE ABOUT GIT:

To get the most recent updates from git, a simple "git pull" would normally suffice. However, this particular
distribution utilizes a feature of git called 'submodules', each of which need to be updated. So, to pull new changes
from the server, enter:

git pull
git submodule update --recursive

The second command here updates the submodules.
