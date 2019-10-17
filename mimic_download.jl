using Dates
using ClimateSatellite

# 1) Create range of dates
nw = Dates.now();
yr = Dates.year(nw); mo = Dates.month(nw); dy = Dates.day(nw);
if mo == 1 & dy == 1; yr = yr-1; mo = 12; else; mo = mo-1; endß
dvec = collect(Date(2016,10,1):Day(1):Date(yr,mo,31))

# 2) Download data for range of dates
for datei in dvec; mimicrun(datei,clisatroot(),["SEA","IND"]); end
