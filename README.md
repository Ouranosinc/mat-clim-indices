# mat-clim-indices
This repo is for Climate indices in MatLab.

# Information
All of the functions takes data structure such as:

```MATLAB
data.tasmin::Array
data.tasmax::Array
data.pr::Array
data.tas::Array
```

A time vector of size `MxN` is also necessary, where `M` is the number of timesteps and `N` has at least a length of 3 (year, month, day). This can be created by the `MATLAB` function `datevec`.

Some functions needs other argument, such as the variable field. For example, `tas`, `pr`, `tasmax`, `tasmin` is needed for functions that calculate annual means, max and minium (i.e. `annualmean`, `annualmin`, `annualmax`).

## Functions

The functions returns a struct.

```
indicator = annualmean(data::Struct, dates::datevec, var::String)

Defn. Returns the annual mean values of variable 'var'.
```

```
indicator = annualmax(data::Struct, dates::datevec, var::String)

Defn. Returns the annual maximum values of variable 'var'.
```

```
indicator = annualmin(data::Struct, dates::datevec, var::String)

Defn. Returns the annual minimum values of variable 'var'.
```

```
indicator = growseasonlength(data::Struct, dates::datevec)

Defn. Returns the length of the growing season. Needs variable 'tas' in data struct.
```

```
indicator = pr_growseason_mean(data::Struct, dates::datevec, var::String)

Defn. Mean precipitation during the growing season. Needs variables 'pr' and 'tas' in data struct.
```

```
indicator = tasmax_thresover(data::Struct, dates::datevec, thres::Int/Float)

Defn. Returns the frequency of tasmax over a custom threshold 'thres'.Needs variables 'tasmax' data struct.
```

```
indicator = utm(data::Struct, dates::datevec, thres::Int/Float)

Defn. Returns the value of 'Unités thermiques maïs'.
```
