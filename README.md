# CPDatSSI
This package is mapping any chemicals on the CPDAT database. 

# Installation
### GitHub
> https://github.com/SilentSpringInstitute/CPDatSSI
### Package available: 
> https://test.pypi.org/project/CPDatSSI/ 
### Installation with pip: 
> $pip install -i https://test.pypi.org/simple/ CPDatSSI

\
&nbsp;
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

# TODO list
- Map on the dtxsid and remap on casrn

# Development command lines
> $python -m unittest tests/testMapping.py #unit test on Chemical class <br>
$python setup.py sdist bdist_wheel <br>
$python -m twine upload --repository testpypi dist/* #upload on testpypi and precise the version<br>

