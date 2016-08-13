% testing the Viterbi algorithm with the example from Wikipedia.

% Hidden States
% 1: healthy
% 2: fever

% Observations
% 1: dizzy
% 2: cold
% 3: normal

trans = [0.7,0.3;0.4,0.6];

emis_all = @(x) [0.1,0.6]*(x==1) + [0.4,0.3]*(x==2) + [0.5,0.1]*(x==3);
emis = [0.1,0.6;0.4,0.3;0.5,0.1];

init = [0.6,0.4];

signal = [3,2,1];

[seq,ll] = viterbi_algorithm(signal,trans,emis_all,emis,init)
