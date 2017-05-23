function indicator = thresover(data, dates, var, th)

min_year = min(unique(dates(:, 1)));
max_year = max(unique(dates(:, 1)));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));
indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
indicator.dates = zeros(size(min_year:max_year, 1), 1);

if isfield(data, var)
    F = getfield(data, var);
else
    error(strcat('this indicator requires a data struct with .', var))
end

if size(data.tasmax(dates(:,1)==min_year,:),1)<360
    error('this indicator requires daily data')
end

for y = min_year:max_year
    temp = F(dates(:,1) == y, :);
    log = temp >= th;
    indicator.data(y - min_year + 1, :) = sum(log, 1);
    indicator.dates(y - min_year + 1, :) = y;
end
indicator.units = ['number occ. > ' num2str(th)];
end
