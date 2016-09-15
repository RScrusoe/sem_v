#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Thu Sep 15 06:53:25 2016
##################################################

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"

from gnuradio import analog
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio import wxgui
from gnuradio.eng_option import eng_option
from gnuradio.fft import window
from gnuradio.filter import firdes
from gnuradio.wxgui import fftsink2
from gnuradio.wxgui import forms
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import wx


class top_block(grc_wxgui.top_block_gui):

    def __init__(self):
        grc_wxgui.top_block_gui.__init__(self, title="Top Block")
        _icon_path = "/usr/share/icons/hicolor/32x32/apps/gnuradio-grc.png"
        self.SetIcon(wx.Icon(_icon_path, wx.BITMAP_TYPE_ANY))

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 32000
        self.s = s = 10e-6

        ##################################################
        # Blocks
        ##################################################
        _s_sizer = wx.BoxSizer(wx.VERTICAL)
        self._s_text_box = forms.text_box(
        	parent=self.GetWin(),
        	sizer=_s_sizer,
        	value=self.s,
        	callback=self.set_s,
        	label='s',
        	converter=forms.float_converter(),
        	proportion=0,
        )
        self._s_slider = forms.slider(
        	parent=self.GetWin(),
        	sizer=_s_sizer,
        	value=self.s,
        	callback=self.set_s,
        	minimum=0,
        	maximum=100e-3,
        	num_steps=100,
        	style=wx.SL_HORIZONTAL,
        	cast=float,
        	proportion=1,
        )
        self.Add(_s_sizer)
        self.wxgui_fftsink2_0 = fftsink2.fft_sink_f(
        	self.GetWin(),
        	baseband_freq=0,
        	y_per_div=10,
        	y_divs=10,
        	ref_level=0,
        	ref_scale=2.0,
        	sample_rate=samp_rate,
        	fft_size=1024,
        	fft_rate=15,
        	average=False,
        	avg_alpha=None,
        	title="FFT Plot",
        	peak_hold=False,
        )
        self.Add(self.wxgui_fftsink2_0.win)
        self.blocks_transcendental_0 = blocks.transcendental("exp", "float")
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_multiply_const_vxx_1 = blocks.multiply_const_vff((0.9, ))
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_vff((-(1000/50)*s, ))
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_float*1, "/home/rs/sem_v/EE340/Lab 6/Input (1).bin", True)
        self.blocks_divide_xx_0 = blocks.divide_ff(1)
        self.blocks_add_const_vxx_0 = blocks.add_const_vff((1, ))
        self.analog_const_source_x_0 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, 1)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_const_source_x_0, 0), (self.blocks_divide_xx_0, 0))    
        self.connect((self.blocks_add_const_vxx_0, 0), (self.blocks_divide_xx_0, 1))    
        self.connect((self.blocks_divide_xx_0, 0), (self.blocks_throttle_0, 0))    
        self.connect((self.blocks_file_source_0, 0), (self.blocks_multiply_const_vxx_0, 0))    
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.blocks_transcendental_0, 0))    
        self.connect((self.blocks_multiply_const_vxx_1, 0), (self.blocks_add_const_vxx_0, 0))    
        self.connect((self.blocks_throttle_0, 0), (self.wxgui_fftsink2_0, 0))    
        self.connect((self.blocks_transcendental_0, 0), (self.blocks_multiply_const_vxx_1, 0))    

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)
        self.wxgui_fftsink2_0.set_sample_rate(self.samp_rate)

    def get_s(self):
        return self.s

    def set_s(self, s):
        self.s = s
        self.blocks_multiply_const_vxx_0.set_k((-(1000/50)*self.s, ))
        self._s_slider.set_value(self.s)
        self._s_text_box.set_value(self.s)


def main(top_block_cls=top_block, options=None):

    tb = top_block_cls()
    tb.Start(True)
    tb.Wait()


if __name__ == '__main__':
    main()
