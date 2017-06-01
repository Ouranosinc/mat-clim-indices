function indicator = jjasum(data, var)
  % June to August sum for variable "var"
  
  dates = data.dates;
  
  min_year = min(dates(:, 1));
  max_year = max(dates(:, 1));
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
    indicator.data(y - min_year + 1, :) = squeeze(sum(F(dates(:, 1) == y & dates(:, 2) >= 6 & dates(:, 2) <= 8, :)));
    indicator.dates(y - min_year +1, :) = y;
  end
  
  indicator.units = 'deg C';
  indicator.var = strcat(['JJA sum of ', var]);
  indicator.title = strcat(['JJA sum of ', var]);
end