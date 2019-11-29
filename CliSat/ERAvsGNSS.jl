using ClimateERA, ClimateGNSS, ClimateEasy
using Dates, Statistics, Logging
using NCDatasets, NetCDF, JLD2, Glob

global_logger(ConsoleLogger(stdout,Logging.Warn))

hdir = pwd();
init,eroot = erastartup(2,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(3,6,3,0,init);
efol = erafolder(emod,epar,ereg,eroot,"sfc"); eratmp2raw(efol);
cd(hdir);

fnc = glob("*.nc",efol["raw"])[1]; ds = Dataset(fnc);
lon = ds["longitude"][:]; lat = ds["latitude"][:];


function era5tpw(yrvec::Array,gcoord::Array,fnc::AbstractString,lon::Array,lat::Array)

    ilon,ilat = regionpoint(gcoord[1],gcoord[2],lon,lat);
    ii = 0; eratpw = [];
    for yr in yrvec; ii = ii + 1;
        @warn "Extracting ERA5 Total Column Water Vapour data for $(yr) ..."
        fyr = replace(fnc,"1979"=>"$(yr)"); ds = Dataset(fyr);
        if ii == 1; eratpw = ds["tcwv"][ilon,ilat,:]*1;
        else; eratpw = cat(dims=3,eratpw,ds["tcwv"][ilon,ilat,:]*1);
        end
    end

    return eratpw[:]

end

function gnsseostpw(yvec::AbstractArray,station::AbstractString,groot::AbstractString)

    groot = gnssroot(groot,"EOS-SG");
    gtpw = Array{Array,1}(undef,length(yvec)); info = eosloadstation(station);
    gfol = gnssfol(groot["data"],station); gcoord = [info[2],info[3]];

    ii = 0;
    for yr in yvec; ii = ii + 1;
        fnc = joinpath(gfol,"$(station)-$(yr).nc");
	    if isfile(fnc)
                  gdata = ncread(fnc,"zwd");
		  gdata = reshape(gdata,6,24,:); gdata = mean(gdata,dims=1); gtpw[ii] = gdata[:]
	    else; gtpw[ii] = ones(Dates.daysinyear(yr))
        end
    end

    gtpw = vcat(gtpw...); return gtpw,gcoord

end

# Run Code

stnnames = eosload("SMT")[:,1]
for stn in stnnames

    @warn "$(Dates.now()) - Retrieving data for the $(stn) GNSS station."
    ybeg = 2017; yend = 2017;
    yvec = convert(Array,ybeg:yend);
    gtpw,gcoord = gnsseostpw(yvec,stn,"/n/kuangdss01/users/nwong/data/");
    etpw = era5tpw(yvec,gcoord,fnc,lon,lat);
    @save "./data/$(stn)_ERAvsGNSS.jld2" gtpw etpw;
    
end
