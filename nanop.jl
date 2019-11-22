using BenchmarkTools

function nanoper(f::Function,data::Array;dim=1)
    return f(data->isnan(data) ? typemin(data) : data, data, dims=dim)
end

function nanoper2(f::Function,data::Array;dim=1)

    ndim = ndims(data); dsize = size(data);
    if ndim==2
        if dim==1; newdim = [2,1]; data = permutedims(data,newdim); nsize = dsize[2];
        else; nsize = dsize[1];
        end
    elseif ndim>2
        if dim==1; newdim = convert(Array,2:ndim); newdim = vcat(newdim,1);
            data = permutedims(data,newdim);
            nsize = dsize[2:end]
        elseif dim<ndim
            newdim1 = convert(Array,1:dim-1);
            newdim2 = convert(Array,dim+1:ndim);
            newdim  = vcat(newdim1,newdim2,dim)
            data    = permutedims(data,newdim);
            nsize   = tuple(dsize[newdim1]...,dsize[newdim2]...)
        else nsize  = dsize[1:end-1]
        end
    else; nsize = dsize[1:end-1]
    end

    data = reshape(data,:,dsize[dim]); l = size(data,1); out = zeros(l);
    data = transpose(data);

    for ii = 1 : l;
        out[ii] = f(skipmissing(data[:,ii]));
    end

    return reshape(out,nsize)

end

#@btime nanoper(mean,rand(2,3,4),dim=2)
#@btime nanoper2(mean,rand(480,241,365),dim=3);;
#@btime nanoper2(maximum,rand(480,241,365),dim=3);
#@btime nanoper2(minimum,rand(480,241,365),dim=3);
#@btime nanoper2(std,rand(480,241,365),dim=3);

@btime nanoper2(mean,rand(288,365),dim=2);
#@btime nanoper2(maximum,rand(480,241,365,4),dim=4);
#@btime nanoper2(minimum,rand(480,241,365,4),dim=4);
#@btime nanoper2(std,rand(480,241,365,4),dim=4);
