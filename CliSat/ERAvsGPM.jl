using ClimateSatellite, ClimateERA, ClimateEasy
using Dates, Statistics, Logging, Dierckx
using Glob, NetCDF, NCDatasets, JLD2

global_logger(ConsoleLogger(stdout,Logging.Warn))

function gpmprcp(coord::Array,yrvec::Array,reg::AbstractString="GLB",
                 sroot::AbstractString=clisatroot())

    ybeg = yrvec[1]; yend = yrvec[end];
    dvec = collect(Date(ybeg,1,1):Day(1):Date(yend,12,31));
    inidate = Date(2016,10,1);

    gpmlnc = joinpath(gpmlfol(inidate,gpmlroot(sroot),reg),gpmlncfile(inidate,reg));
    lon = ncread(gpmlnc,"lon"); lat = ncread(gpmlnc,"lat");
    ilon,ilat = regionpoint(coord,lon,lat); lvec = zeros(48,size(dvec,1));

    jj = 0;
    for datei in dvec; jj = jj + 1;

        @warn "$(Dates.now()) - Extracting GPM data for $(datei) ..."
        gpmlnc = joinpath(gpmlfol(datei,gpmlroot(sroot),reg),gpmlncfile(datei,reg));
        lvec[:,jj] = ncread(gpmlnc,"prcp",start=[ilon,ilat,1],count=[1,1,-1]);

    end

    return mean(reshape(lvec,:,24,size(dvec,1)),dims=1)[:]

end

function era5tpw(coord::Array,yrvec::Array,fnc::AbstractString)

    ii = 0; eratpw = [];
    for yr in yrvec; ii = ii + 1;
        fyr = replace(fnc,"1979"=>"$(yr)"); ds = Dataset(fyr);
        lon = ncread(fnc,"longitude"); lat = ncread(fnc,"latitude");
        ilon,ilat = regionpoint(coord,lon,lat);

        if ii == 1; eratpw = ds["tcwv"][ilon,ilat,:]*1;
        else; eratpw = cat(dims=3,eratpw,ds["tcwv"][ilon,ilat,:]*1);
        end
    end

    return eratpw[:]

end

function EvG(coord,evec::Array,reg::Integer,yrvec::Array)

    hdir = pwd(); rname = regionshortname(reg);
    init,eroot = erastartup(2,1,"/n/kuangdss01/users/nwong/ecmwf/");
    emod,epar,ereg,time = erainitialize(3,6,reg,0,init);
    efol = erafolder(emod,epar,ereg,eroot,"sfc"); eratmp2raw(efol);

    fnc = glob("*.nc",efol["raw"])[1]; cd(hdir);

    etpw = era5tpw(coord,yrvec,fnc); rain = gpmprcp(coord,yrvec,rname);
    erange = 10:80; mrain = zeros(length(erange)); jj = 0;

    for eii in erange; jj = jj + 1;
        ind = (etpw .< eii+0.5) & (etpw .>= eii-0.5)
        mrain[jj] = mean(rain[ind])
    end

    return mrain

end

function EvGmap(reg::Integer,yrvec::Array,evec::Array)

    N,S,E,W = regionbounds(reg); lat = convert(Array,S:0.5:N); lon = convert(Array,W:0.5:E);
    nlat = length(lat); nlon = length(lon); netpw = length(evec); map = zeros(nlon,nlat,netpw);

    for ii = 1 : nlat
        for jj = 1 : nlon
            map[jj,ii,:] = EvG([lon[jj],lat[ii]],evec,reg,yrvec)
        end
    end

    return map

end

map = EvGmap(3,[2017,2018],convert(Array,10:80))
