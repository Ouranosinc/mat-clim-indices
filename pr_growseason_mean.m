function indicator = pr_growseason_mean(data, dates)
  min_year = min(unique(dates(:, 1)));
  max_year = max(unique(dates(:, 1)));
  fields = fieldnames(data);
  time_dim = (size(data.(fields{1})) == size(dates,1));
  indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
  indicator.dates = zeros(size(min_year:max_year, 1), 3);
  if isfield(data,'tas')&isfield(data,'pr')
  else error('this indicator requires a data struct with .tas ans .pr')
  end
  time_dim = size(data.tas)==size(dates,1);
  if find(time_dim)~=1
    data.tas=data.tas';
    data.tasmin=data.tasmin';
    data.tasmax=data.tasmax';
    data.pr=data.pr';
  end
  time_dim = size(data.tas)==size(dates,1);

  if size(data.tas(dates(:,1)==min_year,:),find(time_dim))<360
    error('this indicator requires daily data')
  end
  indicator.data = zeros(size(min_year:max_year,1),size(data.pr,2));
  indicator.dates = zeros(size(min_year:max_year,1),3);
  beg_season = indicators_atlas_final(12.1,data,dates);
end_season = indicators_atlas_final(12.2,data,dates);
for y=min_year:max_year

  for i =1:size(data.tas,2)
    temp = data.pr(beg_season.data(y-min_year +1,i)+datenum([y 1 1])<=datenum(dates) & end_season.data(y-min_year +1,i)+datenum([y 1 1])>= datenum(dates),i);
    indicator.data(y-min_year +1,i) = sum(temp, 1);
  end
  indicator.dates(y-min_year +1,:) = [y 8 1];
end
indicator.units = [ 'mean precip during growing season (mm)'];
indicator.dates(y-min_year +1,:) = [y 8 1];
end
