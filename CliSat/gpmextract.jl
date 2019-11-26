using ClimateSatellite, ClimateEasy
using Dates, NetCDF, BenchmarkTools, Statistics, Logging

global_logger(ConsoleLogger(stderr,Logging.Warn))

function gpmpoint(dvec::Array{Date,1},sroot::AbstractString=clisatroot())
    lvec = zeros(24,size(dvec,1)); pcoord = [101.5,1.0];
    inidate = Date(2001,01,1);

    gpmlnc  = joinpath(gpmlfol(inidate,gpmlroot(sroot),"SEA"),gpmlncfile(inidate,"SEA"));

    @debug "$(Dates.now()) - GPM-LATE NetCDF files defined at $(gpmlnc)"

    lon = ncread(gpmlnc,"lon"); lat = ncread(gpmlnc,"lat");
    ncclose();

    ilon,ilat = regionpoint(pcoord,lon,lat); jj = 0;

    for datei in dvec; jj = jj + 1;
        gpmnc   = joinpath(gpmlfol(datei,gpmlroot(sroot),"SEA"),gpmlncfile(datei,"SEA"));
        gpmii = ncread(gpmnc,"prcp",start=[ilon,ilat,1],count=[1,1,-1]);
        lvec[:,jj] = convert2hourly(gpmii,true);
    end

    return reshape(lvec,(24*size(dvec,1),2))
end

function gpmmap(year::Integer,sroot::AbstractString=clisatroot())

    inidate = Date(2001,01,1);
    gpmlnc = joinpath(gpmlfol(inidate,gpmlroot(sroot),"SEA"),gpmlncfile(inidate,"SEA"));

    lon = ncread(gpmlnc,"lon"); nlon = length(lon);
    lat = ncread(gpmlnc,"lat"); nlat = length(lat);
    dvec = collect(Date(year,1,1):Day(1):Date(year,12,31)); ndt = length(dvec);
    lmat = zeros(nlon,nlat,48,ndt);

    for datei in dvec; jj = jj + 1;
        gpmnc = joinpath(gpmlfol(datei,gpmlroot(sroot),"SEA"),gpmlncfile(datei,"SEA"));
        lmat[:,:,:,jj] = ncread(gpmnc,"prcp");
    end

    return lmat
    
end

dvec = collect(Date(2001,1,1):Day(1):Date(2018,12,31));
lvec = gpmpoint(dvec,"/n/kuangdss01/users/nwong/data/");
