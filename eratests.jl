using ClimateERA

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(1,1,1,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(2,1,1,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(1,3,1,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(2,3,1,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(1,1,3,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(2,1,3,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(1,3,3,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(2,3,3,0,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,2,"/n/kuangdss01/users/nwong/ecmwf/");
emod,epar,ereg,time = erainitialize(2,1,3,0,init);
eraanalyse(emod,epar,ereg,time,eroot)
