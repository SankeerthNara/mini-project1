
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	43813103          	ld	sp,1080(sp) # 8000a438 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda85f>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	de678793          	addi	a5,a5,-538 # 80000e5e <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	472020ef          	jal	8000258e <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7c2000ef          	jal	800008ea <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	00012517          	auipc	a0,0x12
    80000198:	2ec50513          	addi	a0,a0,748 # 80012480 <cons>
    8000019c:	24d000ef          	jal	80000be8 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00012497          	auipc	s1,0x12
    800001a4:	2e048493          	addi	s1,s1,736 # 80012480 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00012917          	auipc	s2,0x12
    800001ac:	37090913          	addi	s2,s2,880 # 80012518 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	73c010ef          	jal	800018fc <myproc>
    800001c4:	24a020ef          	jal	8000240e <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	765010ef          	jal	80002130 <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	29f000ef          	jal	80000c70 <release>
      sleep();
    800001d6:	797010ef          	jal	8000216c <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	20d000ef          	jal	80000be8 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00012717          	auipc	a4,0x12
    800001f2:	29270713          	addi	a4,a4,658 # 80012480 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	322020ef          	jal	80002542 <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	00012517          	auipc	a0,0x12
    8000023c:	24850513          	addi	a0,a0,584 # 80012480 <cons>
    80000240:	231000ef          	jal	80000c70 <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	00012717          	auipc	a4,0x12
    80000262:	2af72d23          	sw	a5,698(a4) # 80012518 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	00012517          	auipc	a0,0x12
    80000278:	20c50513          	addi	a0,a0,524 # 80012480 <cons>
    8000027c:	1f5000ef          	jal	80000c70 <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	6d6000ef          	jal	80000970 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6c8000ef          	jal	80000970 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6c0000ef          	jal	80000970 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ba000ef          	jal	80000970 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00012517          	auipc	a0,0x12
    800002cc:	1b850513          	addi	a0,a0,440 # 80012480 <cons>
    800002d0:	119000ef          	jal	80000be8 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	08f48d63          	beq	s1,a5,80000370 <consoleintr+0xb4>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48263          	beq	s1,a5,800003c4 <consoleintr+0x108>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49363          	bne	s1,a5,800003ec <consoleintr+0x130>
  case C('P'): // Print process list.
    procdump();
    800002ea:	2f0020ef          	jal	800025da <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	00012517          	auipc	a0,0x12
    800002f2:	19250513          	addi	a0,a0,402 # 80012480 <cons>
    800002f6:	17b000ef          	jal	80000c70 <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0af48e63          	beq	s1,a5,800003c4 <consoleintr+0x108>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	00012717          	auipc	a4,0x12
    80000310:	17470713          	addi	a4,a4,372 # 80012480 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48563          	beq	s1,a5,800003f2 <consoleintr+0x136>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	00012717          	auipc	a4,0x12
    80000336:	14e70713          	addi	a4,a4,334 # 80012480 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	c371                	beqz	a4,8000041a <consoleintr+0x15e>
    80000358:	14f1                	addi	s1,s1,-4
    8000035a:	c0e1                	beqz	s1,8000041a <consoleintr+0x15e>
    8000035c:	00012717          	auipc	a4,0x12
    80000360:	1bc72703          	lw	a4,444(a4) # 80012518 <cons+0x98>
    80000364:	9f99                	subw	a5,a5,a4
    80000366:	08000713          	li	a4,128
    8000036a:	f8e792e3          	bne	a5,a4,800002ee <consoleintr+0x32>
    8000036e:	a075                	j	8000041a <consoleintr+0x15e>
    80000370:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    80000372:	00012717          	auipc	a4,0x12
    80000376:	10e70713          	addi	a4,a4,270 # 80012480 <cons>
    8000037a:	0a072783          	lw	a5,160(a4)
    8000037e:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000382:	00012497          	auipc	s1,0x12
    80000386:	0fe48493          	addi	s1,s1,254 # 80012480 <cons>
    while (cons.e != cons.w &&
    8000038a:	4929                	li	s2,10
    8000038c:	02f70863          	beq	a4,a5,800003bc <consoleintr+0x100>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000390:	37fd                	addiw	a5,a5,-1
    80000392:	07f7f713          	andi	a4,a5,127
    80000396:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    80000398:	01874703          	lbu	a4,24(a4)
    8000039c:	03270263          	beq	a4,s2,800003c0 <consoleintr+0x104>
      cons.e--;
    800003a0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a4:	10000513          	li	a0,256
    800003a8:	ee3ff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003ac:	0a04a783          	lw	a5,160(s1)
    800003b0:	09c4a703          	lw	a4,156(s1)
    800003b4:	fcf71ee3          	bne	a4,a5,80000390 <consoleintr+0xd4>
    800003b8:	6902                	ld	s2,0(sp)
    800003ba:	bf15                	j	800002ee <consoleintr+0x32>
    800003bc:	6902                	ld	s2,0(sp)
    800003be:	bf05                	j	800002ee <consoleintr+0x32>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003c4:	00012717          	auipc	a4,0x12
    800003c8:	0bc70713          	addi	a4,a4,188 # 80012480 <cons>
    800003cc:	0a072783          	lw	a5,160(a4)
    800003d0:	09c72703          	lw	a4,156(a4)
    800003d4:	f0f70de3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003d8:	37fd                	addiw	a5,a5,-1
    800003da:	00012717          	auipc	a4,0x12
    800003de:	14f72323          	sw	a5,326(a4) # 80012520 <cons+0xa0>
      consputc(BACKSPACE);
    800003e2:	10000513          	li	a0,256
    800003e6:	ea5ff0ef          	jal	8000028a <consputc>
    800003ea:	b711                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003ec:	f00481e3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f0:	bf31                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003f2:	4529                	li	a0,10
    800003f4:	e97ff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003f8:	00012797          	auipc	a5,0x12
    800003fc:	08878793          	addi	a5,a5,136 # 80012480 <cons>
    80000400:	0a07a703          	lw	a4,160(a5)
    80000404:	0017069b          	addiw	a3,a4,1
    80000408:	8636                	mv	a2,a3
    8000040a:	0ad7a023          	sw	a3,160(a5)
    8000040e:	07f77713          	andi	a4,a4,127
    80000412:	97ba                	add	a5,a5,a4
    80000414:	4729                	li	a4,10
    80000416:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000041a:	00012797          	auipc	a5,0x12
    8000041e:	10c7a123          	sw	a2,258(a5) # 8001251c <cons+0x9c>
        wakeup(&cons.r);
    80000422:	00012517          	auipc	a0,0x12
    80000426:	0f650513          	addi	a0,a0,246 # 80012518 <cons+0x98>
    8000042a:	58b010ef          	jal	800021b4 <wakeup>
    8000042e:	b5c1                	j	800002ee <consoleintr+0x32>

0000000080000430 <consoleinit>:

void
consoleinit(void)
{
    80000430:	1141                	addi	sp,sp,-16
    80000432:	e406                	sd	ra,8(sp)
    80000434:	e022                	sd	s0,0(sp)
    80000436:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000438:	00007597          	auipc	a1,0x7
    8000043c:	bc858593          	addi	a1,a1,-1080 # 80007000 <etext>
    80000440:	00012517          	auipc	a0,0x12
    80000444:	04050513          	addi	a0,a0,64 # 80012480 <cons>
    80000448:	720000ef          	jal	80000b68 <initlock>

  uartinit();
    8000044c:	448000ef          	jal	80000894 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000450:	00023797          	auipc	a5,0x23
    80000454:	9b878793          	addi	a5,a5,-1608 # 80022e08 <devsw>
    80000458:	00000717          	auipc	a4,0x0
    8000045c:	d2070713          	addi	a4,a4,-736 # 80000178 <consoleread>
    80000460:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000462:	00000717          	auipc	a4,0x0
    80000466:	c7470713          	addi	a4,a4,-908 # 800000d6 <consolewrite>
    8000046a:	ef98                	sd	a4,24(a5)
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret

0000000080000474 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000474:	7139                	addi	sp,sp,-64
    80000476:	fc06                	sd	ra,56(sp)
    80000478:	f822                	sd	s0,48(sp)
    8000047a:	f04a                	sd	s2,32(sp)
    8000047c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    8000047e:	c219                	beqz	a2,80000484 <printint+0x10>
    80000480:	08054163          	bltz	a0,80000502 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000484:	4301                	li	t1,0

  i = 0;
    80000486:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000048a:	86ca                	mv	a3,s2
  i = 0;
    8000048c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000048e:	00007817          	auipc	a6,0x7
    80000492:	3ba80813          	addi	a6,a6,954 # 80007848 <digits>
    80000496:	88ba                	mv	a7,a4
    80000498:	0017061b          	addiw	a2,a4,1
    8000049c:	8732                	mv	a4,a2
    8000049e:	02b577b3          	remu	a5,a0,a1
    800004a2:	97c2                	add	a5,a5,a6
    800004a4:	0007c783          	lbu	a5,0(a5)
    800004a8:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004ac:	87aa                	mv	a5,a0
    800004ae:	02b55533          	divu	a0,a0,a1
    800004b2:	0685                	addi	a3,a3,1
    800004b4:	feb7f1e3          	bgeu	a5,a1,80000496 <printint+0x22>

  if (sign)
    800004b8:	00030c63          	beqz	t1,800004d0 <printint+0x5c>
    buf[i++] = '-';
    800004bc:	fe060793          	addi	a5,a2,-32
    800004c0:	00878633          	add	a2,a5,s0
    800004c4:	02d00793          	li	a5,45
    800004c8:	fef60423          	sb	a5,-24(a2)
    800004cc:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d0:	02e05463          	blez	a4,800004f8 <printint+0x84>
    800004d4:	f426                	sd	s1,40(sp)
    800004d6:	377d                	addiw	a4,a4,-1
    800004d8:	00e904b3          	add	s1,s2,a4
    800004dc:	197d                	addi	s2,s2,-1
    800004de:	993a                	add	s2,s2,a4
    800004e0:	1702                	slli	a4,a4,0x20
    800004e2:	9301                	srli	a4,a4,0x20
    800004e4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004e8:	0004c503          	lbu	a0,0(s1)
    800004ec:	d9fff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f0:	14fd                	addi	s1,s1,-1
    800004f2:	ff249be3          	bne	s1,s2,800004e8 <printint+0x74>
    800004f6:	74a2                	ld	s1,40(sp)
}
    800004f8:	70e2                	ld	ra,56(sp)
    800004fa:	7442                	ld	s0,48(sp)
    800004fc:	7902                	ld	s2,32(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
    x = -xx;
    80000502:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    80000506:	4305                	li	t1,1
    x = -xx;
    80000508:	bfbd                	j	80000486 <printint+0x12>

000000008000050a <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    8000050a:	7131                	addi	sp,sp,-192
    8000050c:	fc86                	sd	ra,120(sp)
    8000050e:	f8a2                	sd	s0,112(sp)
    80000510:	f0ca                	sd	s2,96(sp)
    80000512:	0100                	addi	s0,sp,128
    80000514:	892a                	mv	s2,a0
    80000516:	e40c                	sd	a1,8(s0)
    80000518:	e810                	sd	a2,16(s0)
    8000051a:	ec14                	sd	a3,24(s0)
    8000051c:	f018                	sd	a4,32(s0)
    8000051e:	f41c                	sd	a5,40(s0)
    80000520:	03043823          	sd	a6,48(s0)
    80000524:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    80000528:	0000a797          	auipc	a5,0xa
    8000052c:	f2c7a783          	lw	a5,-212(a5) # 8000a454 <panicking>
    80000530:	cf9d                	beqz	a5,8000056e <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000532:	00840793          	addi	a5,s0,8
    80000536:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    8000053a:	00094503          	lbu	a0,0(s2)
    8000053e:	22050663          	beqz	a0,8000076a <printk+0x260>
    80000542:	f4a6                	sd	s1,104(sp)
    80000544:	ecce                	sd	s3,88(sp)
    80000546:	e8d2                	sd	s4,80(sp)
    80000548:	e4d6                	sd	s5,72(sp)
    8000054a:	e0da                	sd	s6,64(sp)
    8000054c:	fc5e                	sd	s7,56(sp)
    8000054e:	f862                	sd	s8,48(sp)
    80000550:	f06a                	sd	s10,32(sp)
    80000552:	ec6e                	sd	s11,24(sp)
    80000554:	4a01                	li	s4,0
    if (cx != '%') {
    80000556:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    8000055a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    8000055e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000562:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000566:	4b29                	li	s6,10
    if (c0 == 'd') {
    80000568:	06400b93          	li	s7,100
    8000056c:	a015                	j	80000590 <printk+0x86>
    acquire(&pr.lock);
    8000056e:	00012517          	auipc	a0,0x12
    80000572:	fba50513          	addi	a0,a0,-70 # 80012528 <pr>
    80000576:	672000ef          	jal	80000be8 <acquire>
    8000057a:	bf65                	j	80000532 <printk+0x28>
      consputc(cx);
    8000057c:	d0fff0ef          	jal	8000028a <consputc>
      continue;
    80000580:	84d2                	mv	s1,s4
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000582:	2485                	addiw	s1,s1,1
    80000584:	8a26                	mv	s4,s1
    80000586:	94ca                	add	s1,s1,s2
    80000588:	0004c503          	lbu	a0,0(s1)
    8000058c:	1c050663          	beqz	a0,80000758 <printk+0x24e>
    if (cx != '%') {
    80000590:	ff3516e3          	bne	a0,s3,8000057c <printk+0x72>
    i++;
    80000594:	001a079b          	addiw	a5,s4,1
    80000598:	84be                	mv	s1,a5
    c0 = fmt[i + 0] & 0xff;
    8000059a:	00f90733          	add	a4,s2,a5
    8000059e:	00074a83          	lbu	s5,0(a4)
    if (c0)
    800005a2:	200a8963          	beqz	s5,800007b4 <printk+0x2aa>
      c1 = fmt[i + 1] & 0xff;
    800005a6:	00174683          	lbu	a3,1(a4)
    if (c1)
    800005aa:	1e068c63          	beqz	a3,800007a2 <printk+0x298>
    if (c0 == 'd') {
    800005ae:	037a8863          	beq	s5,s7,800005de <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b2:	f94a8713          	addi	a4,s5,-108
    800005b6:	00173713          	seqz	a4,a4
    800005ba:	f9c68613          	addi	a2,a3,-100
    800005be:	ee05                	bnez	a2,800005f6 <printk+0xec>
    800005c0:	cb1d                	beqz	a4,800005f6 <printk+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005c2:	f8843783          	ld	a5,-120(s0)
    800005c6:	00878713          	addi	a4,a5,8
    800005ca:	f8e43423          	sd	a4,-120(s0)
    800005ce:	4605                	li	a2,1
    800005d0:	85da                	mv	a1,s6
    800005d2:	6388                	ld	a0,0(a5)
    800005d4:	ea1ff0ef          	jal	80000474 <printint>
      i += 1;
    800005d8:	002a049b          	addiw	s1,s4,2
    800005dc:	b75d                	j	80000582 <printk+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005de:	f8843783          	ld	a5,-120(s0)
    800005e2:	00878713          	addi	a4,a5,8
    800005e6:	f8e43423          	sd	a4,-120(s0)
    800005ea:	4605                	li	a2,1
    800005ec:	85da                	mv	a1,s6
    800005ee:	4388                	lw	a0,0(a5)
    800005f0:	e85ff0ef          	jal	80000474 <printint>
    800005f4:	b779                	j	80000582 <printk+0x78>
      c2 = fmt[i + 2] & 0xff;
    800005f6:	97ca                	add	a5,a5,s2
    800005f8:	8636                	mv	a2,a3
    800005fa:	0027c683          	lbu	a3,2(a5)
    800005fe:	a2c9                	j	800007c0 <printk+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80000600:	f8843783          	ld	a5,-120(s0)
    80000604:	00878713          	addi	a4,a5,8
    80000608:	f8e43423          	sd	a4,-120(s0)
    8000060c:	4605                	li	a2,1
    8000060e:	45a9                	li	a1,10
    80000610:	6388                	ld	a0,0(a5)
    80000612:	e63ff0ef          	jal	80000474 <printint>
      i += 2;
    80000616:	003a049b          	addiw	s1,s4,3
    8000061a:	b7a5                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000061c:	f8843783          	ld	a5,-120(s0)
    80000620:	00878713          	addi	a4,a5,8
    80000624:	f8e43423          	sd	a4,-120(s0)
    80000628:	4601                	li	a2,0
    8000062a:	85da                	mv	a1,s6
    8000062c:	0007e503          	lwu	a0,0(a5)
    80000630:	e45ff0ef          	jal	80000474 <printint>
    80000634:	b7b9                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	85da                	mv	a1,s6
    80000646:	6388                	ld	a0,0(a5)
    80000648:	e2dff0ef          	jal	80000474 <printint>
      i += 1;
    8000064c:	002a049b          	addiw	s1,s4,2
    80000650:	bf0d                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	e11ff0ef          	jal	80000474 <printint>
      i += 2;
    80000668:	003a049b          	addiw	s1,s4,3
    8000066c:	bf19                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45c1                	li	a1,16
    8000067e:	0007e503          	lwu	a0,0(a5)
    80000682:	df3ff0ef          	jal	80000474 <printint>
    80000686:	bdf5                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000688:	f8843783          	ld	a5,-120(s0)
    8000068c:	00878713          	addi	a4,a5,8
    80000690:	f8e43423          	sd	a4,-120(s0)
    80000694:	45c1                	li	a1,16
    80000696:	6388                	ld	a0,0(a5)
    80000698:	dddff0ef          	jal	80000474 <printint>
      i += 1;
    8000069c:	002a049b          	addiw	s1,s4,2
    800006a0:	b5cd                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	dc1ff0ef          	jal	80000474 <printint>
      i += 2;
    800006b8:	003a049b          	addiw	s1,s4,3
    800006bc:	b5d9                	j	80000582 <printk+0x78>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00007c97          	auipc	s9,0x7
    800006e6:	166c8c93          	addi	s9,s9,358 # 80007848 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1e0>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	b541                	j	80000582 <printk+0x78>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5b5                	j	80000582 <printk+0x78>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x238>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	e40509e3          	beqz	a0,80000582 <printk+0x78>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x22a>
    80000740:	b589                	j	80000582 <printk+0x78>
        s = "(null)";
    80000742:	00007a17          	auipc	s4,0x7
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x22a>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b535                	j	80000582 <printk+0x78>
    80000758:	74a6                	ld	s1,104(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	0000a797          	auipc	a5,0xa
    8000076e:	cea7a783          	lw	a5,-790(a5) # 8000a454 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x28a>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	7906                	ld	s2,96(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	74a6                	ld	s1,104(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x260>
    release(&pr.lock);
    80000794:	00012517          	auipc	a0,0x12
    80000798:	d9450513          	addi	a0,a0,-620 # 80012528 <pr>
    8000079c:	4d4000ef          	jal	80000c70 <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x26a>
    if (c0 == 'd') {
    800007a2:	e37a8ee3          	beq	s5,s7,800005de <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8713          	addi	a4,s5,-108
    800007aa:	00173713          	seqz	a4,a4
    800007ae:	8636                	mv	a2,a3
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4781                	li	a5,0
    800007b2:	a00d                	j	800007d4 <printk+0x2ca>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8713          	addi	a4,s5,-108
    800007b8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	86d6                	mv	a3,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460793          	addi	a5,a2,-108
    800007c4:	0017b793          	seqz	a5,a5
    800007c8:	8ff9                	and	a5,a5,a4
    800007ca:	f9c68593          	addi	a1,a3,-100
    800007ce:	e199                	bnez	a1,800007d4 <printk+0x2ca>
    800007d0:	e20798e3          	bnez	a5,80000600 <printk+0xf6>
    } else if (c0 == 'u') {
    800007d4:	e58a84e3          	beq	s5,s8,8000061c <printk+0x112>
    } else if (c0 == 'l' && c1 == 'u') {
    800007d8:	f8b60593          	addi	a1,a2,-117
    800007dc:	e199                	bnez	a1,800007e2 <printk+0x2d8>
    800007de:	e4071ce3          	bnez	a4,80000636 <printk+0x12c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007e2:	f8b68593          	addi	a1,a3,-117
    800007e6:	e199                	bnez	a1,800007ec <printk+0x2e2>
    800007e8:	e60795e3          	bnez	a5,80000652 <printk+0x148>
    } else if (c0 == 'x') {
    800007ec:	e9aa81e3          	beq	s5,s10,8000066e <printk+0x164>
    } else if (c0 == 'l' && c1 == 'x') {
    800007f0:	f8860613          	addi	a2,a2,-120
    800007f4:	e219                	bnez	a2,800007fa <printk+0x2f0>
    800007f6:	e80719e3          	bnez	a4,80000688 <printk+0x17e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    800007fa:	f8868693          	addi	a3,a3,-120
    800007fe:	e299                	bnez	a3,80000804 <printk+0x2fa>
    80000800:	ea0791e3          	bnez	a5,800006a2 <printk+0x198>
    } else if (c0 == 'p') {
    80000804:	ebba8de3          	beq	s5,s11,800006be <printk+0x1b4>
    } else if (c0 == 'c') {
    80000808:	06300793          	li	a5,99
    8000080c:	eefa8ce3          	beq	s5,a5,80000704 <printk+0x1fa>
    } else if (c0 == 's') {
    80000810:	07300793          	li	a5,115
    80000814:	f0fa82e3          	beq	s5,a5,80000718 <printk+0x20e>
    } else if (c0 == '%') {
    80000818:	02500793          	li	a5,37
    8000081c:	f2fa8ae3          	beq	s5,a5,80000750 <printk+0x246>
    } else if (c0 == 0) {
    80000820:	f60a80e3          	beqz	s5,80000780 <printk+0x276>
      consputc('%');
    80000824:	02500513          	li	a0,37
    80000828:	a63ff0ef          	jal	8000028a <consputc>
      consputc(c0);
    8000082c:	8556                	mv	a0,s5
    8000082e:	a5dff0ef          	jal	8000028a <consputc>
    80000832:	bb81                	j	80000582 <printk+0x78>

0000000080000834 <panic>:

void
panic(char *s)
{
    80000834:	1101                	addi	sp,sp,-32
    80000836:	ec06                	sd	ra,24(sp)
    80000838:	e822                	sd	s0,16(sp)
    8000083a:	e426                	sd	s1,8(sp)
    8000083c:	e04a                	sd	s2,0(sp)
    8000083e:	1000                	addi	s0,sp,32
    80000840:	892a                	mv	s2,a0
  panicking = 1;
    80000842:	4485                	li	s1,1
    80000844:	0000a797          	auipc	a5,0xa
    80000848:	c097a823          	sw	s1,-1008(a5) # 8000a454 <panicking>
  printk("panic: ");
    8000084c:	00006517          	auipc	a0,0x6
    80000850:	7cc50513          	addi	a0,a0,1996 # 80007018 <etext+0x18>
    80000854:	cb7ff0ef          	jal	8000050a <printk>
  printk("%s\n", s);
    80000858:	85ca                	mv	a1,s2
    8000085a:	00006517          	auipc	a0,0x6
    8000085e:	7c650513          	addi	a0,a0,1990 # 80007020 <etext+0x20>
    80000862:	ca9ff0ef          	jal	8000050a <printk>
  panicked = 1; // freeze uart output from other CPUs
    80000866:	0000a797          	auipc	a5,0xa
    8000086a:	be97a523          	sw	s1,-1046(a5) # 8000a450 <panicked>
  for (;;)
    8000086e:	a001                	j	8000086e <panic+0x3a>

0000000080000870 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000870:	1141                	addi	sp,sp,-16
    80000872:	e406                	sd	ra,8(sp)
    80000874:	e022                	sd	s0,0(sp)
    80000876:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000878:	00006597          	auipc	a1,0x6
    8000087c:	7b058593          	addi	a1,a1,1968 # 80007028 <etext+0x28>
    80000880:	00012517          	auipc	a0,0x12
    80000884:	ca850513          	addi	a0,a0,-856 # 80012528 <pr>
    80000888:	2e0000ef          	jal	80000b68 <initlock>
}
    8000088c:	60a2                	ld	ra,8(sp)
    8000088e:	6402                	ld	s0,0(sp)
    80000890:	0141                	addi	sp,sp,16
    80000892:	8082                	ret

0000000080000894 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    80000894:	1141                	addi	sp,sp,-16
    80000896:	e406                	sd	ra,8(sp)
    80000898:	e022                	sd	s0,0(sp)
    8000089a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000089c:	100007b7          	lui	a5,0x10000
    800008a0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008a4:	10000737          	lui	a4,0x10000
    800008a8:	f8000693          	li	a3,-128
    800008ac:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008b0:	468d                	li	a3,3
    800008b2:	10000637          	lui	a2,0x10000
    800008b6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008be:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008c2:	8732                	mv	a4,a2
    800008c4:	461d                	li	a2,7
    800008c6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ca:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    800008ce:	00006597          	auipc	a1,0x6
    800008d2:	76258593          	addi	a1,a1,1890 # 80007030 <etext+0x30>
    800008d6:	00012517          	auipc	a0,0x12
    800008da:	c6a50513          	addi	a0,a0,-918 # 80012540 <tx_lock>
    800008de:	17f030ef          	jal	8000425c <initsleeplock>
}
    800008e2:	60a2                	ld	ra,8(sp)
    800008e4:	6402                	ld	s0,0(sp)
    800008e6:	0141                	addi	sp,sp,16
    800008e8:	8082                	ret

00000000800008ea <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008ea:	7139                	addi	sp,sp,-64
    800008ec:	fc06                	sd	ra,56(sp)
    800008ee:	f822                	sd	s0,48(sp)
    800008f0:	f04a                	sd	s2,32(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    800008fa:	00012517          	auipc	a0,0x12
    800008fe:	c4650513          	addi	a0,a0,-954 # 80012540 <tx_lock>
    80000902:	191030ef          	jal	80004292 <acquiresleep>

  int i = 0;
  while (i < n) {
    80000906:	05205963          	blez	s2,80000958 <uartwrite+0x6e>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	ec4e                	sd	s3,24(sp)
    8000090e:	e852                	sd	s4,16(sp)
    80000910:	e05a                	sd	s6,0(sp)
  int i = 0;
    80000912:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80000914:	0000aa17          	auipc	s4,0xa
    80000918:	b44a0a13          	addi	s4,s4,-1212 # 8000a458 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000091c:	100009b7          	lui	s3,0x10000
    80000920:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80000922:	10000b37          	lui	s6,0x10000
    80000926:	a029                	j	80000930 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    80000928:	045010ef          	jal	8000216c <sleep>
  while (i < n) {
    8000092c:	0324d263          	bge	s1,s2,80000950 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80000930:	8552                	mv	a0,s4
    80000932:	7fe010ef          	jal	80002130 <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000936:	0009c783          	lbu	a5,0(s3)
    8000093a:	0207f793          	andi	a5,a5,32
    8000093e:	d7ed                	beqz	a5,80000928 <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80000940:	009a87b3          	add	a5,s5,s1
    80000944:	0007c783          	lbu	a5,0(a5)
    80000948:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    8000094c:	2485                	addiw	s1,s1,1
    8000094e:	bff9                	j	8000092c <uartwrite+0x42>
    80000950:	74a2                	ld	s1,40(sp)
    80000952:	69e2                	ld	s3,24(sp)
    80000954:	6a42                	ld	s4,16(sp)
    80000956:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    80000958:	00012517          	auipc	a0,0x12
    8000095c:	be850513          	addi	a0,a0,-1048 # 80012540 <tx_lock>
    80000960:	187030ef          	jal	800042e6 <releasesleep>
}
    80000964:	70e2                	ld	ra,56(sp)
    80000966:	7442                	ld	s0,48(sp)
    80000968:	7902                	ld	s2,32(sp)
    8000096a:	6aa2                	ld	s5,8(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret

0000000080000970 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000970:	1101                	addi	sp,sp,-32
    80000972:	ec06                	sd	ra,24(sp)
    80000974:	e822                	sd	s0,16(sp)
    80000976:	e426                	sd	s1,8(sp)
    80000978:	1000                	addi	s0,sp,32
    8000097a:	84aa                	mv	s1,a0
  if (panicking == 0)
    8000097c:	0000a797          	auipc	a5,0xa
    80000980:	ad87a783          	lw	a5,-1320(a5) # 8000a454 <panicking>
    80000984:	cf95                	beqz	a5,800009c0 <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000986:	0000a797          	auipc	a5,0xa
    8000098a:	aca7a783          	lw	a5,-1334(a5) # 8000a450 <panicked>
    8000098e:	ef85                	bnez	a5,800009c6 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000990:	10000737          	lui	a4,0x10000
    80000994:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000996:	00074783          	lbu	a5,0(a4)
    8000099a:	0207f793          	andi	a5,a5,32
    8000099e:	dfe5                	beqz	a5,80000996 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800009a0:	0ff4f513          	zext.b	a0,s1
    800009a4:	100007b7          	lui	a5,0x10000
    800009a8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009ac:	0000a797          	auipc	a5,0xa
    800009b0:	aa87a783          	lw	a5,-1368(a5) # 8000a454 <panicking>
    800009b4:	cb91                	beqz	a5,800009c8 <uartputc_sync+0x58>
    pop_off();
}
    800009b6:	60e2                	ld	ra,24(sp)
    800009b8:	6442                	ld	s0,16(sp)
    800009ba:	64a2                	ld	s1,8(sp)
    800009bc:	6105                	addi	sp,sp,32
    800009be:	8082                	ret
    push_off();
    800009c0:	1ee000ef          	jal	80000bae <push_off>
    800009c4:	b7c9                	j	80000986 <uartputc_sync+0x16>
    for (;;)
    800009c6:	a001                	j	800009c6 <uartputc_sync+0x56>
    pop_off();
    800009c8:	260000ef          	jal	80000c28 <pop_off>
}
    800009cc:	b7ed                	j	800009b6 <uartputc_sync+0x46>

00000000800009ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	e04a                	sd	s2,0(sp)
    800009d8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009e2:	100007b7          	lui	a5,0x10000
    800009e6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ea:	0207f793          	andi	a5,a5,32
    800009ee:	ef99                	bnez	a5,80000a0c <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009f0:	100004b7          	lui	s1,0x10000
    800009f4:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    800009f6:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009fa:	0004c783          	lbu	a5,0(s1)
    800009fe:	8b85                	andi	a5,a5,1
    80000a00:	cf89                	beqz	a5,80000a1a <uartintr+0x4c>
    return ReadReg(RHR);
    80000a02:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a06:	8b7ff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a0a:	bfc5                	j	800009fa <uartintr+0x2c>
    wakeup(&tx_chan);
    80000a0c:	0000a517          	auipc	a0,0xa
    80000a10:	a4c50513          	addi	a0,a0,-1460 # 8000a458 <tx_chan>
    80000a14:	7a0010ef          	jal	800021b4 <wakeup>
    80000a18:	bfe1                	j	800009f0 <uartintr+0x22>
  }
}
    80000a1a:	60e2                	ld	ra,24(sp)
    80000a1c:	6442                	ld	s0,16(sp)
    80000a1e:	64a2                	ld	s1,8(sp)
    80000a20:	6902                	ld	s2,0(sp)
    80000a22:	6105                	addi	sp,sp,32
    80000a24:	8082                	ret

0000000080000a26 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a26:	1101                	addi	sp,sp,-32
    80000a28:	ec06                	sd	ra,24(sp)
    80000a2a:	e822                	sd	s0,16(sp)
    80000a2c:	e426                	sd	s1,8(sp)
    80000a2e:	e04a                	sd	s2,0(sp)
    80000a30:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a32:	00023797          	auipc	a5,0x23
    80000a36:	56e78793          	addi	a5,a5,1390 # 80023fa0 <end>
    80000a3a:	00f53733          	sltu	a4,a0,a5
    80000a3e:	47c5                	li	a5,17
    80000a40:	07ee                	slli	a5,a5,0x1b
    80000a42:	17fd                	addi	a5,a5,-1
    80000a44:	00a7b7b3          	sltu	a5,a5,a0
    80000a48:	8fd9                	or	a5,a5,a4
    80000a4a:	ef95                	bnez	a5,80000a86 <kfree+0x60>
    80000a4c:	84aa                	mv	s1,a0
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	eb95                	bnez	a5,80000a86 <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	4585                	li	a1,1
    80000a58:	250000ef          	jal	80000ca8 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a5c:	00012917          	auipc	s2,0x12
    80000a60:	b1490913          	addi	s2,s2,-1260 # 80012570 <kmem>
    80000a64:	854a                	mv	a0,s2
    80000a66:	182000ef          	jal	80000be8 <acquire>
  r->next = kmem.freelist;
    80000a6a:	01893783          	ld	a5,24(s2)
    80000a6e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a70:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a74:	854a                	mv	a0,s2
    80000a76:	1fa000ef          	jal	80000c70 <release>
}
    80000a7a:	60e2                	ld	ra,24(sp)
    80000a7c:	6442                	ld	s0,16(sp)
    80000a7e:	64a2                	ld	s1,8(sp)
    80000a80:	6902                	ld	s2,0(sp)
    80000a82:	6105                	addi	sp,sp,32
    80000a84:	8082                	ret
    panic("kfree");
    80000a86:	00006517          	auipc	a0,0x6
    80000a8a:	5b250513          	addi	a0,a0,1458 # 80007038 <etext+0x38>
    80000a8e:	da7ff0ef          	jal	80000834 <panic>

0000000080000a92 <freerange>:
{
    80000a92:	7179                	addi	sp,sp,-48
    80000a94:	f406                	sd	ra,40(sp)
    80000a96:	f022                	sd	s0,32(sp)
    80000a98:	ec26                	sd	s1,24(sp)
    80000a9a:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000a9c:	6785                	lui	a5,0x1
    80000a9e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aa2:	00e504b3          	add	s1,a0,a4
    80000aa6:	777d                	lui	a4,0xfffff
    80000aa8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aaa:	94be                	add	s1,s1,a5
    80000aac:	0295e263          	bltu	a1,s1,80000ad0 <freerange+0x3e>
    80000ab0:	e84a                	sd	s2,16(sp)
    80000ab2:	e44e                	sd	s3,8(sp)
    80000ab4:	e052                	sd	s4,0(sp)
    80000ab6:	892e                	mv	s2,a1
    kfree(p);
    80000ab8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aba:	89be                	mv	s3,a5
    kfree(p);
    80000abc:	01448533          	add	a0,s1,s4
    80000ac0:	f67ff0ef          	jal	80000a26 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ac4:	94ce                	add	s1,s1,s3
    80000ac6:	fe997be3          	bgeu	s2,s1,80000abc <freerange+0x2a>
    80000aca:	6942                	ld	s2,16(sp)
    80000acc:	69a2                	ld	s3,8(sp)
    80000ace:	6a02                	ld	s4,0(sp)
}
    80000ad0:	70a2                	ld	ra,40(sp)
    80000ad2:	7402                	ld	s0,32(sp)
    80000ad4:	64e2                	ld	s1,24(sp)
    80000ad6:	6145                	addi	sp,sp,48
    80000ad8:	8082                	ret

0000000080000ada <kinit>:
{
    80000ada:	1141                	addi	sp,sp,-16
    80000adc:	e406                	sd	ra,8(sp)
    80000ade:	e022                	sd	s0,0(sp)
    80000ae0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ae2:	00006597          	auipc	a1,0x6
    80000ae6:	55e58593          	addi	a1,a1,1374 # 80007040 <etext+0x40>
    80000aea:	00012517          	auipc	a0,0x12
    80000aee:	a8650513          	addi	a0,a0,-1402 # 80012570 <kmem>
    80000af2:	076000ef          	jal	80000b68 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000af6:	45c5                	li	a1,17
    80000af8:	05ee                	slli	a1,a1,0x1b
    80000afa:	00023517          	auipc	a0,0x23
    80000afe:	4a650513          	addi	a0,a0,1190 # 80023fa0 <end>
    80000b02:	f91ff0ef          	jal	80000a92 <freerange>
}
    80000b06:	60a2                	ld	ra,8(sp)
    80000b08:	6402                	ld	s0,0(sp)
    80000b0a:	0141                	addi	sp,sp,16
    80000b0c:	8082                	ret

0000000080000b0e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b0e:	1101                	addi	sp,sp,-32
    80000b10:	ec06                	sd	ra,24(sp)
    80000b12:	e822                	sd	s0,16(sp)
    80000b14:	e426                	sd	s1,8(sp)
    80000b16:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b18:	00012517          	auipc	a0,0x12
    80000b1c:	a5850513          	addi	a0,a0,-1448 # 80012570 <kmem>
    80000b20:	0c8000ef          	jal	80000be8 <acquire>
  r = kmem.freelist;
    80000b24:	00012497          	auipc	s1,0x12
    80000b28:	a644b483          	ld	s1,-1436(s1) # 80012588 <kmem+0x18>
  if (r)
    80000b2c:	c49d                	beqz	s1,80000b5a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b2e:	609c                	ld	a5,0(s1)
    80000b30:	00012717          	auipc	a4,0x12
    80000b34:	a4f73c23          	sd	a5,-1448(a4) # 80012588 <kmem+0x18>
  release(&kmem.lock);
    80000b38:	00012517          	auipc	a0,0x12
    80000b3c:	a3850513          	addi	a0,a0,-1480 # 80012570 <kmem>
    80000b40:	130000ef          	jal	80000c70 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b44:	6605                	lui	a2,0x1
    80000b46:	4595                	li	a1,5
    80000b48:	8526                	mv	a0,s1
    80000b4a:	15e000ef          	jal	80000ca8 <memset>
  return (void *)r;
}
    80000b4e:	8526                	mv	a0,s1
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret
  release(&kmem.lock);
    80000b5a:	00012517          	auipc	a0,0x12
    80000b5e:	a1650513          	addi	a0,a0,-1514 # 80012570 <kmem>
    80000b62:	10e000ef          	jal	80000c70 <release>
  if (r)
    80000b66:	b7e5                	j	80000b4e <kalloc+0x40>

0000000080000b68 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b68:	1141                	addi	sp,sp,-16
    80000b6a:	e406                	sd	ra,8(sp)
    80000b6c:	e022                	sd	s0,0(sp)
    80000b6e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b70:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b72:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b76:	00053823          	sd	zero,16(a0)
}
    80000b7a:	60a2                	ld	ra,8(sp)
    80000b7c:	6402                	ld	s0,0(sp)
    80000b7e:	0141                	addi	sp,sp,16
    80000b80:	8082                	ret

0000000080000b82 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b82:	411c                	lw	a5,0(a0)
    80000b84:	e399                	bnez	a5,80000b8a <holding+0x8>
    80000b86:	4501                	li	a0,0
  return r;
}
    80000b88:	8082                	ret
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	691c                	ld	a5,16(a0)
    80000b96:	84be                	mv	s1,a5
    80000b98:	545000ef          	jal	800018dc <mycpu>
    80000b9c:	40a48533          	sub	a0,s1,a0
    80000ba0:	00153513          	seqz	a0,a0
}
    80000ba4:	60e2                	ld	ra,24(sp)
    80000ba6:	6442                	ld	s0,16(sp)
    80000ba8:	64a2                	ld	s1,8(sp)
    80000baa:	6105                	addi	sp,sp,32
    80000bac:	8082                	ret

0000000080000bae <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bae:	1101                	addi	sp,sp,-32
    80000bb0:	ec06                	sd	ra,24(sp)
    80000bb2:	e822                	sd	s0,16(sp)
    80000bb4:	e426                	sd	s1,8(sp)
    80000bb6:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000bb8:	100177f3          	csrrci	a5,sstatus,2
    80000bbc:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000bbe:	51f000ef          	jal	800018dc <mycpu>
    80000bc2:	5d3c                	lw	a5,120(a0)
    80000bc4:	cb99                	beqz	a5,80000bda <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bc6:	517000ef          	jal	800018dc <mycpu>
    80000bca:	5d3c                	lw	a5,120(a0)
    80000bcc:	2785                	addiw	a5,a5,1
    80000bce:	dd3c                	sw	a5,120(a0)
}
    80000bd0:	60e2                	ld	ra,24(sp)
    80000bd2:	6442                	ld	s0,16(sp)
    80000bd4:	64a2                	ld	s1,8(sp)
    80000bd6:	6105                	addi	sp,sp,32
    80000bd8:	8082                	ret
    mycpu()->intena = old;
    80000bda:	503000ef          	jal	800018dc <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000bde:	0014d793          	srli	a5,s1,0x1
    80000be2:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000be4:	dd7c                	sw	a5,124(a0)
    80000be6:	b7c5                	j	80000bc6 <push_off+0x18>

0000000080000be8 <acquire>:
{
    80000be8:	1101                	addi	sp,sp,-32
    80000bea:	ec06                	sd	ra,24(sp)
    80000bec:	e822                	sd	s0,16(sp)
    80000bee:	e426                	sd	s1,8(sp)
    80000bf0:	1000                	addi	s0,sp,32
    80000bf2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bf4:	fbbff0ef          	jal	80000bae <push_off>
  if (holding(lk))
    80000bf8:	8526                	mv	a0,s1
    80000bfa:	f89ff0ef          	jal	80000b82 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000bfe:	4705                	li	a4,1
  if (holding(lk))
    80000c00:	ed11                	bnez	a0,80000c1c <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c02:	87ba                	mv	a5,a4
    80000c04:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c08:	2781                	sext.w	a5,a5
    80000c0a:	ffe5                	bnez	a5,80000c02 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c0c:	4d1000ef          	jal	800018dc <mycpu>
    80000c10:	e888                	sd	a0,16(s1)
}
    80000c12:	60e2                	ld	ra,24(sp)
    80000c14:	6442                	ld	s0,16(sp)
    80000c16:	64a2                	ld	s1,8(sp)
    80000c18:	6105                	addi	sp,sp,32
    80000c1a:	8082                	ret
    panic("acquire");
    80000c1c:	00006517          	auipc	a0,0x6
    80000c20:	42c50513          	addi	a0,a0,1068 # 80007048 <etext+0x48>
    80000c24:	c11ff0ef          	jal	80000834 <panic>

0000000080000c28 <pop_off>:

void
pop_off(void)
{
    80000c28:	1141                	addi	sp,sp,-16
    80000c2a:	e406                	sd	ra,8(sp)
    80000c2c:	e022                	sd	s0,0(sp)
    80000c2e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c30:	4ad000ef          	jal	800018dc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c38:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c3a:	ef99                	bnez	a5,80000c58 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c3c:	5d3c                	lw	a5,120(a0)
    80000c3e:	02f05363          	blez	a5,80000c64 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c42:	37fd                	addiw	a5,a5,-1
    80000c44:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c46:	e789                	bnez	a5,80000c50 <pop_off+0x28>
    80000c48:	5d7c                	lw	a5,124(a0)
    80000c4a:	c399                	beqz	a5,80000c50 <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c4c:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c50:	60a2                	ld	ra,8(sp)
    80000c52:	6402                	ld	s0,0(sp)
    80000c54:	0141                	addi	sp,sp,16
    80000c56:	8082                	ret
    panic("pop_off - interruptible");
    80000c58:	00006517          	auipc	a0,0x6
    80000c5c:	3f850513          	addi	a0,a0,1016 # 80007050 <etext+0x50>
    80000c60:	bd5ff0ef          	jal	80000834 <panic>
    panic("pop_off");
    80000c64:	00006517          	auipc	a0,0x6
    80000c68:	40450513          	addi	a0,a0,1028 # 80007068 <etext+0x68>
    80000c6c:	bc9ff0ef          	jal	80000834 <panic>

0000000080000c70 <release>:
{
    80000c70:	1101                	addi	sp,sp,-32
    80000c72:	ec06                	sd	ra,24(sp)
    80000c74:	e822                	sd	s0,16(sp)
    80000c76:	e426                	sd	s1,8(sp)
    80000c78:	1000                	addi	s0,sp,32
    80000c7a:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000c7c:	f07ff0ef          	jal	80000b82 <holding>
    80000c80:	cd11                	beqz	a0,80000c9c <release+0x2c>
  lk->cpu = 0;
    80000c82:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000c86:	0310000f          	fence	rw,w
    80000c8a:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c8e:	f9bff0ef          	jal	80000c28 <pop_off>
}
    80000c92:	60e2                	ld	ra,24(sp)
    80000c94:	6442                	ld	s0,16(sp)
    80000c96:	64a2                	ld	s1,8(sp)
    80000c98:	6105                	addi	sp,sp,32
    80000c9a:	8082                	ret
    panic("release");
    80000c9c:	00006517          	auipc	a0,0x6
    80000ca0:	3d450513          	addi	a0,a0,980 # 80007070 <etext+0x70>
    80000ca4:	b91ff0ef          	jal	80000834 <panic>

0000000080000ca8 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000ca8:	1141                	addi	sp,sp,-16
    80000caa:	e406                	sd	ra,8(sp)
    80000cac:	e022                	sd	s0,0(sp)
    80000cae:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cb0:	ca19                	beqz	a2,80000cc6 <memset+0x1e>
    80000cb2:	87aa                	mv	a5,a0
    80000cb4:	1602                	slli	a2,a2,0x20
    80000cb6:	9201                	srli	a2,a2,0x20
    80000cb8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cbc:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000cc0:	0785                	addi	a5,a5,1
    80000cc2:	fee79de3          	bne	a5,a4,80000cbc <memset+0x14>
  }
  return dst;
}
    80000cc6:	60a2                	ld	ra,8(sp)
    80000cc8:	6402                	ld	s0,0(sp)
    80000cca:	0141                	addi	sp,sp,16
    80000ccc:	8082                	ret

0000000080000cce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e406                	sd	ra,8(sp)
    80000cd2:	e022                	sd	s0,0(sp)
    80000cd4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000cd6:	c61d                	beqz	a2,80000d04 <memcmp+0x36>
    80000cd8:	1602                	slli	a2,a2,0x20
    80000cda:	9201                	srli	a2,a2,0x20
    80000cdc:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000ce0:	00054783          	lbu	a5,0(a0)
    80000ce4:	0005c703          	lbu	a4,0(a1)
    80000ce8:	00e79863          	bne	a5,a4,80000cf8 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000cec:	0505                	addi	a0,a0,1
    80000cee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000cf0:	fed518e3          	bne	a0,a3,80000ce0 <memcmp+0x12>
  }

  return 0;
    80000cf4:	4501                	li	a0,0
    80000cf6:	a019                	j	80000cfc <memcmp+0x2e>
      return *s1 - *s2;
    80000cf8:	40e7853b          	subw	a0,a5,a4
}
    80000cfc:	60a2                	ld	ra,8(sp)
    80000cfe:	6402                	ld	s0,0(sp)
    80000d00:	0141                	addi	sp,sp,16
    80000d02:	8082                	ret
  return 0;
    80000d04:	4501                	li	a0,0
    80000d06:	bfdd                	j	80000cfc <memcmp+0x2e>

0000000080000d08 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d08:	1141                	addi	sp,sp,-16
    80000d0a:	e406                	sd	ra,8(sp)
    80000d0c:	e022                	sd	s0,0(sp)
    80000d0e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d10:	c205                	beqz	a2,80000d30 <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d12:	02a5e363          	bltu	a1,a0,80000d38 <memmove+0x30>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d16:	1602                	slli	a2,a2,0x20
    80000d18:	9201                	srli	a2,a2,0x20
    80000d1a:	00c587b3          	add	a5,a1,a2
{
    80000d1e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d20:	0585                	addi	a1,a1,1
    80000d22:	0705                	addi	a4,a4,1
    80000d24:	fff5c683          	lbu	a3,-1(a1)
    80000d28:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d2c:	feb79ae3          	bne	a5,a1,80000d20 <memmove+0x18>

  return dst;
}
    80000d30:	60a2                	ld	ra,8(sp)
    80000d32:	6402                	ld	s0,0(sp)
    80000d34:	0141                	addi	sp,sp,16
    80000d36:	8082                	ret
  if (s < d && s + n > d) {
    80000d38:	02061693          	slli	a3,a2,0x20
    80000d3c:	9281                	srli	a3,a3,0x20
    80000d3e:	00d58733          	add	a4,a1,a3
    80000d42:	fce57ae3          	bgeu	a0,a4,80000d16 <memmove+0xe>
    d += n;
    80000d46:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d48:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d4c:	1782                	slli	a5,a5,0x20
    80000d4e:	9381                	srli	a5,a5,0x20
    80000d50:	fff7c793          	not	a5,a5
    80000d54:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d56:	177d                	addi	a4,a4,-1
    80000d58:	16fd                	addi	a3,a3,-1
    80000d5a:	00074603          	lbu	a2,0(a4)
    80000d5e:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d62:	fee79ae3          	bne	a5,a4,80000d56 <memmove+0x4e>
    80000d66:	b7e9                	j	80000d30 <memmove+0x28>

0000000080000d68 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e406                	sd	ra,8(sp)
    80000d6c:	e022                	sd	s0,0(sp)
    80000d6e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d70:	f99ff0ef          	jal	80000d08 <memmove>
}
    80000d74:	60a2                	ld	ra,8(sp)
    80000d76:	6402                	ld	s0,0(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret

0000000080000d7c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e406                	sd	ra,8(sp)
    80000d80:	e022                	sd	s0,0(sp)
    80000d82:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000d84:	ce11                	beqz	a2,80000da0 <strncmp+0x24>
    80000d86:	00054783          	lbu	a5,0(a0)
    80000d8a:	cf89                	beqz	a5,80000da4 <strncmp+0x28>
    80000d8c:	0005c703          	lbu	a4,0(a1)
    80000d90:	00f71a63          	bne	a4,a5,80000da4 <strncmp+0x28>
    n--, p++, q++;
    80000d94:	367d                	addiw	a2,a2,-1
    80000d96:	0505                	addi	a0,a0,1
    80000d98:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000d9a:	f675                	bnez	a2,80000d86 <strncmp+0xa>
  if (n == 0)
    return 0;
    80000d9c:	4501                	li	a0,0
    80000d9e:	a801                	j	80000dae <strncmp+0x32>
    80000da0:	4501                	li	a0,0
    80000da2:	a031                	j	80000dae <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000da4:	00054503          	lbu	a0,0(a0)
    80000da8:	0005c783          	lbu	a5,0(a1)
    80000dac:	9d1d                	subw	a0,a0,a5
}
    80000dae:	60a2                	ld	ra,8(sp)
    80000db0:	6402                	ld	s0,0(sp)
    80000db2:	0141                	addi	sp,sp,16
    80000db4:	8082                	ret

0000000080000db6 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000db6:	1141                	addi	sp,sp,-16
    80000db8:	e406                	sd	ra,8(sp)
    80000dba:	e022                	sd	s0,0(sp)
    80000dbc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000dbe:	87aa                	mv	a5,a0
    80000dc0:	a011                	j	80000dc4 <strncpy+0xe>
    80000dc2:	8636                	mv	a2,a3
    80000dc4:	02c05863          	blez	a2,80000df4 <strncpy+0x3e>
    80000dc8:	fff6069b          	addiw	a3,a2,-1
    80000dcc:	8836                	mv	a6,a3
    80000dce:	0785                	addi	a5,a5,1
    80000dd0:	0005c703          	lbu	a4,0(a1)
    80000dd4:	fee78fa3          	sb	a4,-1(a5)
    80000dd8:	0585                	addi	a1,a1,1
    80000dda:	f765                	bnez	a4,80000dc2 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000ddc:	873e                	mv	a4,a5
    80000dde:	01005b63          	blez	a6,80000df4 <strncpy+0x3e>
    80000de2:	9fb1                	addw	a5,a5,a2
    80000de4:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000de6:	0705                	addi	a4,a4,1
    80000de8:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000dec:	40e786bb          	subw	a3,a5,a4
    80000df0:	fed04be3          	bgtz	a3,80000de6 <strncpy+0x30>
  return os;
}
    80000df4:	60a2                	ld	ra,8(sp)
    80000df6:	6402                	ld	s0,0(sp)
    80000df8:	0141                	addi	sp,sp,16
    80000dfa:	8082                	ret

0000000080000dfc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000dfc:	1141                	addi	sp,sp,-16
    80000dfe:	e406                	sd	ra,8(sp)
    80000e00:	e022                	sd	s0,0(sp)
    80000e02:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e04:	02c05363          	blez	a2,80000e2a <safestrcpy+0x2e>
    80000e08:	fff6069b          	addiw	a3,a2,-1
    80000e0c:	1682                	slli	a3,a3,0x20
    80000e0e:	9281                	srli	a3,a3,0x20
    80000e10:	96ae                	add	a3,a3,a1
    80000e12:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e14:	00d58963          	beq	a1,a3,80000e26 <safestrcpy+0x2a>
    80000e18:	0585                	addi	a1,a1,1
    80000e1a:	0785                	addi	a5,a5,1
    80000e1c:	fff5c703          	lbu	a4,-1(a1)
    80000e20:	fee78fa3          	sb	a4,-1(a5)
    80000e24:	fb65                	bnez	a4,80000e14 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e26:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e2a:	60a2                	ld	ra,8(sp)
    80000e2c:	6402                	ld	s0,0(sp)
    80000e2e:	0141                	addi	sp,sp,16
    80000e30:	8082                	ret

0000000080000e32 <strlen>:

int
strlen(const char *s)
{
    80000e32:	1141                	addi	sp,sp,-16
    80000e34:	e406                	sd	ra,8(sp)
    80000e36:	e022                	sd	s0,0(sp)
    80000e38:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e3a:	00054783          	lbu	a5,0(a0)
    80000e3e:	cf91                	beqz	a5,80000e5a <strlen+0x28>
    80000e40:	00150793          	addi	a5,a0,1
    80000e44:	86be                	mv	a3,a5
    80000e46:	0785                	addi	a5,a5,1
    80000e48:	fff7c703          	lbu	a4,-1(a5)
    80000e4c:	ff65                	bnez	a4,80000e44 <strlen+0x12>
    80000e4e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e52:	60a2                	ld	ra,8(sp)
    80000e54:	6402                	ld	s0,0(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e5a:	4501                	li	a0,0
    80000e5c:	bfdd                	j	80000e52 <strlen+0x20>

0000000080000e5e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e5e:	1141                	addi	sp,sp,-16
    80000e60:	e406                	sd	ra,8(sp)
    80000e62:	e022                	sd	s0,0(sp)
    80000e64:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e66:	263000ef          	jal	800018c8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e6a:	00009717          	auipc	a4,0x9
    80000e6e:	5f270713          	addi	a4,a4,1522 # 8000a45c <started>
  if (cpuid() == 0) {
    80000e72:	c51d                	beqz	a0,80000ea0 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e74:	431c                	lw	a5,0(a4)
    80000e76:	0230000f          	fence	r,rw
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dfe5                	beqz	a5,80000e74 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000e7e:	24b000ef          	jal	800018c8 <cpuid>
    80000e82:	85aa                	mv	a1,a0
    80000e84:	00006517          	auipc	a0,0x6
    80000e88:	21450513          	addi	a0,a0,532 # 80007098 <etext+0x98>
    80000e8c:	e7eff0ef          	jal	8000050a <printk>
    kvminithart();  // turn on paging
    80000e90:	082000ef          	jal	80000f12 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000e94:	0b5010ef          	jal	80002748 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000e98:	271040ef          	jal	80005908 <plicinithart>
  }

  scheduler();
    80000e9c:	73f000ef          	jal	80001dda <scheduler>
    consoleinit();
    80000ea0:	d90ff0ef          	jal	80000430 <consoleinit>
    printkinit();
    80000ea4:	9cdff0ef          	jal	80000870 <printkinit>
    printk("\n");
    80000ea8:	00006517          	auipc	a0,0x6
    80000eac:	1d050513          	addi	a0,a0,464 # 80007078 <etext+0x78>
    80000eb0:	e5aff0ef          	jal	8000050a <printk>
    printk("xv6 kernel is booting\n");
    80000eb4:	00006517          	auipc	a0,0x6
    80000eb8:	1cc50513          	addi	a0,a0,460 # 80007080 <etext+0x80>
    80000ebc:	e4eff0ef          	jal	8000050a <printk>
    printk("\n");
    80000ec0:	00006517          	auipc	a0,0x6
    80000ec4:	1b850513          	addi	a0,a0,440 # 80007078 <etext+0x78>
    80000ec8:	e42ff0ef          	jal	8000050a <printk>
    kinit();            // physical page allocator
    80000ecc:	c0fff0ef          	jal	80000ada <kinit>
    kvminit();          // create kernel page table
    80000ed0:	2ce000ef          	jal	8000119e <kvminit>
    kvminithart();      // turn on paging
    80000ed4:	03e000ef          	jal	80000f12 <kvminithart>
    procinit();         // process table
    80000ed8:	141000ef          	jal	80001818 <procinit>
    trapinit();         // trap vectors
    80000edc:	049010ef          	jal	80002724 <trapinit>
    trapinithart();     // install kernel trap vector
    80000ee0:	069010ef          	jal	80002748 <trapinithart>
    plicinit();         // set up interrupt controller
    80000ee4:	20b040ef          	jal	800058ee <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000ee8:	221040ef          	jal	80005908 <plicinithart>
    binit();            // buffer cache
    80000eec:	703010ef          	jal	80002dee <binit>
    iinit();            // inode table
    80000ef0:	454020ef          	jal	80003344 <iinit>
    fileinit();         // file table
    80000ef4:	474030ef          	jal	80004368 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ef8:	301040ef          	jal	800059f8 <virtio_disk_init>
    userinit();         // first user process
    80000efc:	4f5000ef          	jal	80001bf0 <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f00:	00009797          	auipc	a5,0x9
    80000f04:	55c78793          	addi	a5,a5,1372 # 8000a45c <started>
    80000f08:	4705                	li	a4,1
    80000f0a:	0310000f          	fence	rw,w
    80000f0e:	c398                	sw	a4,0(a5)
    80000f10:	b771                	j	80000e9c <main+0x3e>

0000000080000f12 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e406                	sd	ra,8(sp)
    80000f16:	e022                	sd	s0,0(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00009797          	auipc	a5,0x9
    80000f22:	5427b783          	ld	a5,1346(a5) # 8000a460 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	60a2                	ld	ra,8(sp)
    80000f38:	6402                	ld	s0,0(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3e:	7139                	addi	sp,sp,-64
    80000f40:	fc06                	sd	ra,56(sp)
    80000f42:	f822                	sd	s0,48(sp)
    80000f44:	f426                	sd	s1,40(sp)
    80000f46:	f04a                	sd	s2,32(sp)
    80000f48:	ec4e                	sd	s3,24(sp)
    80000f4a:	e852                	sd	s4,16(sp)
    80000f4c:	e456                	sd	s5,8(sp)
    80000f4e:	e05a                	sd	s6,0(sp)
    80000f50:	0080                	addi	s0,sp,64
    80000f52:	84aa                	mv	s1,a0
    80000f54:	89ae                	mv	s3,a1
    80000f56:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f58:	57fd                	li	a5,-1
    80000f5a:	83e9                	srli	a5,a5,0x1a
    80000f5c:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f5e:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f60:	04b7e263          	bltu	a5,a1,80000fa4 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f64:	0149d933          	srl	s2,s3,s4
    80000f68:	1ff97913          	andi	s2,s2,511
    80000f6c:	090e                	slli	s2,s2,0x3
    80000f6e:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f70:	00093483          	ld	s1,0(s2)
    80000f74:	0014f793          	andi	a5,s1,1
    80000f78:	cf85                	beqz	a5,80000fb0 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f7a:	80a9                	srli	s1,s1,0xa
    80000f7c:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--) {
    80000f7e:	3a5d                	addiw	s4,s4,-9
    80000f80:	ff5a12e3          	bne	s4,s5,80000f64 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000f84:	00c9d513          	srli	a0,s3,0xc
    80000f88:	1ff57513          	andi	a0,a0,511
    80000f8c:	050e                	slli	a0,a0,0x3
    80000f8e:	9526                	add	a0,a0,s1
}
    80000f90:	70e2                	ld	ra,56(sp)
    80000f92:	7442                	ld	s0,48(sp)
    80000f94:	74a2                	ld	s1,40(sp)
    80000f96:	7902                	ld	s2,32(sp)
    80000f98:	69e2                	ld	s3,24(sp)
    80000f9a:	6a42                	ld	s4,16(sp)
    80000f9c:	6aa2                	ld	s5,8(sp)
    80000f9e:	6b02                	ld	s6,0(sp)
    80000fa0:	6121                	addi	sp,sp,64
    80000fa2:	8082                	ret
    panic("walk");
    80000fa4:	00006517          	auipc	a0,0x6
    80000fa8:	10c50513          	addi	a0,a0,268 # 800070b0 <etext+0xb0>
    80000fac:	889ff0ef          	jal	80000834 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000fb0:	020b0263          	beqz	s6,80000fd4 <walk+0x96>
    80000fb4:	b5bff0ef          	jal	80000b0e <kalloc>
    80000fb8:	84aa                	mv	s1,a0
    80000fba:	d979                	beqz	a0,80000f90 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fbc:	6605                	lui	a2,0x1
    80000fbe:	4581                	li	a1,0
    80000fc0:	ce9ff0ef          	jal	80000ca8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fc4:	00c4d793          	srli	a5,s1,0xc
    80000fc8:	07aa                	slli	a5,a5,0xa
    80000fca:	0017e793          	ori	a5,a5,1
    80000fce:	00f93023          	sd	a5,0(s2)
    80000fd2:	b775                	j	80000f7e <walk+0x40>
        return 0;
    80000fd4:	4501                	li	a0,0
    80000fd6:	bf6d                	j	80000f90 <walk+0x52>

0000000080000fd8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000fd8:	57fd                	li	a5,-1
    80000fda:	83e9                	srli	a5,a5,0x1a
    80000fdc:	00b7f463          	bgeu	a5,a1,80000fe4 <walkaddr+0xc>
    return 0;
    80000fe0:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe2:	8082                	ret
{
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e406                	sd	ra,8(sp)
    80000fe8:	e022                	sd	s0,0(sp)
    80000fea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fec:	4601                	li	a2,0
    80000fee:	f51ff0ef          	jal	80000f3e <walk>
  if (pte == 0)
    80000ff2:	c901                	beqz	a0,80001002 <walkaddr+0x2a>
  if ((*pte & PTE_V) == 0)
    80000ff4:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000ff6:	0117f693          	andi	a3,a5,17
    80000ffa:	4745                	li	a4,17
    return 0;
    80000ffc:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80000ffe:	00e68663          	beq	a3,a4,8000100a <walkaddr+0x32>
}
    80001002:	60a2                	ld	ra,8(sp)
    80001004:	6402                	ld	s0,0(sp)
    80001006:	0141                	addi	sp,sp,16
    80001008:	8082                	ret
  pa = PTE2PA(*pte);
    8000100a:	83a9                	srli	a5,a5,0xa
    8000100c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001010:	bfcd                	j	80001002 <walkaddr+0x2a>

0000000080001012 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001012:	715d                	addi	sp,sp,-80
    80001014:	e486                	sd	ra,72(sp)
    80001016:	e0a2                	sd	s0,64(sp)
    80001018:	fc26                	sd	s1,56(sp)
    8000101a:	f84a                	sd	s2,48(sp)
    8000101c:	f44e                	sd	s3,40(sp)
    8000101e:	f052                	sd	s4,32(sp)
    80001020:	ec56                	sd	s5,24(sp)
    80001022:	e85a                	sd	s6,16(sp)
    80001024:	e45e                	sd	s7,8(sp)
    80001026:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001028:	03459793          	slli	a5,a1,0x34
    8000102c:	eba1                	bnez	a5,8000107c <mappages+0x6a>
    8000102e:	8a2a                	mv	s4,a0
    80001030:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001032:	03461793          	slli	a5,a2,0x34
    80001036:	eba9                	bnez	a5,80001088 <mappages+0x76>
    panic("mappages: size not aligned");

  if (size == 0)
    80001038:	ce31                	beqz	a2,80001094 <mappages+0x82>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000103a:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000103e:	80060613          	addi	a2,a2,-2048
    80001042:	00b60933          	add	s2,a2,a1
  a = va;
    80001046:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001048:	4b05                	li	s6,1
    8000104a:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000104e:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001050:	865a                	mv	a2,s6
    80001052:	85a6                	mv	a1,s1
    80001054:	8552                	mv	a0,s4
    80001056:	ee9ff0ef          	jal	80000f3e <walk>
    8000105a:	c929                	beqz	a0,800010ac <mappages+0x9a>
    if (*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	e3a1                	bnez	a5,800010a0 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	013487b3          	add	a5,s1,s3
    80001066:	83b1                	srli	a5,a5,0xc
    80001068:	07aa                	slli	a5,a5,0xa
    8000106a:	0157e7b3          	or	a5,a5,s5
    8000106e:	0017e793          	ori	a5,a5,1
    80001072:	e11c                	sd	a5,0(a0)
    if (a == last)
    80001074:	05248863          	beq	s1,s2,800010c4 <mappages+0xb2>
    a += PGSIZE;
    80001078:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	bfd9                	j	80001050 <mappages+0x3e>
    panic("mappages: va not aligned");
    8000107c:	00006517          	auipc	a0,0x6
    80001080:	03c50513          	addi	a0,a0,60 # 800070b8 <etext+0xb8>
    80001084:	fb0ff0ef          	jal	80000834 <panic>
    panic("mappages: size not aligned");
    80001088:	00006517          	auipc	a0,0x6
    8000108c:	05050513          	addi	a0,a0,80 # 800070d8 <etext+0xd8>
    80001090:	fa4ff0ef          	jal	80000834 <panic>
    panic("mappages: size");
    80001094:	00006517          	auipc	a0,0x6
    80001098:	06450513          	addi	a0,a0,100 # 800070f8 <etext+0xf8>
    8000109c:	f98ff0ef          	jal	80000834 <panic>
      panic("mappages: remap");
    800010a0:	00006517          	auipc	a0,0x6
    800010a4:	06850513          	addi	a0,a0,104 # 80007108 <etext+0x108>
    800010a8:	f8cff0ef          	jal	80000834 <panic>
      return -1;
    800010ac:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010ae:	60a6                	ld	ra,72(sp)
    800010b0:	6406                	ld	s0,64(sp)
    800010b2:	74e2                	ld	s1,56(sp)
    800010b4:	7942                	ld	s2,48(sp)
    800010b6:	79a2                	ld	s3,40(sp)
    800010b8:	7a02                	ld	s4,32(sp)
    800010ba:	6ae2                	ld	s5,24(sp)
    800010bc:	6b42                	ld	s6,16(sp)
    800010be:	6ba2                	ld	s7,8(sp)
    800010c0:	6161                	addi	sp,sp,80
    800010c2:	8082                	ret
  return 0;
    800010c4:	4501                	li	a0,0
    800010c6:	b7e5                	j	800010ae <mappages+0x9c>

00000000800010c8 <kvmmap>:
{
    800010c8:	1141                	addi	sp,sp,-16
    800010ca:	e406                	sd	ra,8(sp)
    800010cc:	e022                	sd	s0,0(sp)
    800010ce:	0800                	addi	s0,sp,16
    800010d0:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010d2:	86b2                	mv	a3,a2
    800010d4:	863e                	mv	a2,a5
    800010d6:	f3dff0ef          	jal	80001012 <mappages>
    800010da:	e509                	bnez	a0,800010e4 <kvmmap+0x1c>
}
    800010dc:	60a2                	ld	ra,8(sp)
    800010de:	6402                	ld	s0,0(sp)
    800010e0:	0141                	addi	sp,sp,16
    800010e2:	8082                	ret
    panic("kvmmap");
    800010e4:	00006517          	auipc	a0,0x6
    800010e8:	03450513          	addi	a0,a0,52 # 80007118 <etext+0x118>
    800010ec:	f48ff0ef          	jal	80000834 <panic>

00000000800010f0 <kvmmake>:
{
    800010f0:	1101                	addi	sp,sp,-32
    800010f2:	ec06                	sd	ra,24(sp)
    800010f4:	e822                	sd	s0,16(sp)
    800010f6:	e426                	sd	s1,8(sp)
    800010f8:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800010fa:	a15ff0ef          	jal	80000b0e <kalloc>
    800010fe:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001100:	6605                	lui	a2,0x1
    80001102:	4581                	li	a1,0
    80001104:	ba5ff0ef          	jal	80000ca8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001108:	4719                	li	a4,6
    8000110a:	6685                	lui	a3,0x1
    8000110c:	10000637          	lui	a2,0x10000
    80001110:	85b2                	mv	a1,a2
    80001112:	8526                	mv	a0,s1
    80001114:	fb5ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	85b2                	mv	a1,a2
    80001122:	8526                	mv	a0,s1
    80001124:	fa5ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001128:	4719                	li	a4,6
    8000112a:	040006b7          	lui	a3,0x4000
    8000112e:	0c000637          	lui	a2,0xc000
    80001132:	85b2                	mv	a1,a2
    80001134:	8526                	mv	a0,s1
    80001136:	f93ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000113a:	4729                	li	a4,10
    8000113c:	80006697          	auipc	a3,0x80006
    80001140:	ec468693          	addi	a3,a3,-316 # 7000 <_entry-0x7fff9000>
    80001144:	4605                	li	a2,1
    80001146:	067e                	slli	a2,a2,0x1f
    80001148:	85b2                	mv	a1,a2
    8000114a:	8526                	mv	a0,s1
    8000114c:	f7dff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001150:	4719                	li	a4,6
    80001152:	00006697          	auipc	a3,0x6
    80001156:	eae68693          	addi	a3,a3,-338 # 80007000 <etext>
    8000115a:	47c5                	li	a5,17
    8000115c:	07ee                	slli	a5,a5,0x1b
    8000115e:	40d786b3          	sub	a3,a5,a3
    80001162:	00006617          	auipc	a2,0x6
    80001166:	e9e60613          	addi	a2,a2,-354 # 80007000 <etext>
    8000116a:	85b2                	mv	a1,a2
    8000116c:	8526                	mv	a0,s1
    8000116e:	f5bff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001172:	4729                	li	a4,10
    80001174:	6685                	lui	a3,0x1
    80001176:	00005617          	auipc	a2,0x5
    8000117a:	e8a60613          	addi	a2,a2,-374 # 80006000 <_trampoline>
    8000117e:	040005b7          	lui	a1,0x4000
    80001182:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001184:	05b2                	slli	a1,a1,0xc
    80001186:	8526                	mv	a0,s1
    80001188:	f41ff0ef          	jal	800010c8 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118c:	8526                	mv	a0,s1
    8000118e:	5ec000ef          	jal	8000177a <proc_mapstacks>
}
    80001192:	8526                	mv	a0,s1
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f4bff0ef          	jal	800010f0 <kvmmake>
    800011aa:	00009797          	auipc	a5,0x9
    800011ae:	2aa7bb23          	sd	a0,694(a5) # 8000a460 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011ba:	1101                	addi	sp,sp,-32
    800011bc:	ec06                	sd	ra,24(sp)
    800011be:	e822                	sd	s0,16(sp)
    800011c0:	e426                	sd	s1,8(sp)
    800011c2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011c4:	94bff0ef          	jal	80000b0e <kalloc>
    800011c8:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011ca:	c509                	beqz	a0,800011d4 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011cc:	6605                	lui	a2,0x1
    800011ce:	4581                	li	a1,0
    800011d0:	ad9ff0ef          	jal	80000ca8 <memset>
  return pagetable;
}
    800011d4:	8526                	mv	a0,s1
    800011d6:	60e2                	ld	ra,24(sp)
    800011d8:	6442                	ld	s0,16(sp)
    800011da:	64a2                	ld	s1,8(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret

00000000800011e0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e0:	7139                	addi	sp,sp,-64
    800011e2:	fc06                	sd	ra,56(sp)
    800011e4:	f822                	sd	s0,48(sp)
    800011e6:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011e8:	03459793          	slli	a5,a1,0x34
    800011ec:	e38d                	bnez	a5,8000120e <uvmunmap+0x2e>
    800011ee:	f04a                	sd	s2,32(sp)
    800011f0:	ec4e                	sd	s3,24(sp)
    800011f2:	e852                	sd	s4,16(sp)
    800011f4:	e456                	sd	s5,8(sp)
    800011f6:	e05a                	sd	s6,0(sp)
    800011f8:	8a2a                	mv	s4,a0
    800011fa:	892e                	mv	s2,a1
    800011fc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800011fe:	0632                	slli	a2,a2,0xc
    80001200:	00b609b3          	add	s3,a2,a1
    80001204:	6b05                	lui	s6,0x1
    80001206:	0535f963          	bgeu	a1,s3,80001258 <uvmunmap+0x78>
    8000120a:	f426                	sd	s1,40(sp)
    8000120c:	a015                	j	80001230 <uvmunmap+0x50>
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000121a:	00006517          	auipc	a0,0x6
    8000121e:	f0650513          	addi	a0,a0,-250 # 80007120 <etext+0x120>
    80001222:	e12ff0ef          	jal	80000834 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    80001226:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000122a:	995a                	add	s2,s2,s6
    8000122c:	03397563          	bgeu	s2,s3,80001256 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001230:	4601                	li	a2,0
    80001232:	85ca                	mv	a1,s2
    80001234:	8552                	mv	a0,s4
    80001236:	d09ff0ef          	jal	80000f3e <walk>
    8000123a:	84aa                	mv	s1,a0
    8000123c:	d57d                	beqz	a0,8000122a <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    8000123e:	611c                	ld	a5,0(a0)
    80001240:	0017f713          	andi	a4,a5,1
    80001244:	d37d                	beqz	a4,8000122a <uvmunmap+0x4a>
    if (do_free) {
    80001246:	fe0a80e3          	beqz	s5,80001226 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000124a:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    8000124c:	00c79513          	slli	a0,a5,0xc
    80001250:	fd6ff0ef          	jal	80000a26 <kfree>
    80001254:	bfc9                	j	80001226 <uvmunmap+0x46>
    80001256:	74a2                	ld	s1,40(sp)
    80001258:	7902                	ld	s2,32(sp)
    8000125a:	69e2                	ld	s3,24(sp)
    8000125c:	6a42                	ld	s4,16(sp)
    8000125e:	6aa2                	ld	s5,8(sp)
    80001260:	6b02                	ld	s6,0(sp)
  }
}
    80001262:	70e2                	ld	ra,56(sp)
    80001264:	7442                	ld	s0,48(sp)
    80001266:	6121                	addi	sp,sp,64
    80001268:	8082                	ret

000000008000126a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000126a:	1101                	addi	sp,sp,-32
    8000126c:	ec06                	sd	ra,24(sp)
    8000126e:	e822                	sd	s0,16(sp)
    80001270:	e426                	sd	s1,8(sp)
    80001272:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001274:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001276:	00b67d63          	bgeu	a2,a1,80001290 <uvmdealloc+0x26>
    8000127a:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000127c:	6785                	lui	a5,0x1
    8000127e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001280:	00f60733          	add	a4,a2,a5
    80001284:	76fd                	lui	a3,0xfffff
    80001286:	8f75                	and	a4,a4,a3
    80001288:	97ae                	add	a5,a5,a1
    8000128a:	8ff5                	and	a5,a5,a3
    8000128c:	00f76863          	bltu	a4,a5,8000129c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000129c:	8f99                	sub	a5,a5,a4
    8000129e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012a0:	4685                	li	a3,1
    800012a2:	0007861b          	sext.w	a2,a5
    800012a6:	85ba                	mv	a1,a4
    800012a8:	f39ff0ef          	jal	800011e0 <uvmunmap>
    800012ac:	b7d5                	j	80001290 <uvmdealloc+0x26>

00000000800012ae <uvmalloc>:
  if (newsz < oldsz)
    800012ae:	0ab66163          	bltu	a2,a1,80001350 <uvmalloc+0xa2>
{
    800012b2:	715d                	addi	sp,sp,-80
    800012b4:	e486                	sd	ra,72(sp)
    800012b6:	e0a2                	sd	s0,64(sp)
    800012b8:	f84a                	sd	s2,48(sp)
    800012ba:	f052                	sd	s4,32(sp)
    800012bc:	ec56                	sd	s5,24(sp)
    800012be:	e45e                	sd	s7,8(sp)
    800012c0:	0880                	addi	s0,sp,80
    800012c2:	8aaa                	mv	s5,a0
    800012c4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012c6:	6785                	lui	a5,0x1
    800012c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ca:	95be                	add	a1,a1,a5
    800012cc:	77fd                	lui	a5,0xfffff
    800012ce:	00f5f933          	and	s2,a1,a5
    800012d2:	8bca                	mv	s7,s2
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012d4:	08c97063          	bgeu	s2,a2,80001354 <uvmalloc+0xa6>
    800012d8:	fc26                	sd	s1,56(sp)
    800012da:	f44e                	sd	s3,40(sp)
    800012dc:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800012de:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012e0:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012e4:	82bff0ef          	jal	80000b0e <kalloc>
    800012e8:	84aa                	mv	s1,a0
    if (mem == 0) {
    800012ea:	c50d                	beqz	a0,80001314 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    800012ec:	864e                	mv	a2,s3
    800012ee:	4581                	li	a1,0
    800012f0:	9b9ff0ef          	jal	80000ca8 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012f4:	875a                	mv	a4,s6
    800012f6:	86a6                	mv	a3,s1
    800012f8:	864e                	mv	a2,s3
    800012fa:	85ca                	mv	a1,s2
    800012fc:	8556                	mv	a0,s5
    800012fe:	d15ff0ef          	jal	80001012 <mappages>
    80001302:	e915                	bnez	a0,80001336 <uvmalloc+0x88>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001304:	994e                	add	s2,s2,s3
    80001306:	fd496fe3          	bltu	s2,s4,800012e4 <uvmalloc+0x36>
  return newsz;
    8000130a:	8552                	mv	a0,s4
    8000130c:	74e2                	ld	s1,56(sp)
    8000130e:	79a2                	ld	s3,40(sp)
    80001310:	6b42                	ld	s6,16(sp)
    80001312:	a811                	j	80001326 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001314:	865e                	mv	a2,s7
    80001316:	85ca                	mv	a1,s2
    80001318:	8556                	mv	a0,s5
    8000131a:	f51ff0ef          	jal	8000126a <uvmdealloc>
      return 0;
    8000131e:	4501                	li	a0,0
    80001320:	74e2                	ld	s1,56(sp)
    80001322:	79a2                	ld	s3,40(sp)
    80001324:	6b42                	ld	s6,16(sp)
}
    80001326:	60a6                	ld	ra,72(sp)
    80001328:	6406                	ld	s0,64(sp)
    8000132a:	7942                	ld	s2,48(sp)
    8000132c:	7a02                	ld	s4,32(sp)
    8000132e:	6ae2                	ld	s5,24(sp)
    80001330:	6ba2                	ld	s7,8(sp)
    80001332:	6161                	addi	sp,sp,80
    80001334:	8082                	ret
      kfree(mem);
    80001336:	8526                	mv	a0,s1
    80001338:	eeeff0ef          	jal	80000a26 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000133c:	865e                	mv	a2,s7
    8000133e:	85ca                	mv	a1,s2
    80001340:	8556                	mv	a0,s5
    80001342:	f29ff0ef          	jal	8000126a <uvmdealloc>
      return 0;
    80001346:	4501                	li	a0,0
    80001348:	74e2                	ld	s1,56(sp)
    8000134a:	79a2                	ld	s3,40(sp)
    8000134c:	6b42                	ld	s6,16(sp)
    8000134e:	bfe1                	j	80001326 <uvmalloc+0x78>
    return oldsz;
    80001350:	852e                	mv	a0,a1
}
    80001352:	8082                	ret
  return newsz;
    80001354:	8532                	mv	a0,a2
    80001356:	bfc1                	j	80001326 <uvmalloc+0x78>

0000000080001358 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001358:	7179                	addi	sp,sp,-48
    8000135a:	f406                	sd	ra,40(sp)
    8000135c:	f022                	sd	s0,32(sp)
    8000135e:	ec26                	sd	s1,24(sp)
    80001360:	e84a                	sd	s2,16(sp)
    80001362:	e44e                	sd	s3,8(sp)
    80001364:	1800                	addi	s0,sp,48
    80001366:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001368:	84aa                	mv	s1,a0
    8000136a:	6905                	lui	s2,0x1
    8000136c:	992a                	add	s2,s2,a0
    8000136e:	a811                	j	80001382 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    80001370:	00006517          	auipc	a0,0x6
    80001374:	dc850513          	addi	a0,a0,-568 # 80007138 <etext+0x138>
    80001378:	cbcff0ef          	jal	80000834 <panic>
  for (int i = 0; i < 512; i++) {
    8000137c:	04a1                	addi	s1,s1,8
    8000137e:	03248163          	beq	s1,s2,800013a0 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001382:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001384:	0017f713          	andi	a4,a5,1
    80001388:	db75                	beqz	a4,8000137c <freewalk+0x24>
    8000138a:	00e7f713          	andi	a4,a5,14
    8000138e:	f36d                	bnez	a4,80001370 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80001390:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001392:	00c79513          	slli	a0,a5,0xc
    80001396:	fc3ff0ef          	jal	80001358 <freewalk>
      pagetable[i] = 0;
    8000139a:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000139e:	bff9                	j	8000137c <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013a0:	854e                	mv	a0,s3
    800013a2:	e84ff0ef          	jal	80000a26 <kfree>
}
    800013a6:	70a2                	ld	ra,40(sp)
    800013a8:	7402                	ld	s0,32(sp)
    800013aa:	64e2                	ld	s1,24(sp)
    800013ac:	6942                	ld	s2,16(sp)
    800013ae:	69a2                	ld	s3,8(sp)
    800013b0:	6145                	addi	sp,sp,48
    800013b2:	8082                	ret

00000000800013b4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
    800013be:	84aa                	mv	s1,a0
  if (sz > 0)
    800013c0:	e989                	bnez	a1,800013d2 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013c2:	8526                	mv	a0,s1
    800013c4:	f95ff0ef          	jal	80001358 <freewalk>
}
    800013c8:	60e2                	ld	ra,24(sp)
    800013ca:	6442                	ld	s0,16(sp)
    800013cc:	64a2                	ld	s1,8(sp)
    800013ce:	6105                	addi	sp,sp,32
    800013d0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013d2:	6785                	lui	a5,0x1
    800013d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013d6:	95be                	add	a1,a1,a5
    800013d8:	4685                	li	a3,1
    800013da:	00c5d613          	srli	a2,a1,0xc
    800013de:	4581                	li	a1,0
    800013e0:	e01ff0ef          	jal	800011e0 <uvmunmap>
    800013e4:	bff9                	j	800013c2 <uvmfree+0xe>

00000000800013e6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013e6:	ca59                	beqz	a2,8000147c <uvmcopy+0x96>
{
    800013e8:	715d                	addi	sp,sp,-80
    800013ea:	e486                	sd	ra,72(sp)
    800013ec:	e0a2                	sd	s0,64(sp)
    800013ee:	fc26                	sd	s1,56(sp)
    800013f0:	f84a                	sd	s2,48(sp)
    800013f2:	f44e                	sd	s3,40(sp)
    800013f4:	f052                	sd	s4,32(sp)
    800013f6:	ec56                	sd	s5,24(sp)
    800013f8:	e85a                	sd	s6,16(sp)
    800013fa:	e45e                	sd	s7,8(sp)
    800013fc:	0880                	addi	s0,sp,80
    800013fe:	8b2a                	mv	s6,a0
    80001400:	8bae                	mv	s7,a1
    80001402:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001404:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80001406:	6a05                	lui	s4,0x1
    80001408:	a021                	j	80001410 <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    8000140a:	94d2                	add	s1,s1,s4
    8000140c:	0554fc63          	bgeu	s1,s5,80001464 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    80001410:	4601                	li	a2,0
    80001412:	85a6                	mv	a1,s1
    80001414:	855a                	mv	a0,s6
    80001416:	b29ff0ef          	jal	80000f3e <walk>
    8000141a:	d965                	beqz	a0,8000140a <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000141c:	00053983          	ld	s3,0(a0)
    80001420:	0019f793          	andi	a5,s3,1
    80001424:	d3fd                	beqz	a5,8000140a <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001426:	ee8ff0ef          	jal	80000b0e <kalloc>
    8000142a:	892a                	mv	s2,a0
    8000142c:	c11d                	beqz	a0,80001452 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000142e:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001432:	8652                	mv	a2,s4
    80001434:	05b2                	slli	a1,a1,0xc
    80001436:	8d3ff0ef          	jal	80000d08 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    8000143a:	3ff9f713          	andi	a4,s3,1023
    8000143e:	86ca                	mv	a3,s2
    80001440:	8652                	mv	a2,s4
    80001442:	85a6                	mv	a1,s1
    80001444:	855e                	mv	a0,s7
    80001446:	bcdff0ef          	jal	80001012 <mappages>
    8000144a:	d161                	beqz	a0,8000140a <uvmcopy+0x24>
      kfree(mem);
    8000144c:	854a                	mv	a0,s2
    8000144e:	dd8ff0ef          	jal	80000a26 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001452:	4685                	li	a3,1
    80001454:	00c4d613          	srli	a2,s1,0xc
    80001458:	4581                	li	a1,0
    8000145a:	855e                	mv	a0,s7
    8000145c:	d85ff0ef          	jal	800011e0 <uvmunmap>
  return -1;
    80001460:	557d                	li	a0,-1
    80001462:	a011                	j	80001466 <uvmcopy+0x80>
  return 0;
    80001464:	4501                	li	a0,0
}
    80001466:	60a6                	ld	ra,72(sp)
    80001468:	6406                	ld	s0,64(sp)
    8000146a:	74e2                	ld	s1,56(sp)
    8000146c:	7942                	ld	s2,48(sp)
    8000146e:	79a2                	ld	s3,40(sp)
    80001470:	7a02                	ld	s4,32(sp)
    80001472:	6ae2                	ld	s5,24(sp)
    80001474:	6b42                	ld	s6,16(sp)
    80001476:	6ba2                	ld	s7,8(sp)
    80001478:	6161                	addi	sp,sp,80
    8000147a:	8082                	ret
  return 0;
    8000147c:	4501                	li	a0,0
}
    8000147e:	8082                	ret

0000000080001480 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001480:	1141                	addi	sp,sp,-16
    80001482:	e406                	sd	ra,8(sp)
    80001484:	e022                	sd	s0,0(sp)
    80001486:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001488:	4601                	li	a2,0
    8000148a:	ab5ff0ef          	jal	80000f3e <walk>
  if (pte == 0)
    8000148e:	c901                	beqz	a0,8000149e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001490:	611c                	ld	a5,0(a0)
    80001492:	9bbd                	andi	a5,a5,-17
    80001494:	e11c                	sd	a5,0(a0)
}
    80001496:	60a2                	ld	ra,8(sp)
    80001498:	6402                	ld	s0,0(sp)
    8000149a:	0141                	addi	sp,sp,16
    8000149c:	8082                	ret
    panic("uvmclear");
    8000149e:	00006517          	auipc	a0,0x6
    800014a2:	caa50513          	addi	a0,a0,-854 # 80007148 <etext+0x148>
    800014a6:	b8eff0ef          	jal	80000834 <panic>

00000000800014aa <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800014aa:	1141                	addi	sp,sp,-16
    800014ac:	e406                	sd	ra,8(sp)
    800014ae:	e022                	sd	s0,0(sp)
    800014b0:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014b2:	4601                	li	a2,0
    800014b4:	a8bff0ef          	jal	80000f3e <walk>
  if (pte == 0) {
    800014b8:	c119                	beqz	a0,800014be <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014ba:	6108                	ld	a0,0(a0)
    800014bc:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014be:	60a2                	ld	ra,8(sp)
    800014c0:	6402                	ld	s0,0(sp)
    800014c2:	0141                	addi	sp,sp,16
    800014c4:	8082                	ret

00000000800014c6 <vmfault>:
{
    800014c6:	7179                	addi	sp,sp,-48
    800014c8:	f406                	sd	ra,40(sp)
    800014ca:	f022                	sd	s0,32(sp)
    800014cc:	e052                	sd	s4,0(sp)
    800014ce:	1800                	addi	s0,sp,48
    return 0;
    800014d0:	4a01                	li	s4,0
  if (va >= psz)
    800014d2:	00b66863          	bltu	a2,a1,800014e2 <vmfault+0x1c>
}
    800014d6:	8552                	mv	a0,s4
    800014d8:	70a2                	ld	ra,40(sp)
    800014da:	7402                	ld	s0,32(sp)
    800014dc:	6a02                	ld	s4,0(sp)
    800014de:	6145                	addi	sp,sp,48
    800014e0:	8082                	ret
    800014e2:	ec26                	sd	s1,24(sp)
    800014e4:	e44e                	sd	s3,8(sp)
    800014e6:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    800014e8:	77fd                	lui	a5,0xfffff
    800014ea:	00f679b3          	and	s3,a2,a5
  if (ismapped(pagetable, va)) {
    800014ee:	85ce                	mv	a1,s3
    800014f0:	fbbff0ef          	jal	800014aa <ismapped>
    return 0;
    800014f4:	4a01                	li	s4,0
  if (ismapped(pagetable, va)) {
    800014f6:	c501                	beqz	a0,800014fe <vmfault+0x38>
    800014f8:	64e2                	ld	s1,24(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	bfe9                	j	800014d6 <vmfault+0x10>
    800014fe:	e84a                	sd	s2,16(sp)
  mem = (uint64)kalloc();
    80001500:	e0eff0ef          	jal	80000b0e <kalloc>
    80001504:	892a                	mv	s2,a0
  if (mem == 0)
    80001506:	c915                	beqz	a0,8000153a <vmfault+0x74>
  mem = (uint64)kalloc();
    80001508:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    8000150a:	6605                	lui	a2,0x1
    8000150c:	4581                	li	a1,0
    8000150e:	f9aff0ef          	jal	80000ca8 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001512:	4759                	li	a4,22
    80001514:	86ca                	mv	a3,s2
    80001516:	6605                	lui	a2,0x1
    80001518:	85ce                	mv	a1,s3
    8000151a:	8526                	mv	a0,s1
    8000151c:	af7ff0ef          	jal	80001012 <mappages>
    80001520:	e509                	bnez	a0,8000152a <vmfault+0x64>
    80001522:	64e2                	ld	s1,24(sp)
    80001524:	6942                	ld	s2,16(sp)
    80001526:	69a2                	ld	s3,8(sp)
    80001528:	b77d                	j	800014d6 <vmfault+0x10>
    kfree((void *)mem);
    8000152a:	854a                	mv	a0,s2
    8000152c:	cfaff0ef          	jal	80000a26 <kfree>
    return 0;
    80001530:	4a01                	li	s4,0
    80001532:	64e2                	ld	s1,24(sp)
    80001534:	6942                	ld	s2,16(sp)
    80001536:	69a2                	ld	s3,8(sp)
    80001538:	bf79                	j	800014d6 <vmfault+0x10>
    8000153a:	64e2                	ld	s1,24(sp)
    8000153c:	6942                	ld	s2,16(sp)
    8000153e:	69a2                	ld	s3,8(sp)
    80001540:	bf59                	j	800014d6 <vmfault+0x10>

0000000080001542 <copyout>:
  while (len > 0) {
    80001542:	cf49                	beqz	a4,800015dc <copyout+0x9a>
{
    80001544:	7159                	addi	sp,sp,-112
    80001546:	f486                	sd	ra,104(sp)
    80001548:	f0a2                	sd	s0,96(sp)
    8000154a:	eca6                	sd	s1,88(sp)
    8000154c:	e8ca                	sd	s2,80(sp)
    8000154e:	e4ce                	sd	s3,72(sp)
    80001550:	e0d2                	sd	s4,64(sp)
    80001552:	fc56                	sd	s5,56(sp)
    80001554:	f85a                	sd	s6,48(sp)
    80001556:	f45e                	sd	s7,40(sp)
    80001558:	f062                	sd	s8,32(sp)
    8000155a:	ec66                	sd	s9,24(sp)
    8000155c:	e86a                	sd	s10,16(sp)
    8000155e:	e46e                	sd	s11,8(sp)
    80001560:	1880                	addi	s0,sp,112
    80001562:	8baa                	mv	s7,a0
    80001564:	8dae                	mv	s11,a1
    80001566:	8a32                	mv	s4,a2
    80001568:	8b36                	mv	s6,a3
    8000156a:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    8000156c:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    8000156e:	5cfd                	li	s9,-1
    80001570:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001574:	6c05                	lui	s8,0x1
    80001576:	a005                	j	80001596 <copyout+0x54>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001578:	409a0533          	sub	a0,s4,s1
    8000157c:	0009061b          	sext.w	a2,s2
    80001580:	85da                	mv	a1,s6
    80001582:	954e                	add	a0,a0,s3
    80001584:	f84ff0ef          	jal	80000d08 <memmove>
    len -= n;
    80001588:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000158c:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000158e:	01848a33          	add	s4,s1,s8
  while (len > 0) {
    80001592:	040a8363          	beqz	s5,800015d8 <copyout+0x96>
    va0 = PGROUNDDOWN(dstva);
    80001596:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    8000159a:	049ce363          	bltu	s9,s1,800015e0 <copyout+0x9e>
    pa0 = walkaddr(pagetable, va0);
    8000159e:	85a6                	mv	a1,s1
    800015a0:	855e                	mv	a0,s7
    800015a2:	a37ff0ef          	jal	80000fd8 <walkaddr>
    800015a6:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015a8:	e909                	bnez	a0,800015ba <copyout+0x78>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015aa:	4681                	li	a3,0
    800015ac:	8626                	mv	a2,s1
    800015ae:	85ee                	mv	a1,s11
    800015b0:	855e                	mv	a0,s7
    800015b2:	f15ff0ef          	jal	800014c6 <vmfault>
    800015b6:	89aa                	mv	s3,a0
    800015b8:	c521                	beqz	a0,80001600 <copyout+0xbe>
    pte = walk(pagetable, va0, 0);
    800015ba:	4601                	li	a2,0
    800015bc:	85a6                	mv	a1,s1
    800015be:	855e                	mv	a0,s7
    800015c0:	97fff0ef          	jal	80000f3e <walk>
    if ((*pte & PTE_W) == 0)
    800015c4:	611c                	ld	a5,0(a0)
    800015c6:	8b91                	andi	a5,a5,4
    800015c8:	cf95                	beqz	a5,80001604 <copyout+0xc2>
    n = PGSIZE - (dstva - va0);
    800015ca:	41448933          	sub	s2,s1,s4
    800015ce:	9962                	add	s2,s2,s8
    if (n > len)
    800015d0:	fb2af4e3          	bgeu	s5,s2,80001578 <copyout+0x36>
    800015d4:	8956                	mv	s2,s5
    800015d6:	b74d                	j	80001578 <copyout+0x36>
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	a021                	j	800015e2 <copyout+0xa0>
    800015dc:	4501                	li	a0,0
}
    800015de:	8082                	ret
      return -1;
    800015e0:	557d                	li	a0,-1
}
    800015e2:	70a6                	ld	ra,104(sp)
    800015e4:	7406                	ld	s0,96(sp)
    800015e6:	64e6                	ld	s1,88(sp)
    800015e8:	6946                	ld	s2,80(sp)
    800015ea:	69a6                	ld	s3,72(sp)
    800015ec:	6a06                	ld	s4,64(sp)
    800015ee:	7ae2                	ld	s5,56(sp)
    800015f0:	7b42                	ld	s6,48(sp)
    800015f2:	7ba2                	ld	s7,40(sp)
    800015f4:	7c02                	ld	s8,32(sp)
    800015f6:	6ce2                	ld	s9,24(sp)
    800015f8:	6d42                	ld	s10,16(sp)
    800015fa:	6da2                	ld	s11,8(sp)
    800015fc:	6165                	addi	sp,sp,112
    800015fe:	8082                	ret
        return -1;
    80001600:	557d                	li	a0,-1
    80001602:	b7c5                	j	800015e2 <copyout+0xa0>
      return -1;
    80001604:	557d                	li	a0,-1
    80001606:	bff1                	j	800015e2 <copyout+0xa0>

0000000080001608 <copyin>:
  while (len > 0) {
    80001608:	cf41                	beqz	a4,800016a0 <copyin+0x98>
{
    8000160a:	711d                	addi	sp,sp,-96
    8000160c:	ec86                	sd	ra,88(sp)
    8000160e:	e8a2                	sd	s0,80(sp)
    80001610:	e4a6                	sd	s1,72(sp)
    80001612:	e0ca                	sd	s2,64(sp)
    80001614:	fc4e                	sd	s3,56(sp)
    80001616:	f852                	sd	s4,48(sp)
    80001618:	f456                	sd	s5,40(sp)
    8000161a:	f05a                	sd	s6,32(sp)
    8000161c:	ec5e                	sd	s7,24(sp)
    8000161e:	e862                	sd	s8,16(sp)
    80001620:	e466                	sd	s9,8(sp)
    80001622:	e06a                	sd	s10,0(sp)
    80001624:	1080                	addi	s0,sp,96
    80001626:	8baa                	mv	s7,a0
    80001628:	8cae                	mv	s9,a1
    8000162a:	8ab2                	mv	s5,a2
    8000162c:	8936                	mv	s2,a3
    8000162e:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    80001630:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001632:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80001634:	6b05                	lui	s6,0x1
    80001636:	a035                	j	80001662 <copyin+0x5a>
    80001638:	412984b3          	sub	s1,s3,s2
    8000163c:	94da                	add	s1,s1,s6
    if (n > len)
    8000163e:	009a7363          	bgeu	s4,s1,80001644 <copyin+0x3c>
    80001642:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001644:	413905b3          	sub	a1,s2,s3
    80001648:	0004861b          	sext.w	a2,s1
    8000164c:	95aa                	add	a1,a1,a0
    8000164e:	8556                	mv	a0,s5
    80001650:	eb8ff0ef          	jal	80000d08 <memmove>
    len -= n;
    80001654:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80001658:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000165a:	01698933          	add	s2,s3,s6
  while (len > 0) {
    8000165e:	020a0263          	beqz	s4,80001682 <copyin+0x7a>
    va0 = PGROUNDDOWN(srcva);
    80001662:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001666:	85ce                	mv	a1,s3
    80001668:	855e                	mv	a0,s7
    8000166a:	96fff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    8000166e:	f569                	bnez	a0,80001638 <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001670:	86ea                	mv	a3,s10
    80001672:	864e                	mv	a2,s3
    80001674:	85e6                	mv	a1,s9
    80001676:	855e                	mv	a0,s7
    80001678:	e4fff0ef          	jal	800014c6 <vmfault>
    8000167c:	fd55                	bnez	a0,80001638 <copyin+0x30>
        return -1;
    8000167e:	557d                	li	a0,-1
    80001680:	a011                	j	80001684 <copyin+0x7c>
  return 0;
    80001682:	4501                	li	a0,0
}
    80001684:	60e6                	ld	ra,88(sp)
    80001686:	6446                	ld	s0,80(sp)
    80001688:	64a6                	ld	s1,72(sp)
    8000168a:	6906                	ld	s2,64(sp)
    8000168c:	79e2                	ld	s3,56(sp)
    8000168e:	7a42                	ld	s4,48(sp)
    80001690:	7aa2                	ld	s5,40(sp)
    80001692:	7b02                	ld	s6,32(sp)
    80001694:	6be2                	ld	s7,24(sp)
    80001696:	6c42                	ld	s8,16(sp)
    80001698:	6ca2                	ld	s9,8(sp)
    8000169a:	6d02                	ld	s10,0(sp)
    8000169c:	6125                	addi	sp,sp,96
    8000169e:	8082                	ret
  return 0;
    800016a0:	4501                	li	a0,0
}
    800016a2:	8082                	ret

00000000800016a4 <copyinstr>:
  while (got_null == 0 && max > 0) {
    800016a4:	c769                	beqz	a4,8000176e <copyinstr+0xca>
{
    800016a6:	711d                	addi	sp,sp,-96
    800016a8:	ec86                	sd	ra,88(sp)
    800016aa:	e8a2                	sd	s0,80(sp)
    800016ac:	e4a6                	sd	s1,72(sp)
    800016ae:	e0ca                	sd	s2,64(sp)
    800016b0:	fc4e                	sd	s3,56(sp)
    800016b2:	f852                	sd	s4,48(sp)
    800016b4:	f456                	sd	s5,40(sp)
    800016b6:	f05a                	sd	s6,32(sp)
    800016b8:	ec5e                	sd	s7,24(sp)
    800016ba:	e862                	sd	s8,16(sp)
    800016bc:	e466                	sd	s9,8(sp)
    800016be:	1080                	addi	s0,sp,96
    800016c0:	8b2a                	mv	s6,a0
    800016c2:	8c2e                	mv	s8,a1
    800016c4:	89b2                	mv	s3,a2
    800016c6:	84b6                	mv	s1,a3
    800016c8:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016ca:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016cc:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016ce:	6a85                	lui	s5,0x1
    800016d0:	a881                	j	80001720 <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016d2:	86e6                	mv	a3,s9
    800016d4:	864a                	mv	a2,s2
    800016d6:	85e2                	mv	a1,s8
    800016d8:	855a                	mv	a0,s6
    800016da:	dedff0ef          	jal	800014c6 <vmfault>
    800016de:	e921                	bnez	a0,8000172e <copyinstr+0x8a>
        return -1;
    800016e0:	557d                	li	a0,-1
    800016e2:	a801                	j	800016f2 <copyinstr+0x4e>
        *dst = '\0';
    800016e4:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb060>
        got_null = 1;
    800016e8:	4785                	li	a5,1
  if (got_null) {
    800016ea:	0017c793          	xori	a5,a5,1
    800016ee:	40f0053b          	negw	a0,a5
}
    800016f2:	60e6                	ld	ra,88(sp)
    800016f4:	6446                	ld	s0,80(sp)
    800016f6:	64a6                	ld	s1,72(sp)
    800016f8:	6906                	ld	s2,64(sp)
    800016fa:	79e2                	ld	s3,56(sp)
    800016fc:	7a42                	ld	s4,48(sp)
    800016fe:	7aa2                	ld	s5,40(sp)
    80001700:	7b02                	ld	s6,32(sp)
    80001702:	6be2                	ld	s7,24(sp)
    80001704:	6c42                	ld	s8,16(sp)
    80001706:	6ca2                	ld	s9,8(sp)
    80001708:	6125                	addi	sp,sp,96
    8000170a:	8082                	ret
    8000170c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80001710:	974e                	add	a4,a4,s3
      --max;
    80001712:	40b70a33          	sub	s4,a4,a1
    srcva = va0 + PGSIZE;
    80001716:	015904b3          	add	s1,s2,s5
  while (got_null == 0 && max > 0) {
    8000171a:	04e58463          	beq	a1,a4,80001762 <copyinstr+0xbe>
{
    8000171e:	89be                	mv	s3,a5
    va0 = PGROUNDDOWN(srcva);
    80001720:	0174f933          	and	s2,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80001724:	85ca                	mv	a1,s2
    80001726:	855a                	mv	a0,s6
    80001728:	8b1ff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    8000172c:	d15d                	beqz	a0,800016d2 <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    8000172e:	40990633          	sub	a2,s2,s1
    80001732:	9656                	add	a2,a2,s5
    if (n > max)
    80001734:	00ca7363          	bgeu	s4,a2,8000173a <copyinstr+0x96>
    80001738:	8652                	mv	a2,s4
    while (n > 0) {
    8000173a:	c615                	beqz	a2,80001766 <copyinstr+0xc2>
    char *p = (char *)(pa0 + (srcva - va0));
    8000173c:	412484b3          	sub	s1,s1,s2
    80001740:	94aa                	add	s1,s1,a0
    80001742:	87ce                	mv	a5,s3
      if (*p == '\0') {
    80001744:	413484b3          	sub	s1,s1,s3
    while (n > 0) {
    80001748:	964e                	add	a2,a2,s3
    8000174a:	85be                	mv	a1,a5
      if (*p == '\0') {
    8000174c:	00f48733          	add	a4,s1,a5
    80001750:	00074683          	lbu	a3,0(a4)
    80001754:	dac1                	beqz	a3,800016e4 <copyinstr+0x40>
        *dst = *p;
    80001756:	00d78023          	sb	a3,0(a5)
      dst++;
    8000175a:	0785                	addi	a5,a5,1
    while (n > 0) {
    8000175c:	fec797e3          	bne	a5,a2,8000174a <copyinstr+0xa6>
    80001760:	b775                	j	8000170c <copyinstr+0x68>
    80001762:	4781                	li	a5,0
    80001764:	b759                	j	800016ea <copyinstr+0x46>
    srcva = va0 + PGSIZE;
    80001766:	6485                	lui	s1,0x1
    80001768:	94ca                	add	s1,s1,s2
    8000176a:	87ce                	mv	a5,s3
    8000176c:	bf4d                	j	8000171e <copyinstr+0x7a>
  int got_null = 0;
    8000176e:	4781                	li	a5,0
  if (got_null) {
    80001770:	0017c793          	xori	a5,a5,1
    80001774:	40f0053b          	negw	a0,a5
}
    80001778:	8082                	ret

000000008000177a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000177a:	715d                	addi	sp,sp,-80
    8000177c:	e486                	sd	ra,72(sp)
    8000177e:	e0a2                	sd	s0,64(sp)
    80001780:	fc26                	sd	s1,56(sp)
    80001782:	f84a                	sd	s2,48(sp)
    80001784:	f44e                	sd	s3,40(sp)
    80001786:	f052                	sd	s4,32(sp)
    80001788:	ec56                	sd	s5,24(sp)
    8000178a:	e85a                	sd	s6,16(sp)
    8000178c:	e45e                	sd	s7,8(sp)
    8000178e:	e062                	sd	s8,0(sp)
    80001790:	0880                	addi	s0,sp,80
    80001792:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001794:	00011497          	auipc	s1,0x11
    80001798:	22c48493          	addi	s1,s1,556 # 800129c0 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    8000179c:	8c26                	mv	s8,s1
    8000179e:	1a1f67b7          	lui	a5,0x1a1f6
    800017a2:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    800017a6:	7d634937          	lui	s2,0x7d634
    800017aa:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    800017ae:	1902                	slli	s2,s2,0x20
    800017b0:	993e                	add	s2,s2,a5
    800017b2:	040009b7          	lui	s3,0x4000
    800017b6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017b8:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017ba:	4b99                	li	s7,6
    800017bc:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017be:	00017a97          	auipc	s5,0x17
    800017c2:	402a8a93          	addi	s5,s5,1026 # 80018bc0 <tickslock>
    char *pa = kalloc();
    800017c6:	b48ff0ef          	jal	80000b0e <kalloc>
    800017ca:	862a                	mv	a2,a0
    if (pa == 0)
    800017cc:	c121                	beqz	a0,8000180c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int)(p - proc));
    800017ce:	418485b3          	sub	a1,s1,s8
    800017d2:	858d                	srai	a1,a1,0x3
    800017d4:	032585b3          	mul	a1,a1,s2
    800017d8:	05b6                	slli	a1,a1,0xd
    800017da:	6789                	lui	a5,0x2
    800017dc:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017de:	875e                	mv	a4,s7
    800017e0:	86da                	mv	a3,s6
    800017e2:	40b985b3          	sub	a1,s3,a1
    800017e6:	8552                	mv	a0,s4
    800017e8:	8e1ff0ef          	jal	800010c8 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017ec:	18848493          	addi	s1,s1,392
    800017f0:	fd549be3          	bne	s1,s5,800017c6 <proc_mapstacks+0x4c>
  }
}
    800017f4:	60a6                	ld	ra,72(sp)
    800017f6:	6406                	ld	s0,64(sp)
    800017f8:	74e2                	ld	s1,56(sp)
    800017fa:	7942                	ld	s2,48(sp)
    800017fc:	79a2                	ld	s3,40(sp)
    800017fe:	7a02                	ld	s4,32(sp)
    80001800:	6ae2                	ld	s5,24(sp)
    80001802:	6b42                	ld	s6,16(sp)
    80001804:	6ba2                	ld	s7,8(sp)
    80001806:	6c02                	ld	s8,0(sp)
    80001808:	6161                	addi	sp,sp,80
    8000180a:	8082                	ret
      panic("kalloc");
    8000180c:	00006517          	auipc	a0,0x6
    80001810:	94c50513          	addi	a0,a0,-1716 # 80007158 <etext+0x158>
    80001814:	820ff0ef          	jal	80000834 <panic>

0000000080001818 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001818:	7139                	addi	sp,sp,-64
    8000181a:	fc06                	sd	ra,56(sp)
    8000181c:	f822                	sd	s0,48(sp)
    8000181e:	f426                	sd	s1,40(sp)
    80001820:	f04a                	sd	s2,32(sp)
    80001822:	ec4e                	sd	s3,24(sp)
    80001824:	e852                	sd	s4,16(sp)
    80001826:	e456                	sd	s5,8(sp)
    80001828:	e05a                	sd	s6,0(sp)
    8000182a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000182c:	00006597          	auipc	a1,0x6
    80001830:	93458593          	addi	a1,a1,-1740 # 80007160 <etext+0x160>
    80001834:	00011517          	auipc	a0,0x11
    80001838:	d5c50513          	addi	a0,a0,-676 # 80012590 <pid_lock>
    8000183c:	b2cff0ef          	jal	80000b68 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001840:	00006597          	auipc	a1,0x6
    80001844:	92858593          	addi	a1,a1,-1752 # 80007168 <etext+0x168>
    80001848:	00011517          	auipc	a0,0x11
    8000184c:	d6050513          	addi	a0,a0,-672 # 800125a8 <wait_lock>
    80001850:	b18ff0ef          	jal	80000b68 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001854:	00011497          	auipc	s1,0x11
    80001858:	16c48493          	addi	s1,s1,364 # 800129c0 <proc>
    initlock(&p->lock, "proc");
    8000185c:	00006b17          	auipc	s6,0x6
    80001860:	91cb0b13          	addi	s6,s6,-1764 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001864:	8aa6                	mv	s5,s1
    80001866:	1a1f67b7          	lui	a5,0x1a1f6
    8000186a:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    8000186e:	7d634937          	lui	s2,0x7d634
    80001872:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    80001876:	1902                	slli	s2,s2,0x20
    80001878:	993e                	add	s2,s2,a5
    8000187a:	040009b7          	lui	s3,0x4000
    8000187e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001880:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001882:	00017a17          	auipc	s4,0x17
    80001886:	33ea0a13          	addi	s4,s4,830 # 80018bc0 <tickslock>
    initlock(&p->lock, "proc");
    8000188a:	85da                	mv	a1,s6
    8000188c:	8526                	mv	a0,s1
    8000188e:	adaff0ef          	jal	80000b68 <initlock>
    p->state = UNUSED;
    80001892:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001896:	415487b3          	sub	a5,s1,s5
    8000189a:	878d                	srai	a5,a5,0x3
    8000189c:	032787b3          	mul	a5,a5,s2
    800018a0:	07b6                	slli	a5,a5,0xd
    800018a2:	6709                	lui	a4,0x2
    800018a4:	9fb9                	addw	a5,a5,a4
    800018a6:	40f987b3          	sub	a5,s3,a5
    800018aa:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    800018ac:	18848493          	addi	s1,s1,392
    800018b0:	fd449de3          	bne	s1,s4,8000188a <procinit+0x72>
  }
}
    800018b4:	70e2                	ld	ra,56(sp)
    800018b6:	7442                	ld	s0,48(sp)
    800018b8:	74a2                	ld	s1,40(sp)
    800018ba:	7902                	ld	s2,32(sp)
    800018bc:	69e2                	ld	s3,24(sp)
    800018be:	6a42                	ld	s4,16(sp)
    800018c0:	6aa2                	ld	s5,8(sp)
    800018c2:	6b02                	ld	s6,0(sp)
    800018c4:	6121                	addi	sp,sp,64
    800018c6:	8082                	ret

00000000800018c8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018c8:	1141                	addi	sp,sp,-16
    800018ca:	e406                	sd	ra,8(sp)
    800018cc:	e022                	sd	s0,0(sp)
    800018ce:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018d0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018d2:	2501                	sext.w	a0,a0
    800018d4:	60a2                	ld	ra,8(sp)
    800018d6:	6402                	ld	s0,0(sp)
    800018d8:	0141                	addi	sp,sp,16
    800018da:	8082                	ret

00000000800018dc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800018dc:	1141                	addi	sp,sp,-16
    800018de:	e406                	sd	ra,8(sp)
    800018e0:	e022                	sd	s0,0(sp)
    800018e2:	0800                	addi	s0,sp,16
    800018e4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018e6:	2781                	sext.w	a5,a5
    800018e8:	079e                	slli	a5,a5,0x7
  return c;
}
    800018ea:	00011517          	auipc	a0,0x11
    800018ee:	cd650513          	addi	a0,a0,-810 # 800125c0 <cpus>
    800018f2:	953e                	add	a0,a0,a5
    800018f4:	60a2                	ld	ra,8(sp)
    800018f6:	6402                	ld	s0,0(sp)
    800018f8:	0141                	addi	sp,sp,16
    800018fa:	8082                	ret

00000000800018fc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800018fc:	1101                	addi	sp,sp,-32
    800018fe:	ec06                	sd	ra,24(sp)
    80001900:	e822                	sd	s0,16(sp)
    80001902:	e426                	sd	s1,8(sp)
    80001904:	1000                	addi	s0,sp,32
  push_off();
    80001906:	aa8ff0ef          	jal	80000bae <push_off>
    8000190a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000190c:	2781                	sext.w	a5,a5
    8000190e:	079e                	slli	a5,a5,0x7
    80001910:	00011717          	auipc	a4,0x11
    80001914:	c8070713          	addi	a4,a4,-896 # 80012590 <pid_lock>
    80001918:	97ba                	add	a5,a5,a4
    8000191a:	7b9c                	ld	a5,48(a5)
    8000191c:	84be                	mv	s1,a5
  pop_off();
    8000191e:	b0aff0ef          	jal	80000c28 <pop_off>
  return p;
}
    80001922:	8526                	mv	a0,s1
    80001924:	60e2                	ld	ra,24(sp)
    80001926:	6442                	ld	s0,16(sp)
    80001928:	64a2                	ld	s1,8(sp)
    8000192a:	6105                	addi	sp,sp,32
    8000192c:	8082                	ret

000000008000192e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000192e:	7179                	addi	sp,sp,-48
    80001930:	f406                	sd	ra,40(sp)
    80001932:	f022                	sd	s0,32(sp)
    80001934:	ec26                	sd	s1,24(sp)
    80001936:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001938:	fc5ff0ef          	jal	800018fc <myproc>
    8000193c:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000193e:	b32ff0ef          	jal	80000c70 <release>

  if (__atomic_load_n(&first, __ATOMIC_ACQUIRE)) {
    80001942:	00009797          	auipc	a5,0x9
    80001946:	ade78793          	addi	a5,a5,-1314 # 8000a420 <first.1>
    8000194a:	439c                	lw	a5,0(a5)
    8000194c:	0230000f          	fence	r,rw
    80001950:	2781                	sext.w	a5,a5
    80001952:	c3a1                	beqz	a5,80001992 <forkret+0x64>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001954:	4505                	li	a0,1
    80001956:	6f3010ef          	jal	80003848 <fsinit>

    // ensure other cores see first=0.
    __atomic_store_n(&first, 0, __ATOMIC_RELEASE);
    8000195a:	00009797          	auipc	a5,0x9
    8000195e:	ac678793          	addi	a5,a5,-1338 # 8000a420 <first.1>
    80001962:	0310000f          	fence	rw,w
    80001966:	0007a023          	sw	zero,0(a5)

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    8000196a:	00006797          	auipc	a5,0x6
    8000196e:	81678793          	addi	a5,a5,-2026 # 80007180 <etext+0x180>
    80001972:	fcf43823          	sd	a5,-48(s0)
    80001976:	fc043c23          	sd	zero,-40(s0)
    8000197a:	fd040593          	addi	a1,s0,-48
    8000197e:	853e                	mv	a0,a5
    80001980:	14a030ef          	jal	80004aca <kexec>
    80001984:	6cbc                	ld	a5,88(s1)
    80001986:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001988:	6cbc                	ld	a5,88(s1)
    8000198a:	7bb8                	ld	a4,112(a5)
    8000198c:	57fd                	li	a5,-1
    8000198e:	02f70d63          	beq	a4,a5,800019c8 <forkret+0x9a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001992:	5d3000ef          	jal	80002764 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001996:	68a8                	ld	a0,80(s1)
    80001998:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000199a:	04000737          	lui	a4,0x4000
    8000199e:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019a0:	0732                	slli	a4,a4,0xc
    800019a2:	00004797          	auipc	a5,0x4
    800019a6:	6fa78793          	addi	a5,a5,1786 # 8000609c <userret>
    800019aa:	00004697          	auipc	a3,0x4
    800019ae:	65668693          	addi	a3,a3,1622 # 80006000 <_trampoline>
    800019b2:	8f95                	sub	a5,a5,a3
    800019b4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019b6:	577d                	li	a4,-1
    800019b8:	177e                	slli	a4,a4,0x3f
    800019ba:	8d59                	or	a0,a0,a4
    800019bc:	9782                	jalr	a5
}
    800019be:	70a2                	ld	ra,40(sp)
    800019c0:	7402                	ld	s0,32(sp)
    800019c2:	64e2                	ld	s1,24(sp)
    800019c4:	6145                	addi	sp,sp,48
    800019c6:	8082                	ret
      panic("exec");
    800019c8:	00005517          	auipc	a0,0x5
    800019cc:	7c050513          	addi	a0,a0,1984 # 80007188 <etext+0x188>
    800019d0:	e65fe0ef          	jal	80000834 <panic>

00000000800019d4 <allocpid>:
{
    800019d4:	1101                	addi	sp,sp,-32
    800019d6:	ec06                	sd	ra,24(sp)
    800019d8:	e822                	sd	s0,16(sp)
    800019da:	e426                	sd	s1,8(sp)
    800019dc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019de:	00011517          	auipc	a0,0x11
    800019e2:	bb250513          	addi	a0,a0,-1102 # 80012590 <pid_lock>
    800019e6:	a02ff0ef          	jal	80000be8 <acquire>
  pid = nextpid;
    800019ea:	00009797          	auipc	a5,0x9
    800019ee:	a3a78793          	addi	a5,a5,-1478 # 8000a424 <nextpid>
    800019f2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019f4:	0014871b          	addiw	a4,s1,1
    800019f8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019fa:	00011517          	auipc	a0,0x11
    800019fe:	b9650513          	addi	a0,a0,-1130 # 80012590 <pid_lock>
    80001a02:	a6eff0ef          	jal	80000c70 <release>
}
    80001a06:	8526                	mv	a0,s1
    80001a08:	60e2                	ld	ra,24(sp)
    80001a0a:	6442                	ld	s0,16(sp)
    80001a0c:	64a2                	ld	s1,8(sp)
    80001a0e:	6105                	addi	sp,sp,32
    80001a10:	8082                	ret

0000000080001a12 <proc_pagetable>:
{
    80001a12:	1101                	addi	sp,sp,-32
    80001a14:	ec06                	sd	ra,24(sp)
    80001a16:	e822                	sd	s0,16(sp)
    80001a18:	e426                	sd	s1,8(sp)
    80001a1a:	e04a                	sd	s2,0(sp)
    80001a1c:	1000                	addi	s0,sp,32
    80001a1e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a20:	f9aff0ef          	jal	800011ba <uvmcreate>
    80001a24:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a26:	cd05                	beqz	a0,80001a5e <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a28:	4729                	li	a4,10
    80001a2a:	00004697          	auipc	a3,0x4
    80001a2e:	5d668693          	addi	a3,a3,1494 # 80006000 <_trampoline>
    80001a32:	6605                	lui	a2,0x1
    80001a34:	040005b7          	lui	a1,0x4000
    80001a38:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a3a:	05b2                	slli	a1,a1,0xc
    80001a3c:	dd6ff0ef          	jal	80001012 <mappages>
    80001a40:	02054663          	bltz	a0,80001a6c <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a44:	4719                	li	a4,6
    80001a46:	05893683          	ld	a3,88(s2)
    80001a4a:	6605                	lui	a2,0x1
    80001a4c:	020005b7          	lui	a1,0x2000
    80001a50:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a52:	05b6                	slli	a1,a1,0xd
    80001a54:	8526                	mv	a0,s1
    80001a56:	dbcff0ef          	jal	80001012 <mappages>
    80001a5a:	00054f63          	bltz	a0,80001a78 <proc_pagetable+0x66>
}
    80001a5e:	8526                	mv	a0,s1
    80001a60:	60e2                	ld	ra,24(sp)
    80001a62:	6442                	ld	s0,16(sp)
    80001a64:	64a2                	ld	s1,8(sp)
    80001a66:	6902                	ld	s2,0(sp)
    80001a68:	6105                	addi	sp,sp,32
    80001a6a:	8082                	ret
    uvmfree(pagetable, 0);
    80001a6c:	4581                	li	a1,0
    80001a6e:	8526                	mv	a0,s1
    80001a70:	945ff0ef          	jal	800013b4 <uvmfree>
    return 0;
    80001a74:	4481                	li	s1,0
    80001a76:	b7e5                	j	80001a5e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a78:	4681                	li	a3,0
    80001a7a:	4605                	li	a2,1
    80001a7c:	040005b7          	lui	a1,0x4000
    80001a80:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a82:	05b2                	slli	a1,a1,0xc
    80001a84:	8526                	mv	a0,s1
    80001a86:	f5aff0ef          	jal	800011e0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a8a:	4581                	li	a1,0
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	927ff0ef          	jal	800013b4 <uvmfree>
    return 0;
    80001a92:	4481                	li	s1,0
    80001a94:	b7e9                	j	80001a5e <proc_pagetable+0x4c>

0000000080001a96 <proc_freepagetable>:
{
    80001a96:	1101                	addi	sp,sp,-32
    80001a98:	ec06                	sd	ra,24(sp)
    80001a9a:	e822                	sd	s0,16(sp)
    80001a9c:	e426                	sd	s1,8(sp)
    80001a9e:	e04a                	sd	s2,0(sp)
    80001aa0:	1000                	addi	s0,sp,32
    80001aa2:	84aa                	mv	s1,a0
    80001aa4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aa6:	4681                	li	a3,0
    80001aa8:	4605                	li	a2,1
    80001aaa:	040005b7          	lui	a1,0x4000
    80001aae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ab0:	05b2                	slli	a1,a1,0xc
    80001ab2:	f2eff0ef          	jal	800011e0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ab6:	4681                	li	a3,0
    80001ab8:	4605                	li	a2,1
    80001aba:	020005b7          	lui	a1,0x2000
    80001abe:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ac0:	05b6                	slli	a1,a1,0xd
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	f1cff0ef          	jal	800011e0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001ac8:	85ca                	mv	a1,s2
    80001aca:	8526                	mv	a0,s1
    80001acc:	8e9ff0ef          	jal	800013b4 <uvmfree>
}
    80001ad0:	60e2                	ld	ra,24(sp)
    80001ad2:	6442                	ld	s0,16(sp)
    80001ad4:	64a2                	ld	s1,8(sp)
    80001ad6:	6902                	ld	s2,0(sp)
    80001ad8:	6105                	addi	sp,sp,32
    80001ada:	8082                	ret

0000000080001adc <freeproc>:
{
    80001adc:	1101                	addi	sp,sp,-32
    80001ade:	ec06                	sd	ra,24(sp)
    80001ae0:	e822                	sd	s0,16(sp)
    80001ae2:	e426                	sd	s1,8(sp)
    80001ae4:	1000                	addi	s0,sp,32
    80001ae6:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001ae8:	6d28                	ld	a0,88(a0)
    80001aea:	c119                	beqz	a0,80001af0 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001aec:	f3bfe0ef          	jal	80000a26 <kfree>
  p->trapframe = 0;
    80001af0:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001af4:	68a8                	ld	a0,80(s1)
    80001af6:	c501                	beqz	a0,80001afe <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001af8:	64ac                	ld	a1,72(s1)
    80001afa:	f9dff0ef          	jal	80001a96 <proc_freepagetable>
  p->pagetable = 0;
    80001afe:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b02:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b06:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001b0a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b0e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b12:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b16:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b1a:	0004ac23          	sw	zero,24(s1)
}
    80001b1e:	60e2                	ld	ra,24(sp)
    80001b20:	6442                	ld	s0,16(sp)
    80001b22:	64a2                	ld	s1,8(sp)
    80001b24:	6105                	addi	sp,sp,32
    80001b26:	8082                	ret

0000000080001b28 <allocproc>:
{
    80001b28:	1101                	addi	sp,sp,-32
    80001b2a:	ec06                	sd	ra,24(sp)
    80001b2c:	e822                	sd	s0,16(sp)
    80001b2e:	e426                	sd	s1,8(sp)
    80001b30:	e04a                	sd	s2,0(sp)
    80001b32:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b34:	00011497          	auipc	s1,0x11
    80001b38:	e8c48493          	addi	s1,s1,-372 # 800129c0 <proc>
    80001b3c:	00017917          	auipc	s2,0x17
    80001b40:	08490913          	addi	s2,s2,132 # 80018bc0 <tickslock>
    acquire(&p->lock);
    80001b44:	8526                	mv	a0,s1
    80001b46:	8a2ff0ef          	jal	80000be8 <acquire>
    if (p->state == UNUSED) {
    80001b4a:	4c9c                	lw	a5,24(s1)
    80001b4c:	cb91                	beqz	a5,80001b60 <allocproc+0x38>
      release(&p->lock);
    80001b4e:	8526                	mv	a0,s1
    80001b50:	920ff0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b54:	18848493          	addi	s1,s1,392
    80001b58:	ff2496e3          	bne	s1,s2,80001b44 <allocproc+0x1c>
  return 0;
    80001b5c:	4481                	li	s1,0
    80001b5e:	a095                	j	80001bc2 <allocproc+0x9a>
  p->pid = allocpid();
    80001b60:	e75ff0ef          	jal	800019d4 <allocpid>
    80001b64:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b66:	4785                	li	a5,1
    80001b68:	cc9c                	sw	a5,24(s1)
  p->arrival_tick = 0;    // stamped for real once RUNNABLE (userinit/fork)
    80001b6a:	1604a423          	sw	zero,360(s1)
  p->first_run_tick = -1; // -1 sentinel: "has not run yet"
    80001b6e:	57fd                	li	a5,-1
    80001b70:	16f4a623          	sw	a5,364(s1)
  p->waiting_ticks = 0;
    80001b74:	1604a823          	sw	zero,368(s1)
  p->running_ticks = 0;
    80001b78:	1604aa23          	sw	zero,372(s1)
  p->run_start_tick = 0;
    80001b7c:	1604ac23          	sw	zero,376(s1)
  p->priority = 0;
    80001b80:	1604ae23          	sw	zero,380(s1)
  p->ticks_in_slice = 0;
    80001b84:	1804a023          	sw	zero,384(s1)
  p->enqueue_time = 0; // set to a real `ticks` value once it becomes RUNNABLE
    80001b88:	1804a223          	sw	zero,388(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b8c:	f83fe0ef          	jal	80000b0e <kalloc>
    80001b90:	892a                	mv	s2,a0
    80001b92:	eca8                	sd	a0,88(s1)
    80001b94:	cd15                	beqz	a0,80001bd0 <allocproc+0xa8>
  p->pagetable = proc_pagetable(p);
    80001b96:	8526                	mv	a0,s1
    80001b98:	e7bff0ef          	jal	80001a12 <proc_pagetable>
    80001b9c:	892a                	mv	s2,a0
    80001b9e:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001ba0:	c121                	beqz	a0,80001be0 <allocproc+0xb8>
  memset(&p->context, 0, sizeof(p->context));
    80001ba2:	07000613          	li	a2,112
    80001ba6:	4581                	li	a1,0
    80001ba8:	06048513          	addi	a0,s1,96
    80001bac:	8fcff0ef          	jal	80000ca8 <memset>
  p->context.ra = (uint64)forkret;
    80001bb0:	00000797          	auipc	a5,0x0
    80001bb4:	d7e78793          	addi	a5,a5,-642 # 8000192e <forkret>
    80001bb8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bba:	60bc                	ld	a5,64(s1)
    80001bbc:	6705                	lui	a4,0x1
    80001bbe:	97ba                	add	a5,a5,a4
    80001bc0:	f4bc                	sd	a5,104(s1)
}
    80001bc2:	8526                	mv	a0,s1
    80001bc4:	60e2                	ld	ra,24(sp)
    80001bc6:	6442                	ld	s0,16(sp)
    80001bc8:	64a2                	ld	s1,8(sp)
    80001bca:	6902                	ld	s2,0(sp)
    80001bcc:	6105                	addi	sp,sp,32
    80001bce:	8082                	ret
    freeproc(p);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	f0bff0ef          	jal	80001adc <freeproc>
    release(&p->lock);
    80001bd6:	8526                	mv	a0,s1
    80001bd8:	898ff0ef          	jal	80000c70 <release>
    return 0;
    80001bdc:	84ca                	mv	s1,s2
    80001bde:	b7d5                	j	80001bc2 <allocproc+0x9a>
    freeproc(p);
    80001be0:	8526                	mv	a0,s1
    80001be2:	efbff0ef          	jal	80001adc <freeproc>
    release(&p->lock);
    80001be6:	8526                	mv	a0,s1
    80001be8:	888ff0ef          	jal	80000c70 <release>
    return 0;
    80001bec:	84ca                	mv	s1,s2
    80001bee:	bfd1                	j	80001bc2 <allocproc+0x9a>

0000000080001bf0 <userinit>:
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bfa:	f2fff0ef          	jal	80001b28 <allocproc>
    80001bfe:	84aa                	mv	s1,a0
  initproc = p;
    80001c00:	00009797          	auipc	a5,0x9
    80001c04:	86a7b823          	sd	a0,-1936(a5) # 8000a470 <initproc>
  p->cwd = namei("/");
    80001c08:	00005517          	auipc	a0,0x5
    80001c0c:	58850513          	addi	a0,a0,1416 # 80007190 <etext+0x190>
    80001c10:	188020ef          	jal	80003d98 <namei>
    80001c14:	14a4b823          	sd	a0,336(s1)
  p->arrival_tick = ticks;
    80001c18:	00009597          	auipc	a1,0x9
    80001c1c:	8605a583          	lw	a1,-1952(a1) # 8000a478 <ticks>
    80001c20:	16b4a423          	sw	a1,360(s1)
  p->enqueue_time = ticks;
    80001c24:	18b4a223          	sw	a1,388(s1)
  printk("QLOG tick=%d pid=%d q=0 event=new\n", ticks, p->pid);
    80001c28:	5890                	lw	a2,48(s1)
    80001c2a:	00005517          	auipc	a0,0x5
    80001c2e:	56e50513          	addi	a0,a0,1390 # 80007198 <etext+0x198>
    80001c32:	8d9fe0ef          	jal	8000050a <printk>
  p->state = RUNNABLE;
    80001c36:	478d                	li	a5,3
    80001c38:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	834ff0ef          	jal	80000c70 <release>
}
    80001c40:	60e2                	ld	ra,24(sp)
    80001c42:	6442                	ld	s0,16(sp)
    80001c44:	64a2                	ld	s1,8(sp)
    80001c46:	6105                	addi	sp,sp,32
    80001c48:	8082                	ret

0000000080001c4a <growproc>:
{
    80001c4a:	1101                	addi	sp,sp,-32
    80001c4c:	ec06                	sd	ra,24(sp)
    80001c4e:	e822                	sd	s0,16(sp)
    80001c50:	e426                	sd	s1,8(sp)
    80001c52:	e04a                	sd	s2,0(sp)
    80001c54:	1000                	addi	s0,sp,32
    80001c56:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c58:	ca5ff0ef          	jal	800018fc <myproc>
    80001c5c:	892a                	mv	s2,a0
  sz = p->sz;
    80001c5e:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c60:	02905963          	blez	s1,80001c92 <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    80001c64:	00b48633          	add	a2,s1,a1
    80001c68:	020007b7          	lui	a5,0x2000
    80001c6c:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c6e:	07b6                	slli	a5,a5,0xd
    80001c70:	02c7ea63          	bltu	a5,a2,80001ca4 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c74:	4691                	li	a3,4
    80001c76:	6928                	ld	a0,80(a0)
    80001c78:	e36ff0ef          	jal	800012ae <uvmalloc>
    80001c7c:	85aa                	mv	a1,a0
    80001c7e:	c50d                	beqz	a0,80001ca8 <growproc+0x5e>
  p->sz = sz;
    80001c80:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c84:	4501                	li	a0,0
}
    80001c86:	60e2                	ld	ra,24(sp)
    80001c88:	6442                	ld	s0,16(sp)
    80001c8a:	64a2                	ld	s1,8(sp)
    80001c8c:	6902                	ld	s2,0(sp)
    80001c8e:	6105                	addi	sp,sp,32
    80001c90:	8082                	ret
  } else if (n < 0) {
    80001c92:	fe04d7e3          	bgez	s1,80001c80 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c96:	00b48633          	add	a2,s1,a1
    80001c9a:	6928                	ld	a0,80(a0)
    80001c9c:	dceff0ef          	jal	8000126a <uvmdealloc>
    80001ca0:	85aa                	mv	a1,a0
    80001ca2:	bff9                	j	80001c80 <growproc+0x36>
      return -1;
    80001ca4:	557d                	li	a0,-1
    80001ca6:	b7c5                	j	80001c86 <growproc+0x3c>
      return -1;
    80001ca8:	557d                	li	a0,-1
    80001caa:	bff1                	j	80001c86 <growproc+0x3c>

0000000080001cac <kfork>:
{
    80001cac:	7139                	addi	sp,sp,-64
    80001cae:	fc06                	sd	ra,56(sp)
    80001cb0:	f822                	sd	s0,48(sp)
    80001cb2:	f426                	sd	s1,40(sp)
    80001cb4:	e456                	sd	s5,8(sp)
    80001cb6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001cb8:	c45ff0ef          	jal	800018fc <myproc>
    80001cbc:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001cbe:	e6bff0ef          	jal	80001b28 <allocproc>
    80001cc2:	10050a63          	beqz	a0,80001dd6 <kfork+0x12a>
    80001cc6:	ec4e                	sd	s3,24(sp)
    80001cc8:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001cca:	048ab603          	ld	a2,72(s5)
    80001cce:	692c                	ld	a1,80(a0)
    80001cd0:	050ab503          	ld	a0,80(s5)
    80001cd4:	f12ff0ef          	jal	800013e6 <uvmcopy>
    80001cd8:	04054863          	bltz	a0,80001d28 <kfork+0x7c>
    80001cdc:	f04a                	sd	s2,32(sp)
    80001cde:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001ce0:	048ab783          	ld	a5,72(s5)
    80001ce4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001ce8:	058ab683          	ld	a3,88(s5)
    80001cec:	87b6                	mv	a5,a3
    80001cee:	0589b703          	ld	a4,88(s3)
    80001cf2:	12068693          	addi	a3,a3,288
    80001cf6:	6388                	ld	a0,0(a5)
    80001cf8:	678c                	ld	a1,8(a5)
    80001cfa:	6b90                	ld	a2,16(a5)
    80001cfc:	e308                	sd	a0,0(a4)
    80001cfe:	e70c                	sd	a1,8(a4)
    80001d00:	eb10                	sd	a2,16(a4)
    80001d02:	6f90                	ld	a2,24(a5)
    80001d04:	ef10                	sd	a2,24(a4)
    80001d06:	02078793          	addi	a5,a5,32
    80001d0a:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001d0e:	fed794e3          	bne	a5,a3,80001cf6 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001d12:	0589b783          	ld	a5,88(s3)
    80001d16:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001d1a:	0d0a8493          	addi	s1,s5,208
    80001d1e:	0d098913          	addi	s2,s3,208
    80001d22:	150a8a13          	addi	s4,s5,336
    80001d26:	a831                	j	80001d42 <kfork+0x96>
    freeproc(np);
    80001d28:	854e                	mv	a0,s3
    80001d2a:	db3ff0ef          	jal	80001adc <freeproc>
    release(&np->lock);
    80001d2e:	854e                	mv	a0,s3
    80001d30:	f41fe0ef          	jal	80000c70 <release>
    return -1;
    80001d34:	54fd                	li	s1,-1
    80001d36:	69e2                	ld	s3,24(sp)
    80001d38:	a841                	j	80001dc8 <kfork+0x11c>
  for (i = 0; i < NOFILE; i++)
    80001d3a:	04a1                	addi	s1,s1,8
    80001d3c:	0921                	addi	s2,s2,8
    80001d3e:	01448963          	beq	s1,s4,80001d50 <kfork+0xa4>
    if (p->ofile[i])
    80001d42:	6088                	ld	a0,0(s1)
    80001d44:	d97d                	beqz	a0,80001d3a <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d46:	6a4020ef          	jal	800043ea <filedup>
    80001d4a:	00a93023          	sd	a0,0(s2)
    80001d4e:	b7f5                	j	80001d3a <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001d50:	150ab503          	ld	a0,336(s5)
    80001d54:	782010ef          	jal	800034d6 <idup>
    80001d58:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d5c:	4641                	li	a2,16
    80001d5e:	158a8593          	addi	a1,s5,344
    80001d62:	15898513          	addi	a0,s3,344
    80001d66:	896ff0ef          	jal	80000dfc <safestrcpy>
  pid = np->pid;
    80001d6a:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001d6e:	854e                	mv	a0,s3
    80001d70:	f01fe0ef          	jal	80000c70 <release>
  acquire(&wait_lock);
    80001d74:	00011517          	auipc	a0,0x11
    80001d78:	83450513          	addi	a0,a0,-1996 # 800125a8 <wait_lock>
    80001d7c:	e6dfe0ef          	jal	80000be8 <acquire>
  np->parent = p;
    80001d80:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001d84:	00011517          	auipc	a0,0x11
    80001d88:	82450513          	addi	a0,a0,-2012 # 800125a8 <wait_lock>
    80001d8c:	ee5fe0ef          	jal	80000c70 <release>
  acquire(&np->lock);
    80001d90:	854e                	mv	a0,s3
    80001d92:	e57fe0ef          	jal	80000be8 <acquire>
  np->arrival_tick = ticks;
    80001d96:	00008597          	auipc	a1,0x8
    80001d9a:	6e25a583          	lw	a1,1762(a1) # 8000a478 <ticks>
    80001d9e:	16b9a423          	sw	a1,360(s3)
  np->enqueue_time = ticks;
    80001da2:	18b9a223          	sw	a1,388(s3)
  printk("QLOG tick=%d pid=%d q=0 event=new\n", ticks, np->pid);
    80001da6:	0309a603          	lw	a2,48(s3)
    80001daa:	00005517          	auipc	a0,0x5
    80001dae:	3ee50513          	addi	a0,a0,1006 # 80007198 <etext+0x198>
    80001db2:	f58fe0ef          	jal	8000050a <printk>
  np->state = RUNNABLE;
    80001db6:	478d                	li	a5,3
    80001db8:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001dbc:	854e                	mv	a0,s3
    80001dbe:	eb3fe0ef          	jal	80000c70 <release>
  return pid;
    80001dc2:	7902                	ld	s2,32(sp)
    80001dc4:	69e2                	ld	s3,24(sp)
    80001dc6:	6a42                	ld	s4,16(sp)
}
    80001dc8:	8526                	mv	a0,s1
    80001dca:	70e2                	ld	ra,56(sp)
    80001dcc:	7442                	ld	s0,48(sp)
    80001dce:	74a2                	ld	s1,40(sp)
    80001dd0:	6aa2                	ld	s5,8(sp)
    80001dd2:	6121                	addi	sp,sp,64
    80001dd4:	8082                	ret
    return -1;
    80001dd6:	54fd                	li	s1,-1
    80001dd8:	bfc5                	j	80001dc8 <kfork+0x11c>

0000000080001dda <scheduler>:
{
    80001dda:	7159                	addi	sp,sp,-112
    80001ddc:	f486                	sd	ra,104(sp)
    80001dde:	f0a2                	sd	s0,96(sp)
    80001de0:	eca6                	sd	s1,88(sp)
    80001de2:	e8ca                	sd	s2,80(sp)
    80001de4:	e4ce                	sd	s3,72(sp)
    80001de6:	e0d2                	sd	s4,64(sp)
    80001de8:	fc56                	sd	s5,56(sp)
    80001dea:	f85a                	sd	s6,48(sp)
    80001dec:	f45e                	sd	s7,40(sp)
    80001dee:	f062                	sd	s8,32(sp)
    80001df0:	ec66                	sd	s9,24(sp)
    80001df2:	e86a                	sd	s10,16(sp)
    80001df4:	e46e                	sd	s11,8(sp)
    80001df6:	1880                	addi	s0,sp,112
    80001df8:	8792                	mv	a5,tp
  int id = r_tp();
    80001dfa:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001dfc:	00779c93          	slli	s9,a5,0x7
    80001e00:	00010717          	auipc	a4,0x10
    80001e04:	79070713          	addi	a4,a4,1936 # 80012590 <pid_lock>
    80001e08:	9766                	add	a4,a4,s9
    80001e0a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &best->context);
    80001e0e:	00010717          	auipc	a4,0x10
    80001e12:	7ba70713          	addi	a4,a4,1978 # 800125c8 <cpus+0x8>
    80001e16:	9cba                	add	s9,s9,a4
    int best_priority = NQUEUE; // worse than any real queue number
    80001e18:	4b91                	li	s7,4
      if (p->state == RUNNABLE) {
    80001e1a:	490d                	li	s2,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e1c:	00017997          	auipc	s3,0x17
    80001e20:	da498993          	addi	s3,s3,-604 # 80018bc0 <tickslock>
        best->run_start_tick = ticks;
    80001e24:	00008d97          	auipc	s11,0x8
    80001e28:	654d8d93          	addi	s11,s11,1620 # 8000a478 <ticks>
        c->proc = best;
    80001e2c:	00010d17          	auipc	s10,0x10
    80001e30:	764d0d13          	addi	s10,s10,1892 # 80012590 <pid_lock>
    80001e34:	079e                	slli	a5,a5,0x7
    80001e36:	00fd0c33          	add	s8,s10,a5
    80001e3a:	a8a9                	j	80001e94 <scheduler+0xba>
          best_priority = p->priority;
    80001e3c:	17c4aa83          	lw	s5,380(s1)
          best_enqueue = p->enqueue_time;
    80001e40:	1844ab03          	lw	s6,388(s1)
          best = p;
    80001e44:	8a26                	mv	s4,s1
      release(&p->lock);
    80001e46:	8526                	mv	a0,s1
    80001e48:	e29fe0ef          	jal	80000c70 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e4c:	18848493          	addi	s1,s1,392
    80001e50:	03348563          	beq	s1,s3,80001e7a <scheduler+0xa0>
      acquire(&p->lock);
    80001e54:	8526                	mv	a0,s1
    80001e56:	d93fe0ef          	jal	80000be8 <acquire>
      if (p->state == RUNNABLE) {
    80001e5a:	4c9c                	lw	a5,24(s1)
    80001e5c:	ff2795e3          	bne	a5,s2,80001e46 <scheduler+0x6c>
        if (best == 0 || p->priority < best_priority ||
    80001e60:	fc0a0ee3          	beqz	s4,80001e3c <scheduler+0x62>
    80001e64:	17c4a783          	lw	a5,380(s1)
    80001e68:	fd57cae3          	blt	a5,s5,80001e3c <scheduler+0x62>
    80001e6c:	fd579de3          	bne	a5,s5,80001e46 <scheduler+0x6c>
            (p->priority == best_priority && p->enqueue_time < best_enqueue)) {
    80001e70:	1844a783          	lw	a5,388(s1)
    80001e74:	fd67f9e3          	bgeu	a5,s6,80001e46 <scheduler+0x6c>
    80001e78:	b7d1                	j	80001e3c <scheduler+0x62>
    if (best) {
    80001e7a:	060a0863          	beqz	s4,80001eea <scheduler+0x110>
      acquire(&best->lock);
    80001e7e:	84d2                	mv	s1,s4
    80001e80:	8552                	mv	a0,s4
    80001e82:	d67fe0ef          	jal	80000be8 <acquire>
      if (best->state == RUNNABLE) {
    80001e86:	018a2783          	lw	a5,24(s4)
    80001e8a:	03278163          	beq	a5,s2,80001eac <scheduler+0xd2>
      release(&best->lock);
    80001e8e:	8526                	mv	a0,s1
    80001e90:	de1fe0ef          	jal	80000c70 <release>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001e94:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001e98:	10017073          	csrci	sstatus,2
    uint best_enqueue = 0;
    80001e9c:	4b01                	li	s6,0
    int best_priority = NQUEUE; // worse than any real queue number
    80001e9e:	8ade                	mv	s5,s7
    struct proc *best = 0;
    80001ea0:	4a01                	li	s4,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001ea2:	00011497          	auipc	s1,0x11
    80001ea6:	b1e48493          	addi	s1,s1,-1250 # 800129c0 <proc>
    80001eaa:	b76d                	j	80001e54 <scheduler+0x7a>
        if (best->first_run_tick < 0)
    80001eac:	16ca2783          	lw	a5,364(s4)
    80001eb0:	0207c863          	bltz	a5,80001ee0 <scheduler+0x106>
        best->run_start_tick = ticks;
    80001eb4:	000da783          	lw	a5,0(s11)
    80001eb8:	16fa2c23          	sw	a5,376(s4)
        best->state = RUNNING;
    80001ebc:	017a2c23          	sw	s7,24(s4)
        c->proc = best;
    80001ec0:	034c3823          	sd	s4,48(s8) # fffffffffffff030 <end+0xffffffff7ffdb090>
        swtch(&c->context, &best->context);
    80001ec4:	060a0593          	addi	a1,s4,96
    80001ec8:	8566                	mv	a0,s9
    80001eca:	7f0000ef          	jal	800026ba <swtch>
  asm volatile("mv %0, tp" : "=r"(x));
    80001ece:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001ed0:	2781                	sext.w	a5,a5
    80001ed2:	079e                	slli	a5,a5,0x7
    80001ed4:	97ea                	add	a5,a5,s10
    80001ed6:	0a07a623          	sw	zero,172(a5)
        c->proc = 0;
    80001eda:	020c3823          	sd	zero,48(s8)
    80001ede:	bf45                	j	80001e8e <scheduler+0xb4>
          best->first_run_tick = ticks;
    80001ee0:	000da783          	lw	a5,0(s11)
    80001ee4:	16fa2623          	sw	a5,364(s4)
    80001ee8:	b7f1                	j	80001eb4 <scheduler+0xda>
      asm volatile("wfi");
    80001eea:	10500073          	wfi
    80001eee:	b75d                	j	80001e94 <scheduler+0xba>

0000000080001ef0 <sched>:
{
    80001ef0:	7179                	addi	sp,sp,-48
    80001ef2:	f406                	sd	ra,40(sp)
    80001ef4:	f022                	sd	s0,32(sp)
    80001ef6:	ec26                	sd	s1,24(sp)
    80001ef8:	e84a                	sd	s2,16(sp)
    80001efa:	e44e                	sd	s3,8(sp)
    80001efc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001efe:	9ffff0ef          	jal	800018fc <myproc>
    80001f02:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001f04:	c7ffe0ef          	jal	80000b82 <holding>
    80001f08:	c935                	beqz	a0,80001f7c <sched+0x8c>
    80001f0a:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001f0c:	2781                	sext.w	a5,a5
    80001f0e:	079e                	slli	a5,a5,0x7
    80001f10:	00010717          	auipc	a4,0x10
    80001f14:	68070713          	addi	a4,a4,1664 # 80012590 <pid_lock>
    80001f18:	97ba                	add	a5,a5,a4
    80001f1a:	0a87a703          	lw	a4,168(a5)
    80001f1e:	4785                	li	a5,1
    80001f20:	06f71463          	bne	a4,a5,80001f88 <sched+0x98>
  if (p->state == RUNNING)
    80001f24:	4c98                	lw	a4,24(s1)
    80001f26:	4791                	li	a5,4
    80001f28:	06f70663          	beq	a4,a5,80001f94 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f2c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f30:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001f32:	e7bd                	bnez	a5,80001fa0 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r"(x));
    80001f34:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f36:	00010917          	auipc	s2,0x10
    80001f3a:	65a90913          	addi	s2,s2,1626 # 80012590 <pid_lock>
    80001f3e:	2781                	sext.w	a5,a5
    80001f40:	079e                	slli	a5,a5,0x7
    80001f42:	97ca                	add	a5,a5,s2
    80001f44:	0ac7a983          	lw	s3,172(a5)
    80001f48:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f4a:	2781                	sext.w	a5,a5
    80001f4c:	079e                	slli	a5,a5,0x7
    80001f4e:	07a1                	addi	a5,a5,8
    80001f50:	00010597          	auipc	a1,0x10
    80001f54:	67058593          	addi	a1,a1,1648 # 800125c0 <cpus>
    80001f58:	95be                	add	a1,a1,a5
    80001f5a:	06048513          	addi	a0,s1,96
    80001f5e:	75c000ef          	jal	800026ba <swtch>
    80001f62:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001f64:	2781                	sext.w	a5,a5
    80001f66:	079e                	slli	a5,a5,0x7
    80001f68:	993e                	add	s2,s2,a5
    80001f6a:	0b392623          	sw	s3,172(s2)
}
    80001f6e:	70a2                	ld	ra,40(sp)
    80001f70:	7402                	ld	s0,32(sp)
    80001f72:	64e2                	ld	s1,24(sp)
    80001f74:	6942                	ld	s2,16(sp)
    80001f76:	69a2                	ld	s3,8(sp)
    80001f78:	6145                	addi	sp,sp,48
    80001f7a:	8082                	ret
    panic("sched p->lock");
    80001f7c:	00005517          	auipc	a0,0x5
    80001f80:	24450513          	addi	a0,a0,580 # 800071c0 <etext+0x1c0>
    80001f84:	8b1fe0ef          	jal	80000834 <panic>
    panic("sched locks");
    80001f88:	00005517          	auipc	a0,0x5
    80001f8c:	24850513          	addi	a0,a0,584 # 800071d0 <etext+0x1d0>
    80001f90:	8a5fe0ef          	jal	80000834 <panic>
    panic("sched RUNNING");
    80001f94:	00005517          	auipc	a0,0x5
    80001f98:	24c50513          	addi	a0,a0,588 # 800071e0 <etext+0x1e0>
    80001f9c:	899fe0ef          	jal	80000834 <panic>
    panic("sched interruptible");
    80001fa0:	00005517          	auipc	a0,0x5
    80001fa4:	25050513          	addi	a0,a0,592 # 800071f0 <etext+0x1f0>
    80001fa8:	88dfe0ef          	jal	80000834 <panic>

0000000080001fac <yield>:
{
    80001fac:	1101                	addi	sp,sp,-32
    80001fae:	ec06                	sd	ra,24(sp)
    80001fb0:	e822                	sd	s0,16(sp)
    80001fb2:	e426                	sd	s1,8(sp)
    80001fb4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001fb6:	947ff0ef          	jal	800018fc <myproc>
    80001fba:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001fbc:	c2dfe0ef          	jal	80000be8 <acquire>
  p->running_ticks += ticks - p->run_start_tick;
    80001fc0:	00008597          	auipc	a1,0x8
    80001fc4:	4b85a583          	lw	a1,1208(a1) # 8000a478 <ticks>
    80001fc8:	1744a783          	lw	a5,372(s1)
    80001fcc:	9fad                	addw	a5,a5,a1
    80001fce:	1784a703          	lw	a4,376(s1)
    80001fd2:	9f99                	subw	a5,a5,a4
    80001fd4:	16f4aa23          	sw	a5,372(s1)
  p->ticks_in_slice++;
    80001fd8:	1804a783          	lw	a5,384(s1)
    80001fdc:	2785                	addiw	a5,a5,1
    80001fde:	18f4a023          	sw	a5,384(s1)
  if (p->ticks_in_slice >= mlfq_slice[p->priority]) {
    80001fe2:	17c4a683          	lw	a3,380(s1)
    80001fe6:	00269613          	slli	a2,a3,0x2
    80001fea:	00006717          	auipc	a4,0x6
    80001fee:	87670713          	addi	a4,a4,-1930 # 80007860 <mlfq_slice>
    80001ff2:	9732                	add	a4,a4,a2
    80001ff4:	4318                	lw	a4,0(a4)
    80001ff6:	02e7c363          	blt	a5,a4,8000201c <yield+0x70>
    if (p->priority < NQUEUE - 1)
    80001ffa:	4789                	li	a5,2
    80001ffc:	00d7c563          	blt	a5,a3,80002006 <yield+0x5a>
      p->priority++;
    80002000:	2685                	addiw	a3,a3,1
    80002002:	16d4ae23          	sw	a3,380(s1)
    p->ticks_in_slice = 0;
    80002006:	1804a023          	sw	zero,384(s1)
    printk("QLOG tick=%d pid=%d q=%d event=demote\n", ticks, p->pid, p->priority);
    8000200a:	17c4a683          	lw	a3,380(s1)
    8000200e:	5890                	lw	a2,48(s1)
    80002010:	00005517          	auipc	a0,0x5
    80002014:	1f850513          	addi	a0,a0,504 # 80007208 <etext+0x208>
    80002018:	cf2fe0ef          	jal	8000050a <printk>
  p->enqueue_time = ticks;
    8000201c:	00008797          	auipc	a5,0x8
    80002020:	45c7a783          	lw	a5,1116(a5) # 8000a478 <ticks>
    80002024:	18f4a223          	sw	a5,388(s1)
  p->state = RUNNABLE;
    80002028:	478d                	li	a5,3
    8000202a:	cc9c                	sw	a5,24(s1)
  sched();
    8000202c:	ec5ff0ef          	jal	80001ef0 <sched>
  release(&p->lock);
    80002030:	8526                	mv	a0,s1
    80002032:	c3ffe0ef          	jal	80000c70 <release>
}
    80002036:	60e2                	ld	ra,24(sp)
    80002038:	6442                	ld	s0,16(sp)
    8000203a:	64a2                	ld	s1,8(sp)
    8000203c:	6105                	addi	sp,sp,32
    8000203e:	8082                	ret

0000000080002040 <account_waiting_ticks>:
{
    80002040:	7179                	addi	sp,sp,-48
    80002042:	f406                	sd	ra,40(sp)
    80002044:	f022                	sd	s0,32(sp)
    80002046:	ec26                	sd	s1,24(sp)
    80002048:	e84a                	sd	s2,16(sp)
    8000204a:	e44e                	sd	s3,8(sp)
    8000204c:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    8000204e:	00011497          	auipc	s1,0x11
    80002052:	97248493          	addi	s1,s1,-1678 # 800129c0 <proc>
    if (p->state == RUNNABLE)
    80002056:	498d                	li	s3,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80002058:	00017917          	auipc	s2,0x17
    8000205c:	b6890913          	addi	s2,s2,-1176 # 80018bc0 <tickslock>
    80002060:	a801                	j	80002070 <account_waiting_ticks+0x30>
    release(&p->lock);
    80002062:	8526                	mv	a0,s1
    80002064:	c0dfe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002068:	18848493          	addi	s1,s1,392
    8000206c:	01248e63          	beq	s1,s2,80002088 <account_waiting_ticks+0x48>
    acquire(&p->lock);
    80002070:	8526                	mv	a0,s1
    80002072:	b77fe0ef          	jal	80000be8 <acquire>
    if (p->state == RUNNABLE)
    80002076:	4c9c                	lw	a5,24(s1)
    80002078:	ff3795e3          	bne	a5,s3,80002062 <account_waiting_ticks+0x22>
      p->waiting_ticks++;
    8000207c:	1704a783          	lw	a5,368(s1)
    80002080:	2785                	addiw	a5,a5,1
    80002082:	16f4a823          	sw	a5,368(s1)
    80002086:	bff1                	j	80002062 <account_waiting_ticks+0x22>
}
    80002088:	70a2                	ld	ra,40(sp)
    8000208a:	7402                	ld	s0,32(sp)
    8000208c:	64e2                	ld	s1,24(sp)
    8000208e:	6942                	ld	s2,16(sp)
    80002090:	69a2                	ld	s3,8(sp)
    80002092:	6145                	addi	sp,sp,48
    80002094:	8082                	ret

0000000080002096 <mlfq_boost>:
  if (ticks - mlfq_last_boost < BOOST_INTERVAL)
    80002096:	00008717          	auipc	a4,0x8
    8000209a:	3e272703          	lw	a4,994(a4) # 8000a478 <ticks>
    8000209e:	00008797          	auipc	a5,0x8
    800020a2:	3ca7a783          	lw	a5,970(a5) # 8000a468 <mlfq_last_boost>
    800020a6:	40f707bb          	subw	a5,a4,a5
    800020aa:	02f00693          	li	a3,47
    800020ae:	08f6f063          	bgeu	a3,a5,8000212e <mlfq_boost+0x98>
{
    800020b2:	7179                	addi	sp,sp,-48
    800020b4:	f406                	sd	ra,40(sp)
    800020b6:	f022                	sd	s0,32(sp)
    800020b8:	ec26                	sd	s1,24(sp)
    800020ba:	e84a                	sd	s2,16(sp)
    800020bc:	e44e                	sd	s3,8(sp)
    800020be:	e052                	sd	s4,0(sp)
    800020c0:	1800                	addi	s0,sp,48
  mlfq_last_boost = ticks;
    800020c2:	00008797          	auipc	a5,0x8
    800020c6:	3ae7a323          	sw	a4,934(a5) # 8000a468 <mlfq_last_boost>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020ca:	00011497          	auipc	s1,0x11
    800020ce:	8f648493          	addi	s1,s1,-1802 # 800129c0 <proc>
      p->enqueue_time = ticks;
    800020d2:	00008a17          	auipc	s4,0x8
    800020d6:	3a6a0a13          	addi	s4,s4,934 # 8000a478 <ticks>
      printk("QLOG tick=%d pid=%d q=0 event=boost\n", ticks, p->pid);
    800020da:	00005997          	auipc	s3,0x5
    800020de:	15698993          	addi	s3,s3,342 # 80007230 <etext+0x230>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020e2:	00017917          	auipc	s2,0x17
    800020e6:	ade90913          	addi	s2,s2,-1314 # 80018bc0 <tickslock>
    800020ea:	a801                	j	800020fa <mlfq_boost+0x64>
    release(&p->lock);
    800020ec:	8526                	mv	a0,s1
    800020ee:	b83fe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020f2:	18848493          	addi	s1,s1,392
    800020f6:	03248463          	beq	s1,s2,8000211e <mlfq_boost+0x88>
    acquire(&p->lock);
    800020fa:	8526                	mv	a0,s1
    800020fc:	aedfe0ef          	jal	80000be8 <acquire>
    if (p->state != UNUSED) {
    80002100:	4c9c                	lw	a5,24(s1)
    80002102:	d7ed                	beqz	a5,800020ec <mlfq_boost+0x56>
      p->priority = 0;
    80002104:	1604ae23          	sw	zero,380(s1)
      p->ticks_in_slice = 0;
    80002108:	1804a023          	sw	zero,384(s1)
      p->enqueue_time = ticks;
    8000210c:	000a2583          	lw	a1,0(s4)
    80002110:	18b4a223          	sw	a1,388(s1)
      printk("QLOG tick=%d pid=%d q=0 event=boost\n", ticks, p->pid);
    80002114:	5890                	lw	a2,48(s1)
    80002116:	854e                	mv	a0,s3
    80002118:	bf2fe0ef          	jal	8000050a <printk>
    8000211c:	bfc1                	j	800020ec <mlfq_boost+0x56>
}
    8000211e:	70a2                	ld	ra,40(sp)
    80002120:	7402                	ld	s0,32(sp)
    80002122:	64e2                	ld	s1,24(sp)
    80002124:	6942                	ld	s2,16(sp)
    80002126:	69a2                	ld	s3,8(sp)
    80002128:	6a02                	ld	s4,0(sp)
    8000212a:	6145                	addi	sp,sp,48
    8000212c:	8082                	ret
    8000212e:	8082                	ret

0000000080002130 <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80002130:	1101                	addi	sp,sp,-32
    80002132:	ec06                	sd	ra,24(sp)
    80002134:	e822                	sd	s0,16(sp)
    80002136:	e426                	sd	s1,8(sp)
    80002138:	e04a                	sd	s2,0(sp)
    8000213a:	1000                	addi	s0,sp,32
    8000213c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000213e:	fbeff0ef          	jal	800018fc <myproc>
    80002142:	892a                	mv	s2,a0

  acquire(&p->lock);
    80002144:	aa5fe0ef          	jal	80000be8 <acquire>
  if (chan == 0)
    80002148:	cc81                	beqz	s1,80002160 <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    8000214a:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    8000214e:	854a                	mv	a0,s2
    80002150:	b21fe0ef          	jal	80000c70 <release>
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6902                	ld	s2,0(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret
    panic("sleep_prepare: zero chan");
    80002160:	00005517          	auipc	a0,0x5
    80002164:	0f850513          	addi	a0,a0,248 # 80007258 <etext+0x258>
    80002168:	eccfe0ef          	jal	80000834 <panic>

000000008000216c <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	e426                	sd	s1,8(sp)
    80002174:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002176:	f86ff0ef          	jal	800018fc <myproc>
    8000217a:	84aa                	mv	s1,a0

  acquire(&p->lock);
    8000217c:	a6dfe0ef          	jal	80000be8 <acquire>
  if (p->chan != 0) {
    80002180:	709c                	ld	a5,32(s1)
    80002182:	c38d                	beqz	a5,800021a4 <sleep+0x38>
    p->running_ticks += ticks - p->run_start_tick;
    80002184:	1744a703          	lw	a4,372(s1)
    80002188:	00008797          	auipc	a5,0x8
    8000218c:	2f07a783          	lw	a5,752(a5) # 8000a478 <ticks>
    80002190:	9fb9                	addw	a5,a5,a4
    80002192:	1784a703          	lw	a4,376(s1)
    80002196:	9f99                	subw	a5,a5,a4
    80002198:	16f4aa23          	sw	a5,372(s1)
    p->state = SLEEPING;
    8000219c:	4789                	li	a5,2
    8000219e:	cc9c                	sw	a5,24(s1)
    sched();
    800021a0:	d51ff0ef          	jal	80001ef0 <sched>
  }
  release(&p->lock);
    800021a4:	8526                	mv	a0,s1
    800021a6:	acbfe0ef          	jal	80000c70 <release>
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6105                	addi	sp,sp,32
    800021b2:	8082                	ret

00000000800021b4 <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    800021b4:	7139                	addi	sp,sp,-64
    800021b6:	fc06                	sd	ra,56(sp)
    800021b8:	f822                	sd	s0,48(sp)
    800021ba:	f426                	sd	s1,40(sp)
    800021bc:	f04a                	sd	s2,32(sp)
    800021be:	ec4e                	sd	s3,24(sp)
    800021c0:	e852                	sd	s4,16(sp)
    800021c2:	e456                	sd	s5,8(sp)
    800021c4:	e05a                	sd	s6,0(sp)
    800021c6:	0080                	addi	s0,sp,64
    800021c8:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800021ca:	00010497          	auipc	s1,0x10
    800021ce:	7f648493          	addi	s1,s1,2038 # 800129c0 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    800021d2:	4a09                	li	s4,2
#ifdef SCHEDULER_MLFQ
        // Voluntary yield (blocked on I/O) is over: priority is
        // unchanged, but it re-enters the tail of its queue.
        p->enqueue_time = ticks;
    800021d4:	00008b17          	auipc	s6,0x8
    800021d8:	2a4b0b13          	addi	s6,s6,676 # 8000a478 <ticks>
#endif
        p->state = RUNNABLE;
    800021dc:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800021de:	00017997          	auipc	s3,0x17
    800021e2:	9e298993          	addi	s3,s3,-1566 # 80018bc0 <tickslock>
    800021e6:	a801                	j	800021f6 <wakeup+0x42>
      }
    }
    release(&p->lock);
    800021e8:	8526                	mv	a0,s1
    800021ea:	a87fe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800021ee:	18848493          	addi	s1,s1,392
    800021f2:	03348463          	beq	s1,s3,8000221a <wakeup+0x66>
    acquire(&p->lock);
    800021f6:	8526                	mv	a0,s1
    800021f8:	9f1fe0ef          	jal	80000be8 <acquire>
    if (p->chan == chan) {
    800021fc:	709c                	ld	a5,32(s1)
    800021fe:	ff2795e3          	bne	a5,s2,800021e8 <wakeup+0x34>
      p->chan = 0;
    80002202:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    80002206:	4c9c                	lw	a5,24(s1)
    80002208:	ff4790e3          	bne	a5,s4,800021e8 <wakeup+0x34>
        p->enqueue_time = ticks;
    8000220c:	000b2783          	lw	a5,0(s6)
    80002210:	18f4a223          	sw	a5,388(s1)
        p->state = RUNNABLE;
    80002214:	0154ac23          	sw	s5,24(s1)
    80002218:	bfc1                	j	800021e8 <wakeup+0x34>
  }
}
    8000221a:	70e2                	ld	ra,56(sp)
    8000221c:	7442                	ld	s0,48(sp)
    8000221e:	74a2                	ld	s1,40(sp)
    80002220:	7902                	ld	s2,32(sp)
    80002222:	69e2                	ld	s3,24(sp)
    80002224:	6a42                	ld	s4,16(sp)
    80002226:	6aa2                	ld	s5,8(sp)
    80002228:	6b02                	ld	s6,0(sp)
    8000222a:	6121                	addi	sp,sp,64
    8000222c:	8082                	ret

000000008000222e <reparent>:
{
    8000222e:	7179                	addi	sp,sp,-48
    80002230:	f406                	sd	ra,40(sp)
    80002232:	f022                	sd	s0,32(sp)
    80002234:	ec26                	sd	s1,24(sp)
    80002236:	e84a                	sd	s2,16(sp)
    80002238:	e44e                	sd	s3,8(sp)
    8000223a:	e052                	sd	s4,0(sp)
    8000223c:	1800                	addi	s0,sp,48
    8000223e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002240:	00010497          	auipc	s1,0x10
    80002244:	78048493          	addi	s1,s1,1920 # 800129c0 <proc>
      pp->parent = initproc;
    80002248:	00008a17          	auipc	s4,0x8
    8000224c:	228a0a13          	addi	s4,s4,552 # 8000a470 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002250:	00017997          	auipc	s3,0x17
    80002254:	97098993          	addi	s3,s3,-1680 # 80018bc0 <tickslock>
    80002258:	a029                	j	80002262 <reparent+0x34>
    8000225a:	18848493          	addi	s1,s1,392
    8000225e:	01348b63          	beq	s1,s3,80002274 <reparent+0x46>
    if (pp->parent == p) {
    80002262:	7c9c                	ld	a5,56(s1)
    80002264:	ff279be3          	bne	a5,s2,8000225a <reparent+0x2c>
      pp->parent = initproc;
    80002268:	000a3503          	ld	a0,0(s4)
    8000226c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000226e:	f47ff0ef          	jal	800021b4 <wakeup>
    80002272:	b7e5                	j	8000225a <reparent+0x2c>
}
    80002274:	70a2                	ld	ra,40(sp)
    80002276:	7402                	ld	s0,32(sp)
    80002278:	64e2                	ld	s1,24(sp)
    8000227a:	6942                	ld	s2,16(sp)
    8000227c:	69a2                	ld	s3,8(sp)
    8000227e:	6a02                	ld	s4,0(sp)
    80002280:	6145                	addi	sp,sp,48
    80002282:	8082                	ret

0000000080002284 <kexit>:
{
    80002284:	7139                	addi	sp,sp,-64
    80002286:	fc06                	sd	ra,56(sp)
    80002288:	f822                	sd	s0,48(sp)
    8000228a:	f426                	sd	s1,40(sp)
    8000228c:	f04a                	sd	s2,32(sp)
    8000228e:	ec4e                	sd	s3,24(sp)
    80002290:	e852                	sd	s4,16(sp)
    80002292:	0080                	addi	s0,sp,64
    80002294:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002296:	e66ff0ef          	jal	800018fc <myproc>
    8000229a:	892a                	mv	s2,a0
  if (p == initproc)
    8000229c:	00008797          	auipc	a5,0x8
    800022a0:	1d47b783          	ld	a5,468(a5) # 8000a470 <initproc>
    800022a4:	0d050493          	addi	s1,a0,208
    800022a8:	15050993          	addi	s3,a0,336
    800022ac:	00a79b63          	bne	a5,a0,800022c2 <kexit+0x3e>
    panic("init exiting");
    800022b0:	00005517          	auipc	a0,0x5
    800022b4:	fc850513          	addi	a0,a0,-56 # 80007278 <etext+0x278>
    800022b8:	d7cfe0ef          	jal	80000834 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    800022bc:	04a1                	addi	s1,s1,8
    800022be:	01348963          	beq	s1,s3,800022d0 <kexit+0x4c>
    if (p->ofile[fd]) {
    800022c2:	6088                	ld	a0,0(s1)
    800022c4:	dd65                	beqz	a0,800022bc <kexit+0x38>
      fileclose(f);
    800022c6:	16a020ef          	jal	80004430 <fileclose>
      p->ofile[fd] = 0;
    800022ca:	0004b023          	sd	zero,0(s1)
    800022ce:	b7fd                	j	800022bc <kexit+0x38>
  begin_op();
    800022d0:	4a7010ef          	jal	80003f76 <begin_op>
  iput(p->cwd);
    800022d4:	15093503          	ld	a0,336(s2)
    800022d8:	3b6010ef          	jal	8000368e <iput>
  end_op();
    800022dc:	527010ef          	jal	80004002 <end_op>
  p->cwd = 0;
    800022e0:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800022e4:	00010517          	auipc	a0,0x10
    800022e8:	2c450513          	addi	a0,a0,708 # 800125a8 <wait_lock>
    800022ec:	8fdfe0ef          	jal	80000be8 <acquire>
  reparent(p);
    800022f0:	854a                	mv	a0,s2
    800022f2:	f3dff0ef          	jal	8000222e <reparent>
  wakeup(p->parent);
    800022f6:	03893503          	ld	a0,56(s2)
    800022fa:	ebbff0ef          	jal	800021b4 <wakeup>
  acquire(&p->lock);
    800022fe:	854a                	mv	a0,s2
    80002300:	8e9fe0ef          	jal	80000be8 <acquire>
  p->running_ticks += ticks - p->run_start_tick;
    80002304:	00008797          	auipc	a5,0x8
    80002308:	1747a783          	lw	a5,372(a5) # 8000a478 <ticks>
    8000230c:	17492603          	lw	a2,372(s2)
    80002310:	9e3d                	addw	a2,a2,a5
    80002312:	17892703          	lw	a4,376(s2)
    80002316:	9e19                	subw	a2,a2,a4
    80002318:	16c92a23          	sw	a2,372(s2)
    int response = (p->first_run_tick >= 0) ? (p->first_run_tick - (int)p->arrival_tick) : -1;
    8000231c:	16c92703          	lw	a4,364(s2)
    80002320:	557d                	li	a0,-1
    80002322:	00074663          	bltz	a4,8000232e <kexit+0xaa>
    80002326:	16892503          	lw	a0,360(s2)
    8000232a:	40a7053b          	subw	a0,a4,a0
    printk("STAT pid=%d name=%s arrival=%d first_run=%d completion=%d turnaround=%d waiting=%d running=%d response=%d\n",
    8000232e:	16892683          	lw	a3,360(s2)
    80002332:	17092883          	lw	a7,368(s2)
    80002336:	03092583          	lw	a1,48(s2)
    8000233a:	e42a                	sd	a0,8(sp)
    8000233c:	e032                	sd	a2,0(sp)
    8000233e:	40d7883b          	subw	a6,a5,a3
    80002342:	15890613          	addi	a2,s2,344
    80002346:	00005517          	auipc	a0,0x5
    8000234a:	f4250513          	addi	a0,a0,-190 # 80007288 <etext+0x288>
    8000234e:	9bcfe0ef          	jal	8000050a <printk>
  p->xstate = status;
    80002352:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    80002356:	4795                	li	a5,5
    80002358:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    8000235c:	00010517          	auipc	a0,0x10
    80002360:	24c50513          	addi	a0,a0,588 # 800125a8 <wait_lock>
    80002364:	90dfe0ef          	jal	80000c70 <release>
  sched();
    80002368:	b89ff0ef          	jal	80001ef0 <sched>
  panic("zombie exit");
    8000236c:	00005517          	auipc	a0,0x5
    80002370:	f8c50513          	addi	a0,a0,-116 # 800072f8 <etext+0x2f8>
    80002374:	cc0fe0ef          	jal	80000834 <panic>

0000000080002378 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80002378:	7179                	addi	sp,sp,-48
    8000237a:	f406                	sd	ra,40(sp)
    8000237c:	f022                	sd	s0,32(sp)
    8000237e:	ec26                	sd	s1,24(sp)
    80002380:	e84a                	sd	s2,16(sp)
    80002382:	e44e                	sd	s3,8(sp)
    80002384:	1800                	addi	s0,sp,48
    80002386:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002388:	00010497          	auipc	s1,0x10
    8000238c:	63848493          	addi	s1,s1,1592 # 800129c0 <proc>
    80002390:	00017997          	auipc	s3,0x17
    80002394:	83098993          	addi	s3,s3,-2000 # 80018bc0 <tickslock>
    acquire(&p->lock);
    80002398:	8526                	mv	a0,s1
    8000239a:	84ffe0ef          	jal	80000be8 <acquire>
    if (p->pid == pid) {
    8000239e:	589c                	lw	a5,48(s1)
    800023a0:	01278b63          	beq	a5,s2,800023b6 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023a4:	8526                	mv	a0,s1
    800023a6:	8cbfe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800023aa:	18848493          	addi	s1,s1,392
    800023ae:	ff3495e3          	bne	s1,s3,80002398 <kkill+0x20>
  }
  return -1;
    800023b2:	557d                	li	a0,-1
    800023b4:	a819                	j	800023ca <kkill+0x52>
      p->killed = 1;
    800023b6:	4785                	li	a5,1
    800023b8:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800023ba:	4c98                	lw	a4,24(s1)
    800023bc:	4789                	li	a5,2
    800023be:	00f70d63          	beq	a4,a5,800023d8 <kkill+0x60>
      release(&p->lock);
    800023c2:	8526                	mv	a0,s1
    800023c4:	8adfe0ef          	jal	80000c70 <release>
      return 0;
    800023c8:	4501                	li	a0,0
}
    800023ca:	70a2                	ld	ra,40(sp)
    800023cc:	7402                	ld	s0,32(sp)
    800023ce:	64e2                	ld	s1,24(sp)
    800023d0:	6942                	ld	s2,16(sp)
    800023d2:	69a2                	ld	s3,8(sp)
    800023d4:	6145                	addi	sp,sp,48
    800023d6:	8082                	ret
        p->enqueue_time = ticks;
    800023d8:	00008797          	auipc	a5,0x8
    800023dc:	0a07a783          	lw	a5,160(a5) # 8000a478 <ticks>
    800023e0:	18f4a223          	sw	a5,388(s1)
        p->state = RUNNABLE;
    800023e4:	478d                	li	a5,3
    800023e6:	cc9c                	sw	a5,24(s1)
    800023e8:	bfe9                	j	800023c2 <kkill+0x4a>

00000000800023ea <setkilled>:

void
setkilled(struct proc *p)
{
    800023ea:	1101                	addi	sp,sp,-32
    800023ec:	ec06                	sd	ra,24(sp)
    800023ee:	e822                	sd	s0,16(sp)
    800023f0:	e426                	sd	s1,8(sp)
    800023f2:	1000                	addi	s0,sp,32
    800023f4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023f6:	ff2fe0ef          	jal	80000be8 <acquire>
  p->killed = 1;
    800023fa:	4785                	li	a5,1
    800023fc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	871fe0ef          	jal	80000c70 <release>
}
    80002404:	60e2                	ld	ra,24(sp)
    80002406:	6442                	ld	s0,16(sp)
    80002408:	64a2                	ld	s1,8(sp)
    8000240a:	6105                	addi	sp,sp,32
    8000240c:	8082                	ret

000000008000240e <killed>:

int
killed(struct proc *p)
{
    8000240e:	1101                	addi	sp,sp,-32
    80002410:	ec06                	sd	ra,24(sp)
    80002412:	e822                	sd	s0,16(sp)
    80002414:	e426                	sd	s1,8(sp)
    80002416:	e04a                	sd	s2,0(sp)
    80002418:	1000                	addi	s0,sp,32
    8000241a:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000241c:	fccfe0ef          	jal	80000be8 <acquire>
  k = p->killed;
    80002420:	549c                	lw	a5,40(s1)
    80002422:	893e                	mv	s2,a5
  release(&p->lock);
    80002424:	8526                	mv	a0,s1
    80002426:	84bfe0ef          	jal	80000c70 <release>
  return k;
}
    8000242a:	854a                	mv	a0,s2
    8000242c:	60e2                	ld	ra,24(sp)
    8000242e:	6442                	ld	s0,16(sp)
    80002430:	64a2                	ld	s1,8(sp)
    80002432:	6902                	ld	s2,0(sp)
    80002434:	6105                	addi	sp,sp,32
    80002436:	8082                	ret

0000000080002438 <kwait>:
{
    80002438:	715d                	addi	sp,sp,-80
    8000243a:	e486                	sd	ra,72(sp)
    8000243c:	e0a2                	sd	s0,64(sp)
    8000243e:	fc26                	sd	s1,56(sp)
    80002440:	f84a                	sd	s2,48(sp)
    80002442:	f44e                	sd	s3,40(sp)
    80002444:	f052                	sd	s4,32(sp)
    80002446:	ec56                	sd	s5,24(sp)
    80002448:	e85a                	sd	s6,16(sp)
    8000244a:	e45e                	sd	s7,8(sp)
    8000244c:	0880                	addi	s0,sp,80
    8000244e:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002450:	cacff0ef          	jal	800018fc <myproc>
    80002454:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002456:	00010517          	auipc	a0,0x10
    8000245a:	15250513          	addi	a0,a0,338 # 800125a8 <wait_lock>
    8000245e:	f8afe0ef          	jal	80000be8 <acquire>
        if (pp->state == ZOMBIE) {
    80002462:	4a15                	li	s4,5
        havekids = 1;
    80002464:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002466:	00016997          	auipc	s3,0x16
    8000246a:	75a98993          	addi	s3,s3,1882 # 80018bc0 <tickslock>
    release(&wait_lock);
    8000246e:	00010b17          	auipc	s6,0x10
    80002472:	13ab0b13          	addi	s6,s6,314 # 800125a8 <wait_lock>
    80002476:	a845                	j	80002526 <kwait+0xee>
          pid = pp->pid;
    80002478:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    8000247c:	000b8e63          	beqz	s7,80002498 <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    80002480:	4711                	li	a4,4
    80002482:	02c48693          	addi	a3,s1,44
    80002486:	865e                	mv	a2,s7
    80002488:	04893583          	ld	a1,72(s2)
    8000248c:	05093503          	ld	a0,80(s2)
    80002490:	8b2ff0ef          	jal	80001542 <copyout>
          if (addr != 0 &&
    80002494:	02054c63          	bltz	a0,800024cc <kwait+0x94>
          pp->parent = 0;
    80002498:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    8000249c:	8526                	mv	a0,s1
    8000249e:	e3eff0ef          	jal	80001adc <freeproc>
          release(&pp->lock);
    800024a2:	8526                	mv	a0,s1
    800024a4:	fccfe0ef          	jal	80000c70 <release>
          release(&wait_lock);
    800024a8:	00010517          	auipc	a0,0x10
    800024ac:	10050513          	addi	a0,a0,256 # 800125a8 <wait_lock>
    800024b0:	fc0fe0ef          	jal	80000c70 <release>
}
    800024b4:	854e                	mv	a0,s3
    800024b6:	60a6                	ld	ra,72(sp)
    800024b8:	6406                	ld	s0,64(sp)
    800024ba:	74e2                	ld	s1,56(sp)
    800024bc:	7942                	ld	s2,48(sp)
    800024be:	79a2                	ld	s3,40(sp)
    800024c0:	7a02                	ld	s4,32(sp)
    800024c2:	6ae2                	ld	s5,24(sp)
    800024c4:	6b42                	ld	s6,16(sp)
    800024c6:	6ba2                	ld	s7,8(sp)
    800024c8:	6161                	addi	sp,sp,80
    800024ca:	8082                	ret
            release(&pp->lock);
    800024cc:	8526                	mv	a0,s1
    800024ce:	fa2fe0ef          	jal	80000c70 <release>
            release(&wait_lock);
    800024d2:	00010517          	auipc	a0,0x10
    800024d6:	0d650513          	addi	a0,a0,214 # 800125a8 <wait_lock>
    800024da:	f96fe0ef          	jal	80000c70 <release>
            return -1;
    800024de:	59fd                	li	s3,-1
    800024e0:	bfd1                	j	800024b4 <kwait+0x7c>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800024e2:	18848493          	addi	s1,s1,392
    800024e6:	03348063          	beq	s1,s3,80002506 <kwait+0xce>
      if (pp->parent == p) {
    800024ea:	7c9c                	ld	a5,56(s1)
    800024ec:	ff279be3          	bne	a5,s2,800024e2 <kwait+0xaa>
        acquire(&pp->lock);
    800024f0:	8526                	mv	a0,s1
    800024f2:	ef6fe0ef          	jal	80000be8 <acquire>
        if (pp->state == ZOMBIE) {
    800024f6:	4c9c                	lw	a5,24(s1)
    800024f8:	f94780e3          	beq	a5,s4,80002478 <kwait+0x40>
        release(&pp->lock);
    800024fc:	8526                	mv	a0,s1
    800024fe:	f72fe0ef          	jal	80000c70 <release>
        havekids = 1;
    80002502:	8756                	mv	a4,s5
    80002504:	bff9                	j	800024e2 <kwait+0xaa>
    if (!havekids || killed(p)) {
    80002506:	c715                	beqz	a4,80002532 <kwait+0xfa>
    80002508:	854a                	mv	a0,s2
    8000250a:	f05ff0ef          	jal	8000240e <killed>
    8000250e:	e115                	bnez	a0,80002532 <kwait+0xfa>
    sleep_prepare(p); //DOC: wait-sleep
    80002510:	854a                	mv	a0,s2
    80002512:	c1fff0ef          	jal	80002130 <sleep_prepare>
    release(&wait_lock);
    80002516:	855a                	mv	a0,s6
    80002518:	f58fe0ef          	jal	80000c70 <release>
    sleep();
    8000251c:	c51ff0ef          	jal	8000216c <sleep>
    acquire(&wait_lock);
    80002520:	855a                	mv	a0,s6
    80002522:	ec6fe0ef          	jal	80000be8 <acquire>
    havekids = 0;
    80002526:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002528:	00010497          	auipc	s1,0x10
    8000252c:	49848493          	addi	s1,s1,1176 # 800129c0 <proc>
    80002530:	bf6d                	j	800024ea <kwait+0xb2>
      release(&wait_lock);
    80002532:	00010517          	auipc	a0,0x10
    80002536:	07650513          	addi	a0,a0,118 # 800125a8 <wait_lock>
    8000253a:	f36fe0ef          	jal	80000c70 <release>
      return -1;
    8000253e:	59fd                	li	s3,-1
    80002540:	bf95                	j	800024b4 <kwait+0x7c>

0000000080002542 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002542:	7179                	addi	sp,sp,-48
    80002544:	f406                	sd	ra,40(sp)
    80002546:	f022                	sd	s0,32(sp)
    80002548:	ec26                	sd	s1,24(sp)
    8000254a:	e84a                	sd	s2,16(sp)
    8000254c:	e44e                	sd	s3,8(sp)
    8000254e:	e052                	sd	s4,0(sp)
    80002550:	1800                	addi	s0,sp,48
    80002552:	84aa                	mv	s1,a0
    80002554:	8a2e                	mv	s4,a1
    80002556:	89b2                	mv	s3,a2
    80002558:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000255a:	ba2ff0ef          	jal	800018fc <myproc>
  if (user_dst) {
    8000255e:	c085                	beqz	s1,8000257e <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    80002560:	874a                	mv	a4,s2
    80002562:	86ce                	mv	a3,s3
    80002564:	8652                	mv	a2,s4
    80002566:	652c                	ld	a1,72(a0)
    80002568:	6928                	ld	a0,80(a0)
    8000256a:	fd9fe0ef          	jal	80001542 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000256e:	70a2                	ld	ra,40(sp)
    80002570:	7402                	ld	s0,32(sp)
    80002572:	64e2                	ld	s1,24(sp)
    80002574:	6942                	ld	s2,16(sp)
    80002576:	69a2                	ld	s3,8(sp)
    80002578:	6a02                	ld	s4,0(sp)
    8000257a:	6145                	addi	sp,sp,48
    8000257c:	8082                	ret
    memmove((char *)dst, src, len);
    8000257e:	0009061b          	sext.w	a2,s2
    80002582:	85ce                	mv	a1,s3
    80002584:	8552                	mv	a0,s4
    80002586:	f82fe0ef          	jal	80000d08 <memmove>
    return 0;
    8000258a:	8526                	mv	a0,s1
    8000258c:	b7cd                	j	8000256e <either_copyout+0x2c>

000000008000258e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000258e:	7179                	addi	sp,sp,-48
    80002590:	f406                	sd	ra,40(sp)
    80002592:	f022                	sd	s0,32(sp)
    80002594:	ec26                	sd	s1,24(sp)
    80002596:	e84a                	sd	s2,16(sp)
    80002598:	e44e                	sd	s3,8(sp)
    8000259a:	e052                	sd	s4,0(sp)
    8000259c:	1800                	addi	s0,sp,48
    8000259e:	8a2a                	mv	s4,a0
    800025a0:	84ae                	mv	s1,a1
    800025a2:	89b2                	mv	s3,a2
    800025a4:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800025a6:	b56ff0ef          	jal	800018fc <myproc>
  if (user_src) {
    800025aa:	c085                	beqz	s1,800025ca <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    800025ac:	874a                	mv	a4,s2
    800025ae:	86ce                	mv	a3,s3
    800025b0:	8652                	mv	a2,s4
    800025b2:	652c                	ld	a1,72(a0)
    800025b4:	6928                	ld	a0,80(a0)
    800025b6:	852ff0ef          	jal	80001608 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800025ba:	70a2                	ld	ra,40(sp)
    800025bc:	7402                	ld	s0,32(sp)
    800025be:	64e2                	ld	s1,24(sp)
    800025c0:	6942                	ld	s2,16(sp)
    800025c2:	69a2                	ld	s3,8(sp)
    800025c4:	6a02                	ld	s4,0(sp)
    800025c6:	6145                	addi	sp,sp,48
    800025c8:	8082                	ret
    memmove(dst, (char *)src, len);
    800025ca:	0009061b          	sext.w	a2,s2
    800025ce:	85ce                	mv	a1,s3
    800025d0:	8552                	mv	a0,s4
    800025d2:	f36fe0ef          	jal	80000d08 <memmove>
    return 0;
    800025d6:	8526                	mv	a0,s1
    800025d8:	b7cd                	j	800025ba <either_copyin+0x2c>

00000000800025da <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025da:	711d                	addi	sp,sp,-96
    800025dc:	ec86                	sd	ra,88(sp)
    800025de:	e8a2                	sd	s0,80(sp)
    800025e0:	e4a6                	sd	s1,72(sp)
    800025e2:	e0ca                	sd	s2,64(sp)
    800025e4:	fc4e                	sd	s3,56(sp)
    800025e6:	f852                	sd	s4,48(sp)
    800025e8:	f456                	sd	s5,40(sp)
    800025ea:	f05a                	sd	s6,32(sp)
    800025ec:	ec5e                	sd	s7,24(sp)
    800025ee:	e862                	sd	s8,16(sp)
    800025f0:	e466                	sd	s9,8(sp)
    800025f2:	e06a                	sd	s10,0(sp)
    800025f4:	1080                	addi	s0,sp,96
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    800025f6:	00005517          	auipc	a0,0x5
    800025fa:	a8250513          	addi	a0,a0,-1406 # 80007078 <etext+0x78>
    800025fe:	f0dfd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002602:	00010497          	auipc	s1,0x10
    80002606:	51648493          	addi	s1,s1,1302 # 80012b18 <proc+0x158>
    8000260a:	00016a17          	auipc	s4,0x16
    8000260e:	70ea0a13          	addi	s4,s4,1806 # 80018d18 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002612:	4d15                	li	s10,5
      state = states[p->state];
    else
      state = "???";
    80002614:	00005a97          	auipc	s5,0x5
    80002618:	cf4a8a93          	addi	s5,s5,-780 # 80007308 <etext+0x308>
    printk("%d %s %s", p->pid, state, p->name);
    8000261c:	00005c97          	auipc	s9,0x5
    80002620:	cf4c8c93          	addi	s9,s9,-780 # 80007310 <etext+0x310>
#ifdef SCHEDULER_MLFQ
    printk(" q=%d slice_used=%d/%d enq=%d last_boost=%d",
    80002624:	00008c17          	auipc	s8,0x8
    80002628:	e44c0c13          	addi	s8,s8,-444 # 8000a468 <mlfq_last_boost>
           p->priority, p->ticks_in_slice, mlfq_slice[p->priority],
    8000262c:	00005997          	auipc	s3,0x5
    80002630:	23498993          	addi	s3,s3,564 # 80007860 <mlfq_slice>
    printk(" q=%d slice_used=%d/%d enq=%d last_boost=%d",
    80002634:	00005b97          	auipc	s7,0x5
    80002638:	cecb8b93          	addi	s7,s7,-788 # 80007320 <etext+0x320>
           p->enqueue_time, mlfq_last_boost);
#endif
    printk("\n");
    8000263c:	00005b17          	auipc	s6,0x5
    80002640:	a3cb0b13          	addi	s6,s6,-1476 # 80007078 <etext+0x78>
    80002644:	a82d                	j	8000267e <procdump+0xa4>
    printk("%d %s %s", p->pid, state, p->name);
    80002646:	86ca                	mv	a3,s2
    80002648:	ed892583          	lw	a1,-296(s2)
    8000264c:	8566                	mv	a0,s9
    8000264e:	ebdfd0ef          	jal	8000050a <printk>
    printk(" q=%d slice_used=%d/%d enq=%d last_boost=%d",
    80002652:	02492583          	lw	a1,36(s2)
           p->priority, p->ticks_in_slice, mlfq_slice[p->priority],
    80002656:	00259693          	slli	a3,a1,0x2
    8000265a:	96ce                	add	a3,a3,s3
    printk(" q=%d slice_used=%d/%d enq=%d last_boost=%d",
    8000265c:	000c2783          	lw	a5,0(s8)
    80002660:	02c92703          	lw	a4,44(s2)
    80002664:	4294                	lw	a3,0(a3)
    80002666:	02892603          	lw	a2,40(s2)
    8000266a:	855e                	mv	a0,s7
    8000266c:	e9ffd0ef          	jal	8000050a <printk>
    printk("\n");
    80002670:	855a                	mv	a0,s6
    80002672:	e99fd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002676:	18848493          	addi	s1,s1,392
    8000267a:	03448263          	beq	s1,s4,8000269e <procdump+0xc4>
    if (p->state == UNUSED)
    8000267e:	8926                	mv	s2,s1
    80002680:	ec04a783          	lw	a5,-320(s1)
    80002684:	dbed                	beqz	a5,80002676 <procdump+0x9c>
      state = "???";
    80002686:	8656                	mv	a2,s5
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002688:	fafd6fe3          	bltu	s10,a5,80002646 <procdump+0x6c>
    8000268c:	02079713          	slli	a4,a5,0x20
    80002690:	01d75793          	srli	a5,a4,0x1d
    80002694:	97ce                	add	a5,a5,s3
    80002696:	6b90                	ld	a2,16(a5)
    80002698:	f65d                	bnez	a2,80002646 <procdump+0x6c>
      state = "???";
    8000269a:	8656                	mv	a2,s5
    8000269c:	b76d                	j	80002646 <procdump+0x6c>
  }
}
    8000269e:	60e6                	ld	ra,88(sp)
    800026a0:	6446                	ld	s0,80(sp)
    800026a2:	64a6                	ld	s1,72(sp)
    800026a4:	6906                	ld	s2,64(sp)
    800026a6:	79e2                	ld	s3,56(sp)
    800026a8:	7a42                	ld	s4,48(sp)
    800026aa:	7aa2                	ld	s5,40(sp)
    800026ac:	7b02                	ld	s6,32(sp)
    800026ae:	6be2                	ld	s7,24(sp)
    800026b0:	6c42                	ld	s8,16(sp)
    800026b2:	6ca2                	ld	s9,8(sp)
    800026b4:	6d02                	ld	s10,0(sp)
    800026b6:	6125                	addi	sp,sp,96
    800026b8:	8082                	ret

00000000800026ba <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800026ba:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800026be:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800026c2:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800026c4:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800026c6:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800026ca:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800026ce:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800026d2:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800026d6:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800026da:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800026de:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800026e2:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800026e6:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800026ea:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800026ee:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800026f2:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800026f6:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800026f8:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800026fa:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800026fe:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002702:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002706:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000270a:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000270e:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002712:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002716:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000271a:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000271e:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002722:	8082                	ret

0000000080002724 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002724:	1141                	addi	sp,sp,-16
    80002726:	e406                	sd	ra,8(sp)
    80002728:	e022                	sd	s0,0(sp)
    8000272a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000272c:	00005597          	auipc	a1,0x5
    80002730:	c5458593          	addi	a1,a1,-940 # 80007380 <etext+0x380>
    80002734:	00016517          	auipc	a0,0x16
    80002738:	48c50513          	addi	a0,a0,1164 # 80018bc0 <tickslock>
    8000273c:	c2cfe0ef          	jal	80000b68 <initlock>
}
    80002740:	60a2                	ld	ra,8(sp)
    80002742:	6402                	ld	s0,0(sp)
    80002744:	0141                	addi	sp,sp,16
    80002746:	8082                	ret

0000000080002748 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002748:	1141                	addi	sp,sp,-16
    8000274a:	e406                	sd	ra,8(sp)
    8000274c:	e022                	sd	s0,0(sp)
    8000274e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002750:	00003797          	auipc	a5,0x3
    80002754:	14078793          	addi	a5,a5,320 # 80005890 <kernelvec>
    80002758:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000275c:	60a2                	ld	ra,8(sp)
    8000275e:	6402                	ld	s0,0(sp)
    80002760:	0141                	addi	sp,sp,16
    80002762:	8082                	ret

0000000080002764 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002764:	1141                	addi	sp,sp,-16
    80002766:	e406                	sd	ra,8(sp)
    80002768:	e022                	sd	s0,0(sp)
    8000276a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000276c:	990ff0ef          	jal	800018fc <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002770:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002774:	04000737          	lui	a4,0x4000
    80002778:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000277a:	0732                	slli	a4,a4,0xc
    8000277c:	00004797          	auipc	a5,0x4
    80002780:	88478793          	addi	a5,a5,-1916 # 80006000 <_trampoline>
    80002784:	00004697          	auipc	a3,0x4
    80002788:	87c68693          	addi	a3,a3,-1924 # 80006000 <_trampoline>
    8000278c:	8f95                	sub	a5,a5,a3
    8000278e:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002790:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002794:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002796:	18002773          	csrr	a4,satp
    8000279a:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000279c:	6d38                	ld	a4,88(a0)
    8000279e:	613c                	ld	a5,64(a0)
    800027a0:	6685                	lui	a3,0x1
    800027a2:	97b6                	add	a5,a5,a3
    800027a4:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800027a6:	6d3c                	ld	a5,88(a0)
    800027a8:	00000717          	auipc	a4,0x0
    800027ac:	10470713          	addi	a4,a4,260 # 800028ac <usertrap>
    800027b0:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    800027b2:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800027b4:	8712                	mv	a4,tp
    800027b6:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800027b8:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800027bc:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800027c0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800027c4:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800027c8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800027ca:	6f9c                	ld	a5,24(a5)
    800027cc:	14179073          	csrw	sepc,a5
}
    800027d0:	60a2                	ld	ra,8(sp)
    800027d2:	6402                	ld	s0,0(sp)
    800027d4:	0141                	addi	sp,sp,16
    800027d6:	8082                	ret

00000000800027d8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027d8:	1141                	addi	sp,sp,-16
    800027da:	e406                	sd	ra,8(sp)
    800027dc:	e022                	sd	s0,0(sp)
    800027de:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800027e0:	8e8ff0ef          	jal	800018c8 <cpuid>
    800027e4:	cd11                	beqz	a0,80002800 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    800027e6:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800027ea:	000f4737          	lui	a4,0xf4
    800027ee:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800027f2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    800027f4:	14d79073          	csrw	stimecmp,a5
}
    800027f8:	60a2                	ld	ra,8(sp)
    800027fa:	6402                	ld	s0,0(sp)
    800027fc:	0141                	addi	sp,sp,16
    800027fe:	8082                	ret
    acquire(&tickslock);
    80002800:	00016517          	auipc	a0,0x16
    80002804:	3c050513          	addi	a0,a0,960 # 80018bc0 <tickslock>
    80002808:	be0fe0ef          	jal	80000be8 <acquire>
    ticks++;
    8000280c:	00008717          	auipc	a4,0x8
    80002810:	c6c70713          	addi	a4,a4,-916 # 8000a478 <ticks>
    80002814:	431c                	lw	a5,0(a4)
    80002816:	2785                	addiw	a5,a5,1
    80002818:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    8000281a:	853a                	mv	a0,a4
    8000281c:	999ff0ef          	jal	800021b4 <wakeup>
    release(&tickslock);
    80002820:	00016517          	auipc	a0,0x16
    80002824:	3a050513          	addi	a0,a0,928 # 80018bc0 <tickslock>
    80002828:	c48fe0ef          	jal	80000c70 <release>
    mlfq_boost();
    8000282c:	86bff0ef          	jal	80002096 <mlfq_boost>
    account_waiting_ticks();
    80002830:	811ff0ef          	jal	80002040 <account_waiting_ticks>
    80002834:	bf4d                	j	800027e6 <clockintr+0xe>

0000000080002836 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002836:	1101                	addi	sp,sp,-32
    80002838:	ec06                	sd	ra,24(sp)
    8000283a:	e822                	sd	s0,16(sp)
    8000283c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    8000283e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80002842:	57fd                	li	a5,-1
    80002844:	17fe                	slli	a5,a5,0x3f
    80002846:	07a5                	addi	a5,a5,9
    80002848:	00f70c63          	beq	a4,a5,80002860 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    8000284c:	57fd                	li	a5,-1
    8000284e:	17fe                	slli	a5,a5,0x3f
    80002850:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002852:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    80002854:	04f70863          	beq	a4,a5,800028a4 <devintr+0x6e>
  }
}
    80002858:	60e2                	ld	ra,24(sp)
    8000285a:	6442                	ld	s0,16(sp)
    8000285c:	6105                	addi	sp,sp,32
    8000285e:	8082                	ret
    80002860:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002862:	0da030ef          	jal	8000593c <plic_claim>
    80002866:	872a                	mv	a4,a0
    80002868:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    8000286a:	47a9                	li	a5,10
    8000286c:	00f50963          	beq	a0,a5,8000287e <devintr+0x48>
    } else if (irq == VIRTIO0_IRQ) {
    80002870:	4785                	li	a5,1
    80002872:	00f50963          	beq	a0,a5,80002884 <devintr+0x4e>
    return 1;
    80002876:	4505                	li	a0,1
    } else if (irq) {
    80002878:	eb09                	bnez	a4,8000288a <devintr+0x54>
    8000287a:	64a2                	ld	s1,8(sp)
    8000287c:	bff1                	j	80002858 <devintr+0x22>
      uartintr();
    8000287e:	950fe0ef          	jal	800009ce <uartintr>
    if (irq)
    80002882:	a819                	j	80002898 <devintr+0x62>
      virtio_disk_intr();
    80002884:	570030ef          	jal	80005df4 <virtio_disk_intr>
    if (irq)
    80002888:	a801                	j	80002898 <devintr+0x62>
      printk("unexpected interrupt irq=%d\n", irq);
    8000288a:	85ba                	mv	a1,a4
    8000288c:	00005517          	auipc	a0,0x5
    80002890:	afc50513          	addi	a0,a0,-1284 # 80007388 <etext+0x388>
    80002894:	c77fd0ef          	jal	8000050a <printk>
      plic_complete(irq);
    80002898:	8526                	mv	a0,s1
    8000289a:	0c2030ef          	jal	8000595c <plic_complete>
    return 1;
    8000289e:	4505                	li	a0,1
    800028a0:	64a2                	ld	s1,8(sp)
    800028a2:	bf5d                	j	80002858 <devintr+0x22>
    clockintr();
    800028a4:	f35ff0ef          	jal	800027d8 <clockintr>
    return 2;
    800028a8:	4509                	li	a0,2
    800028aa:	b77d                	j	80002858 <devintr+0x22>

00000000800028ac <usertrap>:
{
    800028ac:	1101                	addi	sp,sp,-32
    800028ae:	ec06                	sd	ra,24(sp)
    800028b0:	e822                	sd	s0,16(sp)
    800028b2:	e426                	sd	s1,8(sp)
    800028b4:	e04a                	sd	s2,0(sp)
    800028b6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800028b8:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    800028bc:	1007f793          	andi	a5,a5,256
    800028c0:	eba5                	bnez	a5,80002930 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    800028c2:	00003797          	auipc	a5,0x3
    800028c6:	fce78793          	addi	a5,a5,-50 # 80005890 <kernelvec>
    800028ca:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028ce:	82eff0ef          	jal	800018fc <myproc>
    800028d2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028d4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800028d6:	14102773          	csrr	a4,sepc
    800028da:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    800028dc:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    800028e0:	47a1                	li	a5,8
    800028e2:	04f70d63          	beq	a4,a5,8000293c <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    800028e6:	f51ff0ef          	jal	80002836 <devintr>
    800028ea:	892a                	mv	s2,a0
    800028ec:	e54d                	bnez	a0,80002996 <usertrap+0xea>
    800028ee:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800028f2:	47bd                	li	a5,15
    800028f4:	08f70463          	beq	a4,a5,8000297c <usertrap+0xd0>
    800028f8:	14202773          	csrr	a4,scause
    800028fc:	47b5                	li	a5,13
    800028fe:	06f70f63          	beq	a4,a5,8000297c <usertrap+0xd0>
    80002902:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002906:	5890                	lw	a2,48(s1)
    80002908:	00005517          	auipc	a0,0x5
    8000290c:	ac050513          	addi	a0,a0,-1344 # 800073c8 <etext+0x3c8>
    80002910:	bfbfd0ef          	jal	8000050a <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002914:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002918:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000291c:	00005517          	auipc	a0,0x5
    80002920:	adc50513          	addi	a0,a0,-1316 # 800073f8 <etext+0x3f8>
    80002924:	be7fd0ef          	jal	8000050a <printk>
    setkilled(p);
    80002928:	8526                	mv	a0,s1
    8000292a:	ac1ff0ef          	jal	800023ea <setkilled>
    8000292e:	a015                	j	80002952 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80002930:	00005517          	auipc	a0,0x5
    80002934:	a7850513          	addi	a0,a0,-1416 # 800073a8 <etext+0x3a8>
    80002938:	efdfd0ef          	jal	80000834 <panic>
    if (killed(p))
    8000293c:	ad3ff0ef          	jal	8000240e <killed>
    80002940:	e915                	bnez	a0,80002974 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002942:	6cb8                	ld	a4,88(s1)
    80002944:	6f1c                	ld	a5,24(a4)
    80002946:	0791                	addi	a5,a5,4
    80002948:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    8000294a:	10016073          	csrsi	sstatus,2
    syscall();
    8000294e:	244000ef          	jal	80002b92 <syscall>
  if (killed(p))
    80002952:	8526                	mv	a0,s1
    80002954:	abbff0ef          	jal	8000240e <killed>
    80002958:	e521                	bnez	a0,800029a0 <usertrap+0xf4>
  prepare_return();
    8000295a:	e0bff0ef          	jal	80002764 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000295e:	68a8                	ld	a0,80(s1)
    80002960:	8131                	srli	a0,a0,0xc
    80002962:	57fd                	li	a5,-1
    80002964:	17fe                	slli	a5,a5,0x3f
    80002966:	8d5d                	or	a0,a0,a5
}
    80002968:	60e2                	ld	ra,24(sp)
    8000296a:	6442                	ld	s0,16(sp)
    8000296c:	64a2                	ld	s1,8(sp)
    8000296e:	6902                	ld	s2,0(sp)
    80002970:	6105                	addi	sp,sp,32
    80002972:	8082                	ret
      kexit(-1);
    80002974:	557d                	li	a0,-1
    80002976:	90fff0ef          	jal	80002284 <kexit>
    8000297a:	b7e1                	j	80002942 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    8000297c:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002980:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80002984:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80002986:	0016b693          	seqz	a3,a3
    8000298a:	64ac                	ld	a1,72(s1)
    8000298c:	68a8                	ld	a0,80(s1)
    8000298e:	b39fe0ef          	jal	800014c6 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002992:	f161                	bnez	a0,80002952 <usertrap+0xa6>
    80002994:	b7bd                	j	80002902 <usertrap+0x56>
  if (killed(p))
    80002996:	8526                	mv	a0,s1
    80002998:	a77ff0ef          	jal	8000240e <killed>
    8000299c:	c511                	beqz	a0,800029a8 <usertrap+0xfc>
    8000299e:	a011                	j	800029a2 <usertrap+0xf6>
    800029a0:	4901                	li	s2,0
    kexit(-1);
    800029a2:	557d                	li	a0,-1
    800029a4:	8e1ff0ef          	jal	80002284 <kexit>
  if (which_dev == 2)
    800029a8:	4789                	li	a5,2
    800029aa:	faf918e3          	bne	s2,a5,8000295a <usertrap+0xae>
    yield();
    800029ae:	dfeff0ef          	jal	80001fac <yield>
    800029b2:	b765                	j	8000295a <usertrap+0xae>

00000000800029b4 <kerneltrap>:
{
    800029b4:	7179                	addi	sp,sp,-48
    800029b6:	f406                	sd	ra,40(sp)
    800029b8:	f022                	sd	s0,32(sp)
    800029ba:	ec26                	sd	s1,24(sp)
    800029bc:	e84a                	sd	s2,16(sp)
    800029be:	e44e                	sd	s3,8(sp)
    800029c0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800029c2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800029c6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800029ca:	142027f3          	csrr	a5,scause
    800029ce:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    800029d0:	1004f793          	andi	a5,s1,256
    800029d4:	c795                	beqz	a5,80002a00 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800029d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029da:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800029dc:	eb85                	bnez	a5,80002a0c <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    800029de:	e59ff0ef          	jal	80002836 <devintr>
    800029e2:	c91d                	beqz	a0,80002a18 <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    800029e4:	4789                	li	a5,2
    800029e6:	04f50a63          	beq	a0,a5,80002a3a <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800029ea:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800029ee:	10049073          	csrw	sstatus,s1
}
    800029f2:	70a2                	ld	ra,40(sp)
    800029f4:	7402                	ld	s0,32(sp)
    800029f6:	64e2                	ld	s1,24(sp)
    800029f8:	6942                	ld	s2,16(sp)
    800029fa:	69a2                	ld	s3,8(sp)
    800029fc:	6145                	addi	sp,sp,48
    800029fe:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a00:	00005517          	auipc	a0,0x5
    80002a04:	a2050513          	addi	a0,a0,-1504 # 80007420 <etext+0x420>
    80002a08:	e2dfd0ef          	jal	80000834 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a0c:	00005517          	auipc	a0,0x5
    80002a10:	a3c50513          	addi	a0,a0,-1476 # 80007448 <etext+0x448>
    80002a14:	e21fd0ef          	jal	80000834 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002a18:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002a1c:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002a20:	85ce                	mv	a1,s3
    80002a22:	00005517          	auipc	a0,0x5
    80002a26:	a4650513          	addi	a0,a0,-1466 # 80007468 <etext+0x468>
    80002a2a:	ae1fd0ef          	jal	8000050a <printk>
    panic("kerneltrap");
    80002a2e:	00005517          	auipc	a0,0x5
    80002a32:	a6250513          	addi	a0,a0,-1438 # 80007490 <etext+0x490>
    80002a36:	dfffd0ef          	jal	80000834 <panic>
  if (which_dev == 2 && myproc() != 0)
    80002a3a:	ec3fe0ef          	jal	800018fc <myproc>
    80002a3e:	d555                	beqz	a0,800029ea <kerneltrap+0x36>
    yield();
    80002a40:	d6cff0ef          	jal	80001fac <yield>
    80002a44:	b75d                	j	800029ea <kerneltrap+0x36>

0000000080002a46 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	1000                	addi	s0,sp,32
    80002a50:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a52:	eabfe0ef          	jal	800018fc <myproc>
  switch (n) {
    80002a56:	4795                	li	a5,5
    80002a58:	0497e163          	bltu	a5,s1,80002a9a <argraw+0x54>
    80002a5c:	048a                	slli	s1,s1,0x2
    80002a5e:	00005717          	auipc	a4,0x5
    80002a62:	e4270713          	addi	a4,a4,-446 # 800078a0 <states.0+0x30>
    80002a66:	94ba                	add	s1,s1,a4
    80002a68:	409c                	lw	a5,0(s1)
    80002a6a:	97ba                	add	a5,a5,a4
    80002a6c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a6e:	6d3c                	ld	a5,88(a0)
    80002a70:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a72:	60e2                	ld	ra,24(sp)
    80002a74:	6442                	ld	s0,16(sp)
    80002a76:	64a2                	ld	s1,8(sp)
    80002a78:	6105                	addi	sp,sp,32
    80002a7a:	8082                	ret
    return p->trapframe->a1;
    80002a7c:	6d3c                	ld	a5,88(a0)
    80002a7e:	7fa8                	ld	a0,120(a5)
    80002a80:	bfcd                	j	80002a72 <argraw+0x2c>
    return p->trapframe->a2;
    80002a82:	6d3c                	ld	a5,88(a0)
    80002a84:	63c8                	ld	a0,128(a5)
    80002a86:	b7f5                	j	80002a72 <argraw+0x2c>
    return p->trapframe->a3;
    80002a88:	6d3c                	ld	a5,88(a0)
    80002a8a:	67c8                	ld	a0,136(a5)
    80002a8c:	b7dd                	j	80002a72 <argraw+0x2c>
    return p->trapframe->a4;
    80002a8e:	6d3c                	ld	a5,88(a0)
    80002a90:	6bc8                	ld	a0,144(a5)
    80002a92:	b7c5                	j	80002a72 <argraw+0x2c>
    return p->trapframe->a5;
    80002a94:	6d3c                	ld	a5,88(a0)
    80002a96:	6fc8                	ld	a0,152(a5)
    80002a98:	bfe9                	j	80002a72 <argraw+0x2c>
  panic("argraw");
    80002a9a:	00005517          	auipc	a0,0x5
    80002a9e:	a0650513          	addi	a0,a0,-1530 # 800074a0 <etext+0x4a0>
    80002aa2:	d93fd0ef          	jal	80000834 <panic>

0000000080002aa6 <fetchaddr>:
{
    80002aa6:	1101                	addi	sp,sp,-32
    80002aa8:	ec06                	sd	ra,24(sp)
    80002aaa:	e822                	sd	s0,16(sp)
    80002aac:	e426                	sd	s1,8(sp)
    80002aae:	e04a                	sd	s2,0(sp)
    80002ab0:	1000                	addi	s0,sp,32
    80002ab2:	84aa                	mv	s1,a0
    80002ab4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ab6:	e47fe0ef          	jal	800018fc <myproc>
  if (addr >= p->sz ||
    80002aba:	652c                	ld	a1,72(a0)
    80002abc:	02b4f663          	bgeu	s1,a1,80002ae8 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002ac0:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    80002ac4:	02f5e463          	bltu	a1,a5,80002aec <fetchaddr+0x46>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ac8:	4721                	li	a4,8
    80002aca:	86a6                	mv	a3,s1
    80002acc:	864a                	mv	a2,s2
    80002ace:	6928                	ld	a0,80(a0)
    80002ad0:	b39fe0ef          	jal	80001608 <copyin>
    80002ad4:	00a03533          	snez	a0,a0
    80002ad8:	40a0053b          	negw	a0,a0
}
    80002adc:	60e2                	ld	ra,24(sp)
    80002ade:	6442                	ld	s0,16(sp)
    80002ae0:	64a2                	ld	s1,8(sp)
    80002ae2:	6902                	ld	s2,0(sp)
    80002ae4:	6105                	addi	sp,sp,32
    80002ae6:	8082                	ret
    return -1;
    80002ae8:	557d                	li	a0,-1
    80002aea:	bfcd                	j	80002adc <fetchaddr+0x36>
    80002aec:	557d                	li	a0,-1
    80002aee:	b7fd                	j	80002adc <fetchaddr+0x36>

0000000080002af0 <fetchstr>:
{
    80002af0:	7179                	addi	sp,sp,-48
    80002af2:	f406                	sd	ra,40(sp)
    80002af4:	f022                	sd	s0,32(sp)
    80002af6:	ec26                	sd	s1,24(sp)
    80002af8:	e84a                	sd	s2,16(sp)
    80002afa:	e44e                	sd	s3,8(sp)
    80002afc:	1800                	addi	s0,sp,48
    80002afe:	89aa                	mv	s3,a0
    80002b00:	84ae                	mv	s1,a1
    80002b02:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002b04:	df9fe0ef          	jal	800018fc <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    80002b08:	874a                	mv	a4,s2
    80002b0a:	86ce                	mv	a3,s3
    80002b0c:	8626                	mv	a2,s1
    80002b0e:	652c                	ld	a1,72(a0)
    80002b10:	6928                	ld	a0,80(a0)
    80002b12:	b93fe0ef          	jal	800016a4 <copyinstr>
    80002b16:	00054c63          	bltz	a0,80002b2e <fetchstr+0x3e>
  return strlen(buf);
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	b16fe0ef          	jal	80000e32 <strlen>
}
    80002b20:	70a2                	ld	ra,40(sp)
    80002b22:	7402                	ld	s0,32(sp)
    80002b24:	64e2                	ld	s1,24(sp)
    80002b26:	6942                	ld	s2,16(sp)
    80002b28:	69a2                	ld	s3,8(sp)
    80002b2a:	6145                	addi	sp,sp,48
    80002b2c:	8082                	ret
    return -1;
    80002b2e:	557d                	li	a0,-1
    80002b30:	bfc5                	j	80002b20 <fetchstr+0x30>

0000000080002b32 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b32:	1101                	addi	sp,sp,-32
    80002b34:	ec06                	sd	ra,24(sp)
    80002b36:	e822                	sd	s0,16(sp)
    80002b38:	e426                	sd	s1,8(sp)
    80002b3a:	1000                	addi	s0,sp,32
    80002b3c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b3e:	f09ff0ef          	jal	80002a46 <argraw>
    80002b42:	c088                	sw	a0,0(s1)
}
    80002b44:	60e2                	ld	ra,24(sp)
    80002b46:	6442                	ld	s0,16(sp)
    80002b48:	64a2                	ld	s1,8(sp)
    80002b4a:	6105                	addi	sp,sp,32
    80002b4c:	8082                	ret

0000000080002b4e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002b4e:	1101                	addi	sp,sp,-32
    80002b50:	ec06                	sd	ra,24(sp)
    80002b52:	e822                	sd	s0,16(sp)
    80002b54:	e426                	sd	s1,8(sp)
    80002b56:	1000                	addi	s0,sp,32
    80002b58:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b5a:	eedff0ef          	jal	80002a46 <argraw>
    80002b5e:	e088                	sd	a0,0(s1)
}
    80002b60:	60e2                	ld	ra,24(sp)
    80002b62:	6442                	ld	s0,16(sp)
    80002b64:	64a2                	ld	s1,8(sp)
    80002b66:	6105                	addi	sp,sp,32
    80002b68:	8082                	ret

0000000080002b6a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b6a:	1101                	addi	sp,sp,-32
    80002b6c:	ec06                	sd	ra,24(sp)
    80002b6e:	e822                	sd	s0,16(sp)
    80002b70:	e426                	sd	s1,8(sp)
    80002b72:	e04a                	sd	s2,0(sp)
    80002b74:	1000                	addi	s0,sp,32
    80002b76:	892e                	mv	s2,a1
    80002b78:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002b7a:	ecdff0ef          	jal	80002a46 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002b7e:	8626                	mv	a2,s1
    80002b80:	85ca                	mv	a1,s2
    80002b82:	f6fff0ef          	jal	80002af0 <fetchstr>
}
    80002b86:	60e2                	ld	ra,24(sp)
    80002b88:	6442                	ld	s0,16(sp)
    80002b8a:	64a2                	ld	s1,8(sp)
    80002b8c:	6902                	ld	s2,0(sp)
    80002b8e:	6105                	addi	sp,sp,32
    80002b90:	8082                	ret

0000000080002b92 <syscall>:
  // clang-format on
};

void
syscall(void)
{
    80002b92:	1101                	addi	sp,sp,-32
    80002b94:	ec06                	sd	ra,24(sp)
    80002b96:	e822                	sd	s0,16(sp)
    80002b98:	e426                	sd	s1,8(sp)
    80002b9a:	e04a                	sd	s2,0(sp)
    80002b9c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b9e:	d5ffe0ef          	jal	800018fc <myproc>
    80002ba2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ba4:	05853903          	ld	s2,88(a0)
    80002ba8:	0a893783          	ld	a5,168(s2)
    80002bac:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002bb0:	37fd                	addiw	a5,a5,-1
    80002bb2:	4755                	li	a4,21
    80002bb4:	00f76f63          	bltu	a4,a5,80002bd2 <syscall+0x40>
    80002bb8:	00369713          	slli	a4,a3,0x3
    80002bbc:	00005797          	auipc	a5,0x5
    80002bc0:	cfc78793          	addi	a5,a5,-772 # 800078b8 <syscalls>
    80002bc4:	97ba                	add	a5,a5,a4
    80002bc6:	639c                	ld	a5,0(a5)
    80002bc8:	c789                	beqz	a5,80002bd2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002bca:	9782                	jalr	a5
    80002bcc:	06a93823          	sd	a0,112(s2)
    80002bd0:	a829                	j	80002bea <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002bd2:	15848613          	addi	a2,s1,344
    80002bd6:	588c                	lw	a1,48(s1)
    80002bd8:	00005517          	auipc	a0,0x5
    80002bdc:	8d050513          	addi	a0,a0,-1840 # 800074a8 <etext+0x4a8>
    80002be0:	92bfd0ef          	jal	8000050a <printk>
    p->trapframe->a0 = -1;
    80002be4:	6cbc                	ld	a5,88(s1)
    80002be6:	577d                	li	a4,-1
    80002be8:	fbb8                	sd	a4,112(a5)
  }
}
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6902                	ld	s2,0(sp)
    80002bf2:	6105                	addi	sp,sp,32
    80002bf4:	8082                	ret

0000000080002bf6 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002bfe:	fec40593          	addi	a1,s0,-20
    80002c02:	4501                	li	a0,0
    80002c04:	f2fff0ef          	jal	80002b32 <argint>
  kexit(n);
    80002c08:	fec42503          	lw	a0,-20(s0)
    80002c0c:	e78ff0ef          	jal	80002284 <kexit>
  return 0; // not reached
}
    80002c10:	4501                	li	a0,0
    80002c12:	60e2                	ld	ra,24(sp)
    80002c14:	6442                	ld	s0,16(sp)
    80002c16:	6105                	addi	sp,sp,32
    80002c18:	8082                	ret

0000000080002c1a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c1a:	1141                	addi	sp,sp,-16
    80002c1c:	e406                	sd	ra,8(sp)
    80002c1e:	e022                	sd	s0,0(sp)
    80002c20:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c22:	cdbfe0ef          	jal	800018fc <myproc>
}
    80002c26:	5908                	lw	a0,48(a0)
    80002c28:	60a2                	ld	ra,8(sp)
    80002c2a:	6402                	ld	s0,0(sp)
    80002c2c:	0141                	addi	sp,sp,16
    80002c2e:	8082                	ret

0000000080002c30 <sys_fork>:

uint64
sys_fork(void)
{
    80002c30:	1141                	addi	sp,sp,-16
    80002c32:	e406                	sd	ra,8(sp)
    80002c34:	e022                	sd	s0,0(sp)
    80002c36:	0800                	addi	s0,sp,16
  return kfork();
    80002c38:	874ff0ef          	jal	80001cac <kfork>
}
    80002c3c:	60a2                	ld	ra,8(sp)
    80002c3e:	6402                	ld	s0,0(sp)
    80002c40:	0141                	addi	sp,sp,16
    80002c42:	8082                	ret

0000000080002c44 <sys_wait>:

uint64
sys_wait(void)
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002c4c:	fe840593          	addi	a1,s0,-24
    80002c50:	4501                	li	a0,0
    80002c52:	efdff0ef          	jal	80002b4e <argaddr>
  return kwait(p);
    80002c56:	fe843503          	ld	a0,-24(s0)
    80002c5a:	fdeff0ef          	jal	80002438 <kwait>
}
    80002c5e:	60e2                	ld	ra,24(sp)
    80002c60:	6442                	ld	s0,16(sp)
    80002c62:	6105                	addi	sp,sp,32
    80002c64:	8082                	ret

0000000080002c66 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c66:	7179                	addi	sp,sp,-48
    80002c68:	f406                	sd	ra,40(sp)
    80002c6a:	f022                	sd	s0,32(sp)
    80002c6c:	ec26                	sd	s1,24(sp)
    80002c6e:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002c70:	fd840593          	addi	a1,s0,-40
    80002c74:	4501                	li	a0,0
    80002c76:	ebdff0ef          	jal	80002b32 <argint>
  argint(1, &t);
    80002c7a:	fdc40593          	addi	a1,s0,-36
    80002c7e:	4505                	li	a0,1
    80002c80:	eb3ff0ef          	jal	80002b32 <argint>
  addr = myproc()->sz;
    80002c84:	c79fe0ef          	jal	800018fc <myproc>
    80002c88:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002c8a:	fdc42703          	lw	a4,-36(s0)
    80002c8e:	4785                	li	a5,1
    80002c90:	02f70763          	beq	a4,a5,80002cbe <sys_sbrk+0x58>
    80002c94:	fd842783          	lw	a5,-40(s0)
    80002c98:	0207c363          	bltz	a5,80002cbe <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80002c9c:	97a6                	add	a5,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    80002c9e:	02000737          	lui	a4,0x2000
    80002ca2:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002ca4:	0736                	slli	a4,a4,0xd
    80002ca6:	02f76a63          	bltu	a4,a5,80002cda <sys_sbrk+0x74>
    80002caa:	0297e863          	bltu	a5,s1,80002cda <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    80002cae:	c4ffe0ef          	jal	800018fc <myproc>
    80002cb2:	fd842703          	lw	a4,-40(s0)
    80002cb6:	653c                	ld	a5,72(a0)
    80002cb8:	97ba                	add	a5,a5,a4
    80002cba:	e53c                	sd	a5,72(a0)
    80002cbc:	a039                	j	80002cca <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    80002cbe:	fd842503          	lw	a0,-40(s0)
    80002cc2:	f89fe0ef          	jal	80001c4a <growproc>
    80002cc6:	00054863          	bltz	a0,80002cd6 <sys_sbrk+0x70>
  }
  return addr;
}
    80002cca:	8526                	mv	a0,s1
    80002ccc:	70a2                	ld	ra,40(sp)
    80002cce:	7402                	ld	s0,32(sp)
    80002cd0:	64e2                	ld	s1,24(sp)
    80002cd2:	6145                	addi	sp,sp,48
    80002cd4:	8082                	ret
      return -1;
    80002cd6:	54fd                	li	s1,-1
    80002cd8:	bfcd                	j	80002cca <sys_sbrk+0x64>
      return -1;
    80002cda:	54fd                	li	s1,-1
    80002cdc:	b7fd                	j	80002cca <sys_sbrk+0x64>

0000000080002cde <sys_pause>:

uint64
sys_pause(void)
{
    80002cde:	7139                	addi	sp,sp,-64
    80002ce0:	fc06                	sd	ra,56(sp)
    80002ce2:	f822                	sd	s0,48(sp)
    80002ce4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ce6:	fcc40593          	addi	a1,s0,-52
    80002cea:	4501                	li	a0,0
    80002cec:	e47ff0ef          	jal	80002b32 <argint>
  if (n < 0)
    80002cf0:	fcc42783          	lw	a5,-52(s0)
    80002cf4:	0807c063          	bltz	a5,80002d74 <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002cf8:	00016517          	auipc	a0,0x16
    80002cfc:	ec850513          	addi	a0,a0,-312 # 80018bc0 <tickslock>
    80002d00:	ee9fd0ef          	jal	80000be8 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002d04:	fcc42783          	lw	a5,-52(s0)
    80002d08:	cbb9                	beqz	a5,80002d5e <sys_pause+0x80>
    80002d0a:	f426                	sd	s1,40(sp)
    80002d0c:	f04a                	sd	s2,32(sp)
    80002d0e:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002d10:	00007997          	auipc	s3,0x7
    80002d14:	7689a983          	lw	s3,1896(s3) # 8000a478 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002d18:	00007917          	auipc	s2,0x7
    80002d1c:	76090913          	addi	s2,s2,1888 # 8000a478 <ticks>
    release(&tickslock);
    80002d20:	00016497          	auipc	s1,0x16
    80002d24:	ea048493          	addi	s1,s1,-352 # 80018bc0 <tickslock>
    if (killed(myproc())) {
    80002d28:	bd5fe0ef          	jal	800018fc <myproc>
    80002d2c:	ee2ff0ef          	jal	8000240e <killed>
    80002d30:	e529                	bnez	a0,80002d7a <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002d32:	854a                	mv	a0,s2
    80002d34:	bfcff0ef          	jal	80002130 <sleep_prepare>
    release(&tickslock);
    80002d38:	8526                	mv	a0,s1
    80002d3a:	f37fd0ef          	jal	80000c70 <release>
    sleep();
    80002d3e:	c2eff0ef          	jal	8000216c <sleep>
    acquire(&tickslock);
    80002d42:	8526                	mv	a0,s1
    80002d44:	ea5fd0ef          	jal	80000be8 <acquire>
  while (ticks - ticks0 < n) {
    80002d48:	00092783          	lw	a5,0(s2)
    80002d4c:	413787bb          	subw	a5,a5,s3
    80002d50:	fcc42703          	lw	a4,-52(s0)
    80002d54:	fce7eae3          	bltu	a5,a4,80002d28 <sys_pause+0x4a>
    80002d58:	74a2                	ld	s1,40(sp)
    80002d5a:	7902                	ld	s2,32(sp)
    80002d5c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002d5e:	00016517          	auipc	a0,0x16
    80002d62:	e6250513          	addi	a0,a0,-414 # 80018bc0 <tickslock>
    80002d66:	f0bfd0ef          	jal	80000c70 <release>
  return 0;
    80002d6a:	4501                	li	a0,0
}
    80002d6c:	70e2                	ld	ra,56(sp)
    80002d6e:	7442                	ld	s0,48(sp)
    80002d70:	6121                	addi	sp,sp,64
    80002d72:	8082                	ret
    n = 0;
    80002d74:	fc042623          	sw	zero,-52(s0)
    80002d78:	b741                	j	80002cf8 <sys_pause+0x1a>
      release(&tickslock);
    80002d7a:	00016517          	auipc	a0,0x16
    80002d7e:	e4650513          	addi	a0,a0,-442 # 80018bc0 <tickslock>
    80002d82:	eeffd0ef          	jal	80000c70 <release>
      return -1;
    80002d86:	557d                	li	a0,-1
    80002d88:	74a2                	ld	s1,40(sp)
    80002d8a:	7902                	ld	s2,32(sp)
    80002d8c:	69e2                	ld	s3,24(sp)
    80002d8e:	bff9                	j	80002d6c <sys_pause+0x8e>

0000000080002d90 <sys_kill>:

uint64
sys_kill(void)
{
    80002d90:	1101                	addi	sp,sp,-32
    80002d92:	ec06                	sd	ra,24(sp)
    80002d94:	e822                	sd	s0,16(sp)
    80002d96:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002d98:	fec40593          	addi	a1,s0,-20
    80002d9c:	4501                	li	a0,0
    80002d9e:	d95ff0ef          	jal	80002b32 <argint>
  return kkill(pid);
    80002da2:	fec42503          	lw	a0,-20(s0)
    80002da6:	dd2ff0ef          	jal	80002378 <kkill>
}
    80002daa:	60e2                	ld	ra,24(sp)
    80002dac:	6442                	ld	s0,16(sp)
    80002dae:	6105                	addi	sp,sp,32
    80002db0:	8082                	ret

0000000080002db2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002db2:	1101                	addi	sp,sp,-32
    80002db4:	ec06                	sd	ra,24(sp)
    80002db6:	e822                	sd	s0,16(sp)
    80002db8:	e426                	sd	s1,8(sp)
    80002dba:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dbc:	00016517          	auipc	a0,0x16
    80002dc0:	e0450513          	addi	a0,a0,-508 # 80018bc0 <tickslock>
    80002dc4:	e25fd0ef          	jal	80000be8 <acquire>
  xticks = ticks;
    80002dc8:	00007797          	auipc	a5,0x7
    80002dcc:	6b07a783          	lw	a5,1712(a5) # 8000a478 <ticks>
    80002dd0:	84be                	mv	s1,a5
  release(&tickslock);
    80002dd2:	00016517          	auipc	a0,0x16
    80002dd6:	dee50513          	addi	a0,a0,-530 # 80018bc0 <tickslock>
    80002dda:	e97fd0ef          	jal	80000c70 <release>
  return xticks;
}
    80002dde:	02049513          	slli	a0,s1,0x20
    80002de2:	9101                	srli	a0,a0,0x20
    80002de4:	60e2                	ld	ra,24(sp)
    80002de6:	6442                	ld	s0,16(sp)
    80002de8:	64a2                	ld	s1,8(sp)
    80002dea:	6105                	addi	sp,sp,32
    80002dec:	8082                	ret

0000000080002dee <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002dee:	7179                	addi	sp,sp,-48
    80002df0:	f406                	sd	ra,40(sp)
    80002df2:	f022                	sd	s0,32(sp)
    80002df4:	ec26                	sd	s1,24(sp)
    80002df6:	e84a                	sd	s2,16(sp)
    80002df8:	e44e                	sd	s3,8(sp)
    80002dfa:	e052                	sd	s4,0(sp)
    80002dfc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002dfe:	00004597          	auipc	a1,0x4
    80002e02:	6ca58593          	addi	a1,a1,1738 # 800074c8 <etext+0x4c8>
    80002e06:	00016517          	auipc	a0,0x16
    80002e0a:	dd250513          	addi	a0,a0,-558 # 80018bd8 <bcache>
    80002e0e:	d5bfd0ef          	jal	80000b68 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e12:	0001e797          	auipc	a5,0x1e
    80002e16:	dc678793          	addi	a5,a5,-570 # 80020bd8 <bcache+0x8000>
    80002e1a:	0001e717          	auipc	a4,0x1e
    80002e1e:	02670713          	addi	a4,a4,38 # 80020e40 <bcache+0x8268>
    80002e22:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e26:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002e2a:	00016497          	auipc	s1,0x16
    80002e2e:	dc648493          	addi	s1,s1,-570 # 80018bf0 <bcache+0x18>
    b->next = bcache.head.next;
    80002e32:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e34:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e36:	00004a17          	auipc	s4,0x4
    80002e3a:	69aa0a13          	addi	s4,s4,1690 # 800074d0 <etext+0x4d0>
    b->next = bcache.head.next;
    80002e3e:	2b893783          	ld	a5,696(s2)
    80002e42:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e44:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e48:	85d2                	mv	a1,s4
    80002e4a:	01048513          	addi	a0,s1,16
    80002e4e:	40e010ef          	jal	8000425c <initsleeplock>
    bcache.head.next->prev = b;
    80002e52:	2b893783          	ld	a5,696(s2)
    80002e56:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002e58:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002e5c:	45848493          	addi	s1,s1,1112
    80002e60:	fd349fe3          	bne	s1,s3,80002e3e <binit+0x50>
  }
}
    80002e64:	70a2                	ld	ra,40(sp)
    80002e66:	7402                	ld	s0,32(sp)
    80002e68:	64e2                	ld	s1,24(sp)
    80002e6a:	6942                	ld	s2,16(sp)
    80002e6c:	69a2                	ld	s3,8(sp)
    80002e6e:	6a02                	ld	s4,0(sp)
    80002e70:	6145                	addi	sp,sp,48
    80002e72:	8082                	ret

0000000080002e74 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002e74:	7179                	addi	sp,sp,-48
    80002e76:	f406                	sd	ra,40(sp)
    80002e78:	f022                	sd	s0,32(sp)
    80002e7a:	ec26                	sd	s1,24(sp)
    80002e7c:	e84a                	sd	s2,16(sp)
    80002e7e:	e44e                	sd	s3,8(sp)
    80002e80:	1800                	addi	s0,sp,48
    80002e82:	892a                	mv	s2,a0
    80002e84:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e86:	00016517          	auipc	a0,0x16
    80002e8a:	d5250513          	addi	a0,a0,-686 # 80018bd8 <bcache>
    80002e8e:	d5bfd0ef          	jal	80000be8 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002e92:	0001e497          	auipc	s1,0x1e
    80002e96:	ffe4b483          	ld	s1,-2(s1) # 80020e90 <bcache+0x82b8>
    80002e9a:	0001e797          	auipc	a5,0x1e
    80002e9e:	fa678793          	addi	a5,a5,-90 # 80020e40 <bcache+0x8268>
    80002ea2:	02f48b63          	beq	s1,a5,80002ed8 <bread+0x64>
    80002ea6:	873e                	mv	a4,a5
    80002ea8:	a021                	j	80002eb0 <bread+0x3c>
    80002eaa:	68a4                	ld	s1,80(s1)
    80002eac:	02e48663          	beq	s1,a4,80002ed8 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002eb0:	449c                	lw	a5,8(s1)
    80002eb2:	ff279ce3          	bne	a5,s2,80002eaa <bread+0x36>
    80002eb6:	44dc                	lw	a5,12(s1)
    80002eb8:	ff3799e3          	bne	a5,s3,80002eaa <bread+0x36>
      b->refcnt++;
    80002ebc:	40bc                	lw	a5,64(s1)
    80002ebe:	2785                	addiw	a5,a5,1
    80002ec0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ec2:	00016517          	auipc	a0,0x16
    80002ec6:	d1650513          	addi	a0,a0,-746 # 80018bd8 <bcache>
    80002eca:	da7fd0ef          	jal	80000c70 <release>
      acquiresleep(&b->lock);
    80002ece:	01048513          	addi	a0,s1,16
    80002ed2:	3c0010ef          	jal	80004292 <acquiresleep>
      return b;
    80002ed6:	a889                	j	80002f28 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002ed8:	0001e497          	auipc	s1,0x1e
    80002edc:	fb04b483          	ld	s1,-80(s1) # 80020e88 <bcache+0x82b0>
    80002ee0:	0001e797          	auipc	a5,0x1e
    80002ee4:	f6078793          	addi	a5,a5,-160 # 80020e40 <bcache+0x8268>
    80002ee8:	00f48863          	beq	s1,a5,80002ef8 <bread+0x84>
    80002eec:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002eee:	40bc                	lw	a5,64(s1)
    80002ef0:	cb91                	beqz	a5,80002f04 <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002ef2:	64a4                	ld	s1,72(s1)
    80002ef4:	fee49de3          	bne	s1,a4,80002eee <bread+0x7a>
  panic("bget: no buffers");
    80002ef8:	00004517          	auipc	a0,0x4
    80002efc:	5e050513          	addi	a0,a0,1504 # 800074d8 <etext+0x4d8>
    80002f00:	935fd0ef          	jal	80000834 <panic>
      b->dev = dev;
    80002f04:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f08:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f0c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f10:	4785                	li	a5,1
    80002f12:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f14:	00016517          	auipc	a0,0x16
    80002f18:	cc450513          	addi	a0,a0,-828 # 80018bd8 <bcache>
    80002f1c:	d55fd0ef          	jal	80000c70 <release>
      acquiresleep(&b->lock);
    80002f20:	01048513          	addi	a0,s1,16
    80002f24:	36e010ef          	jal	80004292 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002f28:	409c                	lw	a5,0(s1)
    80002f2a:	cb89                	beqz	a5,80002f3c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f2c:	8526                	mv	a0,s1
    80002f2e:	70a2                	ld	ra,40(sp)
    80002f30:	7402                	ld	s0,32(sp)
    80002f32:	64e2                	ld	s1,24(sp)
    80002f34:	6942                	ld	s2,16(sp)
    80002f36:	69a2                	ld	s3,8(sp)
    80002f38:	6145                	addi	sp,sp,48
    80002f3a:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f3c:	4581                	li	a1,0
    80002f3e:	8526                	mv	a0,s1
    80002f40:	481020ef          	jal	80005bc0 <virtio_disk_rw>
    b->valid = 1;
    80002f44:	4785                	li	a5,1
    80002f46:	c09c                	sw	a5,0(s1)
  return b;
    80002f48:	b7d5                	j	80002f2c <bread+0xb8>

0000000080002f4a <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002f4a:	1101                	addi	sp,sp,-32
    80002f4c:	ec06                	sd	ra,24(sp)
    80002f4e:	e822                	sd	s0,16(sp)
    80002f50:	e426                	sd	s1,8(sp)
    80002f52:	1000                	addi	s0,sp,32
    80002f54:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002f56:	0541                	addi	a0,a0,16
    80002f58:	3c6010ef          	jal	8000431e <holdingsleep>
    80002f5c:	c911                	beqz	a0,80002f70 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f5e:	4585                	li	a1,1
    80002f60:	8526                	mv	a0,s1
    80002f62:	45f020ef          	jal	80005bc0 <virtio_disk_rw>
}
    80002f66:	60e2                	ld	ra,24(sp)
    80002f68:	6442                	ld	s0,16(sp)
    80002f6a:	64a2                	ld	s1,8(sp)
    80002f6c:	6105                	addi	sp,sp,32
    80002f6e:	8082                	ret
    panic("bwrite");
    80002f70:	00004517          	auipc	a0,0x4
    80002f74:	58050513          	addi	a0,a0,1408 # 800074f0 <etext+0x4f0>
    80002f78:	8bdfd0ef          	jal	80000834 <panic>

0000000080002f7c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f7c:	1101                	addi	sp,sp,-32
    80002f7e:	ec06                	sd	ra,24(sp)
    80002f80:	e822                	sd	s0,16(sp)
    80002f82:	e426                	sd	s1,8(sp)
    80002f84:	e04a                	sd	s2,0(sp)
    80002f86:	1000                	addi	s0,sp,32
    80002f88:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002f8a:	01050913          	addi	s2,a0,16
    80002f8e:	854a                	mv	a0,s2
    80002f90:	38e010ef          	jal	8000431e <holdingsleep>
    80002f94:	c125                	beqz	a0,80002ff4 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002f96:	854a                	mv	a0,s2
    80002f98:	34e010ef          	jal	800042e6 <releasesleep>

  acquire(&bcache.lock);
    80002f9c:	00016517          	auipc	a0,0x16
    80002fa0:	c3c50513          	addi	a0,a0,-964 # 80018bd8 <bcache>
    80002fa4:	c45fd0ef          	jal	80000be8 <acquire>
  b->refcnt--;
    80002fa8:	40bc                	lw	a5,64(s1)
    80002faa:	37fd                	addiw	a5,a5,-1
    80002fac:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002fae:	e79d                	bnez	a5,80002fdc <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002fb0:	68b8                	ld	a4,80(s1)
    80002fb2:	64bc                	ld	a5,72(s1)
    80002fb4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002fb6:	68b8                	ld	a4,80(s1)
    80002fb8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002fba:	0001e797          	auipc	a5,0x1e
    80002fbe:	c1e78793          	addi	a5,a5,-994 # 80020bd8 <bcache+0x8000>
    80002fc2:	2b87b703          	ld	a4,696(a5)
    80002fc6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002fc8:	0001e717          	auipc	a4,0x1e
    80002fcc:	e7870713          	addi	a4,a4,-392 # 80020e40 <bcache+0x8268>
    80002fd0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002fd2:	2b87b703          	ld	a4,696(a5)
    80002fd6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002fd8:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002fdc:	00016517          	auipc	a0,0x16
    80002fe0:	bfc50513          	addi	a0,a0,-1028 # 80018bd8 <bcache>
    80002fe4:	c8dfd0ef          	jal	80000c70 <release>
}
    80002fe8:	60e2                	ld	ra,24(sp)
    80002fea:	6442                	ld	s0,16(sp)
    80002fec:	64a2                	ld	s1,8(sp)
    80002fee:	6902                	ld	s2,0(sp)
    80002ff0:	6105                	addi	sp,sp,32
    80002ff2:	8082                	ret
    panic("brelse");
    80002ff4:	00004517          	auipc	a0,0x4
    80002ff8:	50450513          	addi	a0,a0,1284 # 800074f8 <etext+0x4f8>
    80002ffc:	839fd0ef          	jal	80000834 <panic>

0000000080003000 <bpin>:

void
bpin(struct buf *b)
{
    80003000:	1101                	addi	sp,sp,-32
    80003002:	ec06                	sd	ra,24(sp)
    80003004:	e822                	sd	s0,16(sp)
    80003006:	e426                	sd	s1,8(sp)
    80003008:	1000                	addi	s0,sp,32
    8000300a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000300c:	00016517          	auipc	a0,0x16
    80003010:	bcc50513          	addi	a0,a0,-1076 # 80018bd8 <bcache>
    80003014:	bd5fd0ef          	jal	80000be8 <acquire>
  b->refcnt++;
    80003018:	40bc                	lw	a5,64(s1)
    8000301a:	2785                	addiw	a5,a5,1
    8000301c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000301e:	00016517          	auipc	a0,0x16
    80003022:	bba50513          	addi	a0,a0,-1094 # 80018bd8 <bcache>
    80003026:	c4bfd0ef          	jal	80000c70 <release>
}
    8000302a:	60e2                	ld	ra,24(sp)
    8000302c:	6442                	ld	s0,16(sp)
    8000302e:	64a2                	ld	s1,8(sp)
    80003030:	6105                	addi	sp,sp,32
    80003032:	8082                	ret

0000000080003034 <bunpin>:

void
bunpin(struct buf *b)
{
    80003034:	1101                	addi	sp,sp,-32
    80003036:	ec06                	sd	ra,24(sp)
    80003038:	e822                	sd	s0,16(sp)
    8000303a:	e426                	sd	s1,8(sp)
    8000303c:	1000                	addi	s0,sp,32
    8000303e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003040:	00016517          	auipc	a0,0x16
    80003044:	b9850513          	addi	a0,a0,-1128 # 80018bd8 <bcache>
    80003048:	ba1fd0ef          	jal	80000be8 <acquire>
  b->refcnt--;
    8000304c:	40bc                	lw	a5,64(s1)
    8000304e:	37fd                	addiw	a5,a5,-1
    80003050:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003052:	00016517          	auipc	a0,0x16
    80003056:	b8650513          	addi	a0,a0,-1146 # 80018bd8 <bcache>
    8000305a:	c17fd0ef          	jal	80000c70 <release>
}
    8000305e:	60e2                	ld	ra,24(sp)
    80003060:	6442                	ld	s0,16(sp)
    80003062:	64a2                	ld	s1,8(sp)
    80003064:	6105                	addi	sp,sp,32
    80003066:	8082                	ret

0000000080003068 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003068:	1101                	addi	sp,sp,-32
    8000306a:	ec06                	sd	ra,24(sp)
    8000306c:	e822                	sd	s0,16(sp)
    8000306e:	e426                	sd	s1,8(sp)
    80003070:	e04a                	sd	s2,0(sp)
    80003072:	1000                	addi	s0,sp,32
    80003074:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003076:	00d5d79b          	srliw	a5,a1,0xd
    8000307a:	0001e597          	auipc	a1,0x1e
    8000307e:	23a5a583          	lw	a1,570(a1) # 800212b4 <sb+0x1c>
    80003082:	9dbd                	addw	a1,a1,a5
    80003084:	df1ff0ef          	jal	80002e74 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003088:	0074f713          	andi	a4,s1,7
    8000308c:	4785                	li	a5,1
    8000308e:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003092:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80003094:	90d9                	srli	s1,s1,0x36
    80003096:	00950733          	add	a4,a0,s1
    8000309a:	05874703          	lbu	a4,88(a4)
    8000309e:	00e7f6b3          	and	a3,a5,a4
    800030a2:	c29d                	beqz	a3,800030c8 <bfree+0x60>
    800030a4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    800030a6:	94aa                	add	s1,s1,a0
    800030a8:	fff7c793          	not	a5,a5
    800030ac:	8f7d                	and	a4,a4,a5
    800030ae:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800030b2:	072010ef          	jal	80004124 <log_write>
  brelse(bp);
    800030b6:	854a                	mv	a0,s2
    800030b8:	ec5ff0ef          	jal	80002f7c <brelse>
}
    800030bc:	60e2                	ld	ra,24(sp)
    800030be:	6442                	ld	s0,16(sp)
    800030c0:	64a2                	ld	s1,8(sp)
    800030c2:	6902                	ld	s2,0(sp)
    800030c4:	6105                	addi	sp,sp,32
    800030c6:	8082                	ret
    panic("freeing free block");
    800030c8:	00004517          	auipc	a0,0x4
    800030cc:	43850513          	addi	a0,a0,1080 # 80007500 <etext+0x500>
    800030d0:	f64fd0ef          	jal	80000834 <panic>

00000000800030d4 <balloc>:
{
    800030d4:	715d                	addi	sp,sp,-80
    800030d6:	e486                	sd	ra,72(sp)
    800030d8:	e0a2                	sd	s0,64(sp)
    800030da:	fc26                	sd	s1,56(sp)
    800030dc:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    800030de:	0001e797          	auipc	a5,0x1e
    800030e2:	1be7a783          	lw	a5,446(a5) # 8002129c <sb+0x4>
    800030e6:	0e078263          	beqz	a5,800031ca <balloc+0xf6>
    800030ea:	f84a                	sd	s2,48(sp)
    800030ec:	f44e                	sd	s3,40(sp)
    800030ee:	f052                	sd	s4,32(sp)
    800030f0:	ec56                	sd	s5,24(sp)
    800030f2:	e85a                	sd	s6,16(sp)
    800030f4:	e45e                	sd	s7,8(sp)
    800030f6:	e062                	sd	s8,0(sp)
    800030f8:	8baa                	mv	s7,a0
    800030fa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030fc:	0001eb17          	auipc	s6,0x1e
    80003100:	19cb0b13          	addi	s6,s6,412 # 80021298 <sb>
      m = 1 << (bi % 8);
    80003104:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003106:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80003108:	6c09                	lui	s8,0x2
    8000310a:	a09d                	j	80003170 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    8000310c:	97ca                	add	a5,a5,s2
    8000310e:	8e55                	or	a2,a2,a3
    80003110:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003114:	854a                	mv	a0,s2
    80003116:	00e010ef          	jal	80004124 <log_write>
        brelse(bp);
    8000311a:	854a                	mv	a0,s2
    8000311c:	e61ff0ef          	jal	80002f7c <brelse>
  bp = bread(dev, bno);
    80003120:	85a6                	mv	a1,s1
    80003122:	855e                	mv	a0,s7
    80003124:	d51ff0ef          	jal	80002e74 <bread>
    80003128:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000312a:	40000613          	li	a2,1024
    8000312e:	4581                	li	a1,0
    80003130:	05850513          	addi	a0,a0,88
    80003134:	b75fd0ef          	jal	80000ca8 <memset>
  log_write(bp);
    80003138:	854a                	mv	a0,s2
    8000313a:	7eb000ef          	jal	80004124 <log_write>
  brelse(bp);
    8000313e:	854a                	mv	a0,s2
    80003140:	e3dff0ef          	jal	80002f7c <brelse>
}
    80003144:	7942                	ld	s2,48(sp)
    80003146:	79a2                	ld	s3,40(sp)
    80003148:	7a02                	ld	s4,32(sp)
    8000314a:	6ae2                	ld	s5,24(sp)
    8000314c:	6b42                	ld	s6,16(sp)
    8000314e:	6ba2                	ld	s7,8(sp)
    80003150:	6c02                	ld	s8,0(sp)
}
    80003152:	8526                	mv	a0,s1
    80003154:	60a6                	ld	ra,72(sp)
    80003156:	6406                	ld	s0,64(sp)
    80003158:	74e2                	ld	s1,56(sp)
    8000315a:	6161                	addi	sp,sp,80
    8000315c:	8082                	ret
    brelse(bp);
    8000315e:	854a                	mv	a0,s2
    80003160:	e1dff0ef          	jal	80002f7c <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80003164:	015c0abb          	addw	s5,s8,s5
    80003168:	004b2783          	lw	a5,4(s6)
    8000316c:	04faf863          	bgeu	s5,a5,800031bc <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80003170:	40dad59b          	sraiw	a1,s5,0xd
    80003174:	01cb2783          	lw	a5,28(s6)
    80003178:	9dbd                	addw	a1,a1,a5
    8000317a:	855e                	mv	a0,s7
    8000317c:	cf9ff0ef          	jal	80002e74 <bread>
    80003180:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003182:	004b2503          	lw	a0,4(s6)
    80003186:	84d6                	mv	s1,s5
    80003188:	4701                	li	a4,0
    8000318a:	fca4fae3          	bgeu	s1,a0,8000315e <balloc+0x8a>
      m = 1 << (bi % 8);
    8000318e:	00777693          	andi	a3,a4,7
    80003192:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80003196:	41f7579b          	sraiw	a5,a4,0x1f
    8000319a:	01d7d79b          	srliw	a5,a5,0x1d
    8000319e:	9fb9                	addw	a5,a5,a4
    800031a0:	4037d79b          	sraiw	a5,a5,0x3
    800031a4:	00f90633          	add	a2,s2,a5
    800031a8:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800031ac:	00c6f5b3          	and	a1,a3,a2
    800031b0:	ddb1                	beqz	a1,8000310c <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800031b2:	2705                	addiw	a4,a4,1
    800031b4:	2485                	addiw	s1,s1,1
    800031b6:	fd471ae3          	bne	a4,s4,8000318a <balloc+0xb6>
    800031ba:	b755                	j	8000315e <balloc+0x8a>
    800031bc:	7942                	ld	s2,48(sp)
    800031be:	79a2                	ld	s3,40(sp)
    800031c0:	7a02                	ld	s4,32(sp)
    800031c2:	6ae2                	ld	s5,24(sp)
    800031c4:	6b42                	ld	s6,16(sp)
    800031c6:	6ba2                	ld	s7,8(sp)
    800031c8:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    800031ca:	00004517          	auipc	a0,0x4
    800031ce:	34e50513          	addi	a0,a0,846 # 80007518 <etext+0x518>
    800031d2:	b38fd0ef          	jal	8000050a <printk>
  return 0;
    800031d6:	4481                	li	s1,0
    800031d8:	bfad                	j	80003152 <balloc+0x7e>

00000000800031da <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800031da:	7179                	addi	sp,sp,-48
    800031dc:	f406                	sd	ra,40(sp)
    800031de:	f022                	sd	s0,32(sp)
    800031e0:	ec26                	sd	s1,24(sp)
    800031e2:	e84a                	sd	s2,16(sp)
    800031e4:	e44e                	sd	s3,8(sp)
    800031e6:	1800                	addi	s0,sp,48
    800031e8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    800031ea:	47ad                	li	a5,11
    800031ec:	02b7e363          	bltu	a5,a1,80003212 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    800031f0:	02059793          	slli	a5,a1,0x20
    800031f4:	01e7d593          	srli	a1,a5,0x1e
    800031f8:	00b509b3          	add	s3,a0,a1
    800031fc:	0509a483          	lw	s1,80(s3)
    80003200:	e0b5                	bnez	s1,80003264 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003202:	4108                	lw	a0,0(a0)
    80003204:	ed1ff0ef          	jal	800030d4 <balloc>
    80003208:	84aa                	mv	s1,a0
      if (addr == 0)
    8000320a:	cd29                	beqz	a0,80003264 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    8000320c:	04a9a823          	sw	a0,80(s3)
    80003210:	a891                	j	80003264 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003212:	ff45879b          	addiw	a5,a1,-12
    80003216:	873e                	mv	a4,a5
    80003218:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    8000321a:	0ff00793          	li	a5,255
    8000321e:	06e7e763          	bltu	a5,a4,8000328c <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80003222:	08052483          	lw	s1,128(a0)
    80003226:	e891                	bnez	s1,8000323a <bmap+0x60>
      addr = balloc(ip->dev);
    80003228:	4108                	lw	a0,0(a0)
    8000322a:	eabff0ef          	jal	800030d4 <balloc>
    8000322e:	84aa                	mv	s1,a0
      if (addr == 0)
    80003230:	c915                	beqz	a0,80003264 <bmap+0x8a>
    80003232:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003234:	08a92023          	sw	a0,128(s2)
    80003238:	a011                	j	8000323c <bmap+0x62>
    8000323a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000323c:	85a6                	mv	a1,s1
    8000323e:	00092503          	lw	a0,0(s2)
    80003242:	c33ff0ef          	jal	80002e74 <bread>
    80003246:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80003248:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    8000324c:	02099713          	slli	a4,s3,0x20
    80003250:	01e75593          	srli	a1,a4,0x1e
    80003254:	97ae                	add	a5,a5,a1
    80003256:	89be                	mv	s3,a5
    80003258:	4384                	lw	s1,0(a5)
    8000325a:	cc89                	beqz	s1,80003274 <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000325c:	8552                	mv	a0,s4
    8000325e:	d1fff0ef          	jal	80002f7c <brelse>
    return addr;
    80003262:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003264:	8526                	mv	a0,s1
    80003266:	70a2                	ld	ra,40(sp)
    80003268:	7402                	ld	s0,32(sp)
    8000326a:	64e2                	ld	s1,24(sp)
    8000326c:	6942                	ld	s2,16(sp)
    8000326e:	69a2                	ld	s3,8(sp)
    80003270:	6145                	addi	sp,sp,48
    80003272:	8082                	ret
      addr = balloc(ip->dev);
    80003274:	00092503          	lw	a0,0(s2)
    80003278:	e5dff0ef          	jal	800030d4 <balloc>
    8000327c:	84aa                	mv	s1,a0
      if (addr) {
    8000327e:	dd79                	beqz	a0,8000325c <bmap+0x82>
        a[bn] = addr;
    80003280:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003284:	8552                	mv	a0,s4
    80003286:	69f000ef          	jal	80004124 <log_write>
    8000328a:	bfc9                	j	8000325c <bmap+0x82>
    8000328c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000328e:	00004517          	auipc	a0,0x4
    80003292:	2a250513          	addi	a0,a0,674 # 80007530 <etext+0x530>
    80003296:	d9efd0ef          	jal	80000834 <panic>

000000008000329a <iget>:
{
    8000329a:	7179                	addi	sp,sp,-48
    8000329c:	f406                	sd	ra,40(sp)
    8000329e:	f022                	sd	s0,32(sp)
    800032a0:	ec26                	sd	s1,24(sp)
    800032a2:	e84a                	sd	s2,16(sp)
    800032a4:	e44e                	sd	s3,8(sp)
    800032a6:	e052                	sd	s4,0(sp)
    800032a8:	1800                	addi	s0,sp,48
    800032aa:	892a                	mv	s2,a0
    800032ac:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800032ae:	0001e517          	auipc	a0,0x1e
    800032b2:	00a50513          	addi	a0,a0,10 # 800212b8 <itable>
    800032b6:	933fd0ef          	jal	80000be8 <acquire>
  empty = 0;
    800032ba:	4981                	li	s3,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800032bc:	0001e497          	auipc	s1,0x1e
    800032c0:	01448493          	addi	s1,s1,20 # 800212d0 <itable+0x18>
    800032c4:	00020697          	auipc	a3,0x20
    800032c8:	a9c68693          	addi	a3,a3,-1380 # 80022d60 <log>
    800032cc:	a809                	j	800032de <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800032ce:	e781                	bnez	a5,800032d6 <iget+0x3c>
    800032d0:	00099363          	bnez	s3,800032d6 <iget+0x3c>
      empty = ip;
    800032d4:	89a6                	mv	s3,s1
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800032d6:	08848493          	addi	s1,s1,136
    800032da:	02d48563          	beq	s1,a3,80003304 <iget+0x6a>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    800032de:	449c                	lw	a5,8(s1)
    800032e0:	fef057e3          	blez	a5,800032ce <iget+0x34>
    800032e4:	4098                	lw	a4,0(s1)
    800032e6:	ff2718e3          	bne	a4,s2,800032d6 <iget+0x3c>
    800032ea:	40d8                	lw	a4,4(s1)
    800032ec:	ff4715e3          	bne	a4,s4,800032d6 <iget+0x3c>
      ip->ref++;
    800032f0:	2785                	addiw	a5,a5,1
    800032f2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800032f4:	0001e517          	auipc	a0,0x1e
    800032f8:	fc450513          	addi	a0,a0,-60 # 800212b8 <itable>
    800032fc:	975fd0ef          	jal	80000c70 <release>
      return ip;
    80003300:	89a6                	mv	s3,s1
    80003302:	a015                	j	80003326 <iget+0x8c>
  if (empty == 0)
    80003304:	02098a63          	beqz	s3,80003338 <iget+0x9e>
  ip->dev = dev;
    80003308:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    8000330c:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003310:	4785                	li	a5,1
    80003312:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003316:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000331a:	0001e517          	auipc	a0,0x1e
    8000331e:	f9e50513          	addi	a0,a0,-98 # 800212b8 <itable>
    80003322:	94ffd0ef          	jal	80000c70 <release>
}
    80003326:	854e                	mv	a0,s3
    80003328:	70a2                	ld	ra,40(sp)
    8000332a:	7402                	ld	s0,32(sp)
    8000332c:	64e2                	ld	s1,24(sp)
    8000332e:	6942                	ld	s2,16(sp)
    80003330:	69a2                	ld	s3,8(sp)
    80003332:	6a02                	ld	s4,0(sp)
    80003334:	6145                	addi	sp,sp,48
    80003336:	8082                	ret
    panic("iget: no inodes");
    80003338:	00004517          	auipc	a0,0x4
    8000333c:	21050513          	addi	a0,a0,528 # 80007548 <etext+0x548>
    80003340:	cf4fd0ef          	jal	80000834 <panic>

0000000080003344 <iinit>:
{
    80003344:	7179                	addi	sp,sp,-48
    80003346:	f406                	sd	ra,40(sp)
    80003348:	f022                	sd	s0,32(sp)
    8000334a:	ec26                	sd	s1,24(sp)
    8000334c:	e84a                	sd	s2,16(sp)
    8000334e:	e44e                	sd	s3,8(sp)
    80003350:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003352:	00004597          	auipc	a1,0x4
    80003356:	20658593          	addi	a1,a1,518 # 80007558 <etext+0x558>
    8000335a:	0001e517          	auipc	a0,0x1e
    8000335e:	f5e50513          	addi	a0,a0,-162 # 800212b8 <itable>
    80003362:	807fd0ef          	jal	80000b68 <initlock>
  for (i = 0; i < NINODE; i++) {
    80003366:	0001e497          	auipc	s1,0x1e
    8000336a:	f7a48493          	addi	s1,s1,-134 # 800212e0 <itable+0x28>
    8000336e:	00020997          	auipc	s3,0x20
    80003372:	a0298993          	addi	s3,s3,-1534 # 80022d70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003376:	00004917          	auipc	s2,0x4
    8000337a:	1ea90913          	addi	s2,s2,490 # 80007560 <etext+0x560>
    8000337e:	85ca                	mv	a1,s2
    80003380:	8526                	mv	a0,s1
    80003382:	6db000ef          	jal	8000425c <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80003386:	08848493          	addi	s1,s1,136
    8000338a:	ff349ae3          	bne	s1,s3,8000337e <iinit+0x3a>
}
    8000338e:	70a2                	ld	ra,40(sp)
    80003390:	7402                	ld	s0,32(sp)
    80003392:	64e2                	ld	s1,24(sp)
    80003394:	6942                	ld	s2,16(sp)
    80003396:	69a2                	ld	s3,8(sp)
    80003398:	6145                	addi	sp,sp,48
    8000339a:	8082                	ret

000000008000339c <ialloc>:
{
    8000339c:	7139                	addi	sp,sp,-64
    8000339e:	fc06                	sd	ra,56(sp)
    800033a0:	f822                	sd	s0,48(sp)
    800033a2:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800033a4:	0001e717          	auipc	a4,0x1e
    800033a8:	f0072703          	lw	a4,-256(a4) # 800212a4 <sb+0xc>
    800033ac:	4785                	li	a5,1
    800033ae:	06e7f063          	bgeu	a5,a4,8000340e <ialloc+0x72>
    800033b2:	f426                	sd	s1,40(sp)
    800033b4:	f04a                	sd	s2,32(sp)
    800033b6:	ec4e                	sd	s3,24(sp)
    800033b8:	e852                	sd	s4,16(sp)
    800033ba:	e456                	sd	s5,8(sp)
    800033bc:	e05a                	sd	s6,0(sp)
    800033be:	8aaa                	mv	s5,a0
    800033c0:	8b2e                	mv	s6,a1
    800033c2:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800033c4:	0001ea17          	auipc	s4,0x1e
    800033c8:	ed4a0a13          	addi	s4,s4,-300 # 80021298 <sb>
    800033cc:	00495593          	srli	a1,s2,0x4
    800033d0:	018a2783          	lw	a5,24(s4)
    800033d4:	9dbd                	addw	a1,a1,a5
    800033d6:	8556                	mv	a0,s5
    800033d8:	a9dff0ef          	jal	80002e74 <bread>
    800033dc:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    800033de:	05850993          	addi	s3,a0,88
    800033e2:	00f97793          	andi	a5,s2,15
    800033e6:	079a                	slli	a5,a5,0x6
    800033e8:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    800033ea:	00099783          	lh	a5,0(s3)
    800033ee:	cb9d                	beqz	a5,80003424 <ialloc+0x88>
    brelse(bp);
    800033f0:	b8dff0ef          	jal	80002f7c <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    800033f4:	0905                	addi	s2,s2,1
    800033f6:	00ca2703          	lw	a4,12(s4)
    800033fa:	0009079b          	sext.w	a5,s2
    800033fe:	fce7e7e3          	bltu	a5,a4,800033cc <ialloc+0x30>
    80003402:	74a2                	ld	s1,40(sp)
    80003404:	7902                	ld	s2,32(sp)
    80003406:	69e2                	ld	s3,24(sp)
    80003408:	6a42                	ld	s4,16(sp)
    8000340a:	6aa2                	ld	s5,8(sp)
    8000340c:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    8000340e:	00004517          	auipc	a0,0x4
    80003412:	15a50513          	addi	a0,a0,346 # 80007568 <etext+0x568>
    80003416:	8f4fd0ef          	jal	8000050a <printk>
  return 0;
    8000341a:	4501                	li	a0,0
}
    8000341c:	70e2                	ld	ra,56(sp)
    8000341e:	7442                	ld	s0,48(sp)
    80003420:	6121                	addi	sp,sp,64
    80003422:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003424:	04000613          	li	a2,64
    80003428:	4581                	li	a1,0
    8000342a:	854e                	mv	a0,s3
    8000342c:	87dfd0ef          	jal	80000ca8 <memset>
      dip->type = type;
    80003430:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80003434:	8526                	mv	a0,s1
    80003436:	4ef000ef          	jal	80004124 <log_write>
      brelse(bp);
    8000343a:	8526                	mv	a0,s1
    8000343c:	b41ff0ef          	jal	80002f7c <brelse>
      return iget(dev, inum);
    80003440:	0009059b          	sext.w	a1,s2
    80003444:	8556                	mv	a0,s5
    80003446:	e55ff0ef          	jal	8000329a <iget>
    8000344a:	74a2                	ld	s1,40(sp)
    8000344c:	7902                	ld	s2,32(sp)
    8000344e:	69e2                	ld	s3,24(sp)
    80003450:	6a42                	ld	s4,16(sp)
    80003452:	6aa2                	ld	s5,8(sp)
    80003454:	6b02                	ld	s6,0(sp)
    80003456:	b7d9                	j	8000341c <ialloc+0x80>

0000000080003458 <iupdate>:
{
    80003458:	1101                	addi	sp,sp,-32
    8000345a:	ec06                	sd	ra,24(sp)
    8000345c:	e822                	sd	s0,16(sp)
    8000345e:	e426                	sd	s1,8(sp)
    80003460:	e04a                	sd	s2,0(sp)
    80003462:	1000                	addi	s0,sp,32
    80003464:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003466:	415c                	lw	a5,4(a0)
    80003468:	0047d79b          	srliw	a5,a5,0x4
    8000346c:	0001e597          	auipc	a1,0x1e
    80003470:	e445a583          	lw	a1,-444(a1) # 800212b0 <sb+0x18>
    80003474:	9dbd                	addw	a1,a1,a5
    80003476:	4108                	lw	a0,0(a0)
    80003478:	9fdff0ef          	jal	80002e74 <bread>
    8000347c:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000347e:	05850793          	addi	a5,a0,88
    80003482:	40d8                	lw	a4,4(s1)
    80003484:	8b3d                	andi	a4,a4,15
    80003486:	071a                	slli	a4,a4,0x6
    80003488:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000348a:	04449703          	lh	a4,68(s1)
    8000348e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003492:	04649703          	lh	a4,70(s1)
    80003496:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000349a:	04849703          	lh	a4,72(s1)
    8000349e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800034a2:	04a49703          	lh	a4,74(s1)
    800034a6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800034aa:	44f8                	lw	a4,76(s1)
    800034ac:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800034ae:	03400613          	li	a2,52
    800034b2:	05048593          	addi	a1,s1,80
    800034b6:	00c78513          	addi	a0,a5,12
    800034ba:	84ffd0ef          	jal	80000d08 <memmove>
  log_write(bp);
    800034be:	854a                	mv	a0,s2
    800034c0:	465000ef          	jal	80004124 <log_write>
  brelse(bp);
    800034c4:	854a                	mv	a0,s2
    800034c6:	ab7ff0ef          	jal	80002f7c <brelse>
}
    800034ca:	60e2                	ld	ra,24(sp)
    800034cc:	6442                	ld	s0,16(sp)
    800034ce:	64a2                	ld	s1,8(sp)
    800034d0:	6902                	ld	s2,0(sp)
    800034d2:	6105                	addi	sp,sp,32
    800034d4:	8082                	ret

00000000800034d6 <idup>:
{
    800034d6:	1101                	addi	sp,sp,-32
    800034d8:	ec06                	sd	ra,24(sp)
    800034da:	e822                	sd	s0,16(sp)
    800034dc:	e426                	sd	s1,8(sp)
    800034de:	1000                	addi	s0,sp,32
    800034e0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034e2:	0001e517          	auipc	a0,0x1e
    800034e6:	dd650513          	addi	a0,a0,-554 # 800212b8 <itable>
    800034ea:	efefd0ef          	jal	80000be8 <acquire>
  ip->ref++;
    800034ee:	449c                	lw	a5,8(s1)
    800034f0:	2785                	addiw	a5,a5,1
    800034f2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034f4:	0001e517          	auipc	a0,0x1e
    800034f8:	dc450513          	addi	a0,a0,-572 # 800212b8 <itable>
    800034fc:	f74fd0ef          	jal	80000c70 <release>
}
    80003500:	8526                	mv	a0,s1
    80003502:	60e2                	ld	ra,24(sp)
    80003504:	6442                	ld	s0,16(sp)
    80003506:	64a2                	ld	s1,8(sp)
    80003508:	6105                	addi	sp,sp,32
    8000350a:	8082                	ret

000000008000350c <ilock>:
{
    8000350c:	1101                	addi	sp,sp,-32
    8000350e:	ec06                	sd	ra,24(sp)
    80003510:	e822                	sd	s0,16(sp)
    80003512:	e426                	sd	s1,8(sp)
    80003514:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003516:	cd19                	beqz	a0,80003534 <ilock+0x28>
    80003518:	84aa                	mv	s1,a0
    8000351a:	451c                	lw	a5,8(a0)
    8000351c:	00f05c63          	blez	a5,80003534 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003520:	0541                	addi	a0,a0,16
    80003522:	571000ef          	jal	80004292 <acquiresleep>
  if (ip->valid == 0) {
    80003526:	40bc                	lw	a5,64(s1)
    80003528:	cf89                	beqz	a5,80003542 <ilock+0x36>
}
    8000352a:	60e2                	ld	ra,24(sp)
    8000352c:	6442                	ld	s0,16(sp)
    8000352e:	64a2                	ld	s1,8(sp)
    80003530:	6105                	addi	sp,sp,32
    80003532:	8082                	ret
    80003534:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003536:	00004517          	auipc	a0,0x4
    8000353a:	04a50513          	addi	a0,a0,74 # 80007580 <etext+0x580>
    8000353e:	af6fd0ef          	jal	80000834 <panic>
    80003542:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003544:	40dc                	lw	a5,4(s1)
    80003546:	0047d79b          	srliw	a5,a5,0x4
    8000354a:	0001e597          	auipc	a1,0x1e
    8000354e:	d665a583          	lw	a1,-666(a1) # 800212b0 <sb+0x18>
    80003552:	9dbd                	addw	a1,a1,a5
    80003554:	4088                	lw	a0,0(s1)
    80003556:	91fff0ef          	jal	80002e74 <bread>
    8000355a:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000355c:	05850593          	addi	a1,a0,88
    80003560:	40dc                	lw	a5,4(s1)
    80003562:	8bbd                	andi	a5,a5,15
    80003564:	079a                	slli	a5,a5,0x6
    80003566:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003568:	00059783          	lh	a5,0(a1)
    8000356c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003570:	00259783          	lh	a5,2(a1)
    80003574:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003578:	00459783          	lh	a5,4(a1)
    8000357c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003580:	00659783          	lh	a5,6(a1)
    80003584:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003588:	459c                	lw	a5,8(a1)
    8000358a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000358c:	03400613          	li	a2,52
    80003590:	05b1                	addi	a1,a1,12
    80003592:	05048513          	addi	a0,s1,80
    80003596:	f72fd0ef          	jal	80000d08 <memmove>
    brelse(bp);
    8000359a:	854a                	mv	a0,s2
    8000359c:	9e1ff0ef          	jal	80002f7c <brelse>
    ip->valid = 1;
    800035a0:	4785                	li	a5,1
    800035a2:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    800035a4:	04449783          	lh	a5,68(s1)
    800035a8:	c399                	beqz	a5,800035ae <ilock+0xa2>
    800035aa:	6902                	ld	s2,0(sp)
    800035ac:	bfbd                	j	8000352a <ilock+0x1e>
      panic("ilock: no type");
    800035ae:	00004517          	auipc	a0,0x4
    800035b2:	fda50513          	addi	a0,a0,-38 # 80007588 <etext+0x588>
    800035b6:	a7efd0ef          	jal	80000834 <panic>

00000000800035ba <iunlock>:
{
    800035ba:	1101                	addi	sp,sp,-32
    800035bc:	ec06                	sd	ra,24(sp)
    800035be:	e822                	sd	s0,16(sp)
    800035c0:	e426                	sd	s1,8(sp)
    800035c2:	e04a                	sd	s2,0(sp)
    800035c4:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800035c6:	c505                	beqz	a0,800035ee <iunlock+0x34>
    800035c8:	84aa                	mv	s1,a0
    800035ca:	01050913          	addi	s2,a0,16
    800035ce:	854a                	mv	a0,s2
    800035d0:	54f000ef          	jal	8000431e <holdingsleep>
    800035d4:	cd09                	beqz	a0,800035ee <iunlock+0x34>
    800035d6:	449c                	lw	a5,8(s1)
    800035d8:	00f05b63          	blez	a5,800035ee <iunlock+0x34>
  releasesleep(&ip->lock);
    800035dc:	854a                	mv	a0,s2
    800035de:	509000ef          	jal	800042e6 <releasesleep>
}
    800035e2:	60e2                	ld	ra,24(sp)
    800035e4:	6442                	ld	s0,16(sp)
    800035e6:	64a2                	ld	s1,8(sp)
    800035e8:	6902                	ld	s2,0(sp)
    800035ea:	6105                	addi	sp,sp,32
    800035ec:	8082                	ret
    panic("iunlock");
    800035ee:	00004517          	auipc	a0,0x4
    800035f2:	faa50513          	addi	a0,a0,-86 # 80007598 <etext+0x598>
    800035f6:	a3efd0ef          	jal	80000834 <panic>

00000000800035fa <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800035fa:	7179                	addi	sp,sp,-48
    800035fc:	f406                	sd	ra,40(sp)
    800035fe:	f022                	sd	s0,32(sp)
    80003600:	ec26                	sd	s1,24(sp)
    80003602:	e84a                	sd	s2,16(sp)
    80003604:	e44e                	sd	s3,8(sp)
    80003606:	1800                	addi	s0,sp,48
    80003608:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    8000360a:	05050493          	addi	s1,a0,80
    8000360e:	08050913          	addi	s2,a0,128
    80003612:	a021                	j	8000361a <itrunc+0x20>
    80003614:	0491                	addi	s1,s1,4
    80003616:	01248b63          	beq	s1,s2,8000362c <itrunc+0x32>
    if (ip->addrs[i]) {
    8000361a:	408c                	lw	a1,0(s1)
    8000361c:	dde5                	beqz	a1,80003614 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000361e:	0009a503          	lw	a0,0(s3)
    80003622:	a47ff0ef          	jal	80003068 <bfree>
      ip->addrs[i] = 0;
    80003626:	0004a023          	sw	zero,0(s1)
    8000362a:	b7ed                	j	80003614 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    8000362c:	0809a583          	lw	a1,128(s3)
    80003630:	ed89                	bnez	a1,8000364a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003632:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003636:	854e                	mv	a0,s3
    80003638:	e21ff0ef          	jal	80003458 <iupdate>
}
    8000363c:	70a2                	ld	ra,40(sp)
    8000363e:	7402                	ld	s0,32(sp)
    80003640:	64e2                	ld	s1,24(sp)
    80003642:	6942                	ld	s2,16(sp)
    80003644:	69a2                	ld	s3,8(sp)
    80003646:	6145                	addi	sp,sp,48
    80003648:	8082                	ret
    8000364a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000364c:	0009a503          	lw	a0,0(s3)
    80003650:	825ff0ef          	jal	80002e74 <bread>
    80003654:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80003656:	05850493          	addi	s1,a0,88
    8000365a:	45850913          	addi	s2,a0,1112
    8000365e:	a021                	j	80003666 <itrunc+0x6c>
    80003660:	0491                	addi	s1,s1,4
    80003662:	01248963          	beq	s1,s2,80003674 <itrunc+0x7a>
      if (a[j])
    80003666:	408c                	lw	a1,0(s1)
    80003668:	dde5                	beqz	a1,80003660 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000366a:	0009a503          	lw	a0,0(s3)
    8000366e:	9fbff0ef          	jal	80003068 <bfree>
    80003672:	b7fd                	j	80003660 <itrunc+0x66>
    brelse(bp);
    80003674:	8552                	mv	a0,s4
    80003676:	907ff0ef          	jal	80002f7c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000367a:	0809a583          	lw	a1,128(s3)
    8000367e:	0009a503          	lw	a0,0(s3)
    80003682:	9e7ff0ef          	jal	80003068 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003686:	0809a023          	sw	zero,128(s3)
    8000368a:	6a02                	ld	s4,0(sp)
    8000368c:	b75d                	j	80003632 <itrunc+0x38>

000000008000368e <iput>:
{
    8000368e:	7179                	addi	sp,sp,-48
    80003690:	f406                	sd	ra,40(sp)
    80003692:	f022                	sd	s0,32(sp)
    80003694:	ec26                	sd	s1,24(sp)
    80003696:	1800                	addi	s0,sp,48
    80003698:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000369a:	0001e517          	auipc	a0,0x1e
    8000369e:	c1e50513          	addi	a0,a0,-994 # 800212b8 <itable>
    800036a2:	d46fd0ef          	jal	80000be8 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800036a6:	449c                	lw	a5,8(s1)
    800036a8:	4705                	li	a4,1
    800036aa:	00e78f63          	beq	a5,a4,800036c8 <iput+0x3a>
  ip->ref--;
    800036ae:	37fd                	addiw	a5,a5,-1
    800036b0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036b2:	0001e517          	auipc	a0,0x1e
    800036b6:	c0650513          	addi	a0,a0,-1018 # 800212b8 <itable>
    800036ba:	db6fd0ef          	jal	80000c70 <release>
}
    800036be:	70a2                	ld	ra,40(sp)
    800036c0:	7402                	ld	s0,32(sp)
    800036c2:	64e2                	ld	s1,24(sp)
    800036c4:	6145                	addi	sp,sp,48
    800036c6:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800036c8:	40b8                	lw	a4,64(s1)
    800036ca:	d375                	beqz	a4,800036ae <iput+0x20>
    800036cc:	e84a                	sd	s2,16(sp)
    800036ce:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    800036d0:	0004aa03          	lw	s4,0(s1)
    800036d4:	0044a903          	lw	s2,4(s1)
  if (last) {
    800036d8:	04a49703          	lh	a4,74(s1)
    800036dc:	ef3d                	bnez	a4,8000375a <iput+0xcc>
    800036de:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    800036e0:	01048793          	addi	a5,s1,16
    800036e4:	89be                	mv	s3,a5
    800036e6:	853e                	mv	a0,a5
    800036e8:	3ab000ef          	jal	80004292 <acquiresleep>
    release(&itable.lock);
    800036ec:	0001e517          	auipc	a0,0x1e
    800036f0:	bcc50513          	addi	a0,a0,-1076 # 800212b8 <itable>
    800036f4:	d7cfd0ef          	jal	80000c70 <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    800036f8:	8526                	mv	a0,s1
    800036fa:	f01ff0ef          	jal	800035fa <itrunc>
    ip->valid = 0;
    800036fe:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003702:	854e                	mv	a0,s3
    80003704:	3e3000ef          	jal	800042e6 <releasesleep>
    acquire(&itable.lock);
    80003708:	0001e517          	auipc	a0,0x1e
    8000370c:	bb050513          	addi	a0,a0,-1104 # 800212b8 <itable>
    80003710:	cd8fd0ef          	jal	80000be8 <acquire>
  ip->ref--;
    80003714:	449c                	lw	a5,8(s1)
    80003716:	37fd                	addiw	a5,a5,-1
    80003718:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000371a:	0001e517          	auipc	a0,0x1e
    8000371e:	b9e50513          	addi	a0,a0,-1122 # 800212b8 <itable>
    80003722:	d4efd0ef          	jal	80000c70 <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003726:	0049579b          	srliw	a5,s2,0x4
    8000372a:	0001e597          	auipc	a1,0x1e
    8000372e:	b865a583          	lw	a1,-1146(a1) # 800212b0 <sb+0x18>
    80003732:	9dbd                	addw	a1,a1,a5
    80003734:	8552                	mv	a0,s4
    80003736:	f3eff0ef          	jal	80002e74 <bread>
    8000373a:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000373c:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    80003740:	079a                	slli	a5,a5,0x6
    80003742:	97aa                	add	a5,a5,a0
    80003744:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    80003748:	1dd000ef          	jal	80004124 <log_write>
  brelse(bp);
    8000374c:	8526                	mv	a0,s1
    8000374e:	82fff0ef          	jal	80002f7c <brelse>
}
    80003752:	6942                	ld	s2,16(sp)
    80003754:	69a2                	ld	s3,8(sp)
    80003756:	6a02                	ld	s4,0(sp)
    80003758:	b79d                	j	800036be <iput+0x30>
    8000375a:	6942                	ld	s2,16(sp)
    8000375c:	6a02                	ld	s4,0(sp)
    8000375e:	bf81                	j	800036ae <iput+0x20>

0000000080003760 <iunlockput>:
{
    80003760:	1101                	addi	sp,sp,-32
    80003762:	ec06                	sd	ra,24(sp)
    80003764:	e822                	sd	s0,16(sp)
    80003766:	e426                	sd	s1,8(sp)
    80003768:	1000                	addi	s0,sp,32
    8000376a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000376c:	e4fff0ef          	jal	800035ba <iunlock>
  iput(ip);
    80003770:	8526                	mv	a0,s1
    80003772:	f1dff0ef          	jal	8000368e <iput>
}
    80003776:	60e2                	ld	ra,24(sp)
    80003778:	6442                	ld	s0,16(sp)
    8000377a:	64a2                	ld	s1,8(sp)
    8000377c:	6105                	addi	sp,sp,32
    8000377e:	8082                	ret

0000000080003780 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003780:	0001e717          	auipc	a4,0x1e
    80003784:	b2472703          	lw	a4,-1244(a4) # 800212a4 <sb+0xc>
    80003788:	4785                	li	a5,1
    8000378a:	0ae7fe63          	bgeu	a5,a4,80003846 <ireclaim+0xc6>
{
    8000378e:	7139                	addi	sp,sp,-64
    80003790:	fc06                	sd	ra,56(sp)
    80003792:	f822                	sd	s0,48(sp)
    80003794:	f426                	sd	s1,40(sp)
    80003796:	f04a                	sd	s2,32(sp)
    80003798:	ec4e                	sd	s3,24(sp)
    8000379a:	e852                	sd	s4,16(sp)
    8000379c:	e456                	sd	s5,8(sp)
    8000379e:	e05a                	sd	s6,0(sp)
    800037a0:	0080                	addi	s0,sp,64
    800037a2:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800037a4:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800037a6:	0001ea17          	auipc	s4,0x1e
    800037aa:	af2a0a13          	addi	s4,s4,-1294 # 80021298 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    800037ae:	00004b17          	auipc	s6,0x4
    800037b2:	df2b0b13          	addi	s6,s6,-526 # 800075a0 <etext+0x5a0>
    800037b6:	a099                	j	800037fc <ireclaim+0x7c>
    800037b8:	85ce                	mv	a1,s3
    800037ba:	855a                	mv	a0,s6
    800037bc:	d4ffc0ef          	jal	8000050a <printk>
      ip = iget(dev, inum);
    800037c0:	85ce                	mv	a1,s3
    800037c2:	8556                	mv	a0,s5
    800037c4:	ad7ff0ef          	jal	8000329a <iget>
    800037c8:	89aa                	mv	s3,a0
    brelse(bp);
    800037ca:	854a                	mv	a0,s2
    800037cc:	fb0ff0ef          	jal	80002f7c <brelse>
    if (ip) {
    800037d0:	00098f63          	beqz	s3,800037ee <ireclaim+0x6e>
      begin_op();
    800037d4:	7a2000ef          	jal	80003f76 <begin_op>
      ilock(ip);
    800037d8:	854e                	mv	a0,s3
    800037da:	d33ff0ef          	jal	8000350c <ilock>
      iunlock(ip);
    800037de:	854e                	mv	a0,s3
    800037e0:	ddbff0ef          	jal	800035ba <iunlock>
      iput(ip);
    800037e4:	854e                	mv	a0,s3
    800037e6:	ea9ff0ef          	jal	8000368e <iput>
      end_op();
    800037ea:	019000ef          	jal	80004002 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800037ee:	0485                	addi	s1,s1,1
    800037f0:	00ca2703          	lw	a4,12(s4)
    800037f4:	0004879b          	sext.w	a5,s1
    800037f8:	02e7fd63          	bgeu	a5,a4,80003832 <ireclaim+0xb2>
    800037fc:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003800:	0044d593          	srli	a1,s1,0x4
    80003804:	018a2783          	lw	a5,24(s4)
    80003808:	9dbd                	addw	a1,a1,a5
    8000380a:	8556                	mv	a0,s5
    8000380c:	e68ff0ef          	jal	80002e74 <bread>
    80003810:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003812:	05850793          	addi	a5,a0,88
    80003816:	00f9f713          	andi	a4,s3,15
    8000381a:	071a                	slli	a4,a4,0x6
    8000381c:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    8000381e:	00079703          	lh	a4,0(a5)
    80003822:	c701                	beqz	a4,8000382a <ireclaim+0xaa>
    80003824:	00679783          	lh	a5,6(a5)
    80003828:	dbc1                	beqz	a5,800037b8 <ireclaim+0x38>
    brelse(bp);
    8000382a:	854a                	mv	a0,s2
    8000382c:	f50ff0ef          	jal	80002f7c <brelse>
    if (ip) {
    80003830:	bf7d                	j	800037ee <ireclaim+0x6e>
}
    80003832:	70e2                	ld	ra,56(sp)
    80003834:	7442                	ld	s0,48(sp)
    80003836:	74a2                	ld	s1,40(sp)
    80003838:	7902                	ld	s2,32(sp)
    8000383a:	69e2                	ld	s3,24(sp)
    8000383c:	6a42                	ld	s4,16(sp)
    8000383e:	6aa2                	ld	s5,8(sp)
    80003840:	6b02                	ld	s6,0(sp)
    80003842:	6121                	addi	sp,sp,64
    80003844:	8082                	ret
    80003846:	8082                	ret

0000000080003848 <fsinit>:
{
    80003848:	1101                	addi	sp,sp,-32
    8000384a:	ec06                	sd	ra,24(sp)
    8000384c:	e822                	sd	s0,16(sp)
    8000384e:	e426                	sd	s1,8(sp)
    80003850:	e04a                	sd	s2,0(sp)
    80003852:	1000                	addi	s0,sp,32
    80003854:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003856:	4585                	li	a1,1
    80003858:	e1cff0ef          	jal	80002e74 <bread>
    8000385c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000385e:	02000613          	li	a2,32
    80003862:	05850593          	addi	a1,a0,88
    80003866:	0001e517          	auipc	a0,0x1e
    8000386a:	a3250513          	addi	a0,a0,-1486 # 80021298 <sb>
    8000386e:	c9afd0ef          	jal	80000d08 <memmove>
  brelse(bp);
    80003872:	8526                	mv	a0,s1
    80003874:	f08ff0ef          	jal	80002f7c <brelse>
  if (sb.magic != FSMAGIC)
    80003878:	0001e717          	auipc	a4,0x1e
    8000387c:	a2072703          	lw	a4,-1504(a4) # 80021298 <sb>
    80003880:	102037b7          	lui	a5,0x10203
    80003884:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003888:	02f71263          	bne	a4,a5,800038ac <fsinit+0x64>
  initlog(dev, &sb);
    8000388c:	0001e597          	auipc	a1,0x1e
    80003890:	a0c58593          	addi	a1,a1,-1524 # 80021298 <sb>
    80003894:	854a                	mv	a0,s2
    80003896:	65e000ef          	jal	80003ef4 <initlog>
  ireclaim(dev);
    8000389a:	854a                	mv	a0,s2
    8000389c:	ee5ff0ef          	jal	80003780 <ireclaim>
}
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	64a2                	ld	s1,8(sp)
    800038a6:	6902                	ld	s2,0(sp)
    800038a8:	6105                	addi	sp,sp,32
    800038aa:	8082                	ret
    panic("invalid file system");
    800038ac:	00004517          	auipc	a0,0x4
    800038b0:	d1450513          	addi	a0,a0,-748 # 800075c0 <etext+0x5c0>
    800038b4:	f81fc0ef          	jal	80000834 <panic>

00000000800038b8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800038b8:	1141                	addi	sp,sp,-16
    800038ba:	e406                	sd	ra,8(sp)
    800038bc:	e022                	sd	s0,0(sp)
    800038be:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800038c0:	411c                	lw	a5,0(a0)
    800038c2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800038c4:	415c                	lw	a5,4(a0)
    800038c6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800038c8:	04451783          	lh	a5,68(a0)
    800038cc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800038d0:	04a51783          	lh	a5,74(a0)
    800038d4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800038d8:	04c56783          	lwu	a5,76(a0)
    800038dc:	e99c                	sd	a5,16(a1)
}
    800038de:	60a2                	ld	ra,8(sp)
    800038e0:	6402                	ld	s0,0(sp)
    800038e2:	0141                	addi	sp,sp,16
    800038e4:	8082                	ret

00000000800038e6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800038e6:	457c                	lw	a5,76(a0)
    800038e8:	0ed7e663          	bltu	a5,a3,800039d4 <readi+0xee>
{
    800038ec:	7159                	addi	sp,sp,-112
    800038ee:	f486                	sd	ra,104(sp)
    800038f0:	f0a2                	sd	s0,96(sp)
    800038f2:	eca6                	sd	s1,88(sp)
    800038f4:	e0d2                	sd	s4,64(sp)
    800038f6:	fc56                	sd	s5,56(sp)
    800038f8:	f85a                	sd	s6,48(sp)
    800038fa:	f45e                	sd	s7,40(sp)
    800038fc:	1880                	addi	s0,sp,112
    800038fe:	8b2a                	mv	s6,a0
    80003900:	8bae                	mv	s7,a1
    80003902:	8a32                	mv	s4,a2
    80003904:	84b6                	mv	s1,a3
    80003906:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80003908:	9f35                	addw	a4,a4,a3
    return 0;
    8000390a:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    8000390c:	0ad76b63          	bltu	a4,a3,800039c2 <readi+0xdc>
    80003910:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80003912:	00e7f463          	bgeu	a5,a4,8000391a <readi+0x34>
    n = ip->size - off;
    80003916:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000391a:	080a8b63          	beqz	s5,800039b0 <readi+0xca>
    8000391e:	e8ca                	sd	s2,80(sp)
    80003920:	f062                	sd	s8,32(sp)
    80003922:	ec66                	sd	s9,24(sp)
    80003924:	e86a                	sd	s10,16(sp)
    80003926:	e46e                	sd	s11,8(sp)
    80003928:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000392a:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000392e:	5c7d                	li	s8,-1
    80003930:	a80d                	j	80003962 <readi+0x7c>
    80003932:	020d1d93          	slli	s11,s10,0x20
    80003936:	020ddd93          	srli	s11,s11,0x20
    8000393a:	05890613          	addi	a2,s2,88
    8000393e:	86ee                	mv	a3,s11
    80003940:	963e                	add	a2,a2,a5
    80003942:	85d2                	mv	a1,s4
    80003944:	855e                	mv	a0,s7
    80003946:	bfdfe0ef          	jal	80002542 <either_copyout>
    8000394a:	05850363          	beq	a0,s8,80003990 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000394e:	854a                	mv	a0,s2
    80003950:	e2cff0ef          	jal	80002f7c <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003954:	013d09bb          	addw	s3,s10,s3
    80003958:	009d04bb          	addw	s1,s10,s1
    8000395c:	9a6e                	add	s4,s4,s11
    8000395e:	0559f363          	bgeu	s3,s5,800039a4 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80003962:	00a4d59b          	srliw	a1,s1,0xa
    80003966:	855a                	mv	a0,s6
    80003968:	873ff0ef          	jal	800031da <bmap>
    8000396c:	85aa                	mv	a1,a0
    if (addr == 0)
    8000396e:	c139                	beqz	a0,800039b4 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003970:	000b2503          	lw	a0,0(s6)
    80003974:	d00ff0ef          	jal	80002e74 <bread>
    80003978:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000397a:	3ff4f793          	andi	a5,s1,1023
    8000397e:	40fc873b          	subw	a4,s9,a5
    80003982:	413a86bb          	subw	a3,s5,s3
    80003986:	8d3a                	mv	s10,a4
    80003988:	fae6f5e3          	bgeu	a3,a4,80003932 <readi+0x4c>
    8000398c:	8d36                	mv	s10,a3
    8000398e:	b755                	j	80003932 <readi+0x4c>
      brelse(bp);
    80003990:	854a                	mv	a0,s2
    80003992:	deaff0ef          	jal	80002f7c <brelse>
      tot = -1;
    80003996:	59fd                	li	s3,-1
      break;
    80003998:	6946                	ld	s2,80(sp)
    8000399a:	7c02                	ld	s8,32(sp)
    8000399c:	6ce2                	ld	s9,24(sp)
    8000399e:	6d42                	ld	s10,16(sp)
    800039a0:	6da2                	ld	s11,8(sp)
    800039a2:	a831                	j	800039be <readi+0xd8>
    800039a4:	6946                	ld	s2,80(sp)
    800039a6:	7c02                	ld	s8,32(sp)
    800039a8:	6ce2                	ld	s9,24(sp)
    800039aa:	6d42                	ld	s10,16(sp)
    800039ac:	6da2                	ld	s11,8(sp)
    800039ae:	a801                	j	800039be <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800039b0:	89d6                	mv	s3,s5
    800039b2:	a031                	j	800039be <readi+0xd8>
    800039b4:	6946                	ld	s2,80(sp)
    800039b6:	7c02                	ld	s8,32(sp)
    800039b8:	6ce2                	ld	s9,24(sp)
    800039ba:	6d42                	ld	s10,16(sp)
    800039bc:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800039be:	854e                	mv	a0,s3
    800039c0:	69a6                	ld	s3,72(sp)
}
    800039c2:	70a6                	ld	ra,104(sp)
    800039c4:	7406                	ld	s0,96(sp)
    800039c6:	64e6                	ld	s1,88(sp)
    800039c8:	6a06                	ld	s4,64(sp)
    800039ca:	7ae2                	ld	s5,56(sp)
    800039cc:	7b42                	ld	s6,48(sp)
    800039ce:	7ba2                	ld	s7,40(sp)
    800039d0:	6165                	addi	sp,sp,112
    800039d2:	8082                	ret
    return 0;
    800039d4:	4501                	li	a0,0
}
    800039d6:	8082                	ret

00000000800039d8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800039d8:	457c                	lw	a5,76(a0)
    800039da:	0ed7ee63          	bltu	a5,a3,80003ad6 <writei+0xfe>
{
    800039de:	7159                	addi	sp,sp,-112
    800039e0:	f486                	sd	ra,104(sp)
    800039e2:	f0a2                	sd	s0,96(sp)
    800039e4:	e8ca                	sd	s2,80(sp)
    800039e6:	e0d2                	sd	s4,64(sp)
    800039e8:	fc56                	sd	s5,56(sp)
    800039ea:	f85a                	sd	s6,48(sp)
    800039ec:	f45e                	sd	s7,40(sp)
    800039ee:	1880                	addi	s0,sp,112
    800039f0:	8aaa                	mv	s5,a0
    800039f2:	8bae                	mv	s7,a1
    800039f4:	8a32                	mv	s4,a2
    800039f6:	8936                	mv	s2,a3
    800039f8:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    800039fa:	00e687bb          	addw	a5,a3,a4
    return -1;
  if (off + n > MAXFILE * BSIZE)
    800039fe:	00043737          	lui	a4,0x43
    80003a02:	0cf76c63          	bltu	a4,a5,80003ada <writei+0x102>
    80003a06:	0cd7ea63          	bltu	a5,a3,80003ada <writei+0x102>
    80003a0a:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003a0c:	0a0b0d63          	beqz	s6,80003ac6 <writei+0xee>
    80003a10:	eca6                	sd	s1,88(sp)
    80003a12:	f062                	sd	s8,32(sp)
    80003a14:	ec66                	sd	s9,24(sp)
    80003a16:	e86a                	sd	s10,16(sp)
    80003a18:	e46e                	sd	s11,8(sp)
    80003a1a:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003a1c:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003a20:	5c7d                	li	s8,-1
    80003a22:	a825                	j	80003a5a <writei+0x82>
    80003a24:	020d1d93          	slli	s11,s10,0x20
    80003a28:	020ddd93          	srli	s11,s11,0x20
    80003a2c:	05848513          	addi	a0,s1,88
    80003a30:	86ee                	mv	a3,s11
    80003a32:	8652                	mv	a2,s4
    80003a34:	85de                	mv	a1,s7
    80003a36:	953e                	add	a0,a0,a5
    80003a38:	b57fe0ef          	jal	8000258e <either_copyin>
    80003a3c:	05850663          	beq	a0,s8,80003a88 <writei+0xb0>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80003a40:	8526                	mv	a0,s1
    80003a42:	6e2000ef          	jal	80004124 <log_write>
    brelse(bp);
    80003a46:	8526                	mv	a0,s1
    80003a48:	d34ff0ef          	jal	80002f7c <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003a4c:	013d09bb          	addw	s3,s10,s3
    80003a50:	012d093b          	addw	s2,s10,s2
    80003a54:	9a6e                	add	s4,s4,s11
    80003a56:	0369ff63          	bgeu	s3,s6,80003a94 <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    80003a5a:	00a9559b          	srliw	a1,s2,0xa
    80003a5e:	8556                	mv	a0,s5
    80003a60:	f7aff0ef          	jal	800031da <bmap>
    80003a64:	85aa                	mv	a1,a0
    if (addr == 0)
    80003a66:	c51d                	beqz	a0,80003a94 <writei+0xbc>
    bp = bread(ip->dev, addr);
    80003a68:	000aa503          	lw	a0,0(s5)
    80003a6c:	c08ff0ef          	jal	80002e74 <bread>
    80003a70:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003a72:	3ff97793          	andi	a5,s2,1023
    80003a76:	40fc873b          	subw	a4,s9,a5
    80003a7a:	413b06bb          	subw	a3,s6,s3
    80003a7e:	8d3a                	mv	s10,a4
    80003a80:	fae6f2e3          	bgeu	a3,a4,80003a24 <writei+0x4c>
    80003a84:	8d36                	mv	s10,a3
    80003a86:	bf79                	j	80003a24 <writei+0x4c>
      log_write(bp);
    80003a88:	8526                	mv	a0,s1
    80003a8a:	69a000ef          	jal	80004124 <log_write>
      brelse(bp);
    80003a8e:	8526                	mv	a0,s1
    80003a90:	cecff0ef          	jal	80002f7c <brelse>
  }

  if (off > ip->size)
    80003a94:	04caa783          	lw	a5,76(s5)
    80003a98:	0327f963          	bgeu	a5,s2,80003aca <writei+0xf2>
    ip->size = off;
    80003a9c:	052aa623          	sw	s2,76(s5)
    80003aa0:	64e6                	ld	s1,88(sp)
    80003aa2:	7c02                	ld	s8,32(sp)
    80003aa4:	6ce2                	ld	s9,24(sp)
    80003aa6:	6d42                	ld	s10,16(sp)
    80003aa8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003aaa:	8556                	mv	a0,s5
    80003aac:	9adff0ef          	jal	80003458 <iupdate>

  return tot;
    80003ab0:	854e                	mv	a0,s3
    80003ab2:	69a6                	ld	s3,72(sp)
}
    80003ab4:	70a6                	ld	ra,104(sp)
    80003ab6:	7406                	ld	s0,96(sp)
    80003ab8:	6946                	ld	s2,80(sp)
    80003aba:	6a06                	ld	s4,64(sp)
    80003abc:	7ae2                	ld	s5,56(sp)
    80003abe:	7b42                	ld	s6,48(sp)
    80003ac0:	7ba2                	ld	s7,40(sp)
    80003ac2:	6165                	addi	sp,sp,112
    80003ac4:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003ac6:	89da                	mv	s3,s6
    80003ac8:	b7cd                	j	80003aaa <writei+0xd2>
    80003aca:	64e6                	ld	s1,88(sp)
    80003acc:	7c02                	ld	s8,32(sp)
    80003ace:	6ce2                	ld	s9,24(sp)
    80003ad0:	6d42                	ld	s10,16(sp)
    80003ad2:	6da2                	ld	s11,8(sp)
    80003ad4:	bfd9                	j	80003aaa <writei+0xd2>
    return -1;
    80003ad6:	557d                	li	a0,-1
}
    80003ad8:	8082                	ret
    return -1;
    80003ada:	557d                	li	a0,-1
    80003adc:	bfe1                	j	80003ab4 <writei+0xdc>

0000000080003ade <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ade:	1141                	addi	sp,sp,-16
    80003ae0:	e406                	sd	ra,8(sp)
    80003ae2:	e022                	sd	s0,0(sp)
    80003ae4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ae6:	4639                	li	a2,14
    80003ae8:	a94fd0ef          	jal	80000d7c <strncmp>
}
    80003aec:	60a2                	ld	ra,8(sp)
    80003aee:	6402                	ld	s0,0(sp)
    80003af0:	0141                	addi	sp,sp,16
    80003af2:	8082                	ret

0000000080003af4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003af4:	711d                	addi	sp,sp,-96
    80003af6:	ec86                	sd	ra,88(sp)
    80003af8:	e8a2                	sd	s0,80(sp)
    80003afa:	e4a6                	sd	s1,72(sp)
    80003afc:	e0ca                	sd	s2,64(sp)
    80003afe:	fc4e                	sd	s3,56(sp)
    80003b00:	f852                	sd	s4,48(sp)
    80003b02:	f456                	sd	s5,40(sp)
    80003b04:	f05a                	sd	s6,32(sp)
    80003b06:	ec5e                	sd	s7,24(sp)
    80003b08:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003b0a:	04451703          	lh	a4,68(a0)
    80003b0e:	4785                	li	a5,1
    80003b10:	00f71f63          	bne	a4,a5,80003b2e <dirlookup+0x3a>
    80003b14:	892a                	mv	s2,a0
    80003b16:	8aae                	mv	s5,a1
    80003b18:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003b1a:	457c                	lw	a5,76(a0)
    80003b1c:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b1e:	fa040a13          	addi	s4,s0,-96
    80003b22:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80003b24:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003b28:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003b2a:	e39d                	bnez	a5,80003b50 <dirlookup+0x5c>
    80003b2c:	a8b9                	j	80003b8a <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003b2e:	00004517          	auipc	a0,0x4
    80003b32:	aaa50513          	addi	a0,a0,-1366 # 800075d8 <etext+0x5d8>
    80003b36:	cfffc0ef          	jal	80000834 <panic>
      panic("dirlookup read");
    80003b3a:	00004517          	auipc	a0,0x4
    80003b3e:	ab650513          	addi	a0,a0,-1354 # 800075f0 <etext+0x5f0>
    80003b42:	cf3fc0ef          	jal	80000834 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003b46:	24c1                	addiw	s1,s1,16
    80003b48:	04c92783          	lw	a5,76(s2)
    80003b4c:	02f4fe63          	bgeu	s1,a5,80003b88 <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b50:	874e                	mv	a4,s3
    80003b52:	86a6                	mv	a3,s1
    80003b54:	8652                	mv	a2,s4
    80003b56:	4581                	li	a1,0
    80003b58:	854a                	mv	a0,s2
    80003b5a:	d8dff0ef          	jal	800038e6 <readi>
    80003b5e:	fd351ee3          	bne	a0,s3,80003b3a <dirlookup+0x46>
    if (de.inum == 0)
    80003b62:	fa045783          	lhu	a5,-96(s0)
    80003b66:	d3e5                	beqz	a5,80003b46 <dirlookup+0x52>
    if (namecmp(name, de.name) == 0) {
    80003b68:	85da                	mv	a1,s6
    80003b6a:	8556                	mv	a0,s5
    80003b6c:	f73ff0ef          	jal	80003ade <namecmp>
    80003b70:	f979                	bnez	a0,80003b46 <dirlookup+0x52>
      if (poff)
    80003b72:	000b8463          	beqz	s7,80003b7a <dirlookup+0x86>
        *poff = off;
    80003b76:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003b7a:	fa045583          	lhu	a1,-96(s0)
    80003b7e:	00092503          	lw	a0,0(s2)
    80003b82:	f18ff0ef          	jal	8000329a <iget>
    80003b86:	a011                	j	80003b8a <dirlookup+0x96>
  return 0;
    80003b88:	4501                	li	a0,0
}
    80003b8a:	60e6                	ld	ra,88(sp)
    80003b8c:	6446                	ld	s0,80(sp)
    80003b8e:	64a6                	ld	s1,72(sp)
    80003b90:	6906                	ld	s2,64(sp)
    80003b92:	79e2                	ld	s3,56(sp)
    80003b94:	7a42                	ld	s4,48(sp)
    80003b96:	7aa2                	ld	s5,40(sp)
    80003b98:	7b02                	ld	s6,32(sp)
    80003b9a:	6be2                	ld	s7,24(sp)
    80003b9c:	6125                	addi	sp,sp,96
    80003b9e:	8082                	ret

0000000080003ba0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003ba0:	711d                	addi	sp,sp,-96
    80003ba2:	ec86                	sd	ra,88(sp)
    80003ba4:	e8a2                	sd	s0,80(sp)
    80003ba6:	e4a6                	sd	s1,72(sp)
    80003ba8:	e0ca                	sd	s2,64(sp)
    80003baa:	fc4e                	sd	s3,56(sp)
    80003bac:	f852                	sd	s4,48(sp)
    80003bae:	f456                	sd	s5,40(sp)
    80003bb0:	f05a                	sd	s6,32(sp)
    80003bb2:	ec5e                	sd	s7,24(sp)
    80003bb4:	e862                	sd	s8,16(sp)
    80003bb6:	e466                	sd	s9,8(sp)
    80003bb8:	e06a                	sd	s10,0(sp)
    80003bba:	1080                	addi	s0,sp,96
    80003bbc:	84aa                	mv	s1,a0
    80003bbe:	8b2e                	mv	s6,a1
    80003bc0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003bc2:	00054703          	lbu	a4,0(a0)
    80003bc6:	02f00793          	li	a5,47
    80003bca:	00f70f63          	beq	a4,a5,80003be8 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003bce:	d2ffd0ef          	jal	800018fc <myproc>
    80003bd2:	15053503          	ld	a0,336(a0)
    80003bd6:	901ff0ef          	jal	800034d6 <idup>
    80003bda:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003bdc:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003be0:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003be2:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003be4:	4b85                	li	s7,1
    80003be6:	a07d                	j	80003c94 <namex+0xf4>
    ip = iget(ROOTDEV, ROOTINO);
    80003be8:	4585                	li	a1,1
    80003bea:	852e                	mv	a0,a1
    80003bec:	eaeff0ef          	jal	8000329a <iget>
    80003bf0:	8a2a                	mv	s4,a0
    80003bf2:	b7ed                	j	80003bdc <namex+0x3c>
      iunlockput(ip);
    80003bf4:	8552                	mv	a0,s4
    80003bf6:	b6bff0ef          	jal	80003760 <iunlockput>
      return 0;
    80003bfa:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003bfc:	8552                	mv	a0,s4
    80003bfe:	60e6                	ld	ra,88(sp)
    80003c00:	6446                	ld	s0,80(sp)
    80003c02:	64a6                	ld	s1,72(sp)
    80003c04:	6906                	ld	s2,64(sp)
    80003c06:	79e2                	ld	s3,56(sp)
    80003c08:	7a42                	ld	s4,48(sp)
    80003c0a:	7aa2                	ld	s5,40(sp)
    80003c0c:	7b02                	ld	s6,32(sp)
    80003c0e:	6be2                	ld	s7,24(sp)
    80003c10:	6c42                	ld	s8,16(sp)
    80003c12:	6ca2                	ld	s9,8(sp)
    80003c14:	6d02                	ld	s10,0(sp)
    80003c16:	6125                	addi	sp,sp,96
    80003c18:	8082                	ret
      iunlockput(ip);
    80003c1a:	8552                	mv	a0,s4
    80003c1c:	b45ff0ef          	jal	80003760 <iunlockput>
      return 0;
    80003c20:	4a01                	li	s4,0
    80003c22:	bfe9                	j	80003bfc <namex+0x5c>
      iunlock(ip);
    80003c24:	8552                	mv	a0,s4
    80003c26:	995ff0ef          	jal	800035ba <iunlock>
      return ip;
    80003c2a:	bfc9                	j	80003bfc <namex+0x5c>
      iunlockput(ip);
    80003c2c:	8552                	mv	a0,s4
    80003c2e:	b33ff0ef          	jal	80003760 <iunlockput>
      return 0;
    80003c32:	8a4a                	mv	s4,s2
    80003c34:	b7e1                	j	80003bfc <namex+0x5c>
  len = path - s;
    80003c36:	40990633          	sub	a2,s2,s1
    80003c3a:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003c3e:	09ac5763          	bge	s8,s10,80003ccc <namex+0x12c>
    memmove(name, s, DIRSIZ);
    80003c42:	8666                	mv	a2,s9
    80003c44:	85a6                	mv	a1,s1
    80003c46:	8556                	mv	a0,s5
    80003c48:	8c0fd0ef          	jal	80000d08 <memmove>
    80003c4c:	84ca                	mv	s1,s2
  while (*path == '/')
    80003c4e:	0004c783          	lbu	a5,0(s1)
    80003c52:	01379763          	bne	a5,s3,80003c60 <namex+0xc0>
    path++;
    80003c56:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003c58:	0004c783          	lbu	a5,0(s1)
    80003c5c:	ff378de3          	beq	a5,s3,80003c56 <namex+0xb6>
    ilock(ip);
    80003c60:	8552                	mv	a0,s4
    80003c62:	8abff0ef          	jal	8000350c <ilock>
    if (ip->type != T_DIR) {
    80003c66:	044a1783          	lh	a5,68(s4)
    80003c6a:	f97795e3          	bne	a5,s7,80003bf4 <namex+0x54>
    if (ip->nlink == 0) {
    80003c6e:	04aa1783          	lh	a5,74(s4)
    80003c72:	d7c5                	beqz	a5,80003c1a <namex+0x7a>
    if (nameiparent && *path == '\0') {
    80003c74:	000b0563          	beqz	s6,80003c7e <namex+0xde>
    80003c78:	0004c783          	lbu	a5,0(s1)
    80003c7c:	d7c5                	beqz	a5,80003c24 <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003c7e:	4601                	li	a2,0
    80003c80:	85d6                	mv	a1,s5
    80003c82:	8552                	mv	a0,s4
    80003c84:	e71ff0ef          	jal	80003af4 <dirlookup>
    80003c88:	892a                	mv	s2,a0
    80003c8a:	d14d                	beqz	a0,80003c2c <namex+0x8c>
    iunlockput(ip);
    80003c8c:	8552                	mv	a0,s4
    80003c8e:	ad3ff0ef          	jal	80003760 <iunlockput>
    ip = next;
    80003c92:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003c94:	0004c783          	lbu	a5,0(s1)
    80003c98:	01379763          	bne	a5,s3,80003ca6 <namex+0x106>
    path++;
    80003c9c:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003c9e:	0004c783          	lbu	a5,0(s1)
    80003ca2:	ff378de3          	beq	a5,s3,80003c9c <namex+0xfc>
  if (*path == 0)
    80003ca6:	cf8d                	beqz	a5,80003ce0 <namex+0x140>
  while (*path != '/' && *path != 0)
    80003ca8:	0004c783          	lbu	a5,0(s1)
    80003cac:	fd178713          	addi	a4,a5,-47
    80003cb0:	cb19                	beqz	a4,80003cc6 <namex+0x126>
    80003cb2:	cb91                	beqz	a5,80003cc6 <namex+0x126>
    80003cb4:	8926                	mv	s2,s1
    path++;
    80003cb6:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003cb8:	00094783          	lbu	a5,0(s2)
    80003cbc:	fd178713          	addi	a4,a5,-47
    80003cc0:	db3d                	beqz	a4,80003c36 <namex+0x96>
    80003cc2:	fbf5                	bnez	a5,80003cb6 <namex+0x116>
    80003cc4:	bf8d                	j	80003c36 <namex+0x96>
    80003cc6:	8926                	mv	s2,s1
  len = path - s;
    80003cc8:	4d01                	li	s10,0
    80003cca:	4601                	li	a2,0
    memmove(name, s, len);
    80003ccc:	2601                	sext.w	a2,a2
    80003cce:	85a6                	mv	a1,s1
    80003cd0:	8556                	mv	a0,s5
    80003cd2:	836fd0ef          	jal	80000d08 <memmove>
    name[len] = 0;
    80003cd6:	9d56                	add	s10,s10,s5
    80003cd8:	000d0023          	sb	zero,0(s10)
    80003cdc:	84ca                	mv	s1,s2
    80003cde:	bf85                	j	80003c4e <namex+0xae>
  if (nameiparent) {
    80003ce0:	f00b0ee3          	beqz	s6,80003bfc <namex+0x5c>
    iput(ip);
    80003ce4:	8552                	mv	a0,s4
    80003ce6:	9a9ff0ef          	jal	8000368e <iput>
    return 0;
    80003cea:	4a01                	li	s4,0
    80003cec:	bf01                	j	80003bfc <namex+0x5c>

0000000080003cee <dirlink>:
{
    80003cee:	715d                	addi	sp,sp,-80
    80003cf0:	e486                	sd	ra,72(sp)
    80003cf2:	e0a2                	sd	s0,64(sp)
    80003cf4:	f84a                	sd	s2,48(sp)
    80003cf6:	ec56                	sd	s5,24(sp)
    80003cf8:	e85a                	sd	s6,16(sp)
    80003cfa:	0880                	addi	s0,sp,80
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	8aae                	mv	s5,a1
    80003d00:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003d02:	4601                	li	a2,0
    80003d04:	df1ff0ef          	jal	80003af4 <dirlookup>
    80003d08:	ed1d                	bnez	a0,80003d46 <dirlink+0x58>
    80003d0a:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003d0c:	04c92483          	lw	s1,76(s2)
    80003d10:	c4b9                	beqz	s1,80003d5e <dirlink+0x70>
    80003d12:	f44e                	sd	s3,40(sp)
    80003d14:	f052                	sd	s4,32(sp)
    80003d16:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d18:	fb040a13          	addi	s4,s0,-80
    80003d1c:	49c1                	li	s3,16
    80003d1e:	874e                	mv	a4,s3
    80003d20:	86a6                	mv	a3,s1
    80003d22:	8652                	mv	a2,s4
    80003d24:	4581                	li	a1,0
    80003d26:	854a                	mv	a0,s2
    80003d28:	bbfff0ef          	jal	800038e6 <readi>
    80003d2c:	03351163          	bne	a0,s3,80003d4e <dirlink+0x60>
    if (de.inum == 0)
    80003d30:	fb045783          	lhu	a5,-80(s0)
    80003d34:	c39d                	beqz	a5,80003d5a <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003d36:	24c1                	addiw	s1,s1,16
    80003d38:	04c92783          	lw	a5,76(s2)
    80003d3c:	fef4e1e3          	bltu	s1,a5,80003d1e <dirlink+0x30>
    80003d40:	79a2                	ld	s3,40(sp)
    80003d42:	7a02                	ld	s4,32(sp)
    80003d44:	a829                	j	80003d5e <dirlink+0x70>
    iput(ip);
    80003d46:	949ff0ef          	jal	8000368e <iput>
    return -1;
    80003d4a:	557d                	li	a0,-1
    80003d4c:	a83d                	j	80003d8a <dirlink+0x9c>
      panic("dirlink read");
    80003d4e:	00004517          	auipc	a0,0x4
    80003d52:	8b250513          	addi	a0,a0,-1870 # 80007600 <etext+0x600>
    80003d56:	adffc0ef          	jal	80000834 <panic>
    80003d5a:	79a2                	ld	s3,40(sp)
    80003d5c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003d5e:	4639                	li	a2,14
    80003d60:	85d6                	mv	a1,s5
    80003d62:	fb240513          	addi	a0,s0,-78
    80003d66:	850fd0ef          	jal	80000db6 <strncpy>
  de.inum = inum;
    80003d6a:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d6e:	4741                	li	a4,16
    80003d70:	86a6                	mv	a3,s1
    80003d72:	fb040613          	addi	a2,s0,-80
    80003d76:	4581                	li	a1,0
    80003d78:	854a                	mv	a0,s2
    80003d7a:	c5fff0ef          	jal	800039d8 <writei>
    80003d7e:	1541                	addi	a0,a0,-16
    80003d80:	00a03533          	snez	a0,a0
    80003d84:	40a0053b          	negw	a0,a0
    80003d88:	74e2                	ld	s1,56(sp)
}
    80003d8a:	60a6                	ld	ra,72(sp)
    80003d8c:	6406                	ld	s0,64(sp)
    80003d8e:	7942                	ld	s2,48(sp)
    80003d90:	6ae2                	ld	s5,24(sp)
    80003d92:	6b42                	ld	s6,16(sp)
    80003d94:	6161                	addi	sp,sp,80
    80003d96:	8082                	ret

0000000080003d98 <namei>:

struct inode *
namei(char *path)
{
    80003d98:	1101                	addi	sp,sp,-32
    80003d9a:	ec06                	sd	ra,24(sp)
    80003d9c:	e822                	sd	s0,16(sp)
    80003d9e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003da0:	fe040613          	addi	a2,s0,-32
    80003da4:	4581                	li	a1,0
    80003da6:	dfbff0ef          	jal	80003ba0 <namex>
}
    80003daa:	60e2                	ld	ra,24(sp)
    80003dac:	6442                	ld	s0,16(sp)
    80003dae:	6105                	addi	sp,sp,32
    80003db0:	8082                	ret

0000000080003db2 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003db2:	1141                	addi	sp,sp,-16
    80003db4:	e406                	sd	ra,8(sp)
    80003db6:	e022                	sd	s0,0(sp)
    80003db8:	0800                	addi	s0,sp,16
    80003dba:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003dbc:	4585                	li	a1,1
    80003dbe:	de3ff0ef          	jal	80003ba0 <namex>
}
    80003dc2:	60a2                	ld	ra,8(sp)
    80003dc4:	6402                	ld	s0,0(sp)
    80003dc6:	0141                	addi	sp,sp,16
    80003dc8:	8082                	ret

0000000080003dca <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003dca:	1101                	addi	sp,sp,-32
    80003dcc:	ec06                	sd	ra,24(sp)
    80003dce:	e822                	sd	s0,16(sp)
    80003dd0:	e426                	sd	s1,8(sp)
    80003dd2:	e04a                	sd	s2,0(sp)
    80003dd4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003dd6:	0001f917          	auipc	s2,0x1f
    80003dda:	f8a90913          	addi	s2,s2,-118 # 80022d60 <log>
    80003dde:	01892583          	lw	a1,24(s2)
    80003de2:	02492503          	lw	a0,36(s2)
    80003de6:	88eff0ef          	jal	80002e74 <bread>
    80003dea:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003dec:	02c92603          	lw	a2,44(s2)
    80003df0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003df2:	00c05f63          	blez	a2,80003e10 <write_head+0x46>
    80003df6:	0001f717          	auipc	a4,0x1f
    80003dfa:	f9a70713          	addi	a4,a4,-102 # 80022d90 <log+0x30>
    80003dfe:	87aa                	mv	a5,a0
    80003e00:	060a                	slli	a2,a2,0x2
    80003e02:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003e04:	4314                	lw	a3,0(a4)
    80003e06:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003e08:	0711                	addi	a4,a4,4
    80003e0a:	0791                	addi	a5,a5,4
    80003e0c:	fec79ce3          	bne	a5,a2,80003e04 <write_head+0x3a>
  }
  bwrite(buf);
    80003e10:	8526                	mv	a0,s1
    80003e12:	938ff0ef          	jal	80002f4a <bwrite>
  brelse(buf);
    80003e16:	8526                	mv	a0,s1
    80003e18:	964ff0ef          	jal	80002f7c <brelse>
}
    80003e1c:	60e2                	ld	ra,24(sp)
    80003e1e:	6442                	ld	s0,16(sp)
    80003e20:	64a2                	ld	s1,8(sp)
    80003e22:	6902                	ld	s2,0(sp)
    80003e24:	6105                	addi	sp,sp,32
    80003e26:	8082                	ret

0000000080003e28 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e28:	0001f797          	auipc	a5,0x1f
    80003e2c:	f647a783          	lw	a5,-156(a5) # 80022d8c <log+0x2c>
    80003e30:	0cf05163          	blez	a5,80003ef2 <install_trans+0xca>
{
    80003e34:	715d                	addi	sp,sp,-80
    80003e36:	e486                	sd	ra,72(sp)
    80003e38:	e0a2                	sd	s0,64(sp)
    80003e3a:	fc26                	sd	s1,56(sp)
    80003e3c:	f84a                	sd	s2,48(sp)
    80003e3e:	f44e                	sd	s3,40(sp)
    80003e40:	f052                	sd	s4,32(sp)
    80003e42:	ec56                	sd	s5,24(sp)
    80003e44:	e85a                	sd	s6,16(sp)
    80003e46:	e45e                	sd	s7,8(sp)
    80003e48:	e062                	sd	s8,0(sp)
    80003e4a:	0880                	addi	s0,sp,80
    80003e4c:	8b2a                	mv	s6,a0
    80003e4e:	0001fa97          	auipc	s5,0x1f
    80003e52:	f42a8a93          	addi	s5,s5,-190 # 80022d90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e56:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003e58:	00003c17          	auipc	s8,0x3
    80003e5c:	7b8c0c13          	addi	s8,s8,1976 # 80007610 <etext+0x610>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003e60:	0001fa17          	auipc	s4,0x1f
    80003e64:	f00a0a13          	addi	s4,s4,-256 # 80022d60 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003e68:	40000b93          	li	s7,1024
    80003e6c:	a025                	j	80003e94 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003e6e:	000aa603          	lw	a2,0(s5)
    80003e72:	85ce                	mv	a1,s3
    80003e74:	8562                	mv	a0,s8
    80003e76:	e94fc0ef          	jal	8000050a <printk>
    80003e7a:	a839                	j	80003e98 <install_trans+0x70>
    brelse(lbuf);
    80003e7c:	854a                	mv	a0,s2
    80003e7e:	8feff0ef          	jal	80002f7c <brelse>
    brelse(dbuf);
    80003e82:	8526                	mv	a0,s1
    80003e84:	8f8ff0ef          	jal	80002f7c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e88:	2985                	addiw	s3,s3,1
    80003e8a:	0a91                	addi	s5,s5,4
    80003e8c:	02ca2783          	lw	a5,44(s4)
    80003e90:	04f9d563          	bge	s3,a5,80003eda <install_trans+0xb2>
    if (recovering) {
    80003e94:	fc0b1de3          	bnez	s6,80003e6e <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003e98:	018a2583          	lw	a1,24(s4)
    80003e9c:	013585bb          	addw	a1,a1,s3
    80003ea0:	2585                	addiw	a1,a1,1
    80003ea2:	024a2503          	lw	a0,36(s4)
    80003ea6:	fcffe0ef          	jal	80002e74 <bread>
    80003eaa:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003eac:	000aa583          	lw	a1,0(s5)
    80003eb0:	024a2503          	lw	a0,36(s4)
    80003eb4:	fc1fe0ef          	jal	80002e74 <bread>
    80003eb8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003eba:	865e                	mv	a2,s7
    80003ebc:	05890593          	addi	a1,s2,88
    80003ec0:	05850513          	addi	a0,a0,88
    80003ec4:	e45fc0ef          	jal	80000d08 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003ec8:	8526                	mv	a0,s1
    80003eca:	880ff0ef          	jal	80002f4a <bwrite>
    if (recovering == 0)
    80003ece:	fa0b17e3          	bnez	s6,80003e7c <install_trans+0x54>
      bunpin(dbuf);
    80003ed2:	8526                	mv	a0,s1
    80003ed4:	960ff0ef          	jal	80003034 <bunpin>
    80003ed8:	b755                	j	80003e7c <install_trans+0x54>
}
    80003eda:	60a6                	ld	ra,72(sp)
    80003edc:	6406                	ld	s0,64(sp)
    80003ede:	74e2                	ld	s1,56(sp)
    80003ee0:	7942                	ld	s2,48(sp)
    80003ee2:	79a2                	ld	s3,40(sp)
    80003ee4:	7a02                	ld	s4,32(sp)
    80003ee6:	6ae2                	ld	s5,24(sp)
    80003ee8:	6b42                	ld	s6,16(sp)
    80003eea:	6ba2                	ld	s7,8(sp)
    80003eec:	6c02                	ld	s8,0(sp)
    80003eee:	6161                	addi	sp,sp,80
    80003ef0:	8082                	ret
    80003ef2:	8082                	ret

0000000080003ef4 <initlog>:
{
    80003ef4:	7179                	addi	sp,sp,-48
    80003ef6:	f406                	sd	ra,40(sp)
    80003ef8:	f022                	sd	s0,32(sp)
    80003efa:	ec26                	sd	s1,24(sp)
    80003efc:	e84a                	sd	s2,16(sp)
    80003efe:	e44e                	sd	s3,8(sp)
    80003f00:	1800                	addi	s0,sp,48
    80003f02:	84aa                	mv	s1,a0
    80003f04:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f06:	0001f917          	auipc	s2,0x1f
    80003f0a:	e5a90913          	addi	s2,s2,-422 # 80022d60 <log>
    80003f0e:	00003597          	auipc	a1,0x3
    80003f12:	72258593          	addi	a1,a1,1826 # 80007630 <etext+0x630>
    80003f16:	854a                	mv	a0,s2
    80003f18:	c51fc0ef          	jal	80000b68 <initlock>
  log.start = sb->logstart;
    80003f1c:	0149a583          	lw	a1,20(s3)
    80003f20:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003f24:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003f28:	8526                	mv	a0,s1
    80003f2a:	f4bfe0ef          	jal	80002e74 <bread>
  log.lh.n = lh->n;
    80003f2e:	4d30                	lw	a2,88(a0)
    80003f30:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003f34:	00c05f63          	blez	a2,80003f52 <initlog+0x5e>
    80003f38:	87aa                	mv	a5,a0
    80003f3a:	0001f717          	auipc	a4,0x1f
    80003f3e:	e5670713          	addi	a4,a4,-426 # 80022d90 <log+0x30>
    80003f42:	060a                	slli	a2,a2,0x2
    80003f44:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003f46:	4ff4                	lw	a3,92(a5)
    80003f48:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f4a:	0791                	addi	a5,a5,4
    80003f4c:	0711                	addi	a4,a4,4
    80003f4e:	fec79ce3          	bne	a5,a2,80003f46 <initlog+0x52>
  brelse(buf);
    80003f52:	82aff0ef          	jal	80002f7c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003f56:	4505                	li	a0,1
    80003f58:	ed1ff0ef          	jal	80003e28 <install_trans>
  log.lh.n = 0;
    80003f5c:	0001f797          	auipc	a5,0x1f
    80003f60:	e207a823          	sw	zero,-464(a5) # 80022d8c <log+0x2c>
  write_head(); // clear the log
    80003f64:	e67ff0ef          	jal	80003dca <write_head>
}
    80003f68:	70a2                	ld	ra,40(sp)
    80003f6a:	7402                	ld	s0,32(sp)
    80003f6c:	64e2                	ld	s1,24(sp)
    80003f6e:	6942                	ld	s2,16(sp)
    80003f70:	69a2                	ld	s3,8(sp)
    80003f72:	6145                	addi	sp,sp,48
    80003f74:	8082                	ret

0000000080003f76 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003f76:	1101                	addi	sp,sp,-32
    80003f78:	ec06                	sd	ra,24(sp)
    80003f7a:	e822                	sd	s0,16(sp)
    80003f7c:	e426                	sd	s1,8(sp)
    80003f7e:	e04a                	sd	s2,0(sp)
    80003f80:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003f82:	0001f517          	auipc	a0,0x1f
    80003f86:	dde50513          	addi	a0,a0,-546 # 80022d60 <log>
    80003f8a:	c5ffc0ef          	jal	80000be8 <acquire>
  while (1) {
    if (log.committing) {
    80003f8e:	0001f497          	auipc	s1,0x1f
    80003f92:	dd248493          	addi	s1,s1,-558 # 80022d60 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003f96:	4979                	li	s2,30
    80003f98:	a821                	j	80003fb0 <begin_op+0x3a>
      sleep_prepare(&log);
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	994fe0ef          	jal	80002130 <sleep_prepare>
      release(&log.lock);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	ccffc0ef          	jal	80000c70 <release>
      sleep();
    80003fa6:	9c6fe0ef          	jal	8000216c <sleep>
      acquire(&log.lock);
    80003faa:	8526                	mv	a0,s1
    80003fac:	c3dfc0ef          	jal	80000be8 <acquire>
    if (log.committing) {
    80003fb0:	509c                	lw	a5,32(s1)
    80003fb2:	f7e5                	bnez	a5,80003f9a <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003fb4:	4cd8                	lw	a4,28(s1)
    80003fb6:	2705                	addiw	a4,a4,1
    80003fb8:	0027179b          	slliw	a5,a4,0x2
    80003fbc:	9fb9                	addw	a5,a5,a4
    80003fbe:	0017979b          	slliw	a5,a5,0x1
    80003fc2:	54d4                	lw	a3,44(s1)
    80003fc4:	9fb5                	addw	a5,a5,a3
    80003fc6:	00f95e63          	bge	s2,a5,80003fe2 <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	964fe0ef          	jal	80002130 <sleep_prepare>
      release(&log.lock);
    80003fd0:	8526                	mv	a0,s1
    80003fd2:	c9ffc0ef          	jal	80000c70 <release>
      sleep();
    80003fd6:	996fe0ef          	jal	8000216c <sleep>
      acquire(&log.lock);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	c0dfc0ef          	jal	80000be8 <acquire>
    80003fe0:	bfc1                	j	80003fb0 <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80003fe2:	0001f797          	auipc	a5,0x1f
    80003fe6:	d8e7ad23          	sw	a4,-614(a5) # 80022d7c <log+0x1c>
      release(&log.lock);
    80003fea:	0001f517          	auipc	a0,0x1f
    80003fee:	d7650513          	addi	a0,a0,-650 # 80022d60 <log>
    80003ff2:	c7ffc0ef          	jal	80000c70 <release>
      break;
    }
  }
}
    80003ff6:	60e2                	ld	ra,24(sp)
    80003ff8:	6442                	ld	s0,16(sp)
    80003ffa:	64a2                	ld	s1,8(sp)
    80003ffc:	6902                	ld	s2,0(sp)
    80003ffe:	6105                	addi	sp,sp,32
    80004000:	8082                	ret

0000000080004002 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004002:	7139                	addi	sp,sp,-64
    80004004:	fc06                	sd	ra,56(sp)
    80004006:	f822                	sd	s0,48(sp)
    80004008:	f426                	sd	s1,40(sp)
    8000400a:	f04a                	sd	s2,32(sp)
    8000400c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000400e:	0001f497          	auipc	s1,0x1f
    80004012:	d5248493          	addi	s1,s1,-686 # 80022d60 <log>
    80004016:	8526                	mv	a0,s1
    80004018:	bd1fc0ef          	jal	80000be8 <acquire>
  log.outstanding -= 1;
    8000401c:	4cdc                	lw	a5,28(s1)
    8000401e:	37fd                	addiw	a5,a5,-1
    80004020:	893e                	mv	s2,a5
    80004022:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80004024:	509c                	lw	a5,32(s1)
    80004026:	e3b1                	bnez	a5,8000406a <end_op+0x68>
    panic("log.committing");
  if (log.outstanding == 0) {
    80004028:	04091a63          	bnez	s2,8000407c <end_op+0x7a>
    do_commit = 1;
    log.committing = 1;
    8000402c:	0001f497          	auipc	s1,0x1f
    80004030:	d3448493          	addi	s1,s1,-716 # 80022d60 <log>
    80004034:	4785                	li	a5,1
    80004036:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004038:	8526                	mv	a0,s1
    8000403a:	c37fc0ef          	jal	80000c70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000403e:	54dc                	lw	a5,44(s1)
    80004040:	06f04063          	bgtz	a5,800040a0 <end_op+0x9e>
    acquire(&log.lock);
    80004044:	0001f497          	auipc	s1,0x1f
    80004048:	d1c48493          	addi	s1,s1,-740 # 80022d60 <log>
    8000404c:	8526                	mv	a0,s1
    8000404e:	b9bfc0ef          	jal	80000be8 <acquire>
    log.committing = 0;
    80004052:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80004056:	549c                	lw	a5,40(s1)
    80004058:	2785                	addiw	a5,a5,1
    8000405a:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    8000405c:	8526                	mv	a0,s1
    8000405e:	956fe0ef          	jal	800021b4 <wakeup>
    release(&log.lock);
    80004062:	8526                	mv	a0,s1
    80004064:	c0dfc0ef          	jal	80000c70 <release>
}
    80004068:	a035                	j	80004094 <end_op+0x92>
    8000406a:	ec4e                	sd	s3,24(sp)
    8000406c:	e852                	sd	s4,16(sp)
    8000406e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004070:	00003517          	auipc	a0,0x3
    80004074:	5c850513          	addi	a0,a0,1480 # 80007638 <etext+0x638>
    80004078:	fbcfc0ef          	jal	80000834 <panic>
    wakeup(&log);
    8000407c:	0001f517          	auipc	a0,0x1f
    80004080:	ce450513          	addi	a0,a0,-796 # 80022d60 <log>
    80004084:	930fe0ef          	jal	800021b4 <wakeup>
  release(&log.lock);
    80004088:	0001f517          	auipc	a0,0x1f
    8000408c:	cd850513          	addi	a0,a0,-808 # 80022d60 <log>
    80004090:	be1fc0ef          	jal	80000c70 <release>
}
    80004094:	70e2                	ld	ra,56(sp)
    80004096:	7442                	ld	s0,48(sp)
    80004098:	74a2                	ld	s1,40(sp)
    8000409a:	7902                	ld	s2,32(sp)
    8000409c:	6121                	addi	sp,sp,64
    8000409e:	8082                	ret
    800040a0:	ec4e                	sd	s3,24(sp)
    800040a2:	e852                	sd	s4,16(sp)
    800040a4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800040a6:	0001fa97          	auipc	s5,0x1f
    800040aa:	ceaa8a93          	addi	s5,s5,-790 # 80022d90 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    800040ae:	0001fa17          	auipc	s4,0x1f
    800040b2:	cb2a0a13          	addi	s4,s4,-846 # 80022d60 <log>
    800040b6:	018a2583          	lw	a1,24(s4)
    800040ba:	012585bb          	addw	a1,a1,s2
    800040be:	2585                	addiw	a1,a1,1
    800040c0:	024a2503          	lw	a0,36(s4)
    800040c4:	db1fe0ef          	jal	80002e74 <bread>
    800040c8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800040ca:	000aa583          	lw	a1,0(s5)
    800040ce:	024a2503          	lw	a0,36(s4)
    800040d2:	da3fe0ef          	jal	80002e74 <bread>
    800040d6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800040d8:	40000613          	li	a2,1024
    800040dc:	05850593          	addi	a1,a0,88
    800040e0:	05848513          	addi	a0,s1,88
    800040e4:	c25fc0ef          	jal	80000d08 <memmove>
    bwrite(to); // write the log
    800040e8:	8526                	mv	a0,s1
    800040ea:	e61fe0ef          	jal	80002f4a <bwrite>
    brelse(from);
    800040ee:	854e                	mv	a0,s3
    800040f0:	e8dfe0ef          	jal	80002f7c <brelse>
    brelse(to);
    800040f4:	8526                	mv	a0,s1
    800040f6:	e87fe0ef          	jal	80002f7c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040fa:	2905                	addiw	s2,s2,1
    800040fc:	0a91                	addi	s5,s5,4
    800040fe:	02ca2783          	lw	a5,44(s4)
    80004102:	faf94ae3          	blt	s2,a5,800040b6 <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80004106:	cc5ff0ef          	jal	80003dca <write_head>
    install_trans(0); // Now install writes to home locations
    8000410a:	4501                	li	a0,0
    8000410c:	d1dff0ef          	jal	80003e28 <install_trans>
    log.lh.n = 0;
    80004110:	0001f797          	auipc	a5,0x1f
    80004114:	c607ae23          	sw	zero,-900(a5) # 80022d8c <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004118:	cb3ff0ef          	jal	80003dca <write_head>
    8000411c:	69e2                	ld	s3,24(sp)
    8000411e:	6a42                	ld	s4,16(sp)
    80004120:	6aa2                	ld	s5,8(sp)
    80004122:	b70d                	j	80004044 <end_op+0x42>

0000000080004124 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004124:	1101                	addi	sp,sp,-32
    80004126:	ec06                	sd	ra,24(sp)
    80004128:	e822                	sd	s0,16(sp)
    8000412a:	e426                	sd	s1,8(sp)
    8000412c:	1000                	addi	s0,sp,32
    8000412e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004130:	0001f517          	auipc	a0,0x1f
    80004134:	c3050513          	addi	a0,a0,-976 # 80022d60 <log>
    80004138:	ab1fc0ef          	jal	80000be8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000413c:	0001f617          	auipc	a2,0x1f
    80004140:	c5062603          	lw	a2,-944(a2) # 80022d8c <log+0x2c>
    80004144:	47f5                	li	a5,29
    80004146:	04c7cd63          	blt	a5,a2,800041a0 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000414a:	0001f797          	auipc	a5,0x1f
    8000414e:	c327a783          	lw	a5,-974(a5) # 80022d7c <log+0x1c>
    80004152:	04f05d63          	blez	a5,800041ac <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004156:	4781                	li	a5,0
    80004158:	06c05063          	blez	a2,800041b8 <log_write+0x94>
    if (log.lh.block[i] == b->blockno) // log absorption
    8000415c:	44cc                	lw	a1,12(s1)
    8000415e:	0001f717          	auipc	a4,0x1f
    80004162:	c3270713          	addi	a4,a4,-974 # 80022d90 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004166:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80004168:	4314                	lw	a3,0(a4)
    8000416a:	04b68763          	beq	a3,a1,800041b8 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    8000416e:	2785                	addiw	a5,a5,1
    80004170:	0711                	addi	a4,a4,4
    80004172:	fef61be3          	bne	a2,a5,80004168 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004176:	060a                	slli	a2,a2,0x2
    80004178:	02060613          	addi	a2,a2,32
    8000417c:	0001f797          	auipc	a5,0x1f
    80004180:	be478793          	addi	a5,a5,-1052 # 80022d60 <log>
    80004184:	97b2                	add	a5,a5,a2
    80004186:	44d8                	lw	a4,12(s1)
    80004188:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    8000418a:	8526                	mv	a0,s1
    8000418c:	e75fe0ef          	jal	80003000 <bpin>
    log.lh.n++;
    80004190:	0001f717          	auipc	a4,0x1f
    80004194:	bd070713          	addi	a4,a4,-1072 # 80022d60 <log>
    80004198:	575c                	lw	a5,44(a4)
    8000419a:	2785                	addiw	a5,a5,1
    8000419c:	d75c                	sw	a5,44(a4)
    8000419e:	a815                	j	800041d2 <log_write+0xae>
    panic("too big a transaction");
    800041a0:	00003517          	auipc	a0,0x3
    800041a4:	4a850513          	addi	a0,a0,1192 # 80007648 <etext+0x648>
    800041a8:	e8cfc0ef          	jal	80000834 <panic>
    panic("log_write outside of trans");
    800041ac:	00003517          	auipc	a0,0x3
    800041b0:	4b450513          	addi	a0,a0,1204 # 80007660 <etext+0x660>
    800041b4:	e80fc0ef          	jal	80000834 <panic>
  log.lh.block[i] = b->blockno;
    800041b8:	00279693          	slli	a3,a5,0x2
    800041bc:	02068693          	addi	a3,a3,32
    800041c0:	0001f717          	auipc	a4,0x1f
    800041c4:	ba070713          	addi	a4,a4,-1120 # 80022d60 <log>
    800041c8:	9736                	add	a4,a4,a3
    800041ca:	44d4                	lw	a3,12(s1)
    800041cc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    800041ce:	faf60ee3          	beq	a2,a5,8000418a <log_write+0x66>
  }
  release(&log.lock);
    800041d2:	0001f517          	auipc	a0,0x1f
    800041d6:	b8e50513          	addi	a0,a0,-1138 # 80022d60 <log>
    800041da:	a97fc0ef          	jal	80000c70 <release>
}
    800041de:	60e2                	ld	ra,24(sp)
    800041e0:	6442                	ld	s0,16(sp)
    800041e2:	64a2                	ld	s1,8(sp)
    800041e4:	6105                	addi	sp,sp,32
    800041e6:	8082                	ret

00000000800041e8 <sys_sync>:

uint64
sys_sync(void)
{
    800041e8:	1101                	addi	sp,sp,-32
    800041ea:	ec06                	sd	ra,24(sp)
    800041ec:	e822                	sd	s0,16(sp)
    800041ee:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800041f0:	0001f517          	auipc	a0,0x1f
    800041f4:	b7050513          	addi	a0,a0,-1168 # 80022d60 <log>
    800041f8:	9f1fc0ef          	jal	80000be8 <acquire>
  if (log.committing || log.outstanding > 0) {
    800041fc:	0001f797          	auipc	a5,0x1f
    80004200:	b847a783          	lw	a5,-1148(a5) # 80022d80 <log+0x20>
    80004204:	e799                	bnez	a5,80004212 <sys_sync+0x2a>
    80004206:	0001f797          	auipc	a5,0x1f
    8000420a:	b767a783          	lw	a5,-1162(a5) # 80022d7c <log+0x1c>
    8000420e:	02f05c63          	blez	a5,80004246 <sys_sync+0x5e>
    80004212:	e426                	sd	s1,8(sp)
    80004214:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80004216:	0001f917          	auipc	s2,0x1f
    8000421a:	b7292903          	lw	s2,-1166(s2) # 80022d88 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    8000421e:	0001f497          	auipc	s1,0x1f
    80004222:	b4248493          	addi	s1,s1,-1214 # 80022d60 <log>
    80004226:	8526                	mv	a0,s1
    80004228:	f09fd0ef          	jal	80002130 <sleep_prepare>
      release(&log.lock);
    8000422c:	8526                	mv	a0,s1
    8000422e:	a43fc0ef          	jal	80000c70 <release>
      sleep();
    80004232:	f3bfd0ef          	jal	8000216c <sleep>
      acquire(&log.lock);
    80004236:	8526                	mv	a0,s1
    80004238:	9b1fc0ef          	jal	80000be8 <acquire>
    while (log.ncommit < n) {
    8000423c:	549c                	lw	a5,40(s1)
    8000423e:	fef954e3          	bge	s2,a5,80004226 <sys_sync+0x3e>
    80004242:	64a2                	ld	s1,8(sp)
    80004244:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80004246:	0001f517          	auipc	a0,0x1f
    8000424a:	b1a50513          	addi	a0,a0,-1254 # 80022d60 <log>
    8000424e:	a23fc0ef          	jal	80000c70 <release>
  return 0;
}
    80004252:	4501                	li	a0,0
    80004254:	60e2                	ld	ra,24(sp)
    80004256:	6442                	ld	s0,16(sp)
    80004258:	6105                	addi	sp,sp,32
    8000425a:	8082                	ret

000000008000425c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000425c:	1101                	addi	sp,sp,-32
    8000425e:	ec06                	sd	ra,24(sp)
    80004260:	e822                	sd	s0,16(sp)
    80004262:	e426                	sd	s1,8(sp)
    80004264:	e04a                	sd	s2,0(sp)
    80004266:	1000                	addi	s0,sp,32
    80004268:	84aa                	mv	s1,a0
    8000426a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000426c:	00003597          	auipc	a1,0x3
    80004270:	41458593          	addi	a1,a1,1044 # 80007680 <etext+0x680>
    80004274:	0521                	addi	a0,a0,8
    80004276:	8f3fc0ef          	jal	80000b68 <initlock>
  lk->name = name;
    8000427a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000427e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004282:	0204a423          	sw	zero,40(s1)
}
    80004286:	60e2                	ld	ra,24(sp)
    80004288:	6442                	ld	s0,16(sp)
    8000428a:	64a2                	ld	s1,8(sp)
    8000428c:	6902                	ld	s2,0(sp)
    8000428e:	6105                	addi	sp,sp,32
    80004290:	8082                	ret

0000000080004292 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004292:	1101                	addi	sp,sp,-32
    80004294:	ec06                	sd	ra,24(sp)
    80004296:	e822                	sd	s0,16(sp)
    80004298:	e426                	sd	s1,8(sp)
    8000429a:	e04a                	sd	s2,0(sp)
    8000429c:	1000                	addi	s0,sp,32
    8000429e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042a0:	00850913          	addi	s2,a0,8
    800042a4:	854a                	mv	a0,s2
    800042a6:	943fc0ef          	jal	80000be8 <acquire>
  while (lk->locked) {
    800042aa:	409c                	lw	a5,0(s1)
    800042ac:	cf91                	beqz	a5,800042c8 <acquiresleep+0x36>
    sleep_prepare(lk);
    800042ae:	8526                	mv	a0,s1
    800042b0:	e81fd0ef          	jal	80002130 <sleep_prepare>
    release(&lk->lk);
    800042b4:	854a                	mv	a0,s2
    800042b6:	9bbfc0ef          	jal	80000c70 <release>
    sleep();
    800042ba:	eb3fd0ef          	jal	8000216c <sleep>
    acquire(&lk->lk);
    800042be:	854a                	mv	a0,s2
    800042c0:	929fc0ef          	jal	80000be8 <acquire>
  while (lk->locked) {
    800042c4:	409c                	lw	a5,0(s1)
    800042c6:	f7e5                	bnez	a5,800042ae <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800042c8:	4785                	li	a5,1
    800042ca:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800042cc:	e30fd0ef          	jal	800018fc <myproc>
    800042d0:	591c                	lw	a5,48(a0)
    800042d2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800042d4:	854a                	mv	a0,s2
    800042d6:	99bfc0ef          	jal	80000c70 <release>
}
    800042da:	60e2                	ld	ra,24(sp)
    800042dc:	6442                	ld	s0,16(sp)
    800042de:	64a2                	ld	s1,8(sp)
    800042e0:	6902                	ld	s2,0(sp)
    800042e2:	6105                	addi	sp,sp,32
    800042e4:	8082                	ret

00000000800042e6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800042e6:	1101                	addi	sp,sp,-32
    800042e8:	ec06                	sd	ra,24(sp)
    800042ea:	e822                	sd	s0,16(sp)
    800042ec:	e426                	sd	s1,8(sp)
    800042ee:	e04a                	sd	s2,0(sp)
    800042f0:	1000                	addi	s0,sp,32
    800042f2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042f4:	00850913          	addi	s2,a0,8
    800042f8:	854a                	mv	a0,s2
    800042fa:	8effc0ef          	jal	80000be8 <acquire>
  lk->locked = 0;
    800042fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004302:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004306:	8526                	mv	a0,s1
    80004308:	eadfd0ef          	jal	800021b4 <wakeup>
  release(&lk->lk);
    8000430c:	854a                	mv	a0,s2
    8000430e:	963fc0ef          	jal	80000c70 <release>
}
    80004312:	60e2                	ld	ra,24(sp)
    80004314:	6442                	ld	s0,16(sp)
    80004316:	64a2                	ld	s1,8(sp)
    80004318:	6902                	ld	s2,0(sp)
    8000431a:	6105                	addi	sp,sp,32
    8000431c:	8082                	ret

000000008000431e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000431e:	7179                	addi	sp,sp,-48
    80004320:	f406                	sd	ra,40(sp)
    80004322:	f022                	sd	s0,32(sp)
    80004324:	ec26                	sd	s1,24(sp)
    80004326:	e84a                	sd	s2,16(sp)
    80004328:	1800                	addi	s0,sp,48
    8000432a:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000432c:	00850913          	addi	s2,a0,8
    80004330:	854a                	mv	a0,s2
    80004332:	8b7fc0ef          	jal	80000be8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004336:	409c                	lw	a5,0(s1)
    80004338:	ef81                	bnez	a5,80004350 <holdingsleep+0x32>
    8000433a:	4481                	li	s1,0
  release(&lk->lk);
    8000433c:	854a                	mv	a0,s2
    8000433e:	933fc0ef          	jal	80000c70 <release>
  return r;
}
    80004342:	8526                	mv	a0,s1
    80004344:	70a2                	ld	ra,40(sp)
    80004346:	7402                	ld	s0,32(sp)
    80004348:	64e2                	ld	s1,24(sp)
    8000434a:	6942                	ld	s2,16(sp)
    8000434c:	6145                	addi	sp,sp,48
    8000434e:	8082                	ret
    80004350:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004352:	0284a983          	lw	s3,40(s1)
    80004356:	da6fd0ef          	jal	800018fc <myproc>
    8000435a:	5904                	lw	s1,48(a0)
    8000435c:	413484b3          	sub	s1,s1,s3
    80004360:	0014b493          	seqz	s1,s1
    80004364:	69a2                	ld	s3,8(sp)
    80004366:	bfd9                	j	8000433c <holdingsleep+0x1e>

0000000080004368 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004368:	1141                	addi	sp,sp,-16
    8000436a:	e406                	sd	ra,8(sp)
    8000436c:	e022                	sd	s0,0(sp)
    8000436e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004370:	00003597          	auipc	a1,0x3
    80004374:	32058593          	addi	a1,a1,800 # 80007690 <etext+0x690>
    80004378:	0001f517          	auipc	a0,0x1f
    8000437c:	b3050513          	addi	a0,a0,-1232 # 80022ea8 <ftable>
    80004380:	fe8fc0ef          	jal	80000b68 <initlock>
}
    80004384:	60a2                	ld	ra,8(sp)
    80004386:	6402                	ld	s0,0(sp)
    80004388:	0141                	addi	sp,sp,16
    8000438a:	8082                	ret

000000008000438c <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    8000438c:	1101                	addi	sp,sp,-32
    8000438e:	ec06                	sd	ra,24(sp)
    80004390:	e822                	sd	s0,16(sp)
    80004392:	e426                	sd	s1,8(sp)
    80004394:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004396:	0001f517          	auipc	a0,0x1f
    8000439a:	b1250513          	addi	a0,a0,-1262 # 80022ea8 <ftable>
    8000439e:	84bfc0ef          	jal	80000be8 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800043a2:	0001f497          	auipc	s1,0x1f
    800043a6:	b1e48493          	addi	s1,s1,-1250 # 80022ec0 <ftable+0x18>
    800043aa:	00020717          	auipc	a4,0x20
    800043ae:	ab670713          	addi	a4,a4,-1354 # 80023e60 <disk>
    if (f->ref == 0) {
    800043b2:	40dc                	lw	a5,4(s1)
    800043b4:	cf89                	beqz	a5,800043ce <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800043b6:	02848493          	addi	s1,s1,40
    800043ba:	fee49ce3          	bne	s1,a4,800043b2 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800043be:	0001f517          	auipc	a0,0x1f
    800043c2:	aea50513          	addi	a0,a0,-1302 # 80022ea8 <ftable>
    800043c6:	8abfc0ef          	jal	80000c70 <release>
  return 0;
    800043ca:	4481                	li	s1,0
    800043cc:	a809                	j	800043de <filealloc+0x52>
      f->ref = 1;
    800043ce:	4785                	li	a5,1
    800043d0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800043d2:	0001f517          	auipc	a0,0x1f
    800043d6:	ad650513          	addi	a0,a0,-1322 # 80022ea8 <ftable>
    800043da:	897fc0ef          	jal	80000c70 <release>
}
    800043de:	8526                	mv	a0,s1
    800043e0:	60e2                	ld	ra,24(sp)
    800043e2:	6442                	ld	s0,16(sp)
    800043e4:	64a2                	ld	s1,8(sp)
    800043e6:	6105                	addi	sp,sp,32
    800043e8:	8082                	ret

00000000800043ea <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    800043ea:	1101                	addi	sp,sp,-32
    800043ec:	ec06                	sd	ra,24(sp)
    800043ee:	e822                	sd	s0,16(sp)
    800043f0:	e426                	sd	s1,8(sp)
    800043f2:	1000                	addi	s0,sp,32
    800043f4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800043f6:	0001f517          	auipc	a0,0x1f
    800043fa:	ab250513          	addi	a0,a0,-1358 # 80022ea8 <ftable>
    800043fe:	feafc0ef          	jal	80000be8 <acquire>
  if (f->ref < 1)
    80004402:	40dc                	lw	a5,4(s1)
    80004404:	02f05063          	blez	a5,80004424 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004408:	2785                	addiw	a5,a5,1
    8000440a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000440c:	0001f517          	auipc	a0,0x1f
    80004410:	a9c50513          	addi	a0,a0,-1380 # 80022ea8 <ftable>
    80004414:	85dfc0ef          	jal	80000c70 <release>
  return f;
}
    80004418:	8526                	mv	a0,s1
    8000441a:	60e2                	ld	ra,24(sp)
    8000441c:	6442                	ld	s0,16(sp)
    8000441e:	64a2                	ld	s1,8(sp)
    80004420:	6105                	addi	sp,sp,32
    80004422:	8082                	ret
    panic("filedup");
    80004424:	00003517          	auipc	a0,0x3
    80004428:	27450513          	addi	a0,a0,628 # 80007698 <etext+0x698>
    8000442c:	c08fc0ef          	jal	80000834 <panic>

0000000080004430 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004430:	7139                	addi	sp,sp,-64
    80004432:	fc06                	sd	ra,56(sp)
    80004434:	f822                	sd	s0,48(sp)
    80004436:	f426                	sd	s1,40(sp)
    80004438:	0080                	addi	s0,sp,64
    8000443a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000443c:	0001f517          	auipc	a0,0x1f
    80004440:	a6c50513          	addi	a0,a0,-1428 # 80022ea8 <ftable>
    80004444:	fa4fc0ef          	jal	80000be8 <acquire>
  if (f->ref < 1)
    80004448:	40dc                	lw	a5,4(s1)
    8000444a:	04f05a63          	blez	a5,8000449e <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    8000444e:	37fd                	addiw	a5,a5,-1
    80004450:	c0dc                	sw	a5,4(s1)
    80004452:	06f04063          	bgtz	a5,800044b2 <fileclose+0x82>
    80004456:	f04a                	sd	s2,32(sp)
    80004458:	ec4e                	sd	s3,24(sp)
    8000445a:	e852                	sd	s4,16(sp)
    8000445c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000445e:	0004a903          	lw	s2,0(s1)
    80004462:	0094c783          	lbu	a5,9(s1)
    80004466:	89be                	mv	s3,a5
    80004468:	689c                	ld	a5,16(s1)
    8000446a:	8a3e                	mv	s4,a5
    8000446c:	6c9c                	ld	a5,24(s1)
    8000446e:	8abe                	mv	s5,a5
  f->ref = 0;
    80004470:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004474:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004478:	0001f517          	auipc	a0,0x1f
    8000447c:	a3050513          	addi	a0,a0,-1488 # 80022ea8 <ftable>
    80004480:	ff0fc0ef          	jal	80000c70 <release>

  if (ff.type == FD_PIPE) {
    80004484:	4785                	li	a5,1
    80004486:	04f90163          	beq	s2,a5,800044c8 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    8000448a:	ffe9079b          	addiw	a5,s2,-2
    8000448e:	4705                	li	a4,1
    80004490:	04f77563          	bgeu	a4,a5,800044da <fileclose+0xaa>
    80004494:	7902                	ld	s2,32(sp)
    80004496:	69e2                	ld	s3,24(sp)
    80004498:	6a42                	ld	s4,16(sp)
    8000449a:	6aa2                	ld	s5,8(sp)
    8000449c:	a00d                	j	800044be <fileclose+0x8e>
    8000449e:	f04a                	sd	s2,32(sp)
    800044a0:	ec4e                	sd	s3,24(sp)
    800044a2:	e852                	sd	s4,16(sp)
    800044a4:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800044a6:	00003517          	auipc	a0,0x3
    800044aa:	1fa50513          	addi	a0,a0,506 # 800076a0 <etext+0x6a0>
    800044ae:	b86fc0ef          	jal	80000834 <panic>
    release(&ftable.lock);
    800044b2:	0001f517          	auipc	a0,0x1f
    800044b6:	9f650513          	addi	a0,a0,-1546 # 80022ea8 <ftable>
    800044ba:	fb6fc0ef          	jal	80000c70 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800044be:	70e2                	ld	ra,56(sp)
    800044c0:	7442                	ld	s0,48(sp)
    800044c2:	74a2                	ld	s1,40(sp)
    800044c4:	6121                	addi	sp,sp,64
    800044c6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800044c8:	85ce                	mv	a1,s3
    800044ca:	8552                	mv	a0,s4
    800044cc:	360000ef          	jal	8000482c <pipeclose>
    800044d0:	7902                	ld	s2,32(sp)
    800044d2:	69e2                	ld	s3,24(sp)
    800044d4:	6a42                	ld	s4,16(sp)
    800044d6:	6aa2                	ld	s5,8(sp)
    800044d8:	b7dd                	j	800044be <fileclose+0x8e>
    begin_op();
    800044da:	a9dff0ef          	jal	80003f76 <begin_op>
    iput(ff.ip);
    800044de:	8556                	mv	a0,s5
    800044e0:	9aeff0ef          	jal	8000368e <iput>
    end_op();
    800044e4:	b1fff0ef          	jal	80004002 <end_op>
    800044e8:	7902                	ld	s2,32(sp)
    800044ea:	69e2                	ld	s3,24(sp)
    800044ec:	6a42                	ld	s4,16(sp)
    800044ee:	6aa2                	ld	s5,8(sp)
    800044f0:	b7f9                	j	800044be <fileclose+0x8e>

00000000800044f2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800044f2:	715d                	addi	sp,sp,-80
    800044f4:	e486                	sd	ra,72(sp)
    800044f6:	e0a2                	sd	s0,64(sp)
    800044f8:	fc26                	sd	s1,56(sp)
    800044fa:	f052                	sd	s4,32(sp)
    800044fc:	0880                	addi	s0,sp,80
    800044fe:	84aa                	mv	s1,a0
    80004500:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004502:	bfafd0ef          	jal	800018fc <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80004506:	409c                	lw	a5,0(s1)
    80004508:	37f9                	addiw	a5,a5,-2
    8000450a:	4705                	li	a4,1
    8000450c:	04f76463          	bltu	a4,a5,80004554 <filestat+0x62>
    80004510:	f84a                	sd	s2,48(sp)
    80004512:	f44e                	sd	s3,40(sp)
    80004514:	892a                	mv	s2,a0
    ilock(f->ip);
    80004516:	6c88                	ld	a0,24(s1)
    80004518:	ff5fe0ef          	jal	8000350c <ilock>
    stati(f->ip, &st);
    8000451c:	fb840993          	addi	s3,s0,-72
    80004520:	85ce                	mv	a1,s3
    80004522:	6c88                	ld	a0,24(s1)
    80004524:	b94ff0ef          	jal	800038b8 <stati>
    iunlock(f->ip);
    80004528:	6c88                	ld	a0,24(s1)
    8000452a:	890ff0ef          	jal	800035ba <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    8000452e:	4761                	li	a4,24
    80004530:	86ce                	mv	a3,s3
    80004532:	8652                	mv	a2,s4
    80004534:	04893583          	ld	a1,72(s2)
    80004538:	05093503          	ld	a0,80(s2)
    8000453c:	806fd0ef          	jal	80001542 <copyout>
    80004540:	41f5551b          	sraiw	a0,a0,0x1f
    80004544:	7942                	ld	s2,48(sp)
    80004546:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004548:	60a6                	ld	ra,72(sp)
    8000454a:	6406                	ld	s0,64(sp)
    8000454c:	74e2                	ld	s1,56(sp)
    8000454e:	7a02                	ld	s4,32(sp)
    80004550:	6161                	addi	sp,sp,80
    80004552:	8082                	ret
  return -1;
    80004554:	557d                	li	a0,-1
    80004556:	bfcd                	j	80004548 <filestat+0x56>

0000000080004558 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004558:	7179                	addi	sp,sp,-48
    8000455a:	f406                	sd	ra,40(sp)
    8000455c:	f022                	sd	s0,32(sp)
    8000455e:	e84a                	sd	s2,16(sp)
    80004560:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    80004562:	00854783          	lbu	a5,8(a0)
    80004566:	c3dd                	beqz	a5,8000460c <fileread+0xb4>
    80004568:	ec26                	sd	s1,24(sp)
    8000456a:	e44e                	sd	s3,8(sp)
    8000456c:	84aa                	mv	s1,a0
    8000456e:	892e                	mv	s2,a1
    80004570:	89b2                	mv	s3,a2
    80004572:	01f6579b          	srliw	a5,a2,0x1f
    80004576:	ebc9                	bnez	a5,80004608 <fileread+0xb0>
    return -1;

  if (f->type == FD_PIPE) {
    80004578:	411c                	lw	a5,0(a0)
    8000457a:	4705                	li	a4,1
    8000457c:	04e78363          	beq	a5,a4,800045c2 <fileread+0x6a>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004580:	470d                	li	a4,3
    80004582:	04e78763          	beq	a5,a4,800045d0 <fileread+0x78>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004586:	4709                	li	a4,2
    80004588:	06e79a63          	bne	a5,a4,800045fc <fileread+0xa4>
    ilock(f->ip);
    8000458c:	6d08                	ld	a0,24(a0)
    8000458e:	f7ffe0ef          	jal	8000350c <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004592:	874e                	mv	a4,s3
    80004594:	5094                	lw	a3,32(s1)
    80004596:	864a                	mv	a2,s2
    80004598:	4585                	li	a1,1
    8000459a:	6c88                	ld	a0,24(s1)
    8000459c:	b4aff0ef          	jal	800038e6 <readi>
    800045a0:	892a                	mv	s2,a0
    800045a2:	00a05563          	blez	a0,800045ac <fileread+0x54>
      f->off += r;
    800045a6:	509c                	lw	a5,32(s1)
    800045a8:	9fa9                	addw	a5,a5,a0
    800045aa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800045ac:	6c88                	ld	a0,24(s1)
    800045ae:	80cff0ef          	jal	800035ba <iunlock>
    800045b2:	64e2                	ld	s1,24(sp)
    800045b4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800045b6:	854a                	mv	a0,s2
    800045b8:	70a2                	ld	ra,40(sp)
    800045ba:	7402                	ld	s0,32(sp)
    800045bc:	6942                	ld	s2,16(sp)
    800045be:	6145                	addi	sp,sp,48
    800045c0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800045c2:	6908                	ld	a0,16(a0)
    800045c4:	3e2000ef          	jal	800049a6 <piperead>
    800045c8:	892a                	mv	s2,a0
    800045ca:	64e2                	ld	s1,24(sp)
    800045cc:	69a2                	ld	s3,8(sp)
    800045ce:	b7e5                	j	800045b6 <fileread+0x5e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800045d0:	02451783          	lh	a5,36(a0)
    800045d4:	03079693          	slli	a3,a5,0x30
    800045d8:	92c1                	srli	a3,a3,0x30
    800045da:	4725                	li	a4,9
    800045dc:	02d76b63          	bltu	a4,a3,80004612 <fileread+0xba>
    800045e0:	0792                	slli	a5,a5,0x4
    800045e2:	0001f717          	auipc	a4,0x1f
    800045e6:	82670713          	addi	a4,a4,-2010 # 80022e08 <devsw>
    800045ea:	97ba                	add	a5,a5,a4
    800045ec:	639c                	ld	a5,0(a5)
    800045ee:	c79d                	beqz	a5,8000461c <fileread+0xc4>
    r = devsw[f->major].read(1, addr, n);
    800045f0:	4505                	li	a0,1
    800045f2:	9782                	jalr	a5
    800045f4:	892a                	mv	s2,a0
    800045f6:	64e2                	ld	s1,24(sp)
    800045f8:	69a2                	ld	s3,8(sp)
    800045fa:	bf75                	j	800045b6 <fileread+0x5e>
    panic("fileread");
    800045fc:	00003517          	auipc	a0,0x3
    80004600:	0b450513          	addi	a0,a0,180 # 800076b0 <etext+0x6b0>
    80004604:	a30fc0ef          	jal	80000834 <panic>
    80004608:	64e2                	ld	s1,24(sp)
    8000460a:	69a2                	ld	s3,8(sp)
    return -1;
    8000460c:	57fd                	li	a5,-1
    8000460e:	893e                	mv	s2,a5
    80004610:	b75d                	j	800045b6 <fileread+0x5e>
      return -1;
    80004612:	57fd                	li	a5,-1
    80004614:	893e                	mv	s2,a5
    80004616:	64e2                	ld	s1,24(sp)
    80004618:	69a2                	ld	s3,8(sp)
    8000461a:	bf71                	j	800045b6 <fileread+0x5e>
    8000461c:	57fd                	li	a5,-1
    8000461e:	893e                	mv	s2,a5
    80004620:	64e2                	ld	s1,24(sp)
    80004622:	69a2                	ld	s3,8(sp)
    80004624:	bf49                	j	800045b6 <fileread+0x5e>

0000000080004626 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    80004626:	00954783          	lbu	a5,9(a0)
    8000462a:	12078b63          	beqz	a5,80004760 <filewrite+0x13a>
{
    8000462e:	711d                	addi	sp,sp,-96
    80004630:	ec86                	sd	ra,88(sp)
    80004632:	e8a2                	sd	s0,80(sp)
    80004634:	e0ca                	sd	s2,64(sp)
    80004636:	f456                	sd	s5,40(sp)
    80004638:	f05a                	sd	s6,32(sp)
    8000463a:	1080                	addi	s0,sp,96
    8000463c:	892a                	mv	s2,a0
    8000463e:	8b2e                	mv	s6,a1
    80004640:	8ab2                	mv	s5,a2
  if (f->writable == 0 || n < 0)
    80004642:	01f6579b          	srliw	a5,a2,0x1f
    80004646:	0e079d63          	bnez	a5,80004740 <filewrite+0x11a>
    return -1;

  if (f->type == FD_PIPE) {
    8000464a:	411c                	lw	a5,0(a0)
    8000464c:	4705                	li	a4,1
    8000464e:	02e78a63          	beq	a5,a4,80004682 <filewrite+0x5c>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004652:	470d                	li	a4,3
    80004654:	02e78b63          	beq	a5,a4,8000468a <filewrite+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004658:	4709                	li	a4,2
    8000465a:	0ce79763          	bne	a5,a4,80004728 <filewrite+0x102>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    8000465e:	0ec05763          	blez	a2,8000474c <filewrite+0x126>
    80004662:	e4a6                	sd	s1,72(sp)
    80004664:	fc4e                	sd	s3,56(sp)
    80004666:	f852                	sd	s4,48(sp)
    80004668:	ec5e                	sd	s7,24(sp)
    8000466a:	e862                	sd	s8,16(sp)
    8000466c:	e466                	sd	s9,8(sp)
    int i = 0;
    8000466e:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    80004670:	6b85                	lui	s7,0x1
    80004672:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004676:	6785                	lui	a5,0x1
    80004678:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000467c:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000467e:	4c05                	li	s8,1
    80004680:	a8ad                	j	800046fa <filewrite+0xd4>
    ret = pipewrite(f->pipe, addr, n);
    80004682:	6908                	ld	a0,16(a0)
    80004684:	206000ef          	jal	8000488a <pipewrite>
    80004688:	a849                	j	8000471a <filewrite+0xf4>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000468a:	02451783          	lh	a5,36(a0)
    8000468e:	03079693          	slli	a3,a5,0x30
    80004692:	92c1                	srli	a3,a3,0x30
    80004694:	4725                	li	a4,9
    80004696:	0ad76763          	bltu	a4,a3,80004744 <filewrite+0x11e>
    8000469a:	0792                	slli	a5,a5,0x4
    8000469c:	0001e717          	auipc	a4,0x1e
    800046a0:	76c70713          	addi	a4,a4,1900 # 80022e08 <devsw>
    800046a4:	97ba                	add	a5,a5,a4
    800046a6:	679c                	ld	a5,8(a5)
    800046a8:	c3c5                	beqz	a5,80004748 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800046aa:	4505                	li	a0,1
    800046ac:	9782                	jalr	a5
    800046ae:	a0b5                	j	8000471a <filewrite+0xf4>
      if (n1 > max)
    800046b0:	2981                	sext.w	s3,s3
      begin_op();
    800046b2:	8c5ff0ef          	jal	80003f76 <begin_op>
      ilock(f->ip);
    800046b6:	01893503          	ld	a0,24(s2)
    800046ba:	e53fe0ef          	jal	8000350c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800046be:	874e                	mv	a4,s3
    800046c0:	02092683          	lw	a3,32(s2)
    800046c4:	016a0633          	add	a2,s4,s6
    800046c8:	85e2                	mv	a1,s8
    800046ca:	01893503          	ld	a0,24(s2)
    800046ce:	b0aff0ef          	jal	800039d8 <writei>
    800046d2:	84aa                	mv	s1,a0
    800046d4:	00a05763          	blez	a0,800046e2 <filewrite+0xbc>
        f->off += r;
    800046d8:	02092783          	lw	a5,32(s2)
    800046dc:	9fa9                	addw	a5,a5,a0
    800046de:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800046e2:	01893503          	ld	a0,24(s2)
    800046e6:	ed5fe0ef          	jal	800035ba <iunlock>
      end_op();
    800046ea:	919ff0ef          	jal	80004002 <end_op>

      if (r != n1) {
    800046ee:	00999d63          	bne	s3,s1,80004708 <filewrite+0xe2>
        // error from writei
        break;
      }
      i += r;
    800046f2:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    800046f6:	015a5963          	bge	s4,s5,80004708 <filewrite+0xe2>
      int n1 = n - i;
    800046fa:	414a87bb          	subw	a5,s5,s4
    800046fe:	89be                	mv	s3,a5
      if (n1 > max)
    80004700:	fafbd8e3          	bge	s7,a5,800046b0 <filewrite+0x8a>
    80004704:	89e6                	mv	s3,s9
    80004706:	b76d                	j	800046b0 <filewrite+0x8a>
    }
    ret = (i == n ? n : -1);
    80004708:	054a9463          	bne	s5,s4,80004750 <filewrite+0x12a>
    8000470c:	8556                	mv	a0,s5
    8000470e:	64a6                	ld	s1,72(sp)
    80004710:	79e2                	ld	s3,56(sp)
    80004712:	7a42                	ld	s4,48(sp)
    80004714:	6be2                	ld	s7,24(sp)
    80004716:	6c42                	ld	s8,16(sp)
    80004718:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000471a:	60e6                	ld	ra,88(sp)
    8000471c:	6446                	ld	s0,80(sp)
    8000471e:	6906                	ld	s2,64(sp)
    80004720:	7aa2                	ld	s5,40(sp)
    80004722:	7b02                	ld	s6,32(sp)
    80004724:	6125                	addi	sp,sp,96
    80004726:	8082                	ret
    80004728:	e4a6                	sd	s1,72(sp)
    8000472a:	fc4e                	sd	s3,56(sp)
    8000472c:	f852                	sd	s4,48(sp)
    8000472e:	ec5e                	sd	s7,24(sp)
    80004730:	e862                	sd	s8,16(sp)
    80004732:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004734:	00003517          	auipc	a0,0x3
    80004738:	f8c50513          	addi	a0,a0,-116 # 800076c0 <etext+0x6c0>
    8000473c:	8f8fc0ef          	jal	80000834 <panic>
    return -1;
    80004740:	557d                	li	a0,-1
    80004742:	bfe1                	j	8000471a <filewrite+0xf4>
      return -1;
    80004744:	557d                	li	a0,-1
    80004746:	bfd1                	j	8000471a <filewrite+0xf4>
    80004748:	557d                	li	a0,-1
    8000474a:	bfc1                	j	8000471a <filewrite+0xf4>
    ret = (i == n ? n : -1);
    8000474c:	8532                	mv	a0,a2
    8000474e:	b7f1                	j	8000471a <filewrite+0xf4>
    80004750:	557d                	li	a0,-1
    80004752:	64a6                	ld	s1,72(sp)
    80004754:	79e2                	ld	s3,56(sp)
    80004756:	7a42                	ld	s4,48(sp)
    80004758:	6be2                	ld	s7,24(sp)
    8000475a:	6c42                	ld	s8,16(sp)
    8000475c:	6ca2                	ld	s9,8(sp)
    8000475e:	bf75                	j	8000471a <filewrite+0xf4>
    return -1;
    80004760:	557d                	li	a0,-1
}
    80004762:	8082                	ret

0000000080004764 <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004764:	7179                	addi	sp,sp,-48
    80004766:	f406                	sd	ra,40(sp)
    80004768:	f022                	sd	s0,32(sp)
    8000476a:	ec26                	sd	s1,24(sp)
    8000476c:	e052                	sd	s4,0(sp)
    8000476e:	1800                	addi	s0,sp,48
    80004770:	84aa                	mv	s1,a0
    80004772:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004774:	0005b023          	sd	zero,0(a1)
    80004778:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000477c:	c11ff0ef          	jal	8000438c <filealloc>
    80004780:	e088                	sd	a0,0(s1)
    80004782:	c549                	beqz	a0,8000480c <pipealloc+0xa8>
    80004784:	c09ff0ef          	jal	8000438c <filealloc>
    80004788:	00aa3023          	sd	a0,0(s4)
    8000478c:	cd25                	beqz	a0,80004804 <pipealloc+0xa0>
    8000478e:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80004790:	b7efc0ef          	jal	80000b0e <kalloc>
    80004794:	892a                	mv	s2,a0
    80004796:	c12d                	beqz	a0,800047f8 <pipealloc+0x94>
    80004798:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000479a:	4985                	li	s3,1
    8000479c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800047a0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800047a4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800047a8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800047ac:	00003597          	auipc	a1,0x3
    800047b0:	f2458593          	addi	a1,a1,-220 # 800076d0 <etext+0x6d0>
    800047b4:	bb4fc0ef          	jal	80000b68 <initlock>
  (*f0)->type = FD_PIPE;
    800047b8:	609c                	ld	a5,0(s1)
    800047ba:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800047be:	609c                	ld	a5,0(s1)
    800047c0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800047c4:	609c                	ld	a5,0(s1)
    800047c6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800047ca:	609c                	ld	a5,0(s1)
    800047cc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800047d0:	000a3783          	ld	a5,0(s4)
    800047d4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800047d8:	000a3783          	ld	a5,0(s4)
    800047dc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800047e0:	000a3783          	ld	a5,0(s4)
    800047e4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800047e8:	000a3783          	ld	a5,0(s4)
    800047ec:	0127b823          	sd	s2,16(a5)
  return 0;
    800047f0:	4501                	li	a0,0
    800047f2:	6942                	ld	s2,16(sp)
    800047f4:	69a2                	ld	s3,8(sp)
    800047f6:	a01d                	j	8000481c <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    800047f8:	6088                	ld	a0,0(s1)
    800047fa:	c119                	beqz	a0,80004800 <pipealloc+0x9c>
    800047fc:	6942                	ld	s2,16(sp)
    800047fe:	a029                	j	80004808 <pipealloc+0xa4>
    80004800:	6942                	ld	s2,16(sp)
    80004802:	a029                	j	8000480c <pipealloc+0xa8>
    80004804:	6088                	ld	a0,0(s1)
    80004806:	c10d                	beqz	a0,80004828 <pipealloc+0xc4>
    fileclose(*f0);
    80004808:	c29ff0ef          	jal	80004430 <fileclose>
  if (*f1)
    8000480c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004810:	557d                	li	a0,-1
  if (*f1)
    80004812:	c789                	beqz	a5,8000481c <pipealloc+0xb8>
    fileclose(*f1);
    80004814:	853e                	mv	a0,a5
    80004816:	c1bff0ef          	jal	80004430 <fileclose>
  return -1;
    8000481a:	557d                	li	a0,-1
}
    8000481c:	70a2                	ld	ra,40(sp)
    8000481e:	7402                	ld	s0,32(sp)
    80004820:	64e2                	ld	s1,24(sp)
    80004822:	6a02                	ld	s4,0(sp)
    80004824:	6145                	addi	sp,sp,48
    80004826:	8082                	ret
  return -1;
    80004828:	557d                	li	a0,-1
    8000482a:	bfcd                	j	8000481c <pipealloc+0xb8>

000000008000482c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000482c:	1101                	addi	sp,sp,-32
    8000482e:	ec06                	sd	ra,24(sp)
    80004830:	e822                	sd	s0,16(sp)
    80004832:	e426                	sd	s1,8(sp)
    80004834:	e04a                	sd	s2,0(sp)
    80004836:	1000                	addi	s0,sp,32
    80004838:	84aa                	mv	s1,a0
    8000483a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000483c:	bacfc0ef          	jal	80000be8 <acquire>
  if (writable) {
    80004840:	02090763          	beqz	s2,8000486e <pipeclose+0x42>
    pi->writeopen = 0;
    80004844:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004848:	21848513          	addi	a0,s1,536
    8000484c:	969fd0ef          	jal	800021b4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004850:	2204a783          	lw	a5,544(s1)
    80004854:	e781                	bnez	a5,8000485c <pipeclose+0x30>
    80004856:	2244a783          	lw	a5,548(s1)
    8000485a:	c38d                	beqz	a5,8000487c <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    8000485c:	8526                	mv	a0,s1
    8000485e:	c12fc0ef          	jal	80000c70 <release>
}
    80004862:	60e2                	ld	ra,24(sp)
    80004864:	6442                	ld	s0,16(sp)
    80004866:	64a2                	ld	s1,8(sp)
    80004868:	6902                	ld	s2,0(sp)
    8000486a:	6105                	addi	sp,sp,32
    8000486c:	8082                	ret
    pi->readopen = 0;
    8000486e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004872:	21c48513          	addi	a0,s1,540
    80004876:	93ffd0ef          	jal	800021b4 <wakeup>
    8000487a:	bfd9                	j	80004850 <pipeclose+0x24>
    release(&pi->lock);
    8000487c:	8526                	mv	a0,s1
    8000487e:	bf2fc0ef          	jal	80000c70 <release>
    kfree((char *)pi);
    80004882:	8526                	mv	a0,s1
    80004884:	9a2fc0ef          	jal	80000a26 <kfree>
    80004888:	bfe9                	j	80004862 <pipeclose+0x36>

000000008000488a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000488a:	7159                	addi	sp,sp,-112
    8000488c:	f486                	sd	ra,104(sp)
    8000488e:	f0a2                	sd	s0,96(sp)
    80004890:	eca6                	sd	s1,88(sp)
    80004892:	e8ca                	sd	s2,80(sp)
    80004894:	e4ce                	sd	s3,72(sp)
    80004896:	e0d2                	sd	s4,64(sp)
    80004898:	fc56                	sd	s5,56(sp)
    8000489a:	1880                	addi	s0,sp,112
    8000489c:	84aa                	mv	s1,a0
    8000489e:	8aae                	mv	s5,a1
    800048a0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800048a2:	85afd0ef          	jal	800018fc <myproc>
    800048a6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800048a8:	8526                	mv	a0,s1
    800048aa:	b3efc0ef          	jal	80000be8 <acquire>
  while (i < n) {
    800048ae:	0f405a63          	blez	s4,800049a2 <pipewrite+0x118>
    800048b2:	f85a                	sd	s6,48(sp)
    800048b4:	f45e                	sd	s7,40(sp)
    800048b6:	f062                	sd	s8,32(sp)
    800048b8:	ec66                	sd	s9,24(sp)
    800048ba:	e86a                	sd	s10,16(sp)
  int i = 0;
    800048bc:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    800048be:	f9f40c13          	addi	s8,s0,-97
    800048c2:	4b85                	li	s7,1
    800048c4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800048c6:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    800048ca:	21c48c93          	addi	s9,s1,540
    800048ce:	a0a1                	j	80004916 <pipewrite+0x8c>
      release(&pi->lock);
    800048d0:	8526                	mv	a0,s1
    800048d2:	b9efc0ef          	jal	80000c70 <release>
      return -1;
    800048d6:	597d                	li	s2,-1
    800048d8:	7b42                	ld	s6,48(sp)
    800048da:	7ba2                	ld	s7,40(sp)
    800048dc:	7c02                	ld	s8,32(sp)
    800048de:	6ce2                	ld	s9,24(sp)
    800048e0:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800048e2:	854a                	mv	a0,s2
    800048e4:	70a6                	ld	ra,104(sp)
    800048e6:	7406                	ld	s0,96(sp)
    800048e8:	64e6                	ld	s1,88(sp)
    800048ea:	6946                	ld	s2,80(sp)
    800048ec:	69a6                	ld	s3,72(sp)
    800048ee:	6a06                	ld	s4,64(sp)
    800048f0:	7ae2                	ld	s5,56(sp)
    800048f2:	6165                	addi	sp,sp,112
    800048f4:	8082                	ret
      wakeup(&pi->nread);
    800048f6:	856a                	mv	a0,s10
    800048f8:	8bdfd0ef          	jal	800021b4 <wakeup>
      sleep_prepare(&pi->nwrite);
    800048fc:	8566                	mv	a0,s9
    800048fe:	833fd0ef          	jal	80002130 <sleep_prepare>
      release(&pi->lock);
    80004902:	8526                	mv	a0,s1
    80004904:	b6cfc0ef          	jal	80000c70 <release>
      sleep();
    80004908:	865fd0ef          	jal	8000216c <sleep>
      acquire(&pi->lock);
    8000490c:	8526                	mv	a0,s1
    8000490e:	adafc0ef          	jal	80000be8 <acquire>
  while (i < n) {
    80004912:	07495b63          	bge	s2,s4,80004988 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80004916:	2204a783          	lw	a5,544(s1)
    8000491a:	dbdd                	beqz	a5,800048d0 <pipewrite+0x46>
    8000491c:	854e                	mv	a0,s3
    8000491e:	af1fd0ef          	jal	8000240e <killed>
    80004922:	f55d                	bnez	a0,800048d0 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80004924:	2184a783          	lw	a5,536(s1)
    80004928:	21c4a703          	lw	a4,540(s1)
    8000492c:	2007879b          	addiw	a5,a5,512
    80004930:	fcf703e3          	beq	a4,a5,800048f6 <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80004934:	875e                	mv	a4,s7
    80004936:	015906b3          	add	a3,s2,s5
    8000493a:	8662                	mv	a2,s8
    8000493c:	0489b583          	ld	a1,72(s3)
    80004940:	0509b503          	ld	a0,80(s3)
    80004944:	cc5fc0ef          	jal	80001608 <copyin>
    80004948:	03650163          	beq	a0,s6,8000496a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000494c:	21c4a783          	lw	a5,540(s1)
    80004950:	0017871b          	addiw	a4,a5,1
    80004954:	20e4ae23          	sw	a4,540(s1)
    80004958:	1ff7f793          	andi	a5,a5,511
    8000495c:	97a6                	add	a5,a5,s1
    8000495e:	f9f44703          	lbu	a4,-97(s0)
    80004962:	00e78c23          	sb	a4,24(a5)
      i++;
    80004966:	2905                	addiw	s2,s2,1
    80004968:	b76d                	j	80004912 <pipewrite+0x88>
        if (i == 0)
    8000496a:	00090863          	beqz	s2,8000497a <pipewrite+0xf0>
    8000496e:	7b42                	ld	s6,48(sp)
    80004970:	7ba2                	ld	s7,40(sp)
    80004972:	7c02                	ld	s8,32(sp)
    80004974:	6ce2                	ld	s9,24(sp)
    80004976:	6d42                	ld	s10,16(sp)
    80004978:	a829                	j	80004992 <pipewrite+0x108>
          i = -1;
    8000497a:	892a                	mv	s2,a0
        break;
    8000497c:	7b42                	ld	s6,48(sp)
    8000497e:	7ba2                	ld	s7,40(sp)
    80004980:	7c02                	ld	s8,32(sp)
    80004982:	6ce2                	ld	s9,24(sp)
    80004984:	6d42                	ld	s10,16(sp)
    80004986:	a031                	j	80004992 <pipewrite+0x108>
    80004988:	7b42                	ld	s6,48(sp)
    8000498a:	7ba2                	ld	s7,40(sp)
    8000498c:	7c02                	ld	s8,32(sp)
    8000498e:	6ce2                	ld	s9,24(sp)
    80004990:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004992:	21848513          	addi	a0,s1,536
    80004996:	81ffd0ef          	jal	800021b4 <wakeup>
  release(&pi->lock);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ad4fc0ef          	jal	80000c70 <release>
  return i;
    800049a0:	b789                	j	800048e2 <pipewrite+0x58>
  int i = 0;
    800049a2:	4901                	li	s2,0
    800049a4:	b7fd                	j	80004992 <pipewrite+0x108>

00000000800049a6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049a6:	711d                	addi	sp,sp,-96
    800049a8:	ec86                	sd	ra,88(sp)
    800049aa:	e8a2                	sd	s0,80(sp)
    800049ac:	e4a6                	sd	s1,72(sp)
    800049ae:	e0ca                	sd	s2,64(sp)
    800049b0:	fc4e                	sd	s3,56(sp)
    800049b2:	f852                	sd	s4,48(sp)
    800049b4:	f456                	sd	s5,40(sp)
    800049b6:	1080                	addi	s0,sp,96
    800049b8:	84aa                	mv	s1,a0
    800049ba:	89ae                	mv	s3,a1
    800049bc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800049be:	f3ffc0ef          	jal	800018fc <myproc>
    800049c2:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    800049c4:	8526                	mv	a0,s1
    800049c6:	a22fc0ef          	jal	80000be8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800049ca:	2184a703          	lw	a4,536(s1)
    800049ce:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800049d2:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800049d6:	02f71e63          	bne	a4,a5,80004a12 <piperead+0x6c>
    800049da:	2244a783          	lw	a5,548(s1)
    800049de:	c3b9                	beqz	a5,80004a24 <piperead+0x7e>
    if (killed(pr)) {
    800049e0:	854a                	mv	a0,s2
    800049e2:	a2dfd0ef          	jal	8000240e <killed>
    800049e6:	e915                	bnez	a0,80004a1a <piperead+0x74>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800049e8:	8552                	mv	a0,s4
    800049ea:	f46fd0ef          	jal	80002130 <sleep_prepare>
    release(&pi->lock);
    800049ee:	8526                	mv	a0,s1
    800049f0:	a80fc0ef          	jal	80000c70 <release>
    sleep();
    800049f4:	f78fd0ef          	jal	8000216c <sleep>
    acquire(&pi->lock);
    800049f8:	8526                	mv	a0,s1
    800049fa:	9eefc0ef          	jal	80000be8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800049fe:	2184a703          	lw	a4,536(s1)
    80004a02:	21c4a783          	lw	a5,540(s1)
    80004a06:	fcf70ae3          	beq	a4,a5,800049da <piperead+0x34>
    80004a0a:	f05a                	sd	s6,32(sp)
    80004a0c:	ec5e                	sd	s7,24(sp)
    80004a0e:	e862                	sd	s8,16(sp)
    80004a10:	a829                	j	80004a2a <piperead+0x84>
    80004a12:	f05a                	sd	s6,32(sp)
    80004a14:	ec5e                	sd	s7,24(sp)
    80004a16:	e862                	sd	s8,16(sp)
    80004a18:	a809                	j	80004a2a <piperead+0x84>
      release(&pi->lock);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	a54fc0ef          	jal	80000c70 <release>
      return -1;
    80004a20:	5a7d                	li	s4,-1
    80004a22:	a0b5                	j	80004a8e <piperead+0xe8>
    80004a24:	f05a                	sd	s6,32(sp)
    80004a26:	ec5e                	sd	s7,24(sp)
    80004a28:	e862                	sd	s8,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004a2a:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004a2c:	faf40c13          	addi	s8,s0,-81
    80004a30:	4b85                	li	s7,1
    80004a32:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004a34:	05505363          	blez	s5,80004a7a <piperead+0xd4>
    if (pi->nread == pi->nwrite)
    80004a38:	2184a783          	lw	a5,536(s1)
    80004a3c:	21c4a703          	lw	a4,540(s1)
    80004a40:	02f70d63          	beq	a4,a5,80004a7a <piperead+0xd4>
    ch = pi->data[pi->nread % PIPESIZE];
    80004a44:	1ff7f793          	andi	a5,a5,511
    80004a48:	97a6                	add	a5,a5,s1
    80004a4a:	0187c783          	lbu	a5,24(a5)
    80004a4e:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004a52:	875e                	mv	a4,s7
    80004a54:	86e2                	mv	a3,s8
    80004a56:	864e                	mv	a2,s3
    80004a58:	04893583          	ld	a1,72(s2)
    80004a5c:	05093503          	ld	a0,80(s2)
    80004a60:	ae3fc0ef          	jal	80001542 <copyout>
    80004a64:	03650f63          	beq	a0,s6,80004aa2 <piperead+0xfc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004a68:	2184a783          	lw	a5,536(s1)
    80004a6c:	2785                	addiw	a5,a5,1
    80004a6e:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004a72:	2a05                	addiw	s4,s4,1
    80004a74:	0985                	addi	s3,s3,1
    80004a76:	fd4a91e3          	bne	s5,s4,80004a38 <piperead+0x92>
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    80004a7a:	21c48513          	addi	a0,s1,540
    80004a7e:	f36fd0ef          	jal	800021b4 <wakeup>
  release(&pi->lock);
    80004a82:	8526                	mv	a0,s1
    80004a84:	9ecfc0ef          	jal	80000c70 <release>
    80004a88:	7b02                	ld	s6,32(sp)
    80004a8a:	6be2                	ld	s7,24(sp)
    80004a8c:	6c42                	ld	s8,16(sp)
  return i;
}
    80004a8e:	8552                	mv	a0,s4
    80004a90:	60e6                	ld	ra,88(sp)
    80004a92:	6446                	ld	s0,80(sp)
    80004a94:	64a6                	ld	s1,72(sp)
    80004a96:	6906                	ld	s2,64(sp)
    80004a98:	79e2                	ld	s3,56(sp)
    80004a9a:	7a42                	ld	s4,48(sp)
    80004a9c:	7aa2                	ld	s5,40(sp)
    80004a9e:	6125                	addi	sp,sp,96
    80004aa0:	8082                	ret
      if (i == 0)
    80004aa2:	fc0a1ce3          	bnez	s4,80004a7a <piperead+0xd4>
        i = -1;
    80004aa6:	8a2a                	mv	s4,a0
    80004aa8:	bfc9                	j	80004a7a <piperead+0xd4>

0000000080004aaa <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    80004aaa:	1141                	addi	sp,sp,-16
    80004aac:	e406                	sd	ra,8(sp)
    80004aae:	e022                	sd	s0,0(sp)
    80004ab0:	0800                	addi	s0,sp,16
    80004ab2:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004ab4:	0035151b          	slliw	a0,a0,0x3
    80004ab8:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    80004aba:	8b89                	andi	a5,a5,2
    80004abc:	c399                	beqz	a5,80004ac2 <flags2perm+0x18>
    perm |= PTE_W;
    80004abe:	00456513          	ori	a0,a0,4
  return perm;
}
    80004ac2:	60a2                	ld	ra,8(sp)
    80004ac4:	6402                	ld	s0,0(sp)
    80004ac6:	0141                	addi	sp,sp,16
    80004ac8:	8082                	ret

0000000080004aca <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004aca:	de010113          	addi	sp,sp,-544
    80004ace:	20113c23          	sd	ra,536(sp)
    80004ad2:	20813823          	sd	s0,528(sp)
    80004ad6:	20913423          	sd	s1,520(sp)
    80004ada:	21213023          	sd	s2,512(sp)
    80004ade:	1400                	addi	s0,sp,544
    80004ae0:	892a                	mv	s2,a0
    80004ae2:	dea43823          	sd	a0,-528(s0)
    80004ae6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004aea:	e13fc0ef          	jal	800018fc <myproc>
    80004aee:	84aa                	mv	s1,a0

  begin_op();
    80004af0:	c86ff0ef          	jal	80003f76 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004af4:	854a                	mv	a0,s2
    80004af6:	aa2ff0ef          	jal	80003d98 <namei>
    80004afa:	cd21                	beqz	a0,80004b52 <kexec+0x88>
    80004afc:	fbd2                	sd	s4,496(sp)
    80004afe:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b00:	a0dfe0ef          	jal	8000350c <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b04:	04000713          	li	a4,64
    80004b08:	4681                	li	a3,0
    80004b0a:	e5040613          	addi	a2,s0,-432
    80004b0e:	4581                	li	a1,0
    80004b10:	8552                	mv	a0,s4
    80004b12:	dd5fe0ef          	jal	800038e6 <readi>
    80004b16:	04000793          	li	a5,64
    80004b1a:	00f51a63          	bne	a0,a5,80004b2e <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80004b1e:	e5042703          	lw	a4,-432(s0)
    80004b22:	464c47b7          	lui	a5,0x464c4
    80004b26:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b2a:	02f70863          	beq	a4,a5,80004b5a <kexec+0x90>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004b2e:	8552                	mv	a0,s4
    80004b30:	c31fe0ef          	jal	80003760 <iunlockput>
    end_op();
    80004b34:	cceff0ef          	jal	80004002 <end_op>
  }
  return -1;
    80004b38:	557d                	li	a0,-1
    80004b3a:	7a5e                	ld	s4,496(sp)
}
    80004b3c:	21813083          	ld	ra,536(sp)
    80004b40:	21013403          	ld	s0,528(sp)
    80004b44:	20813483          	ld	s1,520(sp)
    80004b48:	20013903          	ld	s2,512(sp)
    80004b4c:	22010113          	addi	sp,sp,544
    80004b50:	8082                	ret
    end_op();
    80004b52:	cb0ff0ef          	jal	80004002 <end_op>
    return -1;
    80004b56:	557d                	li	a0,-1
    80004b58:	b7d5                	j	80004b3c <kexec+0x72>
    80004b5a:	f3da                	sd	s6,480(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	eb5fc0ef          	jal	80001a12 <proc_pagetable>
    80004b62:	8b2a                	mv	s6,a0
    80004b64:	26050e63          	beqz	a0,80004de0 <kexec+0x316>
    80004b68:	ffce                	sd	s3,504(sp)
    80004b6a:	f7d6                	sd	s5,488(sp)
    80004b6c:	efde                	sd	s7,472(sp)
    80004b6e:	ebe2                	sd	s8,464(sp)
    80004b70:	e7e6                	sd	s9,456(sp)
    80004b72:	e3ea                	sd	s10,448(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004b74:	e8845783          	lhu	a5,-376(s0)
    80004b78:	14078263          	beqz	a5,80004cbc <kexec+0x1f2>
    80004b7c:	ff6e                	sd	s11,440(sp)
    80004b7e:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b82:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004b84:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004b86:	03800d93          	li	s11,56
    if (ph.vaddr % PGSIZE != 0)
    80004b8a:	6c85                	lui	s9,0x1
    80004b8c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004b90:	def43423          	sd	a5,-536(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004b94:	6a85                	lui	s5,0x1
    80004b96:	a085                	j	80004bf6 <kexec+0x12c>
      panic("loadseg: address should exist");
    80004b98:	00003517          	auipc	a0,0x3
    80004b9c:	b4050513          	addi	a0,a0,-1216 # 800076d8 <etext+0x6d8>
    80004ba0:	c95fb0ef          	jal	80000834 <panic>
    if (sz - i < PGSIZE)
    80004ba4:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004ba6:	874a                	mv	a4,s2
    80004ba8:	009b86bb          	addw	a3,s7,s1
    80004bac:	4581                	li	a1,0
    80004bae:	8552                	mv	a0,s4
    80004bb0:	d37fe0ef          	jal	800038e6 <readi>
    80004bb4:	22a91a63          	bne	s2,a0,80004de8 <kexec+0x31e>
  for (i = 0; i < sz; i += PGSIZE) {
    80004bb8:	009a84bb          	addw	s1,s5,s1
    80004bbc:	0334f263          	bgeu	s1,s3,80004be0 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004bc0:	02049593          	slli	a1,s1,0x20
    80004bc4:	9181                	srli	a1,a1,0x20
    80004bc6:	95e2                	add	a1,a1,s8
    80004bc8:	855a                	mv	a0,s6
    80004bca:	c0efc0ef          	jal	80000fd8 <walkaddr>
    80004bce:	862a                	mv	a2,a0
    if (pa == 0)
    80004bd0:	d561                	beqz	a0,80004b98 <kexec+0xce>
    if (sz - i < PGSIZE)
    80004bd2:	409987bb          	subw	a5,s3,s1
    80004bd6:	893e                	mv	s2,a5
    80004bd8:	fcfcf6e3          	bgeu	s9,a5,80004ba4 <kexec+0xda>
    80004bdc:	8956                	mv	s2,s5
    80004bde:	b7d9                	j	80004ba4 <kexec+0xda>
    sz = sz1;
    80004be0:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004be4:	2d05                	addiw	s10,s10,1
    80004be6:	e0843783          	ld	a5,-504(s0)
    80004bea:	0387869b          	addiw	a3,a5,56
    80004bee:	e8845783          	lhu	a5,-376(s0)
    80004bf2:	06fd5d63          	bge	s10,a5,80004c6c <kexec+0x1a2>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004bf6:	e0d43423          	sd	a3,-504(s0)
    80004bfa:	876e                	mv	a4,s11
    80004bfc:	e1840613          	addi	a2,s0,-488
    80004c00:	4581                	li	a1,0
    80004c02:	8552                	mv	a0,s4
    80004c04:	ce3fe0ef          	jal	800038e6 <readi>
    80004c08:	1db51e63          	bne	a0,s11,80004de4 <kexec+0x31a>
    if (ph.type != ELF_PROG_LOAD)
    80004c0c:	e1842783          	lw	a5,-488(s0)
    80004c10:	4705                	li	a4,1
    80004c12:	fce799e3          	bne	a5,a4,80004be4 <kexec+0x11a>
    if (ph.memsz < ph.filesz)
    80004c16:	e4043483          	ld	s1,-448(s0)
    80004c1a:	e3843783          	ld	a5,-456(s0)
    80004c1e:	1ef4e363          	bltu	s1,a5,80004e04 <kexec+0x33a>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004c22:	e2843783          	ld	a5,-472(s0)
    80004c26:	94be                	add	s1,s1,a5
    80004c28:	1ef4e163          	bltu	s1,a5,80004e0a <kexec+0x340>
    if (ph.vaddr % PGSIZE != 0)
    80004c2c:	de843703          	ld	a4,-536(s0)
    80004c30:	8ff9                	and	a5,a5,a4
    80004c32:	1c079f63          	bnez	a5,80004e10 <kexec+0x346>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004c36:	e1c42503          	lw	a0,-484(s0)
    80004c3a:	e71ff0ef          	jal	80004aaa <flags2perm>
    80004c3e:	86aa                	mv	a3,a0
    80004c40:	8626                	mv	a2,s1
    80004c42:	85ca                	mv	a1,s2
    80004c44:	855a                	mv	a0,s6
    80004c46:	e68fc0ef          	jal	800012ae <uvmalloc>
    80004c4a:	dea43c23          	sd	a0,-520(s0)
    80004c4e:	1c050463          	beqz	a0,80004e16 <kexec+0x34c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004c52:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004c56:	00098863          	beqz	s3,80004c66 <kexec+0x19c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004c5a:	e2843c03          	ld	s8,-472(s0)
    80004c5e:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004c62:	4481                	li	s1,0
    80004c64:	bfb1                	j	80004bc0 <kexec+0xf6>
    sz = sz1;
    80004c66:	df843903          	ld	s2,-520(s0)
    80004c6a:	bfad                	j	80004be4 <kexec+0x11a>
    80004c6c:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    80004c6e:	8552                	mv	a0,s4
    80004c70:	af1fe0ef          	jal	80003760 <iunlockput>
  end_op();
    80004c74:	b8eff0ef          	jal	80004002 <end_op>
  p = myproc();
    80004c78:	c85fc0ef          	jal	800018fc <myproc>
    80004c7c:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004c7e:	04853a83          	ld	s5,72(a0)
  sz = PGROUNDUP(sz);
    80004c82:	6c05                	lui	s8,0x1
    80004c84:	1c7d                	addi	s8,s8,-1 # fff <_entry-0x7ffff001>
    80004c86:	9c4a                	add	s8,s8,s2
    80004c88:	77fd                	lui	a5,0xfffff
    80004c8a:	00fc7c33          	and	s8,s8,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004c8e:	4691                	li	a3,4
    80004c90:	6609                	lui	a2,0x2
    80004c92:	9662                	add	a2,a2,s8
    80004c94:	85e2                	mv	a1,s8
    80004c96:	855a                	mv	a0,s6
    80004c98:	e16fc0ef          	jal	800012ae <uvmalloc>
    80004c9c:	892a                	mv	s2,a0
    80004c9e:	e10d                	bnez	a0,80004cc0 <kexec+0x1f6>
    proc_freepagetable(pagetable, sz);
    80004ca0:	85e2                	mv	a1,s8
    80004ca2:	855a                	mv	a0,s6
    80004ca4:	df3fc0ef          	jal	80001a96 <proc_freepagetable>
  return -1;
    80004ca8:	557d                	li	a0,-1
    80004caa:	79fe                	ld	s3,504(sp)
    80004cac:	7a5e                	ld	s4,496(sp)
    80004cae:	7abe                	ld	s5,488(sp)
    80004cb0:	7b1e                	ld	s6,480(sp)
    80004cb2:	6bfe                	ld	s7,472(sp)
    80004cb4:	6c5e                	ld	s8,464(sp)
    80004cb6:	6cbe                	ld	s9,456(sp)
    80004cb8:	6d1e                	ld	s10,448(sp)
    80004cba:	b549                	j	80004b3c <kexec+0x72>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004cbc:	4901                	li	s2,0
    80004cbe:	bf45                	j	80004c6e <kexec+0x1a4>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004cc0:	75f9                	lui	a1,0xffffe
    80004cc2:	95aa                	add	a1,a1,a0
    80004cc4:	855a                	mv	a0,s6
    80004cc6:	fbafc0ef          	jal	80001480 <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004cca:	80090a13          	addi	s4,s2,-2048
    80004cce:	800a0a13          	addi	s4,s4,-2048
  for (argc = 0; argv[argc]; argc++) {
    80004cd2:	e0043783          	ld	a5,-512(s0)
    80004cd6:	6388                	ld	a0,0(a5)
    80004cd8:	c545                	beqz	a0,80004d80 <kexec+0x2b6>
  sp = sz;
    80004cda:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80004cdc:	4481                	li	s1,0
    ustack[argc] = sp;
    80004cde:	e9040b93          	addi	s7,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80004ce2:	950fc0ef          	jal	80000e32 <strlen>
    80004ce6:	0015079b          	addiw	a5,a0,1
    80004cea:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004cee:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80004cf2:	134c6563          	bltu	s8,s4,80004e1c <kexec+0x352>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004cf6:	e0043d03          	ld	s10,-512(s0)
    80004cfa:	000d3c83          	ld	s9,0(s10)
    80004cfe:	8566                	mv	a0,s9
    80004d00:	932fc0ef          	jal	80000e32 <strlen>
    80004d04:	0015071b          	addiw	a4,a0,1
    80004d08:	86e6                	mv	a3,s9
    80004d0a:	8662                	mv	a2,s8
    80004d0c:	85ca                	mv	a1,s2
    80004d0e:	855a                	mv	a0,s6
    80004d10:	833fc0ef          	jal	80001542 <copyout>
    80004d14:	10054663          	bltz	a0,80004e20 <kexec+0x356>
    ustack[argc] = sp;
    80004d18:	00349793          	slli	a5,s1,0x3
    80004d1c:	97de                	add	a5,a5,s7
    80004d1e:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb060>
  for (argc = 0; argv[argc]; argc++) {
    80004d22:	0485                	addi	s1,s1,1
    80004d24:	008d0793          	addi	a5,s10,8
    80004d28:	e0f43023          	sd	a5,-512(s0)
    80004d2c:	008d3503          	ld	a0,8(s10)
    80004d30:	f94d                	bnez	a0,80004ce2 <kexec+0x218>
  ustack[argc] = 0;
    80004d32:	00349793          	slli	a5,s1,0x3
    80004d36:	f9078793          	addi	a5,a5,-112
    80004d3a:	97a2                	add	a5,a5,s0
    80004d3c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004d40:	00349713          	slli	a4,s1,0x3
    80004d44:	0721                	addi	a4,a4,8
    80004d46:	40ec0bb3          	sub	s7,s8,a4
  sp -= sp % 16;
    80004d4a:	ff0bfb93          	andi	s7,s7,-16
  sz = sz1;
    80004d4e:	8c4a                	mv	s8,s2
  if (sp < stackbase)
    80004d50:	f54be8e3          	bltu	s7,s4,80004ca0 <kexec+0x1d6>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004d54:	e9040693          	addi	a3,s0,-368
    80004d58:	865e                	mv	a2,s7
    80004d5a:	85ca                	mv	a1,s2
    80004d5c:	855a                	mv	a0,s6
    80004d5e:	fe4fc0ef          	jal	80001542 <copyout>
    80004d62:	f2054fe3          	bltz	a0,80004ca0 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80004d66:	0589b783          	ld	a5,88(s3)
    80004d6a:	0777bc23          	sd	s7,120(a5)
  for (last = s = path; *s; s++)
    80004d6e:	df043783          	ld	a5,-528(s0)
    80004d72:	0007c703          	lbu	a4,0(a5)
    80004d76:	c30d                	beqz	a4,80004d98 <kexec+0x2ce>
    80004d78:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004d7a:	02f00693          	li	a3,47
    80004d7e:	a801                	j	80004d8e <kexec+0x2c4>
  sp = sz;
    80004d80:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80004d82:	4481                	li	s1,0
    80004d84:	b77d                	j	80004d32 <kexec+0x268>
  for (last = s = path; *s; s++)
    80004d86:	0785                	addi	a5,a5,1
    80004d88:	fff7c703          	lbu	a4,-1(a5)
    80004d8c:	c711                	beqz	a4,80004d98 <kexec+0x2ce>
    if (*s == '/')
    80004d8e:	fed71ce3          	bne	a4,a3,80004d86 <kexec+0x2bc>
      last = s + 1;
    80004d92:	def43823          	sd	a5,-528(s0)
    80004d96:	bfc5                	j	80004d86 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004d98:	4641                	li	a2,16
    80004d9a:	df043583          	ld	a1,-528(s0)
    80004d9e:	15898513          	addi	a0,s3,344
    80004da2:	85afc0ef          	jal	80000dfc <safestrcpy>
  oldpagetable = p->pagetable;
    80004da6:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004daa:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004dae:	0529b423          	sd	s2,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004db2:	0589b783          	ld	a5,88(s3)
    80004db6:	e6843703          	ld	a4,-408(s0)
    80004dba:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004dbc:	0589b783          	ld	a5,88(s3)
    80004dc0:	0377b823          	sd	s7,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004dc4:	85d6                	mv	a1,s5
    80004dc6:	cd1fc0ef          	jal	80001a96 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004dca:	0004851b          	sext.w	a0,s1
    80004dce:	79fe                	ld	s3,504(sp)
    80004dd0:	7a5e                	ld	s4,496(sp)
    80004dd2:	7abe                	ld	s5,488(sp)
    80004dd4:	7b1e                	ld	s6,480(sp)
    80004dd6:	6bfe                	ld	s7,472(sp)
    80004dd8:	6c5e                	ld	s8,464(sp)
    80004dda:	6cbe                	ld	s9,456(sp)
    80004ddc:	6d1e                	ld	s10,448(sp)
    80004dde:	bbb9                	j	80004b3c <kexec+0x72>
    80004de0:	7b1e                	ld	s6,480(sp)
    80004de2:	b3b1                	j	80004b2e <kexec+0x64>
    80004de4:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004de8:	df843583          	ld	a1,-520(s0)
    80004dec:	855a                	mv	a0,s6
    80004dee:	ca9fc0ef          	jal	80001a96 <proc_freepagetable>
  if (ip) {
    80004df2:	79fe                	ld	s3,504(sp)
    80004df4:	7abe                	ld	s5,488(sp)
    80004df6:	7b1e                	ld	s6,480(sp)
    80004df8:	6bfe                	ld	s7,472(sp)
    80004dfa:	6c5e                	ld	s8,464(sp)
    80004dfc:	6cbe                	ld	s9,456(sp)
    80004dfe:	6d1e                	ld	s10,448(sp)
    80004e00:	7dfa                	ld	s11,440(sp)
    80004e02:	b335                	j	80004b2e <kexec+0x64>
    80004e04:	df243c23          	sd	s2,-520(s0)
    80004e08:	b7c5                	j	80004de8 <kexec+0x31e>
    80004e0a:	df243c23          	sd	s2,-520(s0)
    80004e0e:	bfe9                	j	80004de8 <kexec+0x31e>
    80004e10:	df243c23          	sd	s2,-520(s0)
    80004e14:	bfd1                	j	80004de8 <kexec+0x31e>
    80004e16:	df243c23          	sd	s2,-520(s0)
    80004e1a:	b7f9                	j	80004de8 <kexec+0x31e>
  sz = sz1;
    80004e1c:	8c4a                	mv	s8,s2
    80004e1e:	b549                	j	80004ca0 <kexec+0x1d6>
    80004e20:	8c4a                	mv	s8,s2
    80004e22:	bdbd                	j	80004ca0 <kexec+0x1d6>

0000000080004e24 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e24:	7179                	addi	sp,sp,-48
    80004e26:	f406                	sd	ra,40(sp)
    80004e28:	f022                	sd	s0,32(sp)
    80004e2a:	ec26                	sd	s1,24(sp)
    80004e2c:	e84a                	sd	s2,16(sp)
    80004e2e:	1800                	addi	s0,sp,48
    80004e30:	892e                	mv	s2,a1
    80004e32:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004e34:	fdc40593          	addi	a1,s0,-36
    80004e38:	cfbfd0ef          	jal	80002b32 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004e3c:	fdc42703          	lw	a4,-36(s0)
    80004e40:	47bd                	li	a5,15
    80004e42:	02e7ea63          	bltu	a5,a4,80004e76 <argfd+0x52>
    80004e46:	ab7fc0ef          	jal	800018fc <myproc>
    80004e4a:	fdc42703          	lw	a4,-36(s0)
    80004e4e:	00371793          	slli	a5,a4,0x3
    80004e52:	0d078793          	addi	a5,a5,208
    80004e56:	953e                	add	a0,a0,a5
    80004e58:	611c                	ld	a5,0(a0)
    80004e5a:	c385                	beqz	a5,80004e7a <argfd+0x56>
    return -1;
  if (pfd)
    80004e5c:	00090463          	beqz	s2,80004e64 <argfd+0x40>
    *pfd = fd;
    80004e60:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004e64:	4501                	li	a0,0
  if (pf)
    80004e66:	c091                	beqz	s1,80004e6a <argfd+0x46>
    *pf = f;
    80004e68:	e09c                	sd	a5,0(s1)
}
    80004e6a:	70a2                	ld	ra,40(sp)
    80004e6c:	7402                	ld	s0,32(sp)
    80004e6e:	64e2                	ld	s1,24(sp)
    80004e70:	6942                	ld	s2,16(sp)
    80004e72:	6145                	addi	sp,sp,48
    80004e74:	8082                	ret
    return -1;
    80004e76:	557d                	li	a0,-1
    80004e78:	bfcd                	j	80004e6a <argfd+0x46>
    80004e7a:	557d                	li	a0,-1
    80004e7c:	b7fd                	j	80004e6a <argfd+0x46>

0000000080004e7e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004e7e:	1101                	addi	sp,sp,-32
    80004e80:	ec06                	sd	ra,24(sp)
    80004e82:	e822                	sd	s0,16(sp)
    80004e84:	e426                	sd	s1,8(sp)
    80004e86:	1000                	addi	s0,sp,32
    80004e88:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004e8a:	a73fc0ef          	jal	800018fc <myproc>
    80004e8e:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004e90:	0d050793          	addi	a5,a0,208
    80004e94:	4501                	li	a0,0
    80004e96:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004e98:	6398                	ld	a4,0(a5)
    80004e9a:	cb19                	beqz	a4,80004eb0 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004e9c:	2505                	addiw	a0,a0,1
    80004e9e:	07a1                	addi	a5,a5,8
    80004ea0:	fed51ce3          	bne	a0,a3,80004e98 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004ea4:	557d                	li	a0,-1
}
    80004ea6:	60e2                	ld	ra,24(sp)
    80004ea8:	6442                	ld	s0,16(sp)
    80004eaa:	64a2                	ld	s1,8(sp)
    80004eac:	6105                	addi	sp,sp,32
    80004eae:	8082                	ret
      p->ofile[fd] = f;
    80004eb0:	00351793          	slli	a5,a0,0x3
    80004eb4:	0d078793          	addi	a5,a5,208
    80004eb8:	963e                	add	a2,a2,a5
    80004eba:	e204                	sd	s1,0(a2)
      return fd;
    80004ebc:	b7ed                	j	80004ea6 <fdalloc+0x28>

0000000080004ebe <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004ebe:	715d                	addi	sp,sp,-80
    80004ec0:	e486                	sd	ra,72(sp)
    80004ec2:	e0a2                	sd	s0,64(sp)
    80004ec4:	fc26                	sd	s1,56(sp)
    80004ec6:	f84a                	sd	s2,48(sp)
    80004ec8:	f052                	sd	s4,32(sp)
    80004eca:	ec56                	sd	s5,24(sp)
    80004ecc:	e85a                	sd	s6,16(sp)
    80004ece:	0880                	addi	s0,sp,80
    80004ed0:	8a2e                	mv	s4,a1
    80004ed2:	8ab2                	mv	s5,a2
    80004ed4:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004ed6:	fb040593          	addi	a1,s0,-80
    80004eda:	ed9fe0ef          	jal	80003db2 <nameiparent>
    80004ede:	84aa                	mv	s1,a0
    80004ee0:	12050f63          	beqz	a0,8000501e <create+0x160>
    return 0;

  ilock(dp);
    80004ee4:	e28fe0ef          	jal	8000350c <ilock>

  if (dp->nlink == 0) {
    80004ee8:	04a49783          	lh	a5,74(s1)
    80004eec:	cbb9                	beqz	a5,80004f42 <create+0x84>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004eee:	7761                	lui	a4,0xffff8
    80004ef0:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd4061>
    80004ef2:	97ba                	add	a5,a5,a4
    80004ef4:	e781                	bnez	a5,80004efc <create+0x3e>
    80004ef6:	fffa0793          	addi	a5,s4,-1
    80004efa:	cba9                	beqz	a5,80004f4c <create+0x8e>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004efc:	4601                	li	a2,0
    80004efe:	fb040593          	addi	a1,s0,-80
    80004f02:	8526                	mv	a0,s1
    80004f04:	bf1fe0ef          	jal	80003af4 <dirlookup>
    80004f08:	892a                	mv	s2,a0
    80004f0a:	c939                	beqz	a0,80004f60 <create+0xa2>
    iunlockput(dp);
    80004f0c:	8526                	mv	a0,s1
    80004f0e:	853fe0ef          	jal	80003760 <iunlockput>
    ilock(ip);
    80004f12:	854a                	mv	a0,s2
    80004f14:	df8fe0ef          	jal	8000350c <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f18:	4789                	li	a5,2
    80004f1a:	02fa1e63          	bne	s4,a5,80004f56 <create+0x98>
    80004f1e:	04495783          	lhu	a5,68(s2)
    80004f22:	37f9                	addiw	a5,a5,-2
    80004f24:	17c2                	slli	a5,a5,0x30
    80004f26:	93c1                	srli	a5,a5,0x30
    80004f28:	4705                	li	a4,1
    80004f2a:	02f76663          	bltu	a4,a5,80004f56 <create+0x98>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004f2e:	854a                	mv	a0,s2
    80004f30:	60a6                	ld	ra,72(sp)
    80004f32:	6406                	ld	s0,64(sp)
    80004f34:	74e2                	ld	s1,56(sp)
    80004f36:	7942                	ld	s2,48(sp)
    80004f38:	7a02                	ld	s4,32(sp)
    80004f3a:	6ae2                	ld	s5,24(sp)
    80004f3c:	6b42                	ld	s6,16(sp)
    80004f3e:	6161                	addi	sp,sp,80
    80004f40:	8082                	ret
    iunlockput(dp);
    80004f42:	8526                	mv	a0,s1
    80004f44:	81dfe0ef          	jal	80003760 <iunlockput>
    return 0;
    80004f48:	4901                	li	s2,0
    80004f4a:	b7d5                	j	80004f2e <create+0x70>
    iunlockput(dp);
    80004f4c:	8526                	mv	a0,s1
    80004f4e:	813fe0ef          	jal	80003760 <iunlockput>
    return 0;
    80004f52:	4901                	li	s2,0
    80004f54:	bfe9                	j	80004f2e <create+0x70>
    iunlockput(ip);
    80004f56:	854a                	mv	a0,s2
    80004f58:	809fe0ef          	jal	80003760 <iunlockput>
    return 0;
    80004f5c:	4901                	li	s2,0
    80004f5e:	bfc1                	j	80004f2e <create+0x70>
    80004f60:	f44e                	sd	s3,40(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004f62:	85d2                	mv	a1,s4
    80004f64:	4088                	lw	a0,0(s1)
    80004f66:	c36fe0ef          	jal	8000339c <ialloc>
    80004f6a:	89aa                	mv	s3,a0
    80004f6c:	cd1d                	beqz	a0,80004faa <create+0xec>
  ilock(ip);
    80004f6e:	d9efe0ef          	jal	8000350c <ilock>
  ip->major = major;
    80004f72:	05599323          	sh	s5,70(s3)
  ip->minor = minor;
    80004f76:	05699423          	sh	s6,72(s3)
  ip->nlink = 1;
    80004f7a:	4705                	li	a4,1
    80004f7c:	04e99523          	sh	a4,74(s3)
  iupdate(ip);
    80004f80:	854e                	mv	a0,s3
    80004f82:	cd6fe0ef          	jal	80003458 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004f86:	4705                	li	a4,1
    80004f88:	02ea0763          	beq	s4,a4,80004fb6 <create+0xf8>
  if (dirlink(dp, name, ip->inum) < 0)
    80004f8c:	0049a603          	lw	a2,4(s3)
    80004f90:	fb040593          	addi	a1,s0,-80
    80004f94:	8526                	mv	a0,s1
    80004f96:	d59fe0ef          	jal	80003cee <dirlink>
    80004f9a:	06054563          	bltz	a0,80005004 <create+0x146>
  iunlockput(dp);
    80004f9e:	8526                	mv	a0,s1
    80004fa0:	fc0fe0ef          	jal	80003760 <iunlockput>
  return ip;
    80004fa4:	894e                	mv	s2,s3
    80004fa6:	79a2                	ld	s3,40(sp)
    80004fa8:	b759                	j	80004f2e <create+0x70>
    iunlockput(dp);
    80004faa:	8526                	mv	a0,s1
    80004fac:	fb4fe0ef          	jal	80003760 <iunlockput>
    return 0;
    80004fb0:	894e                	mv	s2,s3
    80004fb2:	79a2                	ld	s3,40(sp)
    80004fb4:	bfad                	j	80004f2e <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004fb6:	0049a603          	lw	a2,4(s3)
    80004fba:	00002597          	auipc	a1,0x2
    80004fbe:	73e58593          	addi	a1,a1,1854 # 800076f8 <etext+0x6f8>
    80004fc2:	854e                	mv	a0,s3
    80004fc4:	d2bfe0ef          	jal	80003cee <dirlink>
    80004fc8:	02054e63          	bltz	a0,80005004 <create+0x146>
    80004fcc:	40d0                	lw	a2,4(s1)
    80004fce:	00002597          	auipc	a1,0x2
    80004fd2:	73258593          	addi	a1,a1,1842 # 80007700 <etext+0x700>
    80004fd6:	854e                	mv	a0,s3
    80004fd8:	d17fe0ef          	jal	80003cee <dirlink>
    80004fdc:	02054463          	bltz	a0,80005004 <create+0x146>
  if (dirlink(dp, name, ip->inum) < 0)
    80004fe0:	0049a603          	lw	a2,4(s3)
    80004fe4:	fb040593          	addi	a1,s0,-80
    80004fe8:	8526                	mv	a0,s1
    80004fea:	d05fe0ef          	jal	80003cee <dirlink>
    80004fee:	00054b63          	bltz	a0,80005004 <create+0x146>
    dp->nlink++; // for ".."
    80004ff2:	04a4d783          	lhu	a5,74(s1)
    80004ff6:	2785                	addiw	a5,a5,1
    80004ff8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ffc:	8526                	mv	a0,s1
    80004ffe:	c5afe0ef          	jal	80003458 <iupdate>
    80005002:	bf71                	j	80004f9e <create+0xe0>
  ip->nlink = 0;
    80005004:	04099523          	sh	zero,74(s3)
  iupdate(ip);
    80005008:	854e                	mv	a0,s3
    8000500a:	c4efe0ef          	jal	80003458 <iupdate>
  iunlockput(ip);
    8000500e:	854e                	mv	a0,s3
    80005010:	f50fe0ef          	jal	80003760 <iunlockput>
  iunlockput(dp);
    80005014:	8526                	mv	a0,s1
    80005016:	f4afe0ef          	jal	80003760 <iunlockput>
  return 0;
    8000501a:	79a2                	ld	s3,40(sp)
    8000501c:	bf09                	j	80004f2e <create+0x70>
    return 0;
    8000501e:	892a                	mv	s2,a0
    80005020:	b739                	j	80004f2e <create+0x70>

0000000080005022 <sys_dup>:
{
    80005022:	7179                	addi	sp,sp,-48
    80005024:	f406                	sd	ra,40(sp)
    80005026:	f022                	sd	s0,32(sp)
    80005028:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000502a:	fd840613          	addi	a2,s0,-40
    8000502e:	4581                	li	a1,0
    80005030:	4501                	li	a0,0
    80005032:	df3ff0ef          	jal	80004e24 <argfd>
    return -1;
    80005036:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80005038:	02054363          	bltz	a0,8000505e <sys_dup+0x3c>
    8000503c:	ec26                	sd	s1,24(sp)
    8000503e:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80005040:	fd843483          	ld	s1,-40(s0)
    80005044:	8526                	mv	a0,s1
    80005046:	e39ff0ef          	jal	80004e7e <fdalloc>
    8000504a:	892a                	mv	s2,a0
    return -1;
    8000504c:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    8000504e:	00054d63          	bltz	a0,80005068 <sys_dup+0x46>
  filedup(f);
    80005052:	8526                	mv	a0,s1
    80005054:	b96ff0ef          	jal	800043ea <filedup>
  return fd;
    80005058:	87ca                	mv	a5,s2
    8000505a:	64e2                	ld	s1,24(sp)
    8000505c:	6942                	ld	s2,16(sp)
}
    8000505e:	853e                	mv	a0,a5
    80005060:	70a2                	ld	ra,40(sp)
    80005062:	7402                	ld	s0,32(sp)
    80005064:	6145                	addi	sp,sp,48
    80005066:	8082                	ret
    80005068:	64e2                	ld	s1,24(sp)
    8000506a:	6942                	ld	s2,16(sp)
    8000506c:	bfcd                	j	8000505e <sys_dup+0x3c>

000000008000506e <sys_read>:
{
    8000506e:	7179                	addi	sp,sp,-48
    80005070:	f406                	sd	ra,40(sp)
    80005072:	f022                	sd	s0,32(sp)
    80005074:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005076:	fd840593          	addi	a1,s0,-40
    8000507a:	4505                	li	a0,1
    8000507c:	ad3fd0ef          	jal	80002b4e <argaddr>
  argint(2, &n);
    80005080:	fe440593          	addi	a1,s0,-28
    80005084:	4509                	li	a0,2
    80005086:	aadfd0ef          	jal	80002b32 <argint>
  if (argfd(0, 0, &f) < 0)
    8000508a:	fe840613          	addi	a2,s0,-24
    8000508e:	4581                	li	a1,0
    80005090:	4501                	li	a0,0
    80005092:	d93ff0ef          	jal	80004e24 <argfd>
    80005096:	87aa                	mv	a5,a0
    return -1;
    80005098:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000509a:	0007ca63          	bltz	a5,800050ae <sys_read+0x40>
  return fileread(f, p, n);
    8000509e:	fe442603          	lw	a2,-28(s0)
    800050a2:	fd843583          	ld	a1,-40(s0)
    800050a6:	fe843503          	ld	a0,-24(s0)
    800050aa:	caeff0ef          	jal	80004558 <fileread>
}
    800050ae:	70a2                	ld	ra,40(sp)
    800050b0:	7402                	ld	s0,32(sp)
    800050b2:	6145                	addi	sp,sp,48
    800050b4:	8082                	ret

00000000800050b6 <sys_write>:
{
    800050b6:	7179                	addi	sp,sp,-48
    800050b8:	f406                	sd	ra,40(sp)
    800050ba:	f022                	sd	s0,32(sp)
    800050bc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800050be:	fd840593          	addi	a1,s0,-40
    800050c2:	4505                	li	a0,1
    800050c4:	a8bfd0ef          	jal	80002b4e <argaddr>
  argint(2, &n);
    800050c8:	fe440593          	addi	a1,s0,-28
    800050cc:	4509                	li	a0,2
    800050ce:	a65fd0ef          	jal	80002b32 <argint>
  if (argfd(0, 0, &f) < 0)
    800050d2:	fe840613          	addi	a2,s0,-24
    800050d6:	4581                	li	a1,0
    800050d8:	4501                	li	a0,0
    800050da:	d4bff0ef          	jal	80004e24 <argfd>
    800050de:	87aa                	mv	a5,a0
    return -1;
    800050e0:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800050e2:	0007ca63          	bltz	a5,800050f6 <sys_write+0x40>
  return filewrite(f, p, n);
    800050e6:	fe442603          	lw	a2,-28(s0)
    800050ea:	fd843583          	ld	a1,-40(s0)
    800050ee:	fe843503          	ld	a0,-24(s0)
    800050f2:	d34ff0ef          	jal	80004626 <filewrite>
}
    800050f6:	70a2                	ld	ra,40(sp)
    800050f8:	7402                	ld	s0,32(sp)
    800050fa:	6145                	addi	sp,sp,48
    800050fc:	8082                	ret

00000000800050fe <sys_close>:
{
    800050fe:	1101                	addi	sp,sp,-32
    80005100:	ec06                	sd	ra,24(sp)
    80005102:	e822                	sd	s0,16(sp)
    80005104:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80005106:	fe040613          	addi	a2,s0,-32
    8000510a:	fec40593          	addi	a1,s0,-20
    8000510e:	4501                	li	a0,0
    80005110:	d15ff0ef          	jal	80004e24 <argfd>
    return -1;
    80005114:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80005116:	02054163          	bltz	a0,80005138 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    8000511a:	fe2fc0ef          	jal	800018fc <myproc>
    8000511e:	fec42783          	lw	a5,-20(s0)
    80005122:	078e                	slli	a5,a5,0x3
    80005124:	0d078793          	addi	a5,a5,208
    80005128:	953e                	add	a0,a0,a5
    8000512a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000512e:	fe043503          	ld	a0,-32(s0)
    80005132:	afeff0ef          	jal	80004430 <fileclose>
  return 0;
    80005136:	4781                	li	a5,0
}
    80005138:	853e                	mv	a0,a5
    8000513a:	60e2                	ld	ra,24(sp)
    8000513c:	6442                	ld	s0,16(sp)
    8000513e:	6105                	addi	sp,sp,32
    80005140:	8082                	ret

0000000080005142 <sys_fstat>:
{
    80005142:	1101                	addi	sp,sp,-32
    80005144:	ec06                	sd	ra,24(sp)
    80005146:	e822                	sd	s0,16(sp)
    80005148:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000514a:	fe040593          	addi	a1,s0,-32
    8000514e:	4505                	li	a0,1
    80005150:	9fffd0ef          	jal	80002b4e <argaddr>
  if (argfd(0, 0, &f) < 0)
    80005154:	fe840613          	addi	a2,s0,-24
    80005158:	4581                	li	a1,0
    8000515a:	4501                	li	a0,0
    8000515c:	cc9ff0ef          	jal	80004e24 <argfd>
    80005160:	87aa                	mv	a5,a0
    return -1;
    80005162:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005164:	0007c863          	bltz	a5,80005174 <sys_fstat+0x32>
  return filestat(f, st);
    80005168:	fe043583          	ld	a1,-32(s0)
    8000516c:	fe843503          	ld	a0,-24(s0)
    80005170:	b82ff0ef          	jal	800044f2 <filestat>
}
    80005174:	60e2                	ld	ra,24(sp)
    80005176:	6442                	ld	s0,16(sp)
    80005178:	6105                	addi	sp,sp,32
    8000517a:	8082                	ret

000000008000517c <sys_link>:
{
    8000517c:	7169                	addi	sp,sp,-304
    8000517e:	f606                	sd	ra,296(sp)
    80005180:	f222                	sd	s0,288(sp)
    80005182:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005184:	08000613          	li	a2,128
    80005188:	ed040593          	addi	a1,s0,-304
    8000518c:	4501                	li	a0,0
    8000518e:	9ddfd0ef          	jal	80002b6a <argstr>
    return -1;
    80005192:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005194:	10054163          	bltz	a0,80005296 <sys_link+0x11a>
    80005198:	08000613          	li	a2,128
    8000519c:	f5040593          	addi	a1,s0,-176
    800051a0:	4505                	li	a0,1
    800051a2:	9c9fd0ef          	jal	80002b6a <argstr>
    return -1;
    800051a6:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800051a8:	0e054763          	bltz	a0,80005296 <sys_link+0x11a>
    800051ac:	ee26                	sd	s1,280(sp)
  begin_op();
    800051ae:	dc9fe0ef          	jal	80003f76 <begin_op>
  if ((ip = namei(old)) == 0) {
    800051b2:	ed040513          	addi	a0,s0,-304
    800051b6:	be3fe0ef          	jal	80003d98 <namei>
    800051ba:	84aa                	mv	s1,a0
    800051bc:	cd35                	beqz	a0,80005238 <sys_link+0xbc>
  ilock(ip);
    800051be:	b4efe0ef          	jal	8000350c <ilock>
  if (ip->type == T_DIR) {
    800051c2:	04449703          	lh	a4,68(s1)
    800051c6:	4785                	li	a5,1
    800051c8:	06f70d63          	beq	a4,a5,80005242 <sys_link+0xc6>
  if (ip->nlink >= NLINK_MAX) {
    800051cc:	04a49783          	lh	a5,74(s1)
    800051d0:	6721                	lui	a4,0x8
    800051d2:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    800051d4:	06e78f63          	beq	a5,a4,80005252 <sys_link+0xd6>
    800051d8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800051da:	2785                	addiw	a5,a5,1
    800051dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800051e0:	8526                	mv	a0,s1
    800051e2:	a76fe0ef          	jal	80003458 <iupdate>
  iunlock(ip);
    800051e6:	8526                	mv	a0,s1
    800051e8:	bd2fe0ef          	jal	800035ba <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    800051ec:	fd040593          	addi	a1,s0,-48
    800051f0:	f5040513          	addi	a0,s0,-176
    800051f4:	bbffe0ef          	jal	80003db2 <nameiparent>
    800051f8:	892a                	mv	s2,a0
    800051fa:	c93d                	beqz	a0,80005270 <sys_link+0xf4>
  ilock(dp);
    800051fc:	b10fe0ef          	jal	8000350c <ilock>
  if (dp->nlink == 0) {
    80005200:	04a91783          	lh	a5,74(s2)
    80005204:	cfb9                	beqz	a5,80005262 <sys_link+0xe6>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80005206:	854a                	mv	a0,s2
    80005208:	00092703          	lw	a4,0(s2)
    8000520c:	409c                	lw	a5,0(s1)
    8000520e:	04f71e63          	bne	a4,a5,8000526a <sys_link+0xee>
    80005212:	40d0                	lw	a2,4(s1)
    80005214:	fd040593          	addi	a1,s0,-48
    80005218:	ad7fe0ef          	jal	80003cee <dirlink>
    8000521c:	04054763          	bltz	a0,8000526a <sys_link+0xee>
  iunlockput(dp);
    80005220:	854a                	mv	a0,s2
    80005222:	d3efe0ef          	jal	80003760 <iunlockput>
  iput(ip);
    80005226:	8526                	mv	a0,s1
    80005228:	c66fe0ef          	jal	8000368e <iput>
  end_op();
    8000522c:	dd7fe0ef          	jal	80004002 <end_op>
  return 0;
    80005230:	4781                	li	a5,0
    80005232:	64f2                	ld	s1,280(sp)
    80005234:	6952                	ld	s2,272(sp)
    80005236:	a085                	j	80005296 <sys_link+0x11a>
    end_op();
    80005238:	dcbfe0ef          	jal	80004002 <end_op>
    return -1;
    8000523c:	57fd                	li	a5,-1
    8000523e:	64f2                	ld	s1,280(sp)
    80005240:	a899                	j	80005296 <sys_link+0x11a>
    iunlockput(ip);
    80005242:	8526                	mv	a0,s1
    80005244:	d1cfe0ef          	jal	80003760 <iunlockput>
    end_op();
    80005248:	dbbfe0ef          	jal	80004002 <end_op>
    return -1;
    8000524c:	57fd                	li	a5,-1
    8000524e:	64f2                	ld	s1,280(sp)
    80005250:	a099                	j	80005296 <sys_link+0x11a>
    iunlockput(ip);
    80005252:	8526                	mv	a0,s1
    80005254:	d0cfe0ef          	jal	80003760 <iunlockput>
    end_op();
    80005258:	dabfe0ef          	jal	80004002 <end_op>
    return -1;
    8000525c:	57fd                	li	a5,-1
    8000525e:	64f2                	ld	s1,280(sp)
    80005260:	a81d                	j	80005296 <sys_link+0x11a>
    iunlockput(dp);
    80005262:	854a                	mv	a0,s2
    80005264:	cfcfe0ef          	jal	80003760 <iunlockput>
    goto bad;
    80005268:	a021                	j	80005270 <sys_link+0xf4>
    iunlockput(dp);
    8000526a:	854a                	mv	a0,s2
    8000526c:	cf4fe0ef          	jal	80003760 <iunlockput>
  ilock(ip);
    80005270:	8526                	mv	a0,s1
    80005272:	a9afe0ef          	jal	8000350c <ilock>
  ip->nlink--;
    80005276:	04a4d783          	lhu	a5,74(s1)
    8000527a:	37fd                	addiw	a5,a5,-1
    8000527c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005280:	8526                	mv	a0,s1
    80005282:	9d6fe0ef          	jal	80003458 <iupdate>
  iunlockput(ip);
    80005286:	8526                	mv	a0,s1
    80005288:	cd8fe0ef          	jal	80003760 <iunlockput>
  end_op();
    8000528c:	d77fe0ef          	jal	80004002 <end_op>
  return -1;
    80005290:	57fd                	li	a5,-1
    80005292:	64f2                	ld	s1,280(sp)
    80005294:	6952                	ld	s2,272(sp)
}
    80005296:	853e                	mv	a0,a5
    80005298:	70b2                	ld	ra,296(sp)
    8000529a:	7412                	ld	s0,288(sp)
    8000529c:	6155                	addi	sp,sp,304
    8000529e:	8082                	ret

00000000800052a0 <sys_unlink>:
{
    800052a0:	7151                	addi	sp,sp,-240
    800052a2:	f586                	sd	ra,232(sp)
    800052a4:	f1a2                	sd	s0,224(sp)
    800052a6:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800052a8:	08000613          	li	a2,128
    800052ac:	f3040593          	addi	a1,s0,-208
    800052b0:	4501                	li	a0,0
    800052b2:	8b9fd0ef          	jal	80002b6a <argstr>
    800052b6:	14054d63          	bltz	a0,80005410 <sys_unlink+0x170>
    800052ba:	eda6                	sd	s1,216(sp)
  begin_op();
    800052bc:	cbbfe0ef          	jal	80003f76 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800052c0:	fb040593          	addi	a1,s0,-80
    800052c4:	f3040513          	addi	a0,s0,-208
    800052c8:	aebfe0ef          	jal	80003db2 <nameiparent>
    800052cc:	84aa                	mv	s1,a0
    800052ce:	c955                	beqz	a0,80005382 <sys_unlink+0xe2>
  ilock(dp);
    800052d0:	a3cfe0ef          	jal	8000350c <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800052d4:	00002597          	auipc	a1,0x2
    800052d8:	42458593          	addi	a1,a1,1060 # 800076f8 <etext+0x6f8>
    800052dc:	fb040513          	addi	a0,s0,-80
    800052e0:	ffefe0ef          	jal	80003ade <namecmp>
    800052e4:	10050b63          	beqz	a0,800053fa <sys_unlink+0x15a>
    800052e8:	00002597          	auipc	a1,0x2
    800052ec:	41858593          	addi	a1,a1,1048 # 80007700 <etext+0x700>
    800052f0:	fb040513          	addi	a0,s0,-80
    800052f4:	feafe0ef          	jal	80003ade <namecmp>
    800052f8:	10050163          	beqz	a0,800053fa <sys_unlink+0x15a>
    800052fc:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    800052fe:	f2c40613          	addi	a2,s0,-212
    80005302:	fb040593          	addi	a1,s0,-80
    80005306:	8526                	mv	a0,s1
    80005308:	fecfe0ef          	jal	80003af4 <dirlookup>
    8000530c:	892a                	mv	s2,a0
    8000530e:	0e050563          	beqz	a0,800053f8 <sys_unlink+0x158>
    80005312:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005314:	9f8fe0ef          	jal	8000350c <ilock>
  if (ip->nlink < 1)
    80005318:	04a91783          	lh	a5,74(s2)
    8000531c:	06f05863          	blez	a5,8000538c <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005320:	04491703          	lh	a4,68(s2)
    80005324:	4785                	li	a5,1
    80005326:	06f70963          	beq	a4,a5,80005398 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    8000532a:	fc040993          	addi	s3,s0,-64
    8000532e:	4641                	li	a2,16
    80005330:	4581                	li	a1,0
    80005332:	854e                	mv	a0,s3
    80005334:	975fb0ef          	jal	80000ca8 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005338:	4741                	li	a4,16
    8000533a:	f2c42683          	lw	a3,-212(s0)
    8000533e:	864e                	mv	a2,s3
    80005340:	4581                	li	a1,0
    80005342:	8526                	mv	a0,s1
    80005344:	e94fe0ef          	jal	800039d8 <writei>
    80005348:	47c1                	li	a5,16
    8000534a:	08f51863          	bne	a0,a5,800053da <sys_unlink+0x13a>
  if (ip->type == T_DIR) {
    8000534e:	04491703          	lh	a4,68(s2)
    80005352:	4785                	li	a5,1
    80005354:	08f70963          	beq	a4,a5,800053e6 <sys_unlink+0x146>
  iunlockput(dp);
    80005358:	8526                	mv	a0,s1
    8000535a:	c06fe0ef          	jal	80003760 <iunlockput>
  ip->nlink--;
    8000535e:	04a95783          	lhu	a5,74(s2)
    80005362:	37fd                	addiw	a5,a5,-1
    80005364:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005368:	854a                	mv	a0,s2
    8000536a:	8eefe0ef          	jal	80003458 <iupdate>
  iunlockput(ip);
    8000536e:	854a                	mv	a0,s2
    80005370:	bf0fe0ef          	jal	80003760 <iunlockput>
  end_op();
    80005374:	c8ffe0ef          	jal	80004002 <end_op>
  return 0;
    80005378:	4501                	li	a0,0
    8000537a:	64ee                	ld	s1,216(sp)
    8000537c:	694e                	ld	s2,208(sp)
    8000537e:	69ae                	ld	s3,200(sp)
    80005380:	a061                	j	80005408 <sys_unlink+0x168>
    end_op();
    80005382:	c81fe0ef          	jal	80004002 <end_op>
    return -1;
    80005386:	557d                	li	a0,-1
    80005388:	64ee                	ld	s1,216(sp)
    8000538a:	a8bd                	j	80005408 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000538c:	00002517          	auipc	a0,0x2
    80005390:	37c50513          	addi	a0,a0,892 # 80007708 <etext+0x708>
    80005394:	ca0fb0ef          	jal	80000834 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005398:	04c92703          	lw	a4,76(s2)
    8000539c:	02000793          	li	a5,32
    800053a0:	f8e7f5e3          	bgeu	a5,a4,8000532a <sys_unlink+0x8a>
    800053a4:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800053a6:	4741                	li	a4,16
    800053a8:	86ce                	mv	a3,s3
    800053aa:	f1840613          	addi	a2,s0,-232
    800053ae:	4581                	li	a1,0
    800053b0:	854a                	mv	a0,s2
    800053b2:	d34fe0ef          	jal	800038e6 <readi>
    800053b6:	47c1                	li	a5,16
    800053b8:	00f51b63          	bne	a0,a5,800053ce <sys_unlink+0x12e>
    if (de.inum != 0)
    800053bc:	f1845783          	lhu	a5,-232(s0)
    800053c0:	ebb1                	bnez	a5,80005414 <sys_unlink+0x174>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800053c2:	29c1                	addiw	s3,s3,16
    800053c4:	04c92783          	lw	a5,76(s2)
    800053c8:	fcf9efe3          	bltu	s3,a5,800053a6 <sys_unlink+0x106>
    800053cc:	bfb9                	j	8000532a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800053ce:	00002517          	auipc	a0,0x2
    800053d2:	35250513          	addi	a0,a0,850 # 80007720 <etext+0x720>
    800053d6:	c5efb0ef          	jal	80000834 <panic>
    panic("unlink: writei");
    800053da:	00002517          	auipc	a0,0x2
    800053de:	35e50513          	addi	a0,a0,862 # 80007738 <etext+0x738>
    800053e2:	c52fb0ef          	jal	80000834 <panic>
    dp->nlink--;
    800053e6:	04a4d783          	lhu	a5,74(s1)
    800053ea:	37fd                	addiw	a5,a5,-1
    800053ec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800053f0:	8526                	mv	a0,s1
    800053f2:	866fe0ef          	jal	80003458 <iupdate>
    800053f6:	b78d                	j	80005358 <sys_unlink+0xb8>
    800053f8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800053fa:	8526                	mv	a0,s1
    800053fc:	b64fe0ef          	jal	80003760 <iunlockput>
  end_op();
    80005400:	c03fe0ef          	jal	80004002 <end_op>
  return -1;
    80005404:	557d                	li	a0,-1
    80005406:	64ee                	ld	s1,216(sp)
}
    80005408:	70ae                	ld	ra,232(sp)
    8000540a:	740e                	ld	s0,224(sp)
    8000540c:	616d                	addi	sp,sp,240
    8000540e:	8082                	ret
    return -1;
    80005410:	557d                	li	a0,-1
    80005412:	bfdd                	j	80005408 <sys_unlink+0x168>
    iunlockput(ip);
    80005414:	854a                	mv	a0,s2
    80005416:	b4afe0ef          	jal	80003760 <iunlockput>
    goto bad;
    8000541a:	694e                	ld	s2,208(sp)
    8000541c:	69ae                	ld	s3,200(sp)
    8000541e:	bff1                	j	800053fa <sys_unlink+0x15a>

0000000080005420 <sys_open>:

uint64
sys_open(void)
{
    80005420:	7131                	addi	sp,sp,-192
    80005422:	fd06                	sd	ra,184(sp)
    80005424:	f922                	sd	s0,176(sp)
    80005426:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005428:	f4c40593          	addi	a1,s0,-180
    8000542c:	4505                	li	a0,1
    8000542e:	f04fd0ef          	jal	80002b32 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005432:	08000613          	li	a2,128
    80005436:	f5040593          	addi	a1,s0,-176
    8000543a:	4501                	li	a0,0
    8000543c:	f2efd0ef          	jal	80002b6a <argstr>
    80005440:	87aa                	mv	a5,a0
    return -1;
    80005442:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005444:	0a07c363          	bltz	a5,800054ea <sys_open+0xca>
    80005448:	f526                	sd	s1,168(sp)

  begin_op();
    8000544a:	b2dfe0ef          	jal	80003f76 <begin_op>

  if (omode & O_CREATE) {
    8000544e:	f4c42783          	lw	a5,-180(s0)
    80005452:	2007f793          	andi	a5,a5,512
    80005456:	c3dd                	beqz	a5,800054fc <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005458:	4681                	li	a3,0
    8000545a:	4601                	li	a2,0
    8000545c:	4589                	li	a1,2
    8000545e:	f5040513          	addi	a0,s0,-176
    80005462:	a5dff0ef          	jal	80004ebe <create>
    80005466:	84aa                	mv	s1,a0
    if (ip == 0) {
    80005468:	c549                	beqz	a0,800054f2 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    8000546a:	04449703          	lh	a4,68(s1)
    8000546e:	478d                	li	a5,3
    80005470:	00f71763          	bne	a4,a5,8000547e <sys_open+0x5e>
    80005474:	0464d703          	lhu	a4,70(s1)
    80005478:	47a5                	li	a5,9
    8000547a:	0ae7ee63          	bltu	a5,a4,80005536 <sys_open+0x116>
    8000547e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005480:	f0dfe0ef          	jal	8000438c <filealloc>
    80005484:	892a                	mv	s2,a0
    80005486:	c561                	beqz	a0,8000554e <sys_open+0x12e>
    80005488:	ed4e                	sd	s3,152(sp)
    8000548a:	9f5ff0ef          	jal	80004e7e <fdalloc>
    8000548e:	89aa                	mv	s3,a0
    80005490:	0a054b63          	bltz	a0,80005546 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005494:	04449703          	lh	a4,68(s1)
    80005498:	478d                	li	a5,3
    8000549a:	0cf70363          	beq	a4,a5,80005560 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000549e:	4789                	li	a5,2
    800054a0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800054a4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800054a8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800054ac:	f4c42783          	lw	a5,-180(s0)
    800054b0:	0017f713          	andi	a4,a5,1
    800054b4:	00174713          	xori	a4,a4,1
    800054b8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800054bc:	0037f713          	andi	a4,a5,3
    800054c0:	00e03733          	snez	a4,a4
    800054c4:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800054c8:	4007f793          	andi	a5,a5,1024
    800054cc:	c791                	beqz	a5,800054d8 <sys_open+0xb8>
    800054ce:	04449703          	lh	a4,68(s1)
    800054d2:	4789                	li	a5,2
    800054d4:	08f70d63          	beq	a4,a5,8000556e <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800054d8:	8526                	mv	a0,s1
    800054da:	8e0fe0ef          	jal	800035ba <iunlock>
  end_op();
    800054de:	b25fe0ef          	jal	80004002 <end_op>

  return fd;
    800054e2:	854e                	mv	a0,s3
    800054e4:	74aa                	ld	s1,168(sp)
    800054e6:	790a                	ld	s2,160(sp)
    800054e8:	69ea                	ld	s3,152(sp)
}
    800054ea:	70ea                	ld	ra,184(sp)
    800054ec:	744a                	ld	s0,176(sp)
    800054ee:	6129                	addi	sp,sp,192
    800054f0:	8082                	ret
      end_op();
    800054f2:	b11fe0ef          	jal	80004002 <end_op>
      return -1;
    800054f6:	557d                	li	a0,-1
    800054f8:	74aa                	ld	s1,168(sp)
    800054fa:	bfc5                	j	800054ea <sys_open+0xca>
    if ((ip = namei(path)) == 0) {
    800054fc:	f5040513          	addi	a0,s0,-176
    80005500:	899fe0ef          	jal	80003d98 <namei>
    80005504:	84aa                	mv	s1,a0
    80005506:	c11d                	beqz	a0,8000552c <sys_open+0x10c>
    ilock(ip);
    80005508:	804fe0ef          	jal	8000350c <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    8000550c:	04449703          	lh	a4,68(s1)
    80005510:	4785                	li	a5,1
    80005512:	f4f71ce3          	bne	a4,a5,8000546a <sys_open+0x4a>
    80005516:	f4c42783          	lw	a5,-180(s0)
    8000551a:	d3b5                	beqz	a5,8000547e <sys_open+0x5e>
      iunlockput(ip);
    8000551c:	8526                	mv	a0,s1
    8000551e:	a42fe0ef          	jal	80003760 <iunlockput>
      end_op();
    80005522:	ae1fe0ef          	jal	80004002 <end_op>
      return -1;
    80005526:	557d                	li	a0,-1
    80005528:	74aa                	ld	s1,168(sp)
    8000552a:	b7c1                	j	800054ea <sys_open+0xca>
      end_op();
    8000552c:	ad7fe0ef          	jal	80004002 <end_op>
      return -1;
    80005530:	557d                	li	a0,-1
    80005532:	74aa                	ld	s1,168(sp)
    80005534:	bf5d                	j	800054ea <sys_open+0xca>
    iunlockput(ip);
    80005536:	8526                	mv	a0,s1
    80005538:	a28fe0ef          	jal	80003760 <iunlockput>
    end_op();
    8000553c:	ac7fe0ef          	jal	80004002 <end_op>
    return -1;
    80005540:	557d                	li	a0,-1
    80005542:	74aa                	ld	s1,168(sp)
    80005544:	b75d                	j	800054ea <sys_open+0xca>
      fileclose(f);
    80005546:	854a                	mv	a0,s2
    80005548:	ee9fe0ef          	jal	80004430 <fileclose>
    8000554c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000554e:	8526                	mv	a0,s1
    80005550:	a10fe0ef          	jal	80003760 <iunlockput>
    end_op();
    80005554:	aaffe0ef          	jal	80004002 <end_op>
    return -1;
    80005558:	557d                	li	a0,-1
    8000555a:	74aa                	ld	s1,168(sp)
    8000555c:	790a                	ld	s2,160(sp)
    8000555e:	b771                	j	800054ea <sys_open+0xca>
    f->type = FD_DEVICE;
    80005560:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005564:	04649783          	lh	a5,70(s1)
    80005568:	02f91223          	sh	a5,36(s2)
    8000556c:	bf35                	j	800054a8 <sys_open+0x88>
    itrunc(ip);
    8000556e:	8526                	mv	a0,s1
    80005570:	88afe0ef          	jal	800035fa <itrunc>
    80005574:	b795                	j	800054d8 <sys_open+0xb8>

0000000080005576 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005576:	7175                	addi	sp,sp,-144
    80005578:	e506                	sd	ra,136(sp)
    8000557a:	e122                	sd	s0,128(sp)
    8000557c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000557e:	9f9fe0ef          	jal	80003f76 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005582:	08000613          	li	a2,128
    80005586:	f7040593          	addi	a1,s0,-144
    8000558a:	4501                	li	a0,0
    8000558c:	ddefd0ef          	jal	80002b6a <argstr>
    80005590:	02054363          	bltz	a0,800055b6 <sys_mkdir+0x40>
    80005594:	4681                	li	a3,0
    80005596:	4601                	li	a2,0
    80005598:	4585                	li	a1,1
    8000559a:	f7040513          	addi	a0,s0,-144
    8000559e:	921ff0ef          	jal	80004ebe <create>
    800055a2:	c911                	beqz	a0,800055b6 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800055a4:	9bcfe0ef          	jal	80003760 <iunlockput>
  end_op();
    800055a8:	a5bfe0ef          	jal	80004002 <end_op>
  return 0;
    800055ac:	4501                	li	a0,0
}
    800055ae:	60aa                	ld	ra,136(sp)
    800055b0:	640a                	ld	s0,128(sp)
    800055b2:	6149                	addi	sp,sp,144
    800055b4:	8082                	ret
    end_op();
    800055b6:	a4dfe0ef          	jal	80004002 <end_op>
    return -1;
    800055ba:	557d                	li	a0,-1
    800055bc:	bfcd                	j	800055ae <sys_mkdir+0x38>

00000000800055be <sys_mknod>:

uint64
sys_mknod(void)
{
    800055be:	7135                	addi	sp,sp,-160
    800055c0:	ed06                	sd	ra,152(sp)
    800055c2:	e922                	sd	s0,144(sp)
    800055c4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800055c6:	9b1fe0ef          	jal	80003f76 <begin_op>
  argint(1, &major);
    800055ca:	f6c40593          	addi	a1,s0,-148
    800055ce:	4505                	li	a0,1
    800055d0:	d62fd0ef          	jal	80002b32 <argint>
  argint(2, &minor);
    800055d4:	f6840593          	addi	a1,s0,-152
    800055d8:	4509                	li	a0,2
    800055da:	d58fd0ef          	jal	80002b32 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800055de:	08000613          	li	a2,128
    800055e2:	f7040593          	addi	a1,s0,-144
    800055e6:	4501                	li	a0,0
    800055e8:	d82fd0ef          	jal	80002b6a <argstr>
    800055ec:	02054563          	bltz	a0,80005616 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    800055f0:	f6841683          	lh	a3,-152(s0)
    800055f4:	f6c41603          	lh	a2,-148(s0)
    800055f8:	458d                	li	a1,3
    800055fa:	f7040513          	addi	a0,s0,-144
    800055fe:	8c1ff0ef          	jal	80004ebe <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005602:	c911                	beqz	a0,80005616 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005604:	95cfe0ef          	jal	80003760 <iunlockput>
  end_op();
    80005608:	9fbfe0ef          	jal	80004002 <end_op>
  return 0;
    8000560c:	4501                	li	a0,0
}
    8000560e:	60ea                	ld	ra,152(sp)
    80005610:	644a                	ld	s0,144(sp)
    80005612:	610d                	addi	sp,sp,160
    80005614:	8082                	ret
    end_op();
    80005616:	9edfe0ef          	jal	80004002 <end_op>
    return -1;
    8000561a:	557d                	li	a0,-1
    8000561c:	bfcd                	j	8000560e <sys_mknod+0x50>

000000008000561e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000561e:	7135                	addi	sp,sp,-160
    80005620:	ed06                	sd	ra,152(sp)
    80005622:	e922                	sd	s0,144(sp)
    80005624:	e14a                	sd	s2,128(sp)
    80005626:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005628:	ad4fc0ef          	jal	800018fc <myproc>
    8000562c:	892a                	mv	s2,a0

  begin_op();
    8000562e:	949fe0ef          	jal	80003f76 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005632:	08000613          	li	a2,128
    80005636:	f6040593          	addi	a1,s0,-160
    8000563a:	4501                	li	a0,0
    8000563c:	d2efd0ef          	jal	80002b6a <argstr>
    80005640:	04054363          	bltz	a0,80005686 <sys_chdir+0x68>
    80005644:	e526                	sd	s1,136(sp)
    80005646:	f6040513          	addi	a0,s0,-160
    8000564a:	f4efe0ef          	jal	80003d98 <namei>
    8000564e:	84aa                	mv	s1,a0
    80005650:	c915                	beqz	a0,80005684 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005652:	ebbfd0ef          	jal	8000350c <ilock>
  if (ip->type != T_DIR) {
    80005656:	04449703          	lh	a4,68(s1)
    8000565a:	4785                	li	a5,1
    8000565c:	02f71963          	bne	a4,a5,8000568e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005660:	8526                	mv	a0,s1
    80005662:	f59fd0ef          	jal	800035ba <iunlock>
  iput(p->cwd);
    80005666:	15093503          	ld	a0,336(s2)
    8000566a:	824fe0ef          	jal	8000368e <iput>
  end_op();
    8000566e:	995fe0ef          	jal	80004002 <end_op>
  p->cwd = ip;
    80005672:	14993823          	sd	s1,336(s2)
  return 0;
    80005676:	4501                	li	a0,0
    80005678:	64aa                	ld	s1,136(sp)
}
    8000567a:	60ea                	ld	ra,152(sp)
    8000567c:	644a                	ld	s0,144(sp)
    8000567e:	690a                	ld	s2,128(sp)
    80005680:	610d                	addi	sp,sp,160
    80005682:	8082                	ret
    80005684:	64aa                	ld	s1,136(sp)
    end_op();
    80005686:	97dfe0ef          	jal	80004002 <end_op>
    return -1;
    8000568a:	557d                	li	a0,-1
    8000568c:	b7fd                	j	8000567a <sys_chdir+0x5c>
    iunlockput(ip);
    8000568e:	8526                	mv	a0,s1
    80005690:	8d0fe0ef          	jal	80003760 <iunlockput>
    end_op();
    80005694:	96ffe0ef          	jal	80004002 <end_op>
    return -1;
    80005698:	557d                	li	a0,-1
    8000569a:	64aa                	ld	s1,136(sp)
    8000569c:	bff9                	j	8000567a <sys_chdir+0x5c>

000000008000569e <sys_exec>:

uint64
sys_exec(void)
{
    8000569e:	7105                	addi	sp,sp,-480
    800056a0:	ef86                	sd	ra,472(sp)
    800056a2:	eba2                	sd	s0,464(sp)
    800056a4:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800056a6:	e2840593          	addi	a1,s0,-472
    800056aa:	4505                	li	a0,1
    800056ac:	ca2fd0ef          	jal	80002b4e <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    800056b0:	08000613          	li	a2,128
    800056b4:	f3040593          	addi	a1,s0,-208
    800056b8:	4501                	li	a0,0
    800056ba:	cb0fd0ef          	jal	80002b6a <argstr>
    800056be:	87aa                	mv	a5,a0
    return -1;
    800056c0:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    800056c2:	0e07c063          	bltz	a5,800057a2 <sys_exec+0x104>
    800056c6:	e7a6                	sd	s1,456(sp)
    800056c8:	e3ca                	sd	s2,448(sp)
    800056ca:	ff4e                	sd	s3,440(sp)
    800056cc:	fb52                	sd	s4,432(sp)
    800056ce:	f756                	sd	s5,424(sp)
    800056d0:	f35a                	sd	s6,416(sp)
    800056d2:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800056d4:	e3040a13          	addi	s4,s0,-464
    800056d8:	10000613          	li	a2,256
    800056dc:	4581                	li	a1,0
    800056de:	8552                	mv	a0,s4
    800056e0:	dc8fb0ef          	jal	80000ca8 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800056e4:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800056e6:	89d2                	mv	s3,s4
    800056e8:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800056ea:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800056ee:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    800056f0:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800056f4:	00391513          	slli	a0,s2,0x3
    800056f8:	85d6                	mv	a1,s5
    800056fa:	e2843783          	ld	a5,-472(s0)
    800056fe:	953e                	add	a0,a0,a5
    80005700:	ba6fd0ef          	jal	80002aa6 <fetchaddr>
    80005704:	02054663          	bltz	a0,80005730 <sys_exec+0x92>
    if (uarg == 0) {
    80005708:	e2043783          	ld	a5,-480(s0)
    8000570c:	c7a1                	beqz	a5,80005754 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000570e:	c00fb0ef          	jal	80000b0e <kalloc>
    80005712:	85aa                	mv	a1,a0
    80005714:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005718:	cd01                	beqz	a0,80005730 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000571a:	865a                	mv	a2,s6
    8000571c:	e2043503          	ld	a0,-480(s0)
    80005720:	bd0fd0ef          	jal	80002af0 <fetchstr>
    80005724:	00054663          	bltz	a0,80005730 <sys_exec+0x92>
    if (i >= NELEM(argv)) {
    80005728:	0905                	addi	s2,s2,1
    8000572a:	09a1                	addi	s3,s3,8
    8000572c:	fd7914e3          	bne	s2,s7,800056f4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005730:	100a0a13          	addi	s4,s4,256
    80005734:	6088                	ld	a0,0(s1)
    80005736:	cd31                	beqz	a0,80005792 <sys_exec+0xf4>
    kfree(argv[i]);
    80005738:	aeefb0ef          	jal	80000a26 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000573c:	04a1                	addi	s1,s1,8
    8000573e:	ff449be3          	bne	s1,s4,80005734 <sys_exec+0x96>
  return -1;
    80005742:	557d                	li	a0,-1
    80005744:	64be                	ld	s1,456(sp)
    80005746:	691e                	ld	s2,448(sp)
    80005748:	79fa                	ld	s3,440(sp)
    8000574a:	7a5a                	ld	s4,432(sp)
    8000574c:	7aba                	ld	s5,424(sp)
    8000574e:	7b1a                	ld	s6,416(sp)
    80005750:	6bfa                	ld	s7,408(sp)
    80005752:	a881                	j	800057a2 <sys_exec+0x104>
      argv[i] = 0;
    80005754:	0009079b          	sext.w	a5,s2
    80005758:	e3040593          	addi	a1,s0,-464
    8000575c:	078e                	slli	a5,a5,0x3
    8000575e:	97ae                	add	a5,a5,a1
    80005760:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005764:	f3040513          	addi	a0,s0,-208
    80005768:	b62ff0ef          	jal	80004aca <kexec>
    8000576c:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000576e:	100a0a13          	addi	s4,s4,256
    80005772:	6088                	ld	a0,0(s1)
    80005774:	c511                	beqz	a0,80005780 <sys_exec+0xe2>
    kfree(argv[i]);
    80005776:	ab0fb0ef          	jal	80000a26 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000577a:	04a1                	addi	s1,s1,8
    8000577c:	ff449be3          	bne	s1,s4,80005772 <sys_exec+0xd4>
  return ret;
    80005780:	854a                	mv	a0,s2
    80005782:	64be                	ld	s1,456(sp)
    80005784:	691e                	ld	s2,448(sp)
    80005786:	79fa                	ld	s3,440(sp)
    80005788:	7a5a                	ld	s4,432(sp)
    8000578a:	7aba                	ld	s5,424(sp)
    8000578c:	7b1a                	ld	s6,416(sp)
    8000578e:	6bfa                	ld	s7,408(sp)
    80005790:	a809                	j	800057a2 <sys_exec+0x104>
  return -1;
    80005792:	557d                	li	a0,-1
    80005794:	64be                	ld	s1,456(sp)
    80005796:	691e                	ld	s2,448(sp)
    80005798:	79fa                	ld	s3,440(sp)
    8000579a:	7a5a                	ld	s4,432(sp)
    8000579c:	7aba                	ld	s5,424(sp)
    8000579e:	7b1a                	ld	s6,416(sp)
    800057a0:	6bfa                	ld	s7,408(sp)
}
    800057a2:	60fe                	ld	ra,472(sp)
    800057a4:	645e                	ld	s0,464(sp)
    800057a6:	613d                	addi	sp,sp,480
    800057a8:	8082                	ret

00000000800057aa <sys_pipe>:

uint64
sys_pipe(void)
{
    800057aa:	7139                	addi	sp,sp,-64
    800057ac:	fc06                	sd	ra,56(sp)
    800057ae:	f822                	sd	s0,48(sp)
    800057b0:	f426                	sd	s1,40(sp)
    800057b2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800057b4:	948fc0ef          	jal	800018fc <myproc>
    800057b8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800057ba:	fd840593          	addi	a1,s0,-40
    800057be:	4501                	li	a0,0
    800057c0:	b8efd0ef          	jal	80002b4e <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    800057c4:	fc840593          	addi	a1,s0,-56
    800057c8:	fd040513          	addi	a0,s0,-48
    800057cc:	f99fe0ef          	jal	80004764 <pipealloc>
    return -1;
    800057d0:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    800057d2:	0a054963          	bltz	a0,80005884 <sys_pipe+0xda>
  fd0 = -1;
    800057d6:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800057da:	fd043503          	ld	a0,-48(s0)
    800057de:	ea0ff0ef          	jal	80004e7e <fdalloc>
    800057e2:	fca42223          	sw	a0,-60(s0)
    800057e6:	08054663          	bltz	a0,80005872 <sys_pipe+0xc8>
    800057ea:	fc843503          	ld	a0,-56(s0)
    800057ee:	e90ff0ef          	jal	80004e7e <fdalloc>
    800057f2:	fca42023          	sw	a0,-64(s0)
    800057f6:	06054463          	bltz	a0,8000585e <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800057fa:	4711                	li	a4,4
    800057fc:	fc440693          	addi	a3,s0,-60
    80005800:	fd843603          	ld	a2,-40(s0)
    80005804:	64ac                	ld	a1,72(s1)
    80005806:	68a8                	ld	a0,80(s1)
    80005808:	d3bfb0ef          	jal	80001542 <copyout>
    8000580c:	00054f63          	bltz	a0,8000582a <sys_pipe+0x80>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80005810:	4711                	li	a4,4
    80005812:	fc040693          	addi	a3,s0,-64
    80005816:	fd843603          	ld	a2,-40(s0)
    8000581a:	963a                	add	a2,a2,a4
    8000581c:	64ac                	ld	a1,72(s1)
    8000581e:	68a8                	ld	a0,80(s1)
    80005820:	d23fb0ef          	jal	80001542 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005824:	4781                	li	a5,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005826:	04055f63          	bgez	a0,80005884 <sys_pipe+0xda>
    p->ofile[fd0] = 0;
    8000582a:	fc442783          	lw	a5,-60(s0)
    8000582e:	078e                	slli	a5,a5,0x3
    80005830:	0d078793          	addi	a5,a5,208
    80005834:	97a6                	add	a5,a5,s1
    80005836:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000583a:	fc042783          	lw	a5,-64(s0)
    8000583e:	078e                	slli	a5,a5,0x3
    80005840:	0d078793          	addi	a5,a5,208
    80005844:	94be                	add	s1,s1,a5
    80005846:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000584a:	fd043503          	ld	a0,-48(s0)
    8000584e:	be3fe0ef          	jal	80004430 <fileclose>
    fileclose(wf);
    80005852:	fc843503          	ld	a0,-56(s0)
    80005856:	bdbfe0ef          	jal	80004430 <fileclose>
    return -1;
    8000585a:	57fd                	li	a5,-1
    8000585c:	a025                	j	80005884 <sys_pipe+0xda>
    if (fd0 >= 0)
    8000585e:	fc442783          	lw	a5,-60(s0)
    80005862:	0007c863          	bltz	a5,80005872 <sys_pipe+0xc8>
      p->ofile[fd0] = 0;
    80005866:	078e                	slli	a5,a5,0x3
    80005868:	0d078793          	addi	a5,a5,208
    8000586c:	97a6                	add	a5,a5,s1
    8000586e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005872:	fd043503          	ld	a0,-48(s0)
    80005876:	bbbfe0ef          	jal	80004430 <fileclose>
    fileclose(wf);
    8000587a:	fc843503          	ld	a0,-56(s0)
    8000587e:	bb3fe0ef          	jal	80004430 <fileclose>
    return -1;
    80005882:	57fd                	li	a5,-1
}
    80005884:	853e                	mv	a0,a5
    80005886:	70e2                	ld	ra,56(sp)
    80005888:	7442                	ld	s0,48(sp)
    8000588a:	74a2                	ld	s1,40(sp)
    8000588c:	6121                	addi	sp,sp,64
    8000588e:	8082                	ret

0000000080005890 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005890:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005892:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005894:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005896:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005898:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000589a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000589c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000589e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800058a0:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800058a2:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800058a4:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800058a6:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800058a8:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800058aa:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800058ac:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800058ae:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800058b0:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800058b2:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800058b4:	900fd0ef          	jal	800029b4 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800058b8:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800058ba:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800058bc:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800058be:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800058c0:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800058c2:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800058c4:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800058c6:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800058c8:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800058ca:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800058cc:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800058ce:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800058d0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800058d2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800058d4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800058d6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800058d8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800058da:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800058dc:	10200073          	sret
    800058e0:	0001                	nop
    800058e2:	00000013          	nop
    800058e6:	00000013          	nop
    800058ea:	00000013          	nop

00000000800058ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800058ee:	1141                	addi	sp,sp,-16
    800058f0:	e406                	sd	ra,8(sp)
    800058f2:	e022                	sd	s0,0(sp)
    800058f4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    800058f6:	0c000737          	lui	a4,0xc000
    800058fa:	4785                	li	a5,1
    800058fc:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800058fe:	c35c                	sw	a5,4(a4)
}
    80005900:	60a2                	ld	ra,8(sp)
    80005902:	6402                	ld	s0,0(sp)
    80005904:	0141                	addi	sp,sp,16
    80005906:	8082                	ret

0000000080005908 <plicinithart>:

void
plicinithart(void)
{
    80005908:	1141                	addi	sp,sp,-16
    8000590a:	e406                	sd	ra,8(sp)
    8000590c:	e022                	sd	s0,0(sp)
    8000590e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005910:	fb9fb0ef          	jal	800018c8 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005914:	0085171b          	slliw	a4,a0,0x8
    80005918:	0c0027b7          	lui	a5,0xc002
    8000591c:	97ba                	add	a5,a5,a4
    8000591e:	40200713          	li	a4,1026
    80005922:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005926:	00d5151b          	slliw	a0,a0,0xd
    8000592a:	0c2017b7          	lui	a5,0xc201
    8000592e:	97aa                	add	a5,a5,a0
    80005930:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005934:	60a2                	ld	ra,8(sp)
    80005936:	6402                	ld	s0,0(sp)
    80005938:	0141                	addi	sp,sp,16
    8000593a:	8082                	ret

000000008000593c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000593c:	1141                	addi	sp,sp,-16
    8000593e:	e406                	sd	ra,8(sp)
    80005940:	e022                	sd	s0,0(sp)
    80005942:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005944:	f85fb0ef          	jal	800018c8 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005948:	00d5151b          	slliw	a0,a0,0xd
    8000594c:	0c2017b7          	lui	a5,0xc201
    80005950:	97aa                	add	a5,a5,a0
  return irq;
}
    80005952:	43c8                	lw	a0,4(a5)
    80005954:	60a2                	ld	ra,8(sp)
    80005956:	6402                	ld	s0,0(sp)
    80005958:	0141                	addi	sp,sp,16
    8000595a:	8082                	ret

000000008000595c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000595c:	1101                	addi	sp,sp,-32
    8000595e:	ec06                	sd	ra,24(sp)
    80005960:	e822                	sd	s0,16(sp)
    80005962:	e426                	sd	s1,8(sp)
    80005964:	1000                	addi	s0,sp,32
    80005966:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005968:	f61fb0ef          	jal	800018c8 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    8000596c:	00d5179b          	slliw	a5,a0,0xd
    80005970:	0c201737          	lui	a4,0xc201
    80005974:	97ba                	add	a5,a5,a4
    80005976:	c3c4                	sw	s1,4(a5)
}
    80005978:	60e2                	ld	ra,24(sp)
    8000597a:	6442                	ld	s0,16(sp)
    8000597c:	64a2                	ld	s1,8(sp)
    8000597e:	6105                	addi	sp,sp,32
    80005980:	8082                	ret

0000000080005982 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005982:	1141                	addi	sp,sp,-16
    80005984:	e406                	sd	ra,8(sp)
    80005986:	e022                	sd	s0,0(sp)
    80005988:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000598a:	479d                	li	a5,7
    8000598c:	04a7ca63          	blt	a5,a0,800059e0 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005990:	0001e797          	auipc	a5,0x1e
    80005994:	4d078793          	addi	a5,a5,1232 # 80023e60 <disk>
    80005998:	97aa                	add	a5,a5,a0
    8000599a:	0187c783          	lbu	a5,24(a5)
    8000599e:	e7b9                	bnez	a5,800059ec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800059a0:	00451693          	slli	a3,a0,0x4
    800059a4:	0001e797          	auipc	a5,0x1e
    800059a8:	4bc78793          	addi	a5,a5,1212 # 80023e60 <disk>
    800059ac:	6398                	ld	a4,0(a5)
    800059ae:	9736                	add	a4,a4,a3
    800059b0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800059b4:	6398                	ld	a4,0(a5)
    800059b6:	9736                	add	a4,a4,a3
    800059b8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800059bc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800059c0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800059c4:	97aa                	add	a5,a5,a0
    800059c6:	4705                	li	a4,1
    800059c8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800059cc:	0001e517          	auipc	a0,0x1e
    800059d0:	4ac50513          	addi	a0,a0,1196 # 80023e78 <disk+0x18>
    800059d4:	fe0fc0ef          	jal	800021b4 <wakeup>
}
    800059d8:	60a2                	ld	ra,8(sp)
    800059da:	6402                	ld	s0,0(sp)
    800059dc:	0141                	addi	sp,sp,16
    800059de:	8082                	ret
    panic("free_desc 1");
    800059e0:	00002517          	auipc	a0,0x2
    800059e4:	d6850513          	addi	a0,a0,-664 # 80007748 <etext+0x748>
    800059e8:	e4dfa0ef          	jal	80000834 <panic>
    panic("free_desc 2");
    800059ec:	00002517          	auipc	a0,0x2
    800059f0:	d6c50513          	addi	a0,a0,-660 # 80007758 <etext+0x758>
    800059f4:	e41fa0ef          	jal	80000834 <panic>

00000000800059f8 <virtio_disk_init>:
{
    800059f8:	1101                	addi	sp,sp,-32
    800059fa:	ec06                	sd	ra,24(sp)
    800059fc:	e822                	sd	s0,16(sp)
    800059fe:	e426                	sd	s1,8(sp)
    80005a00:	e04a                	sd	s2,0(sp)
    80005a02:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005a04:	00002597          	auipc	a1,0x2
    80005a08:	d6458593          	addi	a1,a1,-668 # 80007768 <etext+0x768>
    80005a0c:	0001e517          	auipc	a0,0x1e
    80005a10:	57c50513          	addi	a0,a0,1404 # 80023f88 <disk+0x128>
    80005a14:	954fb0ef          	jal	80000b68 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005a18:	100017b7          	lui	a5,0x10001
    80005a1c:	4398                	lw	a4,0(a5)
    80005a1e:	2701                	sext.w	a4,a4
    80005a20:	747277b7          	lui	a5,0x74727
    80005a24:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005a28:	14f71863          	bne	a4,a5,80005b78 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005a2c:	100017b7          	lui	a5,0x10001
    80005a30:	43dc                	lw	a5,4(a5)
    80005a32:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005a34:	4709                	li	a4,2
    80005a36:	14e79163          	bne	a5,a4,80005b78 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005a3a:	100017b7          	lui	a5,0x10001
    80005a3e:	479c                	lw	a5,8(a5)
    80005a40:	2781                	sext.w	a5,a5
    80005a42:	12e79b63          	bne	a5,a4,80005b78 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005a46:	100017b7          	lui	a5,0x10001
    80005a4a:	47d8                	lw	a4,12(a5)
    80005a4c:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005a4e:	554d47b7          	lui	a5,0x554d4
    80005a52:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005a56:	12f71163          	bne	a4,a5,80005b78 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a5a:	100017b7          	lui	a5,0x10001
    80005a5e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a62:	4705                	li	a4,1
    80005a64:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a66:	470d                	li	a4,3
    80005a68:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005a6a:	10001737          	lui	a4,0x10001
    80005a6e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005a70:	c7ffe6b7          	lui	a3,0xc7ffe
    80005a74:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fda5bf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005a78:	8f75                	and	a4,a4,a3
    80005a7a:	100016b7          	lui	a3,0x10001
    80005a7e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a80:	472d                	li	a4,11
    80005a82:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a84:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005a88:	439c                	lw	a5,0(a5)
    80005a8a:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005a8e:	8ba1                	andi	a5,a5,8
    80005a90:	0e078a63          	beqz	a5,80005b84 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005a94:	100017b7          	lui	a5,0x10001
    80005a98:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80005a9c:	43fc                	lw	a5,68(a5)
    80005a9e:	2781                	sext.w	a5,a5
    80005aa0:	0e079863          	bnez	a5,80005b90 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005aa4:	100017b7          	lui	a5,0x10001
    80005aa8:	5bdc                	lw	a5,52(a5)
    80005aaa:	2781                	sext.w	a5,a5
  if (max == 0)
    80005aac:	0e078863          	beqz	a5,80005b9c <virtio_disk_init+0x1a4>
  if (max < NUM)
    80005ab0:	471d                	li	a4,7
    80005ab2:	0ef77b63          	bgeu	a4,a5,80005ba8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005ab6:	858fb0ef          	jal	80000b0e <kalloc>
    80005aba:	0001e497          	auipc	s1,0x1e
    80005abe:	3a648493          	addi	s1,s1,934 # 80023e60 <disk>
    80005ac2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005ac4:	84afb0ef          	jal	80000b0e <kalloc>
    80005ac8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005aca:	844fb0ef          	jal	80000b0e <kalloc>
    80005ace:	87aa                	mv	a5,a0
    80005ad0:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80005ad2:	6088                	ld	a0,0(s1)
    80005ad4:	0e050063          	beqz	a0,80005bb4 <virtio_disk_init+0x1bc>
    80005ad8:	0001e717          	auipc	a4,0x1e
    80005adc:	39073703          	ld	a4,912(a4) # 80023e68 <disk+0x8>
    80005ae0:	cb71                	beqz	a4,80005bb4 <virtio_disk_init+0x1bc>
    80005ae2:	cbe9                	beqz	a5,80005bb4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005ae4:	6605                	lui	a2,0x1
    80005ae6:	4581                	li	a1,0
    80005ae8:	9c0fb0ef          	jal	80000ca8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005aec:	0001e497          	auipc	s1,0x1e
    80005af0:	37448493          	addi	s1,s1,884 # 80023e60 <disk>
    80005af4:	6605                	lui	a2,0x1
    80005af6:	4581                	li	a1,0
    80005af8:	6488                	ld	a0,8(s1)
    80005afa:	9aefb0ef          	jal	80000ca8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005afe:	6605                	lui	a2,0x1
    80005b00:	4581                	li	a1,0
    80005b02:	6888                	ld	a0,16(s1)
    80005b04:	9a4fb0ef          	jal	80000ca8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005b08:	100017b7          	lui	a5,0x10001
    80005b0c:	4721                	li	a4,8
    80005b0e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005b10:	4098                	lw	a4,0(s1)
    80005b12:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005b16:	40d8                	lw	a4,4(s1)
    80005b18:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005b1c:	649c                	ld	a5,8(s1)
    80005b1e:	0007869b          	sext.w	a3,a5
    80005b22:	10001737          	lui	a4,0x10001
    80005b26:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005b2a:	9781                	srai	a5,a5,0x20
    80005b2c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005b30:	689c                	ld	a5,16(s1)
    80005b32:	0007869b          	sext.w	a3,a5
    80005b36:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005b3a:	9781                	srai	a5,a5,0x20
    80005b3c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005b40:	4785                	li	a5,1
    80005b42:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005b44:	00f48c23          	sb	a5,24(s1)
    80005b48:	00f48ca3          	sb	a5,25(s1)
    80005b4c:	00f48d23          	sb	a5,26(s1)
    80005b50:	00f48da3          	sb	a5,27(s1)
    80005b54:	00f48e23          	sb	a5,28(s1)
    80005b58:	00f48ea3          	sb	a5,29(s1)
    80005b5c:	00f48f23          	sb	a5,30(s1)
    80005b60:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005b64:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b68:	07272823          	sw	s2,112(a4)
}
    80005b6c:	60e2                	ld	ra,24(sp)
    80005b6e:	6442                	ld	s0,16(sp)
    80005b70:	64a2                	ld	s1,8(sp)
    80005b72:	6902                	ld	s2,0(sp)
    80005b74:	6105                	addi	sp,sp,32
    80005b76:	8082                	ret
    panic("could not find virtio disk");
    80005b78:	00002517          	auipc	a0,0x2
    80005b7c:	c0050513          	addi	a0,a0,-1024 # 80007778 <etext+0x778>
    80005b80:	cb5fa0ef          	jal	80000834 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005b84:	00002517          	auipc	a0,0x2
    80005b88:	c1450513          	addi	a0,a0,-1004 # 80007798 <etext+0x798>
    80005b8c:	ca9fa0ef          	jal	80000834 <panic>
    panic("virtio disk should not be ready");
    80005b90:	00002517          	auipc	a0,0x2
    80005b94:	c2850513          	addi	a0,a0,-984 # 800077b8 <etext+0x7b8>
    80005b98:	c9dfa0ef          	jal	80000834 <panic>
    panic("virtio disk has no queue 0");
    80005b9c:	00002517          	auipc	a0,0x2
    80005ba0:	c3c50513          	addi	a0,a0,-964 # 800077d8 <etext+0x7d8>
    80005ba4:	c91fa0ef          	jal	80000834 <panic>
    panic("virtio disk max queue too short");
    80005ba8:	00002517          	auipc	a0,0x2
    80005bac:	c5050513          	addi	a0,a0,-944 # 800077f8 <etext+0x7f8>
    80005bb0:	c85fa0ef          	jal	80000834 <panic>
    panic("virtio disk kalloc");
    80005bb4:	00002517          	auipc	a0,0x2
    80005bb8:	c6450513          	addi	a0,a0,-924 # 80007818 <etext+0x818>
    80005bbc:	c79fa0ef          	jal	80000834 <panic>

0000000080005bc0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005bc0:	711d                	addi	sp,sp,-96
    80005bc2:	ec86                	sd	ra,88(sp)
    80005bc4:	e8a2                	sd	s0,80(sp)
    80005bc6:	e4a6                	sd	s1,72(sp)
    80005bc8:	e0ca                	sd	s2,64(sp)
    80005bca:	fc4e                	sd	s3,56(sp)
    80005bcc:	f852                	sd	s4,48(sp)
    80005bce:	f456                	sd	s5,40(sp)
    80005bd0:	f05a                	sd	s6,32(sp)
    80005bd2:	ec5e                	sd	s7,24(sp)
    80005bd4:	e862                	sd	s8,16(sp)
    80005bd6:	1080                	addi	s0,sp,96
    80005bd8:	89aa                	mv	s3,a0
    80005bda:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005bdc:	00c52b83          	lw	s7,12(a0)
    80005be0:	001b9b9b          	slliw	s7,s7,0x1
    80005be4:	1b82                	slli	s7,s7,0x20
    80005be6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005bea:	0001e517          	auipc	a0,0x1e
    80005bee:	39e50513          	addi	a0,a0,926 # 80023f88 <disk+0x128>
    80005bf2:	ff7fa0ef          	jal	80000be8 <acquire>
  for (int i = 0; i < NUM; i++) {
    80005bf6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005bf8:	0001ea97          	auipc	s5,0x1e
    80005bfc:	268a8a93          	addi	s5,s5,616 # 80023e60 <disk>
  for (int i = 0; i < 3; i++) {
    80005c00:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005c02:	5c7d                	li	s8,-1
    80005c04:	a8a5                	j	80005c7c <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005c06:	00fa8733          	add	a4,s5,a5
    80005c0a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005c0e:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005c10:	0207c563          	bltz	a5,80005c3a <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005c14:	2905                	addiw	s2,s2,1
    80005c16:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005c18:	07490663          	beq	s2,s4,80005c84 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005c1c:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005c1e:	0001e717          	auipc	a4,0x1e
    80005c22:	24270713          	addi	a4,a4,578 # 80023e60 <disk>
    80005c26:	4781                	li	a5,0
    if (disk.free[i]) {
    80005c28:	01874683          	lbu	a3,24(a4)
    80005c2c:	fee9                	bnez	a3,80005c06 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80005c2e:	2785                	addiw	a5,a5,1
    80005c30:	0705                	addi	a4,a4,1
    80005c32:	fe979be3          	bne	a5,s1,80005c28 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005c36:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    80005c3a:	01205d63          	blez	s2,80005c54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005c3e:	fa042503          	lw	a0,-96(s0)
    80005c42:	d41ff0ef          	jal	80005982 <free_desc>
      for (int j = 0; j < i; j++)
    80005c46:	4785                	li	a5,1
    80005c48:	0127d663          	bge	a5,s2,80005c54 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005c4c:	fa442503          	lw	a0,-92(s0)
    80005c50:	d33ff0ef          	jal	80005982 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80005c54:	0001e517          	auipc	a0,0x1e
    80005c58:	22450513          	addi	a0,a0,548 # 80023e78 <disk+0x18>
    80005c5c:	cd4fc0ef          	jal	80002130 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005c60:	0001e517          	auipc	a0,0x1e
    80005c64:	32850513          	addi	a0,a0,808 # 80023f88 <disk+0x128>
    80005c68:	808fb0ef          	jal	80000c70 <release>
    sleep();
    80005c6c:	d00fc0ef          	jal	8000216c <sleep>
    acquire(&disk.vdisk_lock);
    80005c70:	0001e517          	auipc	a0,0x1e
    80005c74:	31850513          	addi	a0,a0,792 # 80023f88 <disk+0x128>
    80005c78:	f71fa0ef          	jal	80000be8 <acquire>
  for (int i = 0; i < 3; i++) {
    80005c7c:	fa040613          	addi	a2,s0,-96
    80005c80:	4901                	li	s2,0
    80005c82:	bf69                	j	80005c1c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c84:	fa042503          	lw	a0,-96(s0)
    80005c88:	00451693          	slli	a3,a0,0x4

  if (write)
    80005c8c:	0001e797          	auipc	a5,0x1e
    80005c90:	1d478793          	addi	a5,a5,468 # 80023e60 <disk>
    80005c94:	00451713          	slli	a4,a0,0x4
    80005c98:	0a070713          	addi	a4,a4,160
    80005c9c:	973e                	add	a4,a4,a5
    80005c9e:	01603633          	snez	a2,s6
    80005ca2:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005ca4:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005ca8:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005cac:	6398                	ld	a4,0(a5)
    80005cae:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005cb0:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005cb4:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005cb6:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005cb8:	6390                	ld	a2,0(a5)
    80005cba:	00d60833          	add	a6,a2,a3
    80005cbe:	4741                	li	a4,16
    80005cc0:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005cc4:	4585                	li	a1,1
    80005cc6:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005cca:	fa442703          	lw	a4,-92(s0)
    80005cce:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005cd2:	0712                	slli	a4,a4,0x4
    80005cd4:	963a                	add	a2,a2,a4
    80005cd6:	05898813          	addi	a6,s3,88
    80005cda:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005cde:	0007b883          	ld	a7,0(a5)
    80005ce2:	9746                	add	a4,a4,a7
    80005ce4:	40000613          	li	a2,1024
    80005ce8:	c710                	sw	a2,8(a4)
  if (write)
    80005cea:	001b3613          	seqz	a2,s6
    80005cee:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005cf2:	8e4d                	or	a2,a2,a1
    80005cf4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005cf8:	fa842603          	lw	a2,-88(s0)
    80005cfc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005d00:	00451813          	slli	a6,a0,0x4
    80005d04:	02080813          	addi	a6,a6,32
    80005d08:	983e                	add	a6,a6,a5
    80005d0a:	577d                	li	a4,-1
    80005d0c:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005d10:	0612                	slli	a2,a2,0x4
    80005d12:	98b2                	add	a7,a7,a2
    80005d14:	03068713          	addi	a4,a3,48
    80005d18:	973e                	add	a4,a4,a5
    80005d1a:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005d1e:	6398                	ld	a4,0(a5)
    80005d20:	9732                	add	a4,a4,a2
    80005d22:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005d24:	4689                	li	a3,2
    80005d26:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005d2a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005d2e:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005d32:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005d36:	6794                	ld	a3,8(a5)
    80005d38:	0026d703          	lhu	a4,2(a3)
    80005d3c:	8b1d                	andi	a4,a4,7
    80005d3e:	0706                	slli	a4,a4,0x1
    80005d40:	96ba                	add	a3,a3,a4
    80005d42:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005d46:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005d4a:	6798                	ld	a4,8(a5)
    80005d4c:	00275783          	lhu	a5,2(a4)
    80005d50:	2785                	addiw	a5,a5,1
    80005d52:	00f71123          	sh	a5,2(a4)
    80005d56:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005d5a:	100017b7          	lui	a5,0x10001
    80005d5e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005d62:	0049a783          	lw	a5,4(s3)
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005d66:	0001e497          	auipc	s1,0x1e
    80005d6a:	22248493          	addi	s1,s1,546 # 80023f88 <disk+0x128>
  while (b->disk == 1) {
    80005d6e:	892e                	mv	s2,a1
    80005d70:	02b79163          	bne	a5,a1,80005d92 <virtio_disk_rw+0x1d2>
    sleep_prepare(b);
    80005d74:	854e                	mv	a0,s3
    80005d76:	bbafc0ef          	jal	80002130 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005d7a:	8526                	mv	a0,s1
    80005d7c:	ef5fa0ef          	jal	80000c70 <release>
    sleep();
    80005d80:	becfc0ef          	jal	8000216c <sleep>
    acquire(&disk.vdisk_lock);
    80005d84:	8526                	mv	a0,s1
    80005d86:	e63fa0ef          	jal	80000be8 <acquire>
  while (b->disk == 1) {
    80005d8a:	0049a783          	lw	a5,4(s3)
    80005d8e:	ff2783e3          	beq	a5,s2,80005d74 <virtio_disk_rw+0x1b4>
  }

  disk.info[idx[0]].b = 0;
    80005d92:	fa042903          	lw	s2,-96(s0)
    80005d96:	00491713          	slli	a4,s2,0x4
    80005d9a:	02070713          	addi	a4,a4,32
    80005d9e:	0001e797          	auipc	a5,0x1e
    80005da2:	0c278793          	addi	a5,a5,194 # 80023e60 <disk>
    80005da6:	97ba                	add	a5,a5,a4
    80005da8:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005dac:	0001e997          	auipc	s3,0x1e
    80005db0:	0b498993          	addi	s3,s3,180 # 80023e60 <disk>
    80005db4:	00491713          	slli	a4,s2,0x4
    80005db8:	0009b783          	ld	a5,0(s3)
    80005dbc:	97ba                	add	a5,a5,a4
    80005dbe:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005dc2:	854a                	mv	a0,s2
    80005dc4:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005dc8:	bbbff0ef          	jal	80005982 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005dcc:	8885                	andi	s1,s1,1
    80005dce:	f0fd                	bnez	s1,80005db4 <virtio_disk_rw+0x1f4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005dd0:	0001e517          	auipc	a0,0x1e
    80005dd4:	1b850513          	addi	a0,a0,440 # 80023f88 <disk+0x128>
    80005dd8:	e99fa0ef          	jal	80000c70 <release>
}
    80005ddc:	60e6                	ld	ra,88(sp)
    80005dde:	6446                	ld	s0,80(sp)
    80005de0:	64a6                	ld	s1,72(sp)
    80005de2:	6906                	ld	s2,64(sp)
    80005de4:	79e2                	ld	s3,56(sp)
    80005de6:	7a42                	ld	s4,48(sp)
    80005de8:	7aa2                	ld	s5,40(sp)
    80005dea:	7b02                	ld	s6,32(sp)
    80005dec:	6be2                	ld	s7,24(sp)
    80005dee:	6c42                	ld	s8,16(sp)
    80005df0:	6125                	addi	sp,sp,96
    80005df2:	8082                	ret

0000000080005df4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005df4:	1101                	addi	sp,sp,-32
    80005df6:	ec06                	sd	ra,24(sp)
    80005df8:	e822                	sd	s0,16(sp)
    80005dfa:	e426                	sd	s1,8(sp)
    80005dfc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005dfe:	0001e497          	auipc	s1,0x1e
    80005e02:	06248493          	addi	s1,s1,98 # 80023e60 <disk>
    80005e06:	0001e517          	auipc	a0,0x1e
    80005e0a:	18250513          	addi	a0,a0,386 # 80023f88 <disk+0x128>
    80005e0e:	ddbfa0ef          	jal	80000be8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005e12:	100017b7          	lui	a5,0x10001
    80005e16:	53bc                	lw	a5,96(a5)
    80005e18:	8b8d                	andi	a5,a5,3
    80005e1a:	10001737          	lui	a4,0x10001
    80005e1e:	d37c                	sw	a5,100(a4)
    80005e20:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005e24:	689c                	ld	a5,16(s1)
    80005e26:	0204d703          	lhu	a4,32(s1)
    80005e2a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005e2e:	04f70863          	beq	a4,a5,80005e7e <virtio_disk_intr+0x8a>
    80005e32:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005e36:	6898                	ld	a4,16(s1)
    80005e38:	0204d783          	lhu	a5,32(s1)
    80005e3c:	8b9d                	andi	a5,a5,7
    80005e3e:	078e                	slli	a5,a5,0x3
    80005e40:	97ba                	add	a5,a5,a4
    80005e42:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005e44:	00479713          	slli	a4,a5,0x4
    80005e48:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005e4c:	9726                	add	a4,a4,s1
    80005e4e:	01074703          	lbu	a4,16(a4)
    80005e52:	e329                	bnez	a4,80005e94 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005e54:	0792                	slli	a5,a5,0x4
    80005e56:	02078793          	addi	a5,a5,32
    80005e5a:	97a6                	add	a5,a5,s1
    80005e5c:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005e5e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005e62:	b52fc0ef          	jal	800021b4 <wakeup>

    disk.used_idx += 1;
    80005e66:	0204d783          	lhu	a5,32(s1)
    80005e6a:	2785                	addiw	a5,a5,1
    80005e6c:	17c2                	slli	a5,a5,0x30
    80005e6e:	93c1                	srli	a5,a5,0x30
    80005e70:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005e74:	6898                	ld	a4,16(s1)
    80005e76:	00275703          	lhu	a4,2(a4)
    80005e7a:	faf71ce3          	bne	a4,a5,80005e32 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005e7e:	0001e517          	auipc	a0,0x1e
    80005e82:	10a50513          	addi	a0,a0,266 # 80023f88 <disk+0x128>
    80005e86:	debfa0ef          	jal	80000c70 <release>
}
    80005e8a:	60e2                	ld	ra,24(sp)
    80005e8c:	6442                	ld	s0,16(sp)
    80005e8e:	64a2                	ld	s1,8(sp)
    80005e90:	6105                	addi	sp,sp,32
    80005e92:	8082                	ret
      panic("virtio_disk_intr status");
    80005e94:	00002517          	auipc	a0,0x2
    80005e98:	99c50513          	addi	a0,a0,-1636 # 80007830 <etext+0x830>
    80005e9c:	999fa0ef          	jal	80000834 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	0000100f          	fence.i
    800060a0:	12000073          	sfence.vma
    800060a4:	18051073          	csrw	satp,a0
    800060a8:	12000073          	sfence.vma
    800060ac:	02000537          	lui	a0,0x2000
    800060b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060b2:	0536                	slli	a0,a0,0xd
    800060b4:	02853083          	ld	ra,40(a0)
    800060b8:	03053103          	ld	sp,48(a0)
    800060bc:	03853183          	ld	gp,56(a0)
    800060c0:	04053203          	ld	tp,64(a0)
    800060c4:	04853283          	ld	t0,72(a0)
    800060c8:	05053303          	ld	t1,80(a0)
    800060cc:	05853383          	ld	t2,88(a0)
    800060d0:	7120                	ld	s0,96(a0)
    800060d2:	7524                	ld	s1,104(a0)
    800060d4:	7d2c                	ld	a1,120(a0)
    800060d6:	6150                	ld	a2,128(a0)
    800060d8:	6554                	ld	a3,136(a0)
    800060da:	6958                	ld	a4,144(a0)
    800060dc:	6d5c                	ld	a5,152(a0)
    800060de:	0a053803          	ld	a6,160(a0)
    800060e2:	0a853883          	ld	a7,168(a0)
    800060e6:	0b053903          	ld	s2,176(a0)
    800060ea:	0b853983          	ld	s3,184(a0)
    800060ee:	0c053a03          	ld	s4,192(a0)
    800060f2:	0c853a83          	ld	s5,200(a0)
    800060f6:	0d053b03          	ld	s6,208(a0)
    800060fa:	0d853b83          	ld	s7,216(a0)
    800060fe:	0e053c03          	ld	s8,224(a0)
    80006102:	0e853c83          	ld	s9,232(a0)
    80006106:	0f053d03          	ld	s10,240(a0)
    8000610a:	0f853d83          	ld	s11,248(a0)
    8000610e:	10053e03          	ld	t3,256(a0)
    80006112:	10853e83          	ld	t4,264(a0)
    80006116:	11053f03          	ld	t5,272(a0)
    8000611a:	11853f83          	ld	t6,280(a0)
    8000611e:	7928                	ld	a0,112(a0)
    80006120:	10200073          	sret
	...
