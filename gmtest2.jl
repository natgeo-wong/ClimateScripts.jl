using GillMatsuno
using Seaborn

cd("/Users/natgeo-wong/Projects/JuliaClimate/");

ϕ,u,v = GMcalc(xmin=-10,xmax=20,ymin=-7.5,ymax=7.5,nt=1000,β=2);

close(); figure(figsize=(12.5,5),dpi=200);
contourf(-10:0.1:20,-7.5:0.1:7.5,transpose(ϕ));
colorbar(); axis("scaled");
savefig("testGMphi.png",bbox_inches="tight");
