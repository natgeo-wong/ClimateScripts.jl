using ClimateSatellite, ClimateGNSS, ClimateEasy
using Dates, NetCDF, BenchmarkTools, Statistics, Logging
using PyPlot

global_logger(ConsoleLogger(stdout,Logging.Info))

function mimictpw(dvec::Array{Date,1},pcoord::AbstractArray,sroot::AbstractString=clisatroot())
    lvec = zeros(24,size(dvec,1)); inidate = Date(2016,10,1);

    mimicnc = joinpath(mimicfol(inidate,mimicroot(sroot),"SEA"),mimicfile(inidate,"SEA"));

    @debug "$(Dates.now()) - MIMIC NetCDF files defined at $(mimicnc)"
    @debug "$(Dates.now()) - GPM-LATE NetCDF files defined at $(gpmlnc)"

    lon = ncread(mimicnc,"lon"); lat = ncread(mimicnc,"lat");
    ncclose();

    ilon,ilat = regionpoint(pcoord,lon_m,lat_m);
    jj = 0;

    for datei in dvec; jj = jj + 1;
        mimicnc = joinpath(mimicfol(datei,mimicroot(sroot),"SEA"),mimicfile(datei,"SEA"));
        lvec[:,jj,1] = ncread(mimicnc,"tpw",start=[ilon,ilat,1],count=[1,1,-1]); ncclose();
    end

    return reshape(lvec,24*size(dvec,1))
end

function gnsseostpw(yvec::Array{Date,1},station::AbstractString,groot::AbstractString)

    groot = gnssroot(groot,"EOS-SG");
    gtpw = Array(Vector{Any},length(yvec)); info = eosloadstation(station);
    gfol = gnssfol(groot["data"],station); gcoord = [info[2],info[3]];

    ii = 0;
    for yr in yvec; ii = ii + 1;
        fnc = joinpath(gfol,"$(station)-$(yr).nc"); gdata = ncread(fnc,"zwd"); ncclose();
        gdata = reshape(gdata,6,24,:); gdata = mean(gdata,dims=1); gtpw[ii] = gdata[:]
    end

    gtpw = vcat(gtpw...);
    return gtpw,gcoord

end

# Run Code

stnnames = eosload("SMT")[:,1]
for stn in stnnames

    ybeg = 2017; yend = 2018;
    dvec = collect(Date(ybeg,1,1):Day(1):Date(yend,12,31)); yvec = convert(Array,ybeg:yend);
    gtpw,gcoord = gnsstpw(yvec,stn,"/n/kuangdss01/users/nwong/data/");
    mtpw = mimictpw(dvec,gcoord,"/n/kuangdss01/users/nwong/data/");
    scatter(gtpw,mtpw)
    savefig("test_$(stn).png")

end
