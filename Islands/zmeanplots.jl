using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Projects/JuliaClimate/Islands/");
reg = matread("./data/lonlatpre.mat"); cmap = ColorMap("RdBu_r");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];

@load "./data/realcont_prcp.jld2"; mrcprcp = mprcpRAS; srcprcp = sprcpRAS;
@load "./data/realcont_conv.jld2"; mrcconv = mconvRAS; srcconv = sconvRAS;
@load "./data/realcont_cond.jld2"; mrccond = mcondRAS; srccond = scondRAS;

@load "./data/control_prcp.jld2"; mconprcp = mprcpRAS; sconprcp = sprcpRAS;
@load "./data/control_conv.jld2"; mconconv = mconvRAS; sconconv = sconvRAS;
@load "./data/control_cond.jld2"; mconcond = mcondRAS; sconcond = scondRAS;

mdprcp = mrcprcp-mconprcp; sdprcp = srcprcp+sconprcp;
mdconv = mrcconv-mconconv; sdconv = srcconv+sconconv;
mdcond = mrccond-mconcond; sdcond = srccond+sconcond;

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
ylabel(L"Difference in $P$ (rc - Control) / mm day$^{-1}$");
savefig("./plots/drc_0qflux_prcp.png",bbox_inches="tight")

#########################

@load "./data/realcont_tsfc.jld2"; mrctsfc = mtsfcRAS;
@load "./data/realcont_temp.jld2"; mrctemp = tempRAS;
@load "./data/control_tsfc.jld2"; mcontsfc = mtsfcRAS;
@load "./data/control_temp.jld2"; mcontemp = tempRAS;

mrctemp = hcat(mrctemp,mrctsfc.+273.15)'; mcontemp = hcat(mcontemp,mcontsfc.+273.15)';
mdtemp = mrctemp - mcontemp;

close(); figure(figsize=(8,5),dpi=200); Seaborn.set()
c = contour(sind.(lat),vcat(pre,1000),mcontemp,colors="black",levels=160:10:310,linewidths=0.5);
clabel(c,fontsize=8,inline=1)
contourf(sind.(lat),vcat(pre,1000),mdtemp,levels=-20:20,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa"); grid("on")
title(L"Difference in $T$ (rc - Control) / K")
PyPlot.gca().invert_yaxis()
colorbar();
savefig("./plots/drc_0qflux_temp.png",bbox_inches="tight")

##########################

@load "./data/realcont_wind.jld2";     mrcuwind = uwindRAS; mrcvPsi = vPsiRAS;
@load "./data/control_wind.jld2"; mconuwind = uwindRAS; mconvPsi = vPsiRAS;
mduwind = mrcuwind - mconuwind; mdvPsi = mrcvPsi - mconvPsi;

close(); figure(figsize=(8,5),dpi=200); Seaborn.set()
c = contour(sind.(lat),pre,mconuwind',colors="black",levels=-60:5:60,linewidths=0.5);
clabel(c,fontsize=8,inline=1)
contourf(sind.(lat),pre,mduwind',levels=-40:2:40,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa"); grid("on")
title(L"Difference in $u$ (rc - Control) / m s$^{-1}$")
PyPlot.gca().invert_yaxis()
colorbar();
savefig("./plots/drc_0qflux_uwind.png",bbox_inches="tight")

close(); figure(figsize=(8,5),dpi=200); Seaborn.set()
c = contour(sind.(lat),pre,mconvPsi'/10^9,colors="black",levels=-200:50:200,linewidths=0.5);
clabel(c,fontsize=8,inline=1)
contourf(sind.(lat),pre,mdvPsi'/10^9,levels=-100:10:100,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa"); grid("on")
title(L"Difference in $\psi_v$ (rc - Control) / $10^9$ kg s$^{-1}$")
PyPlot.gca().invert_yaxis()
colorbar();
savefig("./plots/drc_0qflux_vPsi.png",bbox_inches="tight")

close(); figure(figsize=(8,5),dpi=200); Seaborn.set()
c = contourf(sind.(lat),pre,mrcvPsi'/10^9,levels=-400:20:400,cmap=cmap);
xlim(-1,1); ylim(0,1000); grid("on")
xticks([-1,-sind(60),-sind(45),-sind(30),-sind(15),0,sind(15),sind(30),sind(45),sind(60),1],
       ["-90","-60","-45","-30","-15","0","15","30","45","60","90"]);
xlabel(L"Latitude / $\degree$"); ylabel("Pressure / hPa"); grid("on")
title(L"Difference in $\psi_v$ (rc - Control) / $10^9$ kg s$^{-1}$")
PyPlot.gca().invert_yaxis()
colorbar();
savefig("./plots/rc_0qflux_vPsi.png",bbox_inches="tight")
