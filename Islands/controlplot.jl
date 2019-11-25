using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/Islands/");

@load "./data/controlprcp.jld2"

close(); figure(figsize=(10,6),dpi=200)
plot(sind.(lat),mprcpRAS,label="Relaxed Arakawa-Schubert");
fill_between(sind.(lat),mprcpRAS-sprcpRAS,mprcpRAS+sprcpRAS,alpha=0.3);
plot(sind.(lat),mprcpQEB,label="Quasi-Equilibrium Betts-Miller");
fill_between(sind.(lat),mprcpQEB-sprcpQEB,mprcpQEB+sprcpQEB,alpha=0.3);
xlim(-1,1); ylim(0,10); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Precipitation / mm day$^{-1}$");
savefig("./plots/controlprcp.png",bbox_inches="tight")

@load "./data/controltemp.jld2"

close(); figure(figsize=(10,6),dpi=200)
plot(sind.(lat),mtempRAS,label="Relaxed Arakawa-Schubert");
fill_between(sind.(lat),mtempRAS-stempRAS,mtempRAS+stempRAS,alpha=0.3);
plot(sind.(lat),mtempQEB,label="Quasi-Equilibrium Betts-Miller");
fill_between(sind.(lat),mtempQEB-stempQEB,mtempQEB+stempQEB,alpha=0.3);
xlim(-1,1); ylim(-50,30); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Temperature / $\degree$C");
savefig("./plots/controltemp.png",bbox_inches="tight")

@load "./data/controluwind.jld2"
reg = matread("./data/lonlatpre.mat");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];

close(); figure(figsize=(10,6),dpi=200); cmap = ColorMap("RdBu_r")
contourf(sind.(lat),pre,uwindRAS',levels=-40:5:40,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa");
title("Relaxed Arakawa-Schubert")
colorbar();
PyPlot.gca().invert_yaxis()
savefig("./plots/controluwind_RAS.png",bbox_inches="tight")

close(); figure(figsize=(10,6),dpi=200)
contourf(sind.(lat),pre,uwindQEB',levels=-40:5:40,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa");
title("Quasi-Equilibrium Betts-Miller")
colorbar();
PyPlot.gca().invert_yaxis()
savefig("./plots/controluwind_QEB.png",bbox_inches="tight")
