

void decode (){

	unsigned int functSLL = opcodeSLL = 26, rsSLL = rtSLL = rdSLL = shamtSLL = 21;
	unsigned rsMask = rtMask = rdMask = 0x1f, k16Mask = 0xffff, k26Mask = 0x3ffffff;

	opcode = (ri >> 26);

	if (opcode == 0){

		rs = (ri >> 21) & 0x1f;
		rt = (ri >> 16) & 0x1f;
		rd = (ri >> 11) & 0x1f;
		shamt = (ri >> 6) & 0x1f;
		funct = ri & 0x1f;
	}
	else if ((opcode == 0x02)||(opcode == 0x03)){

		k26 = ri & 0x3ffffff;
	}
	else
		rs = (ri >> 21) & 0x1f;
		rt = (ri >> 16) & 0x1f;
		k16 = ri & 0xffff;
}