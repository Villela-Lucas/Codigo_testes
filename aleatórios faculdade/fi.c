#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int Fi(int n){
	
	if (n<0){

		printf("\nN muito pequeno\n");
		exit(1);
	}
	else if (n<2){

		return 1;
	}
	else
		return (Fi(n-1)+Fi(n-2));
}

int main(){

	int n, print;

	printf("\nDigite N:\n");
	scanf("%d", &n);
	print = Fi(n);
	printf("\nFibonacci(%d) = %d \n\n", n, print);

return 0;
}