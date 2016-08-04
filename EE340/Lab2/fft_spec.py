#!/usr/bin/env python
##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Mon Jun 22 11:49:29 2015
##################################################

from PyQt4 import Qt
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser
from math import ceil
import fullfft
import osmosdr
import sys
import time
#import tutorial
import matplotlib.pylab as plt
import numpy


from distutils.version import StrictVersion
class top_block(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "Top Block")
        Qt.QWidget.__init__(self)
        self.setWindowTitle("Top Block")
        try:
             self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
             pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.restoreGeometry(self.settings.value("geometry").toByteArray())


        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 2e6
        self.frq = []
        self.final = []
        ##################################################
        # Blocks
        ##################################################
        self.rtlsdr_source_0 = osmosdr.source( args="numchan=" + str(1) + " " + "" )
        self.rtlsdr_source_0.set_sample_rate(samp_rate)
        #self.rtlsdr_source_0.set_center_freq(100e6, 0)
        self.rtlsdr_source_0.set_freq_corr(0, 0)
        self.rtlsdr_source_0.set_dc_offset_mode(0, 0)
        self.rtlsdr_source_0.set_iq_balance_mode(0, 0)
        self.rtlsdr_source_0.set_gain_mode(False, 0)
        self.rtlsdr_source_0.set_gain(10, 0)
        self.rtlsdr_source_0.set_if_gain(20, 0)
        self.rtlsdr_source_0.set_bb_gain(20, 0)
        self.rtlsdr_source_0.set_antenna("", 0)
        self.rtlsdr_source_0.set_bandwidth(0, 0)
          
        self.fullfft_dft_py_fc_0 = fullfft.dft_py_fc()
        self.blocks_null_sink_0 = blocks.null_sink(gr.sizeof_float*1)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.fullfft_dft_py_fc_0, 0), (self.blocks_null_sink_0, 0))    
        self.connect((self.rtlsdr_source_0, 0), (self.fullfft_dft_py_fc_0, 0))    

    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "top_block")
        self.settings.setValue("geometry", self.saveGeometry())
        event.accept()

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.rtlsdr_source_0.set_sample_rate(self.samp_rate)

    def plot_fft(self,b):
        a = len(self.fullfft_dft_py_fc_0.output)
        
        for i in range(0,b):
            self.frq.append(i)
        plt.plot(self.frq,self.fullfft_dft_py_fc_0.output)
        plt.show()


if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"
    parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
    (options, args) = parser.parse_args()
    if(StrictVersion(Qt.qVersion()) >= StrictVersion("4.5.0")):
        Qt.QApplication.setGraphicsSystem(gr.prefs().get_string('qtgui','style','raster'))
    qapp = Qt.QApplication(sys.argv)
    an = []
    temp_f = []
    lf1 = float(input("Enter the start frequency in the range of FM (eg: 91) : "))
    uf1=float(input("Enter the stop frequency in the range of FM : "))
    r=int(uf1-lf1)
    lf=lf1*1e6
    for i in range(0,r):
        tb = top_block()
        a = lf + i*1e6    
        tb.rtlsdr_source_0.set_center_freq(a,0)
        tb.start()
        #tb.show()
        time.sleep(1.5)
        tb.stop()
        tb.wait()

        #def quitting():
        #    tb.stop()
        #    tb.wait()
        #qapp.connect(qapp, Qt.SIGNAL("aboutToQuit()"), quitting)
        #qapp.exec_()
        
        an.append(tb.fullfft_dft_py_fc_0.output)
        b = len(tb.fullfft_dft_py_fc_0.output)
        
        for j in range(0,b):
            temp_f.append(a+(j*1e6/b))
        
        
        print b
        print a
        tb = None #to clean up Qt widgets
    x =[]
    c = (1e6)/b
    print an[0][0]
    #print an[1][0]
    
    
    s = len(an)
    for q in range(0,s):
        l = len(an[q])
        for w in range(0,l):
            x.append(an[q][w])
    h = len(x)
    y = 20 * numpy.log10(x)
    f = []
    for j in range(0,h):
        k = 88e6 + j*c
        f.append(k)
    temp=numpy.asarray(temp_f)/1e6
    plt.plot(temp,y)
    plt.xlabel('Frequency (MHz) --->')
    plt.ylabel('Power Spectral Density (dB) --->')
    plt.show() 
    
    
    
  
