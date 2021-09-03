#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main (){

    int i, soma, T, N, j;
    
    printf("quantidade de testes: \n\n");
    scanf("%d", &T);
    getchar();
    i = 0;
    while (i<T) {
    	printf("\nquantidade de linhas (0<=linhas<=31): \n\n");
    	scanf("%d", &N);
    	while ((N<0) || (N>31)){
    		printf("Erro!, Fora da faixa de valores.\n\n");
    		scanf("%d", &N);
    		getchar();
    	}
    	j = 0;
    	while (j<N){
    		soma = 0;
    		soma = soma+(pow(2, N))-1;
    		j++;
    	}

    	printf("\nSOMA = %d\n", soma);
        i++;
    }
    
return 0;
}