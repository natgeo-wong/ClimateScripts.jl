using ClimateSatellite

global_logger(ConsoleLogger(stderr,Logging.Info))

user = "natgeo.wong@outlook.com";
rvec = ["TRP"];
ddir = "/n/kuangdss01/user/nwong/clisat/"

clisatdownload("mtpw2m",Date(2017,1),email=user,regions=rvec);
