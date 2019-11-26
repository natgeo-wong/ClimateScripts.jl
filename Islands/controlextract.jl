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
        @info "$(Dates.now()) - Calculating mean and standard deviation for $(parisca)"
        mdata[:,:,ii-1] = mean(ncread(ncname(fol,ii),parisca),dims=3);
        sdata[:,:,ii-1] = std(ncread(ncname(fol,ii),parisca),dims=3);
    end
    
    @info "$(Dates.now()) - Resorting and reshaping mean data for $(parisca)."
    mdata = mean(mdata,dims=3); mdata = mean(mdata,dims=1)[:]; mdata = (mdata + reverse(mdata))/2;
    
    @info "$(Dates.now()) - Resorting and reshaping standard deviation data for $(parisca)."
    sdata = mean(sdata,dims=3)/sqrt(nfol-1);
    sdata = mean(sdata,dims=1)[:]/sqrt(nlon); sdata = sdata + reverse(sdata);

    if parisca == "precipitation"; mdata = mdata*24*3600; sdata = sdata*24*3600;
    elseif parisca == "t_surf";    mdata = mdata .- 273.15;
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
        @info "$(Dates.now()) - Calculating mean and standard deviation for $(parisca)"
        mdata[:,:,:,ii-1] = mean(ncread(ncname(fol,ii),parisca),dims=4);
    end

    @info "$(Dates.now()) - Resorting and reshaping mean data for $(parisca)."
    mdata = mean(mdata,dims=4); mdata = mean(mdata,dims=1);
    mdata = (mdata+reverse(mdata,dims=2))/2; mdata = reshape(mdata,nlat,30);

    return mdata

end

function vtomeridionalPsi(vwind::Array,pre::Array,lat::Array)

    @info "$(Dates.now()) - Cumulative integration of meridional wind to meridional streamfunction."
    return ((2 * pi * cosd.(lat)' / 9.81) .* cumul_integrate(vwind',pre))'

end

reg = matread("./data/lonlatpre.mat");
lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];
nlon = length(lon); nlat = length(lat);

RASfol = "/n/holylfs/LABS/kuang_lab/nwong/isca/isca_out/Islands/T85L30-RRTM-RAS/control/";
QEBfol = "/n/holylfs/LABS/kuang_lab/nwong/isca/isca_out/Islands/T85L30-RRTM-SBM/control/";

#mprcpRAS,sprcpRAS = dataextractsfc("precipitation",RASfol,nlon,nlat);
#mprcpQEB,sprcpQEB = dataextractsfc("precipitation",QEBfol,nlon,nlat);
#@save "./data/controlprcp.jld2"  mprcpQEB mprcpRAS sprcpQEB sprcpRAS

#mtempRAS,stempRAS = dataextractsfc("t_surf",RASfol,nlon,nlat);
#mtempQEB,stempQEB = dataextractsfc("t_surf",QEBfol,nlon,nlat);
#@save "./data/controltemp.jld2"  mtempQEB mtempRAS stempQEB stempRAS

#uwindRAS = dataextractlvl("ucomp",RASfol,nlon,nlat);
#uwindQEB = dataextractlvl("ucomp",QEBfol,nlon,nlat);
#@save "./data/controluwind.jld2" uwindQEB uwindRAS

#vwindRAS = dataextractlvl("vcomp",RASfol,nlon,nlat);
#vwindQEB = dataextractlvl("vcomp",QEBfol,nlon,nlat);
#@save "./data/controlvwind.jld2" vwindQEB vwindRAS

@load "./data/controlvwind.jld2"
vPsiRAS = vtomeridionalPsi(vwindRAS,pre,lat);
vPsiQEB = vtomeridionalPsi(vwindQEB,pre,lat);
@save "./data/controlvPsi.jld2" vPsiQEB vPsiRAS
