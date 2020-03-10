using JLD2, MAT
using PyCall,PyPlot

cd("/Users/natgeo-wong/Projects/JuliaClimate/Islands/");
reg = matread("./data/lonlatpre.mat"); cmap = ColorMap("RdBu_r");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];
lon = [lon;360];

@load "./data/realcont_map_prcp.jld2"; mrcprcp = mprcpRAS; srcprcp = sprcpRAS;
@load "./data/control_map_prcp.jld2";  mcnprcp = mprcpRAS; scnprcp = sprcpRAS;
@load "./data/1x1_map_prcp.jld2";      m1iprcp = mprcpRAS; s1iprcp = sprcpRAS;

@load "./data/realcont_map_tsfc.jld2"; mrctsfc = mtsfcRAS; srctsfc = stsfcRAS;
@load "./data/control_map_tsfc.jld2";  mcntsfc = mtsfcRAS; scntsfc = stsfcRAS;
@load "./data/1x1_map_tsfc.jld2";      m1itsfc = mtsfcRAS; s1itsfc = stsfcRAS;

close("all"); figure(figsize=(12,4.5),dpi=200)
ccrs = pyimport("cartopy.crs");
ax = subplot(projection=ccrs.Mollweide(central_longitude=180));

lvls = convert(Array,0:0.5:25); vmap = m1iprcp[:,:,1]-mcnprcp[:,:,1];
vmap = [vmap;vmap[1,:]'];
contourf(lon,lat,vmap',lvls,transform=ccrs.PlateCarree(),cmap="Blues");
colorbar();

#ax.coastlines()
gcf(); savefig("d1c_prcp.png",bbox_inches="tight",transparent=true)
