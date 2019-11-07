using ClimateGNSS, ClimateEasy
global_logger(ConsoleLogger(stderr,Logging.Info))

stn = eosload(7);
gnssresort("EOS-SG","SMT","/n/holylfs/kuangdss01/users/nwong/data/")
