function indicator = grow_dd(data, thres)

dates = data.dates;

min_year = min(unique(dates(:, 1)));
max_year = max(unique(dates(:, 1)));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));
indicator.data  = NaN(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
indicator.dates = NaN(size(min_year:max_year, 1), 3);

if find(time_dim) ~= 1
    error('Transpose dimension of data vectors/arrays');
end

if ~isfield(data,'tas')
    error('this indicator requires a data struct with .tas ')    
end
if size(data.tas(dates(:, 1) == min_year, :), 1) < 360
   error('this indicator requires daily data')
end

beg_season = growseasonlength(data, 1); % get julian days of start date
end_season = growseasonlength(data, 2); % get julian days of end date

for y = min_year:max_year
    
    for i = 1:size(data.tas, 2)
        temp = data.tas(...
            datenum([y, 1, 1]) + beg_season.data(y - min_year + 1, i) <= datenum(dates) ...
            & datenum([y, 1, 1]) + end_season.data(y - min_year + 1, i) >= datenum(dates) & ...
            data.tas(:, i) >= thres, i);
        indicator.data(y-min_year +1, i) = sum(temp - thres, 1);
    end
    indicator.dates(y - min_year + 1, :) = [y 8 1];
end
indicator.units = [ 'DD > ' num2str(thres) ' C'];
indicator.dates(y - min_year + 1, :) = [y 8 1];
indicator.units = [ 'DD > ' num2str(thres) ' C'];
indicator.title = [ 'Growing Degree days  (> ' num2str(thres) ' C)'];
end