function indicator = annualmean(data, var, output)
% annual mean for variable "var"

dates = data.dates;

min_year = min(dates(:, 1));
max_year = max(dates(:, 1));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));

for ifield = 1:length(fields)
    if ~strcmp(fields{ifield}, 'dates')
        idx = ifield;
    end
end

indicator.data  = NaN(size(min_year:max_year, 2), size(data.(fields{idx}), find(~time_dim)));
indicator.dates = NaN(size(min_year:max_year, 1));

if isfield(data, var)
    F = getfield(data, var);
else
    error(strcat('this indicator requires a data struct with .', var))
end

for y = min_year:max_year
    indicator.data(y-min_year +1, :) = squeeze(mean(F(dates(:, 1) == y, :), 1));
    indicator.dates(y - min_year +1, :) = y;
end

indicator.units = 'deg C';
indicator.var = strcat(['Annual mean of ', var]);
indicator.title = strcat(['Annual mean of ', var]);

if exist('output','var')
    assert(strcmp(output, 'matrix'))
    % output parameter exist, so output only the data matrix
    indicator = indicator.data;
end

end
