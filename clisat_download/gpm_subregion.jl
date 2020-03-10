using ClimateSatellite

global_logger(ConsoleLogger(stderr,Logging.Info))

for mo = 1 : 12; clisatsubregion("gpmimerg",Date(2007,mo),region="JAV"); end
