function indicator = annualmin(data, dates)
  % annual mean temp
  min_year = min(unique(dates(:, 1)));
  max_year = max(unique(dates(:, 1)));
  fields = fieldnames(data);
  time_dim = (size(data.(fields{1})) == size(dates,1));
  indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
  indicator.dates = zeros(size(min_year:max_year, 1), 3);
  if isfield(data,'tasmin')
  else error('this indicator requires a data struct with .tasmin ')
  end
  for y=min_year:max_year
    indicator.data(y-min_year +1,:) = ...
    squeeze(min(data.tasmin(dates(:,1)==y,:),[],1));
    indicator.dates(y-min_year +1,:) = [y 8 1];
  end
  indicator.units = 'deg C';
end
