mini = min(SEM);
maxi = max(SEM);
p1=(maxi-mini)/12;
tam = 8;
fis = addvar(fis,'input','SEM',[mini maxi]);
fis = addmf(fis,'input',tam,'S6','trimf',[mini mini (mini+p1)]);
fis = addmf(fis,'input',tam,'S5','trimf',[mini (mini+p1) (mini+2*p1)]);
fis = addmf(fis,'input',tam,'S4','trimf',[(mini+p1) (mini+2*p1) (mini+3*p1) ]);
fis = addmf(fis,'input',tam,'S3','trimf',[(mini+2*p1) (mini+3*p1) (mini+4*p1)]);
fis = addmf(fis,'input',tam,'S2','trimf',[(mini+3*p1) (mini+4*p1) (mini+5*p1)]);
fis = addmf(fis,'input',tam,'S1','trimf',[(mini+4*p1) (mini+5*p1) (mini+6*p1)]);
fis = addmf(fis,'input',tam,'CE','trimf',[(mini+5*p1) (mini+6*p1) (mini+7*p1)]);
fis = addmf(fis,'input',tam,'B1','trimf',[(mini+6*p1) (mini+7*p1) (mini+8*p1)]);
fis = addmf(fis,'input',tam,'B2','trimf',[(mini+7*p1) (mini+8*p1) (mini+9*p1)]);
fis = addmf(fis,'input',tam,'B3','trimf',[(mini+8*p1) (mini+9*p1) (mini+10*p1)]);
fis = addmf(fis,'input',tam,'B4','trimf',[(mini+9*p1) (mini+10*p1) (mini+11*p1)]);
fis = addmf(fis,'input',tam,'B5','trimf',[(mini+10*p1) (mini+11*p1) (mini+12*p1)]);
fis = addmf(fis,'input',tam,'B6','trimf',[(mini+11*p1) maxi maxi]);