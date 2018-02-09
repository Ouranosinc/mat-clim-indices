function indicator = cnfd(data, output)

dates = data.dates;

min_year = min(unique(dates(:, 1)));
max_year = max(unique(dates(:, 1)));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));
indicator.data  = NaN(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
indicator.dates = NaN(size(min_year:max_year, 1), 3);

deb = lastspringfrost(data, 0);
fin = firstfallfrost(data, -2);

indicator.data = datenum(fin.data)-datenum(deb.data);
indicator.dates = deb.dates;
indicator.units = 'length of season, in days';
indicator.title = 'Length of frost-free season (days)';

if exist('output','var')
    assert(strcmp(output, 'matrix'))
    % output parameter exist, so output only the data matrix
    indicator = indicator.data;
end


end