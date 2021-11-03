import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="CPDatSSI", # Replace with your own username
    version="0.1alpha",
    author="Alexandre Borrel",
    author_email="borrel@silentspring.org",
    description="Package to map chemicals on the CPDat database v.2020-12-16",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/SilentSpringInstitute/CPDatSSI",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.9',
    test_suite='nose.collector',
    tests_require=['nose'],
)