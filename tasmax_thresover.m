function indicator = tasmax_thresover(data, dates, th)
  min_year = min(unique(dates(:, 1)));
  max_year = max(unique(dates(:, 1)));
  fields = fieldnames(data);
  time_dim = (size(data.(fields{1})) == size(dates,1));
  indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
  indicator.dates = zeros(size(min_year:max_year, 1), 3);
  if isfield(data,'tasmax')
  else error('this indicator requires a data struct with .tasmax ')
  end
  error('this now goes in the exception, w/ dep seuil')
  if size(data.tasmax(dates(:,1)==min_year,:),1)<360
    error('this indicator requires daily data')
  end
  % th = 100*rem(code,1); % get thresh temperature from code

  if round(th)== round(30)

    thresh =prctile(data.tasmax(:),98.9);
  elseif round(th)== round(35)
    thresh =prctile(data.tasmax(:),99.9);
  end
  for y=min_year:max_year
    temp = data.tas(dates(:,1)==y,:);
    log=temp>=thresh;
    indicator.data(y-min_year +1,:)=sum(log,1);
    indicator.dates(y-min_year +1,:) = [y 8 1];
  end
  indicator.units = ['number occ. T>' num2str(thresh) ...
  '(eq. of ' num2str(th) ')'];
end
