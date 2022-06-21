# Plot global seismicity

I used GMT (https://www.generic-mapping-tools.org/) to plot global seismicity
and Earth relief.

## Catalog

Earthquake catalog from 1990 to 2022 was downloaded from
USGS ANSS Comprehensive Earthquake Catalog (https://earthquake.usgs.gov/data/comcat/)
using the get_events functions (https://docs.obspy.org/packages/autogen/obspy.clients.fdsn.client.Client.get_events.html)
of ObsPy.

## CPT

I made a cpt for the land elevation according to
usgs.cpt (http://soliton.vm.bytemark.co.uk/pub/cpt-city/views/totp-map.html).
```
# Re-sample usgs CPT
$ gmt makecpt -Cusgs.cpt -T0/9000/280 -H > usgs-new.cpt
```
Then, I adjusted the z values for the display purpose.

I also made a cpt for the water depth according to
abyss.cpt (https://github.com/GenericMappingTools/gmt/blob/master/share/cpt/gmt/abyss.cpt).
```
# Only keep z values between 0.5 and 1
$ cp abyss.cpt abyss-0.5to1.cpt
# Re-sample abyss CPT
$ gmt makecpt -Cabyss-0.5to1.cpt -T-11000/0/500 -H > abyss-new.cpt
```
Then, I adjusted the z values for the display purpose.

Finally, I merged those two CPTs into topography.cpt.

In addition, I manually generated another CPT to plot seismicity referring to
https://www.rapidtables.com/web/color/RGB_Color.html.
