using ClimateSatellite, ClimateEasy
using Dates, NetCDF, BenchmarkTools

function tpwprecip(dvec::Array{Date,1},sroot::AbstractString=clisatroot())
    lvec = zeros(24,size(dvec,1),2); pcoord = [101.5,1.0];

    mimicnc = joinpath(mimicfol(Date(2016,10,1),sroot,"SEA"),mimicfile(Date(2016,10,1),"SEA"));
    gpmlnc  = joinpath(gpmlfol(Date(2016,10,1),sroot,"SEA"),gpmlncfile(Date(2016,10,1),"SEA"));

    @debug "$(Dates.now()) - MIMIC NetCDF files defined at $(mimicnc)"
    @debug "$(Dates.now()) - GPM-LATE NetCDF files defined at $(gpmlnc)"

    lon_g = ncread(gpmlnc,"lon"); lon_m = ncread(mimicnc,"lon");
    lat_g = ncread(gpmlnc,"lat"); lat_m = ncread(mimicnc,"lat");
    ncclose();

    ilon_g,ilat_g = regionpoint(pcoord,lon_g,lat_g);
    ilon_m,ilat_m = regionpoint(pcoord,lon_m,lat_m);

    for datei in dvec
        mimicnc = joinpath(mimicfol(datei,sroot,"SEA"),mimicfile(datei,"SEA"));
        gpmnc   = joinpath(gpmlfol(datei,sroot,"SEA"),gpmlncfile(datei,"SEA"));
        jj = jj + 1;
        lvec[:,jj,1] = ncread(mimicnc,"tpw",start=[ilon_m,ilat_m,1],count=[1,1,-1]); ncclose();
        gpmii = ncread(gpmnc,"prcp",start=[ilon_g,ilat_g,1],count=[1,1,-1]); ncclose();
        lvec[:,jj,2] = convert2hourly(gpmii,isavg=true);
    end

    return reshape(lvec,(24*size(dvec,1),2))
end

dvec1 = collect(Date(2017,1,1):Day(1):Date(2017,1,2));
@benchmark tpwprecip(dvec1,"/n/kuangdss01/users/nwong/data/");

dvec2 = collect(Date(2017,1,1):Day(1):Date(2017,1,10));
@benchmark tpwprecip(dvec2,"/n/kuangdss01/users/nwong/data/");
