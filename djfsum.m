function indicator = djfsum(data, var)
% December to February sum for variable "var"

dates = data.dates;

min_year = min(dates(:, 1));
max_year = max(dates(:, 1));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));
indicator.data  = NaN(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
indicator.dates = NaN(size(min_year:max_year, 1));

if isfield(data, var)
    F = getfield(data, var);
else
    error(strcat('this indicator requires a data struct with .', var))
end

for y = min_year:max_year
    if y == min_year % do nothing, December is usually missing for first year
        indicator.dates(y - min_year +1, :) = y;
    else
        indicator.data(y - min_year + 1, :) = squeeze(...
            sum(F(dates(:, 1) == y - 1 & dates(:, 2) == 12, :)) ...
            + sum(F(dates(:, 1) == y & dates(:, 2) >= 1 & dates(:, 2) <= 2, :)) ...
            );
        indicator.dates(y - min_year +1, :) = y;
    end
end

indicator.units = 'deg C';
indicator.var = strcat(['DJF sum of ', var]);
indicator.title = strcat(['DJF sum of ', var]);

end