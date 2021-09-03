#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/* 	--- COMPILADOR => g++
   	--- Sist. Op.  => Windows 10
   	--- IDE usada  => Sublime Text
*/

#define MEM_SIZE 4096 

// macros de opcodes 
#define ADDI 0x08
#define	ANDI 0x0C
#define	BEQ 0x04
#define BNE 0x05
#define	EXT 0x00
#define	J 0x02
#define	JAL 0x03
#define	LW 0x23
#define	ORI 0x0D
#define	SW 0x2B 

#define ADD 0x20
#define	SUB 0x22
#define	MULT 0x18
#define	AND 0x24
#define	OR 0x25
#define	XOR 0x26
#define	NOR 0x27
#define	SLT 0x2A
#define	JR 0x08
#define	SLL 0x00
#define	SRL 0x02
#define	SRA 0x03
#define	SYSCALL 0x0c
#define	MFHI 0x10
#define	MFLO 0x12

// Variaveis globais
unsigned int ri, PC, hi, lo;
unsigned opcode, rs, rt, rd, shamt, funct, k26;
int k16, mem[MEM_SIZE], breg[32];
	 

// entrada direta de dados na memoria
void  init_mem(){

	printf("\n\nentrou na init_mem\n\n");
	/*segmento código*/
	mem[PC] = 0x20040005;
//	mem[PC+4] = 0x20050006;
//	mem[PC+8] = 0x00a44820;
	mem[PC+4] = 0x2002000a;
	mem[PC+8] = 0x0000000c;
	/*segmento dados*/
	printf("\n\niniciou na memoria as instrucoes\n\n");
}

void dump_reg(char format){

	int i = 0;

	while(i < 32){

		if(format == 'h'){

			printf("\n ---REG %d = %x --- \n ", i, breg[i]);
		}
		else{
			printf("\n ---REG %d = %d --- \n ", i, breg[i]);
		}
		i++;
	}
	if(format == 'h'){

		printf("\n ---PC = %x ---\n ", PC);
		printf("\n ---HI = %x ---\n ", hi);
		printf("\n ---LO = %x ---\n ", lo);
	}
	else{
		printf("\n--- PC = %d ---\n ", PC);
		printf("\n--- HI = %d ---\n ", hi);
		printf("\n--- LO = %d ---\n ", lo);
	}
}

void fetch(){

	printf("\n\nentrou na fetch\n\n");
	ri = mem[PC];
	printf("\n\n instrucao = %x\n\n", ri);
	PC = PC + 4;
	printf("\n\n PC = %x", PC);
	printf("\n\niniciou os RI e PC\n\n");
}

void decode (){

//	unsigned int functSLL = opcodeSLL = 26, rsSLL = rtSLL = rdSLL = shamtSLL = 21;
//	unsigned rsMask = rtMask = rdMask = 0x1f, k16Mask = 0xffff, k26Mask = 0x3ffffff;

	printf("\n\nentrou na decode\n\n");
	opcode = (ri >> 26);
	printf("\n\nleu o opcode\n\n");
	printf("\n\nOPCODE = %d\n\n", opcode);

	if (opcode == 0){

		printf("\n\nopa, parece que e uma istrucao tipo R, vamo extrair os campos\n\n");
		rs = (ri >> 21) & 0x1f;
		printf("\n\nrs = %d\n\n", rs);
		rt = (ri >> 16) & 0x1f;
		printf("\n\nrt = %d\n\n", rt);
		rd = (ri >> 11) & 0x1f;
		printf("\n\nrd = %d\n\n", rd);
		shamt = (ri >> 6) & 0x1f;
		printf("\n\nshamt = %d\n\n", shamt);
		funct = ri & 0x1f;
		printf("\n\nfunct = %d\n\n", funct);
	}
	else if ((opcode == 0x02)||(opcode == 0x03)){

		printf("\n\nopa, parece que e uma istrucao tipo J, vamo extrair os campos\n\n");
		k26 = ri & 0x3ffffff;
		printf("\n\nk26 = %d", k26);
	}
	else
		printf("\n\nopa, parece que e uma istrucao tipo I, vamo extrair os campos\n\n");
		rs = (ri >> 21) & 0x1f;
		printf("\n\nrs = %d\n\n", rs);
		rt = (ri >> 16) & 0x1f;
		printf("\n\nrt = %d\n\n", rt);
		k16 = ri & 0xffff;
		printf("\n\nk16 = %d", k16);
}

