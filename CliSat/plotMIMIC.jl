using ClimateSatellite, ClimateEasy
using Dates, NetCDF
using PyPlot, PyCall

dt = Date(2019,10,1);
mimicnc = joinpath(mimicfol(dt,mimicroot(clisatroot())),mimicfile(dt));
lon = ncread(mimicnc,"lon"); lat = ncread(mimicnc,"lat"); tpw = ncread(mimicnc,"tpw"); ncclose();
tpw = cat(tpw,reshape(tpw[1,:,:],1,721,24),dims=1);
tpw = permutedims(tpw,[2,1,3]); append!(lon,lon[1]+360);

close("all")
figure(figsize=(18,7),dpi=300)
ccrs = pyimport("cartopy.crs");
ax = subplot(projection=ccrs.Mollweide(central_longitude=115));
ax.set_global()

lvls = convert(Array,0:5:80);
contourf(lon,lat,tpw[:,:,10],lvls,transform=ccrs.PlateCarree())
cbar = colorbar(); cbar.ax.set_ylabel("Precipitable Water / mm")
ax.coastlines(resolution="50m");
gcf()
savefig("/Users/natgeo-wong/Dropbox/NatLujia/AGU2019/MIMIC.png",transparent=true)
