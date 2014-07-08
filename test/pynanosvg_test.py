from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.app import App
from kivy.uix.image import Widget, Image
from kivy.graphics.texture import Texture
from functools import partial
from pynanosvg import NSVGImage
from kivy.graphics import Rectangle
from datetime import datetime

class TestNanoSvg(App):

    _svg = None
    _loc_x = 0
    _loc_y = 0
    _buf = None
    _tex = None
    _w = 0
    _h = 0

    def setup(self):
        t1 = datetime.now()
        self._svg = NSVGImage()
        self._svg.parse_from_file("/home/ron/src/pynanosvg/test/232.svg", "px", 96.0)
        _tx = 0.0
        _ty = 0.0
        _scale = 0.6
        self._w = int(self._svg.width())
        self._h = int(self._svg.height())
        _stride = self._w * 4
        self._buf = self._svg.rasterize(_tx, _ty, _scale, self._w, self._h, _stride)
        self._tex = Texture.create(size=(self._w,self._h), colorfmt='rgba')
        assert isinstance(self._tex, Texture)
        self._tex.blit_buffer(self._buf, colorfmt='rgba', bufferfmt='ubyte')
        self._tex.flip_vertical()
        print("Total setup time: ", (datetime.now()-t1))
        return

    def draw_svg(self, wid, largs):
        t1 = datetime.now()
        assert isinstance(wid, Widget)
        wid.canvas.clear()
        with wid.canvas:
            Rectangle(texture=self._tex, pos=(self._loc_x, self._loc_y), size=(self._w,self._h))
        self._loc_x+=1
        self._loc_y+=1
        print("Total draw time: ", (datetime.now()-t1))
        return None

    def reset_svg(self):
        print("Resetting...")
        return None

    def build(self):
        t1 = datetime.now()
        print("Building...")

        wid = Widget(width=1000, height=1000)

        btn_draw = Button(text='Draw SVG', on_press=partial(self.draw_svg, wid))

        btn_reset = Button(text='Reset', on_press=self.stop)

        layout = BoxLayout(size_hint=(1, None), height=50)
        layout.add_widget(btn_draw)
        layout.add_widget(btn_reset)

        root = BoxLayout(orientation='vertical')
        root.add_widget(layout)
        root.add_widget(wid)
        self.setup()
        print("Total build time: ", (datetime.now()-t1))
        return root

if __name__ == '__main__':
    TestNanoSvg().run()
