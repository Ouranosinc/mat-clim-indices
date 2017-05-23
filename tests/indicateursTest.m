% Scripts for unit testing

clear;
% LOAD DATA
[folder, name, ext] = fileparts(which(mfilename('fullpath')));
% r = regexp(filepath, '/');
filepathdata = strcat(folder, '/data/data.mat');
load(filepathdata);

% ===============
% TESTS

%% annualmean
pr = annualmean(data, data.timevec, 'pr');
assert(roundn(min(pr.data), -3) == 2.199);
assert(roundn(max(pr.data), -3) == 2.514);
assert(length(pr.data) == 4);
assert(pr.dates(1) == 1950);
assert(pr.dates(end) == 1953);

%% Custom threshold over (frequency)
tx30 = thresover(data, data.timevec, 'tasmax', 30);
assert(tx30.data(1, 1) == 13);

%% Growing season length, start and end date
grseason = growseasonlength(data, data.timevec, 1); % start date
assert(grseason.data(1, 1) == 115);
grseason = growseasonlength(data, data.timevec, 2); % end date
assert(grseason.data(1, 1) == 313);
grseason = growseasonlength(data, data.timevec, 3); % length date
assert(grseason.data(1, 1) == 198);
