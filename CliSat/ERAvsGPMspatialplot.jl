using ClimateEasy
using DelimitedFiles
using JLD2
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/CliSat/")

N,S,E,W = regionbounds("SEA"); lon = W:0.25:E; latSN = S:0.25:N; latNS = N:-0.25:S;
xy = readdlm("/Users/natgeo-wong/Codes/plot/SEA.txt",'\t',comments=true);
x = xy[:,1]; y = xy[:,2];

close(); figure(figsize=(16,13),dpi=200); Seaborn.set()

subplot(211); @load "./data/SEA_ERAvGPM_rhohr.jld2"
contourf(lon,latSN,rho',levels=0:0.1:1,cmap="viridis")
plot(x,y,"k",linewidth=0.5);
axis("scaled"); xlim(W,E); ylim(S,N); grid("on")
xticks(90:5:165,[]); ylabel(L"Latitude / $\degree$"); title("Correlation (Hourly)")
colorbar();

subplot(212); @load "./data/SEA_ERAvGPM_rhody.jld2"
contourf(lon,latSN,rho',levels=0:0.1:1,cmap="viridis")
plot(x,y,"k",linewidth=0.5);
axis("scaled"); xlim(W,E); ylim(S,N); grid("on")
xticks(90:5:165); xlabel(L"Longitude / $\degree$"); ylabel(L"Latitude / $\degree$");
colorbar(); title("Correlation (Daily)")

savefig("./fig/rho_ERAvGPM_SEA.png",bbox_inches="tight")


# init,eroot = erastartup(2,1,"/Volumes/CliNat-ERA/");
# emod,epar,ereg,etime = erainitialize(1,7,1,0,init);
# efol = erafolder(emod,epar,ereg,eroot,"sfc");
# fnc = glob("*.nc",efol["raw"])[1]; ds = Dataset(fnc);
# z = ds["z"][:]/9.81; lon = ds["longitude"][:]*1.0; lat = ds["latitude"][:]*1.0;
# z,zii = regionextractgrid(z,"SEA",lon,lat); z = reverse(z,dims=2);
# cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/CliSat/")
#
# close(); figure(figsize=(12,6),dpi=200); Seaborn.set()
#
# subplot(121); @load "./data/SEA_rhohr.jld2"
# scatter(z[:]/1000,rho[:],s=1)
# ylabel("Correlation (Hourly)"); ylim(0,1.0)
# xlabel("Topographic Height / km")
#
# subplot(122); @load "./data/SEA_rhody.jld2"
# scatter(z[:]/1000,rho[:],s=1);
# ylabel("Correlation (Daily)"); ylim(0,1.0)
# xlabel("Topographic Height / km")
#
# grid("on")
# savefig("./fig/rhovz.png",bbox_inches="tight")
# close()