void execute(){

	int64_t aux;

	switch (opcode){

		case EXT:

			switch (funct){

				case ADD: breg[rd] = breg[rs] + breg[rt];
						  dump_reg('d');
					break; 

				case SUB: breg[rd] = breg[rs] - breg[rt];
					break;

				case MULT: aux = breg[rs] * breg[rt];
						   hi = aux >> 32;
						   lo = aux;
					break;

				case AND: breg[rd] = breg[rs] & breg[rt];
					break;

				case OR: breg[rd] = breg[rs] | breg[rt];
					break;

				case XOR: breg[rd] = breg[rs] ^ breg[rt];
					break;

				case NOR: breg[rd] = ~(breg[rs] | breg[rt]);
					break;

				case SLT: if(breg[rs] < breg[rt]){

								breg[rd] = 1;
							}
							else
								breg[rd] = 0;
					break;

				case JR: PC = breg[rs];
					break;

				case SLL: breg[rd] = breg[rt] << shamt;
					break;

				case SRL: breg[rd] = breg[rt] >> shamt;
					break;

				case SRA: if ((breg[rt] >> 31) == 1){

							breg[rd] = ((breg[rt] >> shamt) ^ 0xffffffff) & 0x01;

						  }
						  else
						  		breg[rd] = breg[rt] >> shamt;
					break;

				case SYSCALL: if(breg[2] == 10){

								exit(0);
							  }
					break;

				case MFHI: breg[rd] = hi;
					break;

				case MFLO: breg[rd] = lo;
					break;
				
				default: printf("\n\ndeu ruim (opcode == 0x00)\n\n");
			}

		case J: PC = k26;
			break;

		case JAL: breg[31] = PC+8;
				  PC = k26;
			break;

		case BEQ: if(breg[rs] == breg[rt]){

						PC = PC+4+k16;
				  }
			break;

		case BNE:  if(breg[rs] != breg[rt]){

						PC = PC+4+k16;
				  }
			break;

		case ADDI:  breg[rt] = breg[rs] + k16;
					dump_reg('d');
			break;

		case ANDI: breg[rt] = breg[rs] & k16;
			break;

		case ORI: breg[rt] = breg[rs] | k16;
			break;

		case LW: breg[rt] = mem[breg[rs]+k16];
			break;

		case SW: mem[breg[rs]+k16] = breg[rt];
			break;

		default: printf("\n\ndeu ruim (opcode != 0x00)\n\n");
	}

}

void dump_mem(int start, int end, char format){

	int i = start;
	while(i < end){

		if(format == 'h'){

			printf("\n\n INDICE DE MEMORIA %d = %x \n\n ", i, mem[i]);
		}
		else{
			printf("\n\n INDICE DE MEMORIA %d = %d \n\n ", i, mem[i]);
		}
		i++;
	}
}


void step (){

	printf("\n\ntamo na step\n\n");
	fetch();
	printf("\n\nsaiu da fetch\n\n");
	decode();
	printf("\n\nopa!!! saiu do decoden\n\n");
	execute();

}

void run (){

	printf("\n\nentrou na run\n\n");
	PC = 0x00;
	printf("\n\niniciou pc com zero\n\n");
	init_mem();
	printf("\n\nsaiu da init_mem\n\n");
	while (PC < 0x00002000){

		printf("\n\nentrou no loop do step\n\n");
		step();
		printf("\n\nsaiu da step\n\n");
	}
	printf("\n\nsaiu do loop da step\n\n");
}

int main () {

	printf("\n\ndada a largada\n\n");
	run();

return 0;
}
