# cython: c_string_encoding=ascii

cdef extern from "nanosvg.h":

    ctypedef struct NSVGshape:
        pass

    ctypedef struct NSVGimage:
        float width
        float height
        NSVGshape* shapes

    NSVGimage* nsvgParseFromFile(char* filename, char* units, float dpi)
    NSVGimage* nsvgParse(char* input, char* units, float dpi)
    void nsvgDelete(NSVGimage* image)

cdef extern from "nanosvgrast.h":

    ctypedef struct NSVGrasterizer:
        pass
    void nsvgRasterize(NSVGrasterizer* r, \
				   NSVGimage* image, float tx, float ty, float scale, \
				   char* dst, int w, int h, int stride)
    void nsvgDeleteRasterizer(NSVGrasterizer* r)
    NSVGrasterizer* nsvgCreateRasterizer()
