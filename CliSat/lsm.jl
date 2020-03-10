using ClimateEasy
using NCDatasets, JLD2
using Seaborn

global_logger(ConsoleLogger(stderr,Logging.Info))
cd("/Volumes/CliNat-ERA/");
ds = Dataset("era5-landseamask.nc");
lsm = ds["lsm"][:]*1; lsm_reg = lsm;
global lon = ds["longitude"][:]*1.0; global lat = ds["latitude"][:]*1.0;
#nlon = length(lon); nlat = length(lat);

#lsm_reg,bounds = regionextractgrid(lsm,"SEA",lon,lat)
#lon,lat = bounds; nlon = length(lon); nlat = length(lat);

#nnlat = length(1:2:nlat); nnlon = length(1:2:nlon);
#newlat = lat[1:2:nlat]; newlon = lon[1:2:nlon];
newlon = convert(Array,range(0,stop=360,length=257)); pop!(newlon);
newlat = convert(Array,range(-90,stop=90,length=257)); newlat = newlat[2:2:256];
nnlon = length(newlon); nnlat = length(newlat);
lsm_new = zeros(nnlon,nnlat); lsgrid = zeros(nnlon,nnlat);

global ii = 0;
for inewlat in newlat; global ii = ii + 1; global jj = 0;
    for inewlon in newlon; jj = jj + 1;

        ilon,ilat = regionpoint(inewlon,inewlat,lon,lat)

        lsm_new[jj,ii] = lsm_reg[ilon,ilat]*1; lsgrid[jj,ii] = 1;
        try
            lsm_new[jj,ii] += lsm_reg[ilon-1,ilat]*0.5;
            lsgrid[jj,ii] += 0.5
        catch
        end
        try
            lsm_new[jj,ii] += lsm_reg[ilon+1,ilat]*0.5;
            lsgrid[jj,ii] += 0.5
        catch
        end
        try
            lsm_new[jj,ii] += lsm_reg[ilon,ilat+1]*0.5;
            lsgrid[jj,ii] += 0.5
        catch
        end
        try
            lsm_new[jj,ii] += lsm_reg[ilon,ilat-1]*0.5;
            lsgrid[jj,ii] += 0.5
        catch
        end
        try
            lsm_new[jj,ii] += lsm_reg[ilon-1,ilat-1]*0.25;
            lsgrid[jj,ii] += 0.25
        catch
        end
        try
            lsm_new[jj,ii] += lsm_reg[ilon-1,ilat+1]*0.25;
            lsgrid[jj,ii] += 0.25
        catch
        end
        try
            lsm_new[jj,ii] += lsm_reg[ilon+1,ilat-1]*0.25;
            lsgrid[jj,ii] += 0.25
        catch
        end
        try
            lsm_new[jj,ii] += lsm_reg[ilon+1,ilat+1]*0.25;
            lsgrid[jj,ii] += 0.25
        catch
        end

    end
end

lthr = 0.3; uthr = 0.3; lsm = lsm_new ./ lsgrid; lsm_new = zeros(nnlon,nnlat);
lsm_new[lsm.>=lthr] .= lsm_new[lsm.>=lthr] .+ 0.5;
lsm_new[lsm.>=uthr] .= lsm_new[lsm.>=uthr] .+ 0.5;
lsm = convert(Array,lsm_new);

close(); figure(figsize=(10,5),dpi=300);
contourf(newlon,newlat,transpose(lsm_new)); gcf()

lon = newlon; lat = newlat; oro = zeros(256,128); nlon = length(lon); nlat = length(lat);
cd("/Users/natgeo-wong/Projects/JuliaClimate/CliSat/")
@save "./data/GLB_T85.jld2" lon lat lsm;

fnc = "T85_realcont.nc";
if isfile(fnc)
    @info "$(Dates.now()) - Unfinished netCDF file $(fnc) detected.  Deleting."
    rm(fnc);
end

var_lsm = "land_mask"; att_lsm = Dict("units" => "N/A");
var_oro = "zsurf";     att_oro = Dict("units" => "N/A");
var_lon = "lon";       att_lon = Dict("units" => "degree");
var_lat = "lat";       att_lat = Dict("units" => "degree");

nccreate(fnc,var_lsm,"nlon",nlon,"nlat",nlat,atts=att_lsm,t=NC_FLOAT);
nccreate(fnc,var_oro,"nlon",nlon,"nlat",nlat,atts=att_oro,t=NC_FLOAT);
nccreate(fnc,var_lon,"nlon",nlon,atts=att_lon,t=NC_FLOAT);
nccreate(fnc,var_lat,"nlat",nlat,atts=att_lat,t=NC_FLOAT);

ncwrite(lsm,fnc,var_lsm);
ncwrite(oro,fnc,var_oro);
ncwrite(lon,fnc,var_lon);
ncwrite(lat,fnc,var_lat);
