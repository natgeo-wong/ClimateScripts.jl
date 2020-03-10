using ClimateSatellite
using NCDatasets, Seaborn, DelimitedFiles

global_logger(ConsoleLogger(stderr,Logging.Info))

function clisattemporalmean(
    productID::AbstractString, varname::AbstractString,
    datevector::Vector{<:TimeType}, region::AbstractString;
    path::AbstractString=""
)

    sdate = datevector[1]; ndt = length(datevector); ii = 0;

    fol = clisatrawfol(productID,Date(2007),"TRP");
    fnc = joinpath(fol,clisatrawname(productID,Date(2007,1),"TRP"));
    ds  = Dataset(fnc,"r");
    lon = ds["longitude"].var[:]; nlon = length(lon);
    lat = ds["latitude"].var[:];  nlat = length(lat);
    offset = ds[varname].attrib["add_offset"];
    scale  = ds[varname].attrib["scale_factor"];

    if ndt == 1; grid = zeros(nlon,nlat);

        fol = clisatrawfol(productID,datevector[1],"TRP");
        fnc = joinpath(fol,clisatrawname(productID,datevector[1],"TRP"));
        ds  = Dataset(fnc,"r"); data = ds[varname].var[:] :: Array{Int16,3};

        @info "$(Dates.now()) - Begin extraction and time-averaging."
        for ilat = 1 : nlat, ilon = 1 : nlon
            dataii = data[ilon,ilat,:];
            grid[ilon,ilat] = mean(dataii[dataii .!= -32768]);
        end
        @info "$(Dates.now()) - Finished extraction and time-averaging."

    else; grid = zeros(nlon,nlat,ndt);

        for idt = 1 : ndt

            fol = clisatrawfol(productID,datevector[idt],"TRP");
            fnc = joinpath(fol,clisatrawname(productID,datevector[idt],"TRP"));
            ds  = Dataset(fnc,"r"); data = ds[varname].var[:] :: Array{Int16,3};

            @info "$(Dates.now()) - Begin extraction and time-averaging."
            for ilat = 1 : nlat, ilon = 1 : nlon
                dataii = data[ilon,ilat,:];
                grid[ilon,ilat,idt] = mean(dataii[dataii .!= -32768]);
            end
            @info "$(Dates.now()) - Finished extraction and time-averaging."

        end

        grid = dropdims(mean(grid,dims=3),dims=3);

    end

    return lon,lat,grid.*scale.+offset

end

sdate = Date(2007,1); fdate = Date(2007,12); dvec = convert(Array,sdate:Month(1):fdate);

lon,lat,mdata = clisattemporalmean("gpmimerg","prcp_rate",dvec,"TRP");
mdata[mdata.<0] .= 0;

xy = readdlm("/Users/natgeo-wong/Projects/plot/GLB.txt",'\t',comments=true);
x = xy[:,1]; y = xy[:,2];

close()
figure(figsize=(37,5),dpi=200);
contourf(lon,lat,mdata'*3600,levels=0:0.1:1.5);
plot(x,y,"k",linewidth=0.5);
colorbar(); axis("scaled");
xlim(0,360); ylim(-30,30);
savefig(joinpath(@__DIR__,"test.png"),bbox_inches="tight");
gcf()
