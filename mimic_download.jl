using Dates
using ClimateSatellite

# 1) Create range of dates
nw = Dates.now()-Day(2);
yr = Dates.year(nw); mo = Dates.month(nw); dy = Dates.day(nw);
dvec = collect(Date(2016,10,1):Day(1):Date(yr,mo,dy))

# 2) Download data for range of dates
for datei in dvec; mimicrun(datei,clisatroot(),["SEA","IND"]); end
