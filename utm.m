function indicator = utm(data, dates)
  min_year = min(unique(dates(:, 1)));
  max_year = max(unique(dates(:, 1)));
  fields = fieldnames(data);
  time_dim = (size(data.(fields{1})) == size(dates,1));
  indicator.data  = zeros(size(min_year:max_year, 2), size(data.(fields{1}), find(~time_dim)));
  indicator.dates = zeros(size(min_year:max_year, 1), 3);
  if isfield(data,'tasmin')&&isfield(data,'tasmax')&&isfield(data,'tas')
  else error('this indicator requires a data struct with .tas, .tasmin and .tasmax ')
  end
  if size(data.tasmin(dates(:,1)==min_year,:),1)<360
    error('this indicator requires daily data')
  end

  spring_frost = indicators_atlas_final(5.0,data,dates);
  last_spring_frost=median(spring_frost.data,1);
  t128=12.8;
  AutomnFallFrost =indicators_atlas_final(6.2,data,dates);
  firstKillFrost = AutomnFallFrost.data;

  %error('not finished implementing')
  indicator.data = zeros(size(min_year:max_year,1),size(data.(fields{1}),2));
  indicator.dates = zeros(size(min_year:max_year,1),3);
  W=[ 1 1 1 1 1 ]./5;
  for y=min_year:max_year
    year_ind = AutomnFallFrost.dates(:,1)==y;
    temp_max = data.tasmax(dates(:,1)==y,:);
    temp_min = data.tasmin(dates(:,1)==y,:);
    temp_mean = data.tas(dates(:,1)==y,:);
    temp_dates= datenum(dates(dates(:,1)==y,:));
    days = unique(floor(temp_dates));
    for d =1:length(days)
      temp_mean_d = temp_mean(floor(temp_dates)==days(d),:);%this is to remove feb 29 and 30
      temp_min_d = temp_min(floor(temp_dates)==days(d),:);%this is to remove feb 29 and 30
      temp_max_d = temp_max(floor(temp_dates)==days(d),:);%this is to remove feb 29 and 30
      day_temp_mean(d,:) = temp_mean_d(end,:);
      day_temp_min(d,:) = temp_min_d(end,:);
      day_temp_max(d,:) = temp_max_d(end,:);
      day_dates(d,:)   = days(d);
    end
    clear temp
    for d =5:length(days)    %left running avg, value represents last of series of 5
      temp(d-4,:)         = W*day_temp_mean(d-4:d,:);%look out, matrix multiply
    end
    new_dates= days(5:end);

    %find beginning: when run. avg?12.8 for 1st time (5th day of
    %5-day run avg)
    first128=arrayfun(@(i) find(temp(:,i)>=t128&new_dates>last_spring_frost(:,i),1,'first'),1:size(temp,2),'UniformOutput',false);


    %find end: first kill frost (tmin< -2C)
    log2=day_temp_min<-2.;
    for i=1:length(first128)
      log2(1:first128{i},i) = 0;
    end
    %firstKillFrost =arrayfun(@(i) find(log2(:,i)~=0,1,'first'),1:size(log2,2),'UniformOutput',false);

    for i=1: size(log2,2)
      %if isempty(firstKillFrost{i})
      %   firstKillFrost{i} = length(day_dates);
      %end
      if isempty(first128{i})
        first128{i}= length(new_dates);
      end
      fin=find(day_dates-datenum([y,1,1])==floor(firstKillFrost(year_ind,i)));
      Ymax = 3.33* (day_temp_max(first128{i}:fin,i)-10) - ...
      0.084*(day_temp_max(first128{i}:fin,i)-10).*...
      (day_temp_max(first128{i}:fin,i)-10);

      Ymin = 1.8*(day_temp_min(first128{i}:fin,i)-4.4);

      Ymax(day_temp_max(first128{i}:fin,i)<10)=0;
      Ymin(day_temp_min(first128{i}:fin,i)<4.4)=0;

      if code == 13.1
        indicator.data(y-min_year +1,i)=new_dates(first128{i})-datenum([y,1,1]);
        % pas de -5 parceq u'on veut la cinquieme journee de la
        % serie de 5
        indicator.units = 'jour julien';
      elseif code == 13.2
        indicator.units = 'jour julien';

        indicator.data(y-min_year +1,i)=firstKillFrost(year_ind,i);
      elseif code ==13.3
        indicator.data(y-min_year +1,i)=sum((Ymax + Ymin)/2);
        indicator.units = 'UTM (cumul)';
      end
    end
    indicator.dates(y-min_year +1,:) = [y 8 1];

  end
end
