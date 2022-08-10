strain=Ugandan
protein=ug
oligomer=dimer
num_rep=3
property=occupied_fraction_0.52
unit_time=ns
ff=MARTINI-ElNeDyn

ar_x1=0
ar_x2=352
maj_x=100

ar_y1=0
ar_y2=1
maj_y=0.2

leg_x=0.89
leg_y=0.8

rm -r $property
mkdir $property
cd $property
cp ../average.awk .
cp ../par_occupied_fraction.p .

gracebat ../${property}.xvg -saveall rep1.xvg
gracebat ../../../${protein}_${oligomer}.replica2/INTERFACE_A/${property}.xvg -saveall rep2.xvg
gracebat ../../../${protein}_${oligomer}.replica3/INTERFACE_A/${property}.xvg -saveall rep3.xvg

########################
# Separamos las curvas #
########################

for ((rep=1 ; rep<=${num_rep}; rep+=1)); do

arch=rep${rep}.xvg

grep -n "@type xy" $arch | cut -d ':' -f1 > hola1		# Detectamos comienzo de la curva
grep -n "&" $arch | cut -d ':' -f1 > hola2			# y final de la misma

l1=$(wc -l hola1 | cut -d ' ' -f1)

for ((i=1 ; i<=$l1 ; i+=1)); do

com=$(head -n$i hola1 | tail -n1)
fin=$(head -n$i hola2 | tail -n1)
com1=$[ $fin - $com - 1 ]
fin1=$[ $fin - 1 ]

head -n$fin1 $arch | tail -n $com1 > curve_rep${rep}.$i
wc -l curve_rep${rep}.$i >> line_curve

done
done

##################################################
# Dejamos todas las curvas con la misma longitud #
##################################################

min1=$(more line_curve | sort -n | head -n1 | cut -d ' ' -f1)

for ((rep=1 ; rep<=${num_rep}; rep+=1)); do
for ((i=1 ; i<=$l1 ; i+=1)); do

head -n$min1 curve_rep${rep}.$i | cut -d ' ' -f1 > curve.x.rep${rep}.$i 
head -n$min1 curve_rep${rep}.$i | cut -d ' ' -f2 > curve.y.rep${rep}.$i 

done
done

#############################
# Calculamos la curva media #
#############################

for ((i=1 ; i<=$l1 ; i+=1)); do

awk -f average.awk curve.x.rep[1-${num-rep}].$i > average.x
#awk -f average.awk curve.y.rep[1-${num-rep}].$i > average.y
awk '{a[FNR]+=$1; b[FNR]++; c[FNR]+=$1*$1 } 
     END{
        for(i=1;i<=FNR;i++)
          print a[i]/b[i], sqrt((c[i]-a[i]*a[i]/b[i])/(b[i]-1)) ;
     }' curve.y.rep* > average.y

paste average.x average.y > average_curve_$i.dat

done

rm average.x average.y 

##############################################
# Calculamos average and desviación estándar #
##############################################

for ((i=1 ; i<=$l1 ; i+=1)); do

avr=$(awk '{x+=$0;y+=$0}END{printf "%0.2f" , (y/NR)}' curve.y.rep[1-${num-rep}].$i)
dev=$(awk '{x+=$0;y+=$0^2}END{printf "%0.2f" , sqrt(y/NR-(x/NR)^2)}' curve.y.rep[1-${num-rep}].$i)
echo
echo "Property: ${property}"
echo "AVERAGE: $avr"
echo "ST DEV: $dev"
echo
echo $avr $dev >> data

done

cp par_occupied_fraction.p par_1.p

#####################
# Edición de figura #
#####################

avr=$(head -n$i data | tail -n1 | cut -d ' ' -f1)
dev=$(head -n$i data | tail -n1 | cut -d ' ' -f2)

sed "s/##av##/"${avr}"/g" par_1.p | sed "s/##dev##/"${dev}"/g" | sed "s/##ar_x1##/"${ar_x1}"/g" | sed "s/##ar_x2##/"${ar_x2}"/g" | sed "s/##ar_y1##/"${ar_y1}"/g" | sed "s/##ar_y2##/"${ar_y2}"/g" | sed "s/##maj_x##/"${maj_x}"/g" | sed "s/##maj_y##/"${maj_y}"/g" | sed "s/##leg_x##/"${leg_x}"/g" | sed "s/##leg_y##/"${leg_y}"/g" > par ; mv par par_1.p

sed 's/##strain##/'${strain}'/g' par_1.p | sed 's/##oligomer##/'${oligomer}'/g' | sed 's/##chain##/Chain '${chain}'/g' | sed 's/##forcefield##/'${ff}'/g' | sed 's/##unit_time##/'${unit_time}'/g' > par ; mv par par_1.p

gracebat curve_rep[1-${num_rep}].1 average_curve_[1-${i}].dat -p par_1.p -saveall average_${property}.xvg -hdevice PNG
 
rm curve* hola* line_curve data par_1.p rep* 

cd ..
