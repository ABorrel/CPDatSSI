# CPDatSSI (V1.x)
This package is mapping any chemicals (from their CASRN) on the CPDAT database and provide a board exposure categorization. <br>
<i><b>Current Version 1.01 (11/23/2021)</i></b>

# Description
This package developed in python will allow to map any chemicals from their CASRN to an exposure board class using CPDAT database. <br>
Seven classes of board exposure are used:
- Pesticide: include pesticide or derivative chemicals
- Industrial: include produces found in industrial process
- Environemental: include exposure from environment, contaminated water, soil or air exposures
- Diet: include exposure chemicals found in the diet
- Pharmaceuticals: include pharmaceutical chemicals or drugs-like molecules
- Consumer products: include chemicals in consumer products

The mapping uses string terms in the different parts of the database. The all list of search terms is reported in the docs/ folder in the sources.

# Installation
## Dependancy
- Python >= 3.6 with libraries
    - pip 
    - numpy

## Installation with pip
> $pip install -i https://test.pypi.org/simple/ CPDatSSI

<br>

# Run CPDatSSI
## In Python - example of run
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
- 11-23-21: publish the version 1.0

# Version update
- v1.01: match search term "food contact" to Diet and Consumer Product and remove food contact categorie. Correct pharmaceuticals categorie name
<br>

# TODO list for futur version
- Map on DTXSID

<br>

# Development command lines
> python -m unittest tests/testMapping.py #unit test on Chemical class <br>
> python setup.py sdist bdist_wheel <br>
> python -m twine upload --repository testpypi dist/* #upload on testpypi and precise the version<br>
> pip uninstall CPDatSSI<br>
> pip install -i https://test.pypi.org/simple/ CPDatSSI
