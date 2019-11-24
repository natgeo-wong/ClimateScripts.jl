using ClimateSatellite, ClimateGNSS, ClimateEasy
using Dates, NetCDF, BenchmarkTools, Statistics, Logging, JLD2

global_logger(ConsoleLogger(stdout,Logging.Warn))

function mimictpw(dvec::Array{Date,1},pcoord::AbstractArray,sroot::AbstractString=clisatroot())
    lvec = zeros(24,size(dvec,1)); inidate = Date(2016,10,1);

    mimicnc = joinpath(mimicfol(inidate,mimicroot(sroot),"SEA"),mimicfile(inidate,"SEA"));

    @debug "$(Dates.now()) - MIMIC NetCDF files defined at $(mimicnc)"
    @debug "$(Dates.now()) - GPM-LATE NetCDF files defined at $(gpmlnc)"

    lon = ncread(mimicnc,"lon"); lat = ncread(mimicnc,"lat");
    ncclose();

    ilon,ilat = regionpoint(pcoord[1],pcoord[2],lon,lat);
    jj = 0;

    for datei in dvec; jj = jj + 1;
        mimicnc = joinpath(mimicfol(datei,mimicroot(sroot),"SEA"),mimicfile(datei,"SEA"));
        lvec[:,jj] = ncread(mimicnc,"tpw",start=[ilon,ilat,1],count=[1,1,-1]); ncclose();
    end

    return reshape(lvec,24*size(dvec,1))
end

function gnsseostpw(yvec::AbstractArray,station::AbstractString,groot::AbstractString)

    groot = gnssroot(groot,"EOS-SG");
    gtpw = Array{Array,1}(undef,length(yvec)); info = eosloadstation(station);
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
    
    @warn "$(Dates.now()) - Retrieving data for the $(stn) GNSS station."
    try
        ybeg = 2017; dvec = collect(Date(ybeg,1,1):Day(1):Date(ybeg,12,31)); yvec = convert(Array,ybeg:ybeg);
    	gtpw,gcoord = gnsseostpw(yvec,stn,"/n/kuangdss01/users/nwong/data/");
    	mtpw = mimictpw(dvec,gcoord,"/n/kuangdss01/users/nwong/data/");
    	@save "$(stn)_MIMICvsGNSS.jld2" gtpw mtpw;
    catch
	@warn "$(Dates.now()) - There is no available data for the $(stn) GNSS station in $(ybeg)."
    end
end
