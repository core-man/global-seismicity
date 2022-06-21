#!/usr/bin/env bash
#
# Plot global seismicity
#

# Set earthquake symbol size
eq_size1=0.25
eq_size2=0.65

# Sort earthquakes by their depths
sort -g -k 4 catalog/catalog-1900-2022.dat > catalog-1900-2022.dat

gmt begin global-seismicity pdf,png,jpg
# gmt begin global-seismicity pdf

# Begin to plot global seismicity
gmt set FONT_ANNOT_PRIMARY=40p

# Plot topography
gmt grdimage @earth_relief_02m -Ctopography.cpt -I+d -JN123/230c -Rg
gmt basemap -Bxa20g20 -Bya20g20 -BWESN -U+jBL+o179c/0c

# Plot seismicity
awk '$5>=5 && $5<7 {print $2,$3,$4}' catalog-1900-2022.dat | gmt psxy -Sc${eq_size1}c -W0.1p -Cseismicity.cpt
awk '$5>=7 {print $2,$3,$4}' catalog-1900-2022.dat | gmt psxy -Sa${eq_size2}c -W0.1p -Cseismicity.cpt

# Plot legend
echo -45 -55 "Earthquake (Magnitude >= 7)" | gmt text -F+f50p,0,black+jML -N -D170c/-18c
echo -45 -55 | gmt psxy -Sa2c -Gred -N -D169c/-18c
echo -45 -55 "Earthquake (7 > Magnitude >= 5)" | gmt text -F+f50p,0,black+jML -N -D170c/-20c
echo -45 -55 | gmt psxy -Sc1.3c -Gred -N -D169c/-20c

# Plot legend
echo 120 90 "Seismicity of the World" | gmt text -F+f350p,1,black+jTC -N -D0c/18c
echo -45 -55 "Data Source" | gmt text -F+f80p,1,black+jML -N -D-28c/-10c
echo -45 -55 "Earth Relief (From the Generic Mapping Tools data server):" | gmt text -F+f40p,0,black+jML -N -D-28c/-13c
echo -45 -55 "Global Bathymetry and Topography at 15 Arc Sec (SRTM15+)" | gmt text -F+f40p,0,black+jML -N -D-28c/-14.5c
echo -45 -55 "Earthquake Catalog (From 1904 to 2022/06):" | gmt text -F+f40p,0,black+jML -N -D-28c/-16.5c
echo -45 -55 "U.S. Geological Survey ANSS Comprehensive Earthquake Catalog" | gmt text -F+f40p,0,black+jML -N -D-28c/-18c
# echo -45 -55 "Earthquake Catalog (From 1900 to 2022/06):" | gmt text -F+f40p,0,black+jML -N -D-28c/-16.5c
# echo -45 -55 "The Bulletin of the International Seismological Centre" | gmt text -F+f40p,0,black+jML -N -D-28c/-18c
echo -45 -55 "The plotting script:" | gmt text -F+f40p,0,black+jML -N -D-28c/-20c
echo -45 -55 "https://github.com/core-man/global-seismicity" | gmt text -F+f40p,0,black+jML -N -D-28c/-21.5c

# Plot color bar
gmt colorbar -Dx40c/-6c+w150c/2c+h+e -Ctopography.cpt -L --FONT_ANNOT_PRIMARY=20p
echo 122 -90 "Earth Relief (m)" | gmt text -F+f80p,1,black+jMC -N -D0c/-9c
gmt colorbar -Dx227c/-5c+w-25c/2c+eb -Cseismicity.cpt -L -N --FONT_ANNOT_PRIMARY=25p
# gmt colorbar -Dx227c/-5c+w-25c/2c -Cseismicity.cpt -L -N --FONT_ANNOT_PRIMARY=25p
echo 122 -90 "Earthquake Depth (km)" | gmt text -F+f70p,1,black+a90+jMC -N -D110c/8c


# gmt set FORMAT_GEO_MAP=+D MAP_FRAME_WIDTH=1p FONT_ANNOT_PRIMARY=8p
gmt set FORMAT_GEO_MAP=+D MAP_FRAME_WIDTH=5p FONT_ANNOT_PRIMARY=40p


# Begin to plot Arctic seismicity
gmt grdimage @earth_relief_03m -Ctopography.cpt -I+d -JA0/90/35/35c -Rg -X-1c -Yh-12c
gmt basemap -Bxa30g30 -Byg15

# Plot seismicity
awk '$5>=5 && $5<7 {print $2,$3,$4}' catalog-1900-2022.dat | gmt psxy -Sc${eq_size1}c -W0.1p -Cseismicity.cpt
awk '$5>=7 {print $2,$3,$4}' catalog-1900-2022.dat | gmt psxy -Sa${eq_size2}c -W0.1p -Cseismicity.cpt

# Plot North Pole and Arctic Circle
echo 0 90 47d | gmt plot -SE- -W2p,black,-
gmt text -F+f30p,0,black+jBC+a-45 << EOF
315 60.5 60\232N
315 67.5 66.5\232N
315 75.5 75\232N
315 85.5 85\232N
EOF

# Begin to plot Antarctica seismicity
gmt grdimage @earth_relief_03m -Ctopography.cpt -I+d -JA0/-90/35/35c -Rg -X197c
gmt basemap -Bxa30g30 -Byg15

# Plot seismicity
awk '$5>=5 && $5<7 {print $2,$3,$4}' catalog-1900-2022.dat | gmt psxy -Sc${eq_size1}c -W0.1p -Cseismicity.cpt
awk '$5>=7 {print $2,$3,$4}' catalog-1900-2022.dat | gmt psxy -Sa${eq_size2}c -W0.1p -Cseismicity.cpt

# Plot South Pole and Antarctic Circle
echo 0 -90 47d | gmt plot -SE- -W2p,black,-
gmt text -F+f30p,0,black+jBC+a45 << EOF
135 -60.5 60\232S
135 -67.5 66.5\232S
135 -75.5 75\232S
135 -85.5 85\232S
EOF

# Plot annotation
echo 0 -53 "0\232" | gmt text -F+f43p,0,black -N
gmt text -F+f43p,0,black+a -N << EOF
30 -53 -30 30\232
60 -53 -60 60\232
90 -53 90 90\232
120 -53 60 120\232
150 -53 30 150\232
180 -53 0 180\232
210 -53 -30 210\232
240 -53 -60 240\232
270 -53 90 270\232
300 -53 60 300\232
330 -53 30 330\232
EOF

gmt end show

# Remove tmp files
rm catalog-1900-2022.dat
