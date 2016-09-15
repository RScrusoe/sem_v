#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Thu Sep 15 09:58:59 2016
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
from gnuradio import audio
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import filter
from gnuradio import gr
from gnuradio import wxgui
from gnuradio.eng_option import eng_option
from gnuradio.fft import window
from gnuradio.filter import firdes
from gnuradio.wxgui import fftsink2
from grc_gnuradio import wxgui as grc_wxgui
from math import pi
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
        self.samp_rate = samp_rate = 960e3

        ##################################################
        # Blocks
        ##################################################
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
        self.rational_resampler_xxx_1 = filter.rational_resampler_fff(
                interpolation=1,
                decimation=30,
                taps=None,
                fractional_bw=None,
        )
        self.iir_filter_xxx_2 = filter.iir_filter_ffd((10, ), (1, .95), True)
        self.iir_filter_xxx_1 = filter.iir_filter_ffd((1/(5e3), ), ([1,1]), True)
        self.iir_filter_xxx_0 = filter.iir_filter_ffd(([1,0.95]), ([1,0]), False)
        self.hilbert_fc_0 = filter.hilbert_fc(65, firdes.WIN_HAMMING, 6.76)
        self.dc_blocker_xx_0 = filter.dc_blocker_ff(8192, True)
        self.blocks_multiply_xx_0_0 = blocks.multiply_vcc(1)
        self.blocks_multiply_xx_0 = blocks.multiply_vcc(1)
        self.blocks_multiply_conjugate_cc_0 = blocks.multiply_conjugate_cc(1)
        self.blocks_delay_0 = blocks.delay(gr.sizeof_gr_complex*1, 1)
        self.blocks_complex_to_real_0 = blocks.complex_to_real(1)
        self.blocks_complex_to_arg_0 = blocks.complex_to_arg(1)
        self.blocks_add_xx_2 = blocks.add_vff(1)
        self.blocks_add_xx_1_0 = blocks.add_vff(1)
        self.blocks_add_xx_0 = blocks.add_vcc(1)
        self.audio_sink_0 = audio.sink(32000, "", True)
        self.analog_sig_source_x_3 = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, 1000, 1, 0)
        self.analog_sig_source_x_2_0 = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, 10000, 1, 0)
        self.analog_sig_source_x_1_0 = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, 5000, 1, 0)
        self.analog_sig_source_x_0_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, 300000, 1, 0)
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, -300000, 1, 0)
        self.analog_phase_modulator_fc_0 = analog.phase_modulator_fc(5e-6)
        self.analog_noise_source_x_0 = analog.noise_source_c(analog.GR_GAUSSIAN, 0.01, 0)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_noise_source_x_0, 0), (self.blocks_add_xx_0, 1))    
        self.connect((self.analog_phase_modulator_fc_0, 0), (self.blocks_multiply_xx_0_0, 0))    
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_multiply_xx_0, 1))    
        self.connect((self.analog_sig_source_x_0_0, 0), (self.blocks_multiply_xx_0_0, 1))    
        self.connect((self.analog_sig_source_x_1_0, 0), (self.blocks_add_xx_1_0, 1))    
        self.connect((self.analog_sig_source_x_2_0, 0), (self.blocks_add_xx_2, 1))    
        self.connect((self.analog_sig_source_x_3, 0), (self.blocks_add_xx_1_0, 0))    
        self.connect((self.blocks_add_xx_0, 0), (self.blocks_complex_to_real_0, 0))    
        self.connect((self.blocks_add_xx_1_0, 0), (self.blocks_add_xx_2, 0))    
        self.connect((self.blocks_add_xx_2, 0), (self.iir_filter_xxx_0, 0))    
        self.connect((self.blocks_complex_to_arg_0, 0), (self.iir_filter_xxx_2, 0))    
        self.connect((self.blocks_complex_to_real_0, 0), (self.hilbert_fc_0, 0))    
        self.connect((self.blocks_delay_0, 0), (self.blocks_multiply_conjugate_cc_0, 1))    
        self.connect((self.blocks_multiply_conjugate_cc_0, 0), (self.blocks_complex_to_arg_0, 0))    
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_delay_0, 0))    
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_multiply_conjugate_cc_0, 0))    
        self.connect((self.blocks_multiply_xx_0_0, 0), (self.blocks_add_xx_0, 0))    
        self.connect((self.dc_blocker_xx_0, 0), (self.audio_sink_0, 0))    
        self.connect((self.dc_blocker_xx_0, 0), (self.wxgui_fftsink2_0, 0))    
        self.connect((self.hilbert_fc_0, 0), (self.blocks_multiply_xx_0, 0))    
        self.connect((self.iir_filter_xxx_0, 0), (self.iir_filter_xxx_1, 0))    
        self.connect((self.iir_filter_xxx_1, 0), (self.analog_phase_modulator_fc_0, 0))    
        self.connect((self.iir_filter_xxx_2, 0), (self.rational_resampler_xxx_1, 0))    
        self.connect((self.rational_resampler_xxx_1, 0), (self.dc_blocker_xx_0, 0))    

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_0_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_1_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_2_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_3.set_sampling_freq(self.samp_rate)
        self.wxgui_fftsink2_0.set_sample_rate(self.samp_rate)


def main(top_block_cls=top_block, options=None):

    tb = top_block_cls()
    tb.Start(True)
    tb.Wait()


if __name__ == '__main__':
    main()
