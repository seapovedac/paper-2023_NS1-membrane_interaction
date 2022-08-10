# Command grace: xmgrace -settype xydy 0.ug_average_curve_1.dat 0.br_average_curve_1.dat difference.dat difference_point.dat mutation.dat -p par_of1.par

import numpy as np

file1 = '0.ug_average_curve_1.dat'
file2 = '0.br_average_curve_1.dat'

file_xvg1=open('threshold_ug.xvg', 'w+')
file_xvg2=open('threshold_br.xvg', 'w+')

threshold_dif = 0.1
#threshold_oc = 0.5

for cc in np.arange(0, 1.1, 0.1):

	threshold_oc = round(cc,1)

	print('Threshold: ', threshold_oc)

	name1='difference_cutoff'+str(threshold_oc)+'.dat'
	name2='difference_point_cutoff'+str(threshold_oc)+'.dat'

	file_out1 = open(name1, 'w+')
	file_out2 = open(name2, 'w+')

	with open(file1, 'r') as f:
		data1 = [d for d in f.read().split('\n') if d != '']

	with open(file2, 'r') as f:
		data2 = [d for d in f.read().split('\n') if d != '']

	# Getting occupied fractions

	list_r1 = []
	list_of1 = []
	list_ofd1 = []
	for d in data1:
		res, of, of_dev = d.split()
		list_r1.append(int(res))
		list_of1.append(round(float(of),10))
		list_ofd1.append(float(of_dev))

	list_r2 = []
	list_of2 = []
	list_ofd2 = []
	for d in data2:
		res, of, of_dev = d.split()
		list_r2.append(int(res))
		list_of2.append(round(float(of),10))
		list_ofd2.append(float(of_dev))

	# Calculation of the difference between the two occupied fraction

	list_dif = []
	deviation_overlap = []
	zip_object = zip(list_r1, list_of1, list_of2, list_ofd1, list_ofd2)

	num_dif=0
	positive=0
	negative=0
	for list_r, list1_i, list2_i, list1_i_dev, list2_i_dev in zip_object:

		difference = list1_i-list2_i
		list_dif.append(list1_i-list2_i)
		file_out1.write(f'{list_r}\t{difference} 0\n')

		try:
			# Data 1							
			a1 = list1_i - list1_i_dev
			b1 = list1_i + list1_i_dev
			range_data1 = np.arange(a1, b1+0.00001, 0.00001)

		except ValueError:
			# Data 1							
			a1 = list1_i - 0
			b1 = list1_i + 0
			range_data1 = np.arange(a1, b1+0.00001, 0.00001)
			print(f'Error in position {list_r}: y={list1_i} {list1_i_dev}')

		try:
			# Data 2
			a2 = list2_i - list2_i_dev
			b2 = list2_i + list2_i_dev
			range_data2 = np.arange(a2, b2+0.00001, 0.00001)
		except ValueError:
			# Data 2
			a2 = list2_i - 0
			b2 = list2_i + 0
			range_data2 = np.arange(a2, b2+0.00001, 0.00001)
			print(f'Error in position {list_r}: y={list2_i} {list2_i_dev}')
			

		list_verify = []

		# Checking if any value of data2 belong to interval a1, b1
		for rr in range_data2:

			verify = min(a1, b1) <= rr <= max(a1, b1)

			if list1_i != 0:
				list_verify.append(verify)

		# Checking if any value of data1 belong to interval a2, b2
		for rr in range_data1:

			verify = min(a2, b2) <= rr <= max(a2, b2)

			if list2_i != 0:
				list_verify.append(verify)

		# Selecting the relevant values
		if True in list_verify:
			pass

		elif list1_i != list2_i and list1_i >= threshold_oc or list2_i >= threshold_oc:
		
			if abs(difference) > threshold_dif:

				print(f'{list_r}, {list1_i:.3f} ({list1_i_dev:.3f}),  {list2_i:.3f} ({list2_i_dev:.3f}), {difference:5.3f}')

				if difference > 0:
					positive+=1
				elif difference < 0:
					negative+=1
			
				file_out2.write(f'{list_r}\t{difference} 0\n')
				file_out2.write(f'&\n')
				num_dif+=1

	print(f'Number of relevant points: {num_dif}')
	print(f'Positive relevant points: {positive}')
	print(f'Negative relevant points: {negative}')

	file_xvg1.write(f'{threshold_oc} {positive}\n')
	file_xvg2.write(f'{threshold_oc} {negative}\n')

	file_out1.close()
	file_out2.close()

file_xvg1.close()
file_xvg2.close()


