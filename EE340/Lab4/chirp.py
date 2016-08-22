#Chirp.py: Generating wideband signal into .csv file
#Installing numpy: sudo apt-get install python-numpy 
from math import *				# Import Math Library
import csv					# For getting matrix in CSV file 
import numpy					# For numerical and matrix operations 

N = 1000 					# N is total number of samples
w=2*pi*0.01/(N-1)				# Digital Frequency
data=numpy.zeros(N)				# Define Container array for samples 1xN
for n in range(1,N):		
	data[n]=((sin(w*n))/(w*n))**2			# Collect Samples in Data array
a = numpy.array([range(1,N+1), data])           # Matrix 2xN 
b = a.transpose()				# Output Matrix	Nx2
numpy.savetxt("Wave.csv", b, delimiter=",")	# Save output in file "Wave.csv"






