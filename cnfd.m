function indicator = cnfd(data)

dates = data.dates;

min_year = min(unique(dates(:, 1)));
max_year = max(unique(dates(:, 1)));
fields = fieldnames(data);
time_dim = (size(data.(fields{1})) == size(dates,1));
indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
indicator.dates = zeros(size(min_year:max_year, 1), 3);

deb = lastspringfrost(data, 0);
fin = firstfallfrost(data, -2);

indicator.data = datenum(fin.data)-datenum(deb.data);
indicator.units = 'length of season, in days';
indicator.dates = deb.dates;


end