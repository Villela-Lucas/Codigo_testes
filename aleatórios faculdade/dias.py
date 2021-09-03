tempo = input("Digite o numero de segundos: ")

dias = int(tempo)//(24*3600)
TR_1 = int(tempo)%(24*3600)
horas = int(TR_1)//3600
TR_2 = int(TR_1)%3600
minutos = int(TR_2)//60
segundos = int(TR_2)%60

print(dias, "dias,", horas, "horas,", minutos, "minutos e", segundos, "segundos.")