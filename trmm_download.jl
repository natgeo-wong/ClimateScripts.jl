using Dates
using ClimateSatellite

# 1) Create range of dates
dvec = collect(Date(1998,1,1):Day(1):Date(2014,12,31))

# 2) Download data for range of dates
for datei in dvec; trmmrun(datei,clisatroot(),["SEA","IND"]); end
