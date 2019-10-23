using Dates
using ClimateSatellite, ClimateTools

# 1) Create range of dates
nw = Dates.now()-Day(2);
yr = Dates.year(nw); mo = Dates.month(nw); dy = Dates.day(nw);
dvec = collect(Date(2016,10,1):Day(1):Date(yr,mo,dy))

# 2) Download data for range of dates
@info "$(Dates.now()) - System has $(Sys.free_memory()/2^20)MB of memory left.";
for datei in dvec;
    mimicrun(datei,clisatroot(),["SEA","IND"]); clearclustermem();
    @info "$(Dates.now()) - System has $(Sys.free_memory()/2^20)MB of memory left.";
end
