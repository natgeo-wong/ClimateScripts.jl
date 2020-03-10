using DelimitedFiles
using PyPlot

cd("/Users/natgeo-wong/Projects/plot/")
xy = readdlm("/Users/natgeo-wong/Projects/plot/SGP.txt",'\t',comments=true);
x = xy[:,1]; y = xy[:,2];

close(); figure(figsize=(18,6),dpi=300)
plot(x,y,"k",linewidth=0.5);
axis("scaled"); xlim(103,105); ylim(1,2); grid("on")
xticks(103:0.1:105); yticks(1:0.1:2.0);
savefig("/Users/natgeo-wong/SGP.png",bbox_inches="tight")
gcf()
