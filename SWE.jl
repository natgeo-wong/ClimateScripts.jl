using ClimateShallowWater
using Distributions, StatsPlots
gr()

g = 9.81; H = 500; dx = 0.1; r = 0.5;

"""
## 1D Example
dt = r * (dx*1000) / sqrt(g*H);
x = convert(Array,-20:dx:20); d = Normal(-5,0.5);
etam1 = pdf.(d,x); etan = pdf.(d,x);

anim = Animation()
for ii = 1 : (400/dt)
    plot(x,etan,xlims=(-20,20),ylims=(-1,1));
    if isinteger((ii-1)/2); frame(anim); end
    global etap1 = shallowwave1D(etan,etam1,r,"reflective");
    global etam1 = etan[:]; global etan = etap1[:];
end

mp4(anim,"/Users/natgeo-wong/SWE1Dtest_reflect.mp4",fps=30)
"""

## 2D Example
dt = r * (dx*1000) / (2*sqrt(g*H));
x = convert(Array,-20:dx:20); y = convert(Array,-20:dx:20); dr = sqrt.(x.^2 .+ y'.^2)
d = Normal(0,0.5); etam1 = pdf.(d,dr); etan = pdf.(d,dr);

anim = Animation()
for ii = 1 : (100/dt)
    plot(x,etan[201,:],xlims=(-20,20),ylims=(-1,1))
    if isinteger((ii-1)/2); frame(anim); end
    global etap1 = shallowwave2D(etan,etam1,r,"periodic");
    global etam1 = deepcopy(etan); global etan = deepcopy(etap1);
end

mp4(anim,"/Users/natgeo-wong/SWE2Dtest_period_profile.mp4",fps=30)
