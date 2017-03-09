function [ SDD, SEM ] = get_SEM_SDD( STD, ICC)
%Compute SEM and SDD from ICC and STD
%   Detailed explanation goes here

SEM=STD*sqrt(1-ICC);

SDD=1.96*SEM*sqrt(2);

end

