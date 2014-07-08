cimport cpynanosvg

cdef class NSVGImage:
    cdef cpynanosvg.NSVGimage* _c_nsvgimage
    cdef cpynanosvg.NSVGrasterizer* _c_nsvgrasterizer

#    def __cinit__(self):

    def parse_from_file(self, filename, units, dpi):
        _filename = filename.encode('UTF-8')
        _units = units.encode('UTF-8')
        self._c_nsvgimage = cpynanosvg.nsvgParseFromFile(_filename, _units, dpi)
        return True

    def width(self):
        return self._c_nsvgimage.width

    def height(self):
        return self._c_nsvgimage.height

    def rasterize(self, tx, ty, scale, w, h, stride):
        self._c_nsvgrasterizer = cpynanosvg.nsvgCreateRasterizer()
        print("Rasterizing: ", tx, ty, scale, w, h, stride)
        cdef long _len = w * h * 4
        _dst = b''
        _dst += b"\0" * _len
        print("Allocated bytes: ", _len)
        cpynanosvg.nsvgRasterize(self._c_nsvgrasterizer, self._c_nsvgimage, tx, ty, scale, _dst, w, h, stride)
        print("Returned from rasterizing")
        return _dst
