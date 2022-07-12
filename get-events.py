"""Download earthquake catalog
"""
import os

import numpy as np
from obspy.clients.fdsn import Client
from obspy import UTCDateTime


os.makedirs("catalog", exist_ok=True)
client = Client("USGS")
# client = Client("ISC")

for year in range(1900, 2023):
    catalog = client.get_events(starttime=UTCDateTime(f"{year}-01-01T00:00:00.000"),
                                endtime=UTCDateTime(f"{year+1}-01-01T00:00:00.000"),
                                minmagnitude=5)
    print(f"{year}: {catalog.count()} events.")

    events = []
    for ev in catalog[::-1]:
        origin_time = ev.preferred_origin().time

        # Cannot find preferred magnitude, e.g, for ISC catalog
        if ev.preferred_magnitude() == None:
            # Ignore events with no magnitude
            if (len(ev.magnitudes) == 0):
                print(f"{origin_time} has no magnitude")
                continue

            # Regard the largest magnitude as the preferred magnitude
            mag_max = -10
            for i, mag in enumerate(ev.magnitudes):
                if mag.mag > mag_max:
                    mag_max_index = i
                    mag_max = mag.mag
            evmg = ev.magnitudes[mag_max_index].mag
            evmg_type = ev.magnitudes[mag_max_index].magnitude_type
        else:
            evmg = ev.preferred_magnitude().mag
            evmg_type = ev.preferred_magnitude().magnitude_type

        # Cannot find preferred depth
        if ev.preferred_origin().depth == None:
            print(f"{origin_time} has no depth")
            # Check if there is depth value
            for origin in ev.origins:
                if origin.depth != None:
                    print("Error in determining preferred depth!!!")
                    print(origin)
            continue
        else:
            lon = ev.preferred_origin().longitude
            lat = ev.preferred_origin().latitude
            depth = ev.preferred_origin().depth

        events.append([origin_time.strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3],
                       float("{:.4f}".format(lon)),
                       float("{:.4f}".format(lat)),
                       float("{:.1f}".format(depth/1000.0)),
                       float("{:.1f}".format(evmg)),
                       evmg_type])

    if len(events) == 0:
        continue
    np.savetxt(f"catalog/{year}.dat", np.array(events), fmt=["%s", "%9s", "%8s", "%6s", "%3s", "%s"])

os.system("cat catalog/1*.dat catalog/2*.dat > catalog/catalog-1900-2022.dat")
