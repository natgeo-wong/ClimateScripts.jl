using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/Islands/");
reg = matread("./data/lonlatpre.mat"); cmap = ColorMap("RdBu_r");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];
nlon = length(lon); nlat = length(lat);

@load "./data/1x1_zasym_prcp.jld2";     m1x1prcp = mprcpRAS; s1x1prcp = sprcpRAS;
@load "./data/control_zasym_prcp.jld2";
mconprcp = mean(mprcpRAS); sconprcp = mean(sprcpRAS)/sqrt(nlon);

mdprcp = m1x1prcp.-(mconprcp); mdprcp = mdprcp .- mean(mdprcp); sdprcp = s1x1prcp.+sconprcp;

close(); figure(figsize=(12,4),dpi=200); Seaborn.set()
plot(lon,mdprcp,"k",label="Total Precipitation");
plot([178,178],[-2,2],":k")
plot([182,182],[-2,2],":k")
fill_between(lon,mdprcp[:]-sdprcp[:],mdprcp[:]+sdprcp[:],color="k",alpha=0.3);
xlim(0,360); ylim(-2,2); grid("on")
legend(); xlabel(L"Longitude / $\degree$");
ylabel(L"Equatorial $P$ Variability (1x1) / mm day$^{-1}$");
savefig("./plots/d1c_zasym_prcp.png",bbox_inches="tight")

#########################################

@load "./data/2x2_zasym_prcp.jld2";     m2x2prcp = mprcpRAS; s2x2prcp = sprcpRAS;
@load "./data/control_zasym_prcp.jld2";
mconprcp = mean(mprcpRAS); sconprcp = mean(sprcpRAS)/sqrt(nlon);

mdprcp = m2x2prcp.-(mconprcp); mdprcp = mdprcp .- mean(mdprcp); sdprcp = s2x2prcp.+sconprcp;

close(); figure(figsize=(12,4),dpi=200); Seaborn.set()
plot(lon,mdprcp,"k",label="Total Precipitation");
plot([175,175],[-2,2],":k")
plot([179,179],[-2,2],":k")
plot([181,181],[-2,2],":k")
plot([185,185],[-2,2],":k")
fill_between(lon,mdprcp[:]-sdprcp[:],mdprcp[:]+sdprcp[:],color="k",alpha=0.3);
xlim(0,360); ylim(-2,2); grid("on")
legend(); xlabel(L"Longitude / $\degree$");
ylabel(L"Equatorial $P$ Variability (2x2) / mm day$^{-1}$");
savefig("./plots/d2c_zasym_prcp.png",bbox_inches="tight")

#########################################

@load "./data/3x3_zasym_prcp.jld2";     m3x3prcp = mprcpRAS; s3x3prcp = sprcpRAS;
@load "./data/control_zasym_prcp.jld2";
mconprcp = mean(mprcpRAS); sconprcp = mean(sprcpRAS)/sqrt(nlon);

mdprcp = m3x3prcp.-(mconprcp); mdprcp = mdprcp .- mean(mdprcp); sdprcp = s3x3prcp.+sconprcp;

close(); figure(figsize=(12,4),dpi=200); Seaborn.set()
plot(lon,mdprcp,"k",label="Total Precipitation");
plot([178,178],[-2,2],":k")
plot([182,182],[-2,2],":k")
fill_between(lon,mdprcp[:]-sdprcp[:],mdprcp[:]+sdprcp[:],color="k",alpha=0.3);
xlim(0,360); ylim(-2,2); grid("on")
legend(); xlabel(L"Longitude / $\degree$");
ylabel(L"Equatorial $P$ Variability (3x3) / mm day$^{-1}$");
savefig("./plots/d3c_zasym_prcp.png",bbox_inches="tight")

#########################################

@load "./data/5x5_zasym_prcp.jld2";     m5x5prcp = mprcpRAS; s5x5prcp = sprcpRAS;
@load "./data/control_zasym_prcp.jld2";
mconprcp = mean(mprcpRAS); sconprcp = mean(sprcpRAS)/sqrt(nlon);

mdprcp = m5x5prcp.-(mconprcp); mdprcp = mdprcp .- mean(mdprcp); sdprcp = s5x5prcp.+sconprcp;

close(); figure(figsize=(12,4),dpi=200); Seaborn.set()
plot(lon,mdprcp,"k",label="Total Precipitation");
plot([168,168],[-2,2],":k")
plot([172,172],[-2,2],":k")
plot([178,178],[-2,2],":k")
plot([182,182],[-2,2],":k")
plot([188,188],[-2,2],":k")
plot([192,192],[-2,2],":k")
fill_between(lon,mdprcp[:]-sdprcp[:],mdprcp[:]+sdprcp[:],color="k",alpha=0.3);
xlim(0,360); ylim(-2,2); grid("on")
legend(); xlabel(L"Longitude / $\degree$");
ylabel(L"Equatorial $P$ Variability (5x5) / mm day$^{-1}$");
savefig("./plots/d5c_zasym_prcp.png",bbox_inches="tight")
