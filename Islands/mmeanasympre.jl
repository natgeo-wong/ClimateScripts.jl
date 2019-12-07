using JLD2, MAT
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/Islands/");
reg = matread("./data/lonlatpre.mat"); cmap = ColorMap("RdBu_r");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];
nlon = length(lon); nlat = length(lat);

@load "./data/1x1_zasym_wind.jld2";     m1x1uwind = uwindRAS; m1x1wwind = wwindRAS;
@load "./data/control_zasym_prcp.jld2";
mconuwind = mean(uwindRAS,dims=1); mconwwind = mean(wwindRAS,dims=1);

mduwind = m1x1uwind.-(mconuwind); mdwwind = m1x1wwind.-(mconwwind);
mdwind  = (mduwind.^2 + mdwwind.^2);
nduwind = mduwind ./ mdwind; ndwwind = mdwwind ./ mdwind;

close(); figure(figsize=(9,6),dpi=200); Seaborn.set()
plot([178,178],[0,1000],":k")
plot([182,182],[0,1000],":k")
quiver(lon[6:8:end],pre,mduwind[6:8:end,:]',-mdwwind[6:8:end,:]'*100);
xlim(0,360); ylim(0,1000); grid("on")
xlabel(L"Longitude / $\degree$");
ylabel("Pressure / hPa");
PyPlot.gca().invert_yaxis()
savefig("./plots/d1c_zasym_wind.png",bbox_inches="tight")

#########################

@load "./data/2x2_zasym_wind.jld2";     m2x2uwind = uwindRAS; m2x2wwind = wwindRAS;
@load "./data/control_zasym_prcp.jld2";
mconuwind = mean(uwindRAS,dims=1); mconwwind = mean(wwindRAS,dims=1);

mduwind = m2x2uwind.-(mconuwind); mdwwind = m2x2wwind.-(mconwwind);
mdwind  = (mduwind.^2 + mdwwind.^2);
nduwind = mduwind ./ mdwind; ndwwind = mdwwind ./ mdwind;

close(); figure(figsize=(9,6),dpi=200); Seaborn.set()
plot([175,175],[0,1000],":k")
plot([179,179],[0,1000],":k")
plot([181,181],[0,1000],":k")
plot([185,185],[0,1000],":k")
quiver(lon[6:8:end],pre,mduwind[6:8:end,:]',-mdwwind[6:8:end,:]'*100);
xlim(0,360); ylim(0,1000); grid("on")
xlabel(L"Longitude / $\degree$");
ylabel("Pressure / hPa");
PyPlot.gca().invert_yaxis()
savefig("./plots/d2c_zasym_wind.png",bbox_inches="tight")

#########################

@load "./data/3x3_zasym_wind.jld2";     m3x3uwind = uwindRAS; m3x3wwind = wwindRAS;
@load "./data/control_zasym_prcp.jld2";
mconuwind = mean(uwindRAS,dims=1); mconwwind = mean(wwindRAS,dims=1);

mduwind = m3x3uwind.-(mconuwind); mdwwind = m3x3wwind.-(mconwwind);
mdwind  = (mduwind.^2 + mdwwind.^2);
nduwind = mduwind ./ mdwind; ndwwind = mdwwind ./ mdwind;

close(); figure(figsize=(9,6),dpi=200); Seaborn.set()
plot([178,178],[0,1000],":k")
plot([182,182],[0,1000],":k")
quiver(lon[6:8:end],pre,mduwind[6:8:end,:]',-mdwwind[6:8:end,:]'*100);
xlim(0,360); ylim(0,1000); grid("on")
xlabel(L"Longitude / $\degree$");
ylabel("Pressure / hPa");
PyPlot.gca().invert_yaxis()
savefig("./plots/d3c_zasym_wind.png",bbox_inches="tight")

#########################

@load "./data/5x5_zasym_wind.jld2";     m5x5uwind = uwindRAS; m5x5wwind = wwindRAS;
@load "./data/control_zasym_prcp.jld2";
mconuwind = mean(uwindRAS,dims=1); mconwwind = mean(wwindRAS,dims=1);

mduwind = m5x5uwind.-(mconuwind); mdwwind = m5x5wwind.-(mconwwind);
mdwind  = (mduwind.^2 + mdwwind.^2);
nduwind = mduwind ./ mdwind; ndwwind = mdwwind ./ mdwind;

close(); figure(figsize=(9,6),dpi=200); Seaborn.set()
plot([168,168],[0,1000],":k")
plot([172,172],[0,1000],":k")
plot([178,178],[0,1000],":k")
plot([182,182],[0,1000],":k")
plot([188,188],[0,1000],":k")
plot([192,192],[0,1000],":k")
quiver(lon[6:8:end],pre,mduwind[6:8:end,:]',-mdwwind[6:8:end,:]'*100);
xlim(0,360); ylim(0,1000); grid("on")
xlabel(L"Longitude / $\degree$");
ylabel("Pressure / hPa");
PyPlot.gca().invert_yaxis()
savefig("./plots/d5c_zasym_wind.png",bbox_inches="tight")
