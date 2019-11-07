using ClimateSatellite, ClimateEasy

function tpwprecip(dvec::Array{Date,1})
    lvec = zeros(24,size(dvec,1),2); pcoord = [101.5,1.0];

    mimicnc = joinpath(mimicfol(Date(2016,10,1),sroot,"SEA"),mimicfile(datei,"SEA"));
    gpmlnc  = joinpath(gpmlfol(Date(2016,10,1),sroot,"SEA"),gpmlncfile(datei,"SEA"));

    lon_g = ncread(gpmlnc,"lon"); lon_m = ncread(mimicnc,"lon");
    lat_g = ncread(gpmlnc,"lat"); lat_m = ncread(mimicnc,"lat");
    ncclose();

    ilon_g,ilat_g = regionpoint(pcoord,lon_g,lat_g);
    ilon_m,ilat_m = regionpoint(pcoord,lon_m,lat_m);

    for datei in dvec
        mimicnc = joinpath(mimicfol(datei,sroot,"SEA"),mimicfile(datei,"SEA"));
        gpmnc   = joinpath(gpmlfol(datei,sroot,"SEA"),gpmlncfile(datei,"SEA"));
        jj = jj + 1;
        lvec[:,jj,1] = ncread(mimicnc,"tpw",start=[ilon_m,ilat_m,1],count=[1,1,-1]); ncclose();
        gpmii = ncread(gpmnc,"prcp",start=[ilon_g,ilat_g,1],count=[1,1,-1]); ncclose();
        lvec[:,jj,2] = convert2hourly(gpmii,isavg=true);
    end
end

dvec = collect(Date(2016,10,1):Day(1):Date(2019,9,30));
