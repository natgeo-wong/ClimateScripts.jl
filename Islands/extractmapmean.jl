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
    mdata = zeros(nlon,nlat,nfol-1); sdata = zeros(nlon,nlat,nfol-1);

    for ii = 2 : nfol
        @info "$(Dates.now()) - Calculating mean for $(parisca)"
        mdata[:,:,ii-1] = mean(ncread(ncname(fol,ii),parisca),dims=3);
    end

    @info "$(Dates.now()) - Resorting and reshaping mean data for $(parisca)."
    mdata = mean(mdata,dims=3); #mdata = (mdata + reverse(mdata,dims=2))/2;

    if     parisca == "precipitation";     mdata = mdata*24*3600; sdata = sdata*24*3600;
    elseif parisca == "condensation_rain"; mdata = mdata*24*3600; sdata = sdata*24*3600;
    elseif parisca == "convection_rain";   mdata = mdata*24*3600; sdata = sdata*24*3600;
    elseif parisca == "t_surf";            mdata = mdata .- 273.15;
    end

    return mdata,sdata

end

function dataextractlvl(parisca::AbstractString,fol::AbstractString,
                        nlon::Integer,nlat::Integer)

    @info "$(Dates.now()) - Extracting directory information ..."
    cdir = pwd(); cd(fol); allfol = glob("run00*/"); cd(cdir); nfol = length(allfol);

    @info "$(Dates.now()) - Preallocating arrays for mean."
    mdata = zeros(nlon,nlat,30,nfol-1);

    for ii = 2 : nfol
        @info "$(Dates.now()) - Calculating mean for $(parisca)"
        mdata[:,:,:,ii-1] = mean(ncread(ncname(fol,ii),parisca),dims=4);
    end

    @info "$(Dates.now()) - Resorting and reshaping mean data for $(parisca)."
    mdata = mean(mdata,dims=4);

    #if parisca == "vcomp"; mdata = (mdata-reverse(mdata,dims=2))/2;
    #else;                  mdata = (mdata+reverse(mdata,dims=2))/2;
    #end

    return mdata

end

function vtomeridionalPsi(vwind::Array,pre::Array,lat::Array)

    @info "$(Dates.now()) - Cumulative integration of meridional wind to meridional streamfunction."
    return ((2 * pi * 6370 * 1000 * cosd.(lat)' / 9.81) .* cumul_integrate(pre*100,vwind'))'

end

function expdata(exp::AbstractString)

    reg = matread("./data/lonlatpre.mat");
    lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];
    nlon = length(lon); nlat = length(lat);

    RASfol = "/n/holylfs/LABS/kuang_lab/nwong/isca/isca_out/Islands/0QFLUX-RAS/$(exp)/";
    #QEBfol = "/n/holylfs/LABS/kuang_lab/nwong/isca/isca_out/Islands/T85L30-RRTM-SBM/$(exp)/";

    mprcpRAS,sprcpRAS = dataextractsfc("precipitation",RASfol,nlon,nlat);
    #mprcpQEB,sprcpQEB = dataextractsfc("precipitation",QEBfol,nlon,nlat);

    mcondRAS,scondRAS = dataextractsfc("condensation_rain",RASfol,nlon,nlat);
    #mcondQEB,scondQEB = dataextractsfc("condensation_rain",QEBfol,nlon,nlat);

    mconvRAS,sconvRAS = dataextractsfc("convection_rain",RASfol,nlon,nlat);
    #mconvQEB,sconvQEB = dataextractsfc("convection_rain",QEBfol,nlon,nlat);

    mtsfcRAS,stsfcRAS = dataextractsfc("t_surf",RASfol,nlon,nlat);
    #mtsfcQEB,stsfcQEB = dataextractsfc("t_surf",QEBfol,nlon,nlat);

    tempRAS = dataextractlvl("temp",RASfol,nlon,nlat);
    #tempQEB = dataextractlvl("temp",QEBfol,nlon,nlat);

    #uwindRAS = dataextractlvl("ucomp",RASfol,nlon,nlat);
    #uwindQEB = dataextractlvl("ucomp",QEBfol,nlon,nlat);

    #vwindRAS = dataextractlvl("vcomp",RASfol,nlon,nlat);
    #vwindQEB = dataextractlvl("vcomp",QEBfol,nlon,nlat);

    #vPsiRAS = vtomeridionalPsi(vwindRAS,pre,lat);
    #vPsiQEB = vtomeridionalPsi(vwindQEB,pre,lat);

    @save "./data/$(exp)_map_prcp.jld2" mprcpRAS sprcpRAS #mprcpQEB sprcpQEB
    @save "./data/$(exp)_map_cond.jld2" mcondRAS scondRAS #mcondQEB scondQEB
    @save "./data/$(exp)_map_conv.jld2" mconvRAS sconvRAS #mconvQEB sconvQEB
    @save "./data/$(exp)_map_tsfc.jld2" mtsfcRAS stsfcRAS #mtsfcQEB stsfcQEB
    @save "./data/$(exp)_map_temp.jld2" tempRAS #tempQEB
    #@save "./data/$(exp)_map_wind.jld2" uwindRAS vPsiRAS #uwindQEB vPsiQEB

end

expdata("realcont")
#expdata("1x1"); expdata("2x2"); expdata("3x3"); expdata("5x5")
#expdata("csmall"); expdata("cmed"); expdata("clarge");
