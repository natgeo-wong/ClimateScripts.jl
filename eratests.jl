using ClimateERA

global_logger(ConsoleLogger(stdout,Logging.Info))

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(1,1,1,0,init);
eradownload(emod,epar,ereg,etime,eroot)

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(2,1,1,0,init);
eradownload(emod,epar,ereg,etime,eroot)

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(1,3,1,0,init);
eradownload(emod,epar,ereg,etime,eroot)

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(2,3,1,0,init);
eradownload(emod,epar,ereg,etime,eroot)

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(1,1,3,0,init);
eradownload(emod,epar,ereg,etime,eroot)

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(2,1,3,0,init);
eradownload(emod,epar,ereg,etime,eroot)

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(1,3,3,0,init);
eradownload(emod,epar,ereg,etime,eroot)

init,eroot = erastartup(1,1);
emod,epar,ereg,etime = erainitialize(2,3,3,0,init);
eradownload(emod,epar,ereg,etime,eroot)

#init,eroot = erastartup(1,2);
#emod,epar,ereg,etime = erainitialize(2,1,3,0,init);
#eraanalyse(emod,epar,ereg,etime,eroot)
