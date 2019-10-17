using Dates
using ClimateSatellite

# 1) Create range of dates
nw = Dates.now();
yr = Dates.year(nw); mo = Dates.month(nw); dy = Dates.day(nw);
if mo <= 3 & dy == 1; yr = yr-1; mo = mo+9; else; mo = mo-3; endß
dvec = collect(Date(1998,1,1):Day(1):Date(2014,12,31))

# 2) Download data for range of dates
for datei in dvec; trmmrun(datei,clisatroot(),["SEA","IND"]); end
