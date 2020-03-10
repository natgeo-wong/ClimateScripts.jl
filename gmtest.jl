using ClimateShallowWater
using Seaborn

cd("/Users/natgeo-wong/Codes/JuliaClimate/ClimateScripts.jl/");
xvec1 = convert(Array,-15:0.1:30); yvec1 = convert(Array,-7.5:0.1:7.5);
xvec2 = convert(Array,-15:30); yvec2 = convert(Array,-7:7);

############## Default Gill-Matsuno ###################

g = 1; β = 0.5; A = 1; α = 0.1; L = 2; H = 1;
u1,v1,ϕ1 = GM(xvec1,yvec1,g,β,A,α,L,H);
u2,v2,ϕ2 = GM(xvec2,yvec2,g,β,A,α,L,H);
close(); figure(figsize=(18.5,5),dpi=200);
contourf(xvec1,yvec1,ϕ1); colorbar(); axis("scaled");
quiver(xvec2,yvec2,u2,v2,scale=40,width=0.0015);
savefig("GManadefault.png",bbox_inches="tight")
gcf()

############### Small Alpha ###################

g = 1; β = 0.5; A = 1; α = 0; L = 2; H = 1;
u1,v1,ϕ1 = GM(xvec1,yvec1,g,β,A,α,L,H);
u2,v2,ϕ2 = GM(xvec2,yvec2,g,β,A,α,L,H);
close(); figure(figsize=(18.5,5),dpi=200);
contourf(xvec1,yvec1,ϕ1); colorbar(); axis("scaled");
quiver(xvec2,yvec2,u2,v2,scale=40,width=0.0015);
plot([-L,-L],[-7.5,7.5],"--k",linewidth=1)
plot([L,L],[-7.5,7.5],"--k",linewidth=1)
savefig("GManasmallalpha.png",bbox_inches="tight")
gcf()

############## Small Height ###################

g = 1; β = 0.5; A = 1; α = 0.1; L = 2; H = 0.001;
close(); figure(figsize=(18.5,11),dpi=200);

subplot(211)
u1,v1,ϕ1 = GM(xvec1,yvec1,g,β,A,α,L,H);
u2,v2,ϕ2 = GM(xvec2,yvec2,g,β,A,α,L,H);
contourf(xvec1,yvec1,ϕ1); colorbar(); axis("scaled");
quiver(xvec2,yvec2,u2,v2,scale=40,width=0.0015);

subplot(212)
u1,v1,ϕ1 = GMsmallH(xvec1,yvec1,β,A,α,L);
u2,v2,ϕ2 = GMsmallH(xvec2,yvec2,β,A,α,L);
contourf(xvec1,yvec1,ϕ1); colorbar(); axis("scaled");
quiver(xvec2,yvec2,u2,v2,scale=500,width=0.0015);

savefig("GManasmallH.png",bbox_inches="tight")
gcf()

################## Small Coriolis #################

g = 1; β = 0.01; A = 1; α = 0.1; L = 2; H = 1;
close(); figure(figsize=(18.5,11),dpi=200);

subplot(211)
u1,v1,ϕ1 = GM(xvec1,yvec1,g,β,A,α,L,H);
u2,v2,ϕ2 = GM(xvec2,yvec2,g,β,A,α,L,H);
contourf(xvec1,yvec1,ϕ1); colorbar(); axis("scaled");
quiver(xvec2,yvec2,u2,v2,scale=40,width=0.0015);

subplot(212)
u1,v1,ϕ1 = GMsmallβ(xvec1,yvec1,β,A,α,g,H,L);
u2,v2,ϕ2 = GMsmallβ(xvec2,yvec2,β,A,α,g,H,L);
contourf(xvec1,yvec1,ϕ1); colorbar(); axis("scaled");
quiver(xvec2,yvec2,u2,v2,scale=100,width=0.0015);

savefig("GManasmallbeta.png",bbox_inches="tight")
gcf()
