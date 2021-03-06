using ClimateSatellite, ClimateERA, ClimateEasy
using Dates, Statistics, Logging, Dierckx
using Glob, NetCDF, NCDatasets, JLD2

global_logger(ConsoleLogger(stdout,Logging.Warn))

hdir = pwd();
init,eroot = erastartup(2,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(3,6,3,0,init);
efol = erafolder(emod,epar,ereg,eroot,"sfc"); eratmp2raw(efol);

fnc = glob("*.nc",efol["raw"])[1];

function gpmprcp(yrvec::Array,sroot::AbstractString=clisatroot())

    ybeg = yrvec[1]; yend = yrvec[end];
    dvec = collect(Date(ybeg,1,1):Day(1):Date(yend,12,31));
    inidate = Date(2016,10,1);

    gpmlnc = joinpath(gpmlfol(inidate,gpmlroot(sroot),"SEA"),gpmlncfile(inidate,"SEA"));
    lon = ncread(gpmlnc,"lon"); nlon = length(lon); mlon = convert(Array,90:0.25:165);
    lat = ncread(gpmlnc,"lat"); nlat = length(lat); mlat = convert(Array,-15:0.25:20);
    lvec = zeros(length(mlon),length(mlat),24*size(dvec,1));
    @warn mlon; @warn mlat;
    
    jj = 0;
    for datei in dvec
        @warn "$(Dates.now()) - Extracting GPM data for $(datei) ..."
        gpmlnc = joinpath(gpmlfol(datei,gpmlroot(sroot),"SEA"),gpmlncfile(datei,"SEA"));
        gpmii = reshape(ncread(gpmlnc,"prcp"),nlon,nlat,:,24); gpmii = mean(gpmii,dims=3);
        gpmii = reshape(gpmii,nlon,nlat,24)
        @warn "$(Dates.now()) - Interpolating hourly data from GPM grid to ERA grid resolution ..."
        for tt = 1 : 24
            spl = Spline2D(lon,lat,gpmii[:,:,tt]); lvec[:,:,tt+jj*24] = evalgrid(spl,mlon,mlat)
        end
        jj = jj + 1;
    end

    return lvec

end

function era5tpw(yrvec::Array,fnc::AbstractString)

    ii = 0; eratpw = [];
    for yr in yrvec; ii = ii + 1;
        fyr = replace(fnc,"1979"=>"$(yr)"); ds = Dataset(fyr);
        if ii == 1; eratpw = ds["tcwv"][:]*1;
        else; eratpw = cat(dims=3,eratpw,ds["tcwv"][:]*1);
        end
    end

    return eratpw

end

yrvec = [2017,2018]; ybeg = yrvec[1]; yend = yrvec[end];
dvec = collect(Date(ybeg,1,1):Day(1):Date(yend,12,31)); l = length(dvec);
eratpw  = era5tpw(yrvec,fnc); eratpw = reverse(eratpw,dims=2);
gpmrain = gpmprcp(yrvec,"/n/kuangdss01/users/nwong/data/");

eratpw = reshape(eratpw,:,l*24); gpmrain = reshape(gpmrain,:,l*24); cd(hdir);
npts = size(gpmrain,1); rho = zeros(npts);

for ii = 1 : npts
    eraii = eratpw[ii,:][:]; gii = gpmrain[ii,:][:]; ind = .!isnan.(gii);
    rho[ii] = cor(eraii[ind],gii[ind]);
end

rho = reshape(rho,301,141); @save "./data/SEA_ERAvGPM_rhohr.jld2" rho;

etpwdy = reshape(mean(reshape(eratpw,:,24,l),dims=2),:,l);
raindy = reshape(mean(reshape(gpmrain,:,24,l),dims=2),:,l);
npts = size(gpmrain,1); rho = zeros(npts);

for ii = 1 : npts
    eraii = etpwdy[ii,:][:]; gii = raindy[ii,:][:]; ind = .!isnan.(gii);
    rho[ii] = cor(eraii[ind],gii[ind]);
end

rho = reshape(rho,301,141); @save "./data/SEA_ERAvGPM_rhody.jld2" rho;
