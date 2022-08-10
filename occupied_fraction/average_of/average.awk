{ if (FNR==1) file++
  for (i=1;i<=NF;i++) {
    sum[FNR" "i]+=$i
    count[FNR" "i]++
    data[file" "FNR" "i]=$i
  }
}END{
  for (i=1;i<=FNR;i++) {
    for (j=1;j<=NF;j++) {
      avg[i" "j]=sum[i" "j]/count[i" "j]
    }
  }
  for (f=1;f<=file;f++) {
    for (i=1;i<=FNR;i++) {
      for (j=1;j<=NF;j++) {
        tmp[i" "j]+=(data[f" "i" "j]-avg[i" "j])*(data[f" "i" "j]-avg[i" "j]);
      }
    }
  }
  for (i=1;i<=FNR;i++) {
    for (j=1;j<=NF;j++) {
      printf avg[i" "j]" "
    }
    for (j=1;j<=NF;j++) {
      #printf sqrt(tmp[i" "j]/count[i" "j])" "
    }
    printf "\n"
  }
}

#awk '{x+=$0;y+=$0^2}END{print sqrt(y/NR-(x/NR)^2)}'
#printf sum[i]/NR, sqrt(std[i]/(NR-1))

# awk -f average.awk ug_*
