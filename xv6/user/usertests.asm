
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	5b078793          	addi	a5,a5,1456 # 85c0 <malloc+0x29e6>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	6ca050ef          	jal	5714 <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00006517          	auipc	a0,0x6
      70:	c6450513          	addi	a0,a0,-924 # 5cd0 <malloc+0xf6>
      74:	2af050ef          	jal	5b22 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	65a050ef          	jal	56d4 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	0000b797          	auipc	a5,0xb
      82:	55a78793          	addi	a5,a5,1370 # b5d8 <uninit>
      86:	0000e697          	auipc	a3,0xe
      8a:	c6268693          	addi	a3,a3,-926 # dce8 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00006517          	auipc	a0,0x6
      aa:	c4a50513          	addi	a0,a0,-950 # 5cf0 <malloc+0x116>
      ae:	275050ef          	jal	5b22 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	620050ef          	jal	56d4 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	c4250513          	addi	a0,a0,-958 # 5d08 <malloc+0x12e>
      ce:	646050ef          	jal	5714 <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	626050ef          	jal	56fc <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00006517          	auipc	a0,0x6
      e0:	c4c50513          	addi	a0,a0,-948 # 5d28 <malloc+0x14e>
      e4:	630050ef          	jal	5714 <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00006517          	auipc	a0,0x6
      fc:	c1850513          	addi	a0,a0,-1000 # 5d10 <malloc+0x136>
     100:	223050ef          	jal	5b22 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	5ce050ef          	jal	56d4 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	c2c50513          	addi	a0,a0,-980 # 5d38 <malloc+0x15e>
     114:	20f050ef          	jal	5b22 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	5ba050ef          	jal	56d4 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00006517          	auipc	a0,0x6
     132:	c3250513          	addi	a0,a0,-974 # 5d60 <malloc+0x186>
     136:	5ee050ef          	jal	5724 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00006517          	auipc	a0,0x6
     142:	c2250513          	addi	a0,a0,-990 # 5d60 <malloc+0x186>
     146:	5ce050ef          	jal	5714 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00006597          	auipc	a1,0x6
     152:	c2258593          	addi	a1,a1,-990 # 5d70 <malloc+0x196>
     156:	59e050ef          	jal	56f4 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00006517          	auipc	a0,0x6
     162:	c0250513          	addi	a0,a0,-1022 # 5d60 <malloc+0x186>
     166:	5ae050ef          	jal	5714 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00006597          	auipc	a1,0x6
     172:	c0a58593          	addi	a1,a1,-1014 # 5d78 <malloc+0x19e>
     176:	8526                	mv	a0,s1
     178:	57c050ef          	jal	56f4 <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00006517          	auipc	a0,0x6
     186:	bde50513          	addi	a0,a0,-1058 # 5d60 <malloc+0x186>
     18a:	59a050ef          	jal	5724 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	56c050ef          	jal	56fc <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	566050ef          	jal	56fc <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00006517          	auipc	a0,0x6
     1b0:	bd450513          	addi	a0,a0,-1068 # 5d80 <malloc+0x1a6>
     1b4:	16f050ef          	jal	5b22 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	51a050ef          	jal	56d4 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	522050ef          	jal	5714 <open>
    close(fd);
     1f6:	506050ef          	jal	56fc <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	502050ef          	jal	5724 <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00006517          	auipc	a0,0x6
     260:	b4c50513          	addi	a0,a0,-1204 # 5da8 <malloc+0x1ce>
     264:	4c0050ef          	jal	5724 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00006a17          	auipc	s4,0x6
     274:	b38a0a13          	addi	s4,s4,-1224 # 5da8 <malloc+0x1ce>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000e997          	auipc	s3,0xe
     27e:	a6e98993          	addi	s3,s3,-1426 # dce8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <rmdot+0x51>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	488050ef          	jal	5714 <open>
     290:	892a                	mv	s2,a0
    if (fd < 0) {
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	456050ef          	jal	56f4 <write>
      if (cc != sz) {
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for (i = 0; i < 2; i++) {
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	44e050ef          	jal	56fc <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	470050ef          	jal	5724 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00006517          	auipc	a0,0x6
     2e0:	adc50513          	addi	a0,a0,-1316 # 5db8 <malloc+0x1de>
     2e4:	03f050ef          	jal	5b22 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	3ea050ef          	jal	56d4 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00006517          	auipc	a0,0x6
     2f8:	ae450513          	addi	a0,a0,-1308 # 5dd8 <malloc+0x1fe>
     2fc:	027050ef          	jal	5b22 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	3d2050ef          	jal	56d4 <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31a:	00006517          	auipc	a0,0x6
     31e:	ad650513          	addi	a0,a0,-1322 # 5df0 <malloc+0x216>
     322:	402050ef          	jal	5724 <unlink>
     326:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00006997          	auipc	s3,0x6
     332:	ac298993          	addi	s3,s3,-1342 # 5df0 <malloc+0x216>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	3d2050ef          	jal	5714 <open>
     346:	84aa                	mv	s1,a0
    if (fd < 0) {
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	3a4050ef          	jal	56f4 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	3a6050ef          	jal	56fc <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	3c8050ef          	jal	5724 <unlink>
  for (int i = 0; i < assumed_free; i++) {
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00006517          	auipc	a0,0x6
     36e:	a8650513          	addi	a0,a0,-1402 # 5df0 <malloc+0x216>
     372:	3a2050ef          	jal	5714 <open>
     376:	84aa                	mv	s1,a0
  if (fd < 0) {
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37c:	4605                	li	a2,1
     37e:	00006597          	auipc	a1,0x6
     382:	9fa58593          	addi	a1,a1,-1542 # 5d78 <malloc+0x19e>
     386:	36e050ef          	jal	56f4 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00006517          	auipc	a0,0x6
     394:	a8050513          	addi	a0,a0,-1408 # 5e10 <malloc+0x236>
     398:	78a050ef          	jal	5b22 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	336050ef          	jal	56d4 <exit>
      printf("open junk failed\n");
     3a2:	00006517          	auipc	a0,0x6
     3a6:	a5650513          	addi	a0,a0,-1450 # 5df8 <malloc+0x21e>
     3aa:	778050ef          	jal	5b22 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	324050ef          	jal	56d4 <exit>
    printf("open junk failed\n");
     3b4:	00006517          	auipc	a0,0x6
     3b8:	a4450513          	addi	a0,a0,-1468 # 5df8 <malloc+0x21e>
     3bc:	766050ef          	jal	5b22 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	312050ef          	jal	56d4 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	334050ef          	jal	56fc <close>
  unlink("junk");
     3cc:	00006517          	auipc	a0,0x6
     3d0:	a2450513          	addi	a0,a0,-1500 # 5df0 <malloc+0x216>
     3d4:	350050ef          	jal	5724 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	2fa050ef          	jal	56d4 <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	2f0050ef          	jal	5724 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	2d8050ef          	jal	5714 <open>
    if (fd < 0) {
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	2b8050ef          	jal	56fc <close>
  for (int i = 0; i < nzz; i++) {
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
     44e:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++) {
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	296050ef          	jal	5724 <unlink>
  for (int i = 0; i < nzz; i++) {
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00008797          	auipc	a5,0x8
     4c8:	0fc78793          	addi	a5,a5,252 # 85c0 <malloc+0x29e6>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00006a97          	auipc	s5,0x6
     4fa:	92aa8a93          	addi	s5,s5,-1750 # 5e20 <malloc+0x246>
    int n = write(fd, (void *)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     500:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	206050ef          	jal	5714 <open>
     512:	84aa                	mv	s1,a0
    if (fd < 0) {
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	1d8050ef          	jal	56f4 <write>
    if (n >= 0) {
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	1d6050ef          	jal	56fc <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	1f8050ef          	jal	5724 <unlink>
    n = write(1, (char *)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	1be050ef          	jal	56f4 <write>
    if (n > 0) {
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if (pipe(fds) < 0) {
     53e:	855e                	mv	a0,s7
     540:	1a4050ef          	jal	56e4 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	1a4050ef          	jal	56f4 <write>
    if (n > 0) {
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	1a0050ef          	jal	56fc <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	198050ef          	jal	56fc <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00006517          	auipc	a0,0x6
     58c:	8a050513          	addi	a0,a0,-1888 # 5e28 <malloc+0x24e>
     590:	592050ef          	jal	5b22 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	13e050ef          	jal	56d4 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00006517          	auipc	a0,0x6
     5a2:	8a250513          	addi	a0,a0,-1886 # 5e40 <malloc+0x266>
     5a6:	57c050ef          	jal	5b22 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	128050ef          	jal	56d4 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00006517          	auipc	a0,0x6
     5b8:	8bc50513          	addi	a0,a0,-1860 # 5e70 <malloc+0x296>
     5bc:	566050ef          	jal	5b22 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	112050ef          	jal	56d4 <exit>
      printf("pipe() failed\n");
     5c6:	00006517          	auipc	a0,0x6
     5ca:	8da50513          	addi	a0,a0,-1830 # 5ea0 <malloc+0x2c6>
     5ce:	554050ef          	jal	5b22 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	100050ef          	jal	56d4 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00006517          	auipc	a0,0x6
     5e0:	8d450513          	addi	a0,a0,-1836 # 5eb0 <malloc+0x2d6>
     5e4:	53e050ef          	jal	5b22 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	0ea050ef          	jal	56d4 <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     608:	00008797          	auipc	a5,0x8
     60c:	fb878793          	addi	a5,a5,-72 # 85c0 <malloc+0x29e6>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00006b17          	auipc	s6,0x6
     640:	8a4b0b13          	addi	s6,s6,-1884 # 5ee0 <malloc+0x306>
    int n = read(fd, (void *)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	72cb8b93          	addi	s7,s7,1836 # 5d78 <malloc+0x19e>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	0b8050ef          	jal	5714 <open>
     660:	84aa                	mv	s1,a0
    if (fd < 0) {
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	082050ef          	jal	56ec <read>
    if (n > 0) {
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	088050ef          	jal	56fc <close>
    if (pipe(fds) < 0) {
     678:	8562                	mv	a0,s8
     67a:	06a050ef          	jal	56e4 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	06a050ef          	jal	56f4 <write>
    if (n != 1) {
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	052050ef          	jal	56ec <read>
    if (n > 0) {
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	056050ef          	jal	56fc <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	04e050ef          	jal	56fc <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00006517          	auipc	a0,0x6
     6d6:	81650513          	addi	a0,a0,-2026 # 5ee8 <malloc+0x30e>
     6da:	448050ef          	jal	5b22 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	7f5040ef          	jal	56d4 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00006517          	auipc	a0,0x6
     6ec:	81850513          	addi	a0,a0,-2024 # 5f00 <malloc+0x326>
     6f0:	432050ef          	jal	5b22 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	7df040ef          	jal	56d4 <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	7a650513          	addi	a0,a0,1958 # 5ea0 <malloc+0x2c6>
     702:	420050ef          	jal	5b22 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	7cd040ef          	jal	56d4 <exit>
      printf("pipe write failed\n");
     70c:	00006517          	auipc	a0,0x6
     710:	82450513          	addi	a0,a0,-2012 # 5f30 <malloc+0x356>
     714:	40e050ef          	jal	5b22 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	7bb040ef          	jal	56d4 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00006517          	auipc	a0,0x6
     726:	82650513          	addi	a0,a0,-2010 # 5f48 <malloc+0x36e>
     72a:	3f8050ef          	jal	5b22 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	7a5040ef          	jal	56d4 <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	61850513          	addi	a0,a0,1560 # 5d60 <malloc+0x186>
     750:	7d5040ef          	jal	5724 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	60850513          	addi	a0,a0,1544 # 5d60 <malloc+0x186>
     760:	7b5040ef          	jal	5714 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	60858593          	addi	a1,a1,1544 # 5d70 <malloc+0x196>
     770:	785040ef          	jal	56f4 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	787040ef          	jal	56fc <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	5e450513          	addi	a0,a0,1508 # 5d60 <malloc+0x186>
     784:	791040ef          	jal	5714 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	75b040ef          	jal	56ec <read>
  if (n != 4) {
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	5c050513          	addi	a0,a0,1472 # 5d60 <malloc+0x186>
     7a8:	76d040ef          	jal	5714 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	5b050513          	addi	a0,a0,1456 # 5d60 <malloc+0x186>
     7b8:	75d040ef          	jal	5714 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	727040ef          	jal	56ec <read>
     7ca:	8aaa                	mv	s5,a0
  if (n != 0) {
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	715040ef          	jal	56ec <read>
     7dc:	8aaa                	mv	s5,a0
  if (n != 0) {
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	7f658593          	addi	a1,a1,2038 # 5fd8 <malloc+0x3fe>
     7ea:	854e                	mv	a0,s3
     7ec:	709040ef          	jal	56f4 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	6f3040ef          	jal	56ec <read>
  if (n != 6) {
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	6df040ef          	jal	56ec <read>
  if (n != 2) {
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	54850513          	addi	a0,a0,1352 # 5d60 <malloc+0x186>
     820:	705040ef          	jal	5724 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	6d7040ef          	jal	56fc <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	6d1040ef          	jal	56fc <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	6cb040ef          	jal	56fc <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	72c50513          	addi	a0,a0,1836 # 5f78 <malloc+0x39e>
     854:	2ce050ef          	jal	5b22 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	67b040ef          	jal	56d4 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	73850513          	addi	a0,a0,1848 # 5f98 <malloc+0x3be>
     868:	2ba050ef          	jal	5b22 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	73850513          	addi	a0,a0,1848 # 5fa8 <malloc+0x3ce>
     878:	2aa050ef          	jal	5b22 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	657040ef          	jal	56d4 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	74450513          	addi	a0,a0,1860 # 5fc8 <malloc+0x3ee>
     88c:	296050ef          	jal	5b22 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	71450513          	addi	a0,a0,1812 # 5fa8 <malloc+0x3ce>
     89c:	286050ef          	jal	5b22 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	633040ef          	jal	56d4 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	73650513          	addi	a0,a0,1846 # 5fe0 <malloc+0x406>
     8b2:	270050ef          	jal	5b22 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	61d040ef          	jal	56d4 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	74050513          	addi	a0,a0,1856 # 6000 <malloc+0x426>
     8c8:	25a050ef          	jal	5b22 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	607040ef          	jal	56d4 <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	73250513          	addi	a0,a0,1842 # 6020 <malloc+0x446>
     8f6:	61f040ef          	jal	5714 <open>
  if (fd < 0) {
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	744a0a13          	addi	s4,s4,1860 # 6048 <malloc+0x46e>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90c:	00005b17          	auipc	s6,0x5
     910:	774b0b13          	addi	s6,s6,1908 # 6080 <malloc+0x4a6>
  for (i = 0; i < N; i++) {
     914:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	5d7040ef          	jal	56f4 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	5c9040ef          	jal	56f4 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	5c1040ef          	jal	56fc <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	6de50513          	addi	a0,a0,1758 # 6020 <malloc+0x446>
     94a:	5cb040ef          	jal	5714 <open>
     94e:	84aa                	mv	s1,a0
  if (fd < 0) {
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     954:	7d000613          	li	a2,2000
     958:	0000d597          	auipc	a1,0xd
     95c:	39058593          	addi	a1,a1,912 # dce8 <buf>
     960:	58d040ef          	jal	56ec <read>
  if (i != N * SZ * 2) {
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	58f040ef          	jal	56fc <close>
  if (unlink("small") < 0) {
     972:	00005517          	auipc	a0,0x5
     976:	6ae50513          	addi	a0,a0,1710 # 6020 <malloc+0x446>
     97a:	5ab040ef          	jal	5724 <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	68e50513          	addi	a0,a0,1678 # 6028 <malloc+0x44e>
     9a2:	180050ef          	jal	5b22 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	52d040ef          	jal	56d4 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	6a850513          	addi	a0,a0,1704 # 6058 <malloc+0x47e>
     9b8:	16a050ef          	jal	5b22 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	517040ef          	jal	56d4 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	6ca50513          	addi	a0,a0,1738 # 6090 <malloc+0x4b6>
     9ce:	154050ef          	jal	5b22 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	501040ef          	jal	56d4 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	6de50513          	addi	a0,a0,1758 # 60b8 <malloc+0x4de>
     9e2:	140050ef          	jal	5b22 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	4ed040ef          	jal	56d4 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	6ea50513          	addi	a0,a0,1770 # 60d8 <malloc+0x4fe>
     9f6:	12c050ef          	jal	5b22 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	4d9040ef          	jal	56d4 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	6ee50513          	addi	a0,a0,1774 # 60f0 <malloc+0x516>
     a0a:	118050ef          	jal	5b22 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	4c5040ef          	jal	56d4 <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	6e250513          	addi	a0,a0,1762 # 6110 <malloc+0x536>
     a36:	4df040ef          	jal	5714 <open>
  if (fd < 0) {
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a42:	0000d997          	auipc	s3,0xd
     a46:	2a698993          	addi	s3,s3,678 # dce8 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4a:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a4e:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	499040ef          	jal	56f4 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	491040ef          	jal	56fc <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	69e50513          	addi	a0,a0,1694 # 6110 <malloc+0x536>
     a7a:	49b040ef          	jal	5714 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000d917          	auipc	s2,0xd
     a8a:	26290913          	addi	s2,s2,610 # dce8 <buf>
  if (fd < 0) {
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	455040ef          	jal	56ec <read>
    if (i == 0) {
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if (i != BSIZE) {
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	66850513          	addi	a0,a0,1640 # 6118 <malloc+0x53e>
     ab8:	06a050ef          	jal	5b22 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	417040ef          	jal	56d4 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	67250513          	addi	a0,a0,1650 # 6138 <malloc+0x55e>
     ace:	054050ef          	jal	5b22 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	401040ef          	jal	56d4 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	68650513          	addi	a0,a0,1670 # 6160 <malloc+0x586>
     ae2:	040050ef          	jal	5b22 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	3ed040ef          	jal	56d4 <exit>
      if (n != MAXFILE) {
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	407040ef          	jal	56fc <close>
  if (unlink("big") < 0) {
     afa:	00005517          	auipc	a0,0x5
     afe:	61650513          	addi	a0,a0,1558 # 6110 <malloc+0x536>
     b02:	423040ef          	jal	5724 <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	65e50513          	addi	a0,a0,1630 # 6180 <malloc+0x5a6>
     b2a:	7f9040ef          	jal	5b22 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	3a5040ef          	jal	56d4 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	67050513          	addi	a0,a0,1648 # 61a8 <malloc+0x5ce>
     b40:	7e3040ef          	jal	5b22 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	38f040ef          	jal	56d4 <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	67250513          	addi	a0,a0,1650 # 61c0 <malloc+0x5e6>
     b56:	7cd040ef          	jal	5b22 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	379040ef          	jal	56d4 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	68650513          	addi	a0,a0,1670 # 61e8 <malloc+0x60e>
     b6a:	7b9040ef          	jal	5b22 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	365040ef          	jal	56d4 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	67850513          	addi	a0,a0,1656 # 6200 <malloc+0x626>
     b90:	385040ef          	jal	5714 <open>
  if (fd < 0) {
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	69458593          	addi	a1,a1,1684 # 6230 <malloc+0x656>
     ba4:	351040ef          	jal	56f4 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	353040ef          	jal	56fc <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	65050513          	addi	a0,a0,1616 # 6200 <malloc+0x626>
     bb8:	35d040ef          	jal	5714 <open>
     bbc:	84aa                	mv	s1,a0
  if (fd < 0) {
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc2:	00005517          	auipc	a0,0x5
     bc6:	63e50513          	addi	a0,a0,1598 # 6200 <malloc+0x626>
     bca:	35b040ef          	jal	5724 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	62c50513          	addi	a0,a0,1580 # 6200 <malloc+0x626>
     bdc:	339040ef          	jal	5714 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	69458593          	addi	a1,a1,1684 # 6278 <malloc+0x69e>
     bec:	309040ef          	jal	56f4 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	30b040ef          	jal	56fc <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf6:	660d                	lui	a2,0x3
     bf8:	0000d597          	auipc	a1,0xd
     bfc:	0f058593          	addi	a1,a1,240 # dce8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	2eb040ef          	jal	56ec <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0c:	0000d717          	auipc	a4,0xd
     c10:	0dc74703          	lbu	a4,220(a4) # dce8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1c:	4629                	li	a2,10
     c1e:	0000d597          	auipc	a1,0xd
     c22:	0ca58593          	addi	a1,a1,202 # dce8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	2cd040ef          	jal	56f4 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	2c9040ef          	jal	56fc <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	5c850513          	addi	a0,a0,1480 # 6200 <malloc+0x626>
     c40:	2e5040ef          	jal	5724 <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	5bc50513          	addi	a0,a0,1468 # 6210 <malloc+0x636>
     c5c:	6c7040ef          	jal	5b22 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	273040ef          	jal	56d4 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	5d050513          	addi	a0,a0,1488 # 6238 <malloc+0x65e>
     c70:	6b3040ef          	jal	5b22 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	25f040ef          	jal	56d4 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	5dc50513          	addi	a0,a0,1500 # 6258 <malloc+0x67e>
     c84:	69f040ef          	jal	5b22 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	24b040ef          	jal	56d4 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	5f050513          	addi	a0,a0,1520 # 6280 <malloc+0x6a6>
     c98:	68b040ef          	jal	5b22 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	237040ef          	jal	56d4 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	5fc50513          	addi	a0,a0,1532 # 62a0 <malloc+0x6c6>
     cac:	677040ef          	jal	5b22 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	223040ef          	jal	56d4 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	60850513          	addi	a0,a0,1544 # 62c0 <malloc+0x6e6>
     cc0:	663040ef          	jal	5b22 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	20f040ef          	jal	56d4 <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	60850513          	addi	a0,a0,1544 # 62e0 <malloc+0x706>
     ce0:	245040ef          	jal	5724 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	60450513          	addi	a0,a0,1540 # 62e8 <malloc+0x70e>
     cec:	239040ef          	jal	5724 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	5ec50513          	addi	a0,a0,1516 # 62e0 <malloc+0x706>
     cfc:	219040ef          	jal	5714 <open>
  if (fd < 0) {
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	52858593          	addi	a1,a1,1320 # 6230 <malloc+0x656>
     d10:	1e5040ef          	jal	56f4 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	1e1040ef          	jal	56fc <close>
  if (link("lf1", "lf2") < 0) {
     d20:	00005597          	auipc	a1,0x5
     d24:	5c858593          	addi	a1,a1,1480 # 62e8 <malloc+0x70e>
     d28:	00005517          	auipc	a0,0x5
     d2c:	5b850513          	addi	a0,a0,1464 # 62e0 <malloc+0x706>
     d30:	205040ef          	jal	5734 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	5a850513          	addi	a0,a0,1448 # 62e0 <malloc+0x706>
     d40:	1e5040ef          	jal	5724 <unlink>
  if (open("lf1", 0) >= 0) {
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	59a50513          	addi	a0,a0,1434 # 62e0 <malloc+0x706>
     d4e:	1c7040ef          	jal	5714 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	59050513          	addi	a0,a0,1424 # 62e8 <malloc+0x70e>
     d60:	1b5040ef          	jal	5714 <open>
     d64:	84aa                	mv	s1,a0
  if (fd < 0) {
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6a:	660d                	lui	a2,0x3
     d6c:	0000d597          	auipc	a1,0xd
     d70:	f7c58593          	addi	a1,a1,-132 # dce8 <buf>
     d74:	179040ef          	jal	56ec <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	17d040ef          	jal	56fc <close>
  if (link("lf2", "lf2") >= 0) {
     d84:	00005597          	auipc	a1,0x5
     d88:	56458593          	addi	a1,a1,1380 # 62e8 <malloc+0x70e>
     d8c:	852e                	mv	a0,a1
     d8e:	1a7040ef          	jal	5734 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	55250513          	addi	a0,a0,1362 # 62e8 <malloc+0x70e>
     d9e:	187040ef          	jal	5724 <unlink>
  if (link("lf2", "lf1") >= 0) {
     da2:	00005597          	auipc	a1,0x5
     da6:	53e58593          	addi	a1,a1,1342 # 62e0 <malloc+0x706>
     daa:	00005517          	auipc	a0,0x5
     dae:	53e50513          	addi	a0,a0,1342 # 62e8 <malloc+0x70e>
     db2:	183040ef          	jal	5734 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dba:	00005597          	auipc	a1,0x5
     dbe:	52658593          	addi	a1,a1,1318 # 62e0 <malloc+0x706>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	62e50513          	addi	a0,a0,1582 # 63f0 <malloc+0x816>
     dca:	16b040ef          	jal	5734 <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	51050513          	addi	a0,a0,1296 # 62f0 <malloc+0x716>
     de8:	53b040ef          	jal	5b22 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	0e7040ef          	jal	56d4 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	51450513          	addi	a0,a0,1300 # 6308 <malloc+0x72e>
     dfc:	527040ef          	jal	5b22 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	0d3040ef          	jal	56d4 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	51850513          	addi	a0,a0,1304 # 6320 <malloc+0x746>
     e10:	513040ef          	jal	5b22 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	0bf040ef          	jal	56d4 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	52450513          	addi	a0,a0,1316 # 6340 <malloc+0x766>
     e24:	4ff040ef          	jal	5b22 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	0ab040ef          	jal	56d4 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	54050513          	addi	a0,a0,1344 # 6370 <malloc+0x796>
     e38:	4eb040ef          	jal	5b22 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	097040ef          	jal	56d4 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	54450513          	addi	a0,a0,1348 # 6388 <malloc+0x7ae>
     e4c:	4d7040ef          	jal	5b22 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	083040ef          	jal	56d4 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	54850513          	addi	a0,a0,1352 # 63a0 <malloc+0x7c6>
     e60:	4c3040ef          	jal	5b22 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	06f040ef          	jal	56d4 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	55c50513          	addi	a0,a0,1372 # 63c8 <malloc+0x7ee>
     e74:	4af040ef          	jal	5b22 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	05b040ef          	jal	56d4 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	57850513          	addi	a0,a0,1400 # 63f8 <malloc+0x81e>
     e88:	49b040ef          	jal	5b22 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	047040ef          	jal	56d4 <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ea8:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eaa:	00005997          	auipc	s3,0x5
     eae:	56e98993          	addi	s3,s3,1390 # 6418 <malloc+0x83e>
     eb2:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	077040ef          	jal	5734 <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	54650513          	addi	a0,a0,1350 # 6428 <malloc+0x84e>
     eea:	439040ef          	jal	5b22 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	7e4040ef          	jal	56d4 <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	53c50513          	addi	a0,a0,1340 # 6448 <malloc+0x86e>
     f14:	011040ef          	jal	5724 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	52c50513          	addi	a0,a0,1324 # 6448 <malloc+0x86e>
     f24:	7f0040ef          	jal	5714 <open>
  if (fd < 0) {
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	7d0040ef          	jal	56fc <close>
  for (i = 0; i < N; i++) {
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	50e98993          	addi	s3,s3,1294 # 6448 <malloc+0x86e>
  for (i = 0; i < N; i++) {
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	7bc040ef          	jal	5734 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	4c250513          	addi	a0,a0,1218 # 6448 <malloc+0x86e>
     f8e:	796040ef          	jal	5724 <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if (unlink(name) != 0) {
     f96:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fcc:	854a                	mv	a0,s2
     fce:	756040ef          	jal	5724 <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	45e50513          	addi	a0,a0,1118 # 6450 <malloc+0x876>
     ffa:	329040ef          	jal	5b22 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	6d4040ef          	jal	56d4 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	46450513          	addi	a0,a0,1124 # 6470 <malloc+0x896>
    1014:	30f040ef          	jal	5b22 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	6ba040ef          	jal	56d4 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	47850513          	addi	a0,a0,1144 # 6498 <malloc+0x8be>
    1028:	2fb040ef          	jal	5b22 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	6a6040ef          	jal	56d4 <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00009497          	auipc	s1,0x9
    1044:	fc048493          	addi	s1,s1,-64 # a000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	6be040ef          	jal	570c <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	690040ef          	jal	56e4 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	67a040ef          	jal	56d4 <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <uninit+0xd78>
    argv[0] = (char *)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00005997          	auipc	s3,0x5
    1082:	c8a98993          	addi	s3,s3,-886 # 5d08 <malloc+0x12e>
    argv[0] = (char *)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	67a040ef          	jal	570c <exec>
  for (int i = 0; i < 50000; i++) {
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	638040ef          	jal	56d4 <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	65e040ef          	jal	5724 <unlink>
  if (ret != -1) {
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	63c040ef          	jal	5714 <open>
  if (fd != -1) {
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	64c040ef          	jal	5734 <link>
  if (ret != -1) {
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f2:	00006797          	auipc	a5,0x6
    10f6:	48e78793          	addi	a5,a5,1166 # 7580 <malloc+0x19a6>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	602040ef          	jal	570c <exec>
  if (ret != -1) {
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	5b8040ef          	jal	56cc <fork>
  if (pid < 0) {
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if (pid == 0) {
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00009797          	auipc	a5,0x9
    1124:	4b078793          	addi	a5,a5,1200 # a5d0 <big.0>
    1128:	0000a697          	auipc	a3,0xa
    112c:	4a868693          	addi	a3,a3,1192 # b5d0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	0000a797          	auipc	a5,0xa
    1142:	48078923          	sb	zero,1170(a5) # b5d0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1146:	00007797          	auipc	a5,0x7
    114a:	47a78793          	addi	a5,a5,1146 # 85c0 <malloc+0x29e6>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00005517          	auipc	a0,0x5
    116e:	b9e50513          	addi	a0,a0,-1122 # 5d08 <malloc+0x12e>
    1172:	59a040ef          	jal	570c <exec>
    if (ret != -1) {
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	3c250513          	addi	a0,a0,962 # 6540 <malloc+0x966>
    1186:	19d040ef          	jal	5b22 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	548040ef          	jal	56d4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	32250513          	addi	a0,a0,802 # 64b8 <malloc+0x8de>
    119e:	185040ef          	jal	5b22 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	530040ef          	jal	56d4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	32a50513          	addi	a0,a0,810 # 64d8 <malloc+0x8fe>
    11b6:	16d040ef          	jal	5b22 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	518040ef          	jal	56d4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	33050513          	addi	a0,a0,816 # 64f8 <malloc+0x91e>
    11d0:	153040ef          	jal	5b22 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	4fe040ef          	jal	56d4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	34050513          	addi	a0,a0,832 # 6520 <malloc+0x946>
    11e8:	13b040ef          	jal	5b22 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	4e6040ef          	jal	56d4 <exit>
    printf("fork failed\n");
    11f2:	00007517          	auipc	a0,0x7
    11f6:	a6650513          	addi	a0,a0,-1434 # 7c58 <malloc+0x207e>
    11fa:	129040ef          	jal	5b22 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	4d4040ef          	jal	56d4 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	4cc040ef          	jal	56d4 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	4c8040ef          	jal	56dc <wait>
  if (st != 747) {
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	33c50513          	addi	a0,a0,828 # 6568 <malloc+0x98e>
    1234:	0ef040ef          	jal	5b22 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	49a040ef          	jal	56d4 <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00005517          	auipc	a0,0x5
    1252:	b1250513          	addi	a0,a0,-1262 # 5d60 <malloc+0x186>
    1256:	4be040ef          	jal	5714 <open>
    125a:	4a2040ef          	jal	56fc <close>
  pid = fork();
    125e:	46e040ef          	jal	56cc <fork>
  if (pid < 0) {
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if (pid == 0) {
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00005997          	auipc	s3,0x5
    1282:	ae298993          	addi	s3,s3,-1310 # 5d60 <malloc+0x186>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	340b0b13          	addi	s6,s6,832 # 65c8 <malloc+0x9ee>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	478040ef          	jal	5714 <open>
    12a0:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	44a040ef          	jal	56f4 <write>
      if (n != 10) {
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	448040ef          	jal	56fc <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	458040ef          	jal	5714 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	426040ef          	jal	56ec <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	430040ef          	jal	56fc <close>
    for (int i = 0; i < 100; i++) {
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	3fc040ef          	jal	56d4 <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	2aa50513          	addi	a0,a0,682 # 6598 <malloc+0x9be>
    12f6:	02d040ef          	jal	5b22 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	3d8040ef          	jal	56d4 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	2ae50513          	addi	a0,a0,686 # 65b0 <malloc+0x9d6>
    130a:	019040ef          	jal	5b22 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	3c4040ef          	jal	56d4 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	2c050513          	addi	a0,a0,704 # 65d8 <malloc+0x9fe>
    1320:	003040ef          	jal	5b22 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	3ae040ef          	jal	56d4 <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00005a17          	auipc	s4,0x5
    1342:	a22a0a13          	addi	s4,s4,-1502 # 5d60 <malloc+0x186>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	2b0b0b13          	addi	s6,s6,688 # 65f8 <malloc+0xa1e>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	3c0040ef          	jal	5714 <open>
    1358:	84aa                	mv	s1,a0
    if (fd < 0) {
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	392040ef          	jal	56f4 <write>
    if (n != 3) {
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	390040ef          	jal	56fc <close>
  for (int i = 0; i < 150; i++) {
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	35e040ef          	jal	56dc <wait>
  unlink("truncfile");
    1382:	00005517          	auipc	a0,0x5
    1386:	9de50513          	addi	a0,a0,-1570 # 5d60 <malloc+0x186>
    138a:	39a040ef          	jal	5724 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	342040ef          	jal	56d4 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	21450513          	addi	a0,a0,532 # 65b0 <malloc+0x9d6>
    13a4:	77e040ef          	jal	5b22 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	32a040ef          	jal	56d4 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	24a50513          	addi	a0,a0,586 # 6600 <malloc+0xa26>
    13be:	764040ef          	jal	5b22 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	310040ef          	jal	56d4 <exit>

00000000000013c8 <pipe1>:
{
    13c8:	711d                	addi	sp,sp,-96
    13ca:	ec86                	sd	ra,88(sp)
    13cc:	e8a2                	sd	s0,80(sp)
    13ce:	e862                	sd	s8,16(sp)
    13d0:	1080                	addi	s0,sp,96
    13d2:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    13d4:	fa840513          	addi	a0,s0,-88
    13d8:	30c040ef          	jal	56e4 <pipe>
    13dc:	e925                	bnez	a0,144c <pipe1+0x84>
    13de:	e4a6                	sd	s1,72(sp)
    13e0:	fc4e                	sd	s3,56(sp)
    13e2:	84aa                	mv	s1,a0
  pid = fork();
    13e4:	2e8040ef          	jal	56cc <fork>
    13e8:	89aa                	mv	s3,a0
  if (pid == 0) {
    13ea:	c151                	beqz	a0,146e <pipe1+0xa6>
  } else if (pid > 0) {
    13ec:	16a05063          	blez	a0,154c <pipe1+0x184>
    13f0:	e0ca                	sd	s2,64(sp)
    13f2:	f852                	sd	s4,48(sp)
    close(fds[1]);
    13f4:	fac42503          	lw	a0,-84(s0)
    13f8:	304040ef          	jal	56fc <close>
    total = 0;
    13fc:	89a6                	mv	s3,s1
    cc = 1;
    13fe:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1400:	0000da17          	auipc	s4,0xd
    1404:	8e8a0a13          	addi	s4,s4,-1816 # dce8 <buf>
    1408:	864a                	mv	a2,s2
    140a:	85d2                	mv	a1,s4
    140c:	fa842503          	lw	a0,-88(s0)
    1410:	2dc040ef          	jal	56ec <read>
    1414:	85aa                	mv	a1,a0
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x140>
    141a:	0000d797          	auipc	a5,0xd
    141e:	8ce78793          	addi	a5,a5,-1842 # dce8 <buf>
    1422:	00b4863b          	addw	a2,s1,a1
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	0007c683          	lbu	a3,0(a5)
    142a:	0ff4f713          	zext.b	a4,s1
    142e:	0ae69d63          	bne	a3,a4,14e8 <pipe1+0x120>
    1432:	2485                	addiw	s1,s1,1
      for (i = 0; i < n; i++) {
    1434:	0785                	addi	a5,a5,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5e>
      total += n;
    143a:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    143e:	0019191b          	slliw	s2,s2,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd27f2e3          	bgeu	a5,s2,1408 <pipe1+0x40>
        cc = sizeof(buf);
    1448:	893e                	mv	s2,a5
    144a:	bf7d                	j	1408 <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	e0ca                	sd	s2,64(sp)
    1450:	fc4e                	sd	s3,56(sp)
    1452:	f852                	sd	s4,48(sp)
    1454:	f456                	sd	s5,40(sp)
    1456:	f05a                	sd	s6,32(sp)
    1458:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85e2                	mv	a1,s8
    145c:	00005517          	auipc	a0,0x5
    1460:	1c450513          	addi	a0,a0,452 # 6620 <malloc+0xa46>
    1464:	6be040ef          	jal	5b22 <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	26a040ef          	jal	56d4 <exit>
    146e:	e0ca                	sd	s2,64(sp)
    1470:	f852                	sd	s4,48(sp)
    1472:	f456                	sd	s5,40(sp)
    1474:	f05a                	sd	s6,32(sp)
    1476:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	280040ef          	jal	56fc <close>
    for (n = 0; n < N; n++) {
    1480:	0000db17          	auipc	s6,0xd
    1484:	868b0b13          	addi	s6,s6,-1944 # dce8 <buf>
    1488:	416004bb          	negw	s1,s6
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a13          	li	s4,1033
    1498:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    149a:	6a85                	lui	s5,0x1
    149c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0x65>
{
    14a0:	87da                	mv	a5,s6
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x476>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff279be3          	bne	a5,s2,14a2 <pipe1+0xda>
      if (write(fds[1], buf, SZ) != SZ) {
    14b0:	8652                	mv	a2,s4
    14b2:	85de                	mv	a1,s7
    14b4:	fac42503          	lw	a0,-84(s0)
    14b8:	23c040ef          	jal	56f4 <write>
    14bc:	01451c63          	bne	a0,s4,14d4 <pipe1+0x10c>
    14c0:	4099899b          	addiw	s3,s3,1033
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd599be3          	bne	s3,s5,14a0 <pipe1+0xd8>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	204040ef          	jal	56d4 <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85e2                	mv	a1,s8
    14d6:	00005517          	auipc	a0,0x5
    14da:	16250513          	addi	a0,a0,354 # 6638 <malloc+0xa5e>
    14de:	644040ef          	jal	5b22 <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	1f0040ef          	jal	56d4 <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85e2                	mv	a1,s8
    14ea:	00005517          	auipc	a0,0x5
    14ee:	16650513          	addi	a0,a0,358 # 6650 <malloc+0xa76>
    14f2:	630040ef          	jal	5b22 <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	6906                	ld	s2,64(sp)
    14fa:	79e2                	ld	s3,56(sp)
    14fc:	7a42                	ld	s4,48(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6c42                	ld	s8,16(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x65>
    150e:	02f98063          	beq	s3,a5,152e <pipe1+0x166>
    1512:	f456                	sd	s5,40(sp)
    1514:	f05a                	sd	s6,32(sp)
    1516:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	864e                	mv	a2,s3
    151a:	85e2                	mv	a1,s8
    151c:	00005517          	auipc	a0,0x5
    1520:	14c50513          	addi	a0,a0,332 # 6668 <malloc+0xa8e>
    1524:	5fe040ef          	jal	5b22 <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	1aa040ef          	jal	56d4 <exit>
    152e:	f456                	sd	s5,40(sp)
    1530:	f05a                	sd	s6,32(sp)
    1532:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	1c4040ef          	jal	56fc <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	19c040ef          	jal	56dc <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	18c040ef          	jal	56d4 <exit>
    154c:	e0ca                	sd	s2,64(sp)
    154e:	f852                	sd	s4,48(sp)
    1550:	f456                	sd	s5,40(sp)
    1552:	f05a                	sd	s6,32(sp)
    1554:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1556:	85e2                	mv	a1,s8
    1558:	00005517          	auipc	a0,0x5
    155c:	13050513          	addi	a0,a0,304 # 6688 <malloc+0xaae>
    1560:	5c2040ef          	jal	5b22 <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	16e040ef          	jal	56d4 <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	144040ef          	jal	56cc <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	146040ef          	jal	56dc <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	fd850513          	addi	a0,a0,-40 # 6598 <malloc+0x9be>
    15c8:	55a040ef          	jal	5b22 <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	106040ef          	jal	56d4 <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	0cc50513          	addi	a0,a0,204 # 66a0 <malloc+0xac6>
    15dc:	546040ef          	jal	5b22 <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	0f2040ef          	jal	56d4 <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	0d050513          	addi	a0,a0,208 # 66b8 <malloc+0xade>
    15f0:	532040ef          	jal	5b22 <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	0de040ef          	jal	56d4 <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	0d8040ef          	jal	56d4 <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	0ba040ef          	jal	56cc <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	0b0040ef          	jal	56cc <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	0b4040ef          	jal	56dc <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	0ae040ef          	jal	56dc <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	f5450513          	addi	a0,a0,-172 # 6598 <malloc+0x9be>
    164c:	4d6040ef          	jal	5b22 <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	082040ef          	jal	56d4 <exit>
      exit(0);
    1656:	07e040ef          	jal	56d4 <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	f3c50513          	addi	a0,a0,-196 # 6598 <malloc+0x9be>
    1664:	4be040ef          	jal	5b22 <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	06a040ef          	jal	56d4 <exit>
        exit(0);
    166e:	066040ef          	jal	56d4 <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	04e040ef          	jal	56cc <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	044040ef          	jal	56cc <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	046040ef          	jal	56dc <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	038040ef          	jal	56dc <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	01e50513          	addi	a0,a0,30 # 66d8 <malloc+0xafe>
    16c2:	460040ef          	jal	5b22 <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	00c040ef          	jal	56d4 <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	7fd030ef          	jal	56cc <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	000040ef          	jal	56dc <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	7ef030ef          	jal	56d4 <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	7e9030ef          	jal	56d4 <exit>
          exit(0);
    16f0:	7e5030ef          	jal	56d4 <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	ff250513          	addi	a0,a0,-14 # 66e8 <malloc+0xb0e>
    16fe:	424040ef          	jal	5b22 <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	7d1030ef          	jal	56d4 <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	7b7030ef          	jal	56cc <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	7bb030ef          	jal	56dc <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	7a9030ef          	jal	56d4 <exit>
      printf("fork failed\n");
    1730:	00006517          	auipc	a0,0x6
    1734:	52850513          	addi	a0,a0,1320 # 7c58 <malloc+0x207e>
    1738:	3ea040ef          	jal	5b22 <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	797030ef          	jal	56d4 <exit>
      fork();
    1742:	78b030ef          	jal	56cc <fork>
      fork();
    1746:	787030ef          	jal	56cc <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	789030ef          	jal	56d4 <exit>

0000000000001750 <createdelete>:
{
    1750:	7135                	addi	sp,sp,-160
    1752:	ed06                	sd	ra,152(sp)
    1754:	e922                	sd	s0,144(sp)
    1756:	e526                	sd	s1,136(sp)
    1758:	e14a                	sd	s2,128(sp)
    175a:	fcce                	sd	s3,120(sp)
    175c:	f8d2                	sd	s4,112(sp)
    175e:	f4d6                	sd	s5,104(sp)
    1760:	f0da                	sd	s6,96(sp)
    1762:	ecde                	sd	s7,88(sp)
    1764:	e8e2                	sd	s8,80(sp)
    1766:	e4e6                	sd	s9,72(sp)
    1768:	e0ea                	sd	s10,64(sp)
    176a:	fc6e                	sd	s11,56(sp)
    176c:	1100                	addi	s0,sp,160
    176e:	8daa                	mv	s11,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1770:	4901                	li	s2,0
    1772:	4991                	li	s3,4
    pid = fork();
    1774:	759030ef          	jal	56cc <fork>
    1778:	84aa                	mv	s1,a0
    if (pid < 0) {
    177a:	04054063          	bltz	a0,17ba <createdelete+0x6a>
    if (pid == 0) {
    177e:	c921                	beqz	a0,17ce <createdelete+0x7e>
  for (pi = 0; pi < NCHILD; pi++) {
    1780:	2905                	addiw	s2,s2,1
    1782:	ff3919e3          	bne	s2,s3,1774 <createdelete+0x24>
    1786:	4491                	li	s1,4
    wait(&xstatus);
    1788:	f6c40913          	addi	s2,s0,-148
    178c:	854a                	mv	a0,s2
    178e:	74f030ef          	jal	56dc <wait>
    if (xstatus != 0)
    1792:	f6c42a83          	lw	s5,-148(s0)
    1796:	0c0a9263          	bnez	s5,185a <createdelete+0x10a>
  for (pi = 0; pi < NCHILD; pi++) {
    179a:	34fd                	addiw	s1,s1,-1
    179c:	f8e5                	bnez	s1,178c <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    179e:	f6040923          	sb	zero,-142(s0)
    17a2:	03000913          	li	s2,48
    17a6:	5a7d                	li	s4,-1
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17a8:	4d25                	li	s10,9
    17aa:	07000c93          	li	s9,112
      fd = open(name, 0);
    17ae:	f7040c13          	addi	s8,s0,-144
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17b2:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    17b4:	07400b13          	li	s6,116
    17b8:	aa39                	j	18d6 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    17ba:	85ee                	mv	a1,s11
    17bc:	00005517          	auipc	a0,0x5
    17c0:	ddc50513          	addi	a0,a0,-548 # 6598 <malloc+0x9be>
    17c4:	35e040ef          	jal	5b22 <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	70b030ef          	jal	56d4 <exit>
      name[0] = 'p' + pi;
    17ce:	0709091b          	addiw	s2,s2,112
    17d2:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    17d6:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17da:	f7040913          	addi	s2,s0,-144
    17de:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17e2:	4a51                	li	s4,20
    17e4:	a815                	j	1818 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    17e6:	85ee                	mv	a1,s11
    17e8:	00005517          	auipc	a0,0x5
    17ec:	f2050513          	addi	a0,a0,-224 # 6708 <malloc+0xb2e>
    17f0:	332040ef          	jal	5b22 <printf>
          exit(1);
    17f4:	4505                	li	a0,1
    17f6:	6df030ef          	jal	56d4 <exit>
          name[1] = '0' + (i / 2);
    17fa:	01f4d79b          	srliw	a5,s1,0x1f
    17fe:	9fa5                	addw	a5,a5,s1
    1800:	4017d79b          	sraiw	a5,a5,0x1
    1804:	0307879b          	addiw	a5,a5,48
    1808:	f6f408a3          	sb	a5,-143(s0)
          if (unlink(name) < 0) {
    180c:	854a                	mv	a0,s2
    180e:	717030ef          	jal	5724 <unlink>
    1812:	02054a63          	bltz	a0,1846 <createdelete+0xf6>
      for (i = 0; i < N; i++) {
    1816:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1818:	0304879b          	addiw	a5,s1,48
    181c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1820:	85ce                	mv	a1,s3
    1822:	854a                	mv	a0,s2
    1824:	6f1030ef          	jal	5714 <open>
        if (fd < 0) {
    1828:	fa054fe3          	bltz	a0,17e6 <createdelete+0x96>
        close(fd);
    182c:	6d1030ef          	jal	56fc <close>
        if (i > 0 && (i % 2) == 0) {
    1830:	fe9053e3          	blez	s1,1816 <createdelete+0xc6>
    1834:	0014f793          	andi	a5,s1,1
    1838:	d3e9                	beqz	a5,17fa <createdelete+0xaa>
      for (i = 0; i < N; i++) {
    183a:	2485                	addiw	s1,s1,1
    183c:	fd449ee3          	bne	s1,s4,1818 <createdelete+0xc8>
      exit(0);
    1840:	4501                	li	a0,0
    1842:	693030ef          	jal	56d4 <exit>
            printf("%s: unlink failed\n", s);
    1846:	85ee                	mv	a1,s11
    1848:	00005517          	auipc	a0,0x5
    184c:	ed850513          	addi	a0,a0,-296 # 6720 <malloc+0xb46>
    1850:	2d2040ef          	jal	5b22 <printf>
            exit(1);
    1854:	4505                	li	a0,1
    1856:	67f030ef          	jal	56d4 <exit>
      exit(1);
    185a:	4505                	li	a0,1
    185c:	679030ef          	jal	56d4 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1860:	054bf263          	bgeu	s7,s4,18a4 <createdelete+0x154>
      if (fd >= 0)
    1864:	04055e63          	bgez	a0,18c0 <createdelete+0x170>
    for (pi = 0; pi < NCHILD; pi++) {
    1868:	2485                	addiw	s1,s1,1
    186a:	0ff4f493          	zext.b	s1,s1
    186e:	05648c63          	beq	s1,s6,18c6 <createdelete+0x176>
      name[0] = 'p' + pi;
    1872:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1876:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    187a:	4581                	li	a1,0
    187c:	8562                	mv	a0,s8
    187e:	697030ef          	jal	5714 <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1882:	01f5579b          	srliw	a5,a0,0x1f
    1886:	dfe9                	beqz	a5,1860 <createdelete+0x110>
    1888:	fc098ce3          	beqz	s3,1860 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    188c:	f7040613          	addi	a2,s0,-144
    1890:	85ee                	mv	a1,s11
    1892:	00005517          	auipc	a0,0x5
    1896:	ea650513          	addi	a0,a0,-346 # 6738 <malloc+0xb5e>
    189a:	288040ef          	jal	5b22 <printf>
        exit(1);
    189e:	4505                	li	a0,1
    18a0:	635030ef          	jal	56d4 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18a4:	fc0542e3          	bltz	a0,1868 <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    18a8:	f7040613          	addi	a2,s0,-144
    18ac:	85ee                	mv	a1,s11
    18ae:	00005517          	auipc	a0,0x5
    18b2:	eb250513          	addi	a0,a0,-334 # 6760 <malloc+0xb86>
    18b6:	26c040ef          	jal	5b22 <printf>
        exit(1);
    18ba:	4505                	li	a0,1
    18bc:	619030ef          	jal	56d4 <exit>
        close(fd);
    18c0:	63d030ef          	jal	56fc <close>
    18c4:	b755                	j	1868 <createdelete+0x118>
  for (i = 0; i < N; i++) {
    18c6:	2a85                	addiw	s5,s5,1
    18c8:	2a05                	addiw	s4,s4,1
    18ca:	2905                	addiw	s2,s2,1
    18cc:	0ff97913          	zext.b	s2,s2
    18d0:	47d1                	li	a5,20
    18d2:	00fa8a63          	beq	s5,a5,18e6 <createdelete+0x196>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18d6:	001ab993          	seqz	s3,s5
    18da:	015d27b3          	slt	a5,s10,s5
    18de:	00f9e9b3          	or	s3,s3,a5
    18e2:	84e6                	mv	s1,s9
    18e4:	b779                	j	1872 <createdelete+0x122>
    18e6:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18ea:	07000b13          	li	s6,112
      unlink(name);
    18ee:	f7040a13          	addi	s4,s0,-144
    for (pi = 0; pi < NCHILD; pi++) {
    18f2:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18f6:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18fa:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18fc:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1900:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1904:	8552                	mv	a0,s4
    1906:	61f030ef          	jal	5724 <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    190a:	2485                	addiw	s1,s1,1
    190c:	0ff4f493          	zext.b	s1,s1
    1910:	ff3496e3          	bne	s1,s3,18fc <createdelete+0x1ac>
  for (i = 0; i < N; i++) {
    1914:	2905                	addiw	s2,s2,1
    1916:	0ff97913          	zext.b	s2,s2
    191a:	ff5910e3          	bne	s2,s5,18fa <createdelete+0x1aa>
}
    191e:	60ea                	ld	ra,152(sp)
    1920:	644a                	ld	s0,144(sp)
    1922:	64aa                	ld	s1,136(sp)
    1924:	690a                	ld	s2,128(sp)
    1926:	79e6                	ld	s3,120(sp)
    1928:	7a46                	ld	s4,112(sp)
    192a:	7aa6                	ld	s5,104(sp)
    192c:	7b06                	ld	s6,96(sp)
    192e:	6be6                	ld	s7,88(sp)
    1930:	6c46                	ld	s8,80(sp)
    1932:	6ca6                	ld	s9,72(sp)
    1934:	6d06                	ld	s10,64(sp)
    1936:	7de2                	ld	s11,56(sp)
    1938:	610d                	addi	sp,sp,160
    193a:	8082                	ret

000000000000193c <linkunlink>:
{
    193c:	711d                	addi	sp,sp,-96
    193e:	ec86                	sd	ra,88(sp)
    1940:	e8a2                	sd	s0,80(sp)
    1942:	e4a6                	sd	s1,72(sp)
    1944:	e0ca                	sd	s2,64(sp)
    1946:	fc4e                	sd	s3,56(sp)
    1948:	f852                	sd	s4,48(sp)
    194a:	f456                	sd	s5,40(sp)
    194c:	f05a                	sd	s6,32(sp)
    194e:	ec5e                	sd	s7,24(sp)
    1950:	e862                	sd	s8,16(sp)
    1952:	e466                	sd	s9,8(sp)
    1954:	e06a                	sd	s10,0(sp)
    1956:	1080                	addi	s0,sp,96
    1958:	84aa                	mv	s1,a0
  unlink("x");
    195a:	00004517          	auipc	a0,0x4
    195e:	41e50513          	addi	a0,a0,1054 # 5d78 <malloc+0x19e>
    1962:	5c3030ef          	jal	5724 <unlink>
  pid = fork();
    1966:	567030ef          	jal	56cc <fork>
  if (pid < 0) {
    196a:	04054363          	bltz	a0,19b0 <linkunlink+0x74>
    196e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1970:	06100913          	li	s2,97
    1974:	c111                	beqz	a0,1978 <linkunlink+0x3c>
    1976:	4905                	li	s2,1
    1978:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    197c:	41c65ab7          	lui	s5,0x41c65
    1980:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c54185>
    1984:	6a0d                	lui	s4,0x3
    1986:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4af>
    if ((x % 3) == 0) {
    198a:	000ab9b7          	lui	s3,0xab
    198e:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99dc3>
    1992:	09b2                	slli	s3,s3,0xc
    1994:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    1998:	4b85                	li	s7,1
      unlink("x");
    199a:	00004b17          	auipc	s6,0x4
    199e:	3deb0b13          	addi	s6,s6,990 # 5d78 <malloc+0x19e>
      link("cat", "x");
    19a2:	00005c97          	auipc	s9,0x5
    19a6:	de6c8c93          	addi	s9,s9,-538 # 6788 <malloc+0xbae>
      close(open("x", O_RDWR | O_CREATE));
    19aa:	20200c13          	li	s8,514
    19ae:	a03d                	j	19dc <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    19b0:	85a6                	mv	a1,s1
    19b2:	00005517          	auipc	a0,0x5
    19b6:	be650513          	addi	a0,a0,-1050 # 6598 <malloc+0x9be>
    19ba:	168040ef          	jal	5b22 <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	515030ef          	jal	56d4 <exit>
      close(open("x", O_RDWR | O_CREATE));
    19c4:	85e2                	mv	a1,s8
    19c6:	855a                	mv	a0,s6
    19c8:	54d030ef          	jal	5714 <open>
    19cc:	531030ef          	jal	56fc <close>
    19d0:	a021                	j	19d8 <linkunlink+0x9c>
      unlink("x");
    19d2:	855a                	mv	a0,s6
    19d4:	551030ef          	jal	5724 <unlink>
  for (i = 0; i < 100; i++) {
    19d8:	34fd                	addiw	s1,s1,-1
    19da:	c885                	beqz	s1,1a0a <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    19dc:	035907bb          	mulw	a5,s2,s5
    19e0:	00fa07bb          	addw	a5,s4,a5
    19e4:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19e6:	02079713          	slli	a4,a5,0x20
    19ea:	9301                	srli	a4,a4,0x20
    19ec:	03370733          	mul	a4,a4,s3
    19f0:	9305                	srli	a4,a4,0x21
    19f2:	0017169b          	slliw	a3,a4,0x1
    19f6:	9f35                	addw	a4,a4,a3
    19f8:	9f99                	subw	a5,a5,a4
    19fa:	d7e9                	beqz	a5,19c4 <linkunlink+0x88>
    } else if ((x % 3) == 1) {
    19fc:	fd779be3          	bne	a5,s7,19d2 <linkunlink+0x96>
      link("cat", "x");
    1a00:	85da                	mv	a1,s6
    1a02:	8566                	mv	a0,s9
    1a04:	531030ef          	jal	5734 <link>
    1a08:	bfc1                	j	19d8 <linkunlink+0x9c>
  if (pid)
    1a0a:	020d0363          	beqz	s10,1a30 <linkunlink+0xf4>
    wait(0);
    1a0e:	4501                	li	a0,0
    1a10:	4cd030ef          	jal	56dc <wait>
}
    1a14:	60e6                	ld	ra,88(sp)
    1a16:	6446                	ld	s0,80(sp)
    1a18:	64a6                	ld	s1,72(sp)
    1a1a:	6906                	ld	s2,64(sp)
    1a1c:	79e2                	ld	s3,56(sp)
    1a1e:	7a42                	ld	s4,48(sp)
    1a20:	7aa2                	ld	s5,40(sp)
    1a22:	7b02                	ld	s6,32(sp)
    1a24:	6be2                	ld	s7,24(sp)
    1a26:	6c42                	ld	s8,16(sp)
    1a28:	6ca2                	ld	s9,8(sp)
    1a2a:	6d02                	ld	s10,0(sp)
    1a2c:	6125                	addi	sp,sp,96
    1a2e:	8082                	ret
    exit(0);
    1a30:	4501                	li	a0,0
    1a32:	4a3030ef          	jal	56d4 <exit>

0000000000001a36 <forktest>:
{
    1a36:	7179                	addi	sp,sp,-48
    1a38:	f406                	sd	ra,40(sp)
    1a3a:	f022                	sd	s0,32(sp)
    1a3c:	ec26                	sd	s1,24(sp)
    1a3e:	e84a                	sd	s2,16(sp)
    1a40:	e44e                	sd	s3,8(sp)
    1a42:	1800                	addi	s0,sp,48
    1a44:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a46:	4481                	li	s1,0
    1a48:	3e800913          	li	s2,1000
    pid = fork();
    1a4c:	481030ef          	jal	56cc <fork>
    if (pid < 0)
    1a50:	06054063          	bltz	a0,1ab0 <forktest+0x7a>
    if (pid == 0)
    1a54:	cd11                	beqz	a0,1a70 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a56:	2485                	addiw	s1,s1,1
    1a58:	ff249ae3          	bne	s1,s2,1a4c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a5c:	85ce                	mv	a1,s3
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	d7a50513          	addi	a0,a0,-646 # 67d8 <malloc+0xbfe>
    1a66:	0bc040ef          	jal	5b22 <printf>
    exit(1);
    1a6a:	4505                	li	a0,1
    1a6c:	469030ef          	jal	56d4 <exit>
      exit(0);
    1a70:	465030ef          	jal	56d4 <exit>
    printf("%s: no fork at all!\n", s);
    1a74:	85ce                	mv	a1,s3
    1a76:	00005517          	auipc	a0,0x5
    1a7a:	d1a50513          	addi	a0,a0,-742 # 6790 <malloc+0xbb6>
    1a7e:	0a4040ef          	jal	5b22 <printf>
    exit(1);
    1a82:	4505                	li	a0,1
    1a84:	451030ef          	jal	56d4 <exit>
      printf("%s: wait stopped early\n", s);
    1a88:	85ce                	mv	a1,s3
    1a8a:	00005517          	auipc	a0,0x5
    1a8e:	d1e50513          	addi	a0,a0,-738 # 67a8 <malloc+0xbce>
    1a92:	090040ef          	jal	5b22 <printf>
      exit(1);
    1a96:	4505                	li	a0,1
    1a98:	43d030ef          	jal	56d4 <exit>
    printf("%s: wait got too many\n", s);
    1a9c:	85ce                	mv	a1,s3
    1a9e:	00005517          	auipc	a0,0x5
    1aa2:	d2250513          	addi	a0,a0,-734 # 67c0 <malloc+0xbe6>
    1aa6:	07c040ef          	jal	5b22 <printf>
    exit(1);
    1aaa:	4505                	li	a0,1
    1aac:	429030ef          	jal	56d4 <exit>
  if (n == 0) {
    1ab0:	d0f1                	beqz	s1,1a74 <forktest+0x3e>
  for (; n > 0; n--) {
    1ab2:	00905963          	blez	s1,1ac4 <forktest+0x8e>
    if (wait(0) < 0) {
    1ab6:	4501                	li	a0,0
    1ab8:	425030ef          	jal	56dc <wait>
    1abc:	fc0546e3          	bltz	a0,1a88 <forktest+0x52>
  for (; n > 0; n--) {
    1ac0:	34fd                	addiw	s1,s1,-1
    1ac2:	f8f5                	bnez	s1,1ab6 <forktest+0x80>
  if (wait(0) != -1) {
    1ac4:	4501                	li	a0,0
    1ac6:	417030ef          	jal	56dc <wait>
    1aca:	57fd                	li	a5,-1
    1acc:	fcf518e3          	bne	a0,a5,1a9c <forktest+0x66>
}
    1ad0:	70a2                	ld	ra,40(sp)
    1ad2:	7402                	ld	s0,32(sp)
    1ad4:	64e2                	ld	s1,24(sp)
    1ad6:	6942                	ld	s2,16(sp)
    1ad8:	69a2                	ld	s3,8(sp)
    1ada:	6145                	addi	sp,sp,48
    1adc:	8082                	ret

0000000000001ade <kernmem>:
{
    1ade:	715d                	addi	sp,sp,-80
    1ae0:	e486                	sd	ra,72(sp)
    1ae2:	e0a2                	sd	s0,64(sp)
    1ae4:	fc26                	sd	s1,56(sp)
    1ae6:	f84a                	sd	s2,48(sp)
    1ae8:	f44e                	sd	s3,40(sp)
    1aea:	f052                	sd	s4,32(sp)
    1aec:	ec56                	sd	s5,24(sp)
    1aee:	e85a                	sd	s6,16(sp)
    1af0:	0880                	addi	s0,sp,80
    1af2:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1af4:	4485                	li	s1,1
    1af6:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1af8:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1afc:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1afe:	69b1                	lui	s3,0xc
    1b00:	35098993          	addi	s3,s3,848 # c350 <uninit+0xd78>
    1b04:	1003d937          	lui	s2,0x1003d
    1b08:	090e                	slli	s2,s2,0x3
    1b0a:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c798>
    pid = fork();
    1b0e:	3bf030ef          	jal	56cc <fork>
    if (pid < 0) {
    1b12:	02054763          	bltz	a0,1b40 <kernmem+0x62>
    if (pid == 0) {
    1b16:	cd1d                	beqz	a0,1b54 <kernmem+0x76>
    wait(&xstatus);
    1b18:	8556                	mv	a0,s5
    1b1a:	3c3030ef          	jal	56dc <wait>
    if (xstatus != -1) // did kernel kill child?
    1b1e:	fbc42783          	lw	a5,-68(s0)
    1b22:	05479663          	bne	a5,s4,1b6e <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b26:	94ce                	add	s1,s1,s3
    1b28:	ff2493e3          	bne	s1,s2,1b0e <kernmem+0x30>
}
    1b2c:	60a6                	ld	ra,72(sp)
    1b2e:	6406                	ld	s0,64(sp)
    1b30:	74e2                	ld	s1,56(sp)
    1b32:	7942                	ld	s2,48(sp)
    1b34:	79a2                	ld	s3,40(sp)
    1b36:	7a02                	ld	s4,32(sp)
    1b38:	6ae2                	ld	s5,24(sp)
    1b3a:	6b42                	ld	s6,16(sp)
    1b3c:	6161                	addi	sp,sp,80
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85da                	mv	a1,s6
    1b42:	00005517          	auipc	a0,0x5
    1b46:	a5650513          	addi	a0,a0,-1450 # 6598 <malloc+0x9be>
    1b4a:	7d9030ef          	jal	5b22 <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	385030ef          	jal	56d4 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b54:	0004c683          	lbu	a3,0(s1)
    1b58:	8626                	mv	a2,s1
    1b5a:	85da                	mv	a1,s6
    1b5c:	00005517          	auipc	a0,0x5
    1b60:	ca450513          	addi	a0,a0,-860 # 6800 <malloc+0xc26>
    1b64:	7bf030ef          	jal	5b22 <printf>
      exit(1);
    1b68:	4505                	li	a0,1
    1b6a:	36b030ef          	jal	56d4 <exit>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	365030ef          	jal	56d4 <exit>

0000000000001b74 <MAXVAplus>:
{
    1b74:	7139                	addi	sp,sp,-64
    1b76:	fc06                	sd	ra,56(sp)
    1b78:	f822                	sd	s0,48(sp)
    1b7a:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b7c:	4785                	li	a5,1
    1b7e:	179a                	slli	a5,a5,0x26
    1b80:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b84:	fc843783          	ld	a5,-56(s0)
    1b88:	cf9d                	beqz	a5,1bc6 <MAXVAplus+0x52>
    1b8a:	f426                	sd	s1,40(sp)
    1b8c:	f04a                	sd	s2,32(sp)
    1b8e:	ec4e                	sd	s3,24(sp)
    1b90:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b92:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b96:	54fd                	li	s1,-1
    pid = fork();
    1b98:	335030ef          	jal	56cc <fork>
    if (pid < 0) {
    1b9c:	02054963          	bltz	a0,1bce <MAXVAplus+0x5a>
    if (pid == 0) {
    1ba0:	c129                	beqz	a0,1be2 <MAXVAplus+0x6e>
    wait(&xstatus);
    1ba2:	854a                	mv	a0,s2
    1ba4:	339030ef          	jal	56dc <wait>
    if (xstatus != -1) // did kernel kill child?
    1ba8:	fc442783          	lw	a5,-60(s0)
    1bac:	04979d63          	bne	a5,s1,1c06 <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1bb0:	fc843783          	ld	a5,-56(s0)
    1bb4:	0786                	slli	a5,a5,0x1
    1bb6:	fcf43423          	sd	a5,-56(s0)
    1bba:	fc843783          	ld	a5,-56(s0)
    1bbe:	ffe9                	bnez	a5,1b98 <MAXVAplus+0x24>
    1bc0:	74a2                	ld	s1,40(sp)
    1bc2:	7902                	ld	s2,32(sp)
    1bc4:	69e2                	ld	s3,24(sp)
}
    1bc6:	70e2                	ld	ra,56(sp)
    1bc8:	7442                	ld	s0,48(sp)
    1bca:	6121                	addi	sp,sp,64
    1bcc:	8082                	ret
      printf("%s: fork failed\n", s);
    1bce:	85ce                	mv	a1,s3
    1bd0:	00005517          	auipc	a0,0x5
    1bd4:	9c850513          	addi	a0,a0,-1592 # 6598 <malloc+0x9be>
    1bd8:	74b030ef          	jal	5b22 <printf>
      exit(1);
    1bdc:	4505                	li	a0,1
    1bde:	2f7030ef          	jal	56d4 <exit>
      *(char *)a = 99;
    1be2:	fc843783          	ld	a5,-56(s0)
    1be6:	06300713          	li	a4,99
    1bea:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bee:	fc843603          	ld	a2,-56(s0)
    1bf2:	85ce                	mv	a1,s3
    1bf4:	00005517          	auipc	a0,0x5
    1bf8:	c2c50513          	addi	a0,a0,-980 # 6820 <malloc+0xc46>
    1bfc:	727030ef          	jal	5b22 <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	2d3030ef          	jal	56d4 <exit>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	2cd030ef          	jal	56d4 <exit>

0000000000001c0c <stacktest>:
{
    1c0c:	7179                	addi	sp,sp,-48
    1c0e:	f406                	sd	ra,40(sp)
    1c10:	f022                	sd	s0,32(sp)
    1c12:	ec26                	sd	s1,24(sp)
    1c14:	1800                	addi	s0,sp,48
    1c16:	84aa                	mv	s1,a0
  pid = fork();
    1c18:	2b5030ef          	jal	56cc <fork>
  if (pid == 0) {
    1c1c:	cd11                	beqz	a0,1c38 <stacktest+0x2c>
  } else if (pid < 0) {
    1c1e:	02054c63          	bltz	a0,1c56 <stacktest+0x4a>
  wait(&xstatus);
    1c22:	fdc40513          	addi	a0,s0,-36
    1c26:	2b7030ef          	jal	56dc <wait>
  if (xstatus == -1) // kernel killed child?
    1c2a:	fdc42503          	lw	a0,-36(s0)
    1c2e:	57fd                	li	a5,-1
    1c30:	02f50d63          	beq	a0,a5,1c6a <stacktest+0x5e>
    exit(xstatus);
    1c34:	2a1030ef          	jal	56d4 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c38:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c3a:	80078793          	addi	a5,a5,-2048
    1c3e:	8007c603          	lbu	a2,-2048(a5)
    1c42:	85a6                	mv	a1,s1
    1c44:	00005517          	auipc	a0,0x5
    1c48:	bf450513          	addi	a0,a0,-1036 # 6838 <malloc+0xc5e>
    1c4c:	6d7030ef          	jal	5b22 <printf>
    exit(1);
    1c50:	4505                	li	a0,1
    1c52:	283030ef          	jal	56d4 <exit>
    printf("%s: fork failed\n", s);
    1c56:	85a6                	mv	a1,s1
    1c58:	00005517          	auipc	a0,0x5
    1c5c:	94050513          	addi	a0,a0,-1728 # 6598 <malloc+0x9be>
    1c60:	6c3030ef          	jal	5b22 <printf>
    exit(1);
    1c64:	4505                	li	a0,1
    1c66:	26f030ef          	jal	56d4 <exit>
    exit(0);
    1c6a:	4501                	li	a0,0
    1c6c:	269030ef          	jal	56d4 <exit>

0000000000001c70 <nowrite>:
{
    1c70:	7159                	addi	sp,sp,-112
    1c72:	f486                	sd	ra,104(sp)
    1c74:	f0a2                	sd	s0,96(sp)
    1c76:	eca6                	sd	s1,88(sp)
    1c78:	e8ca                	sd	s2,80(sp)
    1c7a:	e4ce                	sd	s3,72(sp)
    1c7c:	e0d2                	sd	s4,64(sp)
    1c7e:	1880                	addi	s0,sp,112
    1c80:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c82:	00007797          	auipc	a5,0x7
    1c86:	93e78793          	addi	a5,a5,-1730 # 85c0 <malloc+0x29e6>
    1c8a:	7788                	ld	a0,40(a5)
    1c8c:	7b8c                	ld	a1,48(a5)
    1c8e:	7f90                	ld	a2,56(a5)
    1c90:	63b4                	ld	a3,64(a5)
    1c92:	67b8                	ld	a4,72(a5)
    1c94:	f8a43c23          	sd	a0,-104(s0)
    1c98:	fab43023          	sd	a1,-96(s0)
    1c9c:	fac43423          	sd	a2,-88(s0)
    1ca0:	fad43823          	sd	a3,-80(s0)
    1ca4:	fae43c23          	sd	a4,-72(s0)
    1ca8:	6bbc                	ld	a5,80(a5)
    1caa:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cae:	4481                	li	s1,0
    wait(&xstatus);
    1cb0:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cb4:	4999                	li	s3,6
    pid = fork();
    1cb6:	217030ef          	jal	56cc <fork>
    if (pid == 0) {
    1cba:	cd19                	beqz	a0,1cd8 <nowrite+0x68>
    } else if (pid < 0) {
    1cbc:	04054163          	bltz	a0,1cfe <nowrite+0x8e>
    wait(&xstatus);
    1cc0:	854a                	mv	a0,s2
    1cc2:	21b030ef          	jal	56dc <wait>
    if (xstatus == 0) {
    1cc6:	fcc42783          	lw	a5,-52(s0)
    1cca:	c7a1                	beqz	a5,1d12 <nowrite+0xa2>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1ccc:	2485                	addiw	s1,s1,1
    1cce:	ff3494e3          	bne	s1,s3,1cb6 <nowrite+0x46>
  exit(0);
    1cd2:	4501                	li	a0,0
    1cd4:	201030ef          	jal	56d4 <exit>
      volatile int *addr = (int *)addrs[ai];
    1cd8:	048e                	slli	s1,s1,0x3
    1cda:	fd048793          	addi	a5,s1,-48
    1cde:	008784b3          	add	s1,a5,s0
    1ce2:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1ce6:	47a9                	li	a5,10
    1ce8:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cea:	85d2                	mv	a1,s4
    1cec:	00005517          	auipc	a0,0x5
    1cf0:	b7450513          	addi	a0,a0,-1164 # 6860 <malloc+0xc86>
    1cf4:	62f030ef          	jal	5b22 <printf>
      exit(0);
    1cf8:	4501                	li	a0,0
    1cfa:	1db030ef          	jal	56d4 <exit>
      printf("%s: fork failed\n", s);
    1cfe:	85d2                	mv	a1,s4
    1d00:	00005517          	auipc	a0,0x5
    1d04:	89850513          	addi	a0,a0,-1896 # 6598 <malloc+0x9be>
    1d08:	61b030ef          	jal	5b22 <printf>
      exit(1);
    1d0c:	4505                	li	a0,1
    1d0e:	1c7030ef          	jal	56d4 <exit>
      exit(1);
    1d12:	4505                	li	a0,1
    1d14:	1c1030ef          	jal	56d4 <exit>

0000000000001d18 <manywrites>:
{
    1d18:	7159                	addi	sp,sp,-112
    1d1a:	f486                	sd	ra,104(sp)
    1d1c:	f0a2                	sd	s0,96(sp)
    1d1e:	eca6                	sd	s1,88(sp)
    1d20:	e8ca                	sd	s2,80(sp)
    1d22:	e4ce                	sd	s3,72(sp)
    1d24:	ec66                	sd	s9,24(sp)
    1d26:	1880                	addi	s0,sp,112
    1d28:	8caa                	mv	s9,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d2a:	4901                	li	s2,0
    1d2c:	4991                	li	s3,4
    int pid = fork();
    1d2e:	19f030ef          	jal	56cc <fork>
    1d32:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d34:	02054c63          	bltz	a0,1d6c <manywrites+0x54>
    if (pid == 0) {
    1d38:	c929                	beqz	a0,1d8a <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    1d3a:	2905                	addiw	s2,s2,1
    1d3c:	ff3919e3          	bne	s2,s3,1d2e <manywrites+0x16>
    1d40:	4491                	li	s1,4
    wait(&st);
    1d42:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d46:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d4a:	854a                	mv	a0,s2
    1d4c:	191030ef          	jal	56dc <wait>
    if (st != 0)
    1d50:	f9842503          	lw	a0,-104(s0)
    1d54:	0e051763          	bnez	a0,1e42 <manywrites+0x12a>
  for (int ci = 0; ci < nchildren; ci++) {
    1d58:	34fd                	addiw	s1,s1,-1
    1d5a:	f4f5                	bnez	s1,1d46 <manywrites+0x2e>
    1d5c:	e0d2                	sd	s4,64(sp)
    1d5e:	fc56                	sd	s5,56(sp)
    1d60:	f85a                	sd	s6,48(sp)
    1d62:	f45e                	sd	s7,40(sp)
    1d64:	f062                	sd	s8,32(sp)
    1d66:	e86a                	sd	s10,16(sp)
  exit(0);
    1d68:	16d030ef          	jal	56d4 <exit>
    1d6c:	e0d2                	sd	s4,64(sp)
    1d6e:	fc56                	sd	s5,56(sp)
    1d70:	f85a                	sd	s6,48(sp)
    1d72:	f45e                	sd	s7,40(sp)
    1d74:	f062                	sd	s8,32(sp)
    1d76:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d78:	00006517          	auipc	a0,0x6
    1d7c:	ee050513          	addi	a0,a0,-288 # 7c58 <malloc+0x207e>
    1d80:	5a3030ef          	jal	5b22 <printf>
      exit(1);
    1d84:	4505                	li	a0,1
    1d86:	14f030ef          	jal	56d4 <exit>
    1d8a:	e0d2                	sd	s4,64(sp)
    1d8c:	fc56                	sd	s5,56(sp)
    1d8e:	f85a                	sd	s6,48(sp)
    1d90:	f45e                	sd	s7,40(sp)
    1d92:	f062                	sd	s8,32(sp)
    1d94:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d96:	06200793          	li	a5,98
    1d9a:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1d9e:	0619079b          	addiw	a5,s2,97
    1da2:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1da6:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1daa:	f9840513          	addi	a0,s0,-104
    1dae:	177030ef          	jal	5724 <unlink>
    1db2:	47f9                	li	a5,30
    1db4:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1db6:	f9840b93          	addi	s7,s0,-104
    1dba:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1dbe:	6a8d                	lui	s5,0x3
    1dc0:	0000cc17          	auipc	s8,0xc
    1dc4:	f28c0c13          	addi	s8,s8,-216 # dce8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1dc8:	8a26                	mv	s4,s1
    1dca:	02094563          	bltz	s2,1df4 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1dce:	85da                	mv	a1,s6
    1dd0:	855e                	mv	a0,s7
    1dd2:	143030ef          	jal	5714 <open>
    1dd6:	89aa                	mv	s3,a0
          if (fd < 0) {
    1dd8:	02054d63          	bltz	a0,1e12 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1ddc:	8656                	mv	a2,s5
    1dde:	85e2                	mv	a1,s8
    1de0:	115030ef          	jal	56f4 <write>
          if (cc != sz) {
    1de4:	05551363          	bne	a0,s5,1e2a <manywrites+0x112>
          close(fd);
    1de8:	854e                	mv	a0,s3
    1dea:	113030ef          	jal	56fc <close>
        for (int i = 0; i < ci + 1; i++) {
    1dee:	2a05                	addiw	s4,s4,1
    1df0:	fd495fe3          	bge	s2,s4,1dce <manywrites+0xb6>
        unlink(name);
    1df4:	f9840513          	addi	a0,s0,-104
    1df8:	12d030ef          	jal	5724 <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1dfc:	fffd079b          	addiw	a5,s10,-1
    1e00:	8d3e                	mv	s10,a5
    1e02:	f3f9                	bnez	a5,1dc8 <manywrites+0xb0>
      unlink(name);
    1e04:	f9840513          	addi	a0,s0,-104
    1e08:	11d030ef          	jal	5724 <unlink>
      exit(0);
    1e0c:	4501                	li	a0,0
    1e0e:	0c7030ef          	jal	56d4 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e12:	f9840613          	addi	a2,s0,-104
    1e16:	85e6                	mv	a1,s9
    1e18:	00005517          	auipc	a0,0x5
    1e1c:	a6850513          	addi	a0,a0,-1432 # 6880 <malloc+0xca6>
    1e20:	503030ef          	jal	5b22 <printf>
            exit(1);
    1e24:	4505                	li	a0,1
    1e26:	0af030ef          	jal	56d4 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e2a:	86aa                	mv	a3,a0
    1e2c:	660d                	lui	a2,0x3
    1e2e:	85e6                	mv	a1,s9
    1e30:	00004517          	auipc	a0,0x4
    1e34:	fa850513          	addi	a0,a0,-88 # 5dd8 <malloc+0x1fe>
    1e38:	4eb030ef          	jal	5b22 <printf>
            exit(1);
    1e3c:	4505                	li	a0,1
    1e3e:	097030ef          	jal	56d4 <exit>
    1e42:	e0d2                	sd	s4,64(sp)
    1e44:	fc56                	sd	s5,56(sp)
    1e46:	f85a                	sd	s6,48(sp)
    1e48:	f45e                	sd	s7,40(sp)
    1e4a:	f062                	sd	s8,32(sp)
    1e4c:	e86a                	sd	s10,16(sp)
      exit(st);
    1e4e:	087030ef          	jal	56d4 <exit>

0000000000001e52 <copyinstr3>:
{
    1e52:	7179                	addi	sp,sp,-48
    1e54:	f406                	sd	ra,40(sp)
    1e56:	f022                	sd	s0,32(sp)
    1e58:	ec26                	sd	s1,24(sp)
    1e5a:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e5c:	6509                	lui	a0,0x2
    1e5e:	043030ef          	jal	56a0 <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e62:	4501                	li	a0,0
    1e64:	03d030ef          	jal	56a0 <sbrk>
  if ((top % PGSIZE) != 0) {
    1e68:	03451793          	slli	a5,a0,0x34
    1e6c:	e7bd                	bnez	a5,1eda <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e6e:	4501                	li	a0,0
    1e70:	031030ef          	jal	56a0 <sbrk>
  if (top % PGSIZE) {
    1e74:	03451793          	slli	a5,a0,0x34
    1e78:	ebad                	bnez	a5,1eea <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1e7a:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xa9>
  *b = 'x';
    1e7e:	07800793          	li	a5,120
    1e82:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e86:	8526                	mv	a0,s1
    1e88:	09d030ef          	jal	5724 <unlink>
  if (ret != -1) {
    1e8c:	57fd                	li	a5,-1
    1e8e:	06f51763          	bne	a0,a5,1efc <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e92:	20100593          	li	a1,513
    1e96:	8526                	mv	a0,s1
    1e98:	07d030ef          	jal	5714 <open>
  if (fd != -1) {
    1e9c:	57fd                	li	a5,-1
    1e9e:	06f51a63          	bne	a0,a5,1f12 <copyinstr3+0xc0>
  ret = link(b, b);
    1ea2:	85a6                	mv	a1,s1
    1ea4:	8526                	mv	a0,s1
    1ea6:	08f030ef          	jal	5734 <link>
  if (ret != -1) {
    1eaa:	57fd                	li	a5,-1
    1eac:	06f51e63          	bne	a0,a5,1f28 <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1eb0:	00005797          	auipc	a5,0x5
    1eb4:	6d078793          	addi	a5,a5,1744 # 7580 <malloc+0x19a6>
    1eb8:	fcf43823          	sd	a5,-48(s0)
    1ebc:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1ec0:	fd040593          	addi	a1,s0,-48
    1ec4:	8526                	mv	a0,s1
    1ec6:	047030ef          	jal	570c <exec>
  if (ret != -1) {
    1eca:	57fd                	li	a5,-1
    1ecc:	06f51a63          	bne	a0,a5,1f40 <copyinstr3+0xee>
}
    1ed0:	70a2                	ld	ra,40(sp)
    1ed2:	7402                	ld	s0,32(sp)
    1ed4:	64e2                	ld	s1,24(sp)
    1ed6:	6145                	addi	sp,sp,48
    1ed8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1eda:	0347d513          	srli	a0,a5,0x34
    1ede:	6785                	lui	a5,0x1
    1ee0:	40a7853b          	subw	a0,a5,a0
    1ee4:	7bc030ef          	jal	56a0 <sbrk>
    1ee8:	b759                	j	1e6e <copyinstr3+0x1c>
    printf("oops\n");
    1eea:	00005517          	auipc	a0,0x5
    1eee:	9ae50513          	addi	a0,a0,-1618 # 6898 <malloc+0xcbe>
    1ef2:	431030ef          	jal	5b22 <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	7dc030ef          	jal	56d4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1efc:	862a                	mv	a2,a0
    1efe:	85a6                	mv	a1,s1
    1f00:	00004517          	auipc	a0,0x4
    1f04:	5b850513          	addi	a0,a0,1464 # 64b8 <malloc+0x8de>
    1f08:	41b030ef          	jal	5b22 <printf>
    exit(1);
    1f0c:	4505                	li	a0,1
    1f0e:	7c6030ef          	jal	56d4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f12:	862a                	mv	a2,a0
    1f14:	85a6                	mv	a1,s1
    1f16:	00004517          	auipc	a0,0x4
    1f1a:	5c250513          	addi	a0,a0,1474 # 64d8 <malloc+0x8fe>
    1f1e:	405030ef          	jal	5b22 <printf>
    exit(1);
    1f22:	4505                	li	a0,1
    1f24:	7b0030ef          	jal	56d4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f28:	86aa                	mv	a3,a0
    1f2a:	8626                	mv	a2,s1
    1f2c:	85a6                	mv	a1,s1
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	5ca50513          	addi	a0,a0,1482 # 64f8 <malloc+0x91e>
    1f36:	3ed030ef          	jal	5b22 <printf>
    exit(1);
    1f3a:	4505                	li	a0,1
    1f3c:	798030ef          	jal	56d4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f40:	863e                	mv	a2,a5
    1f42:	85a6                	mv	a1,s1
    1f44:	00004517          	auipc	a0,0x4
    1f48:	5dc50513          	addi	a0,a0,1500 # 6520 <malloc+0x946>
    1f4c:	3d7030ef          	jal	5b22 <printf>
    exit(1);
    1f50:	4505                	li	a0,1
    1f52:	782030ef          	jal	56d4 <exit>

0000000000001f56 <rwsbrk>:
{
    1f56:	1101                	addi	sp,sp,-32
    1f58:	ec06                	sd	ra,24(sp)
    1f5a:	e822                	sd	s0,16(sp)
    1f5c:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f5e:	6509                	lui	a0,0x2
    1f60:	740030ef          	jal	56a0 <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f64:	57fd                	li	a5,-1
    1f66:	04f50a63          	beq	a0,a5,1fba <rwsbrk+0x64>
    1f6a:	e426                	sd	s1,8(sp)
    1f6c:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f6e:	7579                	lui	a0,0xffffe
    1f70:	730030ef          	jal	56a0 <sbrk>
    1f74:	57fd                	li	a5,-1
    1f76:	04f50d63          	beq	a0,a5,1fd0 <rwsbrk+0x7a>
    1f7a:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f7c:	20100593          	li	a1,513
    1f80:	00005517          	auipc	a0,0x5
    1f84:	95850513          	addi	a0,a0,-1704 # 68d8 <malloc+0xcfe>
    1f88:	78c030ef          	jal	5714 <open>
    1f8c:	892a                	mv	s2,a0
  if (fd < 0) {
    1f8e:	04054b63          	bltz	a0,1fe4 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f92:	6785                	lui	a5,0x1
    1f94:	94be                	add	s1,s1,a5
    1f96:	40000613          	li	a2,1024
    1f9a:	85a6                	mv	a1,s1
    1f9c:	758030ef          	jal	56f4 <write>
    1fa0:	862a                	mv	a2,a0
  if (n >= 0) {
    1fa2:	04054a63          	bltz	a0,1ff6 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1fa6:	85a6                	mv	a1,s1
    1fa8:	00005517          	auipc	a0,0x5
    1fac:	95050513          	addi	a0,a0,-1712 # 68f8 <malloc+0xd1e>
    1fb0:	373030ef          	jal	5b22 <printf>
    exit(1);
    1fb4:	4505                	li	a0,1
    1fb6:	71e030ef          	jal	56d4 <exit>
    1fba:	e426                	sd	s1,8(sp)
    1fbc:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1fbe:	00005517          	auipc	a0,0x5
    1fc2:	8e250513          	addi	a0,a0,-1822 # 68a0 <malloc+0xcc6>
    1fc6:	35d030ef          	jal	5b22 <printf>
    exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	708030ef          	jal	56d4 <exit>
    1fd0:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fd2:	00005517          	auipc	a0,0x5
    1fd6:	8e650513          	addi	a0,a0,-1818 # 68b8 <malloc+0xcde>
    1fda:	349030ef          	jal	5b22 <printf>
    exit(1);
    1fde:	4505                	li	a0,1
    1fe0:	6f4030ef          	jal	56d4 <exit>
    printf("open(rwsbrk) failed\n");
    1fe4:	00005517          	auipc	a0,0x5
    1fe8:	8fc50513          	addi	a0,a0,-1796 # 68e0 <malloc+0xd06>
    1fec:	337030ef          	jal	5b22 <printf>
    exit(1);
    1ff0:	4505                	li	a0,1
    1ff2:	6e2030ef          	jal	56d4 <exit>
  close(fd);
    1ff6:	854a                	mv	a0,s2
    1ff8:	704030ef          	jal	56fc <close>
  unlink("rwsbrk");
    1ffc:	00005517          	auipc	a0,0x5
    2000:	8dc50513          	addi	a0,a0,-1828 # 68d8 <malloc+0xcfe>
    2004:	720030ef          	jal	5724 <unlink>
  fd = open("README", O_RDONLY);
    2008:	4581                	li	a1,0
    200a:	00004517          	auipc	a0,0x4
    200e:	ed650513          	addi	a0,a0,-298 # 5ee0 <malloc+0x306>
    2012:	702030ef          	jal	5714 <open>
    2016:	892a                	mv	s2,a0
  if (fd < 0) {
    2018:	02054363          	bltz	a0,203e <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    201c:	4629                	li	a2,10
    201e:	85a6                	mv	a1,s1
    2020:	6cc030ef          	jal	56ec <read>
    2024:	862a                	mv	a2,a0
  if (n >= 0) {
    2026:	02054563          	bltz	a0,2050 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    202a:	85a6                	mv	a1,s1
    202c:	00005517          	auipc	a0,0x5
    2030:	8fc50513          	addi	a0,a0,-1796 # 6928 <malloc+0xd4e>
    2034:	2ef030ef          	jal	5b22 <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	69a030ef          	jal	56d4 <exit>
    printf("open(README) failed\n");
    203e:	00004517          	auipc	a0,0x4
    2042:	eaa50513          	addi	a0,a0,-342 # 5ee8 <malloc+0x30e>
    2046:	2dd030ef          	jal	5b22 <printf>
    exit(1);
    204a:	4505                	li	a0,1
    204c:	688030ef          	jal	56d4 <exit>
  close(fd);
    2050:	854a                	mv	a0,s2
    2052:	6aa030ef          	jal	56fc <close>
  exit(0);
    2056:	4501                	li	a0,0
    2058:	67c030ef          	jal	56d4 <exit>

000000000000205c <sbrkbasic>:
{
    205c:	715d                	addi	sp,sp,-80
    205e:	e486                	sd	ra,72(sp)
    2060:	e0a2                	sd	s0,64(sp)
    2062:	ec56                	sd	s5,24(sp)
    2064:	0880                	addi	s0,sp,80
    2066:	8aaa                	mv	s5,a0
  pid = fork();
    2068:	664030ef          	jal	56cc <fork>
  if (pid < 0) {
    206c:	02054c63          	bltz	a0,20a4 <sbrkbasic+0x48>
  if (pid == 0) {
    2070:	ed31                	bnez	a0,20cc <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    2072:	40000537          	lui	a0,0x40000
    2076:	62a030ef          	jal	56a0 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    207a:	57fd                	li	a5,-1
    207c:	04f50163          	beq	a0,a5,20be <sbrkbasic+0x62>
    2080:	fc26                	sd	s1,56(sp)
    2082:	f84a                	sd	s2,48(sp)
    2084:	f44e                	sd	s3,40(sp)
    2086:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2088:	400007b7          	lui	a5,0x40000
    208c:	97aa                	add	a5,a5,a0
      *b = 99;
    208e:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2092:	6705                	lui	a4,0x1
      *b = 99;
    2094:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef318>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2098:	953a                	add	a0,a0,a4
    209a:	fef51de3          	bne	a0,a5,2094 <sbrkbasic+0x38>
    exit(1);
    209e:	4505                	li	a0,1
    20a0:	634030ef          	jal	56d4 <exit>
    20a4:	fc26                	sd	s1,56(sp)
    20a6:	f84a                	sd	s2,48(sp)
    20a8:	f44e                	sd	s3,40(sp)
    20aa:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    20ac:	00005517          	auipc	a0,0x5
    20b0:	8a450513          	addi	a0,a0,-1884 # 6950 <malloc+0xd76>
    20b4:	26f030ef          	jal	5b22 <printf>
    exit(1);
    20b8:	4505                	li	a0,1
    20ba:	61a030ef          	jal	56d4 <exit>
    20be:	fc26                	sd	s1,56(sp)
    20c0:	f84a                	sd	s2,48(sp)
    20c2:	f44e                	sd	s3,40(sp)
    20c4:	f052                	sd	s4,32(sp)
      exit(0);
    20c6:	4501                	li	a0,0
    20c8:	60c030ef          	jal	56d4 <exit>
  wait(&xstatus);
    20cc:	fbc40513          	addi	a0,s0,-68
    20d0:	60c030ef          	jal	56dc <wait>
  if (xstatus == 1) {
    20d4:	fbc42703          	lw	a4,-68(s0)
    20d8:	4785                	li	a5,1
    20da:	02f70063          	beq	a4,a5,20fa <sbrkbasic+0x9e>
    20de:	fc26                	sd	s1,56(sp)
    20e0:	f84a                	sd	s2,48(sp)
    20e2:	f44e                	sd	s3,40(sp)
    20e4:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20e6:	4501                	li	a0,0
    20e8:	5b8030ef          	jal	56a0 <sbrk>
    20ec:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20ee:	4901                	li	s2,0
    b = sbrk(1);
    20f0:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20f2:	6a05                	lui	s4,0x1
    20f4:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    20f8:	a005                	j	2118 <sbrkbasic+0xbc>
    20fa:	fc26                	sd	s1,56(sp)
    20fc:	f84a                	sd	s2,48(sp)
    20fe:	f44e                	sd	s3,40(sp)
    2100:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2102:	85d6                	mv	a1,s5
    2104:	00005517          	auipc	a0,0x5
    2108:	86c50513          	addi	a0,a0,-1940 # 6970 <malloc+0xd96>
    210c:	217030ef          	jal	5b22 <printf>
    exit(1);
    2110:	4505                	li	a0,1
    2112:	5c2030ef          	jal	56d4 <exit>
    2116:	84be                	mv	s1,a5
    b = sbrk(1);
    2118:	854e                	mv	a0,s3
    211a:	586030ef          	jal	56a0 <sbrk>
    if (b != a) {
    211e:	04951163          	bne	a0,s1,2160 <sbrkbasic+0x104>
    *b = 1;
    2122:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2126:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    212a:	2905                	addiw	s2,s2,1
    212c:	ff4915e3          	bne	s2,s4,2116 <sbrkbasic+0xba>
  pid = fork();
    2130:	59c030ef          	jal	56cc <fork>
    2134:	892a                	mv	s2,a0
  if (pid < 0) {
    2136:	04054263          	bltz	a0,217a <sbrkbasic+0x11e>
  c = sbrk(1);
    213a:	4505                	li	a0,1
    213c:	564030ef          	jal	56a0 <sbrk>
  c = sbrk(1);
    2140:	4505                	li	a0,1
    2142:	55e030ef          	jal	56a0 <sbrk>
  if (c != a + 1) {
    2146:	0489                	addi	s1,s1,2
    2148:	04950363          	beq	a0,s1,218e <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    214c:	85d6                	mv	a1,s5
    214e:	00005517          	auipc	a0,0x5
    2152:	88250513          	addi	a0,a0,-1918 # 69d0 <malloc+0xdf6>
    2156:	1cd030ef          	jal	5b22 <printf>
    exit(1);
    215a:	4505                	li	a0,1
    215c:	578030ef          	jal	56d4 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2160:	872a                	mv	a4,a0
    2162:	86a6                	mv	a3,s1
    2164:	864a                	mv	a2,s2
    2166:	85d6                	mv	a1,s5
    2168:	00005517          	auipc	a0,0x5
    216c:	82850513          	addi	a0,a0,-2008 # 6990 <malloc+0xdb6>
    2170:	1b3030ef          	jal	5b22 <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	55e030ef          	jal	56d4 <exit>
    printf("%s: sbrk test fork failed\n", s);
    217a:	85d6                	mv	a1,s5
    217c:	00005517          	auipc	a0,0x5
    2180:	83450513          	addi	a0,a0,-1996 # 69b0 <malloc+0xdd6>
    2184:	19f030ef          	jal	5b22 <printf>
    exit(1);
    2188:	4505                	li	a0,1
    218a:	54a030ef          	jal	56d4 <exit>
  if (pid == 0)
    218e:	00091563          	bnez	s2,2198 <sbrkbasic+0x13c>
    exit(0);
    2192:	4501                	li	a0,0
    2194:	540030ef          	jal	56d4 <exit>
  wait(&xstatus);
    2198:	fbc40513          	addi	a0,s0,-68
    219c:	540030ef          	jal	56dc <wait>
  exit(xstatus);
    21a0:	fbc42503          	lw	a0,-68(s0)
    21a4:	530030ef          	jal	56d4 <exit>

00000000000021a8 <sbrkmuch>:
{
    21a8:	7179                	addi	sp,sp,-48
    21aa:	f406                	sd	ra,40(sp)
    21ac:	f022                	sd	s0,32(sp)
    21ae:	ec26                	sd	s1,24(sp)
    21b0:	e84a                	sd	s2,16(sp)
    21b2:	e44e                	sd	s3,8(sp)
    21b4:	e052                	sd	s4,0(sp)
    21b6:	1800                	addi	s0,sp,48
    21b8:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21ba:	4501                	li	a0,0
    21bc:	4e4030ef          	jal	56a0 <sbrk>
    21c0:	892a                	mv	s2,a0
  a = sbrk(0);
    21c2:	4501                	li	a0,0
    21c4:	4dc030ef          	jal	56a0 <sbrk>
    21c8:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21ca:	06400537          	lui	a0,0x6400
    21ce:	9d05                	subw	a0,a0,s1
    21d0:	4d0030ef          	jal	56a0 <sbrk>
  if (p != a) {
    21d4:	08a49963          	bne	s1,a0,2266 <sbrkmuch+0xbe>
  *lastaddr = 99;
    21d8:	064007b7          	lui	a5,0x6400
    21dc:	06300713          	li	a4,99
    21e0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef317>
  a = sbrk(0);
    21e4:	4501                	li	a0,0
    21e6:	4ba030ef          	jal	56a0 <sbrk>
    21ea:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21ec:	757d                	lui	a0,0xfffff
    21ee:	4b2030ef          	jal	56a0 <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21f2:	57fd                	li	a5,-1
    21f4:	08f50363          	beq	a0,a5,227a <sbrkmuch+0xd2>
  c = sbrk(0);
    21f8:	4501                	li	a0,0
    21fa:	4a6030ef          	jal	56a0 <sbrk>
  if (c != a - PGSIZE) {
    21fe:	80048793          	addi	a5,s1,-2048
    2202:	80078793          	addi	a5,a5,-2048
    2206:	08f51463          	bne	a0,a5,228e <sbrkmuch+0xe6>
  a = sbrk(0);
    220a:	4501                	li	a0,0
    220c:	494030ef          	jal	56a0 <sbrk>
    2210:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2212:	6505                	lui	a0,0x1
    2214:	48c030ef          	jal	56a0 <sbrk>
    2218:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    221a:	08a49663          	bne	s1,a0,22a6 <sbrkmuch+0xfe>
    221e:	4501                	li	a0,0
    2220:	480030ef          	jal	56a0 <sbrk>
    2224:	6785                	lui	a5,0x1
    2226:	97a6                	add	a5,a5,s1
    2228:	06f51f63          	bne	a0,a5,22a6 <sbrkmuch+0xfe>
  if (*lastaddr == 99) {
    222c:	064007b7          	lui	a5,0x6400
    2230:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef317>
    2234:	06300793          	li	a5,99
    2238:	08f70363          	beq	a4,a5,22be <sbrkmuch+0x116>
  a = sbrk(0);
    223c:	4501                	li	a0,0
    223e:	462030ef          	jal	56a0 <sbrk>
    2242:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2244:	4501                	li	a0,0
    2246:	45a030ef          	jal	56a0 <sbrk>
    224a:	40a9053b          	subw	a0,s2,a0
    224e:	452030ef          	jal	56a0 <sbrk>
  if (c != a) {
    2252:	08a49063          	bne	s1,a0,22d2 <sbrkmuch+0x12a>
}
    2256:	70a2                	ld	ra,40(sp)
    2258:	7402                	ld	s0,32(sp)
    225a:	64e2                	ld	s1,24(sp)
    225c:	6942                	ld	s2,16(sp)
    225e:	69a2                	ld	s3,8(sp)
    2260:	6a02                	ld	s4,0(sp)
    2262:	6145                	addi	sp,sp,48
    2264:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2266:	85ce                	mv	a1,s3
    2268:	00004517          	auipc	a0,0x4
    226c:	78850513          	addi	a0,a0,1928 # 69f0 <malloc+0xe16>
    2270:	0b3030ef          	jal	5b22 <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	45e030ef          	jal	56d4 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    227a:	85ce                	mv	a1,s3
    227c:	00004517          	auipc	a0,0x4
    2280:	7bc50513          	addi	a0,a0,1980 # 6a38 <malloc+0xe5e>
    2284:	09f030ef          	jal	5b22 <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	44a030ef          	jal	56d4 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    228e:	86aa                	mv	a3,a0
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00004517          	auipc	a0,0x4
    2298:	7c450513          	addi	a0,a0,1988 # 6a58 <malloc+0xe7e>
    229c:	087030ef          	jal	5b22 <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	432030ef          	jal	56d4 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22a6:	86d2                	mv	a3,s4
    22a8:	8626                	mv	a2,s1
    22aa:	85ce                	mv	a1,s3
    22ac:	00004517          	auipc	a0,0x4
    22b0:	7ec50513          	addi	a0,a0,2028 # 6a98 <malloc+0xebe>
    22b4:	06f030ef          	jal	5b22 <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	41a030ef          	jal	56d4 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22be:	85ce                	mv	a1,s3
    22c0:	00005517          	auipc	a0,0x5
    22c4:	80850513          	addi	a0,a0,-2040 # 6ac8 <malloc+0xeee>
    22c8:	05b030ef          	jal	5b22 <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	406030ef          	jal	56d4 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22d2:	86aa                	mv	a3,a0
    22d4:	8626                	mv	a2,s1
    22d6:	85ce                	mv	a1,s3
    22d8:	00005517          	auipc	a0,0x5
    22dc:	82850513          	addi	a0,a0,-2008 # 6b00 <malloc+0xf26>
    22e0:	043030ef          	jal	5b22 <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	3ee030ef          	jal	56d4 <exit>

00000000000022ea <sbrkarg>:
{
    22ea:	7179                	addi	sp,sp,-48
    22ec:	f406                	sd	ra,40(sp)
    22ee:	f022                	sd	s0,32(sp)
    22f0:	ec26                	sd	s1,24(sp)
    22f2:	e84a                	sd	s2,16(sp)
    22f4:	e44e                	sd	s3,8(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22fa:	6505                	lui	a0,0x1
    22fc:	3a4030ef          	jal	56a0 <sbrk>
    2300:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2302:	20100593          	li	a1,513
    2306:	00005517          	auipc	a0,0x5
    230a:	82250513          	addi	a0,a0,-2014 # 6b28 <malloc+0xf4e>
    230e:	406030ef          	jal	5714 <open>
    2312:	84aa                	mv	s1,a0
  unlink("sbrk");
    2314:	00005517          	auipc	a0,0x5
    2318:	81450513          	addi	a0,a0,-2028 # 6b28 <malloc+0xf4e>
    231c:	408030ef          	jal	5724 <unlink>
  if (fd < 0) {
    2320:	0204c963          	bltz	s1,2352 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2324:	6605                	lui	a2,0x1
    2326:	85ca                	mv	a1,s2
    2328:	8526                	mv	a0,s1
    232a:	3ca030ef          	jal	56f4 <write>
    232e:	02054c63          	bltz	a0,2366 <sbrkarg+0x7c>
  close(fd);
    2332:	8526                	mv	a0,s1
    2334:	3c8030ef          	jal	56fc <close>
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	366030ef          	jal	56a0 <sbrk>
  if (pipe((int *)a) != 0) {
    233e:	3a6030ef          	jal	56e4 <pipe>
    2342:	ed05                	bnez	a0,237a <sbrkarg+0x90>
}
    2344:	70a2                	ld	ra,40(sp)
    2346:	7402                	ld	s0,32(sp)
    2348:	64e2                	ld	s1,24(sp)
    234a:	6942                	ld	s2,16(sp)
    234c:	69a2                	ld	s3,8(sp)
    234e:	6145                	addi	sp,sp,48
    2350:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2352:	85ce                	mv	a1,s3
    2354:	00004517          	auipc	a0,0x4
    2358:	7dc50513          	addi	a0,a0,2012 # 6b30 <malloc+0xf56>
    235c:	7c6030ef          	jal	5b22 <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	372030ef          	jal	56d4 <exit>
    printf("%s: write sbrk failed\n", s);
    2366:	85ce                	mv	a1,s3
    2368:	00004517          	auipc	a0,0x4
    236c:	7e050513          	addi	a0,a0,2016 # 6b48 <malloc+0xf6e>
    2370:	7b2030ef          	jal	5b22 <printf>
    exit(1);
    2374:	4505                	li	a0,1
    2376:	35e030ef          	jal	56d4 <exit>
    printf("%s: pipe() failed\n", s);
    237a:	85ce                	mv	a1,s3
    237c:	00004517          	auipc	a0,0x4
    2380:	2a450513          	addi	a0,a0,676 # 6620 <malloc+0xa46>
    2384:	79e030ef          	jal	5b22 <printf>
    exit(1);
    2388:	4505                	li	a0,1
    238a:	34a030ef          	jal	56d4 <exit>

000000000000238e <argptest>:
{
    238e:	1101                	addi	sp,sp,-32
    2390:	ec06                	sd	ra,24(sp)
    2392:	e822                	sd	s0,16(sp)
    2394:	e426                	sd	s1,8(sp)
    2396:	e04a                	sd	s2,0(sp)
    2398:	1000                	addi	s0,sp,32
    239a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    239c:	4581                	li	a1,0
    239e:	00004517          	auipc	a0,0x4
    23a2:	7c250513          	addi	a0,a0,1986 # 6b60 <malloc+0xf86>
    23a6:	36e030ef          	jal	5714 <open>
  if (fd < 0) {
    23aa:	02054563          	bltz	a0,23d4 <argptest+0x46>
    23ae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23b0:	4501                	li	a0,0
    23b2:	2ee030ef          	jal	56a0 <sbrk>
    23b6:	567d                	li	a2,-1
    23b8:	00c505b3          	add	a1,a0,a2
    23bc:	8526                	mv	a0,s1
    23be:	32e030ef          	jal	56ec <read>
  close(fd);
    23c2:	8526                	mv	a0,s1
    23c4:	338030ef          	jal	56fc <close>
}
    23c8:	60e2                	ld	ra,24(sp)
    23ca:	6442                	ld	s0,16(sp)
    23cc:	64a2                	ld	s1,8(sp)
    23ce:	6902                	ld	s2,0(sp)
    23d0:	6105                	addi	sp,sp,32
    23d2:	8082                	ret
    printf("%s: open failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00004517          	auipc	a0,0x4
    23da:	1da50513          	addi	a0,a0,474 # 65b0 <malloc+0x9d6>
    23de:	744030ef          	jal	5b22 <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	2f0030ef          	jal	56d4 <exit>

00000000000023e8 <sbrkbugs>:
{
    23e8:	1141                	addi	sp,sp,-16
    23ea:	e406                	sd	ra,8(sp)
    23ec:	e022                	sd	s0,0(sp)
    23ee:	0800                	addi	s0,sp,16
  int pid = fork();
    23f0:	2dc030ef          	jal	56cc <fork>
  if (pid < 0) {
    23f4:	00054c63          	bltz	a0,240c <sbrkbugs+0x24>
  if (pid == 0) {
    23f8:	e11d                	bnez	a0,241e <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23fa:	2a6030ef          	jal	56a0 <sbrk>
    sbrk(-sz);
    23fe:	40a0053b          	negw	a0,a0
    2402:	29e030ef          	jal	56a0 <sbrk>
    exit(0);
    2406:	4501                	li	a0,0
    2408:	2cc030ef          	jal	56d4 <exit>
    printf("fork failed\n");
    240c:	00006517          	auipc	a0,0x6
    2410:	84c50513          	addi	a0,a0,-1972 # 7c58 <malloc+0x207e>
    2414:	70e030ef          	jal	5b22 <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	2ba030ef          	jal	56d4 <exit>
  wait(0);
    241e:	4501                	li	a0,0
    2420:	2bc030ef          	jal	56dc <wait>
  pid = fork();
    2424:	2a8030ef          	jal	56cc <fork>
  if (pid < 0) {
    2428:	00054f63          	bltz	a0,2446 <sbrkbugs+0x5e>
  if (pid == 0) {
    242c:	e515                	bnez	a0,2458 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    242e:	272030ef          	jal	56a0 <sbrk>
    sbrk(-(sz - 3500));
    2432:	6785                	lui	a5,0x1
    2434:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    2438:	40a7853b          	subw	a0,a5,a0
    243c:	264030ef          	jal	56a0 <sbrk>
    exit(0);
    2440:	4501                	li	a0,0
    2442:	292030ef          	jal	56d4 <exit>
    printf("fork failed\n");
    2446:	00006517          	auipc	a0,0x6
    244a:	81250513          	addi	a0,a0,-2030 # 7c58 <malloc+0x207e>
    244e:	6d4030ef          	jal	5b22 <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	280030ef          	jal	56d4 <exit>
  wait(0);
    2458:	4501                	li	a0,0
    245a:	282030ef          	jal	56dc <wait>
  pid = fork();
    245e:	26e030ef          	jal	56cc <fork>
  if (pid < 0) {
    2462:	02054263          	bltz	a0,2486 <sbrkbugs+0x9e>
  if (pid == 0) {
    2466:	e90d                	bnez	a0,2498 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2468:	238030ef          	jal	56a0 <sbrk>
    246c:	67ad                	lui	a5,0xb
    246e:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x230>
    2472:	40a7853b          	subw	a0,a5,a0
    2476:	22a030ef          	jal	56a0 <sbrk>
    sbrk(-10);
    247a:	5559                	li	a0,-10
    247c:	224030ef          	jal	56a0 <sbrk>
    exit(0);
    2480:	4501                	li	a0,0
    2482:	252030ef          	jal	56d4 <exit>
    printf("fork failed\n");
    2486:	00005517          	auipc	a0,0x5
    248a:	7d250513          	addi	a0,a0,2002 # 7c58 <malloc+0x207e>
    248e:	694030ef          	jal	5b22 <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	240030ef          	jal	56d4 <exit>
  wait(0);
    2498:	4501                	li	a0,0
    249a:	242030ef          	jal	56dc <wait>
  exit(0);
    249e:	4501                	li	a0,0
    24a0:	234030ef          	jal	56d4 <exit>

00000000000024a4 <sbrklast>:
{
    24a4:	7179                	addi	sp,sp,-48
    24a6:	f406                	sd	ra,40(sp)
    24a8:	f022                	sd	s0,32(sp)
    24aa:	ec26                	sd	s1,24(sp)
    24ac:	e84a                	sd	s2,16(sp)
    24ae:	e44e                	sd	s3,8(sp)
    24b0:	e052                	sd	s4,0(sp)
    24b2:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    24b4:	4501                	li	a0,0
    24b6:	1ea030ef          	jal	56a0 <sbrk>
  if ((top % PGSIZE) != 0)
    24ba:	03451793          	slli	a5,a0,0x34
    24be:	ebad                	bnez	a5,2530 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	1de030ef          	jal	56a0 <sbrk>
  sbrk(10);
    24c6:	4529                	li	a0,10
    24c8:	1d8030ef          	jal	56a0 <sbrk>
  sbrk(-20);
    24cc:	5531                	li	a0,-20
    24ce:	1d2030ef          	jal	56a0 <sbrk>
  top = (uint64)sbrk(0);
    24d2:	4501                	li	a0,0
    24d4:	1cc030ef          	jal	56a0 <sbrk>
    24d8:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24da:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    24de:	07800993          	li	s3,120
    24e2:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    24e6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24ea:	20200593          	li	a1,514
    24ee:	854a                	mv	a0,s2
    24f0:	224030ef          	jal	5714 <open>
    24f4:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    24f6:	4605                	li	a2,1
    24f8:	85ca                	mv	a1,s2
    24fa:	1fa030ef          	jal	56f4 <write>
  close(fd);
    24fe:	8552                	mv	a0,s4
    2500:	1fc030ef          	jal	56fc <close>
  fd = open(p, O_RDWR);
    2504:	4589                	li	a1,2
    2506:	854a                	mv	a0,s2
    2508:	20c030ef          	jal	5714 <open>
  p[0] = '\0';
    250c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2510:	4605                	li	a2,1
    2512:	85ca                	mv	a1,s2
    2514:	1d8030ef          	jal	56ec <read>
  if (p[0] != 'x')
    2518:	fc04c783          	lbu	a5,-64(s1)
    251c:	03379263          	bne	a5,s3,2540 <sbrklast+0x9c>
}
    2520:	70a2                	ld	ra,40(sp)
    2522:	7402                	ld	s0,32(sp)
    2524:	64e2                	ld	s1,24(sp)
    2526:	6942                	ld	s2,16(sp)
    2528:	69a2                	ld	s3,8(sp)
    252a:	6a02                	ld	s4,0(sp)
    252c:	6145                	addi	sp,sp,48
    252e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2530:	0347d513          	srli	a0,a5,0x34
    2534:	6785                	lui	a5,0x1
    2536:	40a7853b          	subw	a0,a5,a0
    253a:	166030ef          	jal	56a0 <sbrk>
    253e:	b749                	j	24c0 <sbrklast+0x1c>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	192030ef          	jal	56d4 <exit>

0000000000002546 <sbrk8000>:
{
    2546:	1141                	addi	sp,sp,-16
    2548:	e406                	sd	ra,8(sp)
    254a:	e022                	sd	s0,0(sp)
    254c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    254e:	80000537          	lui	a0,0x80000
    2552:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef31c>
    2554:	14c030ef          	jal	56a0 <sbrk>
  volatile char *top = sbrk(0);
    2558:	4501                	li	a0,0
    255a:	146030ef          	jal	56a0 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    255e:	fff54783          	lbu	a5,-1(a0)
    2562:	0785                	addi	a5,a5,1 # 1001 <bigdir+0x10d>
    2564:	0ff7f793          	zext.b	a5,a5
    2568:	fef50fa3          	sb	a5,-1(a0)
}
    256c:	60a2                	ld	ra,8(sp)
    256e:	6402                	ld	s0,0(sp)
    2570:	0141                	addi	sp,sp,16
    2572:	8082                	ret

0000000000002574 <execout>:
{
    2574:	711d                	addi	sp,sp,-96
    2576:	ec86                	sd	ra,88(sp)
    2578:	e8a2                	sd	s0,80(sp)
    257a:	e4a6                	sd	s1,72(sp)
    257c:	e0ca                	sd	s2,64(sp)
    257e:	fc4e                	sd	s3,56(sp)
    2580:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    2582:	4901                	li	s2,0
    2584:	49bd                	li	s3,15
    int pid = fork();
    2586:	146030ef          	jal	56cc <fork>
    258a:	84aa                	mv	s1,a0
    if (pid < 0) {
    258c:	00054e63          	bltz	a0,25a8 <execout+0x34>
    } else if (pid == 0) {
    2590:	c51d                	beqz	a0,25be <execout+0x4a>
      wait((int *)0);
    2592:	4501                	li	a0,0
    2594:	148030ef          	jal	56dc <wait>
  for (int avail = 0; avail < 15; avail++) {
    2598:	2905                	addiw	s2,s2,1
    259a:	ff3916e3          	bne	s2,s3,2586 <execout+0x12>
    259e:	f852                	sd	s4,48(sp)
    25a0:	f456                	sd	s5,40(sp)
  exit(0);
    25a2:	4501                	li	a0,0
    25a4:	130030ef          	jal	56d4 <exit>
    25a8:	f852                	sd	s4,48(sp)
    25aa:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    25ac:	00005517          	auipc	a0,0x5
    25b0:	6ac50513          	addi	a0,a0,1708 # 7c58 <malloc+0x207e>
    25b4:	56e030ef          	jal	5b22 <printf>
      exit(1);
    25b8:	4505                	li	a0,1
    25ba:	11a030ef          	jal	56d4 <exit>
    25be:	f852                	sd	s4,48(sp)
    25c0:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25c2:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25c4:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25c6:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25c8:	854e                	mv	a0,s3
    25ca:	0d6030ef          	jal	56a0 <sbrk>
        if (a == SBRK_ERROR)
    25ce:	01450663          	beq	a0,s4,25da <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25d2:	954e                	add	a0,a0,s3
    25d4:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25d8:	bfc5                	j	25c8 <execout+0x54>
        sbrk(-PGSIZE);
    25da:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25dc:	01205863          	blez	s2,25ec <execout+0x78>
        sbrk(-PGSIZE);
    25e0:	854e                	mv	a0,s3
    25e2:	0be030ef          	jal	56a0 <sbrk>
      for (int i = 0; i < avail; i++)
    25e6:	2485                	addiw	s1,s1,1
    25e8:	ff249ce3          	bne	s1,s2,25e0 <execout+0x6c>
      close(1);
    25ec:	4505                	li	a0,1
    25ee:	10e030ef          	jal	56fc <close>
      char *args[] = {"echo", "x", 0};
    25f2:	00003797          	auipc	a5,0x3
    25f6:	71678793          	addi	a5,a5,1814 # 5d08 <malloc+0x12e>
    25fa:	faf43423          	sd	a5,-88(s0)
    25fe:	00003797          	auipc	a5,0x3
    2602:	77a78793          	addi	a5,a5,1914 # 5d78 <malloc+0x19e>
    2606:	faf43823          	sd	a5,-80(s0)
    260a:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    260e:	fa840593          	addi	a1,s0,-88
    2612:	00003517          	auipc	a0,0x3
    2616:	6f650513          	addi	a0,a0,1782 # 5d08 <malloc+0x12e>
    261a:	0f2030ef          	jal	570c <exec>
      exit(0);
    261e:	4501                	li	a0,0
    2620:	0b4030ef          	jal	56d4 <exit>

0000000000002624 <fourteen>:
{
    2624:	1101                	addi	sp,sp,-32
    2626:	ec06                	sd	ra,24(sp)
    2628:	e822                	sd	s0,16(sp)
    262a:	e426                	sd	s1,8(sp)
    262c:	1000                	addi	s0,sp,32
    262e:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    2630:	00004517          	auipc	a0,0x4
    2634:	70850513          	addi	a0,a0,1800 # 6d38 <malloc+0x115e>
    2638:	104030ef          	jal	573c <mkdir>
    263c:	e555                	bnez	a0,26e8 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    263e:	00004517          	auipc	a0,0x4
    2642:	55250513          	addi	a0,a0,1362 # 6b90 <malloc+0xfb6>
    2646:	0f6030ef          	jal	573c <mkdir>
    264a:	e94d                	bnez	a0,26fc <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    264c:	20000593          	li	a1,512
    2650:	00004517          	auipc	a0,0x4
    2654:	59850513          	addi	a0,a0,1432 # 6be8 <malloc+0x100e>
    2658:	0bc030ef          	jal	5714 <open>
  if (fd < 0) {
    265c:	0a054a63          	bltz	a0,2710 <fourteen+0xec>
  close(fd);
    2660:	09c030ef          	jal	56fc <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2664:	4581                	li	a1,0
    2666:	00004517          	auipc	a0,0x4
    266a:	5fa50513          	addi	a0,a0,1530 # 6c60 <malloc+0x1086>
    266e:	0a6030ef          	jal	5714 <open>
  if (fd < 0) {
    2672:	0a054963          	bltz	a0,2724 <fourteen+0x100>
  close(fd);
    2676:	086030ef          	jal	56fc <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    267a:	00004517          	auipc	a0,0x4
    267e:	65650513          	addi	a0,a0,1622 # 6cd0 <malloc+0x10f6>
    2682:	0ba030ef          	jal	573c <mkdir>
    2686:	c94d                	beqz	a0,2738 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2688:	00004517          	auipc	a0,0x4
    268c:	6a050513          	addi	a0,a0,1696 # 6d28 <malloc+0x114e>
    2690:	0ac030ef          	jal	573c <mkdir>
    2694:	cd45                	beqz	a0,274c <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2696:	00004517          	auipc	a0,0x4
    269a:	69250513          	addi	a0,a0,1682 # 6d28 <malloc+0x114e>
    269e:	086030ef          	jal	5724 <unlink>
  unlink("12345678901234/12345678901234");
    26a2:	00004517          	auipc	a0,0x4
    26a6:	62e50513          	addi	a0,a0,1582 # 6cd0 <malloc+0x10f6>
    26aa:	07a030ef          	jal	5724 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26ae:	00004517          	auipc	a0,0x4
    26b2:	5b250513          	addi	a0,a0,1458 # 6c60 <malloc+0x1086>
    26b6:	06e030ef          	jal	5724 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26ba:	00004517          	auipc	a0,0x4
    26be:	52e50513          	addi	a0,a0,1326 # 6be8 <malloc+0x100e>
    26c2:	062030ef          	jal	5724 <unlink>
  unlink("12345678901234/123456789012345");
    26c6:	00004517          	auipc	a0,0x4
    26ca:	4ca50513          	addi	a0,a0,1226 # 6b90 <malloc+0xfb6>
    26ce:	056030ef          	jal	5724 <unlink>
  unlink("12345678901234");
    26d2:	00004517          	auipc	a0,0x4
    26d6:	66650513          	addi	a0,a0,1638 # 6d38 <malloc+0x115e>
    26da:	04a030ef          	jal	5724 <unlink>
}
    26de:	60e2                	ld	ra,24(sp)
    26e0:	6442                	ld	s0,16(sp)
    26e2:	64a2                	ld	s1,8(sp)
    26e4:	6105                	addi	sp,sp,32
    26e6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26e8:	85a6                	mv	a1,s1
    26ea:	00004517          	auipc	a0,0x4
    26ee:	47e50513          	addi	a0,a0,1150 # 6b68 <malloc+0xf8e>
    26f2:	430030ef          	jal	5b22 <printf>
    exit(1);
    26f6:	4505                	li	a0,1
    26f8:	7dd020ef          	jal	56d4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26fc:	85a6                	mv	a1,s1
    26fe:	00004517          	auipc	a0,0x4
    2702:	4b250513          	addi	a0,a0,1202 # 6bb0 <malloc+0xfd6>
    2706:	41c030ef          	jal	5b22 <printf>
    exit(1);
    270a:	4505                	li	a0,1
    270c:	7c9020ef          	jal	56d4 <exit>
    printf(
    2710:	85a6                	mv	a1,s1
    2712:	00004517          	auipc	a0,0x4
    2716:	50650513          	addi	a0,a0,1286 # 6c18 <malloc+0x103e>
    271a:	408030ef          	jal	5b22 <printf>
    exit(1);
    271e:	4505                	li	a0,1
    2720:	7b5020ef          	jal	56d4 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2724:	85a6                	mv	a1,s1
    2726:	00004517          	auipc	a0,0x4
    272a:	56a50513          	addi	a0,a0,1386 # 6c90 <malloc+0x10b6>
    272e:	3f4030ef          	jal	5b22 <printf>
    exit(1);
    2732:	4505                	li	a0,1
    2734:	7a1020ef          	jal	56d4 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2738:	85a6                	mv	a1,s1
    273a:	00004517          	auipc	a0,0x4
    273e:	5b650513          	addi	a0,a0,1462 # 6cf0 <malloc+0x1116>
    2742:	3e0030ef          	jal	5b22 <printf>
    exit(1);
    2746:	4505                	li	a0,1
    2748:	78d020ef          	jal	56d4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    274c:	85a6                	mv	a1,s1
    274e:	00004517          	auipc	a0,0x4
    2752:	5fa50513          	addi	a0,a0,1530 # 6d48 <malloc+0x116e>
    2756:	3cc030ef          	jal	5b22 <printf>
    exit(1);
    275a:	4505                	li	a0,1
    275c:	779020ef          	jal	56d4 <exit>

0000000000002760 <diskfull>:
{
    2760:	b6010113          	addi	sp,sp,-1184
    2764:	48113c23          	sd	ra,1176(sp)
    2768:	48813823          	sd	s0,1168(sp)
    276c:	48913423          	sd	s1,1160(sp)
    2770:	49213023          	sd	s2,1152(sp)
    2774:	47313c23          	sd	s3,1144(sp)
    2778:	47413823          	sd	s4,1136(sp)
    277c:	47513423          	sd	s5,1128(sp)
    2780:	47613023          	sd	s6,1120(sp)
    2784:	45713c23          	sd	s7,1112(sp)
    2788:	45813823          	sd	s8,1104(sp)
    278c:	45913423          	sd	s9,1096(sp)
    2790:	45a13023          	sd	s10,1088(sp)
    2794:	43b13c23          	sd	s11,1080(sp)
    2798:	4a010413          	addi	s0,sp,1184
    279c:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    27a0:	00004517          	auipc	a0,0x4
    27a4:	5e050513          	addi	a0,a0,1504 # 6d80 <malloc+0x11a6>
    27a8:	77d020ef          	jal	5724 <unlink>
    27ac:	03000a93          	li	s5,48
    name[0] = 'b';
    27b0:	06200d13          	li	s10,98
    name[1] = 'i';
    27b4:	06900c93          	li	s9,105
    name[2] = 'g';
    27b8:	06700c13          	li	s8,103
    unlink(name);
    27bc:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27c0:	60200b93          	li	s7,1538
    27c4:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27c8:	b9040a13          	addi	s4,s0,-1136
    27cc:	aa8d                	j	293e <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27ce:	b7040613          	addi	a2,s0,-1168
    27d2:	b6843583          	ld	a1,-1176(s0)
    27d6:	00004517          	auipc	a0,0x4
    27da:	5ba50513          	addi	a0,a0,1466 # 6d90 <malloc+0x11b6>
    27de:	344030ef          	jal	5b22 <printf>
      break;
    27e2:	a039                	j	27f0 <diskfull+0x90>
        close(fd);
    27e4:	854e                	mv	a0,s3
    27e6:	717020ef          	jal	56fc <close>
    close(fd);
    27ea:	854e                	mv	a0,s3
    27ec:	711020ef          	jal	56fc <close>
  for (int i = 0; i < nzz; i++) {
    27f0:	4481                	li	s1,0
    name[0] = 'z';
    27f2:	07a00993          	li	s3,122
    unlink(name);
    27f6:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27fe:	08000a93          	li	s5,128
    name[0] = 'z';
    2802:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2806:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    280a:	41f4d71b          	sraiw	a4,s1,0x1f
    280e:	01b7571b          	srliw	a4,a4,0x1b
    2812:	009707bb          	addw	a5,a4,s1
    2816:	4057d69b          	sraiw	a3,a5,0x5
    281a:	0306869b          	addiw	a3,a3,48
    281e:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2822:	8bfd                	andi	a5,a5,31
    2824:	9f99                	subw	a5,a5,a4
    2826:	0307879b          	addiw	a5,a5,48
    282a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    282e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2832:	854a                	mv	a0,s2
    2834:	6f1020ef          	jal	5724 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2838:	85d2                	mv	a1,s4
    283a:	854a                	mv	a0,s2
    283c:	6d9020ef          	jal	5714 <open>
    if (fd < 0)
    2840:	00054763          	bltz	a0,284e <diskfull+0xee>
    close(fd);
    2844:	6b9020ef          	jal	56fc <close>
  for (int i = 0; i < nzz; i++) {
    2848:	2485                	addiw	s1,s1,1
    284a:	fb549ce3          	bne	s1,s5,2802 <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    284e:	00004517          	auipc	a0,0x4
    2852:	53250513          	addi	a0,a0,1330 # 6d80 <malloc+0x11a6>
    2856:	6e7020ef          	jal	573c <mkdir>
    285a:	12050363          	beqz	a0,2980 <diskfull+0x220>
  unlink("diskfulldir");
    285e:	00004517          	auipc	a0,0x4
    2862:	52250513          	addi	a0,a0,1314 # 6d80 <malloc+0x11a6>
    2866:	6bf020ef          	jal	5724 <unlink>
  for (int i = 0; i < nzz; i++) {
    286a:	4481                	li	s1,0
    name[0] = 'z';
    286c:	07a00913          	li	s2,122
    unlink(name);
    2870:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2874:	08000993          	li	s3,128
    name[0] = 'z';
    2878:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    287c:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    2880:	41f4d71b          	sraiw	a4,s1,0x1f
    2884:	01b7571b          	srliw	a4,a4,0x1b
    2888:	009707bb          	addw	a5,a4,s1
    288c:	4057d69b          	sraiw	a3,a5,0x5
    2890:	0306869b          	addiw	a3,a3,48
    2894:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2898:	8bfd                	andi	a5,a5,31
    289a:	9f99                	subw	a5,a5,a4
    289c:	0307879b          	addiw	a5,a5,48
    28a0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28a4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28a8:	8552                	mv	a0,s4
    28aa:	67b020ef          	jal	5724 <unlink>
  for (int i = 0; i < nzz; i++) {
    28ae:	2485                	addiw	s1,s1,1
    28b0:	fd3494e3          	bne	s1,s3,2878 <diskfull+0x118>
    28b4:	03000493          	li	s1,48
    name[0] = 'b';
    28b8:	06200b13          	li	s6,98
    name[1] = 'i';
    28bc:	06900a93          	li	s5,105
    name[2] = 'g';
    28c0:	06700a13          	li	s4,103
    unlink(name);
    28c4:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28c8:	07f00913          	li	s2,127
    name[0] = 'b';
    28cc:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28d0:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28d4:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28d8:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28dc:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28e0:	854e                	mv	a0,s3
    28e2:	643020ef          	jal	5724 <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28e6:	2485                	addiw	s1,s1,1
    28e8:	0ff4f493          	zext.b	s1,s1
    28ec:	ff2490e3          	bne	s1,s2,28cc <diskfull+0x16c>
}
    28f0:	49813083          	ld	ra,1176(sp)
    28f4:	49013403          	ld	s0,1168(sp)
    28f8:	48813483          	ld	s1,1160(sp)
    28fc:	48013903          	ld	s2,1152(sp)
    2900:	47813983          	ld	s3,1144(sp)
    2904:	47013a03          	ld	s4,1136(sp)
    2908:	46813a83          	ld	s5,1128(sp)
    290c:	46013b03          	ld	s6,1120(sp)
    2910:	45813b83          	ld	s7,1112(sp)
    2914:	45013c03          	ld	s8,1104(sp)
    2918:	44813c83          	ld	s9,1096(sp)
    291c:	44013d03          	ld	s10,1088(sp)
    2920:	43813d83          	ld	s11,1080(sp)
    2924:	4a010113          	addi	sp,sp,1184
    2928:	8082                	ret
    close(fd);
    292a:	854e                	mv	a0,s3
    292c:	5d1020ef          	jal	56fc <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    2930:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x477>
    2932:	0ffafa93          	zext.b	s5,s5
    2936:	07f00793          	li	a5,127
    293a:	eafa8be3          	beq	s5,a5,27f0 <diskfull+0x90>
    name[0] = 'b';
    293e:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2942:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2946:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    294a:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    294e:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2952:	855a                	mv	a0,s6
    2954:	5d1020ef          	jal	5724 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2958:	85de                	mv	a1,s7
    295a:	855a                	mv	a0,s6
    295c:	5b9020ef          	jal	5714 <open>
    2960:	89aa                	mv	s3,a0
    if (fd < 0) {
    2962:	e60546e3          	bltz	a0,27ce <diskfull+0x6e>
    2966:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    2968:	40000913          	li	s2,1024
    296c:	864a                	mv	a2,s2
    296e:	85d2                	mv	a1,s4
    2970:	854e                	mv	a0,s3
    2972:	583020ef          	jal	56f4 <write>
    2976:	e72517e3          	bne	a0,s2,27e4 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    297a:	34fd                	addiw	s1,s1,-1
    297c:	f8e5                	bnez	s1,296c <diskfull+0x20c>
    297e:	b775                	j	292a <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2980:	b6843583          	ld	a1,-1176(s0)
    2984:	00004517          	auipc	a0,0x4
    2988:	42c50513          	addi	a0,a0,1068 # 6db0 <malloc+0x11d6>
    298c:	196030ef          	jal	5b22 <printf>
    2990:	b5f9                	j	285e <diskfull+0xfe>

0000000000002992 <iputtest>:
{
    2992:	1101                	addi	sp,sp,-32
    2994:	ec06                	sd	ra,24(sp)
    2996:	e822                	sd	s0,16(sp)
    2998:	e426                	sd	s1,8(sp)
    299a:	1000                	addi	s0,sp,32
    299c:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    299e:	00004517          	auipc	a0,0x4
    29a2:	44250513          	addi	a0,a0,1090 # 6de0 <malloc+0x1206>
    29a6:	597020ef          	jal	573c <mkdir>
    29aa:	02054f63          	bltz	a0,29e8 <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    29ae:	00004517          	auipc	a0,0x4
    29b2:	43250513          	addi	a0,a0,1074 # 6de0 <malloc+0x1206>
    29b6:	58f020ef          	jal	5744 <chdir>
    29ba:	04054163          	bltz	a0,29fc <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29be:	00004517          	auipc	a0,0x4
    29c2:	46250513          	addi	a0,a0,1122 # 6e20 <malloc+0x1246>
    29c6:	55f020ef          	jal	5724 <unlink>
    29ca:	04054363          	bltz	a0,2a10 <iputtest+0x7e>
  if (chdir("/") < 0) {
    29ce:	00004517          	auipc	a0,0x4
    29d2:	48250513          	addi	a0,a0,1154 # 6e50 <malloc+0x1276>
    29d6:	56f020ef          	jal	5744 <chdir>
    29da:	04054563          	bltz	a0,2a24 <iputtest+0x92>
}
    29de:	60e2                	ld	ra,24(sp)
    29e0:	6442                	ld	s0,16(sp)
    29e2:	64a2                	ld	s1,8(sp)
    29e4:	6105                	addi	sp,sp,32
    29e6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e8:	85a6                	mv	a1,s1
    29ea:	00004517          	auipc	a0,0x4
    29ee:	3fe50513          	addi	a0,a0,1022 # 6de8 <malloc+0x120e>
    29f2:	130030ef          	jal	5b22 <printf>
    exit(1);
    29f6:	4505                	li	a0,1
    29f8:	4dd020ef          	jal	56d4 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29fc:	85a6                	mv	a1,s1
    29fe:	00004517          	auipc	a0,0x4
    2a02:	40250513          	addi	a0,a0,1026 # 6e00 <malloc+0x1226>
    2a06:	11c030ef          	jal	5b22 <printf>
    exit(1);
    2a0a:	4505                	li	a0,1
    2a0c:	4c9020ef          	jal	56d4 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a10:	85a6                	mv	a1,s1
    2a12:	00004517          	auipc	a0,0x4
    2a16:	41e50513          	addi	a0,a0,1054 # 6e30 <malloc+0x1256>
    2a1a:	108030ef          	jal	5b22 <printf>
    exit(1);
    2a1e:	4505                	li	a0,1
    2a20:	4b5020ef          	jal	56d4 <exit>
    printf("%s: chdir / failed\n", s);
    2a24:	85a6                	mv	a1,s1
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	43250513          	addi	a0,a0,1074 # 6e58 <malloc+0x127e>
    2a2e:	0f4030ef          	jal	5b22 <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	4a1020ef          	jal	56d4 <exit>

0000000000002a38 <exitiputtest>:
{
    2a38:	7179                	addi	sp,sp,-48
    2a3a:	f406                	sd	ra,40(sp)
    2a3c:	f022                	sd	s0,32(sp)
    2a3e:	ec26                	sd	s1,24(sp)
    2a40:	1800                	addi	s0,sp,48
    2a42:	84aa                	mv	s1,a0
  pid = fork();
    2a44:	489020ef          	jal	56cc <fork>
  if (pid < 0) {
    2a48:	02054e63          	bltz	a0,2a84 <exitiputtest+0x4c>
  if (pid == 0) {
    2a4c:	e541                	bnez	a0,2ad4 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a4e:	00004517          	auipc	a0,0x4
    2a52:	39250513          	addi	a0,a0,914 # 6de0 <malloc+0x1206>
    2a56:	4e7020ef          	jal	573c <mkdir>
    2a5a:	02054f63          	bltz	a0,2a98 <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	38250513          	addi	a0,a0,898 # 6de0 <malloc+0x1206>
    2a66:	4df020ef          	jal	5744 <chdir>
    2a6a:	04054163          	bltz	a0,2aac <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a6e:	00004517          	auipc	a0,0x4
    2a72:	3b250513          	addi	a0,a0,946 # 6e20 <malloc+0x1246>
    2a76:	4af020ef          	jal	5724 <unlink>
    2a7a:	04054363          	bltz	a0,2ac0 <exitiputtest+0x88>
    exit(0);
    2a7e:	4501                	li	a0,0
    2a80:	455020ef          	jal	56d4 <exit>
    printf("%s: fork failed\n", s);
    2a84:	85a6                	mv	a1,s1
    2a86:	00004517          	auipc	a0,0x4
    2a8a:	b1250513          	addi	a0,a0,-1262 # 6598 <malloc+0x9be>
    2a8e:	094030ef          	jal	5b22 <printf>
    exit(1);
    2a92:	4505                	li	a0,1
    2a94:	441020ef          	jal	56d4 <exit>
      printf("%s: mkdir failed\n", s);
    2a98:	85a6                	mv	a1,s1
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	34e50513          	addi	a0,a0,846 # 6de8 <malloc+0x120e>
    2aa2:	080030ef          	jal	5b22 <printf>
      exit(1);
    2aa6:	4505                	li	a0,1
    2aa8:	42d020ef          	jal	56d4 <exit>
      printf("%s: child chdir failed\n", s);
    2aac:	85a6                	mv	a1,s1
    2aae:	00004517          	auipc	a0,0x4
    2ab2:	3c250513          	addi	a0,a0,962 # 6e70 <malloc+0x1296>
    2ab6:	06c030ef          	jal	5b22 <printf>
      exit(1);
    2aba:	4505                	li	a0,1
    2abc:	419020ef          	jal	56d4 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ac0:	85a6                	mv	a1,s1
    2ac2:	00004517          	auipc	a0,0x4
    2ac6:	36e50513          	addi	a0,a0,878 # 6e30 <malloc+0x1256>
    2aca:	058030ef          	jal	5b22 <printf>
      exit(1);
    2ace:	4505                	li	a0,1
    2ad0:	405020ef          	jal	56d4 <exit>
  wait(&xstatus);
    2ad4:	fdc40513          	addi	a0,s0,-36
    2ad8:	405020ef          	jal	56dc <wait>
  exit(xstatus);
    2adc:	fdc42503          	lw	a0,-36(s0)
    2ae0:	3f5020ef          	jal	56d4 <exit>

0000000000002ae4 <dirtest>:
{
    2ae4:	1101                	addi	sp,sp,-32
    2ae6:	ec06                	sd	ra,24(sp)
    2ae8:	e822                	sd	s0,16(sp)
    2aea:	e426                	sd	s1,8(sp)
    2aec:	1000                	addi	s0,sp,32
    2aee:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2af0:	00004517          	auipc	a0,0x4
    2af4:	39850513          	addi	a0,a0,920 # 6e88 <malloc+0x12ae>
    2af8:	445020ef          	jal	573c <mkdir>
    2afc:	02054f63          	bltz	a0,2b3a <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2b00:	00004517          	auipc	a0,0x4
    2b04:	38850513          	addi	a0,a0,904 # 6e88 <malloc+0x12ae>
    2b08:	43d020ef          	jal	5744 <chdir>
    2b0c:	04054163          	bltz	a0,2b4e <dirtest+0x6a>
  if (chdir("..") < 0) {
    2b10:	00004517          	auipc	a0,0x4
    2b14:	39850513          	addi	a0,a0,920 # 6ea8 <malloc+0x12ce>
    2b18:	42d020ef          	jal	5744 <chdir>
    2b1c:	04054363          	bltz	a0,2b62 <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b20:	00004517          	auipc	a0,0x4
    2b24:	36850513          	addi	a0,a0,872 # 6e88 <malloc+0x12ae>
    2b28:	3fd020ef          	jal	5724 <unlink>
    2b2c:	04054563          	bltz	a0,2b76 <dirtest+0x92>
}
    2b30:	60e2                	ld	ra,24(sp)
    2b32:	6442                	ld	s0,16(sp)
    2b34:	64a2                	ld	s1,8(sp)
    2b36:	6105                	addi	sp,sp,32
    2b38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b3a:	85a6                	mv	a1,s1
    2b3c:	00004517          	auipc	a0,0x4
    2b40:	2ac50513          	addi	a0,a0,684 # 6de8 <malloc+0x120e>
    2b44:	7df020ef          	jal	5b22 <printf>
    exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	38b020ef          	jal	56d4 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4e:	85a6                	mv	a1,s1
    2b50:	00004517          	auipc	a0,0x4
    2b54:	34050513          	addi	a0,a0,832 # 6e90 <malloc+0x12b6>
    2b58:	7cb020ef          	jal	5b22 <printf>
    exit(1);
    2b5c:	4505                	li	a0,1
    2b5e:	377020ef          	jal	56d4 <exit>
    printf("%s: chdir .. failed\n", s);
    2b62:	85a6                	mv	a1,s1
    2b64:	00004517          	auipc	a0,0x4
    2b68:	34c50513          	addi	a0,a0,844 # 6eb0 <malloc+0x12d6>
    2b6c:	7b7020ef          	jal	5b22 <printf>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	363020ef          	jal	56d4 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b76:	85a6                	mv	a1,s1
    2b78:	00004517          	auipc	a0,0x4
    2b7c:	35050513          	addi	a0,a0,848 # 6ec8 <malloc+0x12ee>
    2b80:	7a3020ef          	jal	5b22 <printf>
    exit(1);
    2b84:	4505                	li	a0,1
    2b86:	34f020ef          	jal	56d4 <exit>

0000000000002b8a <subdir>:
{
    2b8a:	1101                	addi	sp,sp,-32
    2b8c:	ec06                	sd	ra,24(sp)
    2b8e:	e822                	sd	s0,16(sp)
    2b90:	e426                	sd	s1,8(sp)
    2b92:	e04a                	sd	s2,0(sp)
    2b94:	1000                	addi	s0,sp,32
    2b96:	892a                	mv	s2,a0
  unlink("ff");
    2b98:	00004517          	auipc	a0,0x4
    2b9c:	47850513          	addi	a0,a0,1144 # 7010 <malloc+0x1436>
    2ba0:	385020ef          	jal	5724 <unlink>
  if (mkdir("dd") != 0) {
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	33c50513          	addi	a0,a0,828 # 6ee0 <malloc+0x1306>
    2bac:	391020ef          	jal	573c <mkdir>
    2bb0:	2e051263          	bnez	a0,2e94 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb4:	20200593          	li	a1,514
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	34850513          	addi	a0,a0,840 # 6f00 <malloc+0x1326>
    2bc0:	355020ef          	jal	5714 <open>
    2bc4:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bc6:	2e054163          	bltz	a0,2ea8 <subdir+0x31e>
  write(fd, "ff", 2);
    2bca:	4609                	li	a2,2
    2bcc:	00004597          	auipc	a1,0x4
    2bd0:	44458593          	addi	a1,a1,1092 # 7010 <malloc+0x1436>
    2bd4:	321020ef          	jal	56f4 <write>
  close(fd);
    2bd8:	8526                	mv	a0,s1
    2bda:	323020ef          	jal	56fc <close>
  if (unlink("dd") >= 0) {
    2bde:	00004517          	auipc	a0,0x4
    2be2:	30250513          	addi	a0,a0,770 # 6ee0 <malloc+0x1306>
    2be6:	33f020ef          	jal	5724 <unlink>
    2bea:	2c055963          	bgez	a0,2ebc <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	36a50513          	addi	a0,a0,874 # 6f58 <malloc+0x137e>
    2bf6:	347020ef          	jal	573c <mkdir>
    2bfa:	2c051b63          	bnez	a0,2ed0 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfe:	20200593          	li	a1,514
    2c02:	00004517          	auipc	a0,0x4
    2c06:	37e50513          	addi	a0,a0,894 # 6f80 <malloc+0x13a6>
    2c0a:	30b020ef          	jal	5714 <open>
    2c0e:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c10:	2c054a63          	bltz	a0,2ee4 <subdir+0x35a>
  write(fd, "FF", 2);
    2c14:	4609                	li	a2,2
    2c16:	00004597          	auipc	a1,0x4
    2c1a:	39a58593          	addi	a1,a1,922 # 6fb0 <malloc+0x13d6>
    2c1e:	2d7020ef          	jal	56f4 <write>
  close(fd);
    2c22:	8526                	mv	a0,s1
    2c24:	2d9020ef          	jal	56fc <close>
  fd = open("dd/dd/../ff", 0);
    2c28:	4581                	li	a1,0
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	38e50513          	addi	a0,a0,910 # 6fb8 <malloc+0x13de>
    2c32:	2e3020ef          	jal	5714 <open>
    2c36:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c38:	2c054063          	bltz	a0,2ef8 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c3c:	660d                	lui	a2,0x3
    2c3e:	0000b597          	auipc	a1,0xb
    2c42:	0aa58593          	addi	a1,a1,170 # dce8 <buf>
    2c46:	2a7020ef          	jal	56ec <read>
  if (cc != 2 || buf[0] != 'f') {
    2c4a:	4789                	li	a5,2
    2c4c:	2cf51063          	bne	a0,a5,2f0c <subdir+0x382>
    2c50:	0000b717          	auipc	a4,0xb
    2c54:	09874703          	lbu	a4,152(a4) # dce8 <buf>
    2c58:	06600793          	li	a5,102
    2c5c:	2af71863          	bne	a4,a5,2f0c <subdir+0x382>
  close(fd);
    2c60:	8526                	mv	a0,s1
    2c62:	29b020ef          	jal	56fc <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c66:	00004597          	auipc	a1,0x4
    2c6a:	3a258593          	addi	a1,a1,930 # 7008 <malloc+0x142e>
    2c6e:	00004517          	auipc	a0,0x4
    2c72:	31250513          	addi	a0,a0,786 # 6f80 <malloc+0x13a6>
    2c76:	2bf020ef          	jal	5734 <link>
    2c7a:	2a051363          	bnez	a0,2f20 <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c7e:	00004517          	auipc	a0,0x4
    2c82:	30250513          	addi	a0,a0,770 # 6f80 <malloc+0x13a6>
    2c86:	29f020ef          	jal	5724 <unlink>
    2c8a:	2a051563          	bnez	a0,2f34 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c8e:	4581                	li	a1,0
    2c90:	00004517          	auipc	a0,0x4
    2c94:	2f050513          	addi	a0,a0,752 # 6f80 <malloc+0x13a6>
    2c98:	27d020ef          	jal	5714 <open>
    2c9c:	2a055663          	bgez	a0,2f48 <subdir+0x3be>
  if (chdir("dd") != 0) {
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	24050513          	addi	a0,a0,576 # 6ee0 <malloc+0x1306>
    2ca8:	29d020ef          	jal	5744 <chdir>
    2cac:	2a051863          	bnez	a0,2f5c <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	3f050513          	addi	a0,a0,1008 # 70a0 <malloc+0x14c6>
    2cb8:	28d020ef          	jal	5744 <chdir>
    2cbc:	2a051a63          	bnez	a0,2f70 <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	41050513          	addi	a0,a0,1040 # 70d0 <malloc+0x14f6>
    2cc8:	27d020ef          	jal	5744 <chdir>
    2ccc:	2a051c63          	bnez	a0,2f84 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2cd0:	00004517          	auipc	a0,0x4
    2cd4:	43850513          	addi	a0,a0,1080 # 7108 <malloc+0x152e>
    2cd8:	26d020ef          	jal	5744 <chdir>
    2cdc:	2a051e63          	bnez	a0,2f98 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2ce0:	4581                	li	a1,0
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	32650513          	addi	a0,a0,806 # 7008 <malloc+0x142e>
    2cea:	22b020ef          	jal	5714 <open>
    2cee:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cf0:	2a054e63          	bltz	a0,2fac <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cf4:	660d                	lui	a2,0x3
    2cf6:	0000b597          	auipc	a1,0xb
    2cfa:	ff258593          	addi	a1,a1,-14 # dce8 <buf>
    2cfe:	1ef020ef          	jal	56ec <read>
    2d02:	4789                	li	a5,2
    2d04:	2af51e63          	bne	a0,a5,2fc0 <subdir+0x436>
  close(fd);
    2d08:	8526                	mv	a0,s1
    2d0a:	1f3020ef          	jal	56fc <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d0e:	4581                	li	a1,0
    2d10:	00004517          	auipc	a0,0x4
    2d14:	27050513          	addi	a0,a0,624 # 6f80 <malloc+0x13a6>
    2d18:	1fd020ef          	jal	5714 <open>
    2d1c:	2a055c63          	bgez	a0,2fd4 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d20:	20200593          	li	a1,514
    2d24:	00004517          	auipc	a0,0x4
    2d28:	47450513          	addi	a0,a0,1140 # 7198 <malloc+0x15be>
    2d2c:	1e9020ef          	jal	5714 <open>
    2d30:	2a055c63          	bgez	a0,2fe8 <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d34:	20200593          	li	a1,514
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	49050513          	addi	a0,a0,1168 # 71c8 <malloc+0x15ee>
    2d40:	1d5020ef          	jal	5714 <open>
    2d44:	2a055c63          	bgez	a0,2ffc <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d48:	20000593          	li	a1,512
    2d4c:	00004517          	auipc	a0,0x4
    2d50:	19450513          	addi	a0,a0,404 # 6ee0 <malloc+0x1306>
    2d54:	1c1020ef          	jal	5714 <open>
    2d58:	2a055c63          	bgez	a0,3010 <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d5c:	4589                	li	a1,2
    2d5e:	00004517          	auipc	a0,0x4
    2d62:	18250513          	addi	a0,a0,386 # 6ee0 <malloc+0x1306>
    2d66:	1af020ef          	jal	5714 <open>
    2d6a:	2a055d63          	bgez	a0,3024 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d6e:	4585                	li	a1,1
    2d70:	00004517          	auipc	a0,0x4
    2d74:	17050513          	addi	a0,a0,368 # 6ee0 <malloc+0x1306>
    2d78:	19d020ef          	jal	5714 <open>
    2d7c:	2a055e63          	bgez	a0,3038 <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d80:	00004597          	auipc	a1,0x4
    2d84:	4d858593          	addi	a1,a1,1240 # 7258 <malloc+0x167e>
    2d88:	00004517          	auipc	a0,0x4
    2d8c:	41050513          	addi	a0,a0,1040 # 7198 <malloc+0x15be>
    2d90:	1a5020ef          	jal	5734 <link>
    2d94:	2a050c63          	beqz	a0,304c <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d98:	00004597          	auipc	a1,0x4
    2d9c:	4c058593          	addi	a1,a1,1216 # 7258 <malloc+0x167e>
    2da0:	00004517          	auipc	a0,0x4
    2da4:	42850513          	addi	a0,a0,1064 # 71c8 <malloc+0x15ee>
    2da8:	18d020ef          	jal	5734 <link>
    2dac:	2a050a63          	beqz	a0,3060 <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2db0:	00004597          	auipc	a1,0x4
    2db4:	25858593          	addi	a1,a1,600 # 7008 <malloc+0x142e>
    2db8:	00004517          	auipc	a0,0x4
    2dbc:	14850513          	addi	a0,a0,328 # 6f00 <malloc+0x1326>
    2dc0:	175020ef          	jal	5734 <link>
    2dc4:	2a050863          	beqz	a0,3074 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2dc8:	00004517          	auipc	a0,0x4
    2dcc:	3d050513          	addi	a0,a0,976 # 7198 <malloc+0x15be>
    2dd0:	16d020ef          	jal	573c <mkdir>
    2dd4:	2a050a63          	beqz	a0,3088 <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dd8:	00004517          	auipc	a0,0x4
    2ddc:	3f050513          	addi	a0,a0,1008 # 71c8 <malloc+0x15ee>
    2de0:	15d020ef          	jal	573c <mkdir>
    2de4:	2a050c63          	beqz	a0,309c <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2de8:	00004517          	auipc	a0,0x4
    2dec:	22050513          	addi	a0,a0,544 # 7008 <malloc+0x142e>
    2df0:	14d020ef          	jal	573c <mkdir>
    2df4:	2a050e63          	beqz	a0,30b0 <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	3d050513          	addi	a0,a0,976 # 71c8 <malloc+0x15ee>
    2e00:	125020ef          	jal	5724 <unlink>
    2e04:	2c050063          	beqz	a0,30c4 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2e08:	00004517          	auipc	a0,0x4
    2e0c:	39050513          	addi	a0,a0,912 # 7198 <malloc+0x15be>
    2e10:	115020ef          	jal	5724 <unlink>
    2e14:	2c050263          	beqz	a0,30d8 <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	0e850513          	addi	a0,a0,232 # 6f00 <malloc+0x1326>
    2e20:	125020ef          	jal	5744 <chdir>
    2e24:	2c050463          	beqz	a0,30ec <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e28:	00004517          	auipc	a0,0x4
    2e2c:	58050513          	addi	a0,a0,1408 # 73a8 <malloc+0x17ce>
    2e30:	115020ef          	jal	5744 <chdir>
    2e34:	2c050663          	beqz	a0,3100 <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e38:	00004517          	auipc	a0,0x4
    2e3c:	1d050513          	addi	a0,a0,464 # 7008 <malloc+0x142e>
    2e40:	0e5020ef          	jal	5724 <unlink>
    2e44:	2c051863          	bnez	a0,3114 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	0b850513          	addi	a0,a0,184 # 6f00 <malloc+0x1326>
    2e50:	0d5020ef          	jal	5724 <unlink>
    2e54:	2c051a63          	bnez	a0,3128 <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	08850513          	addi	a0,a0,136 # 6ee0 <malloc+0x1306>
    2e60:	0c5020ef          	jal	5724 <unlink>
    2e64:	2c050c63          	beqz	a0,313c <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e68:	00004517          	auipc	a0,0x4
    2e6c:	5b050513          	addi	a0,a0,1456 # 7418 <malloc+0x183e>
    2e70:	0b5020ef          	jal	5724 <unlink>
    2e74:	2c054e63          	bltz	a0,3150 <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	06850513          	addi	a0,a0,104 # 6ee0 <malloc+0x1306>
    2e80:	0a5020ef          	jal	5724 <unlink>
    2e84:	2e054063          	bltz	a0,3164 <subdir+0x5da>
}
    2e88:	60e2                	ld	ra,24(sp)
    2e8a:	6442                	ld	s0,16(sp)
    2e8c:	64a2                	ld	s1,8(sp)
    2e8e:	6902                	ld	s2,0(sp)
    2e90:	6105                	addi	sp,sp,32
    2e92:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e94:	85ca                	mv	a1,s2
    2e96:	00004517          	auipc	a0,0x4
    2e9a:	05250513          	addi	a0,a0,82 # 6ee8 <malloc+0x130e>
    2e9e:	485020ef          	jal	5b22 <printf>
    exit(1);
    2ea2:	4505                	li	a0,1
    2ea4:	031020ef          	jal	56d4 <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea8:	85ca                	mv	a1,s2
    2eaa:	00004517          	auipc	a0,0x4
    2eae:	05e50513          	addi	a0,a0,94 # 6f08 <malloc+0x132e>
    2eb2:	471020ef          	jal	5b22 <printf>
    exit(1);
    2eb6:	4505                	li	a0,1
    2eb8:	01d020ef          	jal	56d4 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ebc:	85ca                	mv	a1,s2
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	06a50513          	addi	a0,a0,106 # 6f28 <malloc+0x134e>
    2ec6:	45d020ef          	jal	5b22 <printf>
    exit(1);
    2eca:	4505                	li	a0,1
    2ecc:	009020ef          	jal	56d4 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ed0:	85ca                	mv	a1,s2
    2ed2:	00004517          	auipc	a0,0x4
    2ed6:	08e50513          	addi	a0,a0,142 # 6f60 <malloc+0x1386>
    2eda:	449020ef          	jal	5b22 <printf>
    exit(1);
    2ede:	4505                	li	a0,1
    2ee0:	7f4020ef          	jal	56d4 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee4:	85ca                	mv	a1,s2
    2ee6:	00004517          	auipc	a0,0x4
    2eea:	0aa50513          	addi	a0,a0,170 # 6f90 <malloc+0x13b6>
    2eee:	435020ef          	jal	5b22 <printf>
    exit(1);
    2ef2:	4505                	li	a0,1
    2ef4:	7e0020ef          	jal	56d4 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef8:	85ca                	mv	a1,s2
    2efa:	00004517          	auipc	a0,0x4
    2efe:	0ce50513          	addi	a0,a0,206 # 6fc8 <malloc+0x13ee>
    2f02:	421020ef          	jal	5b22 <printf>
    exit(1);
    2f06:	4505                	li	a0,1
    2f08:	7cc020ef          	jal	56d4 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f0c:	85ca                	mv	a1,s2
    2f0e:	00004517          	auipc	a0,0x4
    2f12:	0da50513          	addi	a0,a0,218 # 6fe8 <malloc+0x140e>
    2f16:	40d020ef          	jal	5b22 <printf>
    exit(1);
    2f1a:	4505                	li	a0,1
    2f1c:	7b8020ef          	jal	56d4 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f20:	85ca                	mv	a1,s2
    2f22:	00004517          	auipc	a0,0x4
    2f26:	0f650513          	addi	a0,a0,246 # 7018 <malloc+0x143e>
    2f2a:	3f9020ef          	jal	5b22 <printf>
    exit(1);
    2f2e:	4505                	li	a0,1
    2f30:	7a4020ef          	jal	56d4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f34:	85ca                	mv	a1,s2
    2f36:	00004517          	auipc	a0,0x4
    2f3a:	10a50513          	addi	a0,a0,266 # 7040 <malloc+0x1466>
    2f3e:	3e5020ef          	jal	5b22 <printf>
    exit(1);
    2f42:	4505                	li	a0,1
    2f44:	790020ef          	jal	56d4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f48:	85ca                	mv	a1,s2
    2f4a:	00004517          	auipc	a0,0x4
    2f4e:	11650513          	addi	a0,a0,278 # 7060 <malloc+0x1486>
    2f52:	3d1020ef          	jal	5b22 <printf>
    exit(1);
    2f56:	4505                	li	a0,1
    2f58:	77c020ef          	jal	56d4 <exit>
    printf("%s: chdir dd failed\n", s);
    2f5c:	85ca                	mv	a1,s2
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	12a50513          	addi	a0,a0,298 # 7088 <malloc+0x14ae>
    2f66:	3bd020ef          	jal	5b22 <printf>
    exit(1);
    2f6a:	4505                	li	a0,1
    2f6c:	768020ef          	jal	56d4 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f70:	85ca                	mv	a1,s2
    2f72:	00004517          	auipc	a0,0x4
    2f76:	13e50513          	addi	a0,a0,318 # 70b0 <malloc+0x14d6>
    2f7a:	3a9020ef          	jal	5b22 <printf>
    exit(1);
    2f7e:	4505                	li	a0,1
    2f80:	754020ef          	jal	56d4 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f84:	85ca                	mv	a1,s2
    2f86:	00004517          	auipc	a0,0x4
    2f8a:	15a50513          	addi	a0,a0,346 # 70e0 <malloc+0x1506>
    2f8e:	395020ef          	jal	5b22 <printf>
    exit(1);
    2f92:	4505                	li	a0,1
    2f94:	740020ef          	jal	56d4 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f98:	85ca                	mv	a1,s2
    2f9a:	00004517          	auipc	a0,0x4
    2f9e:	17650513          	addi	a0,a0,374 # 7110 <malloc+0x1536>
    2fa2:	381020ef          	jal	5b22 <printf>
    exit(1);
    2fa6:	4505                	li	a0,1
    2fa8:	72c020ef          	jal	56d4 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fac:	85ca                	mv	a1,s2
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	17a50513          	addi	a0,a0,378 # 7128 <malloc+0x154e>
    2fb6:	36d020ef          	jal	5b22 <printf>
    exit(1);
    2fba:	4505                	li	a0,1
    2fbc:	718020ef          	jal	56d4 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fc0:	85ca                	mv	a1,s2
    2fc2:	00004517          	auipc	a0,0x4
    2fc6:	18650513          	addi	a0,a0,390 # 7148 <malloc+0x156e>
    2fca:	359020ef          	jal	5b22 <printf>
    exit(1);
    2fce:	4505                	li	a0,1
    2fd0:	704020ef          	jal	56d4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd4:	85ca                	mv	a1,s2
    2fd6:	00004517          	auipc	a0,0x4
    2fda:	19250513          	addi	a0,a0,402 # 7168 <malloc+0x158e>
    2fde:	345020ef          	jal	5b22 <printf>
    exit(1);
    2fe2:	4505                	li	a0,1
    2fe4:	6f0020ef          	jal	56d4 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe8:	85ca                	mv	a1,s2
    2fea:	00004517          	auipc	a0,0x4
    2fee:	1be50513          	addi	a0,a0,446 # 71a8 <malloc+0x15ce>
    2ff2:	331020ef          	jal	5b22 <printf>
    exit(1);
    2ff6:	4505                	li	a0,1
    2ff8:	6dc020ef          	jal	56d4 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ffc:	85ca                	mv	a1,s2
    2ffe:	00004517          	auipc	a0,0x4
    3002:	1da50513          	addi	a0,a0,474 # 71d8 <malloc+0x15fe>
    3006:	31d020ef          	jal	5b22 <printf>
    exit(1);
    300a:	4505                	li	a0,1
    300c:	6c8020ef          	jal	56d4 <exit>
    printf("%s: create dd succeeded!\n", s);
    3010:	85ca                	mv	a1,s2
    3012:	00004517          	auipc	a0,0x4
    3016:	1e650513          	addi	a0,a0,486 # 71f8 <malloc+0x161e>
    301a:	309020ef          	jal	5b22 <printf>
    exit(1);
    301e:	4505                	li	a0,1
    3020:	6b4020ef          	jal	56d4 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3024:	85ca                	mv	a1,s2
    3026:	00004517          	auipc	a0,0x4
    302a:	1f250513          	addi	a0,a0,498 # 7218 <malloc+0x163e>
    302e:	2f5020ef          	jal	5b22 <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	6a0020ef          	jal	56d4 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3038:	85ca                	mv	a1,s2
    303a:	00004517          	auipc	a0,0x4
    303e:	1fe50513          	addi	a0,a0,510 # 7238 <malloc+0x165e>
    3042:	2e1020ef          	jal	5b22 <printf>
    exit(1);
    3046:	4505                	li	a0,1
    3048:	68c020ef          	jal	56d4 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    304c:	85ca                	mv	a1,s2
    304e:	00004517          	auipc	a0,0x4
    3052:	21a50513          	addi	a0,a0,538 # 7268 <malloc+0x168e>
    3056:	2cd020ef          	jal	5b22 <printf>
    exit(1);
    305a:	4505                	li	a0,1
    305c:	678020ef          	jal	56d4 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3060:	85ca                	mv	a1,s2
    3062:	00004517          	auipc	a0,0x4
    3066:	22e50513          	addi	a0,a0,558 # 7290 <malloc+0x16b6>
    306a:	2b9020ef          	jal	5b22 <printf>
    exit(1);
    306e:	4505                	li	a0,1
    3070:	664020ef          	jal	56d4 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3074:	85ca                	mv	a1,s2
    3076:	00004517          	auipc	a0,0x4
    307a:	24250513          	addi	a0,a0,578 # 72b8 <malloc+0x16de>
    307e:	2a5020ef          	jal	5b22 <printf>
    exit(1);
    3082:	4505                	li	a0,1
    3084:	650020ef          	jal	56d4 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3088:	85ca                	mv	a1,s2
    308a:	00004517          	auipc	a0,0x4
    308e:	25650513          	addi	a0,a0,598 # 72e0 <malloc+0x1706>
    3092:	291020ef          	jal	5b22 <printf>
    exit(1);
    3096:	4505                	li	a0,1
    3098:	63c020ef          	jal	56d4 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    309c:	85ca                	mv	a1,s2
    309e:	00004517          	auipc	a0,0x4
    30a2:	26250513          	addi	a0,a0,610 # 7300 <malloc+0x1726>
    30a6:	27d020ef          	jal	5b22 <printf>
    exit(1);
    30aa:	4505                	li	a0,1
    30ac:	628020ef          	jal	56d4 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30b0:	85ca                	mv	a1,s2
    30b2:	00004517          	auipc	a0,0x4
    30b6:	26e50513          	addi	a0,a0,622 # 7320 <malloc+0x1746>
    30ba:	269020ef          	jal	5b22 <printf>
    exit(1);
    30be:	4505                	li	a0,1
    30c0:	614020ef          	jal	56d4 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c4:	85ca                	mv	a1,s2
    30c6:	00004517          	auipc	a0,0x4
    30ca:	28250513          	addi	a0,a0,642 # 7348 <malloc+0x176e>
    30ce:	255020ef          	jal	5b22 <printf>
    exit(1);
    30d2:	4505                	li	a0,1
    30d4:	600020ef          	jal	56d4 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d8:	85ca                	mv	a1,s2
    30da:	00004517          	auipc	a0,0x4
    30de:	28e50513          	addi	a0,a0,654 # 7368 <malloc+0x178e>
    30e2:	241020ef          	jal	5b22 <printf>
    exit(1);
    30e6:	4505                	li	a0,1
    30e8:	5ec020ef          	jal	56d4 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30ec:	85ca                	mv	a1,s2
    30ee:	00004517          	auipc	a0,0x4
    30f2:	29a50513          	addi	a0,a0,666 # 7388 <malloc+0x17ae>
    30f6:	22d020ef          	jal	5b22 <printf>
    exit(1);
    30fa:	4505                	li	a0,1
    30fc:	5d8020ef          	jal	56d4 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3100:	85ca                	mv	a1,s2
    3102:	00004517          	auipc	a0,0x4
    3106:	2ae50513          	addi	a0,a0,686 # 73b0 <malloc+0x17d6>
    310a:	219020ef          	jal	5b22 <printf>
    exit(1);
    310e:	4505                	li	a0,1
    3110:	5c4020ef          	jal	56d4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3114:	85ca                	mv	a1,s2
    3116:	00004517          	auipc	a0,0x4
    311a:	f2a50513          	addi	a0,a0,-214 # 7040 <malloc+0x1466>
    311e:	205020ef          	jal	5b22 <printf>
    exit(1);
    3122:	4505                	li	a0,1
    3124:	5b0020ef          	jal	56d4 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3128:	85ca                	mv	a1,s2
    312a:	00004517          	auipc	a0,0x4
    312e:	2a650513          	addi	a0,a0,678 # 73d0 <malloc+0x17f6>
    3132:	1f1020ef          	jal	5b22 <printf>
    exit(1);
    3136:	4505                	li	a0,1
    3138:	59c020ef          	jal	56d4 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    313c:	85ca                	mv	a1,s2
    313e:	00004517          	auipc	a0,0x4
    3142:	2b250513          	addi	a0,a0,690 # 73f0 <malloc+0x1816>
    3146:	1dd020ef          	jal	5b22 <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	588020ef          	jal	56d4 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3150:	85ca                	mv	a1,s2
    3152:	00004517          	auipc	a0,0x4
    3156:	2ce50513          	addi	a0,a0,718 # 7420 <malloc+0x1846>
    315a:	1c9020ef          	jal	5b22 <printf>
    exit(1);
    315e:	4505                	li	a0,1
    3160:	574020ef          	jal	56d4 <exit>
    printf("%s: unlink dd failed\n", s);
    3164:	85ca                	mv	a1,s2
    3166:	00004517          	auipc	a0,0x4
    316a:	2da50513          	addi	a0,a0,730 # 7440 <malloc+0x1866>
    316e:	1b5020ef          	jal	5b22 <printf>
    exit(1);
    3172:	4505                	li	a0,1
    3174:	560020ef          	jal	56d4 <exit>

0000000000003178 <rmdot>:
{
    3178:	1101                	addi	sp,sp,-32
    317a:	ec06                	sd	ra,24(sp)
    317c:	e822                	sd	s0,16(sp)
    317e:	e426                	sd	s1,8(sp)
    3180:	1000                	addi	s0,sp,32
    3182:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3184:	00004517          	auipc	a0,0x4
    3188:	2d450513          	addi	a0,a0,724 # 7458 <malloc+0x187e>
    318c:	5b0020ef          	jal	573c <mkdir>
    3190:	e53d                	bnez	a0,31fe <rmdot+0x86>
  if (chdir("dots") != 0) {
    3192:	00004517          	auipc	a0,0x4
    3196:	2c650513          	addi	a0,a0,710 # 7458 <malloc+0x187e>
    319a:	5aa020ef          	jal	5744 <chdir>
    319e:	e935                	bnez	a0,3212 <rmdot+0x9a>
  if (unlink(".") == 0) {
    31a0:	00003517          	auipc	a0,0x3
    31a4:	25050513          	addi	a0,a0,592 # 63f0 <malloc+0x816>
    31a8:	57c020ef          	jal	5724 <unlink>
    31ac:	cd2d                	beqz	a0,3226 <rmdot+0xae>
  if (unlink("..") == 0) {
    31ae:	00004517          	auipc	a0,0x4
    31b2:	cfa50513          	addi	a0,a0,-774 # 6ea8 <malloc+0x12ce>
    31b6:	56e020ef          	jal	5724 <unlink>
    31ba:	c141                	beqz	a0,323a <rmdot+0xc2>
  if (chdir("/") != 0) {
    31bc:	00004517          	auipc	a0,0x4
    31c0:	c9450513          	addi	a0,a0,-876 # 6e50 <malloc+0x1276>
    31c4:	580020ef          	jal	5744 <chdir>
    31c8:	e159                	bnez	a0,324e <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31ca:	00004517          	auipc	a0,0x4
    31ce:	2f650513          	addi	a0,a0,758 # 74c0 <malloc+0x18e6>
    31d2:	552020ef          	jal	5724 <unlink>
    31d6:	c551                	beqz	a0,3262 <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31d8:	00004517          	auipc	a0,0x4
    31dc:	31050513          	addi	a0,a0,784 # 74e8 <malloc+0x190e>
    31e0:	544020ef          	jal	5724 <unlink>
    31e4:	c949                	beqz	a0,3276 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31e6:	00004517          	auipc	a0,0x4
    31ea:	27250513          	addi	a0,a0,626 # 7458 <malloc+0x187e>
    31ee:	536020ef          	jal	5724 <unlink>
    31f2:	ed41                	bnez	a0,328a <rmdot+0x112>
}
    31f4:	60e2                	ld	ra,24(sp)
    31f6:	6442                	ld	s0,16(sp)
    31f8:	64a2                	ld	s1,8(sp)
    31fa:	6105                	addi	sp,sp,32
    31fc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fe:	85a6                	mv	a1,s1
    3200:	00004517          	auipc	a0,0x4
    3204:	26050513          	addi	a0,a0,608 # 7460 <malloc+0x1886>
    3208:	11b020ef          	jal	5b22 <printf>
    exit(1);
    320c:	4505                	li	a0,1
    320e:	4c6020ef          	jal	56d4 <exit>
    printf("%s: chdir dots failed\n", s);
    3212:	85a6                	mv	a1,s1
    3214:	00004517          	auipc	a0,0x4
    3218:	26450513          	addi	a0,a0,612 # 7478 <malloc+0x189e>
    321c:	107020ef          	jal	5b22 <printf>
    exit(1);
    3220:	4505                	li	a0,1
    3222:	4b2020ef          	jal	56d4 <exit>
    printf("%s: rm . worked!\n", s);
    3226:	85a6                	mv	a1,s1
    3228:	00004517          	auipc	a0,0x4
    322c:	26850513          	addi	a0,a0,616 # 7490 <malloc+0x18b6>
    3230:	0f3020ef          	jal	5b22 <printf>
    exit(1);
    3234:	4505                	li	a0,1
    3236:	49e020ef          	jal	56d4 <exit>
    printf("%s: rm .. worked!\n", s);
    323a:	85a6                	mv	a1,s1
    323c:	00004517          	auipc	a0,0x4
    3240:	26c50513          	addi	a0,a0,620 # 74a8 <malloc+0x18ce>
    3244:	0df020ef          	jal	5b22 <printf>
    exit(1);
    3248:	4505                	li	a0,1
    324a:	48a020ef          	jal	56d4 <exit>
    printf("%s: chdir / failed\n", s);
    324e:	85a6                	mv	a1,s1
    3250:	00004517          	auipc	a0,0x4
    3254:	c0850513          	addi	a0,a0,-1016 # 6e58 <malloc+0x127e>
    3258:	0cb020ef          	jal	5b22 <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	476020ef          	jal	56d4 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3262:	85a6                	mv	a1,s1
    3264:	00004517          	auipc	a0,0x4
    3268:	26450513          	addi	a0,a0,612 # 74c8 <malloc+0x18ee>
    326c:	0b7020ef          	jal	5b22 <printf>
    exit(1);
    3270:	4505                	li	a0,1
    3272:	462020ef          	jal	56d4 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3276:	85a6                	mv	a1,s1
    3278:	00004517          	auipc	a0,0x4
    327c:	27850513          	addi	a0,a0,632 # 74f0 <malloc+0x1916>
    3280:	0a3020ef          	jal	5b22 <printf>
    exit(1);
    3284:	4505                	li	a0,1
    3286:	44e020ef          	jal	56d4 <exit>
    printf("%s: unlink dots failed!\n", s);
    328a:	85a6                	mv	a1,s1
    328c:	00004517          	auipc	a0,0x4
    3290:	28450513          	addi	a0,a0,644 # 7510 <malloc+0x1936>
    3294:	08f020ef          	jal	5b22 <printf>
    exit(1);
    3298:	4505                	li	a0,1
    329a:	43a020ef          	jal	56d4 <exit>

000000000000329e <dirfile>:
{
    329e:	1101                	addi	sp,sp,-32
    32a0:	ec06                	sd	ra,24(sp)
    32a2:	e822                	sd	s0,16(sp)
    32a4:	e426                	sd	s1,8(sp)
    32a6:	e04a                	sd	s2,0(sp)
    32a8:	1000                	addi	s0,sp,32
    32aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32ac:	20000593          	li	a1,512
    32b0:	00004517          	auipc	a0,0x4
    32b4:	28050513          	addi	a0,a0,640 # 7530 <malloc+0x1956>
    32b8:	45c020ef          	jal	5714 <open>
  if (fd < 0) {
    32bc:	0c054563          	bltz	a0,3386 <dirfile+0xe8>
  close(fd);
    32c0:	43c020ef          	jal	56fc <close>
  if (chdir("dirfile") == 0) {
    32c4:	00004517          	auipc	a0,0x4
    32c8:	26c50513          	addi	a0,a0,620 # 7530 <malloc+0x1956>
    32cc:	478020ef          	jal	5744 <chdir>
    32d0:	c569                	beqz	a0,339a <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32d2:	4581                	li	a1,0
    32d4:	00004517          	auipc	a0,0x4
    32d8:	2a450513          	addi	a0,a0,676 # 7578 <malloc+0x199e>
    32dc:	438020ef          	jal	5714 <open>
  if (fd >= 0) {
    32e0:	0c055763          	bgez	a0,33ae <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e4:	20000593          	li	a1,512
    32e8:	00004517          	auipc	a0,0x4
    32ec:	29050513          	addi	a0,a0,656 # 7578 <malloc+0x199e>
    32f0:	424020ef          	jal	5714 <open>
  if (fd >= 0) {
    32f4:	0c055763          	bgez	a0,33c2 <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32f8:	00004517          	auipc	a0,0x4
    32fc:	28050513          	addi	a0,a0,640 # 7578 <malloc+0x199e>
    3300:	43c020ef          	jal	573c <mkdir>
    3304:	0c050963          	beqz	a0,33d6 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    3308:	00004517          	auipc	a0,0x4
    330c:	27050513          	addi	a0,a0,624 # 7578 <malloc+0x199e>
    3310:	414020ef          	jal	5724 <unlink>
    3314:	0c050b63          	beqz	a0,33ea <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    3318:	00004597          	auipc	a1,0x4
    331c:	26058593          	addi	a1,a1,608 # 7578 <malloc+0x199e>
    3320:	00003517          	auipc	a0,0x3
    3324:	bc050513          	addi	a0,a0,-1088 # 5ee0 <malloc+0x306>
    3328:	40c020ef          	jal	5734 <link>
    332c:	0c050963          	beqz	a0,33fe <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    3330:	00004517          	auipc	a0,0x4
    3334:	20050513          	addi	a0,a0,512 # 7530 <malloc+0x1956>
    3338:	3ec020ef          	jal	5724 <unlink>
    333c:	0c051b63          	bnez	a0,3412 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3340:	4589                	li	a1,2
    3342:	00003517          	auipc	a0,0x3
    3346:	0ae50513          	addi	a0,a0,174 # 63f0 <malloc+0x816>
    334a:	3ca020ef          	jal	5714 <open>
  if (fd >= 0) {
    334e:	0c055c63          	bgez	a0,3426 <dirfile+0x188>
  fd = open(".", 0);
    3352:	4581                	li	a1,0
    3354:	00003517          	auipc	a0,0x3
    3358:	09c50513          	addi	a0,a0,156 # 63f0 <malloc+0x816>
    335c:	3b8020ef          	jal	5714 <open>
    3360:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    3362:	4605                	li	a2,1
    3364:	00003597          	auipc	a1,0x3
    3368:	a1458593          	addi	a1,a1,-1516 # 5d78 <malloc+0x19e>
    336c:	388020ef          	jal	56f4 <write>
    3370:	0ca04563          	bgtz	a0,343a <dirfile+0x19c>
  close(fd);
    3374:	8526                	mv	a0,s1
    3376:	386020ef          	jal	56fc <close>
}
    337a:	60e2                	ld	ra,24(sp)
    337c:	6442                	ld	s0,16(sp)
    337e:	64a2                	ld	s1,8(sp)
    3380:	6902                	ld	s2,0(sp)
    3382:	6105                	addi	sp,sp,32
    3384:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3386:	85ca                	mv	a1,s2
    3388:	00004517          	auipc	a0,0x4
    338c:	1b050513          	addi	a0,a0,432 # 7538 <malloc+0x195e>
    3390:	792020ef          	jal	5b22 <printf>
    exit(1);
    3394:	4505                	li	a0,1
    3396:	33e020ef          	jal	56d4 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00004517          	auipc	a0,0x4
    33a0:	1bc50513          	addi	a0,a0,444 # 7558 <malloc+0x197e>
    33a4:	77e020ef          	jal	5b22 <printf>
    exit(1);
    33a8:	4505                	li	a0,1
    33aa:	32a020ef          	jal	56d4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33ae:	85ca                	mv	a1,s2
    33b0:	00004517          	auipc	a0,0x4
    33b4:	1d850513          	addi	a0,a0,472 # 7588 <malloc+0x19ae>
    33b8:	76a020ef          	jal	5b22 <printf>
    exit(1);
    33bc:	4505                	li	a0,1
    33be:	316020ef          	jal	56d4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33c2:	85ca                	mv	a1,s2
    33c4:	00004517          	auipc	a0,0x4
    33c8:	1c450513          	addi	a0,a0,452 # 7588 <malloc+0x19ae>
    33cc:	756020ef          	jal	5b22 <printf>
    exit(1);
    33d0:	4505                	li	a0,1
    33d2:	302020ef          	jal	56d4 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d6:	85ca                	mv	a1,s2
    33d8:	00004517          	auipc	a0,0x4
    33dc:	1d850513          	addi	a0,a0,472 # 75b0 <malloc+0x19d6>
    33e0:	742020ef          	jal	5b22 <printf>
    exit(1);
    33e4:	4505                	li	a0,1
    33e6:	2ee020ef          	jal	56d4 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33ea:	85ca                	mv	a1,s2
    33ec:	00004517          	auipc	a0,0x4
    33f0:	1ec50513          	addi	a0,a0,492 # 75d8 <malloc+0x19fe>
    33f4:	72e020ef          	jal	5b22 <printf>
    exit(1);
    33f8:	4505                	li	a0,1
    33fa:	2da020ef          	jal	56d4 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fe:	85ca                	mv	a1,s2
    3400:	00004517          	auipc	a0,0x4
    3404:	20050513          	addi	a0,a0,512 # 7600 <malloc+0x1a26>
    3408:	71a020ef          	jal	5b22 <printf>
    exit(1);
    340c:	4505                	li	a0,1
    340e:	2c6020ef          	jal	56d4 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3412:	85ca                	mv	a1,s2
    3414:	00004517          	auipc	a0,0x4
    3418:	21450513          	addi	a0,a0,532 # 7628 <malloc+0x1a4e>
    341c:	706020ef          	jal	5b22 <printf>
    exit(1);
    3420:	4505                	li	a0,1
    3422:	2b2020ef          	jal	56d4 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3426:	85ca                	mv	a1,s2
    3428:	00004517          	auipc	a0,0x4
    342c:	22050513          	addi	a0,a0,544 # 7648 <malloc+0x1a6e>
    3430:	6f2020ef          	jal	5b22 <printf>
    exit(1);
    3434:	4505                	li	a0,1
    3436:	29e020ef          	jal	56d4 <exit>
    printf("%s: write . succeeded!\n", s);
    343a:	85ca                	mv	a1,s2
    343c:	00004517          	auipc	a0,0x4
    3440:	23450513          	addi	a0,a0,564 # 7670 <malloc+0x1a96>
    3444:	6de020ef          	jal	5b22 <printf>
    exit(1);
    3448:	4505                	li	a0,1
    344a:	28a020ef          	jal	56d4 <exit>

000000000000344e <iref>:
{
    344e:	715d                	addi	sp,sp,-80
    3450:	e486                	sd	ra,72(sp)
    3452:	e0a2                	sd	s0,64(sp)
    3454:	fc26                	sd	s1,56(sp)
    3456:	f84a                	sd	s2,48(sp)
    3458:	f44e                	sd	s3,40(sp)
    345a:	f052                	sd	s4,32(sp)
    345c:	ec56                	sd	s5,24(sp)
    345e:	e85a                	sd	s6,16(sp)
    3460:	e45e                	sd	s7,8(sp)
    3462:	0880                	addi	s0,sp,80
    3464:	8baa                	mv	s7,a0
    3466:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    346a:	00004a97          	auipc	s5,0x4
    346e:	21ea8a93          	addi	s5,s5,542 # 7688 <malloc+0x1aae>
    mkdir("");
    3472:	00004497          	auipc	s1,0x4
    3476:	d1e48493          	addi	s1,s1,-738 # 7190 <malloc+0x15b6>
    link("README", "");
    347a:	00003b17          	auipc	s6,0x3
    347e:	a66b0b13          	addi	s6,s6,-1434 # 5ee0 <malloc+0x306>
    fd = open("", O_CREATE);
    3482:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3486:	00004997          	auipc	s3,0x4
    348a:	0fa98993          	addi	s3,s3,250 # 7580 <malloc+0x19a6>
    348e:	a835                	j	34ca <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3490:	85de                	mv	a1,s7
    3492:	00004517          	auipc	a0,0x4
    3496:	1fe50513          	addi	a0,a0,510 # 7690 <malloc+0x1ab6>
    349a:	688020ef          	jal	5b22 <printf>
      exit(1);
    349e:	4505                	li	a0,1
    34a0:	234020ef          	jal	56d4 <exit>
      printf("%s: chdir irefd failed\n", s);
    34a4:	85de                	mv	a1,s7
    34a6:	00004517          	auipc	a0,0x4
    34aa:	20250513          	addi	a0,a0,514 # 76a8 <malloc+0x1ace>
    34ae:	674020ef          	jal	5b22 <printf>
      exit(1);
    34b2:	4505                	li	a0,1
    34b4:	220020ef          	jal	56d4 <exit>
      close(fd);
    34b8:	244020ef          	jal	56fc <close>
    34bc:	a825                	j	34f4 <iref+0xa6>
    unlink("xx");
    34be:	854e                	mv	a0,s3
    34c0:	264020ef          	jal	5724 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34c4:	397d                	addiw	s2,s2,-1
    34c6:	04090063          	beqz	s2,3506 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34ca:	8556                	mv	a0,s5
    34cc:	270020ef          	jal	573c <mkdir>
    34d0:	f161                	bnez	a0,3490 <iref+0x42>
    if (chdir("irefd") != 0) {
    34d2:	8556                	mv	a0,s5
    34d4:	270020ef          	jal	5744 <chdir>
    34d8:	f571                	bnez	a0,34a4 <iref+0x56>
    mkdir("");
    34da:	8526                	mv	a0,s1
    34dc:	260020ef          	jal	573c <mkdir>
    link("README", "");
    34e0:	85a6                	mv	a1,s1
    34e2:	855a                	mv	a0,s6
    34e4:	250020ef          	jal	5734 <link>
    fd = open("", O_CREATE);
    34e8:	85d2                	mv	a1,s4
    34ea:	8526                	mv	a0,s1
    34ec:	228020ef          	jal	5714 <open>
    if (fd >= 0)
    34f0:	fc0554e3          	bgez	a0,34b8 <iref+0x6a>
    fd = open("xx", O_CREATE);
    34f4:	85d2                	mv	a1,s4
    34f6:	854e                	mv	a0,s3
    34f8:	21c020ef          	jal	5714 <open>
    if (fd >= 0)
    34fc:	fc0541e3          	bltz	a0,34be <iref+0x70>
      close(fd);
    3500:	1fc020ef          	jal	56fc <close>
    3504:	bf6d                	j	34be <iref+0x70>
    3506:	03300493          	li	s1,51
    chdir("..");
    350a:	00004997          	auipc	s3,0x4
    350e:	99e98993          	addi	s3,s3,-1634 # 6ea8 <malloc+0x12ce>
    unlink("irefd");
    3512:	00004917          	auipc	s2,0x4
    3516:	17690913          	addi	s2,s2,374 # 7688 <malloc+0x1aae>
    chdir("..");
    351a:	854e                	mv	a0,s3
    351c:	228020ef          	jal	5744 <chdir>
    unlink("irefd");
    3520:	854a                	mv	a0,s2
    3522:	202020ef          	jal	5724 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3526:	34fd                	addiw	s1,s1,-1
    3528:	f8ed                	bnez	s1,351a <iref+0xcc>
  chdir("/");
    352a:	00004517          	auipc	a0,0x4
    352e:	92650513          	addi	a0,a0,-1754 # 6e50 <malloc+0x1276>
    3532:	212020ef          	jal	5744 <chdir>
}
    3536:	60a6                	ld	ra,72(sp)
    3538:	6406                	ld	s0,64(sp)
    353a:	74e2                	ld	s1,56(sp)
    353c:	7942                	ld	s2,48(sp)
    353e:	79a2                	ld	s3,40(sp)
    3540:	7a02                	ld	s4,32(sp)
    3542:	6ae2                	ld	s5,24(sp)
    3544:	6b42                	ld	s6,16(sp)
    3546:	6ba2                	ld	s7,8(sp)
    3548:	6161                	addi	sp,sp,80
    354a:	8082                	ret

000000000000354c <unlinkcwd>:
{
    354c:	1101                	addi	sp,sp,-32
    354e:	ec06                	sd	ra,24(sp)
    3550:	e822                	sd	s0,16(sp)
    3552:	e426                	sd	s1,8(sp)
    3554:	1000                	addi	s0,sp,32
    3556:	84aa                	mv	s1,a0
  if (mkdir("/a") < 0) {
    3558:	00004517          	auipc	a0,0x4
    355c:	16850513          	addi	a0,a0,360 # 76c0 <malloc+0x1ae6>
    3560:	1dc020ef          	jal	573c <mkdir>
    3564:	06054a63          	bltz	a0,35d8 <unlinkcwd+0x8c>
  if (mkdir("/a/b") < 0) {
    3568:	00004517          	auipc	a0,0x4
    356c:	17850513          	addi	a0,a0,376 # 76e0 <malloc+0x1b06>
    3570:	1cc020ef          	jal	573c <mkdir>
    3574:	06054c63          	bltz	a0,35ec <unlinkcwd+0xa0>
  if (chdir("/a/b") < 0) {
    3578:	00004517          	auipc	a0,0x4
    357c:	16850513          	addi	a0,a0,360 # 76e0 <malloc+0x1b06>
    3580:	1c4020ef          	jal	5744 <chdir>
    3584:	06054e63          	bltz	a0,3600 <unlinkcwd+0xb4>
  if (unlink("/a/b") < 0) {
    3588:	00004517          	auipc	a0,0x4
    358c:	15850513          	addi	a0,a0,344 # 76e0 <malloc+0x1b06>
    3590:	194020ef          	jal	5724 <unlink>
    3594:	08054063          	bltz	a0,3614 <unlinkcwd+0xc8>
  if (unlink("/a") < 0) {
    3598:	00004517          	auipc	a0,0x4
    359c:	12850513          	addi	a0,a0,296 # 76c0 <malloc+0x1ae6>
    35a0:	184020ef          	jal	5724 <unlink>
    35a4:	08054263          	bltz	a0,3628 <unlinkcwd+0xdc>
  if (open("../", O_RDONLY) > 0) {
    35a8:	4581                	li	a1,0
    35aa:	00004517          	auipc	a0,0x4
    35ae:	19e50513          	addi	a0,a0,414 # 7748 <malloc+0x1b6e>
    35b2:	162020ef          	jal	5714 <open>
    35b6:	08a04363          	bgtz	a0,363c <unlinkcwd+0xf0>
  if (open("../c", O_CREATE) > 0) {
    35ba:	20000593          	li	a1,512
    35be:	00004517          	auipc	a0,0x4
    35c2:	1ba50513          	addi	a0,a0,442 # 7778 <malloc+0x1b9e>
    35c6:	14e020ef          	jal	5714 <open>
    35ca:	08a04163          	bgtz	a0,364c <unlinkcwd+0x100>
}
    35ce:	60e2                	ld	ra,24(sp)
    35d0:	6442                	ld	s0,16(sp)
    35d2:	64a2                	ld	s1,8(sp)
    35d4:	6105                	addi	sp,sp,32
    35d6:	8082                	ret
    printf("%s: mkdir /a failed\n", s);
    35d8:	85a6                	mv	a1,s1
    35da:	00004517          	auipc	a0,0x4
    35de:	0ee50513          	addi	a0,a0,238 # 76c8 <malloc+0x1aee>
    35e2:	540020ef          	jal	5b22 <printf>
    exit(1);
    35e6:	4505                	li	a0,1
    35e8:	0ec020ef          	jal	56d4 <exit>
    printf("%s: mkdir /a/b failed\n", s);
    35ec:	85a6                	mv	a1,s1
    35ee:	00004517          	auipc	a0,0x4
    35f2:	0fa50513          	addi	a0,a0,250 # 76e8 <malloc+0x1b0e>
    35f6:	52c020ef          	jal	5b22 <printf>
    exit(1);
    35fa:	4505                	li	a0,1
    35fc:	0d8020ef          	jal	56d4 <exit>
    printf("%s: chdir failed\n", s);
    3600:	85a6                	mv	a1,s1
    3602:	00004517          	auipc	a0,0x4
    3606:	0fe50513          	addi	a0,a0,254 # 7700 <malloc+0x1b26>
    360a:	518020ef          	jal	5b22 <printf>
    exit(1);
    360e:	4505                	li	a0,1
    3610:	0c4020ef          	jal	56d4 <exit>
    printf("%s: unlink /a/b failed\n", s);
    3614:	85a6                	mv	a1,s1
    3616:	00004517          	auipc	a0,0x4
    361a:	10250513          	addi	a0,a0,258 # 7718 <malloc+0x1b3e>
    361e:	504020ef          	jal	5b22 <printf>
    exit(1);
    3622:	4505                	li	a0,1
    3624:	0b0020ef          	jal	56d4 <exit>
    printf("%s: unlink /a failed\n", s);
    3628:	85a6                	mv	a1,s1
    362a:	00004517          	auipc	a0,0x4
    362e:	10650513          	addi	a0,a0,262 # 7730 <malloc+0x1b56>
    3632:	4f0020ef          	jal	5b22 <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	09c020ef          	jal	56d4 <exit>
    printf("%s: open ../ non-existing directory\n", s);
    363c:	85a6                	mv	a1,s1
    363e:	00004517          	auipc	a0,0x4
    3642:	11250513          	addi	a0,a0,274 # 7750 <malloc+0x1b76>
    3646:	4dc020ef          	jal	5b22 <printf>
    364a:	bf85                	j	35ba <unlinkcwd+0x6e>
    printf("%s: create ../c non-existing file\n", s);
    364c:	85a6                	mv	a1,s1
    364e:	00004517          	auipc	a0,0x4
    3652:	13250513          	addi	a0,a0,306 # 7780 <malloc+0x1ba6>
    3656:	4cc020ef          	jal	5b22 <printf>
}
    365a:	bf95                	j	35ce <unlinkcwd+0x82>

000000000000365c <openiputtest>:
{
    365c:	7179                	addi	sp,sp,-48
    365e:	f406                	sd	ra,40(sp)
    3660:	f022                	sd	s0,32(sp)
    3662:	ec26                	sd	s1,24(sp)
    3664:	1800                	addi	s0,sp,48
    3666:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3668:	00004517          	auipc	a0,0x4
    366c:	14050513          	addi	a0,a0,320 # 77a8 <malloc+0x1bce>
    3670:	0cc020ef          	jal	573c <mkdir>
    3674:	02054a63          	bltz	a0,36a8 <openiputtest+0x4c>
  pid = fork();
    3678:	054020ef          	jal	56cc <fork>
  if (pid < 0) {
    367c:	04054063          	bltz	a0,36bc <openiputtest+0x60>
  if (pid == 0) {
    3680:	e939                	bnez	a0,36d6 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3682:	4589                	li	a1,2
    3684:	00004517          	auipc	a0,0x4
    3688:	12450513          	addi	a0,a0,292 # 77a8 <malloc+0x1bce>
    368c:	088020ef          	jal	5714 <open>
    if (fd >= 0) {
    3690:	04054063          	bltz	a0,36d0 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3694:	85a6                	mv	a1,s1
    3696:	00004517          	auipc	a0,0x4
    369a:	13250513          	addi	a0,a0,306 # 77c8 <malloc+0x1bee>
    369e:	484020ef          	jal	5b22 <printf>
      exit(1);
    36a2:	4505                	li	a0,1
    36a4:	030020ef          	jal	56d4 <exit>
    printf("%s: mkdir oidir failed\n", s);
    36a8:	85a6                	mv	a1,s1
    36aa:	00004517          	auipc	a0,0x4
    36ae:	10650513          	addi	a0,a0,262 # 77b0 <malloc+0x1bd6>
    36b2:	470020ef          	jal	5b22 <printf>
    exit(1);
    36b6:	4505                	li	a0,1
    36b8:	01c020ef          	jal	56d4 <exit>
    printf("%s: fork failed\n", s);
    36bc:	85a6                	mv	a1,s1
    36be:	00003517          	auipc	a0,0x3
    36c2:	eda50513          	addi	a0,a0,-294 # 6598 <malloc+0x9be>
    36c6:	45c020ef          	jal	5b22 <printf>
    exit(1);
    36ca:	4505                	li	a0,1
    36cc:	008020ef          	jal	56d4 <exit>
    exit(0);
    36d0:	4501                	li	a0,0
    36d2:	002020ef          	jal	56d4 <exit>
  pause(1);
    36d6:	4505                	li	a0,1
    36d8:	08c020ef          	jal	5764 <pause>
  if (unlink("oidir") != 0) {
    36dc:	00004517          	auipc	a0,0x4
    36e0:	0cc50513          	addi	a0,a0,204 # 77a8 <malloc+0x1bce>
    36e4:	040020ef          	jal	5724 <unlink>
    36e8:	c919                	beqz	a0,36fe <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    36ea:	85a6                	mv	a1,s1
    36ec:	00003517          	auipc	a0,0x3
    36f0:	03450513          	addi	a0,a0,52 # 6720 <malloc+0xb46>
    36f4:	42e020ef          	jal	5b22 <printf>
    exit(1);
    36f8:	4505                	li	a0,1
    36fa:	7db010ef          	jal	56d4 <exit>
  wait(&xstatus);
    36fe:	fdc40513          	addi	a0,s0,-36
    3702:	7db010ef          	jal	56dc <wait>
  exit(xstatus);
    3706:	fdc42503          	lw	a0,-36(s0)
    370a:	7cb010ef          	jal	56d4 <exit>

000000000000370e <forkforkfork>:
{
    370e:	1101                	addi	sp,sp,-32
    3710:	ec06                	sd	ra,24(sp)
    3712:	e822                	sd	s0,16(sp)
    3714:	e426                	sd	s1,8(sp)
    3716:	1000                	addi	s0,sp,32
    3718:	84aa                	mv	s1,a0
  unlink("stopforking");
    371a:	00004517          	auipc	a0,0x4
    371e:	0d650513          	addi	a0,a0,214 # 77f0 <malloc+0x1c16>
    3722:	002020ef          	jal	5724 <unlink>
  int pid = fork();
    3726:	7a7010ef          	jal	56cc <fork>
  if (pid < 0) {
    372a:	02054b63          	bltz	a0,3760 <forkforkfork+0x52>
  if (pid == 0) {
    372e:	c139                	beqz	a0,3774 <forkforkfork+0x66>
  pause(20); // two seconds
    3730:	4551                	li	a0,20
    3732:	032020ef          	jal	5764 <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3736:	20200593          	li	a1,514
    373a:	00004517          	auipc	a0,0x4
    373e:	0b650513          	addi	a0,a0,182 # 77f0 <malloc+0x1c16>
    3742:	7d3010ef          	jal	5714 <open>
    3746:	7b7010ef          	jal	56fc <close>
  wait(0);
    374a:	4501                	li	a0,0
    374c:	791010ef          	jal	56dc <wait>
  pause(10); // one second
    3750:	4529                	li	a0,10
    3752:	012020ef          	jal	5764 <pause>
}
    3756:	60e2                	ld	ra,24(sp)
    3758:	6442                	ld	s0,16(sp)
    375a:	64a2                	ld	s1,8(sp)
    375c:	6105                	addi	sp,sp,32
    375e:	8082                	ret
    printf("%s: fork failed", s);
    3760:	85a6                	mv	a1,s1
    3762:	00003517          	auipc	a0,0x3
    3766:	f7650513          	addi	a0,a0,-138 # 66d8 <malloc+0xafe>
    376a:	3b8020ef          	jal	5b22 <printf>
    exit(1);
    376e:	4505                	li	a0,1
    3770:	765010ef          	jal	56d4 <exit>
      int fd = open("stopforking", 0);
    3774:	4581                	li	a1,0
    3776:	00004517          	auipc	a0,0x4
    377a:	07a50513          	addi	a0,a0,122 # 77f0 <malloc+0x1c16>
    377e:	797010ef          	jal	5714 <open>
      if (fd >= 0) {
    3782:	02055163          	bgez	a0,37a4 <forkforkfork+0x96>
      if (fork() < 0) {
    3786:	747010ef          	jal	56cc <fork>
    378a:	fe0555e3          	bgez	a0,3774 <forkforkfork+0x66>
        close(open("stopforking", O_CREATE | O_RDWR));
    378e:	20200593          	li	a1,514
    3792:	00004517          	auipc	a0,0x4
    3796:	05e50513          	addi	a0,a0,94 # 77f0 <malloc+0x1c16>
    379a:	77b010ef          	jal	5714 <open>
    379e:	75f010ef          	jal	56fc <close>
    37a2:	bfc9                	j	3774 <forkforkfork+0x66>
        exit(0);
    37a4:	4501                	li	a0,0
    37a6:	72f010ef          	jal	56d4 <exit>

00000000000037aa <exectest>:
{
    37aa:	711d                	addi	sp,sp,-96
    37ac:	ec86                	sd	ra,88(sp)
    37ae:	e8a2                	sd	s0,80(sp)
    37b0:	e0ca                	sd	s2,64(sp)
    37b2:	1080                	addi	s0,sp,96
    37b4:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    37b6:	00002797          	auipc	a5,0x2
    37ba:	55278793          	addi	a5,a5,1362 # 5d08 <malloc+0x12e>
    37be:	faf43823          	sd	a5,-80(s0)
    37c2:	00004797          	auipc	a5,0x4
    37c6:	03e78793          	addi	a5,a5,62 # 7800 <malloc+0x1c26>
    37ca:	faf43c23          	sd	a5,-72(s0)
    37ce:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    37d2:	00004517          	auipc	a0,0x4
    37d6:	03650513          	addi	a0,a0,54 # 7808 <malloc+0x1c2e>
    37da:	74b010ef          	jal	5724 <unlink>
  pid = fork();
    37de:	6ef010ef          	jal	56cc <fork>
  if (pid < 0) {
    37e2:	04054763          	bltz	a0,3830 <exectest+0x86>
    37e6:	e4a6                	sd	s1,72(sp)
    37e8:	fc4e                	sd	s3,56(sp)
    37ea:	84aa                	mv	s1,a0
  if (pid == 0) {
    37ec:	ed49                	bnez	a0,3886 <exectest+0xdc>
    int errfd = dup(1);
    37ee:	4505                	li	a0,1
    37f0:	75d010ef          	jal	574c <dup>
    37f4:	89aa                	mv	s3,a0
    if (errfd < 0) {
    37f6:	04054963          	bltz	a0,3848 <exectest+0x9e>
    close(1);
    37fa:	4505                	li	a0,1
    37fc:	701010ef          	jal	56fc <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    3800:	20100593          	li	a1,513
    3804:	00004517          	auipc	a0,0x4
    3808:	00450513          	addi	a0,a0,4 # 7808 <malloc+0x1c2e>
    380c:	709010ef          	jal	5714 <open>
    if (fd < 0) {
    3810:	04054663          	bltz	a0,385c <exectest+0xb2>
    if (fd != 1) {
    3814:	4785                	li	a5,1
    3816:	04f50e63          	beq	a0,a5,3872 <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    381a:	864a                	mv	a2,s2
    381c:	00004597          	auipc	a1,0x4
    3820:	00458593          	addi	a1,a1,4 # 7820 <malloc+0x1c46>
    3824:	854e                	mv	a0,s3
    3826:	2d2020ef          	jal	5af8 <fprintf>
      exit(1);
    382a:	4505                	li	a0,1
    382c:	6a9010ef          	jal	56d4 <exit>
    3830:	e4a6                	sd	s1,72(sp)
    3832:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3834:	85ca                	mv	a1,s2
    3836:	00003517          	auipc	a0,0x3
    383a:	d6250513          	addi	a0,a0,-670 # 6598 <malloc+0x9be>
    383e:	2e4020ef          	jal	5b22 <printf>
    exit(1);
    3842:	4505                	li	a0,1
    3844:	691010ef          	jal	56d4 <exit>
      printf("%s: dup failed\n", s);
    3848:	85ca                	mv	a1,s2
    384a:	00004517          	auipc	a0,0x4
    384e:	fc650513          	addi	a0,a0,-58 # 7810 <malloc+0x1c36>
    3852:	2d0020ef          	jal	5b22 <printf>
      exit(1);
    3856:	4505                	li	a0,1
    3858:	67d010ef          	jal	56d4 <exit>
      fprintf(errfd, "%s: create failed\n", s);
    385c:	864a                	mv	a2,s2
    385e:	00003597          	auipc	a1,0x3
    3862:	eaa58593          	addi	a1,a1,-342 # 6708 <malloc+0xb2e>
    3866:	854e                	mv	a0,s3
    3868:	290020ef          	jal	5af8 <fprintf>
      exit(1);
    386c:	4505                	li	a0,1
    386e:	667010ef          	jal	56d4 <exit>
    if (exec("echo", echoargv) < 0) {
    3872:	fb040593          	addi	a1,s0,-80
    3876:	00002517          	auipc	a0,0x2
    387a:	49250513          	addi	a0,a0,1170 # 5d08 <malloc+0x12e>
    387e:	68f010ef          	jal	570c <exec>
    3882:	02054563          	bltz	a0,38ac <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3886:	fcc40513          	addi	a0,s0,-52
    388a:	653010ef          	jal	56dc <wait>
    388e:	02951a63          	bne	a0,s1,38c2 <exectest+0x118>
  if (xstatus != 0) {
    3892:	fcc42603          	lw	a2,-52(s0)
    3896:	ce15                	beqz	a2,38d2 <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3898:	85ca                	mv	a1,s2
    389a:	00004517          	auipc	a0,0x4
    389e:	fc650513          	addi	a0,a0,-58 # 7860 <malloc+0x1c86>
    38a2:	280020ef          	jal	5b22 <printf>
    exit(1);
    38a6:	4505                	li	a0,1
    38a8:	62d010ef          	jal	56d4 <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    38ac:	864a                	mv	a2,s2
    38ae:	00004597          	auipc	a1,0x4
    38b2:	f8258593          	addi	a1,a1,-126 # 7830 <malloc+0x1c56>
    38b6:	854e                	mv	a0,s3
    38b8:	240020ef          	jal	5af8 <fprintf>
      exit(1);
    38bc:	4505                	li	a0,1
    38be:	617010ef          	jal	56d4 <exit>
    printf("%s: wait failed!\n", s);
    38c2:	85ca                	mv	a1,s2
    38c4:	00004517          	auipc	a0,0x4
    38c8:	f8450513          	addi	a0,a0,-124 # 7848 <malloc+0x1c6e>
    38cc:	256020ef          	jal	5b22 <printf>
    38d0:	b7c9                	j	3892 <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    38d2:	4581                	li	a1,0
    38d4:	00004517          	auipc	a0,0x4
    38d8:	f3450513          	addi	a0,a0,-204 # 7808 <malloc+0x1c2e>
    38dc:	639010ef          	jal	5714 <open>
  if (fd < 0) {
    38e0:	02054463          	bltz	a0,3908 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    38e4:	4609                	li	a2,2
    38e6:	fa840593          	addi	a1,s0,-88
    38ea:	603010ef          	jal	56ec <read>
    38ee:	4789                	li	a5,2
    38f0:	02f50663          	beq	a0,a5,391c <exectest+0x172>
    printf("%s: read failed\n", s);
    38f4:	85ca                	mv	a1,s2
    38f6:	00002517          	auipc	a0,0x2
    38fa:	7e250513          	addi	a0,a0,2018 # 60d8 <malloc+0x4fe>
    38fe:	224020ef          	jal	5b22 <printf>
    exit(1);
    3902:	4505                	li	a0,1
    3904:	5d1010ef          	jal	56d4 <exit>
    printf("%s: open failed\n", s);
    3908:	85ca                	mv	a1,s2
    390a:	00003517          	auipc	a0,0x3
    390e:	ca650513          	addi	a0,a0,-858 # 65b0 <malloc+0x9d6>
    3912:	210020ef          	jal	5b22 <printf>
    exit(1);
    3916:	4505                	li	a0,1
    3918:	5bd010ef          	jal	56d4 <exit>
  unlink("echo-ok");
    391c:	00004517          	auipc	a0,0x4
    3920:	eec50513          	addi	a0,a0,-276 # 7808 <malloc+0x1c2e>
    3924:	601010ef          	jal	5724 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    3928:	fa844703          	lbu	a4,-88(s0)
    392c:	04f00793          	li	a5,79
    3930:	00f71863          	bne	a4,a5,3940 <exectest+0x196>
    3934:	fa944703          	lbu	a4,-87(s0)
    3938:	04b00793          	li	a5,75
    393c:	00f70c63          	beq	a4,a5,3954 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    3940:	85ca                	mv	a1,s2
    3942:	00004517          	auipc	a0,0x4
    3946:	f3e50513          	addi	a0,a0,-194 # 7880 <malloc+0x1ca6>
    394a:	1d8020ef          	jal	5b22 <printf>
    exit(1);
    394e:	4505                	li	a0,1
    3950:	585010ef          	jal	56d4 <exit>
    exit(0);
    3954:	4501                	li	a0,0
    3956:	57f010ef          	jal	56d4 <exit>

000000000000395a <killstatus>:
{
    395a:	715d                	addi	sp,sp,-80
    395c:	e486                	sd	ra,72(sp)
    395e:	e0a2                	sd	s0,64(sp)
    3960:	fc26                	sd	s1,56(sp)
    3962:	f84a                	sd	s2,48(sp)
    3964:	f44e                	sd	s3,40(sp)
    3966:	f052                	sd	s4,32(sp)
    3968:	ec56                	sd	s5,24(sp)
    396a:	e85a                	sd	s6,16(sp)
    396c:	0880                	addi	s0,sp,80
    396e:	8b2a                	mv	s6,a0
    3970:	06400913          	li	s2,100
    pause(1);
    3974:	4a85                	li	s5,1
    wait(&xst);
    3976:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    397a:	59fd                	li	s3,-1
    int pid1 = fork();
    397c:	551010ef          	jal	56cc <fork>
    3980:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    3982:	02054663          	bltz	a0,39ae <killstatus+0x54>
    if (pid1 == 0) {
    3986:	cd15                	beqz	a0,39c2 <killstatus+0x68>
    pause(1);
    3988:	8556                	mv	a0,s5
    398a:	5db010ef          	jal	5764 <pause>
    kill(pid1);
    398e:	8526                	mv	a0,s1
    3990:	575010ef          	jal	5704 <kill>
    wait(&xst);
    3994:	8552                	mv	a0,s4
    3996:	547010ef          	jal	56dc <wait>
    if (xst != -1) {
    399a:	fbc42783          	lw	a5,-68(s0)
    399e:	03379563          	bne	a5,s3,39c8 <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    39a2:	397d                	addiw	s2,s2,-1
    39a4:	fc091ce3          	bnez	s2,397c <killstatus+0x22>
  exit(0);
    39a8:	4501                	li	a0,0
    39aa:	52b010ef          	jal	56d4 <exit>
      printf("%s: fork failed\n", s);
    39ae:	85da                	mv	a1,s6
    39b0:	00003517          	auipc	a0,0x3
    39b4:	be850513          	addi	a0,a0,-1048 # 6598 <malloc+0x9be>
    39b8:	16a020ef          	jal	5b22 <printf>
      exit(1);
    39bc:	4505                	li	a0,1
    39be:	517010ef          	jal	56d4 <exit>
        getpid();
    39c2:	593010ef          	jal	5754 <getpid>
      while (1) {
    39c6:	bff5                	j	39c2 <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    39c8:	85da                	mv	a1,s6
    39ca:	00004517          	auipc	a0,0x4
    39ce:	ece50513          	addi	a0,a0,-306 # 7898 <malloc+0x1cbe>
    39d2:	150020ef          	jal	5b22 <printf>
      exit(1);
    39d6:	4505                	li	a0,1
    39d8:	4fd010ef          	jal	56d4 <exit>

00000000000039dc <preempt>:
{
    39dc:	7139                	addi	sp,sp,-64
    39de:	fc06                	sd	ra,56(sp)
    39e0:	f822                	sd	s0,48(sp)
    39e2:	f426                	sd	s1,40(sp)
    39e4:	f04a                	sd	s2,32(sp)
    39e6:	ec4e                	sd	s3,24(sp)
    39e8:	e852                	sd	s4,16(sp)
    39ea:	0080                	addi	s0,sp,64
    39ec:	892a                	mv	s2,a0
  pid1 = fork();
    39ee:	4df010ef          	jal	56cc <fork>
  if (pid1 < 0) {
    39f2:	00054563          	bltz	a0,39fc <preempt+0x20>
    39f6:	84aa                	mv	s1,a0
  if (pid1 == 0)
    39f8:	ed01                	bnez	a0,3a10 <preempt+0x34>
    for (;;)
    39fa:	a001                	j	39fa <preempt+0x1e>
    printf("%s: fork failed", s);
    39fc:	85ca                	mv	a1,s2
    39fe:	00003517          	auipc	a0,0x3
    3a02:	cda50513          	addi	a0,a0,-806 # 66d8 <malloc+0xafe>
    3a06:	11c020ef          	jal	5b22 <printf>
    exit(1);
    3a0a:	4505                	li	a0,1
    3a0c:	4c9010ef          	jal	56d4 <exit>
  pid2 = fork();
    3a10:	4bd010ef          	jal	56cc <fork>
    3a14:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3a16:	00054463          	bltz	a0,3a1e <preempt+0x42>
  if (pid2 == 0)
    3a1a:	ed01                	bnez	a0,3a32 <preempt+0x56>
    for (;;)
    3a1c:	a001                	j	3a1c <preempt+0x40>
    printf("%s: fork failed\n", s);
    3a1e:	85ca                	mv	a1,s2
    3a20:	00003517          	auipc	a0,0x3
    3a24:	b7850513          	addi	a0,a0,-1160 # 6598 <malloc+0x9be>
    3a28:	0fa020ef          	jal	5b22 <printf>
    exit(1);
    3a2c:	4505                	li	a0,1
    3a2e:	4a7010ef          	jal	56d4 <exit>
  pipe(pfds);
    3a32:	fc840513          	addi	a0,s0,-56
    3a36:	4af010ef          	jal	56e4 <pipe>
  pid3 = fork();
    3a3a:	493010ef          	jal	56cc <fork>
    3a3e:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3a40:	02054863          	bltz	a0,3a70 <preempt+0x94>
  if (pid3 == 0) {
    3a44:	e921                	bnez	a0,3a94 <preempt+0xb8>
    close(pfds[0]);
    3a46:	fc842503          	lw	a0,-56(s0)
    3a4a:	4b3010ef          	jal	56fc <close>
    if (write(pfds[1], "x", 1) != 1)
    3a4e:	4605                	li	a2,1
    3a50:	00002597          	auipc	a1,0x2
    3a54:	32858593          	addi	a1,a1,808 # 5d78 <malloc+0x19e>
    3a58:	fcc42503          	lw	a0,-52(s0)
    3a5c:	499010ef          	jal	56f4 <write>
    3a60:	4785                	li	a5,1
    3a62:	02f51163          	bne	a0,a5,3a84 <preempt+0xa8>
    close(pfds[1]);
    3a66:	fcc42503          	lw	a0,-52(s0)
    3a6a:	493010ef          	jal	56fc <close>
    for (;;)
    3a6e:	a001                	j	3a6e <preempt+0x92>
    printf("%s: fork failed\n", s);
    3a70:	85ca                	mv	a1,s2
    3a72:	00003517          	auipc	a0,0x3
    3a76:	b2650513          	addi	a0,a0,-1242 # 6598 <malloc+0x9be>
    3a7a:	0a8020ef          	jal	5b22 <printf>
    exit(1);
    3a7e:	4505                	li	a0,1
    3a80:	455010ef          	jal	56d4 <exit>
      printf("%s: preempt write error", s);
    3a84:	85ca                	mv	a1,s2
    3a86:	00004517          	auipc	a0,0x4
    3a8a:	e3250513          	addi	a0,a0,-462 # 78b8 <malloc+0x1cde>
    3a8e:	094020ef          	jal	5b22 <printf>
    3a92:	bfd1                	j	3a66 <preempt+0x8a>
  close(pfds[1]);
    3a94:	fcc42503          	lw	a0,-52(s0)
    3a98:	465010ef          	jal	56fc <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3a9c:	660d                	lui	a2,0x3
    3a9e:	0000a597          	auipc	a1,0xa
    3aa2:	24a58593          	addi	a1,a1,586 # dce8 <buf>
    3aa6:	fc842503          	lw	a0,-56(s0)
    3aaa:	443010ef          	jal	56ec <read>
    3aae:	4785                	li	a5,1
    3ab0:	02f50163          	beq	a0,a5,3ad2 <preempt+0xf6>
    printf("%s: preempt read error", s);
    3ab4:	85ca                	mv	a1,s2
    3ab6:	00004517          	auipc	a0,0x4
    3aba:	e1a50513          	addi	a0,a0,-486 # 78d0 <malloc+0x1cf6>
    3abe:	064020ef          	jal	5b22 <printf>
}
    3ac2:	70e2                	ld	ra,56(sp)
    3ac4:	7442                	ld	s0,48(sp)
    3ac6:	74a2                	ld	s1,40(sp)
    3ac8:	7902                	ld	s2,32(sp)
    3aca:	69e2                	ld	s3,24(sp)
    3acc:	6a42                	ld	s4,16(sp)
    3ace:	6121                	addi	sp,sp,64
    3ad0:	8082                	ret
  close(pfds[0]);
    3ad2:	fc842503          	lw	a0,-56(s0)
    3ad6:	427010ef          	jal	56fc <close>
  printf("kill... ");
    3ada:	00004517          	auipc	a0,0x4
    3ade:	e0e50513          	addi	a0,a0,-498 # 78e8 <malloc+0x1d0e>
    3ae2:	040020ef          	jal	5b22 <printf>
  kill(pid1);
    3ae6:	8526                	mv	a0,s1
    3ae8:	41d010ef          	jal	5704 <kill>
  kill(pid2);
    3aec:	854e                	mv	a0,s3
    3aee:	417010ef          	jal	5704 <kill>
  kill(pid3);
    3af2:	8552                	mv	a0,s4
    3af4:	411010ef          	jal	5704 <kill>
  printf("wait... ");
    3af8:	00004517          	auipc	a0,0x4
    3afc:	e0050513          	addi	a0,a0,-512 # 78f8 <malloc+0x1d1e>
    3b00:	022020ef          	jal	5b22 <printf>
  wait(0);
    3b04:	4501                	li	a0,0
    3b06:	3d7010ef          	jal	56dc <wait>
  wait(0);
    3b0a:	4501                	li	a0,0
    3b0c:	3d1010ef          	jal	56dc <wait>
  wait(0);
    3b10:	4501                	li	a0,0
    3b12:	3cb010ef          	jal	56dc <wait>
    3b16:	b775                	j	3ac2 <preempt+0xe6>

0000000000003b18 <reparent>:
{
    3b18:	7179                	addi	sp,sp,-48
    3b1a:	f406                	sd	ra,40(sp)
    3b1c:	f022                	sd	s0,32(sp)
    3b1e:	ec26                	sd	s1,24(sp)
    3b20:	e84a                	sd	s2,16(sp)
    3b22:	e44e                	sd	s3,8(sp)
    3b24:	e052                	sd	s4,0(sp)
    3b26:	1800                	addi	s0,sp,48
    3b28:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3b2a:	42b010ef          	jal	5754 <getpid>
    3b2e:	8a2a                	mv	s4,a0
    3b30:	0c800913          	li	s2,200
    int pid = fork();
    3b34:	399010ef          	jal	56cc <fork>
    3b38:	84aa                	mv	s1,a0
    if (pid < 0) {
    3b3a:	00054e63          	bltz	a0,3b56 <reparent+0x3e>
    if (pid) {
    3b3e:	c121                	beqz	a0,3b7e <reparent+0x66>
      if (wait(0) != pid) {
    3b40:	4501                	li	a0,0
    3b42:	39b010ef          	jal	56dc <wait>
    3b46:	02951263          	bne	a0,s1,3b6a <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3b4a:	397d                	addiw	s2,s2,-1
    3b4c:	fe0914e3          	bnez	s2,3b34 <reparent+0x1c>
  exit(0);
    3b50:	4501                	li	a0,0
    3b52:	383010ef          	jal	56d4 <exit>
      printf("%s: fork failed\n", s);
    3b56:	85ce                	mv	a1,s3
    3b58:	00003517          	auipc	a0,0x3
    3b5c:	a4050513          	addi	a0,a0,-1472 # 6598 <malloc+0x9be>
    3b60:	7c3010ef          	jal	5b22 <printf>
      exit(1);
    3b64:	4505                	li	a0,1
    3b66:	36f010ef          	jal	56d4 <exit>
        printf("%s: wait wrong pid\n", s);
    3b6a:	85ce                	mv	a1,s3
    3b6c:	00003517          	auipc	a0,0x3
    3b70:	b3450513          	addi	a0,a0,-1228 # 66a0 <malloc+0xac6>
    3b74:	7af010ef          	jal	5b22 <printf>
        exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	35b010ef          	jal	56d4 <exit>
      int pid2 = fork();
    3b7e:	34f010ef          	jal	56cc <fork>
      if (pid2 < 0) {
    3b82:	00054563          	bltz	a0,3b8c <reparent+0x74>
      exit(0);
    3b86:	4501                	li	a0,0
    3b88:	34d010ef          	jal	56d4 <exit>
        kill(master_pid);
    3b8c:	8552                	mv	a0,s4
    3b8e:	377010ef          	jal	5704 <kill>
        exit(1);
    3b92:	4505                	li	a0,1
    3b94:	341010ef          	jal	56d4 <exit>

0000000000003b98 <sbrkfail>:
{
    3b98:	7175                	addi	sp,sp,-144
    3b9a:	e506                	sd	ra,136(sp)
    3b9c:	e122                	sd	s0,128(sp)
    3b9e:	fca6                	sd	s1,120(sp)
    3ba0:	f8ca                	sd	s2,112(sp)
    3ba2:	f4ce                	sd	s3,104(sp)
    3ba4:	f0d2                	sd	s4,96(sp)
    3ba6:	ecd6                	sd	s5,88(sp)
    3ba8:	e8da                	sd	s6,80(sp)
    3baa:	e4de                	sd	s7,72(sp)
    3bac:	e0e2                	sd	s8,64(sp)
    3bae:	0900                	addi	s0,sp,144
    3bb0:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    3bb2:	fa040513          	addi	a0,s0,-96
    3bb6:	32f010ef          	jal	56e4 <pipe>
    3bba:	ed01                	bnez	a0,3bd2 <sbrkfail+0x3a>
    3bbc:	8baa                	mv	s7,a0
    3bbe:	f7040493          	addi	s1,s0,-144
    3bc2:	f9840993          	addi	s3,s0,-104
    3bc6:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3bc8:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3bca:	f9f40b13          	addi	s6,s0,-97
    3bce:	4a85                	li	s5,1
    3bd0:	a095                	j	3c34 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3bd2:	85e2                	mv	a1,s8
    3bd4:	00003517          	auipc	a0,0x3
    3bd8:	a4c50513          	addi	a0,a0,-1460 # 6620 <malloc+0xa46>
    3bdc:	747010ef          	jal	5b22 <printf>
    exit(1);
    3be0:	4505                	li	a0,1
    3be2:	2f3010ef          	jal	56d4 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3be6:	2bb010ef          	jal	56a0 <sbrk>
    3bea:	064007b7          	lui	a5,0x6400
    3bee:	40a7853b          	subw	a0,a5,a0
    3bf2:	2af010ef          	jal	56a0 <sbrk>
    3bf6:	57fd                	li	a5,-1
    3bf8:	02f50163          	beq	a0,a5,3c1a <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3bfc:	4605                	li	a2,1
    3bfe:	00004597          	auipc	a1,0x4
    3c02:	6b258593          	addi	a1,a1,1714 # 82b0 <malloc+0x26d6>
    3c06:	fa442503          	lw	a0,-92(s0)
    3c0a:	2eb010ef          	jal	56f4 <write>
        pause(1000);
    3c0e:	3e800493          	li	s1,1000
    3c12:	8526                	mv	a0,s1
    3c14:	351010ef          	jal	5764 <pause>
      for (;;)
    3c18:	bfed                	j	3c12 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3c1a:	4605                	li	a2,1
    3c1c:	00004597          	auipc	a1,0x4
    3c20:	cec58593          	addi	a1,a1,-788 # 7908 <malloc+0x1d2e>
    3c24:	fa442503          	lw	a0,-92(s0)
    3c28:	2cd010ef          	jal	56f4 <write>
    3c2c:	b7cd                	j	3c0e <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3c2e:	0911                	addi	s2,s2,4
    3c30:	03390a63          	beq	s2,s3,3c64 <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3c34:	299010ef          	jal	56cc <fork>
    3c38:	00a92023          	sw	a0,0(s2)
    3c3c:	d54d                	beqz	a0,3be6 <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3c3e:	ff4508e3          	beq	a0,s4,3c2e <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3c42:	8656                	mv	a2,s5
    3c44:	85da                	mv	a1,s6
    3c46:	fa042503          	lw	a0,-96(s0)
    3c4a:	2a3010ef          	jal	56ec <read>
      if (scratch == '0')
    3c4e:	f9f44783          	lbu	a5,-97(s0)
    3c52:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63ef2e8>
    3c56:	0017b793          	seqz	a5,a5
    3c5a:	00fbe7b3          	or	a5,s7,a5
    3c5e:	00078b9b          	sext.w	s7,a5
    3c62:	b7f1                	j	3c2e <sbrkfail+0x96>
  if (!failed) {
    3c64:	000b8863          	beqz	s7,3c74 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3c68:	6505                	lui	a0,0x1
    3c6a:	237010ef          	jal	56a0 <sbrk>
    3c6e:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3c70:	597d                	li	s2,-1
    3c72:	a821                	j	3c8a <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3c74:	85e2                	mv	a1,s8
    3c76:	00004517          	auipc	a0,0x4
    3c7a:	c9a50513          	addi	a0,a0,-870 # 7910 <malloc+0x1d36>
    3c7e:	6a5010ef          	jal	5b22 <printf>
    3c82:	b7dd                	j	3c68 <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3c84:	0491                	addi	s1,s1,4
    3c86:	01348b63          	beq	s1,s3,3c9c <sbrkfail+0x104>
    if (pids[i] == -1)
    3c8a:	4088                	lw	a0,0(s1)
    3c8c:	ff250ce3          	beq	a0,s2,3c84 <sbrkfail+0xec>
    kill(pids[i]);
    3c90:	275010ef          	jal	5704 <kill>
    wait(0);
    3c94:	4501                	li	a0,0
    3c96:	247010ef          	jal	56dc <wait>
    3c9a:	b7ed                	j	3c84 <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3c9c:	57fd                	li	a5,-1
    3c9e:	02fa0a63          	beq	s4,a5,3cd2 <sbrkfail+0x13a>
  pid = fork();
    3ca2:	22b010ef          	jal	56cc <fork>
  if (pid < 0) {
    3ca6:	04054063          	bltz	a0,3ce6 <sbrkfail+0x14e>
  if (pid == 0) {
    3caa:	e939                	bnez	a0,3d00 <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3cac:	3e800537          	lui	a0,0x3e800
    3cb0:	1f1010ef          	jal	56a0 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3cb4:	57fd                	li	a5,-1
    3cb6:	04f50263          	beq	a0,a5,3cfa <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3cba:	3e800637          	lui	a2,0x3e800
    3cbe:	85e2                	mv	a1,s8
    3cc0:	00004517          	auipc	a0,0x4
    3cc4:	ca050513          	addi	a0,a0,-864 # 7960 <malloc+0x1d86>
    3cc8:	65b010ef          	jal	5b22 <printf>
    exit(1);
    3ccc:	4505                	li	a0,1
    3cce:	207010ef          	jal	56d4 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3cd2:	85e2                	mv	a1,s8
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	c6c50513          	addi	a0,a0,-916 # 7940 <malloc+0x1d66>
    3cdc:	647010ef          	jal	5b22 <printf>
    exit(1);
    3ce0:	4505                	li	a0,1
    3ce2:	1f3010ef          	jal	56d4 <exit>
    printf("%s: fork failed\n", s);
    3ce6:	85e2                	mv	a1,s8
    3ce8:	00003517          	auipc	a0,0x3
    3cec:	8b050513          	addi	a0,a0,-1872 # 6598 <malloc+0x9be>
    3cf0:	633010ef          	jal	5b22 <printf>
    exit(1);
    3cf4:	4505                	li	a0,1
    3cf6:	1df010ef          	jal	56d4 <exit>
      exit(0);
    3cfa:	4501                	li	a0,0
    3cfc:	1d9010ef          	jal	56d4 <exit>
  wait(&xstatus);
    3d00:	fac40513          	addi	a0,s0,-84
    3d04:	1d9010ef          	jal	56dc <wait>
  if (xstatus != 0)
    3d08:	fac42783          	lw	a5,-84(s0)
    3d0c:	ef89                	bnez	a5,3d26 <sbrkfail+0x18e>
}
    3d0e:	60aa                	ld	ra,136(sp)
    3d10:	640a                	ld	s0,128(sp)
    3d12:	74e6                	ld	s1,120(sp)
    3d14:	7946                	ld	s2,112(sp)
    3d16:	79a6                	ld	s3,104(sp)
    3d18:	7a06                	ld	s4,96(sp)
    3d1a:	6ae6                	ld	s5,88(sp)
    3d1c:	6b46                	ld	s6,80(sp)
    3d1e:	6ba6                	ld	s7,72(sp)
    3d20:	6c06                	ld	s8,64(sp)
    3d22:	6149                	addi	sp,sp,144
    3d24:	8082                	ret
    exit(1);
    3d26:	4505                	li	a0,1
    3d28:	1ad010ef          	jal	56d4 <exit>

0000000000003d2c <mem>:
{
    3d2c:	7139                	addi	sp,sp,-64
    3d2e:	fc06                	sd	ra,56(sp)
    3d30:	f822                	sd	s0,48(sp)
    3d32:	f426                	sd	s1,40(sp)
    3d34:	f04a                	sd	s2,32(sp)
    3d36:	ec4e                	sd	s3,24(sp)
    3d38:	0080                	addi	s0,sp,64
    3d3a:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3d3c:	191010ef          	jal	56cc <fork>
    m1 = 0;
    3d40:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3d42:	6909                	lui	s2,0x2
    3d44:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xed>
  if ((pid = fork()) == 0) {
    3d48:	cd11                	beqz	a0,3d64 <mem+0x38>
    wait(&xstatus);
    3d4a:	fcc40513          	addi	a0,s0,-52
    3d4e:	18f010ef          	jal	56dc <wait>
    if (xstatus == -1) {
    3d52:	fcc42503          	lw	a0,-52(s0)
    3d56:	57fd                	li	a5,-1
    3d58:	04f50363          	beq	a0,a5,3d9e <mem+0x72>
    exit(xstatus);
    3d5c:	179010ef          	jal	56d4 <exit>
      *(char **)m2 = m1;
    3d60:	e104                	sd	s1,0(a0)
      m1 = m2;
    3d62:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3d64:	854a                	mv	a0,s2
    3d66:	675010ef          	jal	5bda <malloc>
    3d6a:	f97d                	bnez	a0,3d60 <mem+0x34>
    while (m1) {
    3d6c:	c491                	beqz	s1,3d78 <mem+0x4c>
      m2 = *(char **)m1;
    3d6e:	8526                	mv	a0,s1
    3d70:	6084                	ld	s1,0(s1)
      free(m1);
    3d72:	5e3010ef          	jal	5b54 <free>
    while (m1) {
    3d76:	fce5                	bnez	s1,3d6e <mem+0x42>
    m1 = malloc(1024 * 20);
    3d78:	6515                	lui	a0,0x5
    3d7a:	661010ef          	jal	5bda <malloc>
    if (m1 == 0) {
    3d7e:	c511                	beqz	a0,3d8a <mem+0x5e>
    free(m1);
    3d80:	5d5010ef          	jal	5b54 <free>
    exit(0);
    3d84:	4501                	li	a0,0
    3d86:	14f010ef          	jal	56d4 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3d8a:	85ce                	mv	a1,s3
    3d8c:	00004517          	auipc	a0,0x4
    3d90:	c0450513          	addi	a0,a0,-1020 # 7990 <malloc+0x1db6>
    3d94:	58f010ef          	jal	5b22 <printf>
      exit(1);
    3d98:	4505                	li	a0,1
    3d9a:	13b010ef          	jal	56d4 <exit>
      exit(0);
    3d9e:	4501                	li	a0,0
    3da0:	135010ef          	jal	56d4 <exit>

0000000000003da4 <sharedfd>:
{
    3da4:	7159                	addi	sp,sp,-112
    3da6:	f486                	sd	ra,104(sp)
    3da8:	f0a2                	sd	s0,96(sp)
    3daa:	eca6                	sd	s1,88(sp)
    3dac:	f85a                	sd	s6,48(sp)
    3dae:	1880                	addi	s0,sp,112
    3db0:	84aa                	mv	s1,a0
    3db2:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3db4:	00004517          	auipc	a0,0x4
    3db8:	bfc50513          	addi	a0,a0,-1028 # 79b0 <malloc+0x1dd6>
    3dbc:	169010ef          	jal	5724 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3dc0:	20200593          	li	a1,514
    3dc4:	00004517          	auipc	a0,0x4
    3dc8:	bec50513          	addi	a0,a0,-1044 # 79b0 <malloc+0x1dd6>
    3dcc:	149010ef          	jal	5714 <open>
  if (fd < 0) {
    3dd0:	04054863          	bltz	a0,3e20 <sharedfd+0x7c>
    3dd4:	e8ca                	sd	s2,80(sp)
    3dd6:	e4ce                	sd	s3,72(sp)
    3dd8:	e0d2                	sd	s4,64(sp)
    3dda:	fc56                	sd	s5,56(sp)
    3ddc:	89aa                	mv	s3,a0
  pid = fork();
    3dde:	0ef010ef          	jal	56cc <fork>
    3de2:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3de4:	07000593          	li	a1,112
    3de8:	e119                	bnez	a0,3dee <sharedfd+0x4a>
    3dea:	06300593          	li	a1,99
    3dee:	4629                	li	a2,10
    3df0:	fa040513          	addi	a0,s0,-96
    3df4:	6b6010ef          	jal	54aa <memset>
    3df8:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3dfc:	fa040a13          	addi	s4,s0,-96
    3e00:	4929                	li	s2,10
    3e02:	864a                	mv	a2,s2
    3e04:	85d2                	mv	a1,s4
    3e06:	854e                	mv	a0,s3
    3e08:	0ed010ef          	jal	56f4 <write>
    3e0c:	03251963          	bne	a0,s2,3e3e <sharedfd+0x9a>
  for (i = 0; i < N; i++) {
    3e10:	34fd                	addiw	s1,s1,-1
    3e12:	f8e5                	bnez	s1,3e02 <sharedfd+0x5e>
  if (pid == 0) {
    3e14:	040a9063          	bnez	s5,3e54 <sharedfd+0xb0>
    3e18:	f45e                	sd	s7,40(sp)
    exit(0);
    3e1a:	4501                	li	a0,0
    3e1c:	0b9010ef          	jal	56d4 <exit>
    3e20:	e8ca                	sd	s2,80(sp)
    3e22:	e4ce                	sd	s3,72(sp)
    3e24:	e0d2                	sd	s4,64(sp)
    3e26:	fc56                	sd	s5,56(sp)
    3e28:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3e2a:	85a6                	mv	a1,s1
    3e2c:	00004517          	auipc	a0,0x4
    3e30:	b9450513          	addi	a0,a0,-1132 # 79c0 <malloc+0x1de6>
    3e34:	4ef010ef          	jal	5b22 <printf>
    exit(1);
    3e38:	4505                	li	a0,1
    3e3a:	09b010ef          	jal	56d4 <exit>
    3e3e:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3e40:	85da                	mv	a1,s6
    3e42:	00004517          	auipc	a0,0x4
    3e46:	ba650513          	addi	a0,a0,-1114 # 79e8 <malloc+0x1e0e>
    3e4a:	4d9010ef          	jal	5b22 <printf>
      exit(1);
    3e4e:	4505                	li	a0,1
    3e50:	085010ef          	jal	56d4 <exit>
    wait(&xstatus);
    3e54:	f9c40513          	addi	a0,s0,-100
    3e58:	085010ef          	jal	56dc <wait>
    if (xstatus != 0)
    3e5c:	f9c42a03          	lw	s4,-100(s0)
    3e60:	000a0663          	beqz	s4,3e6c <sharedfd+0xc8>
    3e64:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3e66:	8552                	mv	a0,s4
    3e68:	06d010ef          	jal	56d4 <exit>
    3e6c:	f45e                	sd	s7,40(sp)
  close(fd);
    3e6e:	854e                	mv	a0,s3
    3e70:	08d010ef          	jal	56fc <close>
  fd = open("sharedfd", 0);
    3e74:	4581                	li	a1,0
    3e76:	00004517          	auipc	a0,0x4
    3e7a:	b3a50513          	addi	a0,a0,-1222 # 79b0 <malloc+0x1dd6>
    3e7e:	097010ef          	jal	5714 <open>
    3e82:	8baa                	mv	s7,a0
  nc = np = 0;
    3e84:	89d2                	mv	s3,s4
  if (fd < 0) {
    3e86:	02054363          	bltz	a0,3eac <sharedfd+0x108>
    3e8a:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    3e8e:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3e92:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3e96:	4629                	li	a2,10
    3e98:	fa040593          	addi	a1,s0,-96
    3e9c:	855e                	mv	a0,s7
    3e9e:	04f010ef          	jal	56ec <read>
    3ea2:	02a05b63          	blez	a0,3ed8 <sharedfd+0x134>
    3ea6:	fa040793          	addi	a5,s0,-96
    3eaa:	a839                	j	3ec8 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3eac:	85da                	mv	a1,s6
    3eae:	00004517          	auipc	a0,0x4
    3eb2:	b5a50513          	addi	a0,a0,-1190 # 7a08 <malloc+0x1e2e>
    3eb6:	46d010ef          	jal	5b22 <printf>
    exit(1);
    3eba:	4505                	li	a0,1
    3ebc:	019010ef          	jal	56d4 <exit>
        nc++;
    3ec0:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    3ec2:	0785                	addi	a5,a5,1
    3ec4:	fd2789e3          	beq	a5,s2,3e96 <sharedfd+0xf2>
      if (buf[i] == 'c')
    3ec8:	0007c703          	lbu	a4,0(a5)
    3ecc:	fe970ae3          	beq	a4,s1,3ec0 <sharedfd+0x11c>
      if (buf[i] == 'p')
    3ed0:	ff5719e3          	bne	a4,s5,3ec2 <sharedfd+0x11e>
        np++;
    3ed4:	2985                	addiw	s3,s3,1
    3ed6:	b7f5                	j	3ec2 <sharedfd+0x11e>
  close(fd);
    3ed8:	855e                	mv	a0,s7
    3eda:	023010ef          	jal	56fc <close>
  unlink("sharedfd");
    3ede:	00004517          	auipc	a0,0x4
    3ee2:	ad250513          	addi	a0,a0,-1326 # 79b0 <malloc+0x1dd6>
    3ee6:	03f010ef          	jal	5724 <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3eea:	6789                	lui	a5,0x2
    3eec:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xec>
    3ef0:	00fa1763          	bne	s4,a5,3efe <sharedfd+0x15a>
    3ef4:	01499563          	bne	s3,s4,3efe <sharedfd+0x15a>
    exit(0);
    3ef8:	4501                	li	a0,0
    3efa:	7da010ef          	jal	56d4 <exit>
    printf("%s: nc/np test fails\n", s);
    3efe:	85da                	mv	a1,s6
    3f00:	00004517          	auipc	a0,0x4
    3f04:	b3050513          	addi	a0,a0,-1232 # 7a30 <malloc+0x1e56>
    3f08:	41b010ef          	jal	5b22 <printf>
    exit(1);
    3f0c:	4505                	li	a0,1
    3f0e:	7c6010ef          	jal	56d4 <exit>

0000000000003f12 <fourfiles>:
{
    3f12:	7135                	addi	sp,sp,-160
    3f14:	ed06                	sd	ra,152(sp)
    3f16:	e922                	sd	s0,144(sp)
    3f18:	e526                	sd	s1,136(sp)
    3f1a:	e14a                	sd	s2,128(sp)
    3f1c:	fcce                	sd	s3,120(sp)
    3f1e:	f8d2                	sd	s4,112(sp)
    3f20:	f4d6                	sd	s5,104(sp)
    3f22:	f0da                	sd	s6,96(sp)
    3f24:	ecde                	sd	s7,88(sp)
    3f26:	e8e2                	sd	s8,80(sp)
    3f28:	e4e6                	sd	s9,72(sp)
    3f2a:	e0ea                	sd	s10,64(sp)
    3f2c:	fc6e                	sd	s11,56(sp)
    3f2e:	1100                	addi	s0,sp,160
    3f30:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3f32:	00004797          	auipc	a5,0x4
    3f36:	b1678793          	addi	a5,a5,-1258 # 7a48 <malloc+0x1e6e>
    3f3a:	f6f43823          	sd	a5,-144(s0)
    3f3e:	00004797          	auipc	a5,0x4
    3f42:	b1278793          	addi	a5,a5,-1262 # 7a50 <malloc+0x1e76>
    3f46:	f6f43c23          	sd	a5,-136(s0)
    3f4a:	00004797          	auipc	a5,0x4
    3f4e:	b0e78793          	addi	a5,a5,-1266 # 7a58 <malloc+0x1e7e>
    3f52:	f8f43023          	sd	a5,-128(s0)
    3f56:	00004797          	auipc	a5,0x4
    3f5a:	b0a78793          	addi	a5,a5,-1270 # 7a60 <malloc+0x1e86>
    3f5e:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3f62:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3f66:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3f68:	4481                	li	s1,0
    3f6a:	4a11                	li	s4,4
    fname = names[pi];
    3f6c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3f70:	854e                	mv	a0,s3
    3f72:	7b2010ef          	jal	5724 <unlink>
    pid = fork();
    3f76:	756010ef          	jal	56cc <fork>
    if (pid < 0) {
    3f7a:	04054063          	bltz	a0,3fba <fourfiles+0xa8>
    if (pid == 0) {
    3f7e:	c921                	beqz	a0,3fce <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    3f80:	2485                	addiw	s1,s1,1
    3f82:	0921                	addi	s2,s2,8
    3f84:	ff4494e3          	bne	s1,s4,3f6c <fourfiles+0x5a>
    3f88:	4491                	li	s1,4
    wait(&xstatus);
    3f8a:	f6c40913          	addi	s2,s0,-148
    3f8e:	854a                	mv	a0,s2
    3f90:	74c010ef          	jal	56dc <wait>
    if (xstatus != 0)
    3f94:	f6c42b03          	lw	s6,-148(s0)
    3f98:	0a0b1463          	bnez	s6,4040 <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    3f9c:	34fd                	addiw	s1,s1,-1
    3f9e:	f8e5                	bnez	s1,3f8e <fourfiles+0x7c>
    3fa0:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3fa4:	6a8d                	lui	s5,0x3
    3fa6:	0000aa17          	auipc	s4,0xa
    3faa:	d42a0a13          	addi	s4,s4,-702 # dce8 <buf>
    if (total != N * SZ) {
    3fae:	6d05                	lui	s10,0x1
    3fb0:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    3fb4:	03400d93          	li	s11,52
    3fb8:	a86d                	j	4072 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3fba:	85e6                	mv	a1,s9
    3fbc:	00002517          	auipc	a0,0x2
    3fc0:	5dc50513          	addi	a0,a0,1500 # 6598 <malloc+0x9be>
    3fc4:	35f010ef          	jal	5b22 <printf>
      exit(1);
    3fc8:	4505                	li	a0,1
    3fca:	70a010ef          	jal	56d4 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3fce:	20200593          	li	a1,514
    3fd2:	854e                	mv	a0,s3
    3fd4:	740010ef          	jal	5714 <open>
    3fd8:	892a                	mv	s2,a0
      if (fd < 0) {
    3fda:	04054063          	bltz	a0,401a <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    3fde:	1f400613          	li	a2,500
    3fe2:	0304859b          	addiw	a1,s1,48
    3fe6:	0000a517          	auipc	a0,0xa
    3fea:	d0250513          	addi	a0,a0,-766 # dce8 <buf>
    3fee:	4bc010ef          	jal	54aa <memset>
    3ff2:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    3ff4:	1f400993          	li	s3,500
    3ff8:	0000aa17          	auipc	s4,0xa
    3ffc:	cf0a0a13          	addi	s4,s4,-784 # dce8 <buf>
    4000:	864e                	mv	a2,s3
    4002:	85d2                	mv	a1,s4
    4004:	854a                	mv	a0,s2
    4006:	6ee010ef          	jal	56f4 <write>
    400a:	85aa                	mv	a1,a0
    400c:	03351163          	bne	a0,s3,402e <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    4010:	34fd                	addiw	s1,s1,-1
    4012:	f4fd                	bnez	s1,4000 <fourfiles+0xee>
      exit(0);
    4014:	4501                	li	a0,0
    4016:	6be010ef          	jal	56d4 <exit>
        printf("%s: create failed\n", s);
    401a:	85e6                	mv	a1,s9
    401c:	00002517          	auipc	a0,0x2
    4020:	6ec50513          	addi	a0,a0,1772 # 6708 <malloc+0xb2e>
    4024:	2ff010ef          	jal	5b22 <printf>
        exit(1);
    4028:	4505                	li	a0,1
    402a:	6aa010ef          	jal	56d4 <exit>
          printf("write failed %d\n", n);
    402e:	00004517          	auipc	a0,0x4
    4032:	a3a50513          	addi	a0,a0,-1478 # 7a68 <malloc+0x1e8e>
    4036:	2ed010ef          	jal	5b22 <printf>
          exit(1);
    403a:	4505                	li	a0,1
    403c:	698010ef          	jal	56d4 <exit>
      exit(xstatus);
    4040:	855a                	mv	a0,s6
    4042:	692010ef          	jal	56d4 <exit>
          printf("%s: wrong char\n", s);
    4046:	85e6                	mv	a1,s9
    4048:	00004517          	auipc	a0,0x4
    404c:	a3850513          	addi	a0,a0,-1480 # 7a80 <malloc+0x1ea6>
    4050:	2d3010ef          	jal	5b22 <printf>
          exit(1);
    4054:	4505                	li	a0,1
    4056:	67e010ef          	jal	56d4 <exit>
    close(fd);
    405a:	854e                	mv	a0,s3
    405c:	6a0010ef          	jal	56fc <close>
    if (total != N * SZ) {
    4060:	05a91863          	bne	s2,s10,40b0 <fourfiles+0x19e>
    unlink(fname);
    4064:	8562                	mv	a0,s8
    4066:	6be010ef          	jal	5724 <unlink>
  for (i = 0; i < NCHILD; i++) {
    406a:	0ba1                	addi	s7,s7,8
    406c:	2485                	addiw	s1,s1,1
    406e:	05b48b63          	beq	s1,s11,40c4 <fourfiles+0x1b2>
    fname = names[i];
    4072:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4076:	4581                	li	a1,0
    4078:	8562                	mv	a0,s8
    407a:	69a010ef          	jal	5714 <open>
    407e:	89aa                	mv	s3,a0
    total = 0;
    4080:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4082:	8656                	mv	a2,s5
    4084:	85d2                	mv	a1,s4
    4086:	854e                	mv	a0,s3
    4088:	664010ef          	jal	56ec <read>
    408c:	fca057e3          	blez	a0,405a <fourfiles+0x148>
    4090:	0000a797          	auipc	a5,0xa
    4094:	c5878793          	addi	a5,a5,-936 # dce8 <buf>
    4098:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    409c:	0007c703          	lbu	a4,0(a5)
    40a0:	fa9713e3          	bne	a4,s1,4046 <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    40a4:	0785                	addi	a5,a5,1
    40a6:	fed79be3          	bne	a5,a3,409c <fourfiles+0x18a>
      total += n;
    40aa:	00a9093b          	addw	s2,s2,a0
    40ae:	bfd1                	j	4082 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    40b0:	85ca                	mv	a1,s2
    40b2:	00004517          	auipc	a0,0x4
    40b6:	9de50513          	addi	a0,a0,-1570 # 7a90 <malloc+0x1eb6>
    40ba:	269010ef          	jal	5b22 <printf>
      exit(1);
    40be:	4505                	li	a0,1
    40c0:	614010ef          	jal	56d4 <exit>
}
    40c4:	60ea                	ld	ra,152(sp)
    40c6:	644a                	ld	s0,144(sp)
    40c8:	64aa                	ld	s1,136(sp)
    40ca:	690a                	ld	s2,128(sp)
    40cc:	79e6                	ld	s3,120(sp)
    40ce:	7a46                	ld	s4,112(sp)
    40d0:	7aa6                	ld	s5,104(sp)
    40d2:	7b06                	ld	s6,96(sp)
    40d4:	6be6                	ld	s7,88(sp)
    40d6:	6c46                	ld	s8,80(sp)
    40d8:	6ca6                	ld	s9,72(sp)
    40da:	6d06                	ld	s10,64(sp)
    40dc:	7de2                	ld	s11,56(sp)
    40de:	610d                	addi	sp,sp,160
    40e0:	8082                	ret

00000000000040e2 <concreate>:
{
    40e2:	7171                	addi	sp,sp,-176
    40e4:	f506                	sd	ra,168(sp)
    40e6:	f122                	sd	s0,160(sp)
    40e8:	ed26                	sd	s1,152(sp)
    40ea:	e94a                	sd	s2,144(sp)
    40ec:	e54e                	sd	s3,136(sp)
    40ee:	e152                	sd	s4,128(sp)
    40f0:	fcd6                	sd	s5,120(sp)
    40f2:	f8da                	sd	s6,112(sp)
    40f4:	f4de                	sd	s7,104(sp)
    40f6:	f0e2                	sd	s8,96(sp)
    40f8:	ece6                	sd	s9,88(sp)
    40fa:	e8ea                	sd	s10,80(sp)
    40fc:	1900                	addi	s0,sp,176
    40fe:	8d2a                	mv	s10,a0
  file[0] = 'C';
    4100:	04300793          	li	a5,67
    4104:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    4108:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    410c:	4901                	li	s2,0
    unlink(file);
    410e:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    4112:	55555b37          	lui	s6,0x55555
    4116:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554486e>
    411a:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    411c:	20200c13          	li	s8,514
      link("C0", file);
    4120:	00004c97          	auipc	s9,0x4
    4124:	988c8c93          	addi	s9,s9,-1656 # 7aa8 <malloc+0x1ece>
      wait(&xstatus);
    4128:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    412c:	02800a13          	li	s4,40
    4130:	ac25                	j	4368 <concreate+0x286>
      link("C0", file);
    4132:	85ce                	mv	a1,s3
    4134:	8566                	mv	a0,s9
    4136:	5fe010ef          	jal	5734 <link>
    if (pid == 0) {
    413a:	ac29                	j	4354 <concreate+0x272>
    } else if (pid == 0 && (i % 5) == 1) {
    413c:	666667b7          	lui	a5,0x66666
    4140:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x6665597f>
    4144:	02f907b3          	mul	a5,s2,a5
    4148:	9785                	srai	a5,a5,0x21
    414a:	41f9571b          	sraiw	a4,s2,0x1f
    414e:	9f99                	subw	a5,a5,a4
    4150:	0027971b          	slliw	a4,a5,0x2
    4154:	9fb9                	addw	a5,a5,a4
    4156:	40f9093b          	subw	s2,s2,a5
    415a:	4785                	li	a5,1
    415c:	02f90563          	beq	s2,a5,4186 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    4160:	20200593          	li	a1,514
    4164:	f9840513          	addi	a0,s0,-104
    4168:	5ac010ef          	jal	5714 <open>
      if (fd < 0) {
    416c:	1c055f63          	bgez	a0,434a <concreate+0x268>
        printf("concreate create %s failed\n", file);
    4170:	f9840593          	addi	a1,s0,-104
    4174:	00004517          	auipc	a0,0x4
    4178:	93c50513          	addi	a0,a0,-1732 # 7ab0 <malloc+0x1ed6>
    417c:	1a7010ef          	jal	5b22 <printf>
        exit(1);
    4180:	4505                	li	a0,1
    4182:	552010ef          	jal	56d4 <exit>
      link("C0", file);
    4186:	f9840593          	addi	a1,s0,-104
    418a:	00004517          	auipc	a0,0x4
    418e:	91e50513          	addi	a0,a0,-1762 # 7aa8 <malloc+0x1ece>
    4192:	5a2010ef          	jal	5734 <link>
      exit(0);
    4196:	4501                	li	a0,0
    4198:	53c010ef          	jal	56d4 <exit>
        exit(1);
    419c:	4505                	li	a0,1
    419e:	536010ef          	jal	56d4 <exit>
  memset(fa, 0, sizeof(fa));
    41a2:	02800613          	li	a2,40
    41a6:	4581                	li	a1,0
    41a8:	f7040513          	addi	a0,s0,-144
    41ac:	2fe010ef          	jal	54aa <memset>
  fd = open(".", 0);
    41b0:	4581                	li	a1,0
    41b2:	00002517          	auipc	a0,0x2
    41b6:	23e50513          	addi	a0,a0,574 # 63f0 <malloc+0x816>
    41ba:	55a010ef          	jal	5714 <open>
    41be:	892a                	mv	s2,a0
  n = 0;
    41c0:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    41c2:	f6040a13          	addi	s4,s0,-160
    41c6:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    41c8:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    41cc:	02700b93          	li	s7,39
      fa[i] = 1;
    41d0:	4c05                	li	s8,1
  while (read(fd, &de, sizeof(de)) > 0) {
    41d2:	864e                	mv	a2,s3
    41d4:	85d2                	mv	a1,s4
    41d6:	854a                	mv	a0,s2
    41d8:	514010ef          	jal	56ec <read>
    41dc:	06a05763          	blez	a0,424a <concreate+0x168>
    if (de.inum == 0)
    41e0:	f6045783          	lhu	a5,-160(s0)
    41e4:	d7fd                	beqz	a5,41d2 <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    41e6:	f6244783          	lbu	a5,-158(s0)
    41ea:	ff5794e3          	bne	a5,s5,41d2 <concreate+0xf0>
    41ee:	f6444783          	lbu	a5,-156(s0)
    41f2:	f3e5                	bnez	a5,41d2 <concreate+0xf0>
      i = de.name[1] - '0';
    41f4:	f6344783          	lbu	a5,-157(s0)
    41f8:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    41fc:	00fbef63          	bltu	s7,a5,421a <concreate+0x138>
      if (fa[i]) {
    4200:	fa078713          	addi	a4,a5,-96
    4204:	9722                	add	a4,a4,s0
    4206:	fd074703          	lbu	a4,-48(a4)
    420a:	e705                	bnez	a4,4232 <concreate+0x150>
      fa[i] = 1;
    420c:	fa078793          	addi	a5,a5,-96
    4210:	97a2                	add	a5,a5,s0
    4212:	fd878823          	sb	s8,-48(a5)
      n++;
    4216:	2b05                	addiw	s6,s6,1
    4218:	bf6d                	j	41d2 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    421a:	f6240613          	addi	a2,s0,-158
    421e:	85ea                	mv	a1,s10
    4220:	00004517          	auipc	a0,0x4
    4224:	8b050513          	addi	a0,a0,-1872 # 7ad0 <malloc+0x1ef6>
    4228:	0fb010ef          	jal	5b22 <printf>
        exit(1);
    422c:	4505                	li	a0,1
    422e:	4a6010ef          	jal	56d4 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4232:	f6240613          	addi	a2,s0,-158
    4236:	85ea                	mv	a1,s10
    4238:	00004517          	auipc	a0,0x4
    423c:	8b850513          	addi	a0,a0,-1864 # 7af0 <malloc+0x1f16>
    4240:	0e3010ef          	jal	5b22 <printf>
        exit(1);
    4244:	4505                	li	a0,1
    4246:	48e010ef          	jal	56d4 <exit>
  close(fd);
    424a:	854a                	mv	a0,s2
    424c:	4b0010ef          	jal	56fc <close>
  if (n != N) {
    4250:	02800793          	li	a5,40
    4254:	00fb1a63          	bne	s6,a5,4268 <concreate+0x186>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4258:	55555a37          	lui	s4,0x55555
    425c:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554486e>
      close(open(file, 0));
    4260:	f9840993          	addi	s3,s0,-104
  for (i = 0; i < N; i++) {
    4264:	8ada                	mv	s5,s6
    4266:	a049                	j	42e8 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    4268:	85ea                	mv	a1,s10
    426a:	00004517          	auipc	a0,0x4
    426e:	8ae50513          	addi	a0,a0,-1874 # 7b18 <malloc+0x1f3e>
    4272:	0b1010ef          	jal	5b22 <printf>
    exit(1);
    4276:	4505                	li	a0,1
    4278:	45c010ef          	jal	56d4 <exit>
      printf("%s: fork failed\n", s);
    427c:	85ea                	mv	a1,s10
    427e:	00002517          	auipc	a0,0x2
    4282:	31a50513          	addi	a0,a0,794 # 6598 <malloc+0x9be>
    4286:	09d010ef          	jal	5b22 <printf>
      exit(1);
    428a:	4505                	li	a0,1
    428c:	448010ef          	jal	56d4 <exit>
      close(open(file, 0));
    4290:	4581                	li	a1,0
    4292:	854e                	mv	a0,s3
    4294:	480010ef          	jal	5714 <open>
    4298:	464010ef          	jal	56fc <close>
      close(open(file, 0));
    429c:	4581                	li	a1,0
    429e:	854e                	mv	a0,s3
    42a0:	474010ef          	jal	5714 <open>
    42a4:	458010ef          	jal	56fc <close>
      close(open(file, 0));
    42a8:	4581                	li	a1,0
    42aa:	854e                	mv	a0,s3
    42ac:	468010ef          	jal	5714 <open>
    42b0:	44c010ef          	jal	56fc <close>
      close(open(file, 0));
    42b4:	4581                	li	a1,0
    42b6:	854e                	mv	a0,s3
    42b8:	45c010ef          	jal	5714 <open>
    42bc:	440010ef          	jal	56fc <close>
      close(open(file, 0));
    42c0:	4581                	li	a1,0
    42c2:	854e                	mv	a0,s3
    42c4:	450010ef          	jal	5714 <open>
    42c8:	434010ef          	jal	56fc <close>
      close(open(file, 0));
    42cc:	4581                	li	a1,0
    42ce:	854e                	mv	a0,s3
    42d0:	444010ef          	jal	5714 <open>
    42d4:	428010ef          	jal	56fc <close>
    if (pid == 0)
    42d8:	06090663          	beqz	s2,4344 <concreate+0x262>
      wait(0);
    42dc:	4501                	li	a0,0
    42de:	3fe010ef          	jal	56dc <wait>
  for (i = 0; i < N; i++) {
    42e2:	2485                	addiw	s1,s1,1
    42e4:	0d548163          	beq	s1,s5,43a6 <concreate+0x2c4>
    file[1] = '0' + i;
    42e8:	0304879b          	addiw	a5,s1,48
    42ec:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    42f0:	3dc010ef          	jal	56cc <fork>
    42f4:	892a                	mv	s2,a0
    if (pid < 0) {
    42f6:	f80543e3          	bltz	a0,427c <concreate+0x19a>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    42fa:	03448733          	mul	a4,s1,s4
    42fe:	9301                	srli	a4,a4,0x20
    4300:	41f4d79b          	sraiw	a5,s1,0x1f
    4304:	9f1d                	subw	a4,a4,a5
    4306:	0017179b          	slliw	a5,a4,0x1
    430a:	9fb9                	addw	a5,a5,a4
    430c:	40f487bb          	subw	a5,s1,a5
    4310:	00a7e733          	or	a4,a5,a0
    4314:	2701                	sext.w	a4,a4
    4316:	df2d                	beqz	a4,4290 <concreate+0x1ae>
    4318:	c119                	beqz	a0,431e <concreate+0x23c>
    431a:	17fd                	addi	a5,a5,-1
    431c:	dbb5                	beqz	a5,4290 <concreate+0x1ae>
      unlink(file);
    431e:	854e                	mv	a0,s3
    4320:	404010ef          	jal	5724 <unlink>
      unlink(file);
    4324:	854e                	mv	a0,s3
    4326:	3fe010ef          	jal	5724 <unlink>
      unlink(file);
    432a:	854e                	mv	a0,s3
    432c:	3f8010ef          	jal	5724 <unlink>
      unlink(file);
    4330:	854e                	mv	a0,s3
    4332:	3f2010ef          	jal	5724 <unlink>
      unlink(file);
    4336:	854e                	mv	a0,s3
    4338:	3ec010ef          	jal	5724 <unlink>
      unlink(file);
    433c:	854e                	mv	a0,s3
    433e:	3e6010ef          	jal	5724 <unlink>
    4342:	bf59                	j	42d8 <concreate+0x1f6>
      exit(0);
    4344:	4501                	li	a0,0
    4346:	38e010ef          	jal	56d4 <exit>
      close(fd);
    434a:	3b2010ef          	jal	56fc <close>
    if (pid == 0) {
    434e:	b5a1                	j	4196 <concreate+0xb4>
      close(fd);
    4350:	3ac010ef          	jal	56fc <close>
      wait(&xstatus);
    4354:	8556                	mv	a0,s5
    4356:	386010ef          	jal	56dc <wait>
      if (xstatus != 0)
    435a:	f5c42483          	lw	s1,-164(s0)
    435e:	e2049fe3          	bnez	s1,419c <concreate+0xba>
  for (i = 0; i < N; i++) {
    4362:	2905                	addiw	s2,s2,1
    4364:	e3490fe3          	beq	s2,s4,41a2 <concreate+0xc0>
    file[1] = '0' + i;
    4368:	0309079b          	addiw	a5,s2,48
    436c:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4370:	854e                	mv	a0,s3
    4372:	3b2010ef          	jal	5724 <unlink>
    pid = fork();
    4376:	356010ef          	jal	56cc <fork>
    if (pid && (i % 3) == 1) {
    437a:	dc0501e3          	beqz	a0,413c <concreate+0x5a>
    437e:	036907b3          	mul	a5,s2,s6
    4382:	9381                	srli	a5,a5,0x20
    4384:	41f9571b          	sraiw	a4,s2,0x1f
    4388:	9f99                	subw	a5,a5,a4
    438a:	0017971b          	slliw	a4,a5,0x1
    438e:	9fb9                	addw	a5,a5,a4
    4390:	40f907bb          	subw	a5,s2,a5
    4394:	d9778fe3          	beq	a5,s7,4132 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    4398:	85e2                	mv	a1,s8
    439a:	854e                	mv	a0,s3
    439c:	378010ef          	jal	5714 <open>
      if (fd < 0) {
    43a0:	fa0558e3          	bgez	a0,4350 <concreate+0x26e>
    43a4:	b3f1                	j	4170 <concreate+0x8e>
}
    43a6:	70aa                	ld	ra,168(sp)
    43a8:	740a                	ld	s0,160(sp)
    43aa:	64ea                	ld	s1,152(sp)
    43ac:	694a                	ld	s2,144(sp)
    43ae:	69aa                	ld	s3,136(sp)
    43b0:	6a0a                	ld	s4,128(sp)
    43b2:	7ae6                	ld	s5,120(sp)
    43b4:	7b46                	ld	s6,112(sp)
    43b6:	7ba6                	ld	s7,104(sp)
    43b8:	7c06                	ld	s8,96(sp)
    43ba:	6ce6                	ld	s9,88(sp)
    43bc:	6d46                	ld	s10,80(sp)
    43be:	614d                	addi	sp,sp,176
    43c0:	8082                	ret

00000000000043c2 <bigfile>:
{
    43c2:	7139                	addi	sp,sp,-64
    43c4:	fc06                	sd	ra,56(sp)
    43c6:	f822                	sd	s0,48(sp)
    43c8:	f426                	sd	s1,40(sp)
    43ca:	f04a                	sd	s2,32(sp)
    43cc:	ec4e                	sd	s3,24(sp)
    43ce:	e852                	sd	s4,16(sp)
    43d0:	e456                	sd	s5,8(sp)
    43d2:	e05a                	sd	s6,0(sp)
    43d4:	0080                	addi	s0,sp,64
    43d6:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    43d8:	00003517          	auipc	a0,0x3
    43dc:	77850513          	addi	a0,a0,1912 # 7b50 <malloc+0x1f76>
    43e0:	344010ef          	jal	5724 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    43e4:	20200593          	li	a1,514
    43e8:	00003517          	auipc	a0,0x3
    43ec:	76850513          	addi	a0,a0,1896 # 7b50 <malloc+0x1f76>
    43f0:	324010ef          	jal	5714 <open>
  if (fd < 0) {
    43f4:	08054a63          	bltz	a0,4488 <bigfile+0xc6>
    43f8:	8a2a                	mv	s4,a0
    43fa:	4481                	li	s1,0
    memset(buf, i, SZ);
    43fc:	25800913          	li	s2,600
    4400:	0000a997          	auipc	s3,0xa
    4404:	8e898993          	addi	s3,s3,-1816 # dce8 <buf>
  for (i = 0; i < N; i++) {
    4408:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    440a:	864a                	mv	a2,s2
    440c:	85a6                	mv	a1,s1
    440e:	854e                	mv	a0,s3
    4410:	09a010ef          	jal	54aa <memset>
    if (write(fd, buf, SZ) != SZ) {
    4414:	864a                	mv	a2,s2
    4416:	85ce                	mv	a1,s3
    4418:	8552                	mv	a0,s4
    441a:	2da010ef          	jal	56f4 <write>
    441e:	07251f63          	bne	a0,s2,449c <bigfile+0xda>
  for (i = 0; i < N; i++) {
    4422:	2485                	addiw	s1,s1,1
    4424:	ff5493e3          	bne	s1,s5,440a <bigfile+0x48>
  close(fd);
    4428:	8552                	mv	a0,s4
    442a:	2d2010ef          	jal	56fc <close>
  fd = open("bigfile.dat", 0);
    442e:	4581                	li	a1,0
    4430:	00003517          	auipc	a0,0x3
    4434:	72050513          	addi	a0,a0,1824 # 7b50 <malloc+0x1f76>
    4438:	2dc010ef          	jal	5714 <open>
    443c:	8aaa                	mv	s5,a0
  total = 0;
    443e:	4a01                	li	s4,0
  for (i = 0;; i++) {
    4440:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    4442:	12c00993          	li	s3,300
    4446:	0000a917          	auipc	s2,0xa
    444a:	8a290913          	addi	s2,s2,-1886 # dce8 <buf>
  if (fd < 0) {
    444e:	06054163          	bltz	a0,44b0 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    4452:	864e                	mv	a2,s3
    4454:	85ca                	mv	a1,s2
    4456:	8556                	mv	a0,s5
    4458:	294010ef          	jal	56ec <read>
    if (cc < 0) {
    445c:	06054463          	bltz	a0,44c4 <bigfile+0x102>
    if (cc == 0)
    4460:	c145                	beqz	a0,4500 <bigfile+0x13e>
    if (cc != SZ / 2) {
    4462:	07351b63          	bne	a0,s3,44d8 <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    4466:	01f4d79b          	srliw	a5,s1,0x1f
    446a:	9fa5                	addw	a5,a5,s1
    446c:	4017d79b          	sraiw	a5,a5,0x1
    4470:	00094703          	lbu	a4,0(s2)
    4474:	06f71c63          	bne	a4,a5,44ec <bigfile+0x12a>
    4478:	12b94703          	lbu	a4,299(s2)
    447c:	06f71863          	bne	a4,a5,44ec <bigfile+0x12a>
    total += cc;
    4480:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    4484:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    4486:	b7f1                	j	4452 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    4488:	85da                	mv	a1,s6
    448a:	00003517          	auipc	a0,0x3
    448e:	6d650513          	addi	a0,a0,1750 # 7b60 <malloc+0x1f86>
    4492:	690010ef          	jal	5b22 <printf>
    exit(1);
    4496:	4505                	li	a0,1
    4498:	23c010ef          	jal	56d4 <exit>
      printf("%s: write bigfile failed\n", s);
    449c:	85da                	mv	a1,s6
    449e:	00003517          	auipc	a0,0x3
    44a2:	6e250513          	addi	a0,a0,1762 # 7b80 <malloc+0x1fa6>
    44a6:	67c010ef          	jal	5b22 <printf>
      exit(1);
    44aa:	4505                	li	a0,1
    44ac:	228010ef          	jal	56d4 <exit>
    printf("%s: cannot open bigfile\n", s);
    44b0:	85da                	mv	a1,s6
    44b2:	00003517          	auipc	a0,0x3
    44b6:	6ee50513          	addi	a0,a0,1774 # 7ba0 <malloc+0x1fc6>
    44ba:	668010ef          	jal	5b22 <printf>
    exit(1);
    44be:	4505                	li	a0,1
    44c0:	214010ef          	jal	56d4 <exit>
      printf("%s: read bigfile failed\n", s);
    44c4:	85da                	mv	a1,s6
    44c6:	00003517          	auipc	a0,0x3
    44ca:	6fa50513          	addi	a0,a0,1786 # 7bc0 <malloc+0x1fe6>
    44ce:	654010ef          	jal	5b22 <printf>
      exit(1);
    44d2:	4505                	li	a0,1
    44d4:	200010ef          	jal	56d4 <exit>
      printf("%s: short read bigfile\n", s);
    44d8:	85da                	mv	a1,s6
    44da:	00003517          	auipc	a0,0x3
    44de:	70650513          	addi	a0,a0,1798 # 7be0 <malloc+0x2006>
    44e2:	640010ef          	jal	5b22 <printf>
      exit(1);
    44e6:	4505                	li	a0,1
    44e8:	1ec010ef          	jal	56d4 <exit>
      printf("%s: read bigfile wrong data\n", s);
    44ec:	85da                	mv	a1,s6
    44ee:	00003517          	auipc	a0,0x3
    44f2:	70a50513          	addi	a0,a0,1802 # 7bf8 <malloc+0x201e>
    44f6:	62c010ef          	jal	5b22 <printf>
      exit(1);
    44fa:	4505                	li	a0,1
    44fc:	1d8010ef          	jal	56d4 <exit>
  close(fd);
    4500:	8556                	mv	a0,s5
    4502:	1fa010ef          	jal	56fc <close>
  if (total != N * SZ) {
    4506:	678d                	lui	a5,0x3
    4508:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x356>
    450c:	02fa1263          	bne	s4,a5,4530 <bigfile+0x16e>
  unlink("bigfile.dat");
    4510:	00003517          	auipc	a0,0x3
    4514:	64050513          	addi	a0,a0,1600 # 7b50 <malloc+0x1f76>
    4518:	20c010ef          	jal	5724 <unlink>
}
    451c:	70e2                	ld	ra,56(sp)
    451e:	7442                	ld	s0,48(sp)
    4520:	74a2                	ld	s1,40(sp)
    4522:	7902                	ld	s2,32(sp)
    4524:	69e2                	ld	s3,24(sp)
    4526:	6a42                	ld	s4,16(sp)
    4528:	6aa2                	ld	s5,8(sp)
    452a:	6b02                	ld	s6,0(sp)
    452c:	6121                	addi	sp,sp,64
    452e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4530:	85da                	mv	a1,s6
    4532:	00003517          	auipc	a0,0x3
    4536:	6e650513          	addi	a0,a0,1766 # 7c18 <malloc+0x203e>
    453a:	5e8010ef          	jal	5b22 <printf>
    exit(1);
    453e:	4505                	li	a0,1
    4540:	194010ef          	jal	56d4 <exit>

0000000000004544 <bigargtest>:
{
    4544:	7121                	addi	sp,sp,-448
    4546:	ff06                	sd	ra,440(sp)
    4548:	fb22                	sd	s0,432(sp)
    454a:	f726                	sd	s1,424(sp)
    454c:	0380                	addi	s0,sp,448
    454e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4550:	00003517          	auipc	a0,0x3
    4554:	6e850513          	addi	a0,a0,1768 # 7c38 <malloc+0x205e>
    4558:	1cc010ef          	jal	5724 <unlink>
  pid = fork();
    455c:	170010ef          	jal	56cc <fork>
  if (pid == 0) {
    4560:	c915                	beqz	a0,4594 <bigargtest+0x50>
  } else if (pid < 0) {
    4562:	08054c63          	bltz	a0,45fa <bigargtest+0xb6>
  wait(&xstatus);
    4566:	fdc40513          	addi	a0,s0,-36
    456a:	172010ef          	jal	56dc <wait>
  if (xstatus != 0)
    456e:	fdc42503          	lw	a0,-36(s0)
    4572:	ed51                	bnez	a0,460e <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    4574:	4581                	li	a1,0
    4576:	00003517          	auipc	a0,0x3
    457a:	6c250513          	addi	a0,a0,1730 # 7c38 <malloc+0x205e>
    457e:	196010ef          	jal	5714 <open>
  if (fd < 0) {
    4582:	08054863          	bltz	a0,4612 <bigargtest+0xce>
  close(fd);
    4586:	176010ef          	jal	56fc <close>
}
    458a:	70fa                	ld	ra,440(sp)
    458c:	745a                	ld	s0,432(sp)
    458e:	74ba                	ld	s1,424(sp)
    4590:	6139                	addi	sp,sp,448
    4592:	8082                	ret
    memset(big, ' ', sizeof(big));
    4594:	19000613          	li	a2,400
    4598:	02000593          	li	a1,32
    459c:	e4840513          	addi	a0,s0,-440
    45a0:	70b000ef          	jal	54aa <memset>
    big[sizeof(big) - 1] = '\0';
    45a4:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    45a8:	00006797          	auipc	a5,0x6
    45ac:	f2878793          	addi	a5,a5,-216 # a4d0 <args.1>
    45b0:	00006697          	auipc	a3,0x6
    45b4:	01868693          	addi	a3,a3,24 # a5c8 <args.1+0xf8>
      args[i] = big;
    45b8:	e4840713          	addi	a4,s0,-440
    45bc:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    45be:	07a1                	addi	a5,a5,8
    45c0:	fed79ee3          	bne	a5,a3,45bc <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    45c4:	00006797          	auipc	a5,0x6
    45c8:	0007b223          	sd	zero,4(a5) # a5c8 <args.1+0xf8>
    exec("echo", args);
    45cc:	00006597          	auipc	a1,0x6
    45d0:	f0458593          	addi	a1,a1,-252 # a4d0 <args.1>
    45d4:	00001517          	auipc	a0,0x1
    45d8:	73450513          	addi	a0,a0,1844 # 5d08 <malloc+0x12e>
    45dc:	130010ef          	jal	570c <exec>
    fd = open("bigarg-ok", O_CREATE);
    45e0:	20000593          	li	a1,512
    45e4:	00003517          	auipc	a0,0x3
    45e8:	65450513          	addi	a0,a0,1620 # 7c38 <malloc+0x205e>
    45ec:	128010ef          	jal	5714 <open>
    close(fd);
    45f0:	10c010ef          	jal	56fc <close>
    exit(0);
    45f4:	4501                	li	a0,0
    45f6:	0de010ef          	jal	56d4 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    45fa:	85a6                	mv	a1,s1
    45fc:	00003517          	auipc	a0,0x3
    4600:	64c50513          	addi	a0,a0,1612 # 7c48 <malloc+0x206e>
    4604:	51e010ef          	jal	5b22 <printf>
    exit(1);
    4608:	4505                	li	a0,1
    460a:	0ca010ef          	jal	56d4 <exit>
    exit(xstatus);
    460e:	0c6010ef          	jal	56d4 <exit>
    printf("%s: bigarg test failed!\n", s);
    4612:	85a6                	mv	a1,s1
    4614:	00003517          	auipc	a0,0x3
    4618:	65450513          	addi	a0,a0,1620 # 7c68 <malloc+0x208e>
    461c:	506010ef          	jal	5b22 <printf>
    exit(1);
    4620:	4505                	li	a0,1
    4622:	0b2010ef          	jal	56d4 <exit>

0000000000004626 <partial_write>:
{
    4626:	bb010113          	addi	sp,sp,-1104
    462a:	44113423          	sd	ra,1096(sp)
    462e:	44813023          	sd	s0,1088(sp)
    4632:	42913c23          	sd	s1,1080(sp)
    4636:	43213823          	sd	s2,1072(sp)
    463a:	43313423          	sd	s3,1064(sp)
    463e:	43413023          	sd	s4,1056(sp)
    4642:	41513c23          	sd	s5,1048(sp)
    4646:	45010413          	addi	s0,sp,1104
    464a:	8aaa                	mv	s5,a0
  unlink("testfile");
    464c:	00003517          	auipc	a0,0x3
    4650:	63c50513          	addi	a0,a0,1596 # 7c88 <malloc+0x20ae>
    4654:	0d0010ef          	jal	5724 <unlink>
  int fd = open("testfile", O_CREATE | O_RDWR);
    4658:	20200593          	li	a1,514
    465c:	00003517          	auipc	a0,0x3
    4660:	62c50513          	addi	a0,a0,1580 # 7c88 <malloc+0x20ae>
    4664:	0b0010ef          	jal	5714 <open>
  if (fd < 0) {
    4668:	14054f63          	bltz	a0,47c6 <partial_write+0x1a0>
    466c:	84aa                	mv	s1,a0
  int cc = write(fd, "A", 1);
    466e:	4605                	li	a2,1
    4670:	00003597          	auipc	a1,0x3
    4674:	64858593          	addi	a1,a1,1608 # 7cb8 <malloc+0x20de>
    4678:	07c010ef          	jal	56f4 <write>
  if (cc != 1) {
    467c:	4785                	li	a5,1
    467e:	14f51e63          	bne	a0,a5,47da <partial_write+0x1b4>
  close(fd);
    4682:	8526                	mv	a0,s1
    4684:	078010ef          	jal	56fc <close>
  fd = open("testfile", O_RDWR);
    4688:	4589                	li	a1,2
    468a:	00003517          	auipc	a0,0x3
    468e:	5fe50513          	addi	a0,a0,1534 # 7c88 <malloc+0x20ae>
    4692:	082010ef          	jal	5714 <open>
    4696:	892a                	mv	s2,a0
  if (fd < 0) {
    4698:	14054b63          	bltz	a0,47ee <partial_write+0x1c8>
  char *p = sbrk(0);
    469c:	4501                	li	a0,0
    469e:	002010ef          	jal	56a0 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    46a2:	6485                	lui	s1,0x1
    46a4:	14fd                	addi	s1,s1,-1 # fff <bigdir+0x10b>
    46a6:	009577b3          	and	a5,a0,s1
    46aa:	6505                	lui	a0,0x1
    46ac:	9d1d                	subw	a0,a0,a5
    46ae:	7f3000ef          	jal	56a0 <sbrk>
  p = sbrk(0);
    46b2:	4501                	li	a0,0
    46b4:	7ed000ef          	jal	56a0 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    46b8:	8ce9                	and	s1,s1,a0
    46ba:	14049463          	bnez	s1,4802 <partial_write+0x1dc>
  p[-1] = 'X';
    46be:	05800793          	li	a5,88
    46c2:	fef50fa3          	sb	a5,-1(a0) # fff <bigdir+0x10b>
  cc = write(fd, p - 1, 2);
    46c6:	4609                	li	a2,2
    46c8:	fff50593          	addi	a1,a0,-1
    46cc:	854a                	mv	a0,s2
    46ce:	026010ef          	jal	56f4 <write>
  if (cc != -1) {
    46d2:	57fd                	li	a5,-1
    46d4:	14f51163          	bne	a0,a5,4816 <partial_write+0x1f0>
  close(fd);
    46d8:	854a                	mv	a0,s2
    46da:	022010ef          	jal	56fc <close>
  fd = open("testfile", O_RDONLY);
    46de:	4581                	li	a1,0
    46e0:	00003517          	auipc	a0,0x3
    46e4:	5a850513          	addi	a0,a0,1448 # 7c88 <malloc+0x20ae>
    46e8:	02c010ef          	jal	5714 <open>
    46ec:	84aa                	mv	s1,a0
  if (fd < 0) {
    46ee:	12054e63          	bltz	a0,482a <partial_write+0x204>
  cc = read(fd, &b, 1);
    46f2:	4605                	li	a2,1
    46f4:	fbf40593          	addi	a1,s0,-65
    46f8:	7f5000ef          	jal	56ec <read>
  if (cc != 1) {
    46fc:	4785                	li	a5,1
    46fe:	14f51063          	bne	a0,a5,483e <partial_write+0x218>
  close(fd);
    4702:	8526                	mv	a0,s1
    4704:	7f9000ef          	jal	56fc <close>
  if (b != 'X') {
    4708:	fbf44603          	lbu	a2,-65(s0)
    470c:	05800793          	li	a5,88
    4710:	14f61163          	bne	a2,a5,4852 <partial_write+0x22c>
  fd = open("bigfile", O_CREATE | O_RDWR);
    4714:	20200593          	li	a1,514
    4718:	00003517          	auipc	a0,0x3
    471c:	67050513          	addi	a0,a0,1648 # 7d88 <malloc+0x21ae>
    4720:	7f5000ef          	jal	5714 <open>
    4724:	8a2a                	mv	s4,a0
    4726:	04000913          	li	s2,64
    memset(buf, 0, sizeof(buf));
    472a:	bb840993          	addi	s3,s0,-1096
    472e:	40000493          	li	s1,1024
    4732:	8626                	mv	a2,s1
    4734:	4581                	li	a1,0
    4736:	854e                	mv	a0,s3
    4738:	573000ef          	jal	54aa <memset>
    cc = write(fd, buf, sizeof(buf));
    473c:	8626                	mv	a2,s1
    473e:	85ce                	mv	a1,s3
    4740:	8552                	mv	a0,s4
    4742:	7b3000ef          	jal	56f4 <write>
    if (cc != sizeof(buf)) {
    4746:	12951063          	bne	a0,s1,4866 <partial_write+0x240>
  for (int i = 0; i < 64; i++) {
    474a:	397d                	addiw	s2,s2,-1
    474c:	fe0913e3          	bnez	s2,4732 <partial_write+0x10c>
  close(fd);
    4750:	8552                	mv	a0,s4
    4752:	7ab000ef          	jal	56fc <close>
  unlink("bigfile");
    4756:	00003517          	auipc	a0,0x3
    475a:	63250513          	addi	a0,a0,1586 # 7d88 <malloc+0x21ae>
    475e:	7c7000ef          	jal	5724 <unlink>
  fd = open("testfile", O_RDONLY);
    4762:	4581                	li	a1,0
    4764:	00003517          	auipc	a0,0x3
    4768:	52450513          	addi	a0,a0,1316 # 7c88 <malloc+0x20ae>
    476c:	7a9000ef          	jal	5714 <open>
    4770:	84aa                	mv	s1,a0
  if (fd < 0) {
    4772:	10054463          	bltz	a0,487a <partial_write+0x254>
  cc = read(fd, &b, 1);
    4776:	4605                	li	a2,1
    4778:	fbf40593          	addi	a1,s0,-65
    477c:	771000ef          	jal	56ec <read>
  if (cc != 1) {
    4780:	4785                	li	a5,1
    4782:	10f51663          	bne	a0,a5,488e <partial_write+0x268>
  close(fd);
    4786:	8526                	mv	a0,s1
    4788:	775000ef          	jal	56fc <close>
  if (b != 'X') {
    478c:	fbf44603          	lbu	a2,-65(s0)
    4790:	05800793          	li	a5,88
    4794:	10f61763          	bne	a2,a5,48a2 <partial_write+0x27c>
  unlink("testfile");
    4798:	00003517          	auipc	a0,0x3
    479c:	4f050513          	addi	a0,a0,1264 # 7c88 <malloc+0x20ae>
    47a0:	785000ef          	jal	5724 <unlink>
}
    47a4:	44813083          	ld	ra,1096(sp)
    47a8:	44013403          	ld	s0,1088(sp)
    47ac:	43813483          	ld	s1,1080(sp)
    47b0:	43013903          	ld	s2,1072(sp)
    47b4:	42813983          	ld	s3,1064(sp)
    47b8:	42013a03          	ld	s4,1056(sp)
    47bc:	41813a83          	ld	s5,1048(sp)
    47c0:	45010113          	addi	sp,sp,1104
    47c4:	8082                	ret
    printf("%s: cannot create testfile\n", s);
    47c6:	85d6                	mv	a1,s5
    47c8:	00003517          	auipc	a0,0x3
    47cc:	4d050513          	addi	a0,a0,1232 # 7c98 <malloc+0x20be>
    47d0:	352010ef          	jal	5b22 <printf>
    exit(1);
    47d4:	4505                	li	a0,1
    47d6:	6ff000ef          	jal	56d4 <exit>
    printf("%s: could not write A\n", s);
    47da:	85d6                	mv	a1,s5
    47dc:	00003517          	auipc	a0,0x3
    47e0:	4e450513          	addi	a0,a0,1252 # 7cc0 <malloc+0x20e6>
    47e4:	33e010ef          	jal	5b22 <printf>
    exit(1);
    47e8:	4505                	li	a0,1
    47ea:	6eb000ef          	jal	56d4 <exit>
    printf("%s: cannot re-open testfile\n", s);
    47ee:	85d6                	mv	a1,s5
    47f0:	00003517          	auipc	a0,0x3
    47f4:	4e850513          	addi	a0,a0,1256 # 7cd8 <malloc+0x20fe>
    47f8:	32a010ef          	jal	5b22 <printf>
    exit(1);
    47fc:	4505                	li	a0,1
    47fe:	6d7000ef          	jal	56d4 <exit>
    printf("%s: sbrk did not align\n", s);
    4802:	85d6                	mv	a1,s5
    4804:	00003517          	auipc	a0,0x3
    4808:	4f450513          	addi	a0,a0,1268 # 7cf8 <malloc+0x211e>
    480c:	316010ef          	jal	5b22 <printf>
    exit(1);
    4810:	4505                	li	a0,1
    4812:	6c3000ef          	jal	56d4 <exit>
    printf("%s: write succeeded, should have failed\n", s);
    4816:	85d6                	mv	a1,s5
    4818:	00003517          	auipc	a0,0x3
    481c:	4f850513          	addi	a0,a0,1272 # 7d10 <malloc+0x2136>
    4820:	302010ef          	jal	5b22 <printf>
    exit(1);
    4824:	4505                	li	a0,1
    4826:	6af000ef          	jal	56d4 <exit>
    printf("%s: cannot re-open testfile\n", s);
    482a:	85d6                	mv	a1,s5
    482c:	00003517          	auipc	a0,0x3
    4830:	4ac50513          	addi	a0,a0,1196 # 7cd8 <malloc+0x20fe>
    4834:	2ee010ef          	jal	5b22 <printf>
    exit(1);
    4838:	4505                	li	a0,1
    483a:	69b000ef          	jal	56d4 <exit>
    printf("%s: cannot read testfile\n", s);
    483e:	85d6                	mv	a1,s5
    4840:	00003517          	auipc	a0,0x3
    4844:	50050513          	addi	a0,a0,1280 # 7d40 <malloc+0x2166>
    4848:	2da010ef          	jal	5b22 <printf>
    exit(1);
    484c:	4505                	li	a0,1
    484e:	687000ef          	jal	56d4 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    4852:	85d6                	mv	a1,s5
    4854:	00003517          	auipc	a0,0x3
    4858:	50c50513          	addi	a0,a0,1292 # 7d60 <malloc+0x2186>
    485c:	2c6010ef          	jal	5b22 <printf>
    exit(1);
    4860:	4505                	li	a0,1
    4862:	673000ef          	jal	56d4 <exit>
      printf("%s: could not write to bigfile\n", s);
    4866:	85d6                	mv	a1,s5
    4868:	00003517          	auipc	a0,0x3
    486c:	52850513          	addi	a0,a0,1320 # 7d90 <malloc+0x21b6>
    4870:	2b2010ef          	jal	5b22 <printf>
      exit(-1);
    4874:	557d                	li	a0,-1
    4876:	65f000ef          	jal	56d4 <exit>
    printf("%s: cannot re-open testfile\n", s);
    487a:	85d6                	mv	a1,s5
    487c:	00003517          	auipc	a0,0x3
    4880:	45c50513          	addi	a0,a0,1116 # 7cd8 <malloc+0x20fe>
    4884:	29e010ef          	jal	5b22 <printf>
    exit(1);
    4888:	4505                	li	a0,1
    488a:	64b000ef          	jal	56d4 <exit>
    printf("%s: cannot read testfile\n", s);
    488e:	85d6                	mv	a1,s5
    4890:	00003517          	auipc	a0,0x3
    4894:	4b050513          	addi	a0,a0,1200 # 7d40 <malloc+0x2166>
    4898:	28a010ef          	jal	5b22 <printf>
    exit(1);
    489c:	4505                	li	a0,1
    489e:	637000ef          	jal	56d4 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    48a2:	85d6                	mv	a1,s5
    48a4:	00003517          	auipc	a0,0x3
    48a8:	4bc50513          	addi	a0,a0,1212 # 7d60 <malloc+0x2186>
    48ac:	276010ef          	jal	5b22 <printf>
    exit(1);
    48b0:	4505                	li	a0,1
    48b2:	623000ef          	jal	56d4 <exit>

00000000000048b6 <lazy_alloc>:
{
    48b6:	1141                	addi	sp,sp,-16
    48b8:	e406                	sd	ra,8(sp)
    48ba:	e022                	sd	s0,0(sp)
    48bc:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    48be:	40000537          	lui	a0,0x40000
    48c2:	5f5000ef          	jal	56b6 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    48c6:	57fd                	li	a5,-1
    48c8:	02f50a63          	beq	a0,a5,48fc <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    48cc:	6605                	lui	a2,0x1
    48ce:	962a                	add	a2,a2,a0
    48d0:	400017b7          	lui	a5,0x40001
    48d4:	00f50733          	add	a4,a0,a5
    48d8:	87b2                	mv	a5,a2
    48da:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    48de:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    48e0:	97b6                	add	a5,a5,a3
    48e2:	fee79ee3          	bne	a5,a4,48de <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    48e6:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    48ea:	621c                	ld	a5,0(a2)
    48ec:	02c79163          	bne	a5,a2,490e <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    48f0:	9636                	add	a2,a2,a3
    48f2:	fee61ce3          	bne	a2,a4,48ea <lazy_alloc+0x34>
  exit(0);
    48f6:	4501                	li	a0,0
    48f8:	5dd000ef          	jal	56d4 <exit>
    printf("sbrklazy() failed\n");
    48fc:	00003517          	auipc	a0,0x3
    4900:	4b450513          	addi	a0,a0,1204 # 7db0 <malloc+0x21d6>
    4904:	21e010ef          	jal	5b22 <printf>
    exit(1);
    4908:	4505                	li	a0,1
    490a:	5cb000ef          	jal	56d4 <exit>
      printf("failed to read value from memory\n");
    490e:	00003517          	auipc	a0,0x3
    4912:	4ba50513          	addi	a0,a0,1210 # 7dc8 <malloc+0x21ee>
    4916:	20c010ef          	jal	5b22 <printf>
      exit(1);
    491a:	4505                	li	a0,1
    491c:	5b9000ef          	jal	56d4 <exit>

0000000000004920 <lazy_unmap>:
{
    4920:	7139                	addi	sp,sp,-64
    4922:	fc06                	sd	ra,56(sp)
    4924:	f822                	sd	s0,48(sp)
    4926:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    4928:	40000537          	lui	a0,0x40000
    492c:	58b000ef          	jal	56b6 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4930:	57fd                	li	a5,-1
    4932:	04f50863          	beq	a0,a5,4982 <lazy_unmap+0x62>
    4936:	f426                	sd	s1,40(sp)
    4938:	f04a                	sd	s2,32(sp)
    493a:	ec4e                	sd	s3,24(sp)
    493c:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    493e:	6905                	lui	s2,0x1
    4940:	992a                	add	s2,s2,a0
    4942:	400017b7          	lui	a5,0x40001
    4946:	00f504b3          	add	s1,a0,a5
    494a:	87ca                	mv	a5,s2
    494c:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4950:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4952:	97ba                	add	a5,a5,a4
    4954:	fe979ee3          	bne	a5,s1,4950 <lazy_unmap+0x30>
      wait(&status);
    4958:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    495c:	01000a37          	lui	s4,0x1000
    pid = fork();
    4960:	56d000ef          	jal	56cc <fork>
    if (pid < 0) {
    4964:	02054c63          	bltz	a0,499c <lazy_unmap+0x7c>
    } else if (pid == 0) {
    4968:	c139                	beqz	a0,49ae <lazy_unmap+0x8e>
      wait(&status);
    496a:	854e                	mv	a0,s3
    496c:	571000ef          	jal	56dc <wait>
      if (status == 0) {
    4970:	fcc42783          	lw	a5,-52(s0)
    4974:	c7b1                	beqz	a5,49c0 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4976:	9952                	add	s2,s2,s4
    4978:	fe9914e3          	bne	s2,s1,4960 <lazy_unmap+0x40>
  exit(0);
    497c:	4501                	li	a0,0
    497e:	557000ef          	jal	56d4 <exit>
    4982:	f426                	sd	s1,40(sp)
    4984:	f04a                	sd	s2,32(sp)
    4986:	ec4e                	sd	s3,24(sp)
    4988:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    498a:	00003517          	auipc	a0,0x3
    498e:	42650513          	addi	a0,a0,1062 # 7db0 <malloc+0x21d6>
    4992:	190010ef          	jal	5b22 <printf>
    exit(1);
    4996:	4505                	li	a0,1
    4998:	53d000ef          	jal	56d4 <exit>
      printf("error forking\n");
    499c:	00003517          	auipc	a0,0x3
    49a0:	45450513          	addi	a0,a0,1108 # 7df0 <malloc+0x2216>
    49a4:	17e010ef          	jal	5b22 <printf>
      exit(1);
    49a8:	4505                	li	a0,1
    49aa:	52b000ef          	jal	56d4 <exit>
      sbrklazy(-1L * REGION_SZ);
    49ae:	c0000537          	lui	a0,0xc0000
    49b2:	505000ef          	jal	56b6 <sbrklazy>
      *(char **)i = i;
    49b6:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    49ba:	4501                	li	a0,0
    49bc:	519000ef          	jal	56d4 <exit>
        printf("memory not unmapped\n");
    49c0:	00003517          	auipc	a0,0x3
    49c4:	44050513          	addi	a0,a0,1088 # 7e00 <malloc+0x2226>
    49c8:	15a010ef          	jal	5b22 <printf>
        exit(1);
    49cc:	4505                	li	a0,1
    49ce:	507000ef          	jal	56d4 <exit>

00000000000049d2 <lazy_copy>:
{
    49d2:	7119                	addi	sp,sp,-128
    49d4:	fc86                	sd	ra,120(sp)
    49d6:	f8a2                	sd	s0,112(sp)
    49d8:	f4a6                	sd	s1,104(sp)
    49da:	f0ca                	sd	s2,96(sp)
    49dc:	ecce                	sd	s3,88(sp)
    49de:	e8d2                	sd	s4,80(sp)
    49e0:	e4d6                	sd	s5,72(sp)
    49e2:	e0da                	sd	s6,64(sp)
    49e4:	fc5e                	sd	s7,56(sp)
    49e6:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    49e8:	4501                	li	a0,0
    49ea:	4b7000ef          	jal	56a0 <sbrk>
    49ee:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    49f0:	6511                	lui	a0,0x4
    49f2:	4c5000ef          	jal	56b6 <sbrklazy>
    open(p + 8192, 0);
    49f6:	4581                	li	a1,0
    49f8:	6509                	lui	a0,0x2
    49fa:	9526                	add	a0,a0,s1
    49fc:	519000ef          	jal	5714 <open>
    void *xx = sbrk(0);
    4a00:	4501                	li	a0,0
    4a02:	49f000ef          	jal	56a0 <sbrk>
    4a06:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    4a08:	fff54513          	not	a0,a0
    4a0c:	2501                	sext.w	a0,a0
    4a0e:	493000ef          	jal	56a0 <sbrk>
    if (ret != xx) {
    4a12:	00a48c63          	beq	s1,a0,4a2a <lazy_copy+0x58>
    4a16:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4a18:	00003517          	auipc	a0,0x3
    4a1c:	40050513          	addi	a0,a0,1024 # 7e18 <malloc+0x223e>
    4a20:	102010ef          	jal	5b22 <printf>
      exit(1);
    4a24:	4505                	li	a0,1
    4a26:	4af000ef          	jal	56d4 <exit>
  unsigned long bad[] = {
    4a2a:	00004797          	auipc	a5,0x4
    4a2e:	b9678793          	addi	a5,a5,-1130 # 85c0 <malloc+0x29e6>
    4a32:	7fa8                	ld	a0,120(a5)
    4a34:	63cc                	ld	a1,128(a5)
    4a36:	67d0                	ld	a2,136(a5)
    4a38:	6bd4                	ld	a3,144(a5)
    4a3a:	6fd8                	ld	a4,152(a5)
    4a3c:	f8a43023          	sd	a0,-128(s0)
    4a40:	f8b43423          	sd	a1,-120(s0)
    4a44:	f8c43823          	sd	a2,-112(s0)
    4a48:	f8d43c23          	sd	a3,-104(s0)
    4a4c:	fae43023          	sd	a4,-96(s0)
    4a50:	73dc                	ld	a5,160(a5)
    4a52:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4a56:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4a5a:	00001a97          	auipc	s5,0x1
    4a5e:	486a8a93          	addi	s5,s5,1158 # 5ee0 <malloc+0x306>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4a62:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4a66:	60200b93          	li	s7,1538
    4a6a:	00001b17          	auipc	s6,0x1
    4a6e:	386b0b13          	addi	s6,s6,902 # 5df0 <malloc+0x216>
    int fd = open("README", 0);
    4a72:	4581                	li	a1,0
    4a74:	8556                	mv	a0,s5
    4a76:	49f000ef          	jal	5714 <open>
    4a7a:	84aa                	mv	s1,a0
    if (fd < 0) {
    4a7c:	04054563          	bltz	a0,4ac6 <lazy_copy+0xf4>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4a80:	00093983          	ld	s3,0(s2)
    4a84:	8652                	mv	a2,s4
    4a86:	85ce                	mv	a1,s3
    4a88:	465000ef          	jal	56ec <read>
    4a8c:	04055663          	bgez	a0,4ad8 <lazy_copy+0x106>
    close(fd);
    4a90:	8526                	mv	a0,s1
    4a92:	46b000ef          	jal	56fc <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4a96:	85de                	mv	a1,s7
    4a98:	855a                	mv	a0,s6
    4a9a:	47b000ef          	jal	5714 <open>
    4a9e:	84aa                	mv	s1,a0
    if (fd < 0) {
    4aa0:	04054563          	bltz	a0,4aea <lazy_copy+0x118>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4aa4:	8652                	mv	a2,s4
    4aa6:	85ce                	mv	a1,s3
    4aa8:	44d000ef          	jal	56f4 <write>
    4aac:	04055863          	bgez	a0,4afc <lazy_copy+0x12a>
    close(fd);
    4ab0:	8526                	mv	a0,s1
    4ab2:	44b000ef          	jal	56fc <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4ab6:	0921                	addi	s2,s2,8
    4ab8:	fb040793          	addi	a5,s0,-80
    4abc:	faf91be3          	bne	s2,a5,4a72 <lazy_copy+0xa0>
  exit(0);
    4ac0:	4501                	li	a0,0
    4ac2:	413000ef          	jal	56d4 <exit>
      printf("cannot open README\n");
    4ac6:	00003517          	auipc	a0,0x3
    4aca:	38250513          	addi	a0,a0,898 # 7e48 <malloc+0x226e>
    4ace:	054010ef          	jal	5b22 <printf>
      exit(1);
    4ad2:	4505                	li	a0,1
    4ad4:	401000ef          	jal	56d4 <exit>
      printf("read succeeded\n");
    4ad8:	00003517          	auipc	a0,0x3
    4adc:	38850513          	addi	a0,a0,904 # 7e60 <malloc+0x2286>
    4ae0:	042010ef          	jal	5b22 <printf>
      exit(1);
    4ae4:	4505                	li	a0,1
    4ae6:	3ef000ef          	jal	56d4 <exit>
      printf("cannot open junk\n");
    4aea:	00003517          	auipc	a0,0x3
    4aee:	38650513          	addi	a0,a0,902 # 7e70 <malloc+0x2296>
    4af2:	030010ef          	jal	5b22 <printf>
      exit(1);
    4af6:	4505                	li	a0,1
    4af8:	3dd000ef          	jal	56d4 <exit>
      printf("write succeeded\n");
    4afc:	00003517          	auipc	a0,0x3
    4b00:	38c50513          	addi	a0,a0,908 # 7e88 <malloc+0x22ae>
    4b04:	01e010ef          	jal	5b22 <printf>
      exit(1);
    4b08:	4505                	li	a0,1
    4b0a:	3cb000ef          	jal	56d4 <exit>

0000000000004b0e <lazy_sbrk>:
{
    4b0e:	7179                	addi	sp,sp,-48
    4b10:	f406                	sd	ra,40(sp)
    4b12:	f022                	sd	s0,32(sp)
    4b14:	ec26                	sd	s1,24(sp)
    4b16:	e84a                	sd	s2,16(sp)
    4b18:	e44e                	sd	s3,8(sp)
    4b1a:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4b1c:	4501                	li	a0,0
    4b1e:	383000ef          	jal	56a0 <sbrk>
    4b22:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4b24:	0ff00793          	li	a5,255
    4b28:	07fa                	slli	a5,a5,0x1e
    4b2a:	00f57e63          	bgeu	a0,a5,4b46 <lazy_sbrk+0x38>
    p = sbrklazy(1 << 30);
    4b2e:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA - (1 << 30)) {
    4b32:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4b34:	854e                	mv	a0,s3
    4b36:	381000ef          	jal	56b6 <sbrklazy>
    p = sbrklazy(0);
    4b3a:	4501                	li	a0,0
    4b3c:	37b000ef          	jal	56b6 <sbrklazy>
    4b40:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4b42:	ff2569e3          	bltu	a0,s2,4b34 <lazy_sbrk+0x26>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    4b46:	7975                	lui	s2,0xffffd
    4b48:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4b4c:	854a                	mv	a0,s2
    4b4e:	369000ef          	jal	56b6 <sbrklazy>
    4b52:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4b54:	00950d63          	beq	a0,s1,4b6e <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4b58:	86a6                	mv	a3,s1
    4b5a:	85ca                	mv	a1,s2
    4b5c:	00003517          	auipc	a0,0x3
    4b60:	34450513          	addi	a0,a0,836 # 7ea0 <malloc+0x22c6>
    4b64:	7bf000ef          	jal	5b22 <printf>
    exit(1);
    4b68:	4505                	li	a0,1
    4b6a:	36b000ef          	jal	56d4 <exit>
  p = sbrk(PGSIZE);
    4b6e:	6505                	lui	a0,0x1
    4b70:	331000ef          	jal	56a0 <sbrk>
    4b74:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    4b76:	040007b7          	lui	a5,0x4000
    4b7a:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef315>
    4b7c:	07b2                	slli	a5,a5,0xc
    4b7e:	00f50c63          	beq	a0,a5,4b96 <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4b82:	6585                	lui	a1,0x1
    4b84:	00003517          	auipc	a0,0x3
    4b88:	34c50513          	addi	a0,a0,844 # 7ed0 <malloc+0x22f6>
    4b8c:	797000ef          	jal	5b22 <printf>
    exit(1);
    4b90:	4505                	li	a0,1
    4b92:	343000ef          	jal	56d4 <exit>
  p[0] = 1;
    4b96:	040007b7          	lui	a5,0x4000
    4b9a:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef315>
    4b9c:	07b2                	slli	a5,a5,0xc
    4b9e:	4705                	li	a4,1
    4ba0:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4ba4:	0017c783          	lbu	a5,1(a5)
    4ba8:	cb91                	beqz	a5,4bbc <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    4baa:	00003517          	auipc	a0,0x3
    4bae:	35e50513          	addi	a0,a0,862 # 7f08 <malloc+0x232e>
    4bb2:	771000ef          	jal	5b22 <printf>
    exit(1);
    4bb6:	4505                	li	a0,1
    4bb8:	31d000ef          	jal	56d4 <exit>
  p = sbrk(1);
    4bbc:	4505                	li	a0,1
    4bbe:	2e3000ef          	jal	56a0 <sbrk>
    4bc2:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4bc4:	57fd                	li	a5,-1
    4bc6:	00f50b63          	beq	a0,a5,4bdc <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    4bca:	00003517          	auipc	a0,0x3
    4bce:	36650513          	addi	a0,a0,870 # 7f30 <malloc+0x2356>
    4bd2:	751000ef          	jal	5b22 <printf>
    exit(1);
    4bd6:	4505                	li	a0,1
    4bd8:	2fd000ef          	jal	56d4 <exit>
  p = sbrklazy(1);
    4bdc:	4505                	li	a0,1
    4bde:	2d9000ef          	jal	56b6 <sbrklazy>
    4be2:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4be4:	57fd                	li	a5,-1
    4be6:	00f50b63          	beq	a0,a5,4bfc <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4bea:	00003517          	auipc	a0,0x3
    4bee:	36e50513          	addi	a0,a0,878 # 7f58 <malloc+0x237e>
    4bf2:	731000ef          	jal	5b22 <printf>
    exit(1);
    4bf6:	4505                	li	a0,1
    4bf8:	2dd000ef          	jal	56d4 <exit>
  exit(0);
    4bfc:	4501                	li	a0,0
    4bfe:	2d7000ef          	jal	56d4 <exit>

0000000000004c02 <lazy_copyinstr>:
{
    4c02:	715d                	addi	sp,sp,-80
    4c04:	e486                	sd	ra,72(sp)
    4c06:	e0a2                	sd	s0,64(sp)
    4c08:	fc26                	sd	s1,56(sp)
    4c0a:	f84a                	sd	s2,48(sp)
    4c0c:	f44e                	sd	s3,40(sp)
    4c0e:	0880                	addi	s0,sp,80
    4c10:	89aa                	mv	s3,a0
  char *p = sbrk(0);
    4c12:	4501                	li	a0,0
    4c14:	28d000ef          	jal	56a0 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4c18:	6485                	lui	s1,0x1
    4c1a:	14fd                	addi	s1,s1,-1 # fff <bigdir+0x10b>
    4c1c:	009577b3          	and	a5,a0,s1
    4c20:	6505                	lui	a0,0x1
    4c22:	9d1d                	subw	a0,a0,a5
    4c24:	27d000ef          	jal	56a0 <sbrk>
  p = sbrk(0);
    4c28:	4501                	li	a0,0
    4c2a:	277000ef          	jal	56a0 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    4c2e:	8ce9                	and	s1,s1,a0
    4c30:	e8a9                	bnez	s1,4c82 <lazy_copyinstr+0x80>
    4c32:	892a                	mv	s2,a0
  sbrklazy(2 * PGSIZE);
    4c34:	6509                	lui	a0,0x2
    4c36:	281000ef          	jal	56b6 <sbrklazy>
  p[4095] = '/';
    4c3a:	6505                	lui	a0,0x1
    4c3c:	00a907b3          	add	a5,s2,a0
    4c40:	02f00713          	li	a4,47
    4c44:	fee78fa3          	sb	a4,-1(a5)
  int fd = open(&p[4095], O_RDONLY);
    4c48:	157d                	addi	a0,a0,-1 # fff <bigdir+0x10b>
    4c4a:	4581                	li	a1,0
    4c4c:	954a                	add	a0,a0,s2
    4c4e:	2c7000ef          	jal	5714 <open>
    4c52:	84aa                	mv	s1,a0
  if (fd < 0) {
    4c54:	04054163          	bltz	a0,4c96 <lazy_copyinstr+0x94>
  int r = fstat(fd, &st);
    4c58:	fb840593          	addi	a1,s0,-72
    4c5c:	2d1000ef          	jal	572c <fstat>
  if (r < 0) {
    4c60:	04054463          	bltz	a0,4ca8 <lazy_copyinstr+0xa6>
  if (st.type != T_DIR) {
    4c64:	fc041703          	lh	a4,-64(s0)
    4c68:	4785                	li	a5,1
    4c6a:	04f71863          	bne	a4,a5,4cba <lazy_copyinstr+0xb8>
  close(fd);
    4c6e:	8526                	mv	a0,s1
    4c70:	28d000ef          	jal	56fc <close>
}
    4c74:	60a6                	ld	ra,72(sp)
    4c76:	6406                	ld	s0,64(sp)
    4c78:	74e2                	ld	s1,56(sp)
    4c7a:	7942                	ld	s2,48(sp)
    4c7c:	79a2                	ld	s3,40(sp)
    4c7e:	6161                	addi	sp,sp,80
    4c80:	8082                	ret
    printf("%s: sbrk did not align\n", s);
    4c82:	85ce                	mv	a1,s3
    4c84:	00003517          	auipc	a0,0x3
    4c88:	07450513          	addi	a0,a0,116 # 7cf8 <malloc+0x211e>
    4c8c:	697000ef          	jal	5b22 <printf>
    exit(1);
    4c90:	4505                	li	a0,1
    4c92:	243000ef          	jal	56d4 <exit>
    printf("could not open /");
    4c96:	00003517          	auipc	a0,0x3
    4c9a:	2f250513          	addi	a0,a0,754 # 7f88 <malloc+0x23ae>
    4c9e:	685000ef          	jal	5b22 <printf>
    exit(1);
    4ca2:	4505                	li	a0,1
    4ca4:	231000ef          	jal	56d4 <exit>
    printf("could not stat /");
    4ca8:	00003517          	auipc	a0,0x3
    4cac:	2f850513          	addi	a0,a0,760 # 7fa0 <malloc+0x23c6>
    4cb0:	673000ef          	jal	5b22 <printf>
    exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	21f000ef          	jal	56d4 <exit>
    printf("/ is not T_DIR");
    4cba:	00003517          	auipc	a0,0x3
    4cbe:	2fe50513          	addi	a0,a0,766 # 7fb8 <malloc+0x23de>
    4cc2:	661000ef          	jal	5b22 <printf>
    exit(1);
    4cc6:	4505                	li	a0,1
    4cc8:	20d000ef          	jal	56d4 <exit>

0000000000004ccc <fsfull>:
{
    4ccc:	7131                	addi	sp,sp,-192
    4cce:	fd06                	sd	ra,184(sp)
    4cd0:	f922                	sd	s0,176(sp)
    4cd2:	f526                	sd	s1,168(sp)
    4cd4:	f14a                	sd	s2,160(sp)
    4cd6:	ed4e                	sd	s3,152(sp)
    4cd8:	e952                	sd	s4,144(sp)
    4cda:	e556                	sd	s5,136(sp)
    4cdc:	e15a                	sd	s6,128(sp)
    4cde:	fcde                	sd	s7,120(sp)
    4ce0:	f8e2                	sd	s8,112(sp)
    4ce2:	f4e6                	sd	s9,104(sp)
    4ce4:	f0ea                	sd	s10,96(sp)
    4ce6:	ecee                	sd	s11,88(sp)
    4ce8:	0180                	addi	s0,sp,192
  printf("fsfull test\n");
    4cea:	00003517          	auipc	a0,0x3
    4cee:	2de50513          	addi	a0,a0,734 # 7fc8 <malloc+0x23ee>
    4cf2:	631000ef          	jal	5b22 <printf>
  int fsblocks = 0;
    4cf6:	4981                	li	s3,0
  for (nfiles = 0;; nfiles++) {
    4cf8:	4481                	li	s1,0
    name[0] = 'f';
    4cfa:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4cfe:	106257b7          	lui	a5,0x10625
    4d02:	dd378793          	addi	a5,a5,-557 # 10624dd3 <base+0x106140eb>
    4d06:	f4f43423          	sd	a5,-184(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d0a:	51eb8b37          	lui	s6,0x51eb8
    4d0e:	51fb0b13          	addi	s6,s6,1311 # 51eb851f <base+0x51ea7837>
    name[3] = '0' + (nfiles % 100) / 10;
    4d12:	66666ab7          	lui	s5,0x66666
    4d16:	667a8a93          	addi	s5,s5,1639 # 66666667 <base+0x6665597f>
    printf("writing %s\n", name);
    4d1a:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4d1e:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d22:	f4843783          	ld	a5,-184(s0)
    4d26:	02f487b3          	mul	a5,s1,a5
    4d2a:	9799                	srai	a5,a5,0x26
    4d2c:	41f4d69b          	sraiw	a3,s1,0x1f
    4d30:	9f95                	subw	a5,a5,a3
    4d32:	0307871b          	addiw	a4,a5,48
    4d36:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d3a:	3e800713          	li	a4,1000
    4d3e:	02f707bb          	mulw	a5,a4,a5
    4d42:	40f487bb          	subw	a5,s1,a5
    4d46:	03678733          	mul	a4,a5,s6
    4d4a:	9715                	srai	a4,a4,0x25
    4d4c:	41f7d79b          	sraiw	a5,a5,0x1f
    4d50:	40f707bb          	subw	a5,a4,a5
    4d54:	0307879b          	addiw	a5,a5,48
    4d58:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d5c:	036487b3          	mul	a5,s1,s6
    4d60:	9795                	srai	a5,a5,0x25
    4d62:	9f95                	subw	a5,a5,a3
    4d64:	06400713          	li	a4,100
    4d68:	02f707bb          	mulw	a5,a4,a5
    4d6c:	40f487bb          	subw	a5,s1,a5
    4d70:	03578733          	mul	a4,a5,s5
    4d74:	9709                	srai	a4,a4,0x22
    4d76:	41f7d79b          	sraiw	a5,a5,0x1f
    4d7a:	40f707bb          	subw	a5,a4,a5
    4d7e:	0307879b          	addiw	a5,a5,48
    4d82:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d86:	03548733          	mul	a4,s1,s5
    4d8a:	9709                	srai	a4,a4,0x22
    4d8c:	9f15                	subw	a4,a4,a3
    4d8e:	0027179b          	slliw	a5,a4,0x2
    4d92:	9fb9                	addw	a5,a5,a4
    4d94:	0017979b          	slliw	a5,a5,0x1
    4d98:	40f487bb          	subw	a5,s1,a5
    4d9c:	0307879b          	addiw	a5,a5,48
    4da0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4da4:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4da8:	85ea                	mv	a1,s10
    4daa:	00003517          	auipc	a0,0x3
    4dae:	22e50513          	addi	a0,a0,558 # 7fd8 <malloc+0x23fe>
    4db2:	571000ef          	jal	5b22 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4db6:	20200593          	li	a1,514
    4dba:	856a                	mv	a0,s10
    4dbc:	159000ef          	jal	5714 <open>
    4dc0:	892a                	mv	s2,a0
    if (fd < 0) {
    4dc2:	0e055c63          	bgez	a0,4eba <fsfull+0x1ee>
      printf("open %s failed\n", name);
    4dc6:	f5040593          	addi	a1,s0,-176
    4dca:	00003517          	auipc	a0,0x3
    4dce:	21e50513          	addi	a0,a0,542 # 7fe8 <malloc+0x240e>
    4dd2:	551000ef          	jal	5b22 <printf>
  while (nfiles >= 0) {
    4dd6:	0a04cc63          	bltz	s1,4e8e <fsfull+0x1c2>
    name[0] = 'f';
    4dda:	06600c93          	li	s9,102
    name[1] = '0' + nfiles / 1000;
    4dde:	10625ab7          	lui	s5,0x10625
    4de2:	dd3a8a93          	addi	s5,s5,-557 # 10624dd3 <base+0x106140eb>
    name[2] = '0' + (nfiles % 1000) / 100;
    4de6:	3e800c13          	li	s8,1000
    4dea:	51eb8a37          	lui	s4,0x51eb8
    4dee:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51ea7837>
    name[3] = '0' + (nfiles % 100) / 10;
    4df2:	06400b93          	li	s7,100
    4df6:	66666937          	lui	s2,0x66666
    4dfa:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x6665597f>
    unlink(name);
    4dfe:	f5040b13          	addi	s6,s0,-176
    name[0] = 'f';
    4e02:	f5940823          	sb	s9,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e06:	035487b3          	mul	a5,s1,s5
    4e0a:	9799                	srai	a5,a5,0x26
    4e0c:	41f4d69b          	sraiw	a3,s1,0x1f
    4e10:	9f95                	subw	a5,a5,a3
    4e12:	0307871b          	addiw	a4,a5,48
    4e16:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e1a:	02fc07bb          	mulw	a5,s8,a5
    4e1e:	40f487bb          	subw	a5,s1,a5
    4e22:	03478733          	mul	a4,a5,s4
    4e26:	9715                	srai	a4,a4,0x25
    4e28:	41f7d79b          	sraiw	a5,a5,0x1f
    4e2c:	40f707bb          	subw	a5,a4,a5
    4e30:	0307879b          	addiw	a5,a5,48
    4e34:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e38:	034487b3          	mul	a5,s1,s4
    4e3c:	9795                	srai	a5,a5,0x25
    4e3e:	9f95                	subw	a5,a5,a3
    4e40:	02fb87bb          	mulw	a5,s7,a5
    4e44:	40f487bb          	subw	a5,s1,a5
    4e48:	03278733          	mul	a4,a5,s2
    4e4c:	9709                	srai	a4,a4,0x22
    4e4e:	41f7d79b          	sraiw	a5,a5,0x1f
    4e52:	40f707bb          	subw	a5,a4,a5
    4e56:	0307879b          	addiw	a5,a5,48
    4e5a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e5e:	03248733          	mul	a4,s1,s2
    4e62:	9709                	srai	a4,a4,0x22
    4e64:	9f15                	subw	a4,a4,a3
    4e66:	0027179b          	slliw	a5,a4,0x2
    4e6a:	9fb9                	addw	a5,a5,a4
    4e6c:	0017979b          	slliw	a5,a5,0x1
    4e70:	40f487bb          	subw	a5,s1,a5
    4e74:	0307879b          	addiw	a5,a5,48
    4e78:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e7c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e80:	855a                	mv	a0,s6
    4e82:	0a3000ef          	jal	5724 <unlink>
    nfiles--;
    4e86:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4e88:	57fd                	li	a5,-1
    4e8a:	f6f49ce3          	bne	s1,a5,4e02 <fsfull+0x136>
  printf("fsfull test finished, %d blocks\n", fsblocks);
    4e8e:	85ce                	mv	a1,s3
    4e90:	00003517          	auipc	a0,0x3
    4e94:	17850513          	addi	a0,a0,376 # 8008 <malloc+0x242e>
    4e98:	48b000ef          	jal	5b22 <printf>
}
    4e9c:	70ea                	ld	ra,184(sp)
    4e9e:	744a                	ld	s0,176(sp)
    4ea0:	74aa                	ld	s1,168(sp)
    4ea2:	790a                	ld	s2,160(sp)
    4ea4:	69ea                	ld	s3,152(sp)
    4ea6:	6a4a                	ld	s4,144(sp)
    4ea8:	6aaa                	ld	s5,136(sp)
    4eaa:	6b0a                	ld	s6,128(sp)
    4eac:	7be6                	ld	s7,120(sp)
    4eae:	7c46                	ld	s8,112(sp)
    4eb0:	7ca6                	ld	s9,104(sp)
    4eb2:	7d06                	ld	s10,96(sp)
    4eb4:	6de6                	ld	s11,88(sp)
    4eb6:	6129                	addi	sp,sp,192
    4eb8:	8082                	ret
    int total = 0;
    4eba:	4a01                	li	s4,0
      int cc = write(fd, buf, BSIZE);
    4ebc:	40000c93          	li	s9,1024
    4ec0:	00009c17          	auipc	s8,0x9
    4ec4:	e28c0c13          	addi	s8,s8,-472 # dce8 <buf>
      if (cc < BSIZE)
    4ec8:	3ff00b93          	li	s7,1023
      int cc = write(fd, buf, BSIZE);
    4ecc:	8666                	mv	a2,s9
    4ece:	85e2                	mv	a1,s8
    4ed0:	854a                	mv	a0,s2
    4ed2:	023000ef          	jal	56f4 <write>
      if (cc < BSIZE)
    4ed6:	00abd663          	bge	s7,a0,4ee2 <fsfull+0x216>
      total += cc;
    4eda:	00aa0a3b          	addw	s4,s4,a0
      fsblocks++;
    4ede:	2985                	addiw	s3,s3,1 # 40000001 <base+0x3ffef319>
    while (1) {
    4ee0:	b7f5                	j	4ecc <fsfull+0x200>
    printf("wrote %d bytes\n", total);
    4ee2:	85d2                	mv	a1,s4
    4ee4:	00003517          	auipc	a0,0x3
    4ee8:	11450513          	addi	a0,a0,276 # 7ff8 <malloc+0x241e>
    4eec:	437000ef          	jal	5b22 <printf>
    close(fd);
    4ef0:	854a                	mv	a0,s2
    4ef2:	00b000ef          	jal	56fc <close>
    if (total == 0)
    4ef6:	ee0a00e3          	beqz	s4,4dd6 <fsfull+0x10a>
  for (nfiles = 0;; nfiles++) {
    4efa:	2485                	addiw	s1,s1,1
    4efc:	b50d                	j	4d1e <fsfull+0x52>

0000000000004efe <linkoverflow>:

void
linkoverflow(char *s)
{
    4efe:	7175                	addi	sp,sp,-144
    4f00:	e506                	sd	ra,136(sp)
    4f02:	e122                	sd	s0,128(sp)
    4f04:	fca6                	sd	s1,120(sp)
    4f06:	f8ca                	sd	s2,112(sp)
    4f08:	f4ce                	sd	s3,104(sp)
    4f0a:	f0d2                	sd	s4,96(sp)
    4f0c:	ecd6                	sd	s5,88(sp)
    4f0e:	e8da                	sd	s6,80(sp)
    4f10:	e4de                	sd	s7,72(sp)
    4f12:	e0e2                	sd	s8,64(sp)
    4f14:	fc66                	sd	s9,56(sp)
    4f16:	f86a                	sd	s10,48(sp)
    4f18:	0900                	addi	s0,sp,144
    4f1a:	8d2a                	mv	s10,a0
  enum { TARGET = 32768 };
  enum { DIRS = 64 };
  struct stat st;
  int i;

  unlink("/lof");
    4f1c:	00003517          	auipc	a0,0x3
    4f20:	11450513          	addi	a0,a0,276 # 8030 <malloc+0x2456>
    4f24:	001000ef          	jal	5724 <unlink>
  int fd = open("/lof", O_CREATE | O_RDWR);
    4f28:	20200593          	li	a1,514
    4f2c:	00003517          	auipc	a0,0x3
    4f30:	10450513          	addi	a0,a0,260 # 8030 <malloc+0x2456>
    4f34:	7e0000ef          	jal	5714 <open>
  if (fd < 0) {
    4f38:	02054863          	bltz	a0,4f68 <linkoverflow+0x6a>
    printf("%s: cannot create /lof\n", s);
    exit(1);
  }
  close(fd);
    4f3c:	7c0000ef          	jal	56fc <close>

  for (i = 0; i < TARGET; i++) {
    4f40:	4901                	li	s2,0
    int d = i % DIRS;
    int f = i / DIRS;

    char pn[16];
    pn[0] = '/';
    4f42:	02f00993          	li	s3,47
    pn[1] = 'd';
    4f46:	06400b93          	li	s7,100
    pn[2] = '_';
    4f4a:	05f00b13          	li	s6,95
    pn[3] = 'a' + (d / 16);
    pn[4] = 'a' + (d % 16);
    pn[5] = '\0';
    if (f == 0 && mkdir(pn) < 0) {
    4f4e:	f7840a13          	addi	s4,s0,-136
      printf("%s: mkdir(%s) failed\n", s, pn);
      exit(1);
    }

    pn[5] = '/';
    pn[6] = 'l';
    4f52:	06c00c93          	li	s9,108
    pn[7] = 'a' + (f / 256);
    pn[8] = 'a' + ((f / 16) % 16);
    pn[9] = 'a' + (f % 16);
    pn[10] = '\0';

    if (link("/lof", pn) < 0) {
    4f56:	00003c17          	auipc	s8,0x3
    4f5a:	0dac0c13          	addi	s8,s8,218 # 8030 <malloc+0x2456>
      }
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
      exit(1);
    }

    if (i % 100 == 0) {
    4f5e:	51eb8ab7          	lui	s5,0x51eb8
    4f62:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea7837>
    4f66:	a869                	j	5000 <linkoverflow+0x102>
    printf("%s: cannot create /lof\n", s);
    4f68:	85ea                	mv	a1,s10
    4f6a:	00003517          	auipc	a0,0x3
    4f6e:	0ce50513          	addi	a0,a0,206 # 8038 <malloc+0x245e>
    4f72:	3b1000ef          	jal	5b22 <printf>
    exit(1);
    4f76:	4505                	li	a0,1
    4f78:	75c000ef          	jal	56d4 <exit>
    pn[5] = '/';
    4f7c:	f7340ea3          	sb	s3,-131(s0)
    pn[6] = 'l';
    4f80:	f7940f23          	sb	s9,-130(s0)
    pn[7] = 'a' + (f / 256);
    4f84:	41f9579b          	sraiw	a5,s2,0x1f
    4f88:	0127d79b          	srliw	a5,a5,0x12
    4f8c:	012787bb          	addw	a5,a5,s2
    4f90:	40e7d79b          	sraiw	a5,a5,0xe
    4f94:	0617879b          	addiw	a5,a5,97
    4f98:	f6f40fa3          	sb	a5,-129(s0)
    pn[8] = 'a' + ((f / 16) % 16);
    4f9c:	41f4d71b          	sraiw	a4,s1,0x1f
    4fa0:	01c7571b          	srliw	a4,a4,0x1c
    4fa4:	9cb9                	addw	s1,s1,a4
    4fa6:	4044d79b          	sraiw	a5,s1,0x4
    4faa:	41f7d69b          	sraiw	a3,a5,0x1f
    4fae:	01c6d69b          	srliw	a3,a3,0x1c
    4fb2:	9fb5                	addw	a5,a5,a3
    4fb4:	8bbd                	andi	a5,a5,15
    4fb6:	9f95                	subw	a5,a5,a3
    4fb8:	0617879b          	addiw	a5,a5,97
    4fbc:	f8f40023          	sb	a5,-128(s0)
    pn[9] = 'a' + (f % 16);
    4fc0:	88bd                	andi	s1,s1,15
    4fc2:	9c99                	subw	s1,s1,a4
    4fc4:	0614849b          	addiw	s1,s1,97
    4fc8:	f89400a3          	sb	s1,-127(s0)
    pn[10] = '\0';
    4fcc:	f8040123          	sb	zero,-126(s0)
    if (link("/lof", pn) < 0) {
    4fd0:	85d2                	mv	a1,s4
    4fd2:	8562                	mv	a0,s8
    4fd4:	760000ef          	jal	5734 <link>
    4fd8:	08054a63          	bltz	a0,506c <linkoverflow+0x16e>
    if (i % 100 == 0) {
    4fdc:	03590733          	mul	a4,s2,s5
    4fe0:	9715                	srai	a4,a4,0x25
    4fe2:	41f9579b          	sraiw	a5,s2,0x1f
    4fe6:	9f1d                	subw	a4,a4,a5
    4fe8:	06400793          	li	a5,100
    4fec:	02e787bb          	mulw	a5,a5,a4
    4ff0:	40f907bb          	subw	a5,s2,a5
    4ff4:	10078363          	beqz	a5,50fa <linkoverflow+0x1fc>
  for (i = 0; i < TARGET; i++) {
    4ff8:	2905                	addiw	s2,s2,1
    4ffa:	67a1                	lui	a5,0x8
    4ffc:	08f90863          	beq	s2,a5,508c <linkoverflow+0x18e>
    int d = i % DIRS;
    5000:	41f9571b          	sraiw	a4,s2,0x1f
    5004:	01a7571b          	srliw	a4,a4,0x1a
    5008:	012704bb          	addw	s1,a4,s2
    500c:	03f4f793          	andi	a5,s1,63
    5010:	9f99                	subw	a5,a5,a4
    int f = i / DIRS;
    5012:	4064d49b          	sraiw	s1,s1,0x6
    pn[0] = '/';
    5016:	f7340c23          	sb	s3,-136(s0)
    pn[1] = 'd';
    501a:	f7740ca3          	sb	s7,-135(s0)
    pn[2] = '_';
    501e:	f7640d23          	sb	s6,-134(s0)
    pn[3] = 'a' + (d / 16);
    5022:	41f7d71b          	sraiw	a4,a5,0x1f
    5026:	01c7571b          	srliw	a4,a4,0x1c
    502a:	9fb9                	addw	a5,a5,a4
    502c:	4047d69b          	sraiw	a3,a5,0x4
    5030:	0616869b          	addiw	a3,a3,97 # 40061 <base+0x2f379>
    5034:	f6d40da3          	sb	a3,-133(s0)
    pn[4] = 'a' + (d % 16);
    5038:	8bbd                	andi	a5,a5,15
    503a:	9f99                	subw	a5,a5,a4
    503c:	0617879b          	addiw	a5,a5,97 # 8061 <malloc+0x2487>
    5040:	f6f40e23          	sb	a5,-132(s0)
    pn[5] = '\0';
    5044:	f6040ea3          	sb	zero,-131(s0)
    if (f == 0 && mkdir(pn) < 0) {
    5048:	f895                	bnez	s1,4f7c <linkoverflow+0x7e>
    504a:	8552                	mv	a0,s4
    504c:	6f0000ef          	jal	573c <mkdir>
    5050:	f20556e3          	bgez	a0,4f7c <linkoverflow+0x7e>
      printf("%s: mkdir(%s) failed\n", s, pn);
    5054:	f7840613          	addi	a2,s0,-136
    5058:	85ea                	mv	a1,s10
    505a:	00003517          	auipc	a0,0x3
    505e:	ff650513          	addi	a0,a0,-10 # 8050 <malloc+0x2476>
    5062:	2c1000ef          	jal	5b22 <printf>
      exit(1);
    5066:	4505                	li	a0,1
    5068:	66c000ef          	jal	56d4 <exit>
      if (stat("/lof", &st) < 0) {
    506c:	f8840593          	addi	a1,s0,-120
    5070:	00003517          	auipc	a0,0x3
    5074:	fc050513          	addi	a0,a0,-64 # 8030 <malloc+0x2456>
    5078:	4f6000ef          	jal	556e <stat>
    507c:	04054a63          	bltz	a0,50d0 <linkoverflow+0x1d2>
      if (st.nlink >= 32767) {
    5080:	f9241683          	lh	a3,-110(s0)
    5084:	67a1                	lui	a5,0x8
    5086:	17fd                	addi	a5,a5,-1 # 7fff <malloc+0x2425>
    5088:	04f69e63          	bne	a3,a5,50e4 <linkoverflow+0x1e6>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    }
  }

  if (stat("/lof", &st) < 0) {
    508c:	f8840593          	addi	a1,s0,-120
    5090:	00003517          	auipc	a0,0x3
    5094:	fa050513          	addi	a0,a0,-96 # 8030 <malloc+0x2456>
    5098:	4d6000ef          	jal	556e <stat>
    509c:	06054963          	bltz	a0,510e <linkoverflow+0x210>
    printf("%s: stat(/lof) failed\n", s);
    exit(1);
  }

  unlink("/lof");
    50a0:	00003517          	auipc	a0,0x3
    50a4:	f9050513          	addi	a0,a0,-112 # 8030 <malloc+0x2456>
    50a8:	67c000ef          	jal	5724 <unlink>

  if (st.nlink < 0) {
    50ac:	f9241603          	lh	a2,-110(s0)
    50b0:	06064963          	bltz	a2,5122 <linkoverflow+0x224>
    printf("%s: negative link count: %d\n", s, st.nlink);
    exit(1);
  }
}
    50b4:	60aa                	ld	ra,136(sp)
    50b6:	640a                	ld	s0,128(sp)
    50b8:	74e6                	ld	s1,120(sp)
    50ba:	7946                	ld	s2,112(sp)
    50bc:	79a6                	ld	s3,104(sp)
    50be:	7a06                	ld	s4,96(sp)
    50c0:	6ae6                	ld	s5,88(sp)
    50c2:	6b46                	ld	s6,80(sp)
    50c4:	6ba6                	ld	s7,72(sp)
    50c6:	6c06                	ld	s8,64(sp)
    50c8:	7ce2                	ld	s9,56(sp)
    50ca:	7d42                	ld	s10,48(sp)
    50cc:	6149                	addi	sp,sp,144
    50ce:	8082                	ret
        printf("%s: stat(/lof) failed\n", s);
    50d0:	85ea                	mv	a1,s10
    50d2:	00003517          	auipc	a0,0x3
    50d6:	f9650513          	addi	a0,a0,-106 # 8068 <malloc+0x248e>
    50da:	249000ef          	jal	5b22 <printf>
        exit(1);
    50de:	4505                	li	a0,1
    50e0:	5f4000ef          	jal	56d4 <exit>
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
    50e4:	864a                	mv	a2,s2
    50e6:	85ea                	mv	a1,s10
    50e8:	00003517          	auipc	a0,0x3
    50ec:	f9850513          	addi	a0,a0,-104 # 8080 <malloc+0x24a6>
    50f0:	233000ef          	jal	5b22 <printf>
      exit(1);
    50f4:	4505                	li	a0,1
    50f6:	5de000ef          	jal	56d4 <exit>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    50fa:	86d2                	mv	a3,s4
    50fc:	864a                	mv	a2,s2
    50fe:	85ea                	mv	a1,s10
    5100:	00003517          	auipc	a0,0x3
    5104:	fb050513          	addi	a0,a0,-80 # 80b0 <malloc+0x24d6>
    5108:	21b000ef          	jal	5b22 <printf>
    510c:	b5f5                	j	4ff8 <linkoverflow+0xfa>
    printf("%s: stat(/lof) failed\n", s);
    510e:	85ea                	mv	a1,s10
    5110:	00003517          	auipc	a0,0x3
    5114:	f5850513          	addi	a0,a0,-168 # 8068 <malloc+0x248e>
    5118:	20b000ef          	jal	5b22 <printf>
    exit(1);
    511c:	4505                	li	a0,1
    511e:	5b6000ef          	jal	56d4 <exit>
    printf("%s: negative link count: %d\n", s, st.nlink);
    5122:	85ea                	mv	a1,s10
    5124:	00003517          	auipc	a0,0x3
    5128:	fa450513          	addi	a0,a0,-92 # 80c8 <malloc+0x24ee>
    512c:	1f7000ef          	jal	5b22 <printf>
    exit(1);
    5130:	4505                	li	a0,1
    5132:	5a2000ef          	jal	56d4 <exit>

0000000000005136 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    5136:	7179                	addi	sp,sp,-48
    5138:	f406                	sd	ra,40(sp)
    513a:	f022                	sd	s0,32(sp)
    513c:	ec26                	sd	s1,24(sp)
    513e:	e84a                	sd	s2,16(sp)
    5140:	1800                	addi	s0,sp,48
    5142:	84aa                	mv	s1,a0
    5144:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5146:	00003517          	auipc	a0,0x3
    514a:	fa250513          	addi	a0,a0,-94 # 80e8 <malloc+0x250e>
    514e:	1d5000ef          	jal	5b22 <printf>
  if ((pid = fork()) < 0) {
    5152:	57a000ef          	jal	56cc <fork>
    5156:	02054a63          	bltz	a0,518a <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    515a:	c129                	beqz	a0,519c <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    515c:	fdc40513          	addi	a0,s0,-36
    5160:	57c000ef          	jal	56dc <wait>
    if (xstatus != 0)
    5164:	fdc42783          	lw	a5,-36(s0)
    5168:	cf9d                	beqz	a5,51a6 <run+0x70>
      printf("FAILED\n");
    516a:	00003517          	auipc	a0,0x3
    516e:	fa650513          	addi	a0,a0,-90 # 8110 <malloc+0x2536>
    5172:	1b1000ef          	jal	5b22 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5176:	fdc42503          	lw	a0,-36(s0)
  }
}
    517a:	00153513          	seqz	a0,a0
    517e:	70a2                	ld	ra,40(sp)
    5180:	7402                	ld	s0,32(sp)
    5182:	64e2                	ld	s1,24(sp)
    5184:	6942                	ld	s2,16(sp)
    5186:	6145                	addi	sp,sp,48
    5188:	8082                	ret
    printf("runtest: fork error\n");
    518a:	00003517          	auipc	a0,0x3
    518e:	f6e50513          	addi	a0,a0,-146 # 80f8 <malloc+0x251e>
    5192:	191000ef          	jal	5b22 <printf>
    exit(1);
    5196:	4505                	li	a0,1
    5198:	53c000ef          	jal	56d4 <exit>
    f(s);
    519c:	854a                	mv	a0,s2
    519e:	9482                	jalr	s1
    exit(0);
    51a0:	4501                	li	a0,0
    51a2:	532000ef          	jal	56d4 <exit>
      printf("OK\n");
    51a6:	00003517          	auipc	a0,0x3
    51aa:	f7250513          	addi	a0,a0,-142 # 8118 <malloc+0x253e>
    51ae:	175000ef          	jal	5b22 <printf>
    51b2:	b7d1                	j	5176 <run+0x40>

00000000000051b4 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    51b4:	7179                	addi	sp,sp,-48
    51b6:	f406                	sd	ra,40(sp)
    51b8:	f022                	sd	s0,32(sp)
    51ba:	ec26                	sd	s1,24(sp)
    51bc:	e44e                	sd	s3,8(sp)
    51be:	1800                	addi	s0,sp,48
    51c0:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    51c2:	6508                	ld	a0,8(a0)
    51c4:	cd29                	beqz	a0,521e <runtests+0x6a>
    51c6:	e84a                	sd	s2,16(sp)
    51c8:	e052                	sd	s4,0(sp)
    51ca:	892e                	mv	s2,a1
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    51cc:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    51ce:	00c03a33          	snez	s4,a2
  int ntests = 0;
    51d2:	4981                	li	s3,0
    51d4:	a029                	j	51de <runtests+0x2a>
      ntests++;
    51d6:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    51d8:	04c1                	addi	s1,s1,16
    51da:	6488                	ld	a0,8(s1)
    51dc:	c905                	beqz	a0,520c <runtests+0x58>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    51de:	00090663          	beqz	s2,51ea <runtests+0x36>
    51e2:	85ca                	mv	a1,s2
    51e4:	26a000ef          	jal	544e <strcmp>
    51e8:	f965                	bnez	a0,51d8 <runtests+0x24>
      if (!run(t->f, t->s)) {
    51ea:	648c                	ld	a1,8(s1)
    51ec:	6088                	ld	a0,0(s1)
    51ee:	f49ff0ef          	jal	5136 <run>
        if (continuous != 2) {
    51f2:	f175                	bnez	a0,51d6 <runtests+0x22>
    51f4:	fe0a01e3          	beqz	s4,51d6 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    51f8:	00003517          	auipc	a0,0x3
    51fc:	f2850513          	addi	a0,a0,-216 # 8120 <malloc+0x2546>
    5200:	123000ef          	jal	5b22 <printf>
          return -1;
    5204:	59fd                	li	s3,-1
    5206:	6942                	ld	s2,16(sp)
    5208:	6a02                	ld	s4,0(sp)
    520a:	a019                	j	5210 <runtests+0x5c>
    520c:	6942                	ld	s2,16(sp)
    520e:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    5210:	854e                	mv	a0,s3
    5212:	70a2                	ld	ra,40(sp)
    5214:	7402                	ld	s0,32(sp)
    5216:	64e2                	ld	s1,24(sp)
    5218:	69a2                	ld	s3,8(sp)
    521a:	6145                	addi	sp,sp,48
    521c:	8082                	ret
  return ntests;
    521e:	4981                	li	s3,0
    5220:	bfc5                	j	5210 <runtests+0x5c>

0000000000005222 <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    5222:	7179                	addi	sp,sp,-48
    5224:	f406                	sd	ra,40(sp)
    5226:	f022                	sd	s0,32(sp)
    5228:	ec26                	sd	s1,24(sp)
    522a:	e84a                	sd	s2,16(sp)
    522c:	e44e                	sd	s3,8(sp)
    522e:	e052                	sd	s4,0(sp)
    5230:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    5232:	4501                	li	a0,0
    5234:	46c000ef          	jal	56a0 <sbrk>
    5238:	8a2a                	mv	s4,a0
  int n = 0;
    523a:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    523c:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    523e:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    5240:	854e                	mv	a0,s3
    5242:	45e000ef          	jal	56a0 <sbrk>
    if (a == SBRK_ERROR) {
    5246:	01250463          	beq	a0,s2,524e <countfree+0x2c>
      break;
    }
    n += 1;
    524a:	2485                	addiw	s1,s1,1
  while (1) {
    524c:	bfd5                	j	5240 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    524e:	4501                	li	a0,0
    5250:	450000ef          	jal	56a0 <sbrk>
    5254:	40aa053b          	subw	a0,s4,a0
    5258:	448000ef          	jal	56a0 <sbrk>
  return n;
}
    525c:	8526                	mv	a0,s1
    525e:	70a2                	ld	ra,40(sp)
    5260:	7402                	ld	s0,32(sp)
    5262:	64e2                	ld	s1,24(sp)
    5264:	6942                	ld	s2,16(sp)
    5266:	69a2                	ld	s3,8(sp)
    5268:	6a02                	ld	s4,0(sp)
    526a:	6145                	addi	sp,sp,48
    526c:	8082                	ret

000000000000526e <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    526e:	7159                	addi	sp,sp,-112
    5270:	f486                	sd	ra,104(sp)
    5272:	f0a2                	sd	s0,96(sp)
    5274:	eca6                	sd	s1,88(sp)
    5276:	e8ca                	sd	s2,80(sp)
    5278:	e4ce                	sd	s3,72(sp)
    527a:	e0d2                	sd	s4,64(sp)
    527c:	fc56                	sd	s5,56(sp)
    527e:	f85a                	sd	s6,48(sp)
    5280:	f45e                	sd	s7,40(sp)
    5282:	f062                	sd	s8,32(sp)
    5284:	ec66                	sd	s9,24(sp)
    5286:	e86a                	sd	s10,16(sp)
    5288:	e46e                	sd	s11,8(sp)
    528a:	1880                	addi	s0,sp,112
    528c:	8aaa                	mv	s5,a0
    528e:	89ae                	mv	s3,a1
    5290:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    5292:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    5296:	00003c17          	auipc	s8,0x3
    529a:	ea2c0c13          	addi	s8,s8,-350 # 8138 <malloc+0x255e>
    n = runtests(quicktests, justone, continuous);
    529e:	00005b97          	auipc	s7,0x5
    52a2:	d72b8b93          	addi	s7,s7,-654 # a010 <quicktests>
      if (continuous != 2) {
    52a6:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    52a8:	00005c97          	auipc	s9,0x5
    52ac:	1a8c8c93          	addi	s9,s9,424 # a450 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    52b0:	00003d97          	auipc	s11,0x3
    52b4:	ec0d8d93          	addi	s11,s11,-320 # 8170 <malloc+0x2596>
    52b8:	a82d                	j	52f2 <drivetests+0x84>
      if (continuous != 2) {
    52ba:	0b699363          	bne	s3,s6,5360 <drivetests+0xf2>
    int ntests = 0;
    52be:	4481                	li	s1,0
    52c0:	a0b9                	j	530e <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    52c2:	00003517          	auipc	a0,0x3
    52c6:	e8e50513          	addi	a0,a0,-370 # 8150 <malloc+0x2576>
    52ca:	059000ef          	jal	5b22 <printf>
    52ce:	a0a1                	j	5316 <drivetests+0xa8>
        if (continuous != 2) {
    52d0:	05698b63          	beq	s3,s6,5326 <drivetests+0xb8>
          return 1;
    52d4:	4505                	li	a0,1
    52d6:	a0b5                	j	5342 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    52d8:	864a                	mv	a2,s2
    52da:	85aa                	mv	a1,a0
    52dc:	856e                	mv	a0,s11
    52de:	045000ef          	jal	5b22 <printf>
      if (continuous != 2) {
    52e2:	09699163          	bne	s3,s6,5364 <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    52e6:	e491                	bnez	s1,52f2 <drivetests+0x84>
    52e8:	000d0563          	beqz	s10,52f2 <drivetests+0x84>
    52ec:	a0a1                	j	5334 <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    52ee:	06098d63          	beqz	s3,5368 <drivetests+0xfa>
    printf("usertests starting\n");
    52f2:	8562                	mv	a0,s8
    52f4:	02f000ef          	jal	5b22 <printf>
    int free0 = countfree();
    52f8:	f2bff0ef          	jal	5222 <countfree>
    52fc:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    52fe:	864e                	mv	a2,s3
    5300:	85d2                	mv	a1,s4
    5302:	855e                	mv	a0,s7
    5304:	eb1ff0ef          	jal	51b4 <runtests>
    5308:	84aa                	mv	s1,a0
    if (n < 0) {
    530a:	fa0548e3          	bltz	a0,52ba <drivetests+0x4c>
    if (!quick) {
    530e:	000a9c63          	bnez	s5,5326 <drivetests+0xb8>
      if (justone == 0)
    5312:	fa0a08e3          	beqz	s4,52c2 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    5316:	864e                	mv	a2,s3
    5318:	85d2                	mv	a1,s4
    531a:	8566                	mv	a0,s9
    531c:	e99ff0ef          	jal	51b4 <runtests>
      if (n < 0) {
    5320:	fa0548e3          	bltz	a0,52d0 <drivetests+0x62>
        ntests += n;
    5324:	9ca9                	addw	s1,s1,a0
    if ((free1 = countfree()) < free0) {
    5326:	efdff0ef          	jal	5222 <countfree>
    532a:	fb2547e3          	blt	a0,s2,52d8 <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    532e:	f0e1                	bnez	s1,52ee <drivetests+0x80>
    5330:	fa0d0fe3          	beqz	s10,52ee <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    5334:	00003517          	auipc	a0,0x3
    5338:	e6c50513          	addi	a0,a0,-404 # 81a0 <malloc+0x25c6>
    533c:	7e6000ef          	jal	5b22 <printf>
      return 1;
    5340:	4505                	li	a0,1
  return 0;
}
    5342:	70a6                	ld	ra,104(sp)
    5344:	7406                	ld	s0,96(sp)
    5346:	64e6                	ld	s1,88(sp)
    5348:	6946                	ld	s2,80(sp)
    534a:	69a6                	ld	s3,72(sp)
    534c:	6a06                	ld	s4,64(sp)
    534e:	7ae2                	ld	s5,56(sp)
    5350:	7b42                	ld	s6,48(sp)
    5352:	7ba2                	ld	s7,40(sp)
    5354:	7c02                	ld	s8,32(sp)
    5356:	6ce2                	ld	s9,24(sp)
    5358:	6d42                	ld	s10,16(sp)
    535a:	6da2                	ld	s11,8(sp)
    535c:	6165                	addi	sp,sp,112
    535e:	8082                	ret
        return 1;
    5360:	4505                	li	a0,1
    5362:	b7c5                	j	5342 <drivetests+0xd4>
        return 1;
    5364:	4505                	li	a0,1
    5366:	bff1                	j	5342 <drivetests+0xd4>
  return 0;
    5368:	854e                	mv	a0,s3
    536a:	bfe1                	j	5342 <drivetests+0xd4>

000000000000536c <main>:

int
main(int argc, char *argv[])
{
    536c:	1101                	addi	sp,sp,-32
    536e:	ec06                	sd	ra,24(sp)
    5370:	e822                	sd	s0,16(sp)
    5372:	e426                	sd	s1,8(sp)
    5374:	e04a                	sd	s2,0(sp)
    5376:	1000                	addi	s0,sp,32
    5378:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    537a:	4789                	li	a5,2
    537c:	00f50e63          	beq	a0,a5,5398 <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    5380:	4785                	li	a5,1
    5382:	06a7c663          	blt	a5,a0,53ee <main+0x82>
  char *justone = 0;
    5386:	4601                	li	a2,0
  int quick = 0;
    5388:	4501                	li	a0,0
  int continuous = 0;
    538a:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    538c:	ee3ff0ef          	jal	526e <drivetests>
    5390:	cd35                	beqz	a0,540c <main+0xa0>
    exit(1);
    5392:	4505                	li	a0,1
    5394:	340000ef          	jal	56d4 <exit>
    5398:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    539a:	00003597          	auipc	a1,0x3
    539e:	e1e58593          	addi	a1,a1,-482 # 81b8 <malloc+0x25de>
    53a2:	00893503          	ld	a0,8(s2)
    53a6:	0a8000ef          	jal	544e <strcmp>
    53aa:	85aa                	mv	a1,a0
    53ac:	e501                	bnez	a0,53b4 <main+0x48>
  char *justone = 0;
    53ae:	4601                	li	a2,0
    quick = 1;
    53b0:	4505                	li	a0,1
    53b2:	bfe9                	j	538c <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    53b4:	00003597          	auipc	a1,0x3
    53b8:	e0c58593          	addi	a1,a1,-500 # 81c0 <malloc+0x25e6>
    53bc:	00893503          	ld	a0,8(s2)
    53c0:	08e000ef          	jal	544e <strcmp>
    53c4:	cd15                	beqz	a0,5400 <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    53c6:	00003597          	auipc	a1,0x3
    53ca:	e4a58593          	addi	a1,a1,-438 # 8210 <malloc+0x2636>
    53ce:	00893503          	ld	a0,8(s2)
    53d2:	07c000ef          	jal	544e <strcmp>
    53d6:	c905                	beqz	a0,5406 <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    53d8:	00893603          	ld	a2,8(s2)
    53dc:	00064703          	lbu	a4,0(a2)
    53e0:	02d00793          	li	a5,45
    53e4:	00f70563          	beq	a4,a5,53ee <main+0x82>
  int quick = 0;
    53e8:	4501                	li	a0,0
  int continuous = 0;
    53ea:	4581                	li	a1,0
    53ec:	b745                	j	538c <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    53ee:	00003517          	auipc	a0,0x3
    53f2:	dda50513          	addi	a0,a0,-550 # 81c8 <malloc+0x25ee>
    53f6:	72c000ef          	jal	5b22 <printf>
    exit(1);
    53fa:	4505                	li	a0,1
    53fc:	2d8000ef          	jal	56d4 <exit>
  char *justone = 0;
    5400:	4601                	li	a2,0
    continuous = 1;
    5402:	4585                	li	a1,1
    5404:	b761                	j	538c <main+0x20>
    continuous = 2;
    5406:	85a6                	mv	a1,s1
  char *justone = 0;
    5408:	4601                	li	a2,0
    540a:	b749                	j	538c <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    540c:	00003517          	auipc	a0,0x3
    5410:	dec50513          	addi	a0,a0,-532 # 81f8 <malloc+0x261e>
    5414:	70e000ef          	jal	5b22 <printf>
  exit(0);
    5418:	4501                	li	a0,0
    541a:	2ba000ef          	jal	56d4 <exit>

000000000000541e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    541e:	1141                	addi	sp,sp,-16
    5420:	e406                	sd	ra,8(sp)
    5422:	e022                	sd	s0,0(sp)
    5424:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    5426:	f47ff0ef          	jal	536c <main>
  exit(r);
    542a:	2aa000ef          	jal	56d4 <exit>

000000000000542e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    542e:	1141                	addi	sp,sp,-16
    5430:	e406                	sd	ra,8(sp)
    5432:	e022                	sd	s0,0(sp)
    5434:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    5436:	87aa                	mv	a5,a0
    5438:	0585                	addi	a1,a1,1
    543a:	0785                	addi	a5,a5,1
    543c:	fff5c703          	lbu	a4,-1(a1)
    5440:	fee78fa3          	sb	a4,-1(a5)
    5444:	fb75                	bnez	a4,5438 <strcpy+0xa>
    ;
  return os;
}
    5446:	60a2                	ld	ra,8(sp)
    5448:	6402                	ld	s0,0(sp)
    544a:	0141                	addi	sp,sp,16
    544c:	8082                	ret

000000000000544e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    544e:	1141                	addi	sp,sp,-16
    5450:	e406                	sd	ra,8(sp)
    5452:	e022                	sd	s0,0(sp)
    5454:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    5456:	00054783          	lbu	a5,0(a0)
    545a:	cb91                	beqz	a5,546e <strcmp+0x20>
    545c:	0005c703          	lbu	a4,0(a1)
    5460:	00f71763          	bne	a4,a5,546e <strcmp+0x20>
    p++, q++;
    5464:	0505                	addi	a0,a0,1
    5466:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    5468:	00054783          	lbu	a5,0(a0)
    546c:	fbe5                	bnez	a5,545c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    546e:	0005c503          	lbu	a0,0(a1)
}
    5472:	40a7853b          	subw	a0,a5,a0
    5476:	60a2                	ld	ra,8(sp)
    5478:	6402                	ld	s0,0(sp)
    547a:	0141                	addi	sp,sp,16
    547c:	8082                	ret

000000000000547e <strlen>:

uint
strlen(const char *s)
{
    547e:	1141                	addi	sp,sp,-16
    5480:	e406                	sd	ra,8(sp)
    5482:	e022                	sd	s0,0(sp)
    5484:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    5486:	00054783          	lbu	a5,0(a0)
    548a:	cf91                	beqz	a5,54a6 <strlen+0x28>
    548c:	00150793          	addi	a5,a0,1
    5490:	86be                	mv	a3,a5
    5492:	0785                	addi	a5,a5,1
    5494:	fff7c703          	lbu	a4,-1(a5)
    5498:	ff65                	bnez	a4,5490 <strlen+0x12>
    549a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    549e:	60a2                	ld	ra,8(sp)
    54a0:	6402                	ld	s0,0(sp)
    54a2:	0141                	addi	sp,sp,16
    54a4:	8082                	ret
  for (n = 0; s[n]; n++)
    54a6:	4501                	li	a0,0
    54a8:	bfdd                	j	549e <strlen+0x20>

00000000000054aa <memset>:

void *
memset(void *dst, int c, uint n)
{
    54aa:	1141                	addi	sp,sp,-16
    54ac:	e406                	sd	ra,8(sp)
    54ae:	e022                	sd	s0,0(sp)
    54b0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    54b2:	ca19                	beqz	a2,54c8 <memset+0x1e>
    54b4:	87aa                	mv	a5,a0
    54b6:	1602                	slli	a2,a2,0x20
    54b8:	9201                	srli	a2,a2,0x20
    54ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    54be:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    54c2:	0785                	addi	a5,a5,1
    54c4:	fee79de3          	bne	a5,a4,54be <memset+0x14>
  }
  return dst;
}
    54c8:	60a2                	ld	ra,8(sp)
    54ca:	6402                	ld	s0,0(sp)
    54cc:	0141                	addi	sp,sp,16
    54ce:	8082                	ret

00000000000054d0 <strchr>:

char *
strchr(const char *s, char c)
{
    54d0:	1141                	addi	sp,sp,-16
    54d2:	e406                	sd	ra,8(sp)
    54d4:	e022                	sd	s0,0(sp)
    54d6:	0800                	addi	s0,sp,16
  for (; *s; s++)
    54d8:	00054783          	lbu	a5,0(a0)
    54dc:	cf81                	beqz	a5,54f4 <strchr+0x24>
    if (*s == c)
    54de:	00f58763          	beq	a1,a5,54ec <strchr+0x1c>
  for (; *s; s++)
    54e2:	0505                	addi	a0,a0,1
    54e4:	00054783          	lbu	a5,0(a0)
    54e8:	fbfd                	bnez	a5,54de <strchr+0xe>
      return (char *)s;
  return 0;
    54ea:	4501                	li	a0,0
}
    54ec:	60a2                	ld	ra,8(sp)
    54ee:	6402                	ld	s0,0(sp)
    54f0:	0141                	addi	sp,sp,16
    54f2:	8082                	ret
  return 0;
    54f4:	4501                	li	a0,0
    54f6:	bfdd                	j	54ec <strchr+0x1c>

00000000000054f8 <gets>:

char *
gets(char *buf, int max)
{
    54f8:	711d                	addi	sp,sp,-96
    54fa:	ec86                	sd	ra,88(sp)
    54fc:	e8a2                	sd	s0,80(sp)
    54fe:	e4a6                	sd	s1,72(sp)
    5500:	e0ca                	sd	s2,64(sp)
    5502:	fc4e                	sd	s3,56(sp)
    5504:	f852                	sd	s4,48(sp)
    5506:	f456                	sd	s5,40(sp)
    5508:	f05a                	sd	s6,32(sp)
    550a:	ec5e                	sd	s7,24(sp)
    550c:	e862                	sd	s8,16(sp)
    550e:	1080                	addi	s0,sp,96
    5510:	8baa                	mv	s7,a0
    5512:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    5514:	892a                	mv	s2,a0
    5516:	4481                	li	s1,0
    cc = read(0, &c, 1);
    5518:	faf40b13          	addi	s6,s0,-81
    551c:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
    551e:	8c26                	mv	s8,s1
    5520:	0014899b          	addiw	s3,s1,1
    5524:	84ce                	mv	s1,s3
    5526:	0349d463          	bge	s3,s4,554e <gets+0x56>
    cc = read(0, &c, 1);
    552a:	8656                	mv	a2,s5
    552c:	85da                	mv	a1,s6
    552e:	4501                	li	a0,0
    5530:	1bc000ef          	jal	56ec <read>
    if (cc < 1)
    5534:	00a05d63          	blez	a0,554e <gets+0x56>
      break;
    buf[i++] = c;
    5538:	faf44783          	lbu	a5,-81(s0)
    553c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    5540:	0905                	addi	s2,s2,1
    5542:	ff678713          	addi	a4,a5,-10
    5546:	c319                	beqz	a4,554c <gets+0x54>
    5548:	17cd                	addi	a5,a5,-13
    554a:	fbf1                	bnez	a5,551e <gets+0x26>
    buf[i++] = c;
    554c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    554e:	9c5e                	add	s8,s8,s7
    5550:	000c0023          	sb	zero,0(s8)
  return buf;
}
    5554:	855e                	mv	a0,s7
    5556:	60e6                	ld	ra,88(sp)
    5558:	6446                	ld	s0,80(sp)
    555a:	64a6                	ld	s1,72(sp)
    555c:	6906                	ld	s2,64(sp)
    555e:	79e2                	ld	s3,56(sp)
    5560:	7a42                	ld	s4,48(sp)
    5562:	7aa2                	ld	s5,40(sp)
    5564:	7b02                	ld	s6,32(sp)
    5566:	6be2                	ld	s7,24(sp)
    5568:	6c42                	ld	s8,16(sp)
    556a:	6125                	addi	sp,sp,96
    556c:	8082                	ret

000000000000556e <stat>:

int
stat(const char *n, struct stat *st)
{
    556e:	1101                	addi	sp,sp,-32
    5570:	ec06                	sd	ra,24(sp)
    5572:	e822                	sd	s0,16(sp)
    5574:	e04a                	sd	s2,0(sp)
    5576:	1000                	addi	s0,sp,32
    5578:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    557a:	4581                	li	a1,0
    557c:	198000ef          	jal	5714 <open>
  if (fd < 0)
    5580:	02054263          	bltz	a0,55a4 <stat+0x36>
    5584:	e426                	sd	s1,8(sp)
    5586:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5588:	85ca                	mv	a1,s2
    558a:	1a2000ef          	jal	572c <fstat>
    558e:	892a                	mv	s2,a0
  close(fd);
    5590:	8526                	mv	a0,s1
    5592:	16a000ef          	jal	56fc <close>
  return r;
    5596:	64a2                	ld	s1,8(sp)
}
    5598:	854a                	mv	a0,s2
    559a:	60e2                	ld	ra,24(sp)
    559c:	6442                	ld	s0,16(sp)
    559e:	6902                	ld	s2,0(sp)
    55a0:	6105                	addi	sp,sp,32
    55a2:	8082                	ret
    return -1;
    55a4:	57fd                	li	a5,-1
    55a6:	893e                	mv	s2,a5
    55a8:	bfc5                	j	5598 <stat+0x2a>

00000000000055aa <atoi>:

int
atoi(const char *s)
{
    55aa:	1141                	addi	sp,sp,-16
    55ac:	e406                	sd	ra,8(sp)
    55ae:	e022                	sd	s0,0(sp)
    55b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    55b2:	00054683          	lbu	a3,0(a0)
    55b6:	fd06879b          	addiw	a5,a3,-48
    55ba:	0ff7f793          	zext.b	a5,a5
    55be:	4625                	li	a2,9
    55c0:	02f66963          	bltu	a2,a5,55f2 <atoi+0x48>
    55c4:	872a                	mv	a4,a0
  n = 0;
    55c6:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    55c8:	0705                	addi	a4,a4,1 # 1000001 <base+0xfef319>
    55ca:	0025179b          	slliw	a5,a0,0x2
    55ce:	9fa9                	addw	a5,a5,a0
    55d0:	0017979b          	slliw	a5,a5,0x1
    55d4:	9fb5                	addw	a5,a5,a3
    55d6:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    55da:	00074683          	lbu	a3,0(a4)
    55de:	fd06879b          	addiw	a5,a3,-48
    55e2:	0ff7f793          	zext.b	a5,a5
    55e6:	fef671e3          	bgeu	a2,a5,55c8 <atoi+0x1e>
  return n;
}
    55ea:	60a2                	ld	ra,8(sp)
    55ec:	6402                	ld	s0,0(sp)
    55ee:	0141                	addi	sp,sp,16
    55f0:	8082                	ret
  n = 0;
    55f2:	4501                	li	a0,0
    55f4:	bfdd                	j	55ea <atoi+0x40>

00000000000055f6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    55f6:	1141                	addi	sp,sp,-16
    55f8:	e406                	sd	ra,8(sp)
    55fa:	e022                	sd	s0,0(sp)
    55fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    55fe:	02b57563          	bgeu	a0,a1,5628 <memmove+0x32>
    while (n-- > 0)
    5602:	00c05f63          	blez	a2,5620 <memmove+0x2a>
    5606:	1602                	slli	a2,a2,0x20
    5608:	9201                	srli	a2,a2,0x20
    560a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    560e:	872a                	mv	a4,a0
      *dst++ = *src++;
    5610:	0585                	addi	a1,a1,1
    5612:	0705                	addi	a4,a4,1
    5614:	fff5c683          	lbu	a3,-1(a1)
    5618:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    561c:	fee79ae3          	bne	a5,a4,5610 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5620:	60a2                	ld	ra,8(sp)
    5622:	6402                	ld	s0,0(sp)
    5624:	0141                	addi	sp,sp,16
    5626:	8082                	ret
    while (n-- > 0)
    5628:	fec05ce3          	blez	a2,5620 <memmove+0x2a>
    dst += n;
    562c:	00c50733          	add	a4,a0,a2
    src += n;
    5630:	95b2                	add	a1,a1,a2
    5632:	fff6079b          	addiw	a5,a2,-1
    5636:	1782                	slli	a5,a5,0x20
    5638:	9381                	srli	a5,a5,0x20
    563a:	fff7c793          	not	a5,a5
    563e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5640:	15fd                	addi	a1,a1,-1
    5642:	177d                	addi	a4,a4,-1
    5644:	0005c683          	lbu	a3,0(a1)
    5648:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    564c:	fef71ae3          	bne	a4,a5,5640 <memmove+0x4a>
    5650:	bfc1                	j	5620 <memmove+0x2a>

0000000000005652 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5652:	1141                	addi	sp,sp,-16
    5654:	e406                	sd	ra,8(sp)
    5656:	e022                	sd	s0,0(sp)
    5658:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    565a:	c61d                	beqz	a2,5688 <memcmp+0x36>
    565c:	1602                	slli	a2,a2,0x20
    565e:	9201                	srli	a2,a2,0x20
    5660:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    5664:	00054783          	lbu	a5,0(a0)
    5668:	0005c703          	lbu	a4,0(a1)
    566c:	00e79863          	bne	a5,a4,567c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    5670:	0505                	addi	a0,a0,1
    p2++;
    5672:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5674:	fed518e3          	bne	a0,a3,5664 <memcmp+0x12>
  }
  return 0;
    5678:	4501                	li	a0,0
    567a:	a019                	j	5680 <memcmp+0x2e>
      return *p1 - *p2;
    567c:	40e7853b          	subw	a0,a5,a4
}
    5680:	60a2                	ld	ra,8(sp)
    5682:	6402                	ld	s0,0(sp)
    5684:	0141                	addi	sp,sp,16
    5686:	8082                	ret
  return 0;
    5688:	4501                	li	a0,0
    568a:	bfdd                	j	5680 <memcmp+0x2e>

000000000000568c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    568c:	1141                	addi	sp,sp,-16
    568e:	e406                	sd	ra,8(sp)
    5690:	e022                	sd	s0,0(sp)
    5692:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5694:	f63ff0ef          	jal	55f6 <memmove>
}
    5698:	60a2                	ld	ra,8(sp)
    569a:	6402                	ld	s0,0(sp)
    569c:	0141                	addi	sp,sp,16
    569e:	8082                	ret

00000000000056a0 <sbrk>:

char *
sbrk(int n)
{
    56a0:	1141                	addi	sp,sp,-16
    56a2:	e406                	sd	ra,8(sp)
    56a4:	e022                	sd	s0,0(sp)
    56a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    56a8:	4585                	li	a1,1
    56aa:	0b2000ef          	jal	575c <sys_sbrk>
}
    56ae:	60a2                	ld	ra,8(sp)
    56b0:	6402                	ld	s0,0(sp)
    56b2:	0141                	addi	sp,sp,16
    56b4:	8082                	ret

00000000000056b6 <sbrklazy>:

char *
sbrklazy(int n)
{
    56b6:	1141                	addi	sp,sp,-16
    56b8:	e406                	sd	ra,8(sp)
    56ba:	e022                	sd	s0,0(sp)
    56bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    56be:	4589                	li	a1,2
    56c0:	09c000ef          	jal	575c <sys_sbrk>
}
    56c4:	60a2                	ld	ra,8(sp)
    56c6:	6402                	ld	s0,0(sp)
    56c8:	0141                	addi	sp,sp,16
    56ca:	8082                	ret

00000000000056cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    56cc:	4885                	li	a7,1
 ecall
    56ce:	00000073          	ecall
 ret
    56d2:	8082                	ret

00000000000056d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    56d4:	4889                	li	a7,2
 ecall
    56d6:	00000073          	ecall
 ret
    56da:	8082                	ret

00000000000056dc <wait>:
.global wait
wait:
 li a7, SYS_wait
    56dc:	488d                	li	a7,3
 ecall
    56de:	00000073          	ecall
 ret
    56e2:	8082                	ret

00000000000056e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    56e4:	4891                	li	a7,4
 ecall
    56e6:	00000073          	ecall
 ret
    56ea:	8082                	ret

00000000000056ec <read>:
.global read
read:
 li a7, SYS_read
    56ec:	4895                	li	a7,5
 ecall
    56ee:	00000073          	ecall
 ret
    56f2:	8082                	ret

00000000000056f4 <write>:
.global write
write:
 li a7, SYS_write
    56f4:	48c1                	li	a7,16
 ecall
    56f6:	00000073          	ecall
 ret
    56fa:	8082                	ret

00000000000056fc <close>:
.global close
close:
 li a7, SYS_close
    56fc:	48d5                	li	a7,21
 ecall
    56fe:	00000073          	ecall
 ret
    5702:	8082                	ret

0000000000005704 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5704:	4899                	li	a7,6
 ecall
    5706:	00000073          	ecall
 ret
    570a:	8082                	ret

000000000000570c <exec>:
.global exec
exec:
 li a7, SYS_exec
    570c:	489d                	li	a7,7
 ecall
    570e:	00000073          	ecall
 ret
    5712:	8082                	ret

0000000000005714 <open>:
.global open
open:
 li a7, SYS_open
    5714:	48bd                	li	a7,15
 ecall
    5716:	00000073          	ecall
 ret
    571a:	8082                	ret

000000000000571c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    571c:	48c5                	li	a7,17
 ecall
    571e:	00000073          	ecall
 ret
    5722:	8082                	ret

0000000000005724 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5724:	48c9                	li	a7,18
 ecall
    5726:	00000073          	ecall
 ret
    572a:	8082                	ret

000000000000572c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    572c:	48a1                	li	a7,8
 ecall
    572e:	00000073          	ecall
 ret
    5732:	8082                	ret

0000000000005734 <link>:
.global link
link:
 li a7, SYS_link
    5734:	48cd                	li	a7,19
 ecall
    5736:	00000073          	ecall
 ret
    573a:	8082                	ret

000000000000573c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    573c:	48d1                	li	a7,20
 ecall
    573e:	00000073          	ecall
 ret
    5742:	8082                	ret

0000000000005744 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5744:	48a5                	li	a7,9
 ecall
    5746:	00000073          	ecall
 ret
    574a:	8082                	ret

000000000000574c <dup>:
.global dup
dup:
 li a7, SYS_dup
    574c:	48a9                	li	a7,10
 ecall
    574e:	00000073          	ecall
 ret
    5752:	8082                	ret

0000000000005754 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5754:	48ad                	li	a7,11
 ecall
    5756:	00000073          	ecall
 ret
    575a:	8082                	ret

000000000000575c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    575c:	48b1                	li	a7,12
 ecall
    575e:	00000073          	ecall
 ret
    5762:	8082                	ret

0000000000005764 <pause>:
.global pause
pause:
 li a7, SYS_pause
    5764:	48b5                	li	a7,13
 ecall
    5766:	00000073          	ecall
 ret
    576a:	8082                	ret

000000000000576c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    576c:	48b9                	li	a7,14
 ecall
    576e:	00000073          	ecall
 ret
    5772:	8082                	ret

0000000000005774 <sync>:
.global sync
sync:
 li a7, SYS_sync
    5774:	48d9                	li	a7,22
 ecall
    5776:	00000073          	ecall
 ret
    577a:	8082                	ret

000000000000577c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    577c:	1101                	addi	sp,sp,-32
    577e:	ec06                	sd	ra,24(sp)
    5780:	e822                	sd	s0,16(sp)
    5782:	1000                	addi	s0,sp,32
    5784:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5788:	4605                	li	a2,1
    578a:	fef40593          	addi	a1,s0,-17
    578e:	f67ff0ef          	jal	56f4 <write>
}
    5792:	60e2                	ld	ra,24(sp)
    5794:	6442                	ld	s0,16(sp)
    5796:	6105                	addi	sp,sp,32
    5798:	8082                	ret

000000000000579a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    579a:	715d                	addi	sp,sp,-80
    579c:	e486                	sd	ra,72(sp)
    579e:	e0a2                	sd	s0,64(sp)
    57a0:	f84a                	sd	s2,48(sp)
    57a2:	f44e                	sd	s3,40(sp)
    57a4:	0880                	addi	s0,sp,80
    57a6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    57a8:	c6d1                	beqz	a3,5834 <printint+0x9a>
    57aa:	0805d563          	bgez	a1,5834 <printint+0x9a>
    neg = 1;
    x = -xx;
    57ae:	40b005b3          	neg	a1,a1
    neg = 1;
    57b2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    57b4:	fb840993          	addi	s3,s0,-72
  neg = 0;
    57b8:	86ce                	mv	a3,s3
  i = 0;
    57ba:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    57bc:	00003817          	auipc	a6,0x3
    57c0:	eac80813          	addi	a6,a6,-340 # 8668 <digits>
    57c4:	88ba                	mv	a7,a4
    57c6:	0017051b          	addiw	a0,a4,1
    57ca:	872a                	mv	a4,a0
    57cc:	02c5f7b3          	remu	a5,a1,a2
    57d0:	97c2                	add	a5,a5,a6
    57d2:	0007c783          	lbu	a5,0(a5)
    57d6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    57da:	87ae                	mv	a5,a1
    57dc:	02c5d5b3          	divu	a1,a1,a2
    57e0:	0685                	addi	a3,a3,1
    57e2:	fec7f1e3          	bgeu	a5,a2,57c4 <printint+0x2a>
  if (neg)
    57e6:	00030c63          	beqz	t1,57fe <printint+0x64>
    buf[i++] = '-';
    57ea:	fd050793          	addi	a5,a0,-48
    57ee:	00878533          	add	a0,a5,s0
    57f2:	02d00793          	li	a5,45
    57f6:	fef50423          	sb	a5,-24(a0)
    57fa:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    57fe:	02e05563          	blez	a4,5828 <printint+0x8e>
    5802:	fc26                	sd	s1,56(sp)
    5804:	377d                	addiw	a4,a4,-1
    5806:	00e984b3          	add	s1,s3,a4
    580a:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    580c:	99ba                	add	s3,s3,a4
    580e:	1702                	slli	a4,a4,0x20
    5810:	9301                	srli	a4,a4,0x20
    5812:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5816:	0004c583          	lbu	a1,0(s1)
    581a:	854a                	mv	a0,s2
    581c:	f61ff0ef          	jal	577c <putc>
  while (--i >= 0)
    5820:	14fd                	addi	s1,s1,-1
    5822:	ff349ae3          	bne	s1,s3,5816 <printint+0x7c>
    5826:	74e2                	ld	s1,56(sp)
}
    5828:	60a6                	ld	ra,72(sp)
    582a:	6406                	ld	s0,64(sp)
    582c:	7942                	ld	s2,48(sp)
    582e:	79a2                	ld	s3,40(sp)
    5830:	6161                	addi	sp,sp,80
    5832:	8082                	ret
  neg = 0;
    5834:	4301                	li	t1,0
    5836:	bfbd                	j	57b4 <printint+0x1a>

0000000000005838 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5838:	711d                	addi	sp,sp,-96
    583a:	ec86                	sd	ra,88(sp)
    583c:	e8a2                	sd	s0,80(sp)
    583e:	e4a6                	sd	s1,72(sp)
    5840:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    5842:	0005c483          	lbu	s1,0(a1)
    5846:	22048363          	beqz	s1,5a6c <vprintf+0x234>
    584a:	e0ca                	sd	s2,64(sp)
    584c:	fc4e                	sd	s3,56(sp)
    584e:	f852                	sd	s4,48(sp)
    5850:	f456                	sd	s5,40(sp)
    5852:	f05a                	sd	s6,32(sp)
    5854:	ec5e                	sd	s7,24(sp)
    5856:	e862                	sd	s8,16(sp)
    5858:	8b2a                	mv	s6,a0
    585a:	8a2e                	mv	s4,a1
    585c:	8bb2                	mv	s7,a2
  state = 0;
    585e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    5860:	4901                	li	s2,0
    5862:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    5864:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    5868:	06400c13          	li	s8,100
    586c:	a00d                	j	588e <vprintf+0x56>
        putc(fd, c0);
    586e:	85a6                	mv	a1,s1
    5870:	855a                	mv	a0,s6
    5872:	f0bff0ef          	jal	577c <putc>
    5876:	a019                	j	587c <vprintf+0x44>
    } else if (state == '%') {
    5878:	03598363          	beq	s3,s5,589e <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
    587c:	0019079b          	addiw	a5,s2,1
    5880:	893e                	mv	s2,a5
    5882:	873e                	mv	a4,a5
    5884:	97d2                	add	a5,a5,s4
    5886:	0007c483          	lbu	s1,0(a5)
    588a:	1c048a63          	beqz	s1,5a5e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    588e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    5892:	fe0993e3          	bnez	s3,5878 <vprintf+0x40>
      if (c0 == '%') {
    5896:	fd579ce3          	bne	a5,s5,586e <vprintf+0x36>
        state = '%';
    589a:	89be                	mv	s3,a5
    589c:	b7c5                	j	587c <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
    589e:	00ea06b3          	add	a3,s4,a4
    58a2:	0016c603          	lbu	a2,1(a3)
      if (c1)
    58a6:	1c060863          	beqz	a2,5a76 <vprintf+0x23e>
      if (c0 == 'd') {
    58aa:	03878763          	beq	a5,s8,58d8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    58ae:	f9478693          	addi	a3,a5,-108
    58b2:	0016b693          	seqz	a3,a3
    58b6:	f9c60593          	addi	a1,a2,-100
    58ba:	e99d                	bnez	a1,58f0 <vprintf+0xb8>
    58bc:	ca95                	beqz	a3,58f0 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    58be:	008b8493          	addi	s1,s7,8
    58c2:	4685                	li	a3,1
    58c4:	4629                	li	a2,10
    58c6:	000bb583          	ld	a1,0(s7)
    58ca:	855a                	mv	a0,s6
    58cc:	ecfff0ef          	jal	579a <printint>
        i += 1;
    58d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    58d2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    58d4:	4981                	li	s3,0
    58d6:	b75d                	j	587c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    58d8:	008b8493          	addi	s1,s7,8
    58dc:	4685                	li	a3,1
    58de:	4629                	li	a2,10
    58e0:	000ba583          	lw	a1,0(s7)
    58e4:	855a                	mv	a0,s6
    58e6:	eb5ff0ef          	jal	579a <printint>
    58ea:	8ba6                	mv	s7,s1
      state = 0;
    58ec:	4981                	li	s3,0
    58ee:	b779                	j	587c <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
    58f0:	9752                	add	a4,a4,s4
    58f2:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    58f6:	f9460713          	addi	a4,a2,-108
    58fa:	00173713          	seqz	a4,a4
    58fe:	8f75                	and	a4,a4,a3
    5900:	f9c58513          	addi	a0,a1,-100
    5904:	18051363          	bnez	a0,5a8a <vprintf+0x252>
    5908:	18070163          	beqz	a4,5a8a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    590c:	008b8493          	addi	s1,s7,8
    5910:	4685                	li	a3,1
    5912:	4629                	li	a2,10
    5914:	000bb583          	ld	a1,0(s7)
    5918:	855a                	mv	a0,s6
    591a:	e81ff0ef          	jal	579a <printint>
        i += 2;
    591e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5920:	8ba6                	mv	s7,s1
      state = 0;
    5922:	4981                	li	s3,0
        i += 2;
    5924:	bfa1                	j	587c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5926:	008b8493          	addi	s1,s7,8
    592a:	4681                	li	a3,0
    592c:	4629                	li	a2,10
    592e:	000be583          	lwu	a1,0(s7)
    5932:	855a                	mv	a0,s6
    5934:	e67ff0ef          	jal	579a <printint>
    5938:	8ba6                	mv	s7,s1
      state = 0;
    593a:	4981                	li	s3,0
    593c:	b781                	j	587c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    593e:	008b8493          	addi	s1,s7,8
    5942:	4681                	li	a3,0
    5944:	4629                	li	a2,10
    5946:	000bb583          	ld	a1,0(s7)
    594a:	855a                	mv	a0,s6
    594c:	e4fff0ef          	jal	579a <printint>
        i += 1;
    5950:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5952:	8ba6                	mv	s7,s1
      state = 0;
    5954:	4981                	li	s3,0
    5956:	b71d                	j	587c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5958:	008b8493          	addi	s1,s7,8
    595c:	4681                	li	a3,0
    595e:	4629                	li	a2,10
    5960:	000bb583          	ld	a1,0(s7)
    5964:	855a                	mv	a0,s6
    5966:	e35ff0ef          	jal	579a <printint>
        i += 2;
    596a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    596c:	8ba6                	mv	s7,s1
      state = 0;
    596e:	4981                	li	s3,0
        i += 2;
    5970:	b731                	j	587c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5972:	008b8493          	addi	s1,s7,8
    5976:	4681                	li	a3,0
    5978:	4641                	li	a2,16
    597a:	000be583          	lwu	a1,0(s7)
    597e:	855a                	mv	a0,s6
    5980:	e1bff0ef          	jal	579a <printint>
    5984:	8ba6                	mv	s7,s1
      state = 0;
    5986:	4981                	li	s3,0
    5988:	bdd5                	j	587c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    598a:	008b8493          	addi	s1,s7,8
    598e:	4681                	li	a3,0
    5990:	4641                	li	a2,16
    5992:	000bb583          	ld	a1,0(s7)
    5996:	855a                	mv	a0,s6
    5998:	e03ff0ef          	jal	579a <printint>
        i += 1;
    599c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    599e:	8ba6                	mv	s7,s1
      state = 0;
    59a0:	4981                	li	s3,0
    59a2:	bde9                	j	587c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    59a4:	008b8493          	addi	s1,s7,8
    59a8:	4681                	li	a3,0
    59aa:	4641                	li	a2,16
    59ac:	000bb583          	ld	a1,0(s7)
    59b0:	855a                	mv	a0,s6
    59b2:	de9ff0ef          	jal	579a <printint>
        i += 2;
    59b6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    59b8:	8ba6                	mv	s7,s1
      state = 0;
    59ba:	4981                	li	s3,0
        i += 2;
    59bc:	b5c1                	j	587c <vprintf+0x44>
    59be:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    59c0:	008b8793          	addi	a5,s7,8
    59c4:	8cbe                	mv	s9,a5
    59c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    59ca:	03000593          	li	a1,48
    59ce:	855a                	mv	a0,s6
    59d0:	dadff0ef          	jal	577c <putc>
  putc(fd, 'x');
    59d4:	07800593          	li	a1,120
    59d8:	855a                	mv	a0,s6
    59da:	da3ff0ef          	jal	577c <putc>
    59de:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    59e0:	00003b97          	auipc	s7,0x3
    59e4:	c88b8b93          	addi	s7,s7,-888 # 8668 <digits>
    59e8:	03c9d793          	srli	a5,s3,0x3c
    59ec:	97de                	add	a5,a5,s7
    59ee:	0007c583          	lbu	a1,0(a5)
    59f2:	855a                	mv	a0,s6
    59f4:	d89ff0ef          	jal	577c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    59f8:	0992                	slli	s3,s3,0x4
    59fa:	34fd                	addiw	s1,s1,-1
    59fc:	f4f5                	bnez	s1,59e8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    59fe:	8be6                	mv	s7,s9
      state = 0;
    5a00:	4981                	li	s3,0
    5a02:	6ca2                	ld	s9,8(sp)
    5a04:	bda5                	j	587c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5a06:	008b8493          	addi	s1,s7,8
    5a0a:	000bc583          	lbu	a1,0(s7)
    5a0e:	855a                	mv	a0,s6
    5a10:	d6dff0ef          	jal	577c <putc>
    5a14:	8ba6                	mv	s7,s1
      state = 0;
    5a16:	4981                	li	s3,0
    5a18:	b595                	j	587c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5a1a:	008b8993          	addi	s3,s7,8
    5a1e:	000bb483          	ld	s1,0(s7)
    5a22:	cc91                	beqz	s1,5a3e <vprintf+0x206>
        for (; *s; s++)
    5a24:	0004c583          	lbu	a1,0(s1)
    5a28:	c985                	beqz	a1,5a58 <vprintf+0x220>
          putc(fd, *s);
    5a2a:	855a                	mv	a0,s6
    5a2c:	d51ff0ef          	jal	577c <putc>
        for (; *s; s++)
    5a30:	0485                	addi	s1,s1,1
    5a32:	0004c583          	lbu	a1,0(s1)
    5a36:	f9f5                	bnez	a1,5a2a <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
    5a38:	8bce                	mv	s7,s3
      state = 0;
    5a3a:	4981                	li	s3,0
    5a3c:	b581                	j	587c <vprintf+0x44>
          s = "(null)";
    5a3e:	00003497          	auipc	s1,0x3
    5a42:	b7a48493          	addi	s1,s1,-1158 # 85b8 <malloc+0x29de>
        for (; *s; s++)
    5a46:	02800593          	li	a1,40
    5a4a:	b7c5                	j	5a2a <vprintf+0x1f2>
        putc(fd, '%');
    5a4c:	85be                	mv	a1,a5
    5a4e:	855a                	mv	a0,s6
    5a50:	d2dff0ef          	jal	577c <putc>
      state = 0;
    5a54:	4981                	li	s3,0
    5a56:	b51d                	j	587c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5a58:	8bce                	mv	s7,s3
      state = 0;
    5a5a:	4981                	li	s3,0
    5a5c:	b505                	j	587c <vprintf+0x44>
    5a5e:	6906                	ld	s2,64(sp)
    5a60:	79e2                	ld	s3,56(sp)
    5a62:	7a42                	ld	s4,48(sp)
    5a64:	7aa2                	ld	s5,40(sp)
    5a66:	7b02                	ld	s6,32(sp)
    5a68:	6be2                	ld	s7,24(sp)
    5a6a:	6c42                	ld	s8,16(sp)
    }
  }
}
    5a6c:	60e6                	ld	ra,88(sp)
    5a6e:	6446                	ld	s0,80(sp)
    5a70:	64a6                	ld	s1,72(sp)
    5a72:	6125                	addi	sp,sp,96
    5a74:	8082                	ret
      if (c0 == 'd') {
    5a76:	06400713          	li	a4,100
    5a7a:	e4e78fe3          	beq	a5,a4,58d8 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
    5a7e:	f9478693          	addi	a3,a5,-108
    5a82:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5a86:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5a88:	4701                	li	a4,0
      } else if (c0 == 'u') {
    5a8a:	07500513          	li	a0,117
    5a8e:	e8a78ce3          	beq	a5,a0,5926 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
    5a92:	f8b60513          	addi	a0,a2,-117
    5a96:	e119                	bnez	a0,5a9c <vprintf+0x264>
    5a98:	ea0693e3          	bnez	a3,593e <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    5a9c:	f8b58513          	addi	a0,a1,-117
    5aa0:	e119                	bnez	a0,5aa6 <vprintf+0x26e>
    5aa2:	ea071be3          	bnez	a4,5958 <vprintf+0x120>
      } else if (c0 == 'x') {
    5aa6:	07800513          	li	a0,120
    5aaa:	eca784e3          	beq	a5,a0,5972 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
    5aae:	f8860613          	addi	a2,a2,-120
    5ab2:	e219                	bnez	a2,5ab8 <vprintf+0x280>
    5ab4:	ec069be3          	bnez	a3,598a <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5ab8:	f8858593          	addi	a1,a1,-120
    5abc:	e199                	bnez	a1,5ac2 <vprintf+0x28a>
    5abe:	ee0713e3          	bnez	a4,59a4 <vprintf+0x16c>
      } else if (c0 == 'p') {
    5ac2:	07000713          	li	a4,112
    5ac6:	eee78ce3          	beq	a5,a4,59be <vprintf+0x186>
      } else if (c0 == 'c') {
    5aca:	06300713          	li	a4,99
    5ace:	f2e78ce3          	beq	a5,a4,5a06 <vprintf+0x1ce>
      } else if (c0 == 's') {
    5ad2:	07300713          	li	a4,115
    5ad6:	f4e782e3          	beq	a5,a4,5a1a <vprintf+0x1e2>
      } else if (c0 == '%') {
    5ada:	02500713          	li	a4,37
    5ade:	f6e787e3          	beq	a5,a4,5a4c <vprintf+0x214>
        putc(fd, '%');
    5ae2:	02500593          	li	a1,37
    5ae6:	855a                	mv	a0,s6
    5ae8:	c95ff0ef          	jal	577c <putc>
        putc(fd, c0);
    5aec:	85a6                	mv	a1,s1
    5aee:	855a                	mv	a0,s6
    5af0:	c8dff0ef          	jal	577c <putc>
      state = 0;
    5af4:	4981                	li	s3,0
    5af6:	b359                	j	587c <vprintf+0x44>

0000000000005af8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5af8:	715d                	addi	sp,sp,-80
    5afa:	ec06                	sd	ra,24(sp)
    5afc:	e822                	sd	s0,16(sp)
    5afe:	1000                	addi	s0,sp,32
    5b00:	e010                	sd	a2,0(s0)
    5b02:	e414                	sd	a3,8(s0)
    5b04:	e818                	sd	a4,16(s0)
    5b06:	ec1c                	sd	a5,24(s0)
    5b08:	03043023          	sd	a6,32(s0)
    5b0c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5b10:	8622                	mv	a2,s0
    5b12:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5b16:	d23ff0ef          	jal	5838 <vprintf>
}
    5b1a:	60e2                	ld	ra,24(sp)
    5b1c:	6442                	ld	s0,16(sp)
    5b1e:	6161                	addi	sp,sp,80
    5b20:	8082                	ret

0000000000005b22 <printf>:

void
printf(const char *fmt, ...)
{
    5b22:	711d                	addi	sp,sp,-96
    5b24:	ec06                	sd	ra,24(sp)
    5b26:	e822                	sd	s0,16(sp)
    5b28:	1000                	addi	s0,sp,32
    5b2a:	e40c                	sd	a1,8(s0)
    5b2c:	e810                	sd	a2,16(s0)
    5b2e:	ec14                	sd	a3,24(s0)
    5b30:	f018                	sd	a4,32(s0)
    5b32:	f41c                	sd	a5,40(s0)
    5b34:	03043823          	sd	a6,48(s0)
    5b38:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5b3c:	00840613          	addi	a2,s0,8
    5b40:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5b44:	85aa                	mv	a1,a0
    5b46:	4505                	li	a0,1
    5b48:	cf1ff0ef          	jal	5838 <vprintf>
}
    5b4c:	60e2                	ld	ra,24(sp)
    5b4e:	6442                	ld	s0,16(sp)
    5b50:	6125                	addi	sp,sp,96
    5b52:	8082                	ret

0000000000005b54 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5b54:	1141                	addi	sp,sp,-16
    5b56:	e406                	sd	ra,8(sp)
    5b58:	e022                	sd	s0,0(sp)
    5b5a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5b5c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b60:	00005797          	auipc	a5,0x5
    5b64:	9607b783          	ld	a5,-1696(a5) # a4c0 <freep>
    5b68:	a039                	j	5b76 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5b6a:	6398                	ld	a4,0(a5)
    5b6c:	00e7e463          	bltu	a5,a4,5b74 <free+0x20>
    5b70:	00e6ea63          	bltu	a3,a4,5b84 <free+0x30>
{
    5b74:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b76:	fed7fae3          	bgeu	a5,a3,5b6a <free+0x16>
    5b7a:	6398                	ld	a4,0(a5)
    5b7c:	00e6e463          	bltu	a3,a4,5b84 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5b80:	fee7eae3          	bltu	a5,a4,5b74 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
    5b84:	ff852583          	lw	a1,-8(a0)
    5b88:	6390                	ld	a2,0(a5)
    5b8a:	02059813          	slli	a6,a1,0x20
    5b8e:	01c85713          	srli	a4,a6,0x1c
    5b92:	9736                	add	a4,a4,a3
    5b94:	02e60563          	beq	a2,a4,5bbe <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    5b98:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    5b9c:	4790                	lw	a2,8(a5)
    5b9e:	02061593          	slli	a1,a2,0x20
    5ba2:	01c5d713          	srli	a4,a1,0x1c
    5ba6:	973e                	add	a4,a4,a5
    5ba8:	02e68263          	beq	a3,a4,5bcc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    5bac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5bae:	00005717          	auipc	a4,0x5
    5bb2:	90f73923          	sd	a5,-1774(a4) # a4c0 <freep>
}
    5bb6:	60a2                	ld	ra,8(sp)
    5bb8:	6402                	ld	s0,0(sp)
    5bba:	0141                	addi	sp,sp,16
    5bbc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5bbe:	4618                	lw	a4,8(a2)
    5bc0:	9f2d                	addw	a4,a4,a1
    5bc2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5bc6:	6398                	ld	a4,0(a5)
    5bc8:	6310                	ld	a2,0(a4)
    5bca:	b7f9                	j	5b98 <free+0x44>
    p->s.size += bp->s.size;
    5bcc:	ff852703          	lw	a4,-8(a0)
    5bd0:	9f31                	addw	a4,a4,a2
    5bd2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5bd4:	ff053683          	ld	a3,-16(a0)
    5bd8:	bfd1                	j	5bac <free+0x58>

0000000000005bda <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5bda:	7139                	addi	sp,sp,-64
    5bdc:	fc06                	sd	ra,56(sp)
    5bde:	f822                	sd	s0,48(sp)
    5be0:	f04a                	sd	s2,32(sp)
    5be2:	ec4e                	sd	s3,24(sp)
    5be4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5be6:	02051993          	slli	s3,a0,0x20
    5bea:	0209d993          	srli	s3,s3,0x20
    5bee:	09bd                	addi	s3,s3,15
    5bf0:	0049d993          	srli	s3,s3,0x4
    5bf4:	2985                	addiw	s3,s3,1
    5bf6:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    5bf8:	00005517          	auipc	a0,0x5
    5bfc:	8c853503          	ld	a0,-1848(a0) # a4c0 <freep>
    5c00:	c905                	beqz	a0,5c30 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5c02:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5c04:	4798                	lw	a4,8(a5)
    5c06:	09377663          	bgeu	a4,s3,5c92 <malloc+0xb8>
    5c0a:	f426                	sd	s1,40(sp)
    5c0c:	e852                	sd	s4,16(sp)
    5c0e:	e456                	sd	s5,8(sp)
    5c10:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    5c12:	8a4e                	mv	s4,s3
    5c14:	6705                	lui	a4,0x1
    5c16:	00e9f363          	bgeu	s3,a4,5c1c <malloc+0x42>
    5c1a:	6a05                	lui	s4,0x1
    5c1c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5c20:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5c24:	00005497          	auipc	s1,0x5
    5c28:	89c48493          	addi	s1,s1,-1892 # a4c0 <freep>
  if (p == SBRK_ERROR)
    5c2c:	5afd                	li	s5,-1
    5c2e:	a83d                	j	5c6c <malloc+0x92>
    5c30:	f426                	sd	s1,40(sp)
    5c32:	e852                	sd	s4,16(sp)
    5c34:	e456                	sd	s5,8(sp)
    5c36:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5c38:	0000b797          	auipc	a5,0xb
    5c3c:	0b078793          	addi	a5,a5,176 # 10ce8 <base>
    5c40:	00005717          	auipc	a4,0x5
    5c44:	88f73023          	sd	a5,-1920(a4) # a4c0 <freep>
    5c48:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5c4a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5c4e:	b7d1                	j	5c12 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5c50:	6398                	ld	a4,0(a5)
    5c52:	e118                	sd	a4,0(a0)
    5c54:	a899                	j	5caa <malloc+0xd0>
  hp->s.size = nu;
    5c56:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5c5a:	0541                	addi	a0,a0,16
    5c5c:	ef9ff0ef          	jal	5b54 <free>
  return freep;
    5c60:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    5c62:	c125                	beqz	a0,5cc2 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5c64:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5c66:	4798                	lw	a4,8(a5)
    5c68:	03277163          	bgeu	a4,s2,5c8a <malloc+0xb0>
    if (p == freep)
    5c6c:	6098                	ld	a4,0(s1)
    5c6e:	853e                	mv	a0,a5
    5c70:	fef71ae3          	bne	a4,a5,5c64 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5c74:	8552                	mv	a0,s4
    5c76:	a2bff0ef          	jal	56a0 <sbrk>
  if (p == SBRK_ERROR)
    5c7a:	fd551ee3          	bne	a0,s5,5c56 <malloc+0x7c>
        return 0;
    5c7e:	4501                	li	a0,0
    5c80:	74a2                	ld	s1,40(sp)
    5c82:	6a42                	ld	s4,16(sp)
    5c84:	6aa2                	ld	s5,8(sp)
    5c86:	6b02                	ld	s6,0(sp)
    5c88:	a03d                	j	5cb6 <malloc+0xdc>
    5c8a:	74a2                	ld	s1,40(sp)
    5c8c:	6a42                	ld	s4,16(sp)
    5c8e:	6aa2                	ld	s5,8(sp)
    5c90:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5c92:	fae90fe3          	beq	s2,a4,5c50 <malloc+0x76>
        p->s.size -= nunits;
    5c96:	4137073b          	subw	a4,a4,s3
    5c9a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5c9c:	02071693          	slli	a3,a4,0x20
    5ca0:	01c6d713          	srli	a4,a3,0x1c
    5ca4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5ca6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5caa:	00005717          	auipc	a4,0x5
    5cae:	80a73b23          	sd	a0,-2026(a4) # a4c0 <freep>
      return (void *)(p + 1);
    5cb2:	01078513          	addi	a0,a5,16
  }
}
    5cb6:	70e2                	ld	ra,56(sp)
    5cb8:	7442                	ld	s0,48(sp)
    5cba:	7902                	ld	s2,32(sp)
    5cbc:	69e2                	ld	s3,24(sp)
    5cbe:	6121                	addi	sp,sp,64
    5cc0:	8082                	ret
    5cc2:	74a2                	ld	s1,40(sp)
    5cc4:	6a42                	ld	s4,16(sp)
    5cc6:	6aa2                	ld	s5,8(sp)
    5cc8:	6b02                	ld	s6,0(sp)
    5cca:	b7f5                	j	5cb6 <malloc+0xdc>
