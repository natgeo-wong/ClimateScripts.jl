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

function plotMvGhr(fol::AbstractString,stn::AbstractString,Pi::AbstractFloat)
    fdata = "$(fol)/data/$(stn)_MIMICvsGNSS.jld2"; @info fdata
    @load fdata mtpw gtpw
    ind = sum.(.!isnan.(mtpw)+.!isnan.(gtpw))
    pval = sum(ind.==2) / length(ind); threshold = 0.5
    if pval >= threshold
        figure(figsize=(6,6),dpi=225)
        kdeplot(gtpw[ind.==2]*Pi*1000,mtpw[ind.==2],shade=true,shade_lowest=false,levels=20)
        plot([20,80],[20,80],"k",linewidth=0.5)
        axis("scaled"); xlim(20,80); ylim(20,80); grid("on")
        xlabel("GNSS Zenith Wet Delay")
        ylabel("MIMIC-TPW2m Precipitable Water")
        text(25,75,"Percentage of Valid Data: $(pval*100)%")
        title("$(stn) (Hourly)")
        savefig("$(fol)/fig/MvG_hourly_$(stn).png",bbox_inches="tight")
        close()
    else
        @warn "$(stn) has valid data for less than $(threshold*100)% of 2017."
    end
end

function plotMvGdy(fol::AbstractString,stn::AbstractString,Pi::AbstractFloat)
    fdata = "$(fol)/data/$(stn)_MIMICvsGNSS.jld2"; @info fdata
    @load fdata mtpw gtpw
    mtpw = mean(reshape(mtpw,24,:),dims=1); mtpw = mtpw[:]
    gtpw = mean(reshape(gtpw,24,:),dims=1); gtpw = gtpw[:]
    ind = sum.(.!isnan.(mtpw)+.!isnan.(gtpw))
    pval = sum(ind.==2) / length(ind); threshold = 0.5
    if pval >= threshold
        figure(figsize=(6,6),dpi=225)
        kdeplot(gtpw[ind.==2]*Pi*1000,mtpw[ind.==2],shade=true,shade_lowest=false,levels=20)
        plot([20,80],[20,80],"k",linewidth=0.5)
        axis("scaled"); xlim(20,80); ylim(20,80); grid("on")
        xlabel("GNSS Zenith Wet Delay")
        ylabel("MIMIC-TPW2m Precipitable Water")
        text(25,75,"Percentage of Valid Data: $(pval*100)%")
        title("$(stn) (Daily)")
        savefig("$(fol)/fig/MvG_daily_$(stn).png",bbox_inches="tight")
        close()
    else
        @warn "$(stn) has valid data for less than $(threshold*100)% of 2017."
    end
end

function plotMGvThr(fol::AbstractString,stn::AbstractString,Pi::AbstractFloat)
    fdata = "$(fol)/data/$(stn)_MIMICvsGNSS.jld2"; @info fdata
    @load fdata mtpw gtpw
    t = 1 : length(mtpw)
    figure(figsize=(8,4),dpi=225)
    plot(t,mtpw,linewidth=0.5,label="MIMIC-TPW2m");
    plot(t,gtpw*Pi*1000,linewidth=0.5,label="GNSS");
    xlim(0,600); ylim(20,80); grid("on")
    xlabel("Time past 2017-01-01 / hours")
    ylabel("Precipitable Water")
    title("$(stn) (Hourly)"); legend(loc="upper right");
    savefig("$(fol)/fig/MGvT_hourly_$(stn).png",bbox_inches="tight");
    close();
end

function plotMGvTdy(fol::AbstractString,stn::AbstractString,Pi::AbstractFloat)
    fdata = "$(fol)/data/$(stn)_MIMICvsGNSS.jld2"; @info fdata
    @load fdata mtpw gtpw
    mtpw = mean(reshape(mtpw,24,:),dims=1); mtpw = mtpw[:]
    gtpw = mean(reshape(gtpw,24,:),dims=1); gtpw = gtpw[:]
    t = 1 : length(mtpw)
    figure(figsize=(8,4),dpi=225)
    plot(t,mtpw,linewidth=0.5,label="MIMIC-TPW2m");
    plot(t,gtpw*Pi*1000,linewidth=0.5,label="GNSS");
    xlim(0,365); ylim(20,80); grid("on")
    xlabel("Days past 2016-12-31 / days")
    ylabel("Precipitable Water")
    title("$(stn) (Daily)"); legend(loc="upper right");
    savefig("$(fol)/fig/MGvT_daily_$(stn).png",bbox_inches="tight");
    close();
end

cd("/Volumes/CliNat-ERA/erai/GLB"); reg = matread("info_reg.mat");
rlon = reg["reg"]["lon"][:]; rlat = reg["reg"]["lat"][:];
cd("/Volumes/CliNat-ERA/erai/GLB/Pi_ADVD/ana/"); Pi = findPi(rlon,rlat)


sinfo = eosload("SMT"); stnnames = sinfo[:,1]; lon = sinfo[:,2]; lat = sinfo[:,3];
fol = "/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/MIMICvsGNSS/"; cd(fol)

for ii = 1 : size(sinfo,1)
    ilon,ilat = regionpoint(lon[ii],lat[ii],rlon[:],rlat[:]);
    Pistn = Pi[ilon,ilat]
    try
        plotMvGhr(fol,stnnames[ii],Pistn); plotMGvThr(fol,stnnames[ii],Pistn);
        plotMvGdy(fol,stnnames[ii],Pistn); plotMGvTdy(fol,stnnames[ii],Pistn);
    catch; @warn "No data exists for $(stnnames[ii])"
    end
end
