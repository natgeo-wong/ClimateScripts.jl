using Statistics, NumericalIntegration
using NetCDF, MAT, Glob, Statistics, JLD2

function ncname(fol::AbstractString,ii::Integer)
    fnc = "$(fol)/run000$(ii)/atmos_daily.nc"
end

function dataextractsfc(parisca::AbstractString,fol::AbstractString,
                        nlon::Integer,nlat::Integer)

    @info "$(Dates.now()) - Extracting directory information ..."
    cdir = pwd(); cd(fol); allfol = glob("run00*/"); cd(cdir); nfol = length(allfol);

    @info "$(Dates.now()) - Preallocating arrays for mean and standard deviation."
    mdata = zeros(nlon,nfol-1); sdata = zeros(nlon,nfol-1);

    for ii = 2 : nfol
        @info "$(Dates.now()) - Calculating mean and standard deviation for $(parisca)"
        mdata[:,ii-1] = mean(mean(ncread(ncname(fol,ii),parisca,
                                           start=[1,60,1],[-1,10,-1]),dims=2),dims=3);
        sdata[:,ii-1] = mean(std(ncread(ncname(fol,ii),parisca),
                                           start=[1,60,1],[-1,10,-1]),dims=2),dims=3)/sqrt(360);
    end

    @info "$(Dates.now()) - Resorting and reshaping mean data for $(parisca)."
    mdata = mean(mdata,dims=2);

    @info "$(Dates.now()) - Resorting and reshaping standard deviation data for $(parisca)."
    sdata = mean(sdata,dims=2)/sqrt(nfol-1);

    if     parisca == "precipitation";     mdata = mdata*24*3600; sdata = sdata*24*3600;
    elseif parisca == "condensation_rain"; mdata = mdata*24*3600; sdata = sdata*24*3600;
    elseif parisca == "convection_rain";   mdata = mdata*24*3600; sdata = sdata*24*3600;
    end

    return mdata,sdata

end

function dataextractlvl(parisca::AbstractString,fol::AbstractString,
                        nlon::Integer,nlat::Integer)

    @info "$(Dates.now()) - Extracting directory information ..."
    cdir = pwd(); cd(fol); allfol = glob("run00*/"); cd(cdir); nfol = length(allfol);

    @info "$(Dates.now()) - Preallocating arrays for mean."
    mdata = zeros(nlon,1,30,nfol-1);

    for ii = 2 : nfol
        @info "$(Dates.now()) - Calculating mean and standard deviation for $(parisca)"
        mdata[:,:,:,ii-1] = mean(mean(ncread(ncname(fol,ii),parisca,
                                             start=[1,60,1,1],[-1,10,-1,-1]),dims=2),dims=4);
    end

    @info "$(Dates.now()) - Resorting and reshaping mean data for $(parisca)."
    mdata = mean(mdata,dims=4);

    mdata = reshape(mdata,nlon,30);

    return mdata

end

function expdata(exp::AbstractString)

    reg = matread("./data/lonlatpre.mat");
    lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];
    nlon = length(lon); nlat = length(lat);

    RASfol = "/n/holylfs/LABS/kuang_lab/nwong/isca/isca_out/Islands/T85L30-RRTM-RAS/$(exp)/";
    QEBfol = "/n/holylfs/LABS/kuang_lab/nwong/isca/isca_out/Islands/T85L30-RRTM-SBM/$(exp)/";

    mprcpRAS,sprcpRAS = dataextractsfc("precipitation",RASfol,nlon,nlat);
    mprcpQEB,sprcpQEB = dataextractsfc("precipitation",QEBfol,nlon,nlat);

    mtsfcRAS,stsfcRAS = dataextractsfc("t_surf",RASfol,nlon,nlat);
    mtsfcQEB,stsfcQEB = dataextractsfc("t_surf",QEBfol,nlon,nlat);

    tempRAS = dataextractlvl("temp",RASfol,nlon,nlat);
    tempQEB = dataextractlvl("temp",QEBfol,nlon,nlat);

    uwindRAS = dataextractlvl("ucomp",RASfol,nlon,nlat);
    uwindQEB = dataextractlvl("ucomp",QEBfol,nlon,nlat);

    wwindRAS = dataextractlvl("omega",RASfol,nlon,nlat);
    wwindQEB = dataextractlvl("omega",QEBfol,nlon,nlat);

    @save "./data/$(exp)_zasym_prcp.jld2" mprcpRAS sprcpRAS mprcpQEB sprcpQEB
    @save "./data/$(exp)_zasym_tsfc.jld2" mtsfcRAS stsfcRAS mtsfcQEB stsfcQEB
    @save "./data/$(exp)_zasym_temp.jld2" tempRAS tempQEB
    @save "./data/$(exp)_zasym_wind.jld2" uwindRAS uwindQEB wwindRAS wwindQEB

end

expdata("control")
expdata("1x1"); expdata("2x2"); expdata("3x3"); expdata("5x5")
expdata("csmall"); expdata("cmed"); expdata("clarge");
