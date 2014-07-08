from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

setup(
    name = "PyNanoSvg",
    ext_modules = cythonize([
    Extension("pynanosvg", ["pynanosvg.pyx"],
              include_dirs=["../../nanosvg/src"],
              library_dirs=["../../nanosvg/src"],
              libraries=["m","nanosvg"])
    ])
)
