function indicator = annualmin(data, var)
  % annual min for variable "var"
  
  dates = data.dates;
  
  min_year = min(unique(dates(:, 1)));
  max_year = max(unique(dates(:, 1)));
  fields = fieldnames(data);
  time_dim = (size(data.(fields{1})) == size(dates,1));
  indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
  indicator.dates = zeros(size(min_year:max_year, 1));
  
  if isfield(data, var) 
      F = getfield(data, var);
  else
      error(strcat('this indicator requires a data struct with .', var))
  end
  
  for y = min_year:max_year
    
    indicator.data(y-min_year +1, :) = squeeze(min(F(dates(:, 1) == y, :)));
    indicator.dates(y - min_year +1, :) = y;
  end
  
  indicator.units = 'deg C';
  indicator.var = strcat(['Annual min of ', var]);
end
