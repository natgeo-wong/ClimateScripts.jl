using ClimateSatellite, ClimateERA, ClimateEasy
using Dates, Statistics, Logging
using Glob, NetCDF, NCDatasets, JLD2

global_logger(ConsoleLogger(stdout,Logging.Warn))

hdir = pwd();
init,eroot = erastartup(2,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(3,6,3,0,init);
efol = erafolder(emod,epar,ereg,eroot,"sfc"); eratmp2raw(efol);

fnc = glob("*.nc",efol["raw"])[1];

function mimictpw(yrvec::Array,sroot::AbstractString=clisatroot())

    ybeg = yrvec[1]; yend = yrvec[end];
    dvec = collect(Date(ybeg,1,1):Day(1):Date(yend,12,31));
    inidate = Date(2016,10,1);

    mimicnc = joinpath(mimicfol(inidate,mimicroot(sroot),"SEA"),mimicfile(inidate,"SEA"));

    @debug "$(Dates.now()) - MIMIC NetCDF files defined at $(mimicnc)"
    @debug "$(Dates.now()) - GPM-LATE NetCDF files defined at $(gpmlnc)"

    lon = ncread(mimicnc,"lon"); nlon = length(lon);
    lat = ncread(mimicnc,"lat"); nlat = length(lat);
    lvec = zeros(nlon,nlat,24,size(dvec,1));

    jj = 0;
    for datei in dvec; jj = jj + 1;
        @warn "Extracting MIMIC data for $(datei) ..."
        mimicnc = joinpath(mimicfol(datei,mimicroot(sroot),"SEA"),mimicfile(datei,"SEA"));
        lvec[:,:,:,jj] = ncread(mimicnc,"tpw");
    end

    return reshape(lvec,nlon,nlat,24*size(dvec,1))

end

function era5tpw(yrvec::Array,fnc::AbstractString)

    ii = 0; eratpw = [];
    for yr in yrvec; ii = ii + 1;
        @warn "Extracting ERA5 Total Column Water Vapour data for $(yr) ..."
        fyr = replace(fnc,"1979"=>"$(yr)"); ds = Dataset(fyr);
        if ii == 1; eratpw = ds["tcwv"][:]*1;
        else; eratpw = cat(dims=3,eratpw,ds["tcwv"][:]*1);
        end
    end

    return eratpw

end

yrvec = [2017,2018]; ybeg = yrvec[1]; yend = yrvec[end];
dvec = collect(Date(ybeg,1,1):Day(1):Date(yend,12,31)); l = length(dvec);
eratpw = era5tpw(yrvec,fnc);
mtpw = mimictpw(yrvec,"/n/kuangdss01/users/nwong/data/");

eratpw = reshape(eratpw,:,l*24); mtpw = reshape(mtpw,:,l*24); cd(hdir);
@save "test.jld2" eratpw mtpw;
npts = size(mtpw,1); rho = zeros(npts);

for ii = 1 : npts
    eraii = eratpw[ii,:][:]; mii = mtpw[ii,:][:]; ind = .!isnan.(mii);
    rho[ii] = cor(eraii[ind],mii[ind]);
end

rho = reshape(rho,nlon,nlat); @save "./data/SEA_rho.jld2" rho;
