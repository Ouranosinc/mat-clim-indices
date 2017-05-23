function indicator = growseasonlength(data, dates)
  min_year = min(unique(dates(:, 1)));
  max_year = max(unique(dates(:, 1)));
  fields = fieldnames(data);
  time_dim = (size(data.(fields{1})) == size(dates,1));
  indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
  indicator.dates = zeros(size(min_year:max_year, 1), 3);
  if isfield(data,'tas')
  else error('this indicator requires a data struct with .tas ')
  end
  time_dim = find(size(data.tas)==size(dates,1));
  if time_dim~=1
    data.tas=data.tas';
    data.tasmin=data.tasmin';
    data.tasmax=data.tasmax';
    data.pr=data.pr';
  end
  time_dim = size(data.tas)==size(dates,1);
  if size(data.tas(dates(:,1)==min_year,:),find(time_dim))<360
    error('this indicator requires daily data')
  end
  indicator.data = zeros(size(min_year:max_year,1),size(data.tas,find(~time_dim)));
  indicator.dates = zeros(size(min_year:max_year,1),3);
  t55 =5.5 ;%prctile(data.tasref(:),53.0);
  W=[ 1 4 6 4 1 ]./16;%,size(indicator.data,2),1)';  %running avg weights
  for y=min_year:max_year
    temp = data.tas(dates(:,1)==y,:);
    temp_dates= datenum(dates(dates(:,1)==y,:));
    days = unique(floor(temp_dates));
    for d =1:length(days)
      temp_d = temp(floor(temp_dates)==days(d),:);%this is to remove feb 29 and 30
      day_temp(d,:)    = temp_d(end,:);
      day_dates(d,:)   = floor(temp_dates(1))+d-1;
    end
    for d =3:length(days)-2    % center run avg, no values for 1st and last 2
      temp2(d-3+1,:)         = W*day_temp(d-2:d+2,:);%look out, matrix multiply
    end
    log   = temp2>=t55;
    cum_  = cumsum(log) ;
    cum_2 = (cum_(1+5:end,:)-cum_(1:end-5,:)) ==5; % find where run avg is 5.5 for 5 days
    first=arrayfun(@(i) find(cum_2(:,i)~=0,1,'first'),1:size(cum_2,2),'UniformOutput',false);
    last =arrayfun(@(i) find(log(:,i)~=0,1,'last'),1:size(log,2),'UniformOutput',false);
    for i=1:size(cum_2,2)
      %I want the 5th day of the series of 5,
      if code == 12.1

        try
          indicator.data(y-min_year +1,i)=day_dates(first{i}+2+5+1,:)-datenum([y 1 1]);
        catch
          indicator.data(y-min_year +1,i)=0;
        end
      elseif code == 12.2
        try
          indicator.data(y-min_year +1,i)=day_dates(last{i}+2,:)-datenum([y 1 1]);
        catch
          indicator.data(y-min_year +1,i)=0;
        end
      elseif code ==12.3
        try
          indicator.data(y-min_year +1,i)=day_dates(last{i}+2,:)-...
          day_dates(first{i}+2+5+1,:) ;
        catch
          indicator.data(y-min_year +1,i)=0;
        end
      end
    end
    indicator.dates(y-min_year +1,:) = [y 8 1];
    indicator.units = 'Growing season (dates or nb. days)';

  end
end