% Scripts for unit testing

clear;
% LOAD DATA
filepath = mfilename('fullpath');
r = regexp(filepath, '/');
filepathdata = strcat(filepath(1:r(end)), '/data/data.mat');
load(filepathdata);

% TESTS
pr = annualmean(data, data.timevec, 'pr');
assert(roundn(min(pr.data), -3) == 2.199);
assert(roundn(max(pr.data), -3) == 2.514);
assert(length(pr.data) == 4);
assert(pr.dates(1) == 1950);
assert(pr.dates(end) == 1953);
