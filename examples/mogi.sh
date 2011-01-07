#!/bin/sh

# viscoelastic relaxation following a dilatation source
# viscous flow governed by a power-law viscosity with
# stress exponent of n = 3.

time ../relax <<EOF
# grid size (sx1,sx2,sx3)
256 256 256
# sampling size & smoothing (dx1,dx2,dx3,beta) & nyquist
0.05 0.05 0.05 0.2 1
# origin position and rotation
0 0 0 
# observation depth (displacement and stress)
0 0.5
# output directory
./mogi
# elastic parameters (lambda,mu) and gravity effect
1 1 0
# integration time (t1)
10 0.257
# number of observation planes
0
# number of observation points
0
# number of prestress interfaces
0
# number of linear viscous interfaces
0
# number of powerlaw viscous interfaces
1
# no depth gammadot0 power cohesion
   1     2        20     3        0
# number of power-law ductile zones
0
# number of friction faults
0
# number of interseismic loading stuff
0
0
# number of coseismic events
1
# number of shear dislocations
0
# index slip   x1 x2 x3 length width strike dip rake
#      1    0 -1.0  0  0      1   0.8      0  90    0
# number of tensile cracks
0
# number of dilatation point sources
1
# no dilatation xs ys zs
   1          1  0  0  1
EOF
