#
f_in = 'density_con1.xvg'
f_out = 'density_con2.xvg'
factorx = 8.8
factory = ##factory##

new_den = open(f_out, 'w+')

with open(f_in, 'r') as f:
	data = [d for d in f.read().split('\n') if d != '']

for d in data:
	try:
		x, y, = d.split()
		x1 = float(x) - factorx
		y1 = float(y) * factory
		new_den.write(f'{x1}\t{y1}\n')
	except ValueError:
		new_den.write(f'{d}\n')

