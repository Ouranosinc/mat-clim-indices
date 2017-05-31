function indicator = pr_growseason_mean(data)

dates = data.dates;

min_year = min(dates(:, 1));
max_year = max(dates(:, 1));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));
indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
indicator.dates = zeros(size(min_year:max_year, 1), 3);

if ~(isfield(data,'tas') && isfield(data,'pr'))
    error('this indicator requires a data struct with .tas ans .pr')
end

time_dim = size(data.tas) == size(dates,1);
if find(time_dim) ~= 1
    error('Transpose dimension of data vectors/arrays');
end

if size(data.tas(dates(:, 1) == min_year, :), find(time_dim)) < 360
    error('this indicator requires daily data')
end

beg_season = growseasonlength(data, 1);
end_season = growseasonlength(data, 2);

for y = min_year:max_year    
    for i = 1:size(data.tas,2)
        temp = data.pr(beg_season.data(y - min_year + 1, i) + datenum([y 1 1]) <= datenum(dates) ...
            & end_season.data(y - min_year + 1, i) + datenum([y 1 1]) >= datenum(dates), i);
        indicator.data(y-min_year +1,i) = sum(temp, 1) ./ length(temp);
    end
    indicator.dates(y-min_year +1,:) = [y 8 1];
end

indicator.units = 'mean precip during growing season (mm)';
indicator.dates(y - min_year + 1, :) = [y 8 1];
indicator.title = 'Mean precipitation during growing season (mm)';
end
