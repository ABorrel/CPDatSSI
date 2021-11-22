# CPDatSSI
This package is mapping any chemicals on the CPDAT database. 

# Installation
## Dependancy
- Python >= 3.6 with libraries
    - pip 
    - numpy

## Installation with pip
> $pip install -i https://test.pypi.org/simple/ CPDatSSI

<br>

# Run CPDatSSI
## In Python
> import CPDatSSI<br>
> pr_database = "< your path to the database >/CPDatRelease20201216/"<br>
> l_CASRN = ["106-50-3", "128-95-0", "2243-62-1", "112-38-9", "82-44-0", "2110-18-1"] # exemple of input<br>
> c_CPDAT = CPDatSSI.CPDatSSI(pr_database)<br>
> c_CPDAT.loadMapping()<br>
> c_CPDAT.listCasToFunct(l_CASRN)<br>
> out = c_CPDAT.extractBoardExposure()<br>
> print(out)<br>


## Script 
In the scripts folder in GitHub you can find a script to run CPDat in bash or powershell terminal.
> python generateBoardExposure.py -h


<br>

# Ressources 
### GitHub
> https://github.com/SilentSpringInstitute/CPDatSSI
### Package available: 
> https://test.pypi.org/project/CPDatSSI/ 

<br>

# Data input
CPDAT (version="20201216") exposure mapping <br>
Folder: /CPDat/CPDatRelease20201216/"<br>
Download CPDAT:
> https://epa.figshare.com/articles/dataset/The_Chemical_and_Products_Database_CPDat_MySQL_Data_File/5352997



\
&nbsp;

---
\
&nbsp;


# Project updates
- 10-12-21: init git
- 11-01-21: transform curent script to package available in pip

<br>

# TODO list
- Map on the dtxsid and remap on casrn

<br>

# Development command lines
> python -m unittest tests/testMapping.py #unit test on Chemical class <br>
> python setup.py sdist bdist_wheel <br>
> python -m twine upload --repository testpypi dist/* #upload on testpypi and precise the version<br>
> pip uninstall CPDatSSI<br>
> pip install -i https://test.pypi.org/simple/ CPDatSSI
