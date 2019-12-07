using ClimateSatellite, ClimateERA, ClimateEasy
using Dates, Statistics, Logging
using Glob, NetCDF, NCDatasets, JLD2

global_logger(ConsoleLogger(stdout,Logging.Info))

function gpmprcp(coord::Array,yrvec::Array,reg::AbstractString="GLB",
                 sroot::AbstractString=clisatroot())

    ybeg = yrvec[1]; yend = yrvec[end];
    dvec = collect(Date(ybeg,1,1):Day(1):Date(yend,12,31));
    inidate = Date(2016,10,1);

    gpmlnc = joinpath(gpmlfol(inidate,gpmlroot(sroot),reg),gpmlncfile(inidate,reg));
    lon = ncread(gpmlnc,"lon"); lat = ncread(gpmlnc,"lat");
    ilon,ilat = regionpoint(coord[1],coord[2],lon,lat); lvec = zeros(48,size(dvec,1));

    jj = 0; @info "$(Dates.now()) - Extracting GPM rainfall data for [$(coord[1]),$(coord[2])] ..."
    for datei in dvec; jj = jj + 1;

        gpmlnc = joinpath(gpmlfol(datei,gpmlroot(sroot),reg),gpmlncfile(datei,reg));
        lvec[:,jj] = ncread(gpmlnc,"prcp",start=[ilon,ilat,1],count=[1,1,-1]);

    end

    return mean(reshape(lvec,:,24,size(dvec,1)),dims=1)[:]

end

function era5tpw(coord::Array,yrvec::Array,fnc::AbstractString)

    ii = 0; eratpw = []; @info "$(Dates.now()) - Extracting ERA TPW data for [$(coord[1]),$(coord[2])] ..."
    for yr in yrvec; ii = ii + 1;
        fyr = replace(fnc,"1979"=>"$(yr)"); ds = Dataset(fyr);
        lon = ncread(fnc,"longitude"); lat = ncread(fnc,"latitude");
        ilon,ilat = regionpoint(coord[1],coord[2],lon,lat);

        if ii == 1; eratpw = ds["tcwv"][ilon,ilat,:]*1;
        else; eratpw = cat(dims=3,eratpw,ds["tcwv"][ilon,ilat,:]*1);
        end
    end

    return eratpw[:]

end

function EvG(coord,evec::Array,reg::Integer,yrvec::Array)

    hdir = pwd(); rname = regionshortname(reg);
    global_logger(ConsoleLogger(stdout,Logging.Warn))
    init,eroot = erastartup(2,1,"/n/kuangdss01/users/nwong/ecmwf/");
    emod,epar,ereg,time = erainitialize(3,6,reg,0,init);
    efol = erafolder(emod,epar,ereg,eroot,"sfc"); eratmp2raw(efol);
    fnc = glob("*.nc",efol["raw"])[1]; cd(hdir);
    global_logger(ConsoleLogger(stdout,Logging.Info));

    etpw = era5tpw(coord,yrvec,fnc);
    rain = gpmprcp(coord,yrvec,rname,"/n/kuangdss01/users/nwong/data/");
    mrain = zeros(length(evec)); minfo = zeros(length(evec)); jj = 0;
    @info "$(Dates.now()) - Binning GPM rainfall rates according to ERA TPW height for [$(coord[1]),$(coord[2])] ..."
    
    estp = (evec[2]-evec[1])/2;
    for eii in evec; jj = jj + 1;
        ind = (etpw .< eii+estp) .& (etpw .>= eii-estp);
        mrain[jj] = mean(rain[ind])
        minfo[jj] = sum(rain[ind]);
    end
    
    return [mrain,minfo]

end

function EvGmap(reg::Integer,yrvec::Array,evec::Array)

    N,S,E,W = regionbounds(reg); lat = convert(Array,S:0.5:N); lon = convert(Array,W:0.5:E);
    nlat = length(lat); nlon = length(lon); netpw = length(evec);
    emap = zeros(nlon,nlat,netpw); einf = zeros(nlon,nlat,netpw);

    for ii = 1 : nlat
        for jj = 1 : nlon
            @info "$(Dates.now()) - Calculating EvG for [$(lon[jj]),$(lat[ii])] ..."
            emap[jj,ii,:],einf[jj,ii,:] = EvG([lon[jj],lat[ii]],evec,reg,yrvec)
        end
    end

    return [emap,einf]

end

function EvGmap!(emap::Array,reg::Integer,yrvec::Array,evec::Array)

    N,S,E,W = regionbounds(reg); lat = convert(Array,S:0.5:N); lon = convert(Array,W:0.5:E);
    nlat = length(lat); nlon = length(lon); netpw = length(evec);

    for ii = 2 : 2
        for jj = 2 : 2
            @info "$(Dates.now()) - Calculating EvG for [$(lon[jj]),$(lat[ii])] ..."
            emap[jj,ii,:] = EvG([lon[jj],lat[ii]],evec,reg,yrvec)
        end
    end

    return map

end

emap,einf = EvGmap(3,[2017,2018],convert(Array,10:0.5:80))
@save "./data/ERAvsGPM_Muller.jld2" emap einf
