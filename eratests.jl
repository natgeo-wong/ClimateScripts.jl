using ClimateERA

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(1,1,0,1,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(2,1,0,1,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(1,3,0,1,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(2,3,0,1,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(1,1,0,3,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(2,1,0,3,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(1,3,0,3,init);
eradownload(emod,epar,ereg,time,eroot)

init,eroot = erastartup(1,1); emod,epar,ereg,time = erainitialize(2,3,0,3,init);
eradownload(emod,epar,ereg,time,eroot)
