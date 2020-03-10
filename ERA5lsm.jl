using ClimateEasy
using NCDatasets
using Seaborn

cd("/Volumes/CliNat-ERA/");
ds = Dataset("era5-landseamask.nc");
lsm = ds["lsm"][:]*1;
lon = ds["longitude"][:]*1.0;
lat = ds["latitude"][:]*1.0;

lsm_SEA,bounds = regionextractgrid(lsm,"SEA",lon,lat)
lon,lat = bounds; nlon = length(lon); nlat = length(lat)
lsm_SEA = reshape(lsm_SEA,nlon,nlat);

close(); figure(figsize=(20,10),dpi=200)
contourf(lon,lat,transpose(lsm_SEA),levels=0:0.01:1); axis("scaled")
gcf()
