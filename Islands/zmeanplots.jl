using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/Islands/");
reg = matread("./data/lonlatpre.mat");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];

@load "./data/5x5_prcp.jld2"

close(); figure(figsize=(10,6),dpi=200)
plot(sind.(lat),mprcpRAS,label="Relaxed Arakawa-Schubert");
fill_between(sind.(lat),mprcpRAS-sprcpRAS,mprcpRAS+sprcpRAS,alpha=0.3);
plot(sind.(lat),mprcpQEB,label="Quasi-Equilibrium Betts-Miller");
fill_between(sind.(lat),mprcpQEB-sprcpQEB,mprcpQEB+sprcpQEB,alpha=0.3);
xlim(-1,1); ylim(0,10); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Precipitation / mm day$^{-1}$");
savefig("./plots/5x5_prcp.png",bbox_inches="tight")

@load "./data/5x5_conv.jld2"

mconvRAS = mconvRAS*24*3600; sconvRAS = sconvRAS*24*3600;
mconvQEB = mconvQEB*24*3600; sconvQEB = sconvQEB*24*3600;

close(); figure(figsize=(10,6),dpi=200)
plot(sind.(lat),mconvRAS,label="Relaxed Arakawa-Schubert");
fill_between(sind.(lat),mconvRAS-sconvRAS,mconvRAS+sconvRAS,alpha=0.3);
plot(sind.(lat),mconvQEB,label="Quasi-Equilibrium Betts-Miller");
fill_between(sind.(lat),mconvQEB-sconvQEB,mconvQEB+sconvQEB,alpha=0.3);
xlim(-1,1); ylim(0,10); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Convection Precipitation / mm day$^{-1}$");
savefig("./plots/5x5_conv.png",bbox_inches="tight")

@load "./data/5x5_cond.jld2"

mcondRAS = mcondRAS*24*3600; scondRAS = scondRAS*24*3600;
mcondQEB = mcondQEB*24*3600; scondQEB = scondQEB*24*3600;

close(); figure(figsize=(10,6),dpi=200)
plot(sind.(lat),mcondRAS,label="Relaxed Arakawa-Schubert");
fill_between(sind.(lat),mcondRAS-scondRAS,mcondRAS+scondRAS,alpha=0.3);
plot(sind.(lat),mcondQEB,label="Quasi-Equilibrium Betts-Miller");
fill_between(sind.(lat),mcondQEB-scondQEB,mcondQEB+scondQEB,alpha=0.3);
xlim(-1,1); ylim(0,10); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Condensation Precipitation / mm day$^{-1}$");
savefig("./plots/5x5_cond.png",bbox_inches="tight")

@load "./data/5x5_temp.jld2"

close(); figure(figsize=(10,6),dpi=200)
plot(sind.(lat),mtempRAS,label="Relaxed Arakawa-Schubert");
fill_between(sind.(lat),mtempRAS-stempRAS,mtempRAS+stempRAS,alpha=0.3);
plot(sind.(lat),mtempQEB,label="Quasi-Equilibrium Betts-Miller");
fill_between(sind.(lat),mtempQEB-stempQEB,mtempQEB+stempQEB,alpha=0.3);
xlim(-1,1); ylim(-50,30); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$"); ylabel(L"Temperature / $\degree$C");
savefig("./plots/5x5_temp.png",bbox_inches="tight")

@load "./data/5x5_wind.jld2"

close(); figure(figsize=(10,6),dpi=200); cmap = ColorMap("RdBu_r")
contourf(sind.(lat),pre,uwindRAS',levels=-60:5:60,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa");
title("Relaxed Arakawa-Schubert")
colorbar();
PyPlot.gca().invert_yaxis()
savefig("./plots/5x5_uwind_RAS.png",bbox_inches="tight")

close(); figure(figsize=(10,6),dpi=200)
contourf(sind.(lat),pre,uwindQEB',levels=-60:5:60,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa");
title("Quasi-Equilibrium Betts-Miller")
colorbar();
PyPlot.gca().invert_yaxis()
savefig("./plots/5x5_uwind_QEB.png",bbox_inches="tight")

close(); figure(figsize=(10,6),dpi=200)
contourf(sind.(lat),pre,vPsiRAS'/(10^9),levels=-300:25:300,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa");
title("Relaxed Arakawa-Schubert")
colorbar();
PyPlot.gca().invert_yaxis()
savefig("./plots/5x5_vPsi_RAS.png",bbox_inches="tight")

close(); figure(figsize=(10,6),dpi=200)
contourf(sind.(lat),pre,vPsiQEB'/(10^9),levels=-300:25:300,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa");
title("Quasi-Equilibrium Betts-Miller")
colorbar();
PyPlot.gca().invert_yaxis()
savefig("./plots/5x5_vPsi_QEB.png",bbox_inches="tight")
