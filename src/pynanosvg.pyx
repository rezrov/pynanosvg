cimport cpynanosvg

cdef class NSVGImage:
    """Cython interface to nanosvg for parsing and rendering SVG images."""
    cdef cpynanosvg.NSVGimage* _c_nsvgimage
    cdef cpynanosvg.NSVGrasterizer* _c_nsvgrasterizer

    def __cinit__(self):
        self._c_nsvgrasterizer = cpynanosvg.nsvgCreateRasterizer()
        self._c_nsvgimage = NULL

    def parse_from_file(self, filename, units, dpi):
        """Reads and parses an SVG file. Units must be one of 'px', 'pt',
        'pc' 'mm', 'cm', or 'in'."""
        _filename = filename.encode('UTF-8')
        _units = units.encode('UTF-8')
        self._c_nsvgimage = cpynanosvg.nsvgParseFromFile(_filename, _units, dpi)
        return self._c_nsvgimage != NULL

    def width(self):
        """Returns the width of the parsed image."""
        if self._c_nsvgimage == NULL:
            return 0
        return self._c_nsvgimage.width

    def height(self):
        """Returns the height of the parsed image."""
        if self._c_nsvgimage == NULL:
            return 0
        return self._c_nsvgimage.height

    def rasterize(self, tx, ty, scale, w, h):
        """Returns a bytes object containing a rasterized rgba bitmap
        of the parsed SVG image."""
        if self._c_nsvgimage == NULL:
            return None
        w = int(w)
        h = int(h)
        _len = w * h * 4
        _stride = w * 4
        _buf = bytes(_len)
        cpynanosvg.nsvgRasterize(self._c_nsvgrasterizer,
                                 self._c_nsvgimage, tx, ty, scale,
                                 _buf, w, h, _stride)
        #print("NSVGImage: Rasterized image to bytes(", _len, ") with id ", id(_buf))
        return _buf

    def rasterize_to_buffer(self, tx, ty, scale, w, h, stride, buffer):
        """Places a rasterized rgba bitmap into a pre-allocated bytes
        object buffer. The buffer should be of size w * h * 4, and
        stride is generally w * 4."""
        if type(buffer) is not bytes:
            return False
        if self._c_nsvgimage == NULL:
            return False
        cpynanosvg.nsvgRasterize(self._c_nsvgrasterizer,
                                 self._c_nsvgimage, tx, ty, scale,
                                 buffer, w, h, stride)
        #print("NSVGImage: Rasterized image to buffer with id ", id(buffer))
        return buffer

    def __dealloc__(self):
        if self._c_nsvgrasterizer != NULL:
            cpynanosvg.nsvgDeleteRasterizer(self._c_nsvgrasterizer)
        if self._c_nsvgimage != NULL:
            cpynanosvg.nsvgDelete(self._c_nsvgimage)
        #print("NSVGImage: Deallocating ", id(self))
