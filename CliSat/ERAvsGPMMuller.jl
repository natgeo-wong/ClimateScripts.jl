using ClimateEasy
using DelimitedFiles
using JLD2
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/CliSat/")

N,S,E,W = regionbounds("SEA"); lon = W:0.25:E; latSN = S:0.25:N; latNS = N:-0.25:S;
@load "./data/ERAvsGPM_Muller.jld2"
@load "./data/SEA_05x05grid.jld2" lsm; lsm = reverse(lsm,dims=2);

close(); figure();
einf = transpose(reshape(einf,:,141));
emap = transpose(reshape(emap,:,141));
n = einf ./ emap; n[isnan.(n)] .= 0; n = sum(n,dims=2);

emap_land = emap[:,lsm[:].==1]; emap_sea = emap[:,lsm[:].==0]; emap_cst = emap[:,lsm[:].==0.5];
einf_land = einf[:,lsm[:].==1]; einf_sea = einf[:,lsm[:].==0]; einf_cst = einf[:,lsm[:].==0.5];

n_land = einf_land ./ emap_land; n_sea = einf_sea ./ emap_sea; n_cst = einf_cst ./ emap_cst;
n_land[isnan.(n_land)] .= 0; n_sea[isnan.(n_sea)] .= 0; n_cst[isnan.(n_cst)] .= 0;
n_land = sum(n_land,dims=2); n_sea = sum(n_sea,dims=2); n_cst = sum(n_cst,dims=2);

einf = sum(einf,dims=2) ./ n;
einf_land = sum(einf_land,dims=2) ./ n_land;
einf_sea  = sum(einf_sea,dims=2) ./ n_sea;
einf_cst  = sum(einf_cst,dims=2) ./ n_cst;

nprop = n_land ./ n_sea;
nlnds = sum(lsm[:].==1) / sum(lsm[:].!=1)

close(); figure(dpi=200); Seaborn.set()
semilogy(10:0.5:80,einf,linewidth=1,label="All")
semilogy(10:0.5:80,einf_land,linewidth=1,label="Land")
semilogy(10:0.5:80,einf_sea,linewidth=1,label="Sea")
semilogy(10:0.5:80,einf_cst,linewidth=1,label="Coast")
legend(); xlim(10,80);
xlabel("Precipitable Water / mm"); ylabel(L"Precipitation Rate / mm hr$^{-1}$")
savefig("./fig/ERAvsGPM_Muller.png",bbox_inches="tight")

close(); figure(dpi=200); Seaborn.set()
semilogy(10:0.5:80,nprop,linewidth=1)
plot([10,80],[nlnds,nlnds],"--k",linewidth=1)
xlabel("Precipitable Water / mm"); ylabel("Ratio (Land / Sea)"); xlim(10,80);
savefig("./fig/prop_landsea.png",bbox_inches="tight")
