using ClimateEasy
using DelimitedFiles
using JLD2
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/CliSat/")

N,S,E,W = regionbounds("SEA"); lon = W:0.25:E; latSN = S:0.25:N; latNS = N:-0.25:S;
xy = readdlm("/Users/natgeo-wong/Codes/plot/SEA.txt",'\t',comments=true);
x = xy[:,1]; y = xy[:,2];

@load "./data/SEA_rho.jld2"

close(); figure(figsize=(18,6),dpi=200);# Seaborn.set()
contourf(lon,latSN,rho',levels=0:0.05:1)
plot(x,y,"k",linewidth=0.5);
axis("scaled"); xlim(W,E); ylim(S,N); grid("on")
xticks(90:5:165); xlabel(L"Longitude / $\degree$"); ylabel(L"Latitude / $\degree$");
colorbar(); gcf()
savefig("./fig/rho_SEA.png",bbox_inches="tight")
