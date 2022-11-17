mini = min(PK4);
maxi = max(PK4);
fis = addvar(fis,'input','PK4',[mini maxi]);
fis = addmf(fis,'input',4,'S6','trimf',[mini mini (mini+p1)]);
fis = addmf(fis,'input',4,'S5','trimf',[mini (mini+p1) (mini+2*p1)]);
fis = addmf(fis,'input',4,'S4','trimf',[(mini+p1) (mini+2*p1) (mini+3*p1) ]);
fis = addmf(fis,'input',4,'S3','trimf',[(mini+2*p1) (mini+3*p1) (mini+4*p1)]);
fis = addmf(fis,'input',4,'S2','trimf',[(mini+3*p1) (mini+4*p1) (mini+5*p1)]);
fis = addmf(fis,'input',4,'S1','trimf',[(mini+4*p1) (mini+5*p1) (mini+6*p1)]);
fis = addmf(fis,'input',4,'CE','trimf',[(mini+5*p1) (mini+6*p1) (mini+7*p1)]);
fis = addmf(fis,'input',4,'B1','trimf',[(mini+6*p1) (mini+7*p1) (mini+8*p1)]);
fis = addmf(fis,'input',4,'B2','trimf',[(mini+7*p1) (mini+8*p1) (mini+9*p1)]);
fis = addmf(fis,'input',4,'B3','trimf',[(mini+8*p1) (mini+9*p1) (mini+10*p1)]);
fis = addmf(fis,'input',4,'B4','trimf',[(mini+9*p1) (mini+10*p1) (mini+11*p1)]);
fis = addmf(fis,'input',4,'B5','trimf',[(mini+10*p1) (mini+11*p1) (mini+12*p1)]);
fis = addmf(fis,'input',4,'B6','trimf',[(mini+11*p1) maxi maxi]);