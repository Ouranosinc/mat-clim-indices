function indicator = annualmax(data, var)
  % annual max for variable "var"
  
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
    
    indicator.data(y-min_year +1, :) = squeeze(max(F(dates(:, 1) == y, :)));
    indicator.dates(y - min_year +1, :) = y;
  end
  
  indicator.units = 'deg C';
  indicator.var = strcat(['Annual max of ', var]);
  indicator.title = strcat(['Annual maximum of ', var]);
end