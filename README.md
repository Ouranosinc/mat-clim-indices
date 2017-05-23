# mat-clim-indices
This repo is for Climate indices in MATLAB.

# Information
The functions takes a data structure with the variables as fields. The variables array can be of dimensions 1, 2 or 3.

The data struct is as follows.

```matlab
data.tasmin % Daily minimum temperature
data.tasmax % Daily maximum temperature
data.pr % Daily precipitation accumulation
data.tas % Daily mean temperature
data.dates % Dates vector
```

A time vector of size `MxN` is also necessary in the data struct, where `M` is the number of timesteps and `N` has at least a length of 3 (year, month, day). This can be created by the `MATLAB` function `datevec`.

Some functions needs other argument, such as the variable field. For example, `tas`, `pr`, `tasmax`, `tasmin` is needed for functions that calculate annual means, max and minium (i.e. `annualmean`, `annualmin`, `annualmax`).

*N.B. It is not necessary to have all variables (e.g. `.tasmin`, `.tasmax`, `.pr` and `.tas`) in the data struct if the called functions does not need it. However, the `.dates` field is necessary.*

# Functions

The functions returns a struct.

```matlab
indicator.data % Data array
indicator.dates % Date array
indicator.units % Unit
```

### Annual mean
```matlab
indicator = annualmean(data, var::String)

Defn. Returns the annual mean values of variable 'var'.
```

### Annual maximum
```matlab
indicator = annualmax(data, var::String)

Defn. Returns the annual maximum values of variable 'var'.
```

### Annual minimum
```matlab
indicator = annualmin(data, var::String)

Defn. Returns the annual minimum values of variable 'var'.
```

### Annual sum
```matlab
indicator = annualsum(data, var::String)

Defn. Returns the annual summation of variable 'var'.
```

### Growing season (length, start date, end date)
```matlab
indicator = growseasonlength(data, code::Int)

Defn. Returns the length of the growing season. Needs variable 'tas' in data struct.
Code = 1 return the start date of the growing season (julian day)
Code = 2 return the end date of the growing season (julian day)
Code = 3 return the length of the growing season (days)
```

### Mean precipitation during the growing season
```matlab
indicator = pr_growseason_mean(data)

Defn. Mean precipitation during the growing season. Needs variables 'pr' and 'tas' in data struct.
```

### Precipitation during the growing season
```matlab
indicator = pr_growseason(data)

Defn. Precipitation total during the growing season. Needs variables 'pr' and 'tas' in data struct.
```

### Annual frequency over a threshold
```matlab
indicator = thresover(data, var, thres::Int/Float)

Defn. Returns the frequency of tasmax over a custom threshold 'thres'. Needs variables 'tasmax' data struct.
```

### Unités thermique du maïs (Corn Heat Unit)
```matlab
indicator = utm(data)

Defn. Returns the value of 'Unités thermiques maïs'.
```

### Degree days during growing season
```matlab
indicator = grow_dd(data, thres::Float)

Defn. Returns the growing degree days, as defined by the cumulative temperature over the threshold 'thres'.
```

### Last spring frost
```matlab
indicator = lastspringfrost(data, thres::Float)

Defn. Returns the julian day of the last spring frost with respect to threshold 'thres' (usually 0 Celsius).
```

### Length of frost free season
```matlab
indicator = cnfd(data)

Defn. Returns the length of the frost-free season. Hardcoded to lastspringfrost of 0 Celsius and firstfallfrost of -2 Celsius.

N.B. cnfd stands for "consecutive no frost days".
```

### First fall frost
```matlab
indicator = firstfallfrost(data, thres::Float)

Defn. Returns the julian day of the first spring frost with respect to threshold 'thres' (usually -2 Celsius)
```
