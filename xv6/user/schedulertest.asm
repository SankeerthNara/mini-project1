
user/_schedulertest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
// Python plotting script.
//
// Usage: schedulertest [num_cpu_bound] [num_io_bound]
int
main(int argc, char *argv[])
{
   0:	7159                	addi	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	eca6                	sd	s1,88(sp)
   8:	e8ca                	sd	s2,80(sp)
   a:	e4ce                	sd	s3,72(sp)
   c:	1880                	addi	s0,sp,112
  int ncpu = 3;
  int nio = 3;
  int i, pid;

  if (argc > 1)
   e:	4785                	li	a5,1
  10:	06a7cb63          	blt	a5,a0,86 <main+0x86>
    ncpu = atoi(argv[1]);
  if (argc > 2)
    nio = atoi(argv[2]);

  printf("schedulertest: start, %d cpu-bound + %d io-bound children, uptime=%d\n",
  14:	564000ef          	jal	578 <uptime>
  18:	86aa                	mv	a3,a0
  1a:	460d                	li	a2,3
  1c:	85b2                	mv	a1,a2
  1e:	00001517          	auipc	a0,0x1
  22:	ac250513          	addi	a0,a0,-1342 # ae0 <malloc+0xfa>
  26:	109000ef          	jal	92e <printf>
  int nio = 3;
  2a:	498d                	li	s3,3
  int ncpu = 3;
  2c:	894e                	mv	s2,s3
  2e:	4481                	li	s1,0
         ncpu, nio, uptime());

  // CPU-bound children: pure busy loops of varying length, so you can
  // tell them apart in the timeline (different total runtimes).
  for (i = 0; i < ncpu; i++) {
    pid = fork();
  30:	4a8000ef          	jal	4d8 <fork>
    if (pid < 0) {
  34:	0a054663          	bltz	a0,e0 <main+0xe0>
      printf("schedulertest: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
  38:	cd4d                	beqz	a0,f2 <main+0xf2>
  for (i = 0; i < ncpu; i++) {
  3a:	2485                	addiw	s1,s1,1
  3c:	ff249ae3          	bne	s1,s2,30 <main+0x30>
    }
  }

  // I/O-bound children: short CPU bursts + voluntary pause(), so they
  // should stay at a low (high-priority) queue under MLFQ.
  for (i = 0; i < nio; i++) {
  40:	01305c63          	blez	s3,58 <main+0x58>
  44:	4481                	li	s1,0
    pid = fork();
  46:	492000ef          	jal	4d8 <fork>
    if (pid < 0) {
  4a:	18054263          	bltz	a0,1ce <main+0x1ce>
      printf("schedulertest: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
  4e:	18050963          	beqz	a0,1e0 <main+0x1e0>
  for (i = 0; i < nio; i++) {
  52:	2485                	addiw	s1,s1,1
  54:	ff34c9e3          	blt	s1,s3,46 <main+0x46>
      exit(1);
    }
  }

  // Reap all children (both loops combined).
  for (i = 0; i < ncpu + nio; i++) {
  58:	013909bb          	addw	s3,s2,s3
  5c:	01305963          	blez	s3,6e <main+0x6e>
  60:	4481                	li	s1,0
    wait(0);
  62:	4501                	li	a0,0
  64:	484000ef          	jal	4e8 <wait>
  for (i = 0; i < ncpu + nio; i++) {
  68:	2485                	addiw	s1,s1,1
  6a:	ff349ce3          	bne	s1,s3,62 <main+0x62>
  }

  printf("schedulertest: all children done, uptime=%d\n", uptime());
  6e:	50a000ef          	jal	578 <uptime>
  72:	85aa                	mv	a1,a0
  74:	00001517          	auipc	a0,0x1
  78:	b4450513          	addi	a0,a0,-1212 # bb8 <malloc+0x1d2>
  7c:	0b3000ef          	jal	92e <printf>
  exit(0);
  80:	4501                	li	a0,0
  82:	45e000ef          	jal	4e0 <exit>
  86:	84aa                	mv	s1,a0
  88:	89ae                	mv	s3,a1
    ncpu = atoi(argv[1]);
  8a:	6588                	ld	a0,8(a1)
  8c:	32a000ef          	jal	3b6 <atoi>
  90:	892a                	mv	s2,a0
  if (argc > 2)
  92:	4789                	li	a5,2
  94:	0297c163          	blt	a5,s1,b6 <main+0xb6>
  printf("schedulertest: start, %d cpu-bound + %d io-bound children, uptime=%d\n",
  98:	4e0000ef          	jal	578 <uptime>
  9c:	86aa                	mv	a3,a0
  9e:	460d                	li	a2,3
  a0:	85ca                	mv	a1,s2
  a2:	00001517          	auipc	a0,0x1
  a6:	a3e50513          	addi	a0,a0,-1474 # ae0 <malloc+0xfa>
  aa:	085000ef          	jal	92e <printf>
  int nio = 3;
  ae:	498d                	li	s3,3
  for (i = 0; i < ncpu; i++) {
  b0:	f7204fe3          	bgtz	s2,2e <main+0x2e>
  b4:	bf41                	j	44 <main+0x44>
    nio = atoi(argv[2]);
  b6:	0109b503          	ld	a0,16(s3)
  ba:	2fc000ef          	jal	3b6 <atoi>
  be:	89aa                	mv	s3,a0
  printf("schedulertest: start, %d cpu-bound + %d io-bound children, uptime=%d\n",
  c0:	4b8000ef          	jal	578 <uptime>
  c4:	86aa                	mv	a3,a0
  c6:	864e                	mv	a2,s3
  c8:	85ca                	mv	a1,s2
  ca:	00001517          	auipc	a0,0x1
  ce:	a1650513          	addi	a0,a0,-1514 # ae0 <malloc+0xfa>
  d2:	05d000ef          	jal	92e <printf>
  for (i = 0; i < ncpu; i++) {
  d6:	f5204ce3          	bgtz	s2,2e <main+0x2e>
  for (i = 0; i < nio; i++) {
  da:	f73045e3          	bgtz	s3,44 <main+0x44>
  de:	bf41                	j	6e <main+0x6e>
      printf("schedulertest: fork failed\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	a4850513          	addi	a0,a0,-1464 # b28 <malloc+0x142>
  e8:	047000ef          	jal	92e <printf>
      exit(1);
  ec:	4505                	li	a0,1
  ee:	3f2000ef          	jal	4e0 <exit>
      if (v == 0) {
  f2:	57fd                	li	a5,-1
  f4:	0cf48763          	beq	s1,a5,1c2 <main+0x1c2>
      long n = 300000000L * (i + 1);
  f8:	2485                	addiw	s1,s1,1
  fa:	11e1a7b7          	lui	a5,0x11e1a
  fe:	30078793          	addi	a5,a5,768 # 11e1a300 <base+0x11e182f0>
 102:	02f484b3          	mul	s1,s1,a5
      while (v > 0) {
 106:	fa040693          	addi	a3,s0,-96
 10a:	862a                	mv	a2,a0
 10c:	06905863          	blez	s1,17c <main+0x17c>
        tmp[t++] = '0' + (v % 10);
 110:	666667b7          	lui	a5,0x66666
 114:	66678593          	addi	a1,a5,1638 # 66666666 <base+0x66664656>
 118:	66778793          	addi	a5,a5,1639
 11c:	1582                	slli	a1,a1,0x20
 11e:	95be                	add	a1,a1,a5
      while (v > 0) {
 120:	4825                	li	a6,9
        tmp[t++] = '0' + (v % 10);
 122:	2605                	addiw	a2,a2,1
 124:	02b49733          	mulh	a4,s1,a1
 128:	8709                	srai	a4,a4,0x2
 12a:	43f4d793          	srai	a5,s1,0x3f
 12e:	8f1d                	sub	a4,a4,a5
 130:	00271793          	slli	a5,a4,0x2
 134:	97ba                	add	a5,a5,a4
 136:	0786                	slli	a5,a5,0x1
 138:	40f487b3          	sub	a5,s1,a5
 13c:	0307879b          	addiw	a5,a5,48
 140:	00f68023          	sb	a5,0(a3)
        v /= 10;
 144:	87a6                	mv	a5,s1
 146:	84ba                	mv	s1,a4
      while (v > 0) {
 148:	0685                	addi	a3,a3,1
 14a:	fcf84ce3          	blt	a6,a5,122 <main+0x122>
      while (t > 0)
 14e:	02c05763          	blez	a2,17c <main+0x17c>
 152:	fff6069b          	addiw	a3,a2,-1
 156:	fa040713          	addi	a4,s0,-96
 15a:	9736                	add	a4,a4,a3
 15c:	f9040793          	addi	a5,s0,-112
 160:	1682                	slli	a3,a3,0x20
 162:	9281                	srli	a3,a3,0x20
 164:	f9140593          	addi	a1,s0,-111
 168:	95b6                	add	a1,a1,a3
        nbuf[k++] = tmp[--t];
 16a:	00074683          	lbu	a3,0(a4)
 16e:	00d78023          	sb	a3,0(a5)
      while (t > 0)
 172:	177d                	addi	a4,a4,-1
 174:	0785                	addi	a5,a5,1
 176:	feb79ae3          	bne	a5,a1,16a <main+0x16a>
 17a:	8532                	mv	a0,a2
      nbuf[k] = 0;
 17c:	fd050793          	addi	a5,a0,-48
 180:	00878533          	add	a0,a5,s0
 184:	fc050023          	sb	zero,-64(a0)
      args[0] = "spin";
 188:	00001797          	auipc	a5,0x1
 18c:	9c078793          	addi	a5,a5,-1600 # b48 <malloc+0x162>
 190:	faf43823          	sd	a5,-80(s0)
      args[1] = nbuf;
 194:	f9040793          	addi	a5,s0,-112
 198:	faf43c23          	sd	a5,-72(s0)
      args[2] = 0;
 19c:	fc043023          	sd	zero,-64(s0)
      exec("spin", args);
 1a0:	fb040593          	addi	a1,s0,-80
 1a4:	00001517          	auipc	a0,0x1
 1a8:	9a450513          	addi	a0,a0,-1628 # b48 <malloc+0x162>
 1ac:	36c000ef          	jal	518 <exec>
      printf("schedulertest: exec spin failed\n");
 1b0:	00001517          	auipc	a0,0x1
 1b4:	9a050513          	addi	a0,a0,-1632 # b50 <malloc+0x16a>
 1b8:	776000ef          	jal	92e <printf>
      exit(1);
 1bc:	4505                	li	a0,1
 1be:	322000ef          	jal	4e0 <exit>
 1c2:	03000793          	li	a5,48
 1c6:	faf40023          	sb	a5,-96(s0)
      if (v == 0) {
 1ca:	4605                	li	a2,1
 1cc:	b749                	j	14e <main+0x14e>
      printf("schedulertest: fork failed\n");
 1ce:	00001517          	auipc	a0,0x1
 1d2:	95a50513          	addi	a0,a0,-1702 # b28 <malloc+0x142>
 1d6:	758000ef          	jal	92e <printf>
      exit(1);
 1da:	4505                	li	a0,1
 1dc:	304000ef          	jal	4e0 <exit>
      args[0] = "iobound";
 1e0:	00001797          	auipc	a5,0x1
 1e4:	99878793          	addi	a5,a5,-1640 # b78 <malloc+0x192>
 1e8:	faf43823          	sd	a5,-80(s0)
      args[1] = "40"; // rounds
 1ec:	00001797          	auipc	a5,0x1
 1f0:	99478793          	addi	a5,a5,-1644 # b80 <malloc+0x19a>
 1f4:	faf43c23          	sd	a5,-72(s0)
      args[2] = "4";  // pause ticks per round
 1f8:	00001797          	auipc	a5,0x1
 1fc:	99078793          	addi	a5,a5,-1648 # b88 <malloc+0x1a2>
 200:	fcf43023          	sd	a5,-64(s0)
      args[3] = 0;
 204:	fc043423          	sd	zero,-56(s0)
      exec("iobound", args);
 208:	fb040593          	addi	a1,s0,-80
 20c:	00001517          	auipc	a0,0x1
 210:	96c50513          	addi	a0,a0,-1684 # b78 <malloc+0x192>
 214:	304000ef          	jal	518 <exec>
      printf("schedulertest: exec iobound failed\n");
 218:	00001517          	auipc	a0,0x1
 21c:	97850513          	addi	a0,a0,-1672 # b90 <malloc+0x1aa>
 220:	70e000ef          	jal	92e <printf>
      exit(1);
 224:	4505                	li	a0,1
 226:	2ba000ef          	jal	4e0 <exit>

000000000000022a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 232:	dcfff0ef          	jal	0 <main>
  exit(r);
 236:	2aa000ef          	jal	4e0 <exit>

000000000000023a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 242:	87aa                	mv	a5,a0
 244:	0585                	addi	a1,a1,1
 246:	0785                	addi	a5,a5,1
 248:	fff5c703          	lbu	a4,-1(a1)
 24c:	fee78fa3          	sb	a4,-1(a5)
 250:	fb75                	bnez	a4,244 <strcpy+0xa>
    ;
  return os;
}
 252:	60a2                	ld	ra,8(sp)
 254:	6402                	ld	s0,0(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret

000000000000025a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 262:	00054783          	lbu	a5,0(a0)
 266:	cb91                	beqz	a5,27a <strcmp+0x20>
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00f71763          	bne	a4,a5,27a <strcmp+0x20>
    p++, q++;
 270:	0505                	addi	a0,a0,1
 272:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 274:	00054783          	lbu	a5,0(a0)
 278:	fbe5                	bnez	a5,268 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 27a:	0005c503          	lbu	a0,0(a1)
}
 27e:	40a7853b          	subw	a0,a5,a0
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strlen>:

uint
strlen(const char *s)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 292:	00054783          	lbu	a5,0(a0)
 296:	cf91                	beqz	a5,2b2 <strlen+0x28>
 298:	00150793          	addi	a5,a0,1
 29c:	86be                	mv	a3,a5
 29e:	0785                	addi	a5,a5,1
 2a0:	fff7c703          	lbu	a4,-1(a5)
 2a4:	ff65                	bnez	a4,29c <strlen+0x12>
 2a6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  for (n = 0; s[n]; n++)
 2b2:	4501                	li	a0,0
 2b4:	bfdd                	j	2aa <strlen+0x20>

00000000000002b6 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2be:	ca19                	beqz	a2,2d4 <memset+0x1e>
 2c0:	87aa                	mv	a5,a0
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ca:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 2ce:	0785                	addi	a5,a5,1
 2d0:	fee79de3          	bne	a5,a4,2ca <memset+0x14>
  }
  return dst;
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <strchr>:

char *
strchr(const char *s, char c)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  for (; *s; s++)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cf81                	beqz	a5,300 <strchr+0x24>
    if (*s == c)
 2ea:	00f58763          	beq	a1,a5,2f8 <strchr+0x1c>
  for (; *s; s++)
 2ee:	0505                	addi	a0,a0,1
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	fbfd                	bnez	a5,2ea <strchr+0xe>
      return (char *)s;
  return 0;
 2f6:	4501                	li	a0,0
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
  return 0;
 300:	4501                	li	a0,0
 302:	bfdd                	j	2f8 <strchr+0x1c>

0000000000000304 <gets>:

char *
gets(char *buf, int max)
{
 304:	711d                	addi	sp,sp,-96
 306:	ec86                	sd	ra,88(sp)
 308:	e8a2                	sd	s0,80(sp)
 30a:	e4a6                	sd	s1,72(sp)
 30c:	e0ca                	sd	s2,64(sp)
 30e:	fc4e                	sd	s3,56(sp)
 310:	f852                	sd	s4,48(sp)
 312:	f456                	sd	s5,40(sp)
 314:	f05a                	sd	s6,32(sp)
 316:	ec5e                	sd	s7,24(sp)
 318:	e862                	sd	s8,16(sp)
 31a:	1080                	addi	s0,sp,96
 31c:	8baa                	mv	s7,a0
 31e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 320:	892a                	mv	s2,a0
 322:	4481                	li	s1,0
    cc = read(0, &c, 1);
 324:	faf40b13          	addi	s6,s0,-81
 328:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 32a:	8c26                	mv	s8,s1
 32c:	0014899b          	addiw	s3,s1,1
 330:	84ce                	mv	s1,s3
 332:	0349d463          	bge	s3,s4,35a <gets+0x56>
    cc = read(0, &c, 1);
 336:	8656                	mv	a2,s5
 338:	85da                	mv	a1,s6
 33a:	4501                	li	a0,0
 33c:	1bc000ef          	jal	4f8 <read>
    if (cc < 1)
 340:	00a05d63          	blez	a0,35a <gets+0x56>
      break;
    buf[i++] = c;
 344:	faf44783          	lbu	a5,-81(s0)
 348:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 34c:	0905                	addi	s2,s2,1
 34e:	ff678713          	addi	a4,a5,-10
 352:	c319                	beqz	a4,358 <gets+0x54>
 354:	17cd                	addi	a5,a5,-13
 356:	fbf1                	bnez	a5,32a <gets+0x26>
    buf[i++] = c;
 358:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 35a:	9c5e                	add	s8,s8,s7
 35c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 360:	855e                	mv	a0,s7
 362:	60e6                	ld	ra,88(sp)
 364:	6446                	ld	s0,80(sp)
 366:	64a6                	ld	s1,72(sp)
 368:	6906                	ld	s2,64(sp)
 36a:	79e2                	ld	s3,56(sp)
 36c:	7a42                	ld	s4,48(sp)
 36e:	7aa2                	ld	s5,40(sp)
 370:	7b02                	ld	s6,32(sp)
 372:	6be2                	ld	s7,24(sp)
 374:	6c42                	ld	s8,16(sp)
 376:	6125                	addi	sp,sp,96
 378:	8082                	ret

000000000000037a <stat>:

int
stat(const char *n, struct stat *st)
{
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	e04a                	sd	s2,0(sp)
 382:	1000                	addi	s0,sp,32
 384:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 386:	4581                	li	a1,0
 388:	198000ef          	jal	520 <open>
  if (fd < 0)
 38c:	02054263          	bltz	a0,3b0 <stat+0x36>
 390:	e426                	sd	s1,8(sp)
 392:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 394:	85ca                	mv	a1,s2
 396:	1a2000ef          	jal	538 <fstat>
 39a:	892a                	mv	s2,a0
  close(fd);
 39c:	8526                	mv	a0,s1
 39e:	16a000ef          	jal	508 <close>
  return r;
 3a2:	64a2                	ld	s1,8(sp)
}
 3a4:	854a                	mv	a0,s2
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6902                	ld	s2,0(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret
    return -1;
 3b0:	57fd                	li	a5,-1
 3b2:	893e                	mv	s2,a5
 3b4:	bfc5                	j	3a4 <stat+0x2a>

00000000000003b6 <atoi>:

int
atoi(const char *s)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 3be:	00054683          	lbu	a3,0(a0)
 3c2:	fd06879b          	addiw	a5,a3,-48
 3c6:	0ff7f793          	zext.b	a5,a5
 3ca:	4625                	li	a2,9
 3cc:	02f66963          	bltu	a2,a5,3fe <atoi+0x48>
 3d0:	872a                	mv	a4,a0
  n = 0;
 3d2:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 3d4:	0705                	addi	a4,a4,1
 3d6:	0025179b          	slliw	a5,a0,0x2
 3da:	9fa9                	addw	a5,a5,a0
 3dc:	0017979b          	slliw	a5,a5,0x1
 3e0:	9fb5                	addw	a5,a5,a3
 3e2:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 3e6:	00074683          	lbu	a3,0(a4)
 3ea:	fd06879b          	addiw	a5,a3,-48
 3ee:	0ff7f793          	zext.b	a5,a5
 3f2:	fef671e3          	bgeu	a2,a5,3d4 <atoi+0x1e>
  return n;
}
 3f6:	60a2                	ld	ra,8(sp)
 3f8:	6402                	ld	s0,0(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
  n = 0;
 3fe:	4501                	li	a0,0
 400:	bfdd                	j	3f6 <atoi+0x40>

0000000000000402 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 40a:	02b57563          	bgeu	a0,a1,434 <memmove+0x32>
    while (n-- > 0)
 40e:	00c05f63          	blez	a2,42c <memmove+0x2a>
 412:	1602                	slli	a2,a2,0x20
 414:	9201                	srli	a2,a2,0x20
 416:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 41a:	872a                	mv	a4,a0
      *dst++ = *src++;
 41c:	0585                	addi	a1,a1,1
 41e:	0705                	addi	a4,a4,1
 420:	fff5c683          	lbu	a3,-1(a1)
 424:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 428:	fee79ae3          	bne	a5,a4,41c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 42c:	60a2                	ld	ra,8(sp)
 42e:	6402                	ld	s0,0(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret
    while (n-- > 0)
 434:	fec05ce3          	blez	a2,42c <memmove+0x2a>
    dst += n;
 438:	00c50733          	add	a4,a0,a2
    src += n;
 43c:	95b2                	add	a1,a1,a2
 43e:	fff6079b          	addiw	a5,a2,-1
 442:	1782                	slli	a5,a5,0x20
 444:	9381                	srli	a5,a5,0x20
 446:	fff7c793          	not	a5,a5
 44a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 44c:	15fd                	addi	a1,a1,-1
 44e:	177d                	addi	a4,a4,-1
 450:	0005c683          	lbu	a3,0(a1)
 454:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 458:	fef71ae3          	bne	a4,a5,44c <memmove+0x4a>
 45c:	bfc1                	j	42c <memmove+0x2a>

000000000000045e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e406                	sd	ra,8(sp)
 462:	e022                	sd	s0,0(sp)
 464:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 466:	c61d                	beqz	a2,494 <memcmp+0x36>
 468:	1602                	slli	a2,a2,0x20
 46a:	9201                	srli	a2,a2,0x20
 46c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 470:	00054783          	lbu	a5,0(a0)
 474:	0005c703          	lbu	a4,0(a1)
 478:	00e79863          	bne	a5,a4,488 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 47c:	0505                	addi	a0,a0,1
    p2++;
 47e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 480:	fed518e3          	bne	a0,a3,470 <memcmp+0x12>
  }
  return 0;
 484:	4501                	li	a0,0
 486:	a019                	j	48c <memcmp+0x2e>
      return *p1 - *p2;
 488:	40e7853b          	subw	a0,a5,a4
}
 48c:	60a2                	ld	ra,8(sp)
 48e:	6402                	ld	s0,0(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret
  return 0;
 494:	4501                	li	a0,0
 496:	bfdd                	j	48c <memcmp+0x2e>

0000000000000498 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 498:	1141                	addi	sp,sp,-16
 49a:	e406                	sd	ra,8(sp)
 49c:	e022                	sd	s0,0(sp)
 49e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a0:	f63ff0ef          	jal	402 <memmove>
}
 4a4:	60a2                	ld	ra,8(sp)
 4a6:	6402                	ld	s0,0(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret

00000000000004ac <sbrk>:

char *
sbrk(int n)
{
 4ac:	1141                	addi	sp,sp,-16
 4ae:	e406                	sd	ra,8(sp)
 4b0:	e022                	sd	s0,0(sp)
 4b2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4b4:	4585                	li	a1,1
 4b6:	0b2000ef          	jal	568 <sys_sbrk>
}
 4ba:	60a2                	ld	ra,8(sp)
 4bc:	6402                	ld	s0,0(sp)
 4be:	0141                	addi	sp,sp,16
 4c0:	8082                	ret

00000000000004c2 <sbrklazy>:

char *
sbrklazy(int n)
{
 4c2:	1141                	addi	sp,sp,-16
 4c4:	e406                	sd	ra,8(sp)
 4c6:	e022                	sd	s0,0(sp)
 4c8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4ca:	4589                	li	a1,2
 4cc:	09c000ef          	jal	568 <sys_sbrk>
}
 4d0:	60a2                	ld	ra,8(sp)
 4d2:	6402                	ld	s0,0(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret

00000000000004d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d8:	4885                	li	a7,1
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e0:	4889                	li	a7,2
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e8:	488d                	li	a7,3
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f0:	4891                	li	a7,4
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <read>:
.global read
read:
 li a7, SYS_read
 4f8:	4895                	li	a7,5
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <write>:
.global write
write:
 li a7, SYS_write
 500:	48c1                	li	a7,16
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <close>:
.global close
close:
 li a7, SYS_close
 508:	48d5                	li	a7,21
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <kill>:
.global kill
kill:
 li a7, SYS_kill
 510:	4899                	li	a7,6
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <exec>:
.global exec
exec:
 li a7, SYS_exec
 518:	489d                	li	a7,7
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <open>:
.global open
open:
 li a7, SYS_open
 520:	48bd                	li	a7,15
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 528:	48c5                	li	a7,17
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 530:	48c9                	li	a7,18
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 538:	48a1                	li	a7,8
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <link>:
.global link
link:
 li a7, SYS_link
 540:	48cd                	li	a7,19
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 548:	48d1                	li	a7,20
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 550:	48a5                	li	a7,9
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <dup>:
.global dup
dup:
 li a7, SYS_dup
 558:	48a9                	li	a7,10
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 560:	48ad                	li	a7,11
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 568:	48b1                	li	a7,12
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <pause>:
.global pause
pause:
 li a7, SYS_pause
 570:	48b5                	li	a7,13
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 578:	48b9                	li	a7,14
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <sync>:
.global sync
sync:
 li a7, SYS_sync
 580:	48d9                	li	a7,22
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 588:	1101                	addi	sp,sp,-32
 58a:	ec06                	sd	ra,24(sp)
 58c:	e822                	sd	s0,16(sp)
 58e:	1000                	addi	s0,sp,32
 590:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 594:	4605                	li	a2,1
 596:	fef40593          	addi	a1,s0,-17
 59a:	f67ff0ef          	jal	500 <write>
}
 59e:	60e2                	ld	ra,24(sp)
 5a0:	6442                	ld	s0,16(sp)
 5a2:	6105                	addi	sp,sp,32
 5a4:	8082                	ret

00000000000005a6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5a6:	715d                	addi	sp,sp,-80
 5a8:	e486                	sd	ra,72(sp)
 5aa:	e0a2                	sd	s0,64(sp)
 5ac:	f84a                	sd	s2,48(sp)
 5ae:	f44e                	sd	s3,40(sp)
 5b0:	0880                	addi	s0,sp,80
 5b2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 5b4:	c6d1                	beqz	a3,640 <printint+0x9a>
 5b6:	0805d563          	bgez	a1,640 <printint+0x9a>
    neg = 1;
    x = -xx;
 5ba:	40b005b3          	neg	a1,a1
    neg = 1;
 5be:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5c0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 5c4:	86ce                	mv	a3,s3
  i = 0;
 5c6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 5c8:	00000817          	auipc	a6,0x0
 5cc:	62880813          	addi	a6,a6,1576 # bf0 <digits>
 5d0:	88ba                	mv	a7,a4
 5d2:	0017051b          	addiw	a0,a4,1
 5d6:	872a                	mv	a4,a0
 5d8:	02c5f7b3          	remu	a5,a1,a2
 5dc:	97c2                	add	a5,a5,a6
 5de:	0007c783          	lbu	a5,0(a5)
 5e2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 5e6:	87ae                	mv	a5,a1
 5e8:	02c5d5b3          	divu	a1,a1,a2
 5ec:	0685                	addi	a3,a3,1
 5ee:	fec7f1e3          	bgeu	a5,a2,5d0 <printint+0x2a>
  if (neg)
 5f2:	00030c63          	beqz	t1,60a <printint+0x64>
    buf[i++] = '-';
 5f6:	fd050793          	addi	a5,a0,-48
 5fa:	00878533          	add	a0,a5,s0
 5fe:	02d00793          	li	a5,45
 602:	fef50423          	sb	a5,-24(a0)
 606:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 60a:	02e05563          	blez	a4,634 <printint+0x8e>
 60e:	fc26                	sd	s1,56(sp)
 610:	377d                	addiw	a4,a4,-1
 612:	00e984b3          	add	s1,s3,a4
 616:	19fd                	addi	s3,s3,-1
 618:	99ba                	add	s3,s3,a4
 61a:	1702                	slli	a4,a4,0x20
 61c:	9301                	srli	a4,a4,0x20
 61e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 622:	0004c583          	lbu	a1,0(s1)
 626:	854a                	mv	a0,s2
 628:	f61ff0ef          	jal	588 <putc>
  while (--i >= 0)
 62c:	14fd                	addi	s1,s1,-1
 62e:	ff349ae3          	bne	s1,s3,622 <printint+0x7c>
 632:	74e2                	ld	s1,56(sp)
}
 634:	60a6                	ld	ra,72(sp)
 636:	6406                	ld	s0,64(sp)
 638:	7942                	ld	s2,48(sp)
 63a:	79a2                	ld	s3,40(sp)
 63c:	6161                	addi	sp,sp,80
 63e:	8082                	ret
  neg = 0;
 640:	4301                	li	t1,0
 642:	bfbd                	j	5c0 <printint+0x1a>

0000000000000644 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 644:	711d                	addi	sp,sp,-96
 646:	ec86                	sd	ra,88(sp)
 648:	e8a2                	sd	s0,80(sp)
 64a:	e4a6                	sd	s1,72(sp)
 64c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 64e:	0005c483          	lbu	s1,0(a1)
 652:	22048363          	beqz	s1,878 <vprintf+0x234>
 656:	e0ca                	sd	s2,64(sp)
 658:	fc4e                	sd	s3,56(sp)
 65a:	f852                	sd	s4,48(sp)
 65c:	f456                	sd	s5,40(sp)
 65e:	f05a                	sd	s6,32(sp)
 660:	ec5e                	sd	s7,24(sp)
 662:	e862                	sd	s8,16(sp)
 664:	8b2a                	mv	s6,a0
 666:	8a2e                	mv	s4,a1
 668:	8bb2                	mv	s7,a2
  state = 0;
 66a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 66c:	4901                	li	s2,0
 66e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 670:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 674:	06400c13          	li	s8,100
 678:	a00d                	j	69a <vprintf+0x56>
        putc(fd, c0);
 67a:	85a6                	mv	a1,s1
 67c:	855a                	mv	a0,s6
 67e:	f0bff0ef          	jal	588 <putc>
 682:	a019                	j	688 <vprintf+0x44>
    } else if (state == '%') {
 684:	03598363          	beq	s3,s5,6aa <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 688:	0019079b          	addiw	a5,s2,1
 68c:	893e                	mv	s2,a5
 68e:	873e                	mv	a4,a5
 690:	97d2                	add	a5,a5,s4
 692:	0007c483          	lbu	s1,0(a5)
 696:	1c048a63          	beqz	s1,86a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 69a:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 69e:	fe0993e3          	bnez	s3,684 <vprintf+0x40>
      if (c0 == '%') {
 6a2:	fd579ce3          	bne	a5,s5,67a <vprintf+0x36>
        state = '%';
 6a6:	89be                	mv	s3,a5
 6a8:	b7c5                	j	688 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 6aa:	00ea06b3          	add	a3,s4,a4
 6ae:	0016c603          	lbu	a2,1(a3)
      if (c1)
 6b2:	1c060863          	beqz	a2,882 <vprintf+0x23e>
      if (c0 == 'd') {
 6b6:	03878763          	beq	a5,s8,6e4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 6ba:	f9478693          	addi	a3,a5,-108
 6be:	0016b693          	seqz	a3,a3
 6c2:	f9c60593          	addi	a1,a2,-100
 6c6:	e99d                	bnez	a1,6fc <vprintf+0xb8>
 6c8:	ca95                	beqz	a3,6fc <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ca:	008b8493          	addi	s1,s7,8
 6ce:	4685                	li	a3,1
 6d0:	4629                	li	a2,10
 6d2:	000bb583          	ld	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	ecfff0ef          	jal	5a6 <printint>
        i += 1;
 6dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6de:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b75d                	j	688 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 6e4:	008b8493          	addi	s1,s7,8
 6e8:	4685                	li	a3,1
 6ea:	4629                	li	a2,10
 6ec:	000ba583          	lw	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	eb5ff0ef          	jal	5a6 <printint>
 6f6:	8ba6                	mv	s7,s1
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b779                	j	688 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 6fc:	9752                	add	a4,a4,s4
 6fe:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 702:	f9460713          	addi	a4,a2,-108
 706:	00173713          	seqz	a4,a4
 70a:	8f75                	and	a4,a4,a3
 70c:	f9c58513          	addi	a0,a1,-100
 710:	18051363          	bnez	a0,896 <vprintf+0x252>
 714:	18070163          	beqz	a4,896 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	008b8493          	addi	s1,s7,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000bb583          	ld	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	e81ff0ef          	jal	5a6 <printint>
        i += 2;
 72a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 72c:	8ba6                	mv	s7,s1
      state = 0;
 72e:	4981                	li	s3,0
        i += 2;
 730:	bfa1                	j	688 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 732:	008b8493          	addi	s1,s7,8
 736:	4681                	li	a3,0
 738:	4629                	li	a2,10
 73a:	000be583          	lwu	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	e67ff0ef          	jal	5a6 <printint>
 744:	8ba6                	mv	s7,s1
      state = 0;
 746:	4981                	li	s3,0
 748:	b781                	j	688 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	008b8493          	addi	s1,s7,8
 74e:	4681                	li	a3,0
 750:	4629                	li	a2,10
 752:	000bb583          	ld	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	e4fff0ef          	jal	5a6 <printint>
        i += 1;
 75c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	8ba6                	mv	s7,s1
      state = 0;
 760:	4981                	li	s3,0
 762:	b71d                	j	688 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	008b8493          	addi	s1,s7,8
 768:	4681                	li	a3,0
 76a:	4629                	li	a2,10
 76c:	000bb583          	ld	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	e35ff0ef          	jal	5a6 <printint>
        i += 2;
 776:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	8ba6                	mv	s7,s1
      state = 0;
 77a:	4981                	li	s3,0
        i += 2;
 77c:	b731                	j	688 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 77e:	008b8493          	addi	s1,s7,8
 782:	4681                	li	a3,0
 784:	4641                	li	a2,16
 786:	000be583          	lwu	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	e1bff0ef          	jal	5a6 <printint>
 790:	8ba6                	mv	s7,s1
      state = 0;
 792:	4981                	li	s3,0
 794:	bdd5                	j	688 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	008b8493          	addi	s1,s7,8
 79a:	4681                	li	a3,0
 79c:	4641                	li	a2,16
 79e:	000bb583          	ld	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	e03ff0ef          	jal	5a6 <printint>
        i += 1;
 7a8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7aa:	8ba6                	mv	s7,s1
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bde9                	j	688 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b0:	008b8493          	addi	s1,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4641                	li	a2,16
 7b8:	000bb583          	ld	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	de9ff0ef          	jal	5a6 <printint>
        i += 2;
 7c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c4:	8ba6                	mv	s7,s1
      state = 0;
 7c6:	4981                	li	s3,0
        i += 2;
 7c8:	b5c1                	j	688 <vprintf+0x44>
 7ca:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7cc:	008b8793          	addi	a5,s7,8
 7d0:	8cbe                	mv	s9,a5
 7d2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7d6:	03000593          	li	a1,48
 7da:	855a                	mv	a0,s6
 7dc:	dadff0ef          	jal	588 <putc>
  putc(fd, 'x');
 7e0:	07800593          	li	a1,120
 7e4:	855a                	mv	a0,s6
 7e6:	da3ff0ef          	jal	588 <putc>
 7ea:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ec:	00000b97          	auipc	s7,0x0
 7f0:	404b8b93          	addi	s7,s7,1028 # bf0 <digits>
 7f4:	03c9d793          	srli	a5,s3,0x3c
 7f8:	97de                	add	a5,a5,s7
 7fa:	0007c583          	lbu	a1,0(a5)
 7fe:	855a                	mv	a0,s6
 800:	d89ff0ef          	jal	588 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 804:	0992                	slli	s3,s3,0x4
 806:	34fd                	addiw	s1,s1,-1
 808:	f4f5                	bnez	s1,7f4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 80a:	8be6                	mv	s7,s9
      state = 0;
 80c:	4981                	li	s3,0
 80e:	6ca2                	ld	s9,8(sp)
 810:	bda5                	j	688 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 812:	008b8493          	addi	s1,s7,8
 816:	000bc583          	lbu	a1,0(s7)
 81a:	855a                	mv	a0,s6
 81c:	d6dff0ef          	jal	588 <putc>
 820:	8ba6                	mv	s7,s1
      state = 0;
 822:	4981                	li	s3,0
 824:	b595                	j	688 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 826:	008b8993          	addi	s3,s7,8
 82a:	000bb483          	ld	s1,0(s7)
 82e:	cc91                	beqz	s1,84a <vprintf+0x206>
        for (; *s; s++)
 830:	0004c583          	lbu	a1,0(s1)
 834:	c985                	beqz	a1,864 <vprintf+0x220>
          putc(fd, *s);
 836:	855a                	mv	a0,s6
 838:	d51ff0ef          	jal	588 <putc>
        for (; *s; s++)
 83c:	0485                	addi	s1,s1,1
 83e:	0004c583          	lbu	a1,0(s1)
 842:	f9f5                	bnez	a1,836 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 844:	8bce                	mv	s7,s3
      state = 0;
 846:	4981                	li	s3,0
 848:	b581                	j	688 <vprintf+0x44>
          s = "(null)";
 84a:	00000497          	auipc	s1,0x0
 84e:	39e48493          	addi	s1,s1,926 # be8 <malloc+0x202>
        for (; *s; s++)
 852:	02800593          	li	a1,40
 856:	b7c5                	j	836 <vprintf+0x1f2>
        putc(fd, '%');
 858:	85be                	mv	a1,a5
 85a:	855a                	mv	a0,s6
 85c:	d2dff0ef          	jal	588 <putc>
      state = 0;
 860:	4981                	li	s3,0
 862:	b51d                	j	688 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 864:	8bce                	mv	s7,s3
      state = 0;
 866:	4981                	li	s3,0
 868:	b505                	j	688 <vprintf+0x44>
 86a:	6906                	ld	s2,64(sp)
 86c:	79e2                	ld	s3,56(sp)
 86e:	7a42                	ld	s4,48(sp)
 870:	7aa2                	ld	s5,40(sp)
 872:	7b02                	ld	s6,32(sp)
 874:	6be2                	ld	s7,24(sp)
 876:	6c42                	ld	s8,16(sp)
    }
  }
}
 878:	60e6                	ld	ra,88(sp)
 87a:	6446                	ld	s0,80(sp)
 87c:	64a6                	ld	s1,72(sp)
 87e:	6125                	addi	sp,sp,96
 880:	8082                	ret
      if (c0 == 'd') {
 882:	06400713          	li	a4,100
 886:	e4e78fe3          	beq	a5,a4,6e4 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 88a:	f9478693          	addi	a3,a5,-108
 88e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 892:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 894:	4701                	li	a4,0
      } else if (c0 == 'u') {
 896:	07500513          	li	a0,117
 89a:	e8a78ce3          	beq	a5,a0,732 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 89e:	f8b60513          	addi	a0,a2,-117
 8a2:	e119                	bnez	a0,8a8 <vprintf+0x264>
 8a4:	ea0693e3          	bnez	a3,74a <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 8a8:	f8b58513          	addi	a0,a1,-117
 8ac:	e119                	bnez	a0,8b2 <vprintf+0x26e>
 8ae:	ea071be3          	bnez	a4,764 <vprintf+0x120>
      } else if (c0 == 'x') {
 8b2:	07800513          	li	a0,120
 8b6:	eca784e3          	beq	a5,a0,77e <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 8ba:	f8860613          	addi	a2,a2,-120
 8be:	e219                	bnez	a2,8c4 <vprintf+0x280>
 8c0:	ec069be3          	bnez	a3,796 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 8c4:	f8858593          	addi	a1,a1,-120
 8c8:	e199                	bnez	a1,8ce <vprintf+0x28a>
 8ca:	ee0713e3          	bnez	a4,7b0 <vprintf+0x16c>
      } else if (c0 == 'p') {
 8ce:	07000713          	li	a4,112
 8d2:	eee78ce3          	beq	a5,a4,7ca <vprintf+0x186>
      } else if (c0 == 'c') {
 8d6:	06300713          	li	a4,99
 8da:	f2e78ce3          	beq	a5,a4,812 <vprintf+0x1ce>
      } else if (c0 == 's') {
 8de:	07300713          	li	a4,115
 8e2:	f4e782e3          	beq	a5,a4,826 <vprintf+0x1e2>
      } else if (c0 == '%') {
 8e6:	02500713          	li	a4,37
 8ea:	f6e787e3          	beq	a5,a4,858 <vprintf+0x214>
        putc(fd, '%');
 8ee:	02500593          	li	a1,37
 8f2:	855a                	mv	a0,s6
 8f4:	c95ff0ef          	jal	588 <putc>
        putc(fd, c0);
 8f8:	85a6                	mv	a1,s1
 8fa:	855a                	mv	a0,s6
 8fc:	c8dff0ef          	jal	588 <putc>
      state = 0;
 900:	4981                	li	s3,0
 902:	b359                	j	688 <vprintf+0x44>

0000000000000904 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 904:	715d                	addi	sp,sp,-80
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	1000                	addi	s0,sp,32
 90c:	e010                	sd	a2,0(s0)
 90e:	e414                	sd	a3,8(s0)
 910:	e818                	sd	a4,16(s0)
 912:	ec1c                	sd	a5,24(s0)
 914:	03043023          	sd	a6,32(s0)
 918:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91c:	8622                	mv	a2,s0
 91e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 922:	d23ff0ef          	jal	644 <vprintf>
}
 926:	60e2                	ld	ra,24(sp)
 928:	6442                	ld	s0,16(sp)
 92a:	6161                	addi	sp,sp,80
 92c:	8082                	ret

000000000000092e <printf>:

void
printf(const char *fmt, ...)
{
 92e:	711d                	addi	sp,sp,-96
 930:	ec06                	sd	ra,24(sp)
 932:	e822                	sd	s0,16(sp)
 934:	1000                	addi	s0,sp,32
 936:	e40c                	sd	a1,8(s0)
 938:	e810                	sd	a2,16(s0)
 93a:	ec14                	sd	a3,24(s0)
 93c:	f018                	sd	a4,32(s0)
 93e:	f41c                	sd	a5,40(s0)
 940:	03043823          	sd	a6,48(s0)
 944:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 948:	00840613          	addi	a2,s0,8
 94c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 950:	85aa                	mv	a1,a0
 952:	4505                	li	a0,1
 954:	cf1ff0ef          	jal	644 <vprintf>
}
 958:	60e2                	ld	ra,24(sp)
 95a:	6442                	ld	s0,16(sp)
 95c:	6125                	addi	sp,sp,96
 95e:	8082                	ret

0000000000000960 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 960:	1141                	addi	sp,sp,-16
 962:	e406                	sd	ra,8(sp)
 964:	e022                	sd	s0,0(sp)
 966:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 968:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96c:	00001797          	auipc	a5,0x1
 970:	6947b783          	ld	a5,1684(a5) # 2000 <freep>
 974:	a039                	j	982 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 976:	6398                	ld	a4,0(a5)
 978:	00e7e463          	bltu	a5,a4,980 <free+0x20>
 97c:	00e6ea63          	bltu	a3,a4,990 <free+0x30>
{
 980:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 982:	fed7fae3          	bgeu	a5,a3,976 <free+0x16>
 986:	6398                	ld	a4,0(a5)
 988:	00e6e463          	bltu	a3,a4,990 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98c:	fee7eae3          	bltu	a5,a4,980 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 990:	ff852583          	lw	a1,-8(a0)
 994:	6390                	ld	a2,0(a5)
 996:	02059813          	slli	a6,a1,0x20
 99a:	01c85713          	srli	a4,a6,0x1c
 99e:	9736                	add	a4,a4,a3
 9a0:	02e60563          	beq	a2,a4,9ca <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9a4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 9a8:	4790                	lw	a2,8(a5)
 9aa:	02061593          	slli	a1,a2,0x20
 9ae:	01c5d713          	srli	a4,a1,0x1c
 9b2:	973e                	add	a4,a4,a5
 9b4:	02e68263          	beq	a3,a4,9d8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ba:	00001717          	auipc	a4,0x1
 9be:	64f73323          	sd	a5,1606(a4) # 2000 <freep>
}
 9c2:	60a2                	ld	ra,8(sp)
 9c4:	6402                	ld	s0,0(sp)
 9c6:	0141                	addi	sp,sp,16
 9c8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9ca:	4618                	lw	a4,8(a2)
 9cc:	9f2d                	addw	a4,a4,a1
 9ce:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d2:	6398                	ld	a4,0(a5)
 9d4:	6310                	ld	a2,0(a4)
 9d6:	b7f9                	j	9a4 <free+0x44>
    p->s.size += bp->s.size;
 9d8:	ff852703          	lw	a4,-8(a0)
 9dc:	9f31                	addw	a4,a4,a2
 9de:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9e0:	ff053683          	ld	a3,-16(a0)
 9e4:	bfd1                	j	9b8 <free+0x58>

00000000000009e6 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 9e6:	7139                	addi	sp,sp,-64
 9e8:	fc06                	sd	ra,56(sp)
 9ea:	f822                	sd	s0,48(sp)
 9ec:	f04a                	sd	s2,32(sp)
 9ee:	ec4e                	sd	s3,24(sp)
 9f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9f2:	02051993          	slli	s3,a0,0x20
 9f6:	0209d993          	srli	s3,s3,0x20
 9fa:	09bd                	addi	s3,s3,15
 9fc:	0049d993          	srli	s3,s3,0x4
 a00:	2985                	addiw	s3,s3,1
 a02:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 a04:	00001517          	auipc	a0,0x1
 a08:	5fc53503          	ld	a0,1532(a0) # 2000 <freep>
 a0c:	c905                	beqz	a0,a3c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a0e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a10:	4798                	lw	a4,8(a5)
 a12:	09377663          	bgeu	a4,s3,a9e <malloc+0xb8>
 a16:	f426                	sd	s1,40(sp)
 a18:	e852                	sd	s4,16(sp)
 a1a:	e456                	sd	s5,8(sp)
 a1c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a1e:	8a4e                	mv	s4,s3
 a20:	6705                	lui	a4,0x1
 a22:	00e9f363          	bgeu	s3,a4,a28 <malloc+0x42>
 a26:	6a05                	lui	s4,0x1
 a28:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a30:	00001497          	auipc	s1,0x1
 a34:	5d048493          	addi	s1,s1,1488 # 2000 <freep>
  if (p == SBRK_ERROR)
 a38:	5afd                	li	s5,-1
 a3a:	a83d                	j	a78 <malloc+0x92>
 a3c:	f426                	sd	s1,40(sp)
 a3e:	e852                	sd	s4,16(sp)
 a40:	e456                	sd	s5,8(sp)
 a42:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a44:	00001797          	auipc	a5,0x1
 a48:	5cc78793          	addi	a5,a5,1484 # 2010 <base>
 a4c:	00001717          	auipc	a4,0x1
 a50:	5af73a23          	sd	a5,1460(a4) # 2000 <freep>
 a54:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a56:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a5a:	b7d1                	j	a1e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a5c:	6398                	ld	a4,0(a5)
 a5e:	e118                	sd	a4,0(a0)
 a60:	a899                	j	ab6 <malloc+0xd0>
  hp->s.size = nu;
 a62:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a66:	0541                	addi	a0,a0,16
 a68:	ef9ff0ef          	jal	960 <free>
  return freep;
 a6c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 a6e:	c125                	beqz	a0,ace <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a70:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a72:	4798                	lw	a4,8(a5)
 a74:	03277163          	bgeu	a4,s2,a96 <malloc+0xb0>
    if (p == freep)
 a78:	6098                	ld	a4,0(s1)
 a7a:	853e                	mv	a0,a5
 a7c:	fef71ae3          	bne	a4,a5,a70 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a80:	8552                	mv	a0,s4
 a82:	a2bff0ef          	jal	4ac <sbrk>
  if (p == SBRK_ERROR)
 a86:	fd551ee3          	bne	a0,s5,a62 <malloc+0x7c>
        return 0;
 a8a:	4501                	li	a0,0
 a8c:	74a2                	ld	s1,40(sp)
 a8e:	6a42                	ld	s4,16(sp)
 a90:	6aa2                	ld	s5,8(sp)
 a92:	6b02                	ld	s6,0(sp)
 a94:	a03d                	j	ac2 <malloc+0xdc>
 a96:	74a2                	ld	s1,40(sp)
 a98:	6a42                	ld	s4,16(sp)
 a9a:	6aa2                	ld	s5,8(sp)
 a9c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a9e:	fae90fe3          	beq	s2,a4,a5c <malloc+0x76>
        p->s.size -= nunits;
 aa2:	4137073b          	subw	a4,a4,s3
 aa6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aa8:	02071693          	slli	a3,a4,0x20
 aac:	01c6d713          	srli	a4,a3,0x1c
 ab0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ab2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ab6:	00001717          	auipc	a4,0x1
 aba:	54a73523          	sd	a0,1354(a4) # 2000 <freep>
      return (void *)(p + 1);
 abe:	01078513          	addi	a0,a5,16
  }
}
 ac2:	70e2                	ld	ra,56(sp)
 ac4:	7442                	ld	s0,48(sp)
 ac6:	7902                	ld	s2,32(sp)
 ac8:	69e2                	ld	s3,24(sp)
 aca:	6121                	addi	sp,sp,64
 acc:	8082                	ret
 ace:	74a2                	ld	s1,40(sp)
 ad0:	6a42                	ld	s4,16(sp)
 ad2:	6aa2                	ld	s5,8(sp)
 ad4:	6b02                	ld	s6,0(sp)
 ad6:	b7f5                	j	ac2 <malloc+0xdc>
