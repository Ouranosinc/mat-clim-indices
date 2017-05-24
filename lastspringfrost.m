function indicator = lastspringfrost(data, thres)

dates = data.dates;

min_year = min(unique(dates(:, 1)));
max_year = max(unique(dates(:, 1)));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));
indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
indicator.dates = zeros(size(min_year:max_year, 1), 3);

if ~isfield(data,'tasmin')
    error('this indicator requires a data struct with .tasmin ')
end

if size(data.tasmin(dates(:,1)==min_year,:),1)<360
    error('this indicator requires daily data')
end

for y = min_year:max_year
%     fgdata = dates(:, 1) == y & datenum([y, 8, 1]) >= datenum(dates);
    fgdata = dates(:, 1) == y & dates(:, 2) <= 8;
    temp = data.tasmin(fgdata, :);
    temp_dates = dates(fgdata, :);
    log = temp <= thres;
    for i = 1:size(log,2)
        last = find(log(:,i) ~= 0, 1, 'last');
        if isempty(last)
            last = 1;%put last spring frost on jan1st if no frost
        end
        indicator.data(y - min_year + 1, i, :) = datenum(temp_dates(last, :)) - datenum([y,1,1]);
    end
    indicator.dates(y - min_year + 1, :) = [y 8 1];
end
indicator.units = 'date';
