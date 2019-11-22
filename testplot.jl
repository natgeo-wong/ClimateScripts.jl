using PyPlot, Seaborn
using BenchmarkTools

function pyplotscatter(n::Integer)

    figure();
    x = rand(n); y = rand(n);
    scatter(x,y)
    savefig("/Users/natgeo-wong/pyplotscatter.png",transparent=true)
    close();

end

function pyplotcontourf(n::Integer)

    figure();
    x = 0:n; y = 0:n; z = rand(n+1,n+1); lvls = convert(Array,0:0.1:1);
    contourf(x,y,z,lvls)
    savefig("/Users/natgeo-wong/pyplotcontourf.png",transparent=true)
    close();

end

function seabornkde(n::Integer)

    figure();
    x = rand(n); y = rand(n);
    kdeplot(x,y,shade=true)
    savefig("/Users/natgeo-wong/seabornkde.png",transparent=true)
    close();

end

#@btime pyplotscatter(10)
#@btime pyplotscatter(100)
#@btime pyplotscatter(1000)

#@btime pyplotcontourf(10)
#@btime pyplotcontourf(100)
#@btime pyplotcontourf(1000)

@btime seabornkde(10)
@btime seabornkde(100)
@btime seabornkde(1000)
