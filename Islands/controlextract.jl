using Statistics, NumericalIntegration
using NetCDF, MAT, Glob, Statistics, JLD2

function ncname(fol::AbstractString,exp::AbstractString,ii::Integer)
    fnc = "$(fol)/run000$(ii)/atmos_daily.nc"
end

function dataextractsfc(parisca::AbstractString,fol::AbstractString,exp::AbstractString,
                        nlon::Integer,nlat::Integer)

    cdir = pwd(); cd(fol); allfol = glob("run00*/"); cd(cdir); nfol = length(allfol);
    mdata = zeros(nlon,nlat,nfol-1); sdata = zeros(nlon,nlat,nfol-1);

    for ii = 2 : nfol
        mdata[:,:,ii-1] = mean(ncread(ncname(fol,ii),parisca),dims=3);
        sdata[:,:,ii-1] = std(ncread(ncname(fol,ii),parisca),dims=3);
    end

    mdata = mean(mdata,dims=3); mdata = mean(mdata,dims=1)[:]; mdata = (mdata + reverse(mdata))/2;
    sdata = mean(sdata,dims=3)/sqrt(nfol-1);
    sdata = mean(sdata,dims=1)[:]/sqrt(nlon); sdata = sdata + reverse(sdata);

    if parisca == "precipitation"; mdata = mdata*24*3600; sdata = sdata*24*3600;
    elseif parisca == "t_surf";    mdata = mdata .- 273.15;
    end

    return mdata,sdata

end

function dataextractlvl(parisca::AbstractString,fol::AbstractString,
                        nlon::Integer,nlat::Integer)

    cdir = pwd(); cd(fol); allfol = glob("run00*/"); cd(cdir); nfol = length(allfol);
    mdata = zeros(nlon,nlat,30,nfol-1);

    for ii = 2 : nfol
        mdata[:,:,:,ii-1] = mean(ncread(ncname(fol,ii),parisca),dims=4);
    end

    mdata = mean(mdata,dims=4); mdata = mean(mdata,dims=1);
    mdata = (mdata+reverse(mdata,dims=2))/2; mdata = reshape(mdata,nlat,30);

    return mdata

end

function vtomeridionalPsi(vwind::Array,pre::Array,lat::Array)

    return ((2 * pi * cosd(lat)' / 9.81) .* cumul_Integrate(vwind',pre))'

end

reg = matread("lonlatpre.mat"); lon = reg["lon"][:]; lat = reg["lat"][:]; pre = reg["allpre"][:];
nlon = length(lon); nlat = length(lat);

RASfol = "/Volumes/CliNat-Isca/isca_out/Islands/T85L30-RRTM-RAS/control/";
QEBfol = "/Volumes/CliNat-Isca/isca_out/Islands/T85L30-RRTM-SBM/control/";

mprcpRAS,sprcpRAS = dataextractsfc("precipitation",RASfol,nlon,nlat);
mprcpQEB,sprcpQEB = dataextractsfc("precipitation",QEBfol,nlon,nlat);
@save "controlprcp.jld2"  mprcpQEB mprcpRAS sprcpQEB sprcpRAS

mtempRAS,stempRAS = dataextractsfc("t_surf",RASfol,nlon,nlat);
mtempQEB,stempQEB = dataextractsfc("t_surf",QEBfol,nlon,nlat);
@save "controltemp.jld2"  mtempQEB mtempRAS stempQEB stempRAS

uwindRAS = dataextractlvl("ucomp",RASfol,nlon,nlat);
uwindQEB = dataextractlvl("ucomp",QEBfol,nlon,nlat);
@save "controluwind.jld2" uwindQEB uwindRAS

vwindRAS = dataextractlvl("vcomp",RASfol,nlon,nlat);
vwindQEB = dataextractlvl("vcomp",QEBfol,nlon,nlat);
@save "controlvwind.jld2" vwindQEB vwindRAS

vPsiRAS = vtomeridionalPsi(vwindRAS,pre,lat);
vPsiQEB = vtomeridionalPsi(vwindQEB,pre,lat);
@save "controlvPsi.jld2" vPsiQEB vPsiRAS
