#!/usr/bin/env python

from pynanosvg import NSVGImage
from datetime import datetime
from sys import path
import unittest

path.insert(0, "../src")

class ImageTest(unittest.TestCase):

    image_file = "./tiger.svg"

    def load_image(self, img, filename):
        success = img.parse_from_file(filename, "px", 96.0)
        self.assertTrue(success, "Failed to load test image file")
        return img

    def create_image(self):
        img = NSVGImage()
        self.assertIsNotNone(img, "Failed to initialize NSVGImage")
        return img

    def test_create_image(self):
        self.create_image()

    def test_load_image(self):
        img = self.create_image()
        self.load_image(img, self.image_file)

    def test_width_and_height(self):
        img = self.create_image()
        self.load_image(img, self.image_file)
        self.assertGreater(img.width(), 0, "Failed to determine image width")
        self.assertGreater(img.height(), 0, "Failed to determine image height")

    def test_rasterize(self):
        img = self.create_image()
        self.load_image(img, self.image_file)
        buffer = img.rasterize(0.0, 0.0, 1.0,
                                    img.width(), img.height(),
                                    img.width()*4)
        self.assertIsNotNone(buffer, "Failed to rasterize image")
        self.assertIsInstance(buffer, bytes, "Rasterize did not return a bytes object")
        self.assertGreater(len(buffer), 0, "Rasterize returned an empty buffer")

if __name__ == '__main__':
    unittest.main()
