using ClimateGNSS
using DelimitedFiles
using PyPlot

global_logger(ConsoleLogger(stdout,Logging.Info))

info = eosload("SMT"); lon = info[:,2]; lat = info[:,3];

slon = []; slat = []; vlon = []; vlat = []; vname = [];
fol = "/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/MIMICvsGNSS/";
for ii = 1 : size(info,1)
    if isfile(joinpath(fol,"data/$(info[ii,1])_MIMICvsGNSS.jld2"))
        append!(slon,info[ii,2]); append!(slat,info[ii,3])
    end
end
for ii = 1 : size(info,1)
    if isfile(joinpath(fol,"fig/$(info[ii,1])_MIMICvsGNSS.png"))
        append!(vlon,info[ii,2]); append!(vlat,info[ii,3]); append!(vname,[info[ii,1]])
    end
end

cd("/Users/natgeo-wong/Codes/plot/")
xy = readdlm("/Users/natgeo-wong/Codes/plot/SMT.txt",'\t',comments=true);
x = xy[:,1]; y = xy[:,2];

figure(figsize=(6,6),dpi=300)
plot(x,y,"k",linewidth=0.5);
scatter(lon,lat,label="SuGAr stations not active in 2017");
scatter(slon,slat,label="SuGAr stations active in 2017 (<50% valid data)")
scatter(vlon,vlat,c="#2cdd2c",label="SuGAr stations active in 2017 (>50% valid data)")
text.(vlon.+0.1,vlat.-0.3,vname);
axis("scaled"); xlim(95,107); ylim(-6,6); grid("on")
gcf(); legend(loc="upper right");
savefig("/Users/natgeo-wong/SuGAr.png",bbox_inches="tight")
close();
