using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/Islands/");
reg = matread("./data/lonlatpre.mat"); cmap = ColorMap("RdBu_r");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];

@load "./data/1x1_prcp.jld2"; m1x1prcp = mprcpRAS; s1x1prcp = sprcpRAS;
@load "./data/1x1_conv.jld2"; m1x1conv = mconvRAS; s1x1conv = sconvRAS;
@load "./data/1x1_cond.jld2"; m1x1cond = mcondRAS; s1x1cond = scondRAS;

@load "./data/control_prcp.jld2"; mconprcp = mprcpRAS; sconprcp = sprcpRAS;
@load "./data/control_conv.jld2"; mconconv = mconvRAS; sconconv = sconvRAS;
@load "./data/control_cond.jld2"; mconcond = mcondRAS; sconcond = scondRAS;

mdprcp = m1x1prcp-mconprcp; sdprcp = s1x1prcp+sconprcp;
mdconv = m1x1conv-mconconv; sdconv = s1x1conv+sconconv;
mdcond = m1x1cond-mconcond; sdcond = s1x1cond+sconcond;

close(); figure(figsize=(6,5),dpi=200); Seaborn.set()
plot(sind.(lat),mdprcp,"k",label="Total Precipitation");
fill_between(sind.(lat),mdprcp-sdprcp,mdprcp+sdprcp,color="k",alpha=0.3);
plot(sind.(lat),mdconv,"--k",label="Convective Precipitation");
fill_between(sind.(lat),mdconv-sdconv,mdconv+sdconv,color="k",alpha=0.3);
plot(sind.(lat),mdcond,":k",label="Condenstation Precipitation");
fill_between(sind.(lat),mdcond-sdcond,mdcond+sdcond,color="k",alpha=0.3);
xlim(-1,1); ylim(-5,25); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
legend(); xlabel(L"Latitude / $\degree$");
ylabel(L"Difference in $P$ (1x1 - Control) / mm day$^{-1}$");
savefig("./plots/d1c_prcp.png",bbox_inches="tight")

#########################

@load "./data/1x1_tsfc.jld2"; m1x1tsfc = mtsfcRAS;
@load "./data/1x1_temp.jld2"; m1x1temp = tempRAS;
@load "./data/control_tsfc.jld2"; mcontsfc = mtsfcRAS;
@load "./data/control_temp.jld2"; mcontemp = tempRAS;

m1x1temp = hcat(m1x1temp,m1x1tsfc.+273.15)'; mcontemp = hcat(mcontemp,mcontsfc.+273.15)';
mdtemp = m1x1temp - mcontemp;

close(); figure(figsize=(8,5),dpi=200); Seaborn.set()
c = contour(sind.(lat),vcat(pre,1000),mcontemp,colors="black",levels=160:10:310,linewidths=0.5);
clabel(c,fontsize=8,inline=1)
contourf(sind.(lat),vcat(pre,1000),mdtemp,levels=-20:20,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa"); grid("on")
title(L"Difference in $T$ (1x1 - Control) / K")
PyPlot.gca().invert_yaxis()
colorbar();
savefig("./plots/d1c_temp.png",bbox_inches="tight")

##########################

@load "./data/1x1_wind.jld2";     m1x1uwind = uwindRAS; m1x1vPsi = vPsiRAS;
@load "./data/control_wind.jld2"; mconuwind = uwindRAS; mconvPsi = vPsiRAS;
mduwind = m1x1uwind - mconuwind; mdvPsi = m1x1vPsi - mconvPsi;

close(); figure(figsize=(8,5),dpi=200); Seaborn.set()
c = contour(sind.(lat),pre,mconuwind',colors="black",levels=-60:5:60,linewidths=0.5);
clabel(c,fontsize=8,inline=1)
contourf(sind.(lat),pre,mduwind',levels=-40:2:40,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa"); grid("on")
title(L"Difference in $u$ (1x1 - Control) / m s$^{-1}$")
PyPlot.gca().invert_yaxis()
colorbar();
savefig("./plots/d1c_uwind.png",bbox_inches="tight")

close(); figure(figsize=(8,5),dpi=200); Seaborn.set()
c = contour(sind.(lat),pre,mconvPsi'/10^9,colors="black",levels=-200:50:200,linewidths=0.5);
clabel(c,fontsize=8,inline=1)
contourf(sind.(lat),pre,mdvPsi'/10^9,levels=-100:10:100,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa"); grid("on")
title(L"Difference in $\psi_v$ (1x1 - Control) / $10^9$ kg s$^{-1}$")
PyPlot.gca().invert_yaxis()
colorbar();
savefig("./plots/d1c_vPsi.png",bbox_inches="tight")
