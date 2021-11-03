# CPDatSSI
This package is mapping any chemicals on the CPDAT database. 


# Data input
CPDAT (version="20201216") exposure mapping <br>
Folder: /CPDat/CPDatRelease20201216/"

# Installation

# GitHub
https://github.com/SilentSpringInstitute/CPDatSSI


# Project updates
- 10-12-21: init git
- 11-01-21: transform curent script to package available in pip

# TODO list
- Map on the dtxsid and remap on casrn

# Development command line
$python -m unittest tests/testMapping.py #unit test on Chemical class <br>
$python setup.py sdist bdist_wheel <br>
$python -m twine upload --repository testpypi dist/* #upload on testpypi and precise the version<br>