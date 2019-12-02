using Statistics
using JLD2
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/CliSat/")

@load "gpml.jld2"

dvec = (0:49)/2 .- 0.25;
lday = mean(lvec,dims=1)[:];
ldhr = mean(lvec,dims=2); ldhr = cat(dims=1,ldhr[end],ldhr,ldhr[1]);

figure(); Seaborn.set();
plot(dvec,ldhr); xlim(0,24); ylim = (0,0.5); grid("on")
gcf()
