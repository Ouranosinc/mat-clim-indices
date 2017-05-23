# mat-clim-indices
This repo is for Climate indices in MATLAB.

# Information
All of the functions takes data structure with the variables as fields. The variables array can be of dimensions 1, 2 or 3.

The data struct is as follows.

```matlab
data.tasmin
data.tasmax
data.pr
data.tas
```

A time vector of size `MxN` is also necessary, where `M` is the number of timesteps and `N` has at least a length of 3 (year, month, day). This can be created by the `MATLAB` function `datevec`.

Some functions needs other argument, such as the variable field. For example, `tas`, `pr`, `tasmax`, `tasmin` is needed for functions that calculate annual means, max and minium (i.e. `annualmean`, `annualmin`, `annualmax`).

## Functions

The functions returns a struct.

```matlab
indicator = annualmean(data, dates, var::String)

Defn. Returns the annual mean values of variable 'var'.
```

```matlab
indicator = annualmax(data, dates, var::String)

Defn. Returns the annual maximum values of variable 'var'.
```

```matlab
indicator = annualmin(data, dates, var::String)

Defn. Returns the annual minimum values of variable 'var'.
```

```matlab
indicator = growseasonlength(data, dates, code::Int)

Defn. Returns the length of the growing season. Needs variable 'tas' in data struct.
Code = 1 return the start date of the growing season (julian day)
Code = 2 return the end date of the growing season (julian day)
Code = 3 return the length of the growing season (days)
```

```matlab
indicator = pr_growseason_mean(data, dates)

Defn. Mean precipitation during the growing season. Needs variables 'pr' and 'tas' in data struct.
```

```matlab
indicator = tasmax_thresover(data, dates, thres::Int/Float)

Defn. Returns the frequency of tasmax over a custom threshold 'thres'. Needs variables 'tasmax' data struct.
```

```matlab
indicator = utm(data, dates)

Defn. Returns the value of 'Unités thermiques maïs'.
```
