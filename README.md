sparseAMAViaModelEZ
=============


obtain ma50ad.f 
(See page 9 of ftp://ftp.numerical.rl.ac.uk/pub/oldhsl/hsl2002.pdf)


cd modelEZ
make -f makeToCJar %this should produce modelEZtoC.jar in the modelEZ directory
cd ..
cp pathTo/ma50ad.f  ./sparseAMA/src/main/fortran/
chmod +x ./generateModelCode.sh 
./generateModelCode.sh stickywage %this should create the program RUNstickwage
./RUNstickywage  runs the program with all parameters set to zero producing errors





./generateModelCode.sh stickywage reasonableParams %this should create the program RUNstickwage 
./RUNstickywage  runs the program with all parameters set by the f90 program reasonableParams


