#!/bin/bash

set -e
self=$(basename $0)
trap 'echo $self: Some errors occurred. Exiting.; exit' ERR

usage(){
        echo "usage: $self "
	echo "or"
	echo "       cat file.dat | $self"
	echo ""
	echo "Computes the coordinates y1,y2 and y3 of end points"
	echo "of a fault or volume located at x1,x2 and x3. The script"
	echo "is useful to construct slip distributions or ductile zones."
	echo ""
	echo "usage: $self"
	echo "1 x1 x2 x3 length width thickness strike dip"
	echo "..."
	echo "N x1 x3 x4 length width thickness strike dip"
	echo ""
        echo "options:"
        echo "         -h display this message"
	echo "         -c cumulative (the new point becomes the origin point)"
	echo ""
        echo "description:"
	echo ""
	echo "                   North (x1)"
	echo "                  /     "
	echo "                 /) Strike                          y1,y2,y3 " 
	echo "     x1,x2,x3 ->@------------------------    (x2)     +     "
	echo "                :\                       \ W         / k s"
	echo "                :-\                       \ i       / c s"
	echo "                :  \                       \ d     / i e"
	echo "                :90 \                       \ t   / h n"
	echo "                :-Dip\                       \ h / T -"
	echo "                :     \                       \^/"
	echo "                :      -------------------------"
	echo "                :             L e n g t h"
	echo "                Z (x3)"
	echo ""
	echo "  The fault strike, normal and dip unit vectors are:"
	echo ""
	echo "     s = [cos(str), sin(str), 0]"
	echo "     n = [+sin(str) * sin(dip), -cos(str) * sin(dip), +cos(dip)]"
	echo "     d = [-sin(str) * cos(dip), +cos(str) * cos(dip), +sin(dip)]"
	echo ""
	echo "  The 1, 2 & 3 directions are north, east and down, respectively."
	echo "  Unit vectors s, n, d form a right-handed coordinate system." 
	echo "  Positive unit dip vectors are pointing down dip. The end point"
	echo "  coordinates are:"
	echo ""
	echo "     y1 = x1 + l*s1 + w*d1 + t*n1"
	echo "     y2 = x2 + l*s2 + w*d2 + t*n2"
	echo "     y3 = x3 + l*s3 + w*d3 + t*n3"
	echo ""
	
        exit
}

while getopts "cd:hs:" flag
do
  case "$flag" in
    c) cset=1;;
    d) dset=1;dip=`echo "" | awk -v a=$OPTARG '{print a*3.1415926535897932385/180.0}'`;;
    h) hset=1;;
    s) sset=1;str=`echo "" | awk -v a=$OPTARG '{print a*3.1415926535897932385/180.0}'`;;
  esac
done
for item in $dset $sset;do
	shift;shift
done

# usage
if [ "1" == "$hset" ]; then
	usage
fi

# cumulative
if [ "1" != "$cset" ]; then
	cset=0;
fi

echo "#  n   x1   x2   x3 length width thickness strike dip"
while read line
do
	if [ "$line" == "" ]; then
		exit 0;
	fi
	# character '#' indicates a commented line
	if [ `echo $line | awk '{print substr($0,1,1)}'` == "#" ]; then
		continue
	fi
	di="$(echo $line | cut -d " " -f 9)"
	echo $line
done | awk -v c=$cset '{
		d2r=atan2(1,0)/90.0;
		if (1==NR || 0==c){
			x1=$2;
			x2=$3;
			x3=$4;
		}
		l=$5;
		w=$6;
		t=$7;
		s=$8;
		d=$9;
		s1=cos(s*d2r);
		s2=sin(s*d2r);
		n1=sin(s*d2r)*sin(d*d2r);
		n2=-cos(s*d2r)*sin(d*d2r);
		n3=+cos(d*d2r);
		d1=-sin(s*d2r)*cos(d*d2r);
		d2=+cos(s*d2r)*cos(d*d2r);
		d3=+sin(d*d2r);
		y1=x1+l*s1+w*d1+t*n1;
		y2=x2+l*s2+w*d2+t*n2;
		y3=x3+l*s3+w*d3+t*n3;
		printf("%+e %+e %+e\n",y1,y2,y3);
		if (1==c){
			x1=y1;
			x2=y2;
			x3=y3;
		}
	}'

