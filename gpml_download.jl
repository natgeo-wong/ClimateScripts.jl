using Dates
using ClimateSatellite

# 1) Create range of dates
nw = Dates.now()-Day(2);
yr = Dates.year(nw); mo = Dates.month(nw); dy = Dates.day(nw);
dvec = collect(Date(2000,6,1):Day(1):Date(yr,mo,dy));

# 2) Download data for range of dates
for datei in dvec; gpmlrun(datei,clisatroot("/n/kuangdss01/users/nwong/data/"),["SEA","IND"]); end
