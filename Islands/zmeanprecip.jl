using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/Islands/");
reg = matread("./data/lonlatpre.mat"); cmap = ColorMap("RdBu_r");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];

close(); figure(figsize=(6,5),dpi=200); Seaborn.set()

@load "./data/control_prcp.jld2"
plot(sind.(lat),mprcpRAS,"k",label="Control");
fill_between(sind.(lat),mprcpRAS-sprcpRAS,mprcpRAS+sprcpRAS,color="k",alpha=0.3);

@load "./data/1x1_prcp.jld2"
plot(sind.(lat),mprcpRAS,"w",label="Single Island");
fill_between(sind.(lat),mprcpRAS-sprcpRAS,mprcpRAS+sprcpRAS,color="w",alpha=0.3);

@load "./data/2x2_prcp.jld2"
plot(sind.(lat),mprcpRAS,"y",label="2x2 Archipelago");

@load "./data/3x3_prcp.jld2"
plot(sind.(lat),mprcpRAS,"m",label="3x3 Archipelago");

@load "./data/5x5_prcp.jld2"
plot(sind.(lat),mprcpRAS,"r",label="5x5 Archipelago");
fill_between(sind.(lat),mprcpRAS-sprcpRAS,mprcpRAS+sprcpRAS,color="r",alpha=0.3);

@load "./data/csmall_prcp.jld2"
plot(sind.(lat),mprcpRAS,"b",label="Small Continent");

@load "./data/cmed_prcp.jld2"
plot(sind.(lat),mprcpRAS,"c",label="Medium Continent");

@load "./data/clarge_prcp.jld2"
plot(sind.(lat),mprcpRAS,"g",label="Large Continent");
fill_between(sind.(lat),mprcpRAS-sprcpRAS,mprcpRAS+sprcpRAS,color="g",alpha=0.3);

xlim(-1,1); ylim(0,30); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Total Precipitation / mm day$^{-1}$");
savefig("./plots/precip.png",bbox_inches="tight")
