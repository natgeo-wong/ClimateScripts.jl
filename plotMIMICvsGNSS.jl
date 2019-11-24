using ClimateGNSS, ClimateEasy
using JLD2, MAT, Glob, Statistics
using PyPlot, Seaborn

global_logger(ConsoleLogger(stdout,Logging.Info))

function findPi(rlon::AbstractArray,rlat::AbstractArray)

    fnc = glob("*.nc"); lnc = length(fnc);
    nlon = length(rlon); nlat = length(rlat); Pi = zeros(nlon,nlat,lnc);

    for ii = 1 : lnc
        Pi[:,:,ii] = ncread(fnc[ii],"raw_year_mu")
    end

    @info sum(isnan.(Pi))

    return mean(Pi,dims=3)

end

function plotMvG(fol::AbstractString,stn::AbstractString,Pi::AbstractFloat)
    fdata = "$(fol)/data/$(stn)_MIMICvsGNSS.jld2"; @info fdata
    @load fdata mtpw gtpw
    ind = sum.(.!isnan.(mtpw)+.!isnan.(gtpw))
    pval = sum(ind.==2) / length(ind); threshold = 0.5
    if pval >= threshold
        figure(figsize=(6,6),dpi=225)
        kdeplot(gtpw[ind.==2]*Pi*1000,mtpw[ind.==2],shade=true,shade_lowest=false,levels=20)
        axis("scaled"); xlim(20,80); ylim(20,80); grid("on")
        xlabel("GNSS Zenith Wet Delay")
        ylabel("MIMIC-TPW2m Precipitable Water")
        text(25,75,"Percentage of Valid Data: $(pval*100)%")
        title("$(stn)")
        savefig("$(fol)/fig/$(stn)_MIMICvsGNSS.png",bbox_inches="tight")
        close()
    else
        @warn "$(stn) has valid data for less than $(threshold*100)% of 2017."
    end
end

cd("/Volumes/CliNat-ERA/erai/GLB"); reg = matread("info_reg.mat");
rlon = reg["reg"]["lon"][:]; rlat = reg["reg"]["lat"][:];
cd("/Volumes/CliNat-ERA/erai/GLB/Pi_ADVD/ana/"); Pi = findPi(rlon,rlat)


sinfo = eosload("SMT"); stnnames = sinfo[:,1]; lon = sinfo[:,2]; lat = sinfo[:,3];
fol = "/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/MIMICvsGNSS/"; cd(fol)

for ii = 1 : size(sinfo,1)
    ilon,ilat = regionpoint(lon[ii],lat[ii],rlon[:],rlat[:]);
    Pistn = Pi[ilon,ilat]
    try; plotMvG(fol,stnnames[ii],Pistn);
    catch; @warn "No data exists for $(stnnames[ii])"
    end
end
