using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/Islands/");
reg = matread("./data/lonlatpre.mat");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];

@load "./data/control_prcp.jld2" mprcpRAS sprcpRAS; con_mprcpRAS = mprcpRAS; con_sprcpRAS = sprcpRAS;
@load "./data/2x2_prcp.jld2" mprcpRAS sprcpRAS; a5_mprcpRAS = mprcpRAS; a5_sprcpRAS = sprcpRAS;

close(); figure(figsize=(10,6),dpi=200)
plot(sind.(lat),con_mprcpRAS,label="Control");
fill_between(sind.(lat),con_mprcpRAS-con_sprcpRAS,con_mprcpRAS+con_sprcpRAS,alpha=0.3);
plot(sind.(lat),a5_mprcpRAS,label="Archipelago 1x1");
fill_between(sind.(lat),a5_mprcpRAS-a5_sprcpRAS,a5_mprcpRAS+a5_sprcpRAS,alpha=0.3);
xlim(-1,1); ylim(0,30); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Precipitation / mm day$^{-1}$");
savefig("./plots/controlprcp.png",bbox_inches="tight");
gcf()
