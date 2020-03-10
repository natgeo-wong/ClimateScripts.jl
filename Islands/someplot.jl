using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Projects/JuliaClimate/Islands/");
reg = matread("./data/lonlatpre.mat");
lon = reg["lon"][:]; lat = reg["lat"][:];

@load "./data/seasonal_map_prcp.jld2"; seam = mprcpRAS[:,:,1]; seas = sprcpRAS;
@load "./data/control_map_prcp.jld2";  conm = mprcpRAS[:,:,1]; cons = sprcpRAS;

close(); figure(figsize=(10,6),dpi=200);
contourf(lon,lat,seam'-conm'); colorbar();
axis("scaled"); gcf();
