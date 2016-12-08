#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Thu Oct 20 15:57:17 2016
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
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import filter
from gnuradio import gr
from gnuradio import wxgui
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from gnuradio.filter import pfb
from gnuradio.wxgui import forms
from gnuradio.wxgui import scopesink2
from grc_gnuradio import wxgui as grc_wxgui
from math import pi
from optparse import OptionParser
import numpy
import wx


class top_block(grc_wxgui.top_block_gui):

    def __init__(self):
        grc_wxgui.top_block_gui.__init__(self, title="Top Block")
        _icon_path = "/usr/share/icons/hicolor/32x32/apps/gnuradio-grc.png"
        self.SetIcon(wx.Icon(_icon_path, wx.BITMAP_TYPE_ANY))

        ##################################################
        # Variables
        ##################################################
        self.sps = sps = 4
        self.ntaps = ntaps = 1408
        self.nfilts = nfilts = 32
        self.excess_bw = excess_bw = 0.45
        self.timing_bw = timing_bw = 2*pi/100
        self.sr2 = sr2 = 300000
        self.samp_rate_0 = samp_rate_0 = 32000
        self.samp_rate = samp_rate = 100000
        self.s = s = .01
        self.rx_taps = rx_taps = filter.firdes.root_raised_cosine(nfilts, nfilts*sps, 1.0,excess_bw, ntaps)
        self.freq_bw = freq_bw = 2*pi/100
        self.fll_ntaps = fll_ntaps = 55

        ##################################################
        # Blocks
        ##################################################
        self.n = self.n = wx.Notebook(self.GetWin(), style=wx.NB_TOP)
        self.n.AddPage(grc_wxgui.Panel(self.n), "tab1")
        self.n.AddPage(grc_wxgui.Panel(self.n), "tab2")
        self.n.AddPage(grc_wxgui.Panel(self.n), "tab3")
        self.Add(self.n)
        self.wxgui_scopesink2_2 = scopesink2.scope_sink_c(
        	self.n.GetPage(1).GetWin(),
        	title="Scope Plot",
        	sample_rate=samp_rate,
        	v_scale=0,
        	v_offset=0,
        	t_scale=0,
        	ac_couple=False,
        	xy_mode=False,
        	num_inputs=1,
        	trig_mode=wxgui.TRIG_MODE_AUTO,
        	y_axis_label="Counts",
        )
        self.n.GetPage(1).Add(self.wxgui_scopesink2_2.win)
        self.wxgui_scopesink2_1 = scopesink2.scope_sink_f(
        	self.n.GetPage(0).GetWin(),
        	title="Scope Plot",
        	sample_rate=samp_rate,
        	v_scale=0,
        	v_offset=0,
        	t_scale=0,
        	ac_couple=False,
        	xy_mode=False,
        	num_inputs=1,
        	trig_mode=wxgui.TRIG_MODE_AUTO,
        	y_axis_label="Counts",
        )
        self.n.GetPage(0).Add(self.wxgui_scopesink2_1.win)
        self.wxgui_scopesink2_0 = scopesink2.scope_sink_c(
        	self.n.GetPage(2).GetWin(),
        	title="Scope Plot",
        	sample_rate=samp_rate,
        	v_scale=0,
        	v_offset=0,
        	t_scale=0,
        	ac_couple=False,
        	xy_mode=False,
        	num_inputs=1,
        	trig_mode=wxgui.TRIG_MODE_AUTO,
        	y_axis_label="Counts",
        )
        self.n.GetPage(2).Add(self.wxgui_scopesink2_0.win)
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
        	minimum=-5,
        	maximum=5,
        	num_steps=100,
        	style=wx.SL_HORIZONTAL,
        	cast=float,
        	proportion=1,
        )
        self.Add(_s_sizer)
        self.pfb_arb_resampler_xxx_0 = pfb.arb_resampler_ccf(
        	  4,
                  taps=(firdes.root_raised_cosine(32,32,1.0,0.45,1408)),
        	  flt_size=32)
        self.pfb_arb_resampler_xxx_0.declare_sample_delay(0)
        	
        self.iir_filter_xxx_0_0 = filter.iir_filter_ffd(([1.0001,-1]), ( [-1,1]), True)
        self.iir_filter_xxx_0 = filter.iir_filter_ffd((0.01, ), ( [-1,0.99]), True)
        self.digital_pfb_clock_sync_xxx_0 = digital.pfb_clock_sync_ccf(4, 2*pi/100, (rx_taps), 32, 16, 1.5, 1)
        self.digital_chunks_to_symbols_xx_0 = digital.chunks_to_symbols_bc((((1+1j),(1-1j),(-1+1j),(-1-1j))), 1)
        self.blocks_vco_c_0 = blocks.vco_c(samp_rate, -5, 1)
        self.blocks_udp_source_0 = blocks.udp_source(gr.sizeof_float*1, "127.0.0.1", 12345, 1472, True)
        self.blocks_udp_sink_0 = blocks.udp_sink(gr.sizeof_float*1, "127.0.0.1", 12345, 1472, True)
        self.blocks_threshold_ff_0_0 = blocks.threshold_ff(-.001, .001, 0)
        self.blocks_threshold_ff_0 = blocks.threshold_ff(-.001, .001, 0)
        self.blocks_sub_xx_0 = blocks.sub_ff(1)
        self.blocks_multiply_xx_2 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_1 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_0 = blocks.multiply_vcc(1)
        self.blocks_multiply_const_vxx_2 = blocks.multiply_const_vff((1, ))
        self.blocks_multiply_const_vxx_1 = blocks.multiply_const_vff((1.413, ))
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_vff((1.413, ))
        self.blocks_delay_0 = blocks.delay(gr.sizeof_float*1, 1000)
        self.blocks_complex_to_real_0 = blocks.complex_to_real(1)
        self.blocks_complex_to_imag_0 = blocks.complex_to_imag(1)
        self.blocks_add_const_vxx_0_0 = blocks.add_const_vff((-0.5, ))
        self.blocks_add_const_vxx_0 = blocks.add_const_vff((-0.5, ))
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_SIN_WAVE, 10, 1, 0)
        self.analog_random_source_x_0 = blocks.vector_source_b(map(int, numpy.random.randint(0, 4, 1000)), True)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_random_source_x_0, 0), (self.digital_chunks_to_symbols_xx_0, 0))    
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_multiply_xx_0, 1))    
        self.connect((self.blocks_add_const_vxx_0, 0), (self.blocks_multiply_const_vxx_0, 0))    
        self.connect((self.blocks_add_const_vxx_0_0, 0), (self.blocks_multiply_const_vxx_1, 0))    
        self.connect((self.blocks_complex_to_imag_0, 0), (self.blocks_multiply_xx_2, 1))    
        self.connect((self.blocks_complex_to_imag_0, 0), (self.blocks_threshold_ff_0_0, 0))    
        self.connect((self.blocks_complex_to_real_0, 0), (self.blocks_multiply_xx_1, 1))    
        self.connect((self.blocks_complex_to_real_0, 0), (self.blocks_threshold_ff_0, 0))    
        self.connect((self.blocks_delay_0, 0), (self.iir_filter_xxx_0_0, 0))    
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.blocks_multiply_xx_2, 0))    
        self.connect((self.blocks_multiply_const_vxx_1, 0), (self.blocks_multiply_xx_1, 0))    
        self.connect((self.blocks_multiply_const_vxx_2, 0), (self.blocks_delay_0, 0))    
        self.connect((self.blocks_multiply_xx_0, 0), (self.digital_pfb_clock_sync_xxx_0, 0))    
        self.connect((self.blocks_multiply_xx_1, 0), (self.blocks_sub_xx_0, 1))    
        self.connect((self.blocks_multiply_xx_2, 0), (self.blocks_sub_xx_0, 0))    
        self.connect((self.blocks_sub_xx_0, 0), (self.iir_filter_xxx_0, 0))    
        self.connect((self.blocks_threshold_ff_0, 0), (self.blocks_add_const_vxx_0, 0))    
        self.connect((self.blocks_threshold_ff_0_0, 0), (self.blocks_add_const_vxx_0_0, 0))    
        self.connect((self.blocks_udp_source_0, 0), (self.blocks_multiply_const_vxx_2, 0))    
        self.connect((self.blocks_vco_c_0, 0), (self.blocks_multiply_xx_0, 2))    
        self.connect((self.blocks_vco_c_0, 0), (self.wxgui_scopesink2_2, 0))    
        self.connect((self.digital_chunks_to_symbols_xx_0, 0), (self.pfb_arb_resampler_xxx_0, 0))    
        self.connect((self.digital_pfb_clock_sync_xxx_0, 0), (self.blocks_complex_to_imag_0, 0))    
        self.connect((self.digital_pfb_clock_sync_xxx_0, 0), (self.blocks_complex_to_real_0, 0))    
        self.connect((self.digital_pfb_clock_sync_xxx_0, 0), (self.wxgui_scopesink2_0, 0))    
        self.connect((self.iir_filter_xxx_0, 0), (self.blocks_udp_sink_0, 0))    
        self.connect((self.iir_filter_xxx_0, 0), (self.wxgui_scopesink2_1, 0))    
        self.connect((self.iir_filter_xxx_0_0, 0), (self.blocks_vco_c_0, 0))    
        self.connect((self.pfb_arb_resampler_xxx_0, 0), (self.blocks_multiply_xx_0, 0))    

    def get_sps(self):
        return self.sps

    def set_sps(self, sps):
        self.sps = sps
        self.set_rx_taps(filter.firdes.root_raised_cosine(self.nfilts, self.nfilts*self.sps, 1.0,self.excess_bw, self.ntaps))

    def get_ntaps(self):
        return self.ntaps

    def set_ntaps(self, ntaps):
        self.ntaps = ntaps
        self.set_rx_taps(filter.firdes.root_raised_cosine(self.nfilts, self.nfilts*self.sps, 1.0,self.excess_bw, self.ntaps))

    def get_nfilts(self):
        return self.nfilts

    def set_nfilts(self, nfilts):
        self.nfilts = nfilts
        self.set_rx_taps(filter.firdes.root_raised_cosine(self.nfilts, self.nfilts*self.sps, 1.0,self.excess_bw, self.ntaps))

    def get_excess_bw(self):
        return self.excess_bw

    def set_excess_bw(self, excess_bw):
        self.excess_bw = excess_bw
        self.set_rx_taps(filter.firdes.root_raised_cosine(self.nfilts, self.nfilts*self.sps, 1.0,self.excess_bw, self.ntaps))

    def get_timing_bw(self):
        return self.timing_bw

    def set_timing_bw(self, timing_bw):
        self.timing_bw = timing_bw

    def get_sr2(self):
        return self.sr2

    def set_sr2(self, sr2):
        self.sr2 = sr2

    def get_samp_rate_0(self):
        return self.samp_rate_0

    def set_samp_rate_0(self, samp_rate_0):
        self.samp_rate_0 = samp_rate_0

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.wxgui_scopesink2_0.set_sample_rate(self.samp_rate)
        self.wxgui_scopesink2_1.set_sample_rate(self.samp_rate)
        self.wxgui_scopesink2_2.set_sample_rate(self.samp_rate)

    def get_s(self):
        return self.s

    def set_s(self, s):
        self.s = s
        self._s_slider.set_value(self.s)
        self._s_text_box.set_value(self.s)

    def get_rx_taps(self):
        return self.rx_taps

    def set_rx_taps(self, rx_taps):
        self.rx_taps = rx_taps
        self.digital_pfb_clock_sync_xxx_0.update_taps((self.rx_taps))

    def get_freq_bw(self):
        return self.freq_bw

    def set_freq_bw(self, freq_bw):
        self.freq_bw = freq_bw

    def get_fll_ntaps(self):
        return self.fll_ntaps

    def set_fll_ntaps(self, fll_ntaps):
        self.fll_ntaps = fll_ntaps


def main(top_block_cls=top_block, options=None):

    tb = top_block_cls()
    tb.Start(True)
    tb.Wait()


if __name__ == '__main__':
    main()
