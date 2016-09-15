from math import *
import csv
import numpy as np

FR = 128000 #framerate

writerMsg = csv.writer(open("Msg.csv","wb"),delimiter='\n')
writerMI = csv.writer(open("mIdata.csv","wb"),delimiter='\n')
writerMQ = csv.writer(open("mQdata.csv","wb"),delimiter='\n')

f1 = 1100
f2 = 11000
kf = 10

Am1= 1
Am2= 1

m1 = Am1*11000
m2 = Am2*11000

Integrated_Msg = range(FR)
mIdata = range(FR)
mQdata = range(FR)
window = range(FR)

for i in range(FR):
	p = i*0.01/FR
	
	#Integrated_Msg list is for generating .csv file to test transmissin on IQ modulator board
	Integrated_Msg[i] = kf*(m1*(-np.cos(2*pi*p*f1)/(2*pi*f1))-m2*(np.cos(2*pi*p*f2)/(2*pi*f2)))
	#In-phase component
	mIdata[i] = np.cos(Integrated_Msg[i])
	#Quad-phase component
	mQdata[i] = np.sin(Integrated_Msg[i])


writerMI.writerow(mIdata)
writerMQ.writerow(mQdata)
