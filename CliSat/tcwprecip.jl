using ClimateSatellite, ClimateEasy
using Dates, NetCDF, BenchmarkTools, Statistics, Logging

global_logger(ConsoleLogger(stderr,Logging.Warn))

function tpwprecip(dvec::Array{Date,1},sroot::AbstractString=clisatroot())
    lvec = zeros(24,size(dvec,1),2); pcoord = [101.5,1.0];
    inidate = Date(2016,10,1);

    mimicnc = joinpath(mimicfol(inidate,mimicroot(sroot),"SEA"),mimicfile(inidate,"SEA"));
    gpmlnc  = joinpath(gpmlfol(inidate,gpmlroot(sroot),"SEA"),gpmlncfile(inidate,"SEA"));

    @debug "$(Dates.now()) - MIMIC NetCDF files defined at $(mimicnc)"
    @debug "$(Dates.now()) - GPM-LATE NetCDF files defined at $(gpmlnc)"

    lon_g = ncread(gpmlnc,"lon"); lon_m = ncread(mimicnc,"lon");
    lat_g = ncread(gpmlnc,"lat"); lat_m = ncread(mimicnc,"lat");
    ncclose();

    ilon_g,ilat_g = regionpoint(pcoord,lon_g,lat_g);
    ilon_m,ilat_m = regionpoint(pcoord,lon_m,lat_m);
    jj = 0;

    for datei in dvec
        mimicnc = joinpath(mimicfol(datei,mimicroot(sroot),"SEA"),mimicfile(datei,"SEA"));
        gpmnc   = joinpath(gpmlfol(datei,gpmlroot(sroot),"SEA"),gpmlncfile(datei,"SEA"));
        jj = jj + 1;
        lvec[:,jj,1] = ncread(mimicnc,"tpw",start=[ilon_m,ilat_m,1],count=[1,1,-1]); ncclose();
        gpmii = ncread(gpmnc,"prcp",start=[ilon_g,ilat_g,1],count=[1,1,-1]); ncclose();
        lvec[:,jj,2] = convert2hourly(gpmii,true);
    end

    return reshape(lvec,(24*size(dvec,1),2))
end

dvec = collect(Date(2017,1,1):Day(1):Date(2018,12,31));
lvec = tpwprecip(dvec,"/n/kuangdss01/users/nwong/data/");
