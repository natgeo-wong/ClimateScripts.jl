using ClimateSatellite
using NCDatasets, Seaborn, DelimitedFiles

global_logger(ConsoleLogger(stderr,Logging.Info))

user = "natgeo.wong@outlook.com";
rvec = ["SGP"];
ddir = "/n/kuangdss01/user/nwong/clisat/"

for yr = 2001, mo = 1 : 12
    clisatdownload("gpmimerg",Date(yr,mo),email=user,regions=rvec);
end
