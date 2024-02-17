
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot_header>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4                   	.byte 0xe4

0010000c <_start>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
  10000c:	bc 30 64 10 00       	mov    $0x106430,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
  100011:	b8 a5 08 10 00       	mov    $0x1008a5,%eax
  jmp *%eax
  100016:	ff e0                	jmp    *%eax

00100018 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
  100018:	55                   	push   %ebp
  100019:	89 e5                	mov    %esp,%ebp
  10001b:	83 ec 08             	sub    $0x8,%esp
  10001e:	8b 55 08             	mov    0x8(%ebp),%edx
  100021:	8b 45 0c             	mov    0xc(%ebp),%eax
  100024:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  100028:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10002c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100030:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100034:	66 ef                	out    %ax,(%dx)
}
  100036:	90                   	nop
  100037:	c9                   	leave  
  100038:	c3                   	ret    

00100039 <cli>:
  return eflags;
}

static inline void
cli(void)
{
  100039:	55                   	push   %ebp
  10003a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
  10003c:	fa                   	cli    
}
  10003d:	90                   	nop
  10003e:	5d                   	pop    %ebp
  10003f:	c3                   	ret    

00100040 <printint>:

static int panicked = 0;

static void
printint(int xx, int base, int sign)
{
  100040:	f3 0f 1e fb          	endbr32 
  100044:	55                   	push   %ebp
  100045:	89 e5                	mov    %esp,%ebp
  100047:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
  10004a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10004e:	74 1c                	je     10006c <printint+0x2c>
  100050:	8b 45 08             	mov    0x8(%ebp),%eax
  100053:	c1 e8 1f             	shr    $0x1f,%eax
  100056:	0f b6 c0             	movzbl %al,%eax
  100059:	89 45 10             	mov    %eax,0x10(%ebp)
  10005c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  100060:	74 0a                	je     10006c <printint+0x2c>
    x = -xx;
  100062:	8b 45 08             	mov    0x8(%ebp),%eax
  100065:	f7 d8                	neg    %eax
  100067:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10006a:	eb 06                	jmp    100072 <printint+0x32>
  else
    x = xx;
  10006c:	8b 45 08             	mov    0x8(%ebp),%eax
  10006f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
  100072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
  100079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10007f:	ba 00 00 00 00       	mov    $0x0,%edx
  100084:	f7 f1                	div    %ecx
  100086:	89 d1                	mov    %edx,%ecx
  100088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10008b:	8d 50 01             	lea    0x1(%eax),%edx
  10008e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100091:	0f b6 91 00 50 10 00 	movzbl 0x105000(%ecx),%edx
  100098:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
  10009c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10009f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1000a2:	ba 00 00 00 00       	mov    $0x0,%edx
  1000a7:	f7 f1                	div    %ecx
  1000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1000ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1000b0:	75 c7                	jne    100079 <printint+0x39>

  if(sign)
  1000b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1000b6:	74 2a                	je     1000e2 <printint+0xa2>
    buf[i++] = '-';
  1000b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000bb:	8d 50 01             	lea    0x1(%eax),%edx
  1000be:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1000c1:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
  1000c6:	eb 1a                	jmp    1000e2 <printint+0xa2>
    consputc(buf[i]);
  1000c8:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1000cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000ce:	01 d0                	add    %edx,%eax
  1000d0:	0f b6 00             	movzbl (%eax),%eax
  1000d3:	0f be c0             	movsbl %al,%eax
  1000d6:	83 ec 0c             	sub    $0xc,%esp
  1000d9:	50                   	push   %eax
  1000da:	e8 6b 02 00 00       	call   10034a <consputc>
  1000df:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
  1000e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1000e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1000ea:	79 dc                	jns    1000c8 <printint+0x88>
}
  1000ec:	90                   	nop
  1000ed:	90                   	nop
  1000ee:	c9                   	leave  
  1000ef:	c3                   	ret    

001000f0 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1000f0:	f3 0f 1e fb          	endbr32 
  1000f4:	55                   	push   %ebp
  1000f5:	89 e5                	mov    %esp,%ebp
  1000f7:	83 ec 18             	sub    $0x18,%esp
  int i, c;
  uint *argp;
  char *s;

  if (fmt == 0)
  1000fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fd:	85 c0                	test   %eax,%eax
  1000ff:	0f 84 63 01 00 00    	je     100268 <cprintf+0x178>
    // panic("null fmt");
    return;

  argp = (uint*)(void*)(&fmt + 1);
  100105:	8d 45 0c             	lea    0xc(%ebp),%eax
  100108:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10010b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100112:	e9 2f 01 00 00       	jmp    100246 <cprintf+0x156>
    if(c != '%'){
  100117:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  10011b:	74 13                	je     100130 <cprintf+0x40>
      consputc(c);
  10011d:	83 ec 0c             	sub    $0xc,%esp
  100120:	ff 75 e8             	pushl  -0x18(%ebp)
  100123:	e8 22 02 00 00       	call   10034a <consputc>
  100128:	83 c4 10             	add    $0x10,%esp
      continue;
  10012b:	e9 12 01 00 00       	jmp    100242 <cprintf+0x152>
    }
    c = fmt[++i] & 0xff;
  100130:	8b 55 08             	mov    0x8(%ebp),%edx
  100133:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10013a:	01 d0                	add    %edx,%eax
  10013c:	0f b6 00             	movzbl (%eax),%eax
  10013f:	0f be c0             	movsbl %al,%eax
  100142:	25 ff 00 00 00       	and    $0xff,%eax
  100147:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
  10014a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10014e:	0f 84 17 01 00 00    	je     10026b <cprintf+0x17b>
      break;
    switch(c){
  100154:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  100158:	74 5e                	je     1001b8 <cprintf+0xc8>
  10015a:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  10015e:	0f 8f c2 00 00 00    	jg     100226 <cprintf+0x136>
  100164:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  100168:	74 6b                	je     1001d5 <cprintf+0xe5>
  10016a:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  10016e:	0f 8f b2 00 00 00    	jg     100226 <cprintf+0x136>
  100174:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  100178:	74 3e                	je     1001b8 <cprintf+0xc8>
  10017a:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  10017e:	0f 8f a2 00 00 00    	jg     100226 <cprintf+0x136>
  100184:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  100188:	0f 84 89 00 00 00    	je     100217 <cprintf+0x127>
  10018e:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
  100192:	0f 85 8e 00 00 00    	jne    100226 <cprintf+0x136>
    case 'd':
      printint(*argp++, 10, 1);
  100198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10019b:	8d 50 04             	lea    0x4(%eax),%edx
  10019e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001a1:	8b 00                	mov    (%eax),%eax
  1001a3:	83 ec 04             	sub    $0x4,%esp
  1001a6:	6a 01                	push   $0x1
  1001a8:	6a 0a                	push   $0xa
  1001aa:	50                   	push   %eax
  1001ab:	e8 90 fe ff ff       	call   100040 <printint>
  1001b0:	83 c4 10             	add    $0x10,%esp
      break;
  1001b3:	e9 8a 00 00 00       	jmp    100242 <cprintf+0x152>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  1001b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001bb:	8d 50 04             	lea    0x4(%eax),%edx
  1001be:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001c1:	8b 00                	mov    (%eax),%eax
  1001c3:	83 ec 04             	sub    $0x4,%esp
  1001c6:	6a 00                	push   $0x0
  1001c8:	6a 10                	push   $0x10
  1001ca:	50                   	push   %eax
  1001cb:	e8 70 fe ff ff       	call   100040 <printint>
  1001d0:	83 c4 10             	add    $0x10,%esp
      break;
  1001d3:	eb 6d                	jmp    100242 <cprintf+0x152>
    case 's':
      if((s = (char*)*argp++) == 0)
  1001d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001d8:	8d 50 04             	lea    0x4(%eax),%edx
  1001db:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001de:	8b 00                	mov    (%eax),%eax
  1001e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1001e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1001e7:	75 22                	jne    10020b <cprintf+0x11b>
        s = "(null)";
  1001e9:	c7 45 ec fc 40 10 00 	movl   $0x1040fc,-0x14(%ebp)
      for(; *s; s++)
  1001f0:	eb 19                	jmp    10020b <cprintf+0x11b>
        consputc(*s);
  1001f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1001f5:	0f b6 00             	movzbl (%eax),%eax
  1001f8:	0f be c0             	movsbl %al,%eax
  1001fb:	83 ec 0c             	sub    $0xc,%esp
  1001fe:	50                   	push   %eax
  1001ff:	e8 46 01 00 00       	call   10034a <consputc>
  100204:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
  100207:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  10020b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10020e:	0f b6 00             	movzbl (%eax),%eax
  100211:	84 c0                	test   %al,%al
  100213:	75 dd                	jne    1001f2 <cprintf+0x102>
      break;
  100215:	eb 2b                	jmp    100242 <cprintf+0x152>
    case '%':
      consputc('%');
  100217:	83 ec 0c             	sub    $0xc,%esp
  10021a:	6a 25                	push   $0x25
  10021c:	e8 29 01 00 00       	call   10034a <consputc>
  100221:	83 c4 10             	add    $0x10,%esp
      break;
  100224:	eb 1c                	jmp    100242 <cprintf+0x152>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
  100226:	83 ec 0c             	sub    $0xc,%esp
  100229:	6a 25                	push   $0x25
  10022b:	e8 1a 01 00 00       	call   10034a <consputc>
  100230:	83 c4 10             	add    $0x10,%esp
      consputc(c);
  100233:	83 ec 0c             	sub    $0xc,%esp
  100236:	ff 75 e8             	pushl  -0x18(%ebp)
  100239:	e8 0c 01 00 00       	call   10034a <consputc>
  10023e:	83 c4 10             	add    $0x10,%esp
      break;
  100241:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100242:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100246:	8b 55 08             	mov    0x8(%ebp),%edx
  100249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10024c:	01 d0                	add    %edx,%eax
  10024e:	0f b6 00             	movzbl (%eax),%eax
  100251:	0f be c0             	movsbl %al,%eax
  100254:	25 ff 00 00 00       	and    $0xff,%eax
  100259:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10025c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  100260:	0f 85 b1 fe ff ff    	jne    100117 <cprintf+0x27>
  100266:	eb 04                	jmp    10026c <cprintf+0x17c>
    return;
  100268:	90                   	nop
  100269:	eb 01                	jmp    10026c <cprintf+0x17c>
      break;
  10026b:	90                   	nop
    }
  }
}
  10026c:	c9                   	leave  
  10026d:	c3                   	ret    

0010026e <halt>:

void
halt(void)
{
  10026e:	f3 0f 1e fb          	endbr32 
  100272:	55                   	push   %ebp
  100273:	89 e5                	mov    %esp,%ebp
  100275:	83 ec 08             	sub    $0x8,%esp
  cprintf("Bye COL%d!\n\0", 331);
  100278:	83 ec 08             	sub    $0x8,%esp
  10027b:	68 4b 01 00 00       	push   $0x14b
  100280:	68 03 41 10 00       	push   $0x104103
  100285:	e8 66 fe ff ff       	call   1000f0 <cprintf>
  10028a:	83 c4 10             	add    $0x10,%esp
  outw(0x602, 0x2000);
  10028d:	83 ec 08             	sub    $0x8,%esp
  100290:	68 00 20 00 00       	push   $0x2000
  100295:	68 02 06 00 00       	push   $0x602
  10029a:	e8 79 fd ff ff       	call   100018 <outw>
  10029f:	83 c4 10             	add    $0x10,%esp
  // For older versions of QEMU, 
  outw(0xB002, 0x2000);
  1002a2:	83 ec 08             	sub    $0x8,%esp
  1002a5:	68 00 20 00 00       	push   $0x2000
  1002aa:	68 02 b0 00 00       	push   $0xb002
  1002af:	e8 64 fd ff ff       	call   100018 <outw>
  1002b4:	83 c4 10             	add    $0x10,%esp
  for(;;);
  1002b7:	eb fe                	jmp    1002b7 <halt+0x49>

001002b9 <panic>:
}

void
panic(char *s)
{
  1002b9:	f3 0f 1e fb          	endbr32 
  1002bd:	55                   	push   %ebp
  1002be:	89 e5                	mov    %esp,%ebp
  1002c0:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
  1002c3:	e8 71 fd ff ff       	call   100039 <cli>
  cprintf("lapicid %d: panic: ", lapicid());
  1002c8:	e8 78 04 00 00       	call   100745 <lapicid>
  1002cd:	83 ec 08             	sub    $0x8,%esp
  1002d0:	50                   	push   %eax
  1002d1:	68 10 41 10 00       	push   $0x104110
  1002d6:	e8 15 fe ff ff       	call   1000f0 <cprintf>
  1002db:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
  1002de:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e1:	83 ec 0c             	sub    $0xc,%esp
  1002e4:	50                   	push   %eax
  1002e5:	e8 06 fe ff ff       	call   1000f0 <cprintf>
  1002ea:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
  1002ed:	83 ec 0c             	sub    $0xc,%esp
  1002f0:	68 24 41 10 00       	push   $0x104124
  1002f5:	e8 f6 fd ff ff       	call   1000f0 <cprintf>
  1002fa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
  1002fd:	83 ec 08             	sub    $0x8,%esp
  100300:	8d 45 cc             	lea    -0x34(%ebp),%eax
  100303:	50                   	push   %eax
  100304:	8d 45 08             	lea    0x8(%ebp),%eax
  100307:	50                   	push   %eax
  100308:	e8 2d 0f 00 00       	call   10123a <getcallerpcs>
  10030d:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100317:	eb 1c                	jmp    100335 <panic+0x7c>
    cprintf(" %p", pcs[i]);
  100319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10031c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
  100320:	83 ec 08             	sub    $0x8,%esp
  100323:	50                   	push   %eax
  100324:	68 26 41 10 00       	push   $0x104126
  100329:	e8 c2 fd ff ff       	call   1000f0 <cprintf>
  10032e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100331:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100335:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  100339:	7e de                	jle    100319 <panic+0x60>
  panicked = 1; // freeze other CPU
  10033b:	c7 05 20 54 10 00 01 	movl   $0x1,0x105420
  100342:	00 00 00 
  halt();
  100345:	e8 24 ff ff ff       	call   10026e <halt>

0010034a <consputc>:

#define BACKSPACE 0x100

void
consputc(int c)
{
  10034a:	f3 0f 1e fb          	endbr32 
  10034e:	55                   	push   %ebp
  10034f:	89 e5                	mov    %esp,%ebp
  100351:	83 ec 08             	sub    $0x8,%esp
  if(c == BACKSPACE){
  100354:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
  10035b:	75 29                	jne    100386 <consputc+0x3c>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  10035d:	83 ec 0c             	sub    $0xc,%esp
  100360:	6a 08                	push   $0x8
  100362:	e8 a3 0a 00 00       	call   100e0a <uartputc>
  100367:	83 c4 10             	add    $0x10,%esp
  10036a:	83 ec 0c             	sub    $0xc,%esp
  10036d:	6a 20                	push   $0x20
  10036f:	e8 96 0a 00 00       	call   100e0a <uartputc>
  100374:	83 c4 10             	add    $0x10,%esp
  100377:	83 ec 0c             	sub    $0xc,%esp
  10037a:	6a 08                	push   $0x8
  10037c:	e8 89 0a 00 00       	call   100e0a <uartputc>
  100381:	83 c4 10             	add    $0x10,%esp
  } else
    uartputc(c);
}
  100384:	eb 0e                	jmp    100394 <consputc+0x4a>
    uartputc(c);
  100386:	83 ec 0c             	sub    $0xc,%esp
  100389:	ff 75 08             	pushl  0x8(%ebp)
  10038c:	e8 79 0a 00 00       	call   100e0a <uartputc>
  100391:	83 c4 10             	add    $0x10,%esp
}
  100394:	90                   	nop
  100395:	c9                   	leave  
  100396:	c3                   	ret    

00100397 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100397:	f3 0f 1e fb          	endbr32 
  10039b:	55                   	push   %ebp
  10039c:	89 e5                	mov    %esp,%ebp
  10039e:	83 ec 18             	sub    $0x18,%esp
  int c;

  while((c = getc()) >= 0){
  1003a1:	e9 19 01 00 00       	jmp    1004bf <consoleintr+0x128>
    switch(c){
  1003a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  1003aa:	74 63                	je     10040f <consoleintr+0x78>
  1003ac:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  1003b0:	0f 8f 8b 00 00 00    	jg     100441 <consoleintr+0xaa>
  1003b6:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  1003ba:	74 53                	je     10040f <consoleintr+0x78>
  1003bc:	83 7d f4 15          	cmpl   $0x15,-0xc(%ebp)
  1003c0:	75 7f                	jne    100441 <consoleintr+0xaa>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1003c2:	eb 1d                	jmp    1003e1 <consoleintr+0x4a>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  1003c4:	a1 c8 64 10 00       	mov    0x1064c8,%eax
  1003c9:	83 e8 01             	sub    $0x1,%eax
  1003cc:	a3 c8 64 10 00       	mov    %eax,0x1064c8
        consputc(BACKSPACE);
  1003d1:	83 ec 0c             	sub    $0xc,%esp
  1003d4:	68 00 01 00 00       	push   $0x100
  1003d9:	e8 6c ff ff ff       	call   10034a <consputc>
  1003de:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
  1003e1:	8b 15 c8 64 10 00    	mov    0x1064c8,%edx
  1003e7:	a1 c4 64 10 00       	mov    0x1064c4,%eax
  1003ec:	39 c2                	cmp    %eax,%edx
  1003ee:	0f 84 cb 00 00 00    	je     1004bf <consoleintr+0x128>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1003f4:	a1 c8 64 10 00       	mov    0x1064c8,%eax
  1003f9:	83 e8 01             	sub    $0x1,%eax
  1003fc:	83 e0 7f             	and    $0x7f,%eax
  1003ff:	0f b6 80 40 64 10 00 	movzbl 0x106440(%eax),%eax
      while(input.e != input.w &&
  100406:	3c 0a                	cmp    $0xa,%al
  100408:	75 ba                	jne    1003c4 <consoleintr+0x2d>
      }
      break;
  10040a:	e9 b0 00 00 00       	jmp    1004bf <consoleintr+0x128>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
  10040f:	8b 15 c8 64 10 00    	mov    0x1064c8,%edx
  100415:	a1 c4 64 10 00       	mov    0x1064c4,%eax
  10041a:	39 c2                	cmp    %eax,%edx
  10041c:	0f 84 9d 00 00 00    	je     1004bf <consoleintr+0x128>
        input.e--;
  100422:	a1 c8 64 10 00       	mov    0x1064c8,%eax
  100427:	83 e8 01             	sub    $0x1,%eax
  10042a:	a3 c8 64 10 00       	mov    %eax,0x1064c8
        consputc(BACKSPACE);
  10042f:	83 ec 0c             	sub    $0xc,%esp
  100432:	68 00 01 00 00       	push   $0x100
  100437:	e8 0e ff ff ff       	call   10034a <consputc>
  10043c:	83 c4 10             	add    $0x10,%esp
      }
      break;
  10043f:	eb 7e                	jmp    1004bf <consoleintr+0x128>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100445:	74 77                	je     1004be <consoleintr+0x127>
  100447:	8b 15 c8 64 10 00    	mov    0x1064c8,%edx
  10044d:	a1 c0 64 10 00       	mov    0x1064c0,%eax
  100452:	29 c2                	sub    %eax,%edx
  100454:	89 d0                	mov    %edx,%eax
  100456:	83 f8 7f             	cmp    $0x7f,%eax
  100459:	77 63                	ja     1004be <consoleintr+0x127>
        c = (c == '\r') ? '\n' : c;
  10045b:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
  10045f:	74 05                	je     100466 <consoleintr+0xcf>
  100461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100464:	eb 05                	jmp    10046b <consoleintr+0xd4>
  100466:	b8 0a 00 00 00       	mov    $0xa,%eax
  10046b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
  10046e:	a1 c8 64 10 00       	mov    0x1064c8,%eax
  100473:	8d 50 01             	lea    0x1(%eax),%edx
  100476:	89 15 c8 64 10 00    	mov    %edx,0x1064c8
  10047c:	83 e0 7f             	and    $0x7f,%eax
  10047f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100482:	88 90 40 64 10 00    	mov    %dl,0x106440(%eax)
        consputc(c);
  100488:	83 ec 0c             	sub    $0xc,%esp
  10048b:	ff 75 f4             	pushl  -0xc(%ebp)
  10048e:	e8 b7 fe ff ff       	call   10034a <consputc>
  100493:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100496:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  10049a:	74 18                	je     1004b4 <consoleintr+0x11d>
  10049c:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  1004a0:	74 12                	je     1004b4 <consoleintr+0x11d>
  1004a2:	a1 c8 64 10 00       	mov    0x1064c8,%eax
  1004a7:	8b 15 c0 64 10 00    	mov    0x1064c0,%edx
  1004ad:	83 ea 80             	sub    $0xffffff80,%edx
  1004b0:	39 d0                	cmp    %edx,%eax
  1004b2:	75 0a                	jne    1004be <consoleintr+0x127>
          input.w = input.e;
  1004b4:	a1 c8 64 10 00       	mov    0x1064c8,%eax
  1004b9:	a3 c4 64 10 00       	mov    %eax,0x1064c4
        }
      }
      break;
  1004be:	90                   	nop
  while((c = getc()) >= 0){
  1004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c2:	ff d0                	call   *%eax
  1004c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1004c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004cb:	0f 89 d5 fe ff ff    	jns    1003a6 <consoleintr+0xf>
    }
  }
  1004d1:	90                   	nop
  1004d2:	90                   	nop
  1004d3:	c9                   	leave  
  1004d4:	c3                   	ret    

001004d5 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
  1004d5:	f3 0f 1e fb          	endbr32 
  1004d9:	55                   	push   %ebp
  1004da:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1004dc:	a1 cc 64 10 00       	mov    0x1064cc,%eax
  1004e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1004e4:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
  1004e6:	a1 cc 64 10 00       	mov    0x1064cc,%eax
  1004eb:	8b 40 10             	mov    0x10(%eax),%eax
}
  1004ee:	5d                   	pop    %ebp
  1004ef:	c3                   	ret    

001004f0 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  1004f0:	f3 0f 1e fb          	endbr32 
  1004f4:	55                   	push   %ebp
  1004f5:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1004f7:	a1 cc 64 10 00       	mov    0x1064cc,%eax
  1004fc:	8b 55 08             	mov    0x8(%ebp),%edx
  1004ff:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  100501:	a1 cc 64 10 00       	mov    0x1064cc,%eax
  100506:	8b 55 0c             	mov    0xc(%ebp),%edx
  100509:	89 50 10             	mov    %edx,0x10(%eax)
}
  10050c:	90                   	nop
  10050d:	5d                   	pop    %ebp
  10050e:	c3                   	ret    

0010050f <ioapicinit>:

void
ioapicinit(void)
{
  10050f:	f3 0f 1e fb          	endbr32 
  100513:	55                   	push   %ebp
  100514:	89 e5                	mov    %esp,%ebp
  100516:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  100519:	c7 05 cc 64 10 00 00 	movl   $0xfec00000,0x1064cc
  100520:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  100523:	6a 01                	push   $0x1
  100525:	e8 ab ff ff ff       	call   1004d5 <ioapicread>
  10052a:	83 c4 04             	add    $0x4,%esp
  10052d:	c1 e8 10             	shr    $0x10,%eax
  100530:	25 ff 00 00 00       	and    $0xff,%eax
  100535:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
  100538:	6a 00                	push   $0x0
  10053a:	e8 96 ff ff ff       	call   1004d5 <ioapicread>
  10053f:	83 c4 04             	add    $0x4,%esp
  100542:	c1 e8 18             	shr    $0x18,%eax
  100545:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
  100548:	0f b6 05 d4 64 10 00 	movzbl 0x1064d4,%eax
  10054f:	0f b6 c0             	movzbl %al,%eax
  100552:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  100555:	74 10                	je     100567 <ioapicinit+0x58>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  100557:	83 ec 0c             	sub    $0xc,%esp
  10055a:	68 2c 41 10 00       	push   $0x10412c
  10055f:	e8 8c fb ff ff       	call   1000f0 <cprintf>
  100564:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  100567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10056e:	eb 3f                	jmp    1005af <ioapicinit+0xa0>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  100570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100573:	83 c0 20             	add    $0x20,%eax
  100576:	0d 00 00 01 00       	or     $0x10000,%eax
  10057b:	89 c2                	mov    %eax,%edx
  10057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100580:	83 c0 08             	add    $0x8,%eax
  100583:	01 c0                	add    %eax,%eax
  100585:	83 ec 08             	sub    $0x8,%esp
  100588:	52                   	push   %edx
  100589:	50                   	push   %eax
  10058a:	e8 61 ff ff ff       	call   1004f0 <ioapicwrite>
  10058f:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
  100592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100595:	83 c0 08             	add    $0x8,%eax
  100598:	01 c0                	add    %eax,%eax
  10059a:	83 c0 01             	add    $0x1,%eax
  10059d:	83 ec 08             	sub    $0x8,%esp
  1005a0:	6a 00                	push   $0x0
  1005a2:	50                   	push   %eax
  1005a3:	e8 48 ff ff ff       	call   1004f0 <ioapicwrite>
  1005a8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
  1005ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1005b5:	7e b9                	jle    100570 <ioapicinit+0x61>
  }
}
  1005b7:	90                   	nop
  1005b8:	90                   	nop
  1005b9:	c9                   	leave  
  1005ba:	c3                   	ret    

001005bb <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  1005bb:	f3 0f 1e fb          	endbr32 
  1005bf:	55                   	push   %ebp
  1005c0:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  1005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c5:	83 c0 20             	add    $0x20,%eax
  1005c8:	89 c2                	mov    %eax,%edx
  1005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1005cd:	83 c0 08             	add    $0x8,%eax
  1005d0:	01 c0                	add    %eax,%eax
  1005d2:	52                   	push   %edx
  1005d3:	50                   	push   %eax
  1005d4:	e8 17 ff ff ff       	call   1004f0 <ioapicwrite>
  1005d9:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c1 e0 18             	shl    $0x18,%eax
  1005e2:	89 c2                	mov    %eax,%edx
  1005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e7:	83 c0 08             	add    $0x8,%eax
  1005ea:	01 c0                	add    %eax,%eax
  1005ec:	83 c0 01             	add    $0x1,%eax
  1005ef:	52                   	push   %edx
  1005f0:	50                   	push   %eax
  1005f1:	e8 fa fe ff ff       	call   1004f0 <ioapicwrite>
  1005f6:	83 c4 08             	add    $0x8,%esp
}
  1005f9:	90                   	nop
  1005fa:	c9                   	leave  
  1005fb:	c3                   	ret    

001005fc <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1005fc:	f3 0f 1e fb          	endbr32 
  100600:	55                   	push   %ebp
  100601:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  100603:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  100608:	8b 55 08             	mov    0x8(%ebp),%edx
  10060b:	c1 e2 02             	shl    $0x2,%edx
  10060e:	01 c2                	add    %eax,%edx
  100610:	8b 45 0c             	mov    0xc(%ebp),%eax
  100613:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
  100615:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  10061a:	83 c0 20             	add    $0x20,%eax
  10061d:	8b 00                	mov    (%eax),%eax
}
  10061f:	90                   	nop
  100620:	5d                   	pop    %ebp
  100621:	c3                   	ret    

00100622 <lapicinit>:

void
lapicinit(void)
{
  100622:	f3 0f 1e fb          	endbr32 
  100626:	55                   	push   %ebp
  100627:	89 e5                	mov    %esp,%ebp
  if(!lapic)
  100629:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  10062e:	85 c0                	test   %eax,%eax
  100630:	0f 84 0c 01 00 00    	je     100742 <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
  100636:	68 3f 01 00 00       	push   $0x13f
  10063b:	6a 3c                	push   $0x3c
  10063d:	e8 ba ff ff ff       	call   1005fc <lapicw>
  100642:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  100645:	6a 0b                	push   $0xb
  100647:	68 f8 00 00 00       	push   $0xf8
  10064c:	e8 ab ff ff ff       	call   1005fc <lapicw>
  100651:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
  100654:	68 20 00 02 00       	push   $0x20020
  100659:	68 c8 00 00 00       	push   $0xc8
  10065e:	e8 99 ff ff ff       	call   1005fc <lapicw>
  100663:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
  100666:	68 80 96 98 00       	push   $0x989680
  10066b:	68 e0 00 00 00       	push   $0xe0
  100670:	e8 87 ff ff ff       	call   1005fc <lapicw>
  100675:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  100678:	68 00 00 01 00       	push   $0x10000
  10067d:	68 d4 00 00 00       	push   $0xd4
  100682:	e8 75 ff ff ff       	call   1005fc <lapicw>
  100687:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
  10068a:	68 00 00 01 00       	push   $0x10000
  10068f:	68 d8 00 00 00       	push   $0xd8
  100694:	e8 63 ff ff ff       	call   1005fc <lapicw>
  100699:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10069c:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  1006a1:	83 c0 30             	add    $0x30,%eax
  1006a4:	8b 00                	mov    (%eax),%eax
  1006a6:	c1 e8 10             	shr    $0x10,%eax
  1006a9:	25 fc 00 00 00       	and    $0xfc,%eax
  1006ae:	85 c0                	test   %eax,%eax
  1006b0:	74 12                	je     1006c4 <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
  1006b2:	68 00 00 01 00       	push   $0x10000
  1006b7:	68 d0 00 00 00       	push   $0xd0
  1006bc:	e8 3b ff ff ff       	call   1005fc <lapicw>
  1006c1:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
  1006c4:	6a 33                	push   $0x33
  1006c6:	68 dc 00 00 00       	push   $0xdc
  1006cb:	e8 2c ff ff ff       	call   1005fc <lapicw>
  1006d0:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  1006d3:	6a 00                	push   $0x0
  1006d5:	68 a0 00 00 00       	push   $0xa0
  1006da:	e8 1d ff ff ff       	call   1005fc <lapicw>
  1006df:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
  1006e2:	6a 00                	push   $0x0
  1006e4:	68 a0 00 00 00       	push   $0xa0
  1006e9:	e8 0e ff ff ff       	call   1005fc <lapicw>
  1006ee:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  1006f1:	6a 00                	push   $0x0
  1006f3:	6a 2c                	push   $0x2c
  1006f5:	e8 02 ff ff ff       	call   1005fc <lapicw>
  1006fa:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1006fd:	6a 00                	push   $0x0
  1006ff:	68 c4 00 00 00       	push   $0xc4
  100704:	e8 f3 fe ff ff       	call   1005fc <lapicw>
  100709:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  10070c:	68 00 85 08 00       	push   $0x88500
  100711:	68 c0 00 00 00       	push   $0xc0
  100716:	e8 e1 fe ff ff       	call   1005fc <lapicw>
  10071b:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
  10071e:	90                   	nop
  10071f:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  100724:	05 00 03 00 00       	add    $0x300,%eax
  100729:	8b 00                	mov    (%eax),%eax
  10072b:	25 00 10 00 00       	and    $0x1000,%eax
  100730:	85 c0                	test   %eax,%eax
  100732:	75 eb                	jne    10071f <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  100734:	6a 00                	push   $0x0
  100736:	6a 20                	push   $0x20
  100738:	e8 bf fe ff ff       	call   1005fc <lapicw>
  10073d:	83 c4 08             	add    $0x8,%esp
  100740:	eb 01                	jmp    100743 <lapicinit+0x121>
    return;
  100742:	90                   	nop
}
  100743:	c9                   	leave  
  100744:	c3                   	ret    

00100745 <lapicid>:

int
lapicid(void)
{
  100745:	f3 0f 1e fb          	endbr32 
  100749:	55                   	push   %ebp
  10074a:	89 e5                	mov    %esp,%ebp
  if (!lapic)
  10074c:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  100751:	85 c0                	test   %eax,%eax
  100753:	75 07                	jne    10075c <lapicid+0x17>
    return 0;
  100755:	b8 00 00 00 00       	mov    $0x0,%eax
  10075a:	eb 0d                	jmp    100769 <lapicid+0x24>
  return lapic[ID] >> 24;
  10075c:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  100761:	83 c0 20             	add    $0x20,%eax
  100764:	8b 00                	mov    (%eax),%eax
  100766:	c1 e8 18             	shr    $0x18,%eax
}
  100769:	5d                   	pop    %ebp
  10076a:	c3                   	ret    

0010076b <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  10076b:	f3 0f 1e fb          	endbr32 
  10076f:	55                   	push   %ebp
  100770:	89 e5                	mov    %esp,%ebp
  if(lapic)
  100772:	a1 d0 64 10 00       	mov    0x1064d0,%eax
  100777:	85 c0                	test   %eax,%eax
  100779:	74 0c                	je     100787 <lapiceoi+0x1c>
    lapicw(EOI, 0);
  10077b:	6a 00                	push   $0x0
  10077d:	6a 2c                	push   $0x2c
  10077f:	e8 78 fe ff ff       	call   1005fc <lapicw>
  100784:	83 c4 08             	add    $0x8,%esp
}
  100787:	90                   	nop
  100788:	c9                   	leave  
  100789:	c3                   	ret    

0010078a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  10078a:	f3 0f 1e fb          	endbr32 
  10078e:	55                   	push   %ebp
  10078f:	89 e5                	mov    %esp,%ebp
  100791:	90                   	nop
  100792:	5d                   	pop    %ebp
  100793:	c3                   	ret    

00100794 <sti>:


static inline void
sti(void)
{
  100794:	55                   	push   %ebp
  100795:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
  100797:	fb                   	sti    
}
  100798:	90                   	nop
  100799:	5d                   	pop    %ebp
  10079a:	c3                   	ret    

0010079b <wfi>:

static inline void
wfi(void)
{
  10079b:	55                   	push   %ebp
  10079c:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
  10079e:	f4                   	hlt    
}
  10079f:	90                   	nop
  1007a0:	5d                   	pop    %ebp
  1007a1:	c3                   	ret    

001007a2 <log_test>:
#include "logflag.h"

extern char end[]; // first address after kernel loaded from ELF file

static inline void 
log_test(void) {
  1007a2:	55                   	push   %ebp
  1007a3:	89 e5                	mov    %esp,%ebp
  1007a5:	81 ec 18 02 00 00    	sub    $0x218,%esp
  struct file* gtxt;
  int n;
  char buffer[512];

  if((gtxt=open("/hello.txt", O_RDONLY)) == 0) {
  1007ab:	83 ec 08             	sub    $0x8,%esp
  1007ae:	6a 00                	push   $0x0
  1007b0:	68 60 41 10 00       	push   $0x104160
  1007b5:	e8 e2 33 00 00       	call   103b9c <open>
  1007ba:	83 c4 10             	add    $0x10,%esp
  1007bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1007c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1007c4:	75 0d                	jne    1007d3 <log_test+0x31>
    panic("Unable to open /hello.txt");
  1007c6:	83 ec 0c             	sub    $0xc,%esp
  1007c9:	68 6b 41 10 00       	push   $0x10416b
  1007ce:	e8 e6 fa ff ff       	call   1002b9 <panic>
  } 

  n = fileread(gtxt, buffer, 5);
  1007d3:	83 ec 04             	sub    $0x4,%esp
  1007d6:	6a 05                	push   $0x5
  1007d8:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  1007de:	50                   	push   %eax
  1007df:	ff 75 f4             	pushl  -0xc(%ebp)
  1007e2:	e8 2a 2e 00 00       	call   103611 <fileread>
  1007e7:	83 c4 10             	add    $0x10,%esp
  1007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cprintf("[UNDOLOG] READ: %d %s\n", n, buffer);
  1007ed:	83 ec 04             	sub    $0x4,%esp
  1007f0:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  1007f6:	50                   	push   %eax
  1007f7:	ff 75 f0             	pushl  -0x10(%ebp)
  1007fa:	68 85 41 10 00       	push   $0x104185
  1007ff:	e8 ec f8 ff ff       	call   1000f0 <cprintf>
  100804:	83 c4 10             	add    $0x10,%esp
  fileclose(gtxt);
  100807:	83 ec 0c             	sub    $0xc,%esp
  10080a:	ff 75 f4             	pushl  -0xc(%ebp)
  10080d:	e8 23 2d 00 00       	call   103535 <fileclose>
  100812:	83 c4 10             	add    $0x10,%esp

  buffer[0] = '0' + PANIC_1;
  100815:	c6 85 f0 fd ff ff 30 	movb   $0x30,-0x210(%ebp)
  buffer[1] = '0' + PANIC_2;
  10081c:	c6 85 f1 fd ff ff 30 	movb   $0x30,-0x20f(%ebp)
  buffer[2] = '0' + PANIC_3;
  100823:	c6 85 f2 fd ff ff 30 	movb   $0x30,-0x20e(%ebp)
  buffer[3] = '0' + PANIC_4;
  10082a:	c6 85 f3 fd ff ff 30 	movb   $0x30,-0x20d(%ebp)
  buffer[4] = '0' + PANIC_5;
  100831:	c6 85 f4 fd ff ff 30 	movb   $0x30,-0x20c(%ebp)

  // Open for writing 
  if((gtxt = open("/hello.txt", O_WRONLY)) == 0){
  100838:	83 ec 08             	sub    $0x8,%esp
  10083b:	6a 01                	push   $0x1
  10083d:	68 60 41 10 00       	push   $0x104160
  100842:	e8 55 33 00 00       	call   103b9c <open>
  100847:	83 c4 10             	add    $0x10,%esp
  10084a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10084d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100851:	75 0d                	jne    100860 <log_test+0xbe>
    panic("Failed to create /foo/hello.txt");
  100853:	83 ec 0c             	sub    $0xc,%esp
  100856:	68 9c 41 10 00       	push   $0x10419c
  10085b:	e8 59 fa ff ff       	call   1002b9 <panic>
  }  
  n = filewrite(gtxt, buffer, 5);
  100860:	83 ec 04             	sub    $0x4,%esp
  100863:	6a 05                	push   $0x5
  100865:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  10086b:	50                   	push   %eax
  10086c:	ff 75 f4             	pushl  -0xc(%ebp)
  10086f:	e8 20 2e 00 00       	call   103694 <filewrite>
  100874:	83 c4 10             	add    $0x10,%esp
  100877:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cprintf("[UNDOLOG] WRITE: %d %s\n", n, buffer);
  10087a:	83 ec 04             	sub    $0x4,%esp
  10087d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  100883:	50                   	push   %eax
  100884:	ff 75 f0             	pushl  -0x10(%ebp)
  100887:	68 bc 41 10 00       	push   $0x1041bc
  10088c:	e8 5f f8 ff ff       	call   1000f0 <cprintf>
  100891:	83 c4 10             	add    $0x10,%esp
  fileclose(gtxt);
  100894:	83 ec 0c             	sub    $0xc,%esp
  100897:	ff 75 f4             	pushl  -0xc(%ebp)
  10089a:	e8 96 2c 00 00       	call   103535 <fileclose>
  10089f:	83 c4 10             	add    $0x10,%esp
}
  1008a2:	90                   	nop
  1008a3:	c9                   	leave  
  1008a4:	c3                   	ret    

001008a5 <main>:

// Bootstrap processor starts running C code here.
int
main(int argc, char* argv[])
{
  1008a5:	f3 0f 1e fb          	endbr32 
  1008a9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  1008ad:	83 e4 f0             	and    $0xfffffff0,%esp
  1008b0:	ff 71 fc             	pushl  -0x4(%ecx)
  1008b3:	55                   	push   %ebp
  1008b4:	89 e5                	mov    %esp,%ebp
  1008b6:	51                   	push   %ecx
  1008b7:	83 ec 04             	sub    $0x4,%esp
  mpinit();        // detect other processors
  1008ba:	e8 95 02 00 00       	call   100b54 <mpinit>
  lapicinit();     // interrupt controller
  1008bf:	e8 5e fd ff ff       	call   100622 <lapicinit>
  picinit();       // disable pic
  1008c4:	e8 ed 03 00 00       	call   100cb6 <picinit>
  ioapicinit();    // another interrupt controller
  1008c9:	e8 41 fc ff ff       	call   10050f <ioapicinit>
  uartinit();      // serial port
  1008ce:	e8 4c 04 00 00       	call   100d1f <uartinit>
  ideinit();       // disk 
  1008d3:	e8 6a 19 00 00       	call   102242 <ideinit>
  tvinit();        // trap vectors
  1008d8:	e8 1d 0a 00 00       	call   1012fa <tvinit>
  binit();         // buffer cache
  1008dd:	e8 4a 16 00 00       	call   101f2c <binit>
  idtinit();       // load idt register
  1008e2:	e8 fd 0a 00 00       	call   1013e4 <idtinit>
  sti();           // enable interrupts
  1008e7:	e8 a8 fe ff ff       	call   100794 <sti>
  iinit(ROOTDEV);  // Read superblock to start reading inodes
  1008ec:	83 ec 0c             	sub    $0xc,%esp
  1008ef:	6a 01                	push   $0x1
  1008f1:	e8 5f 1f 00 00       	call   102855 <iinit>
  1008f6:	83 c4 10             	add    $0x10,%esp
  initlog(ROOTDEV);  // Initialize log
  1008f9:	83 ec 0c             	sub    $0xc,%esp
  1008fc:	6a 01                	push   $0x1
  1008fe:	e8 19 34 00 00       	call   103d1c <initlog>
  100903:	83 c4 10             	add    $0x10,%esp
  log_test();
  100906:	e8 97 fe ff ff       	call   1007a2 <log_test>
  for(;;)
    wfi();
  10090b:	e8 8b fe ff ff       	call   10079b <wfi>
  100910:	eb f9                	jmp    10090b <main+0x66>

00100912 <inb>:
{
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	83 ec 14             	sub    $0x14,%esp
  100918:	8b 45 08             	mov    0x8(%ebp),%eax
  10091b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10091f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100923:	89 c2                	mov    %eax,%edx
  100925:	ec                   	in     (%dx),%al
  100926:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  100929:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  10092d:	c9                   	leave  
  10092e:	c3                   	ret    

0010092f <outb>:
{
  10092f:	55                   	push   %ebp
  100930:	89 e5                	mov    %esp,%ebp
  100932:	83 ec 08             	sub    $0x8,%esp
  100935:	8b 45 08             	mov    0x8(%ebp),%eax
  100938:	8b 55 0c             	mov    0xc(%ebp),%edx
  10093b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  10093f:	89 d0                	mov    %edx,%eax
  100941:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100944:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100948:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10094c:	ee                   	out    %al,(%dx)
}
  10094d:	90                   	nop
  10094e:	c9                   	leave  
  10094f:	c3                   	ret    

00100950 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
  100950:	f3 0f 1e fb          	endbr32 
  100954:	55                   	push   %ebp
  100955:	89 e5                	mov    %esp,%ebp
  100957:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
  10095a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
  100961:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100968:	eb 15                	jmp    10097f <sum+0x2f>
    sum += addr[i];
  10096a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10096d:	8b 45 08             	mov    0x8(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	0f b6 00             	movzbl (%eax),%eax
  100975:	0f b6 c0             	movzbl %al,%eax
  100978:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
  10097b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10097f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100982:	3b 45 0c             	cmp    0xc(%ebp),%eax
  100985:	7c e3                	jl     10096a <sum+0x1a>
  return sum;
  100987:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10098a:	c9                   	leave  
  10098b:	c3                   	ret    

0010098c <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  10098c:	f3 0f 1e fb          	endbr32 
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  // addr = P2V(a);
  addr = (uchar*) a;
  100996:	8b 45 08             	mov    0x8(%ebp),%eax
  100999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
  10099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10099f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009a2:	01 d0                	add    %edx,%eax
  1009a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
  1009a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009ad:	eb 36                	jmp    1009e5 <mpsearch1+0x59>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1009af:	83 ec 04             	sub    $0x4,%esp
  1009b2:	6a 04                	push   $0x4
  1009b4:	68 d4 41 10 00       	push   $0x1041d4
  1009b9:	ff 75 f4             	pushl  -0xc(%ebp)
  1009bc:	e8 ba 05 00 00       	call   100f7b <memcmp>
  1009c1:	83 c4 10             	add    $0x10,%esp
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	75 19                	jne    1009e1 <mpsearch1+0x55>
  1009c8:	83 ec 08             	sub    $0x8,%esp
  1009cb:	6a 10                	push   $0x10
  1009cd:	ff 75 f4             	pushl  -0xc(%ebp)
  1009d0:	e8 7b ff ff ff       	call   100950 <sum>
  1009d5:	83 c4 10             	add    $0x10,%esp
  1009d8:	84 c0                	test   %al,%al
  1009da:	75 05                	jne    1009e1 <mpsearch1+0x55>
      return (struct mp*)p;
  1009dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009df:	eb 11                	jmp    1009f2 <mpsearch1+0x66>
  for(p = addr; p < e; p += sizeof(struct mp))
  1009e1:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  1009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1009eb:	72 c2                	jb     1009af <mpsearch1+0x23>
  return 0;
  1009ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1009f2:	c9                   	leave  
  1009f3:	c3                   	ret    

001009f4 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
  1009f4:	f3 0f 1e fb          	endbr32 
  1009f8:	55                   	push   %ebp
  1009f9:	89 e5                	mov    %esp,%ebp
  1009fb:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  // bda = (uchar *) P2V(0x400);
  bda = (uchar *) 0x400;
  1009fe:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
  100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a08:	83 c0 0f             	add    $0xf,%eax
  100a0b:	0f b6 00             	movzbl (%eax),%eax
  100a0e:	0f b6 c0             	movzbl %al,%eax
  100a11:	c1 e0 08             	shl    $0x8,%eax
  100a14:	89 c2                	mov    %eax,%edx
  100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a19:	83 c0 0e             	add    $0xe,%eax
  100a1c:	0f b6 00             	movzbl (%eax),%eax
  100a1f:	0f b6 c0             	movzbl %al,%eax
  100a22:	09 d0                	or     %edx,%eax
  100a24:	c1 e0 04             	shl    $0x4,%eax
  100a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100a2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a2e:	74 21                	je     100a51 <mpsearch+0x5d>
    if((mp = mpsearch1(p, 1024)))
  100a30:	83 ec 08             	sub    $0x8,%esp
  100a33:	68 00 04 00 00       	push   $0x400
  100a38:	ff 75 f0             	pushl  -0x10(%ebp)
  100a3b:	e8 4c ff ff ff       	call   10098c <mpsearch1>
  100a40:	83 c4 10             	add    $0x10,%esp
  100a43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100a4a:	74 51                	je     100a9d <mpsearch+0xa9>
      return mp;
  100a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a4f:	eb 61                	jmp    100ab2 <mpsearch+0xbe>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
  100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a54:	83 c0 14             	add    $0x14,%eax
  100a57:	0f b6 00             	movzbl (%eax),%eax
  100a5a:	0f b6 c0             	movzbl %al,%eax
  100a5d:	c1 e0 08             	shl    $0x8,%eax
  100a60:	89 c2                	mov    %eax,%edx
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	83 c0 13             	add    $0x13,%eax
  100a68:	0f b6 00             	movzbl (%eax),%eax
  100a6b:	0f b6 c0             	movzbl %al,%eax
  100a6e:	09 d0                	or     %edx,%eax
  100a70:	c1 e0 0a             	shl    $0xa,%eax
  100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
  100a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a79:	2d 00 04 00 00       	sub    $0x400,%eax
  100a7e:	83 ec 08             	sub    $0x8,%esp
  100a81:	68 00 04 00 00       	push   $0x400
  100a86:	50                   	push   %eax
  100a87:	e8 00 ff ff ff       	call   10098c <mpsearch1>
  100a8c:	83 c4 10             	add    $0x10,%esp
  100a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100a92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100a96:	74 05                	je     100a9d <mpsearch+0xa9>
      return mp;
  100a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a9b:	eb 15                	jmp    100ab2 <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
  100a9d:	83 ec 08             	sub    $0x8,%esp
  100aa0:	68 00 00 01 00       	push   $0x10000
  100aa5:	68 00 00 0f 00       	push   $0xf0000
  100aaa:	e8 dd fe ff ff       	call   10098c <mpsearch1>
  100aaf:	83 c4 10             	add    $0x10,%esp
}
  100ab2:	c9                   	leave  
  100ab3:	c3                   	ret    

00100ab4 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
  100ab4:	f3 0f 1e fb          	endbr32 
  100ab8:	55                   	push   %ebp
  100ab9:	89 e5                	mov    %esp,%ebp
  100abb:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100abe:	e8 31 ff ff ff       	call   1009f4 <mpsearch>
  100ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100aca:	74 0a                	je     100ad6 <mpconfig+0x22>
  100acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acf:	8b 40 04             	mov    0x4(%eax),%eax
  100ad2:	85 c0                	test   %eax,%eax
  100ad4:	75 07                	jne    100add <mpconfig+0x29>
    return 0;
  100ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  100adb:	eb 75                	jmp    100b52 <mpconfig+0x9e>
  // conf = (struct mpconf*) P2V((uint) mp->physaddr);
  conf = (struct mpconf*) (uint) mp->physaddr;
  100add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae0:	8b 40 04             	mov    0x4(%eax),%eax
  100ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
  100ae6:	83 ec 04             	sub    $0x4,%esp
  100ae9:	6a 04                	push   $0x4
  100aeb:	68 d9 41 10 00       	push   $0x1041d9
  100af0:	ff 75 f0             	pushl  -0x10(%ebp)
  100af3:	e8 83 04 00 00       	call   100f7b <memcmp>
  100af8:	83 c4 10             	add    $0x10,%esp
  100afb:	85 c0                	test   %eax,%eax
  100afd:	74 07                	je     100b06 <mpconfig+0x52>
    return 0;
  100aff:	b8 00 00 00 00       	mov    $0x0,%eax
  100b04:	eb 4c                	jmp    100b52 <mpconfig+0x9e>
  if(conf->version != 1 && conf->version != 4)
  100b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b09:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100b0d:	3c 01                	cmp    $0x1,%al
  100b0f:	74 12                	je     100b23 <mpconfig+0x6f>
  100b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b14:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100b18:	3c 04                	cmp    $0x4,%al
  100b1a:	74 07                	je     100b23 <mpconfig+0x6f>
    return 0;
  100b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  100b21:	eb 2f                	jmp    100b52 <mpconfig+0x9e>
  if(sum((uchar*)conf, conf->length) != 0)
  100b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b26:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100b2a:	0f b7 c0             	movzwl %ax,%eax
  100b2d:	83 ec 08             	sub    $0x8,%esp
  100b30:	50                   	push   %eax
  100b31:	ff 75 f0             	pushl  -0x10(%ebp)
  100b34:	e8 17 fe ff ff       	call   100950 <sum>
  100b39:	83 c4 10             	add    $0x10,%esp
  100b3c:	84 c0                	test   %al,%al
  100b3e:	74 07                	je     100b47 <mpconfig+0x93>
    return 0;
  100b40:	b8 00 00 00 00       	mov    $0x0,%eax
  100b45:	eb 0b                	jmp    100b52 <mpconfig+0x9e>
  *pmp = mp;
  100b47:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4d:	89 10                	mov    %edx,(%eax)
  return conf;
  100b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100b52:	c9                   	leave  
  100b53:	c3                   	ret    

00100b54 <mpinit>:

void
mpinit(void)
{
  100b54:	f3 0f 1e fb          	endbr32 
  100b58:	55                   	push   %ebp
  100b59:	89 e5                	mov    %esp,%ebp
  100b5b:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
  100b5e:	83 ec 0c             	sub    $0xc,%esp
  100b61:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100b64:	50                   	push   %eax
  100b65:	e8 4a ff ff ff       	call   100ab4 <mpconfig>
  100b6a:	83 c4 10             	add    $0x10,%esp
  100b6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100b70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100b74:	75 0d                	jne    100b83 <mpinit+0x2f>
    panic("Expect to run on an SMP");
  100b76:	83 ec 0c             	sub    $0xc,%esp
  100b79:	68 de 41 10 00       	push   $0x1041de
  100b7e:	e8 36 f7 ff ff       	call   1002b9 <panic>
  ismp = 1;
  100b83:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
  100b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b8d:	8b 40 24             	mov    0x24(%eax),%eax
  100b90:	a3 d0 64 10 00       	mov    %eax,0x1064d0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b98:	83 c0 2c             	add    $0x2c,%eax
  100b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100ba1:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100ba5:	0f b7 d0             	movzwl %ax,%edx
  100ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100bab:	01 d0                	add    %edx,%eax
  100bad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  100bb0:	e9 83 00 00 00       	jmp    100c38 <mpinit+0xe4>
    switch(*p){
  100bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb8:	0f b6 00             	movzbl (%eax),%eax
  100bbb:	0f b6 c0             	movzbl %al,%eax
  100bbe:	83 f8 04             	cmp    $0x4,%eax
  100bc1:	7f 6d                	jg     100c30 <mpinit+0xdc>
  100bc3:	83 f8 03             	cmp    $0x3,%eax
  100bc6:	7d 62                	jge    100c2a <mpinit+0xd6>
  100bc8:	83 f8 02             	cmp    $0x2,%eax
  100bcb:	74 45                	je     100c12 <mpinit+0xbe>
  100bcd:	83 f8 02             	cmp    $0x2,%eax
  100bd0:	7f 5e                	jg     100c30 <mpinit+0xdc>
  100bd2:	85 c0                	test   %eax,%eax
  100bd4:	74 07                	je     100bdd <mpinit+0x89>
  100bd6:	83 f8 01             	cmp    $0x1,%eax
  100bd9:	74 4f                	je     100c2a <mpinit+0xd6>
  100bdb:	eb 53                	jmp    100c30 <mpinit+0xdc>
    case MPPROC:
      proc = (struct mpproc*)p;
  100bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100be0:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
  100be3:	a1 e0 64 10 00       	mov    0x1064e0,%eax
  100be8:	83 f8 07             	cmp    $0x7,%eax
  100beb:	7f 1f                	jg     100c0c <mpinit+0xb8>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  100bed:	a1 e0 64 10 00       	mov    0x1064e0,%eax
  100bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100bf5:	0f b6 52 01          	movzbl 0x1(%edx),%edx
  100bf9:	88 90 d8 64 10 00    	mov    %dl,0x1064d8(%eax)
        ncpu++;
  100bff:	a1 e0 64 10 00       	mov    0x1064e0,%eax
  100c04:	83 c0 01             	add    $0x1,%eax
  100c07:	a3 e0 64 10 00       	mov    %eax,0x1064e0
      }
      p += sizeof(struct mpproc);
  100c0c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
  100c10:	eb 26                	jmp    100c38 <mpinit+0xe4>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
  100c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
  100c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c1b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
  100c1f:	a2 d4 64 10 00       	mov    %al,0x1064d4
      p += sizeof(struct mpioapic);
  100c24:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100c28:	eb 0e                	jmp    100c38 <mpinit+0xe4>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  100c2a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100c2e:	eb 08                	jmp    100c38 <mpinit+0xe4>
    default:
      ismp = 0;
  100c30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
  100c37:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  100c3e:	0f 82 71 ff ff ff    	jb     100bb5 <mpinit+0x61>
    }
  }
  if(!ismp)
  100c44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c48:	75 0d                	jne    100c57 <mpinit+0x103>
    panic("Didn't find a suitable machine");
  100c4a:	83 ec 0c             	sub    $0xc,%esp
  100c4d:	68 f8 41 10 00       	push   $0x1041f8
  100c52:	e8 62 f6 ff ff       	call   1002b9 <panic>

  if(mp->imcrp){
  100c57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100c5a:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
  100c5e:	84 c0                	test   %al,%al
  100c60:	74 30                	je     100c92 <mpinit+0x13e>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
  100c62:	83 ec 08             	sub    $0x8,%esp
  100c65:	6a 70                	push   $0x70
  100c67:	6a 22                	push   $0x22
  100c69:	e8 c1 fc ff ff       	call   10092f <outb>
  100c6e:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  100c71:	83 ec 0c             	sub    $0xc,%esp
  100c74:	6a 23                	push   $0x23
  100c76:	e8 97 fc ff ff       	call   100912 <inb>
  100c7b:	83 c4 10             	add    $0x10,%esp
  100c7e:	83 c8 01             	or     $0x1,%eax
  100c81:	0f b6 c0             	movzbl %al,%eax
  100c84:	83 ec 08             	sub    $0x8,%esp
  100c87:	50                   	push   %eax
  100c88:	6a 23                	push   $0x23
  100c8a:	e8 a0 fc ff ff       	call   10092f <outb>
  100c8f:	83 c4 10             	add    $0x10,%esp
  }
}
  100c92:	90                   	nop
  100c93:	c9                   	leave  
  100c94:	c3                   	ret    

00100c95 <outb>:
{
  100c95:	55                   	push   %ebp
  100c96:	89 e5                	mov    %esp,%ebp
  100c98:	83 ec 08             	sub    $0x8,%esp
  100c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ca1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100ca5:	89 d0                	mov    %edx,%eax
  100ca7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100caa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100cae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100cb2:	ee                   	out    %al,(%dx)
}
  100cb3:	90                   	nop
  100cb4:	c9                   	leave  
  100cb5:	c3                   	ret    

00100cb6 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
  100cb6:	f3 0f 1e fb          	endbr32 
  100cba:	55                   	push   %ebp
  100cbb:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  100cbd:	68 ff 00 00 00       	push   $0xff
  100cc2:	6a 21                	push   $0x21
  100cc4:	e8 cc ff ff ff       	call   100c95 <outb>
  100cc9:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
  100ccc:	68 ff 00 00 00       	push   $0xff
  100cd1:	68 a1 00 00 00       	push   $0xa1
  100cd6:	e8 ba ff ff ff       	call   100c95 <outb>
  100cdb:	83 c4 08             	add    $0x8,%esp
  100cde:	90                   	nop
  100cdf:	c9                   	leave  
  100ce0:	c3                   	ret    

00100ce1 <inb>:
{
  100ce1:	55                   	push   %ebp
  100ce2:	89 e5                	mov    %esp,%ebp
  100ce4:	83 ec 14             	sub    $0x14,%esp
  100ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cea:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100cee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100cf2:	89 c2                	mov    %eax,%edx
  100cf4:	ec                   	in     (%dx),%al
  100cf5:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  100cf8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  100cfc:	c9                   	leave  
  100cfd:	c3                   	ret    

00100cfe <outb>:
{
  100cfe:	55                   	push   %ebp
  100cff:	89 e5                	mov    %esp,%ebp
  100d01:	83 ec 08             	sub    $0x8,%esp
  100d04:	8b 45 08             	mov    0x8(%ebp),%eax
  100d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  100d0a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100d0e:	89 d0                	mov    %edx,%eax
  100d10:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100d13:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100d17:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100d1b:	ee                   	out    %al,(%dx)
}
  100d1c:	90                   	nop
  100d1d:	c9                   	leave  
  100d1e:	c3                   	ret    

00100d1f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  100d1f:	f3 0f 1e fb          	endbr32 
  100d23:	55                   	push   %ebp
  100d24:	89 e5                	mov    %esp,%ebp
  100d26:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
  100d29:	6a 00                	push   $0x0
  100d2b:	68 fa 03 00 00       	push   $0x3fa
  100d30:	e8 c9 ff ff ff       	call   100cfe <outb>
  100d35:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
  100d38:	68 80 00 00 00       	push   $0x80
  100d3d:	68 fb 03 00 00       	push   $0x3fb
  100d42:	e8 b7 ff ff ff       	call   100cfe <outb>
  100d47:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
  100d4a:	6a 0c                	push   $0xc
  100d4c:	68 f8 03 00 00       	push   $0x3f8
  100d51:	e8 a8 ff ff ff       	call   100cfe <outb>
  100d56:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
  100d59:	6a 00                	push   $0x0
  100d5b:	68 f9 03 00 00       	push   $0x3f9
  100d60:	e8 99 ff ff ff       	call   100cfe <outb>
  100d65:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  100d68:	6a 03                	push   $0x3
  100d6a:	68 fb 03 00 00       	push   $0x3fb
  100d6f:	e8 8a ff ff ff       	call   100cfe <outb>
  100d74:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
  100d77:	6a 00                	push   $0x0
  100d79:	68 fc 03 00 00       	push   $0x3fc
  100d7e:	e8 7b ff ff ff       	call   100cfe <outb>
  100d83:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
  100d86:	6a 01                	push   $0x1
  100d88:	68 f9 03 00 00       	push   $0x3f9
  100d8d:	e8 6c ff ff ff       	call   100cfe <outb>
  100d92:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  100d95:	68 fd 03 00 00       	push   $0x3fd
  100d9a:	e8 42 ff ff ff       	call   100ce1 <inb>
  100d9f:	83 c4 04             	add    $0x4,%esp
  100da2:	3c ff                	cmp    $0xff,%al
  100da4:	74 61                	je     100e07 <uartinit+0xe8>
    return;
  uart = 1;
  100da6:	c7 05 24 54 10 00 01 	movl   $0x1,0x105424
  100dad:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  100db0:	68 fa 03 00 00       	push   $0x3fa
  100db5:	e8 27 ff ff ff       	call   100ce1 <inb>
  100dba:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
  100dbd:	68 f8 03 00 00       	push   $0x3f8
  100dc2:	e8 1a ff ff ff       	call   100ce1 <inb>
  100dc7:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
  100dca:	83 ec 08             	sub    $0x8,%esp
  100dcd:	6a 00                	push   $0x0
  100dcf:	6a 04                	push   $0x4
  100dd1:	e8 e5 f7 ff ff       	call   1005bb <ioapicenable>
  100dd6:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  100dd9:	c7 45 f4 17 42 10 00 	movl   $0x104217,-0xc(%ebp)
  100de0:	eb 19                	jmp    100dfb <uartinit+0xdc>
    uartputc(*p);
  100de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100de5:	0f b6 00             	movzbl (%eax),%eax
  100de8:	0f be c0             	movsbl %al,%eax
  100deb:	83 ec 0c             	sub    $0xc,%esp
  100dee:	50                   	push   %eax
  100def:	e8 16 00 00 00       	call   100e0a <uartputc>
  100df4:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
  100df7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dfe:	0f b6 00             	movzbl (%eax),%eax
  100e01:	84 c0                	test   %al,%al
  100e03:	75 dd                	jne    100de2 <uartinit+0xc3>
  100e05:	eb 01                	jmp    100e08 <uartinit+0xe9>
    return;
  100e07:	90                   	nop
}
  100e08:	c9                   	leave  
  100e09:	c3                   	ret    

00100e0a <uartputc>:

void
uartputc(int c)
{
  100e0a:	f3 0f 1e fb          	endbr32 
  100e0e:	55                   	push   %ebp
  100e0f:	89 e5                	mov    %esp,%ebp
  100e11:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  100e14:	a1 24 54 10 00       	mov    0x105424,%eax
  100e19:	85 c0                	test   %eax,%eax
  100e1b:	74 40                	je     100e5d <uartputc+0x53>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100e1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100e24:	eb 04                	jmp    100e2a <uartputc+0x20>
  100e26:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100e2a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  100e2e:	7f 17                	jg     100e47 <uartputc+0x3d>
  100e30:	68 fd 03 00 00       	push   $0x3fd
  100e35:	e8 a7 fe ff ff       	call   100ce1 <inb>
  100e3a:	83 c4 04             	add    $0x4,%esp
  100e3d:	0f b6 c0             	movzbl %al,%eax
  100e40:	83 e0 20             	and    $0x20,%eax
  100e43:	85 c0                	test   %eax,%eax
  100e45:	74 df                	je     100e26 <uartputc+0x1c>
  outb(COM1+0, c);
  100e47:	8b 45 08             	mov    0x8(%ebp),%eax
  100e4a:	0f b6 c0             	movzbl %al,%eax
  100e4d:	50                   	push   %eax
  100e4e:	68 f8 03 00 00       	push   $0x3f8
  100e53:	e8 a6 fe ff ff       	call   100cfe <outb>
  100e58:	83 c4 08             	add    $0x8,%esp
  100e5b:	eb 01                	jmp    100e5e <uartputc+0x54>
    return;
  100e5d:	90                   	nop
}
  100e5e:	c9                   	leave  
  100e5f:	c3                   	ret    

00100e60 <uartgetc>:


static int
uartgetc(void)
{
  100e60:	f3 0f 1e fb          	endbr32 
  100e64:	55                   	push   %ebp
  100e65:	89 e5                	mov    %esp,%ebp
  if(!uart)
  100e67:	a1 24 54 10 00       	mov    0x105424,%eax
  100e6c:	85 c0                	test   %eax,%eax
  100e6e:	75 07                	jne    100e77 <uartgetc+0x17>
    return -1;
  100e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e75:	eb 2e                	jmp    100ea5 <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
  100e77:	68 fd 03 00 00       	push   $0x3fd
  100e7c:	e8 60 fe ff ff       	call   100ce1 <inb>
  100e81:	83 c4 04             	add    $0x4,%esp
  100e84:	0f b6 c0             	movzbl %al,%eax
  100e87:	83 e0 01             	and    $0x1,%eax
  100e8a:	85 c0                	test   %eax,%eax
  100e8c:	75 07                	jne    100e95 <uartgetc+0x35>
    return -1;
  100e8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e93:	eb 10                	jmp    100ea5 <uartgetc+0x45>
  return inb(COM1+0);
  100e95:	68 f8 03 00 00       	push   $0x3f8
  100e9a:	e8 42 fe ff ff       	call   100ce1 <inb>
  100e9f:	83 c4 04             	add    $0x4,%esp
  100ea2:	0f b6 c0             	movzbl %al,%eax
}
  100ea5:	c9                   	leave  
  100ea6:	c3                   	ret    

00100ea7 <uartintr>:

void
uartintr(void)
{
  100ea7:	f3 0f 1e fb          	endbr32 
  100eab:	55                   	push   %ebp
  100eac:	89 e5                	mov    %esp,%ebp
  100eae:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
  100eb1:	83 ec 0c             	sub    $0xc,%esp
  100eb4:	68 60 0e 10 00       	push   $0x100e60
  100eb9:	e8 d9 f4 ff ff       	call   100397 <consoleintr>
  100ebe:	83 c4 10             	add    $0x10,%esp
  100ec1:	90                   	nop
  100ec2:	c9                   	leave  
  100ec3:	c3                   	ret    

00100ec4 <stosb>:
{
  100ec4:	55                   	push   %ebp
  100ec5:	89 e5                	mov    %esp,%ebp
  100ec7:	57                   	push   %edi
  100ec8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  100ec9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100ecc:	8b 55 10             	mov    0x10(%ebp),%edx
  100ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ed2:	89 cb                	mov    %ecx,%ebx
  100ed4:	89 df                	mov    %ebx,%edi
  100ed6:	89 d1                	mov    %edx,%ecx
  100ed8:	fc                   	cld    
  100ed9:	f3 aa                	rep stos %al,%es:(%edi)
  100edb:	89 ca                	mov    %ecx,%edx
  100edd:	89 fb                	mov    %edi,%ebx
  100edf:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100ee2:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100ee5:	90                   	nop
  100ee6:	5b                   	pop    %ebx
  100ee7:	5f                   	pop    %edi
  100ee8:	5d                   	pop    %ebp
  100ee9:	c3                   	ret    

00100eea <stosl>:
{
  100eea:	55                   	push   %ebp
  100eeb:	89 e5                	mov    %esp,%ebp
  100eed:	57                   	push   %edi
  100eee:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
  100eef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100ef2:	8b 55 10             	mov    0x10(%ebp),%edx
  100ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ef8:	89 cb                	mov    %ecx,%ebx
  100efa:	89 df                	mov    %ebx,%edi
  100efc:	89 d1                	mov    %edx,%ecx
  100efe:	fc                   	cld    
  100eff:	f3 ab                	rep stos %eax,%es:(%edi)
  100f01:	89 ca                	mov    %ecx,%edx
  100f03:	89 fb                	mov    %edi,%ebx
  100f05:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100f08:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100f0b:	90                   	nop
  100f0c:	5b                   	pop    %ebx
  100f0d:	5f                   	pop    %edi
  100f0e:	5d                   	pop    %ebp
  100f0f:	c3                   	ret    

00100f10 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  100f10:	f3 0f 1e fb          	endbr32 
  100f14:	55                   	push   %ebp
  100f15:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
  100f17:	8b 45 08             	mov    0x8(%ebp),%eax
  100f1a:	83 e0 03             	and    $0x3,%eax
  100f1d:	85 c0                	test   %eax,%eax
  100f1f:	75 43                	jne    100f64 <memset+0x54>
  100f21:	8b 45 10             	mov    0x10(%ebp),%eax
  100f24:	83 e0 03             	and    $0x3,%eax
  100f27:	85 c0                	test   %eax,%eax
  100f29:	75 39                	jne    100f64 <memset+0x54>
    c &= 0xFF;
  100f2b:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  100f32:	8b 45 10             	mov    0x10(%ebp),%eax
  100f35:	c1 e8 02             	shr    $0x2,%eax
  100f38:	89 c1                	mov    %eax,%ecx
  100f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f3d:	c1 e0 18             	shl    $0x18,%eax
  100f40:	89 c2                	mov    %eax,%edx
  100f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f45:	c1 e0 10             	shl    $0x10,%eax
  100f48:	09 c2                	or     %eax,%edx
  100f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f4d:	c1 e0 08             	shl    $0x8,%eax
  100f50:	09 d0                	or     %edx,%eax
  100f52:	0b 45 0c             	or     0xc(%ebp),%eax
  100f55:	51                   	push   %ecx
  100f56:	50                   	push   %eax
  100f57:	ff 75 08             	pushl  0x8(%ebp)
  100f5a:	e8 8b ff ff ff       	call   100eea <stosl>
  100f5f:	83 c4 0c             	add    $0xc,%esp
  100f62:	eb 12                	jmp    100f76 <memset+0x66>
  } else
    stosb(dst, c, n);
  100f64:	8b 45 10             	mov    0x10(%ebp),%eax
  100f67:	50                   	push   %eax
  100f68:	ff 75 0c             	pushl  0xc(%ebp)
  100f6b:	ff 75 08             	pushl  0x8(%ebp)
  100f6e:	e8 51 ff ff ff       	call   100ec4 <stosb>
  100f73:	83 c4 0c             	add    $0xc,%esp
  return dst;
  100f76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100f79:	c9                   	leave  
  100f7a:	c3                   	ret    

00100f7b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  100f7b:	f3 0f 1e fb          	endbr32 
  100f7f:	55                   	push   %ebp
  100f80:	89 e5                	mov    %esp,%ebp
  100f82:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
  100f85:	8b 45 08             	mov    0x8(%ebp),%eax
  100f88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
  100f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
  100f91:	eb 30                	jmp    100fc3 <memcmp+0x48>
    if(*s1 != *s2)
  100f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f96:	0f b6 10             	movzbl (%eax),%edx
  100f99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f9c:	0f b6 00             	movzbl (%eax),%eax
  100f9f:	38 c2                	cmp    %al,%dl
  100fa1:	74 18                	je     100fbb <memcmp+0x40>
      return *s1 - *s2;
  100fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fa6:	0f b6 00             	movzbl (%eax),%eax
  100fa9:	0f b6 d0             	movzbl %al,%edx
  100fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100faf:	0f b6 00             	movzbl (%eax),%eax
  100fb2:	0f b6 c0             	movzbl %al,%eax
  100fb5:	29 c2                	sub    %eax,%edx
  100fb7:	89 d0                	mov    %edx,%eax
  100fb9:	eb 1a                	jmp    100fd5 <memcmp+0x5a>
    s1++, s2++;
  100fbb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fbf:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
  100fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  100fc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  100fc9:	89 55 10             	mov    %edx,0x10(%ebp)
  100fcc:	85 c0                	test   %eax,%eax
  100fce:	75 c3                	jne    100f93 <memcmp+0x18>
  }

  return 0;
  100fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100fd5:	c9                   	leave  
  100fd6:	c3                   	ret    

00100fd7 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  100fd7:	f3 0f 1e fb          	endbr32 
  100fdb:	55                   	push   %ebp
  100fdc:	89 e5                	mov    %esp,%ebp
  100fde:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
  100fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
  100fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  100fea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
  100fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ff0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100ff3:	73 54                	jae    101049 <memmove+0x72>
  100ff5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  100ffb:	01 d0                	add    %edx,%eax
  100ffd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
  101000:	73 47                	jae    101049 <memmove+0x72>
    s += n;
  101002:	8b 45 10             	mov    0x10(%ebp),%eax
  101005:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
  101008:	8b 45 10             	mov    0x10(%ebp),%eax
  10100b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
  10100e:	eb 13                	jmp    101023 <memmove+0x4c>
      *--d = *--s;
  101010:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  101014:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  101018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10101b:	0f b6 10             	movzbl (%eax),%edx
  10101e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101021:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  101023:	8b 45 10             	mov    0x10(%ebp),%eax
  101026:	8d 50 ff             	lea    -0x1(%eax),%edx
  101029:	89 55 10             	mov    %edx,0x10(%ebp)
  10102c:	85 c0                	test   %eax,%eax
  10102e:	75 e0                	jne    101010 <memmove+0x39>
  if(s < d && s + n > d){
  101030:	eb 24                	jmp    101056 <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
  101032:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101035:	8d 42 01             	lea    0x1(%edx),%eax
  101038:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10103e:	8d 48 01             	lea    0x1(%eax),%ecx
  101041:	89 4d f8             	mov    %ecx,-0x8(%ebp)
  101044:	0f b6 12             	movzbl (%edx),%edx
  101047:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  101049:	8b 45 10             	mov    0x10(%ebp),%eax
  10104c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10104f:	89 55 10             	mov    %edx,0x10(%ebp)
  101052:	85 c0                	test   %eax,%eax
  101054:	75 dc                	jne    101032 <memmove+0x5b>

  return dst;
  101056:	8b 45 08             	mov    0x8(%ebp),%eax
}
  101059:	c9                   	leave  
  10105a:	c3                   	ret    

0010105b <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  10105b:	f3 0f 1e fb          	endbr32 
  10105f:	55                   	push   %ebp
  101060:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
  101062:	ff 75 10             	pushl  0x10(%ebp)
  101065:	ff 75 0c             	pushl  0xc(%ebp)
  101068:	ff 75 08             	pushl  0x8(%ebp)
  10106b:	e8 67 ff ff ff       	call   100fd7 <memmove>
  101070:	83 c4 0c             	add    $0xc,%esp
}
  101073:	c9                   	leave  
  101074:	c3                   	ret    

00101075 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  101075:	f3 0f 1e fb          	endbr32 
  101079:	55                   	push   %ebp
  10107a:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
  10107c:	eb 0c                	jmp    10108a <strncmp+0x15>
    n--, p++, q++;
  10107e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  101082:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  101086:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
  10108a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10108e:	74 1a                	je     1010aa <strncmp+0x35>
  101090:	8b 45 08             	mov    0x8(%ebp),%eax
  101093:	0f b6 00             	movzbl (%eax),%eax
  101096:	84 c0                	test   %al,%al
  101098:	74 10                	je     1010aa <strncmp+0x35>
  10109a:	8b 45 08             	mov    0x8(%ebp),%eax
  10109d:	0f b6 10             	movzbl (%eax),%edx
  1010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1010a3:	0f b6 00             	movzbl (%eax),%eax
  1010a6:	38 c2                	cmp    %al,%dl
  1010a8:	74 d4                	je     10107e <strncmp+0x9>
  if(n == 0)
  1010aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1010ae:	75 07                	jne    1010b7 <strncmp+0x42>
    return 0;
  1010b0:	b8 00 00 00 00       	mov    $0x0,%eax
  1010b5:	eb 16                	jmp    1010cd <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
  1010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ba:	0f b6 00             	movzbl (%eax),%eax
  1010bd:	0f b6 d0             	movzbl %al,%edx
  1010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1010c3:	0f b6 00             	movzbl (%eax),%eax
  1010c6:	0f b6 c0             	movzbl %al,%eax
  1010c9:	29 c2                	sub    %eax,%edx
  1010cb:	89 d0                	mov    %edx,%eax
}
  1010cd:	5d                   	pop    %ebp
  1010ce:	c3                   	ret    

001010cf <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1010cf:	f3 0f 1e fb          	endbr32 
  1010d3:	55                   	push   %ebp
  1010d4:	89 e5                	mov    %esp,%ebp
  1010d6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  1010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
  1010df:	90                   	nop
  1010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1010e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1010e6:	89 55 10             	mov    %edx,0x10(%ebp)
  1010e9:	85 c0                	test   %eax,%eax
  1010eb:	7e 2c                	jle    101119 <strncpy+0x4a>
  1010ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  1010f0:	8d 42 01             	lea    0x1(%edx),%eax
  1010f3:	89 45 0c             	mov    %eax,0xc(%ebp)
  1010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f9:	8d 48 01             	lea    0x1(%eax),%ecx
  1010fc:	89 4d 08             	mov    %ecx,0x8(%ebp)
  1010ff:	0f b6 12             	movzbl (%edx),%edx
  101102:	88 10                	mov    %dl,(%eax)
  101104:	0f b6 00             	movzbl (%eax),%eax
  101107:	84 c0                	test   %al,%al
  101109:	75 d5                	jne    1010e0 <strncpy+0x11>
    ;
  while(n-- > 0)
  10110b:	eb 0c                	jmp    101119 <strncpy+0x4a>
    *s++ = 0;
  10110d:	8b 45 08             	mov    0x8(%ebp),%eax
  101110:	8d 50 01             	lea    0x1(%eax),%edx
  101113:	89 55 08             	mov    %edx,0x8(%ebp)
  101116:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
  101119:	8b 45 10             	mov    0x10(%ebp),%eax
  10111c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10111f:	89 55 10             	mov    %edx,0x10(%ebp)
  101122:	85 c0                	test   %eax,%eax
  101124:	7f e7                	jg     10110d <strncpy+0x3e>
  return os;
  101126:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101129:	c9                   	leave  
  10112a:	c3                   	ret    

0010112b <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  10112b:	f3 0f 1e fb          	endbr32 
  10112f:	55                   	push   %ebp
  101130:	89 e5                	mov    %esp,%ebp
  101132:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  101135:	8b 45 08             	mov    0x8(%ebp),%eax
  101138:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
  10113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10113f:	7f 05                	jg     101146 <safestrcpy+0x1b>
    return os;
  101141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101144:	eb 31                	jmp    101177 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
  101146:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10114a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10114e:	7e 1e                	jle    10116e <safestrcpy+0x43>
  101150:	8b 55 0c             	mov    0xc(%ebp),%edx
  101153:	8d 42 01             	lea    0x1(%edx),%eax
  101156:	89 45 0c             	mov    %eax,0xc(%ebp)
  101159:	8b 45 08             	mov    0x8(%ebp),%eax
  10115c:	8d 48 01             	lea    0x1(%eax),%ecx
  10115f:	89 4d 08             	mov    %ecx,0x8(%ebp)
  101162:	0f b6 12             	movzbl (%edx),%edx
  101165:	88 10                	mov    %dl,(%eax)
  101167:	0f b6 00             	movzbl (%eax),%eax
  10116a:	84 c0                	test   %al,%al
  10116c:	75 d8                	jne    101146 <safestrcpy+0x1b>
    ;
  *s = 0;
  10116e:	8b 45 08             	mov    0x8(%ebp),%eax
  101171:	c6 00 00             	movb   $0x0,(%eax)
  return os;
  101174:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101177:	c9                   	leave  
  101178:	c3                   	ret    

00101179 <strlen>:

int
strlen(const char *s)
{
  101179:	f3 0f 1e fb          	endbr32 
  10117d:	55                   	push   %ebp
  10117e:	89 e5                	mov    %esp,%ebp
  101180:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  101183:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10118a:	eb 04                	jmp    101190 <strlen+0x17>
  10118c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101190:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101193:	8b 45 08             	mov    0x8(%ebp),%eax
  101196:	01 d0                	add    %edx,%eax
  101198:	0f b6 00             	movzbl (%eax),%eax
  10119b:	84 c0                	test   %al,%al
  10119d:	75 ed                	jne    10118c <strlen+0x13>
    ;
  return n;
  10119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1011a2:	c9                   	leave  
  1011a3:	c3                   	ret    

001011a4 <readeflags>:
{
  1011a4:	55                   	push   %ebp
  1011a5:	89 e5                	mov    %esp,%ebp
  1011a7:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1011aa:	9c                   	pushf  
  1011ab:	58                   	pop    %eax
  1011ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
  1011af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1011b2:	c9                   	leave  
  1011b3:	c3                   	ret    

001011b4 <cpuid>:
#include "x86.h"
#include "proc.h"

// Must be called with interrupts disabled
int
cpuid() {
  1011b4:	f3 0f 1e fb          	endbr32 
  1011b8:	55                   	push   %ebp
  1011b9:	89 e5                	mov    %esp,%ebp
  1011bb:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
  1011be:	e8 07 00 00 00       	call   1011ca <mycpu>
  1011c3:	2d d8 64 10 00       	sub    $0x1064d8,%eax
}
  1011c8:	c9                   	leave  
  1011c9:	c3                   	ret    

001011ca <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  1011ca:	f3 0f 1e fb          	endbr32 
  1011ce:	55                   	push   %ebp
  1011cf:	89 e5                	mov    %esp,%ebp
  1011d1:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
  1011d4:	e8 cb ff ff ff       	call   1011a4 <readeflags>
  1011d9:	25 00 02 00 00       	and    $0x200,%eax
  1011de:	85 c0                	test   %eax,%eax
  1011e0:	74 0d                	je     1011ef <mycpu+0x25>
    panic("mycpu called with interrupts enabled\n");
  1011e2:	83 ec 0c             	sub    $0xc,%esp
  1011e5:	68 20 42 10 00       	push   $0x104220
  1011ea:	e8 ca f0 ff ff       	call   1002b9 <panic>
  
  apicid = lapicid();
  1011ef:	e8 51 f5 ff ff       	call   100745 <lapicid>
  1011f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
  1011f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1011fe:	eb 21                	jmp    101221 <mycpu+0x57>
    if (cpus[i].apicid == apicid)
  101200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101203:	05 d8 64 10 00       	add    $0x1064d8,%eax
  101208:	0f b6 00             	movzbl (%eax),%eax
  10120b:	0f b6 c0             	movzbl %al,%eax
  10120e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  101211:	75 0a                	jne    10121d <mycpu+0x53>
      return &cpus[i];
  101213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101216:	05 d8 64 10 00       	add    $0x1064d8,%eax
  10121b:	eb 1b                	jmp    101238 <mycpu+0x6e>
  for (i = 0; i < ncpu; ++i) {
  10121d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101221:	a1 e0 64 10 00       	mov    0x1064e0,%eax
  101226:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  101229:	7c d5                	jl     101200 <mycpu+0x36>
  }
  panic("unknown apicid\n");
  10122b:	83 ec 0c             	sub    $0xc,%esp
  10122e:	68 46 42 10 00       	push   $0x104246
  101233:	e8 81 f0 ff ff       	call   1002b9 <panic>
  101238:	c9                   	leave  
  101239:	c3                   	ret    

0010123a <getcallerpcs>:
// #include "memlayout.h"

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  10123a:	f3 0f 1e fb          	endbr32 
  10123e:	55                   	push   %ebp
  10123f:	89 e5                	mov    %esp,%ebp
  101241:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  101244:	8b 45 08             	mov    0x8(%ebp),%eax
  101247:	83 e8 08             	sub    $0x8,%eax
  10124a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  10124d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  101254:	eb 2f                	jmp    101285 <getcallerpcs+0x4b>
    // if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  101256:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10125a:	74 4a                	je     1012a6 <getcallerpcs+0x6c>
  10125c:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
  101260:	74 44                	je     1012a6 <getcallerpcs+0x6c>
      break;
    pcs[i] = ebp[1];     // saved %eip
  101262:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10126c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10126f:	01 c2                	add    %eax,%edx
  101271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101274:	8b 40 04             	mov    0x4(%eax),%eax
  101277:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
  101279:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10127c:	8b 00                	mov    (%eax),%eax
  10127e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  101281:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101285:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  101289:	7e cb                	jle    101256 <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
  10128b:	eb 19                	jmp    1012a6 <getcallerpcs+0x6c>
    pcs[i] = 0;
  10128d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101297:	8b 45 0c             	mov    0xc(%ebp),%eax
  10129a:	01 d0                	add    %edx,%eax
  10129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  1012a2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1012a6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  1012aa:	7e e1                	jle    10128d <getcallerpcs+0x53>
  1012ac:	90                   	nop
  1012ad:	90                   	nop
  1012ae:	c9                   	leave  
  1012af:	c3                   	ret    

001012b0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushal
  1012b0:	60                   	pusha  
  
  # Call trap(tf), where tf=%esp
  pushl %esp
  1012b1:	54                   	push   %esp
  call trap
  1012b2:	e8 49 01 00 00       	call   101400 <trap>
  addl $4, %esp
  1012b7:	83 c4 04             	add    $0x4,%esp

001012ba <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  1012ba:	61                   	popa   
  addl $0x8, %esp  # trapno and errcode
  1012bb:	83 c4 08             	add    $0x8,%esp
  iret
  1012be:	cf                   	iret   

001012bf <lidt>:
{
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
  1012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1012c8:	83 e8 01             	sub    $0x1,%eax
  1012cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  1012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d9:	c1 e8 10             	shr    $0x10,%eax
  1012dc:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
  1012e0:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1012e3:	0f 01 18             	lidtl  (%eax)
}
  1012e6:	90                   	nop
  1012e7:	c9                   	leave  
  1012e8:	c3                   	ret    

001012e9 <rcr2>:

static inline uint
rcr2(void)
{
  1012e9:	55                   	push   %ebp
  1012ea:	89 e5                	mov    %esp,%ebp
  1012ec:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  1012ef:	0f 20 d0             	mov    %cr2,%eax
  1012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
  1012f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1012f8:	c9                   	leave  
  1012f9:	c3                   	ret    

001012fa <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
uint ticks;

void
tvinit(void)
{
  1012fa:	f3 0f 1e fb          	endbr32 
  1012fe:	55                   	push   %ebp
  1012ff:	89 e5                	mov    %esp,%ebp
  101301:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
  101304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10130b:	e9 c3 00 00 00       	jmp    1013d3 <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  101310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101313:	8b 04 85 11 50 10 00 	mov    0x105011(,%eax,4),%eax
  10131a:	89 c2                	mov    %eax,%edx
  10131c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10131f:	66 89 14 c5 00 65 10 	mov    %dx,0x106500(,%eax,8)
  101326:	00 
  101327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10132a:	66 c7 04 c5 02 65 10 	movw   $0x8,0x106502(,%eax,8)
  101331:	00 08 00 
  101334:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101337:	0f b6 14 c5 04 65 10 	movzbl 0x106504(,%eax,8),%edx
  10133e:	00 
  10133f:	83 e2 e0             	and    $0xffffffe0,%edx
  101342:	88 14 c5 04 65 10 00 	mov    %dl,0x106504(,%eax,8)
  101349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10134c:	0f b6 14 c5 04 65 10 	movzbl 0x106504(,%eax,8),%edx
  101353:	00 
  101354:	83 e2 1f             	and    $0x1f,%edx
  101357:	88 14 c5 04 65 10 00 	mov    %dl,0x106504(,%eax,8)
  10135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101361:	0f b6 14 c5 05 65 10 	movzbl 0x106505(,%eax,8),%edx
  101368:	00 
  101369:	83 e2 f0             	and    $0xfffffff0,%edx
  10136c:	83 ca 0e             	or     $0xe,%edx
  10136f:	88 14 c5 05 65 10 00 	mov    %dl,0x106505(,%eax,8)
  101376:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101379:	0f b6 14 c5 05 65 10 	movzbl 0x106505(,%eax,8),%edx
  101380:	00 
  101381:	83 e2 ef             	and    $0xffffffef,%edx
  101384:	88 14 c5 05 65 10 00 	mov    %dl,0x106505(,%eax,8)
  10138b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10138e:	0f b6 14 c5 05 65 10 	movzbl 0x106505(,%eax,8),%edx
  101395:	00 
  101396:	83 e2 9f             	and    $0xffffff9f,%edx
  101399:	88 14 c5 05 65 10 00 	mov    %dl,0x106505(,%eax,8)
  1013a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1013a3:	0f b6 14 c5 05 65 10 	movzbl 0x106505(,%eax,8),%edx
  1013aa:	00 
  1013ab:	83 ca 80             	or     $0xffffff80,%edx
  1013ae:	88 14 c5 05 65 10 00 	mov    %dl,0x106505(,%eax,8)
  1013b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1013b8:	8b 04 85 11 50 10 00 	mov    0x105011(,%eax,4),%eax
  1013bf:	c1 e8 10             	shr    $0x10,%eax
  1013c2:	89 c2                	mov    %eax,%edx
  1013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1013c7:	66 89 14 c5 06 65 10 	mov    %dx,0x106506(,%eax,8)
  1013ce:	00 
  for(i = 0; i < 256; i++)
  1013cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1013d3:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1013da:	0f 8e 30 ff ff ff    	jle    101310 <tvinit+0x16>
}
  1013e0:	90                   	nop
  1013e1:	90                   	nop
  1013e2:	c9                   	leave  
  1013e3:	c3                   	ret    

001013e4 <idtinit>:

void
idtinit(void)
{
  1013e4:	f3 0f 1e fb          	endbr32 
  1013e8:	55                   	push   %ebp
  1013e9:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
  1013eb:	68 00 08 00 00       	push   $0x800
  1013f0:	68 00 65 10 00       	push   $0x106500
  1013f5:	e8 c5 fe ff ff       	call   1012bf <lidt>
  1013fa:	83 c4 08             	add    $0x8,%esp
}
  1013fd:	90                   	nop
  1013fe:	c9                   	leave  
  1013ff:	c3                   	ret    

00101400 <trap>:

void
trap(struct trapframe *tf)
{
  101400:	f3 0f 1e fb          	endbr32 
  101404:	55                   	push   %ebp
  101405:	89 e5                	mov    %esp,%ebp
  101407:	56                   	push   %esi
  101408:	53                   	push   %ebx
  switch(tf->trapno){
  101409:	8b 45 08             	mov    0x8(%ebp),%eax
  10140c:	8b 40 20             	mov    0x20(%eax),%eax
  10140f:	83 e8 20             	sub    $0x20,%eax
  101412:	83 f8 1f             	cmp    $0x1f,%eax
  101415:	77 62                	ja     101479 <trap+0x79>
  101417:	8b 04 85 b4 42 10 00 	mov    0x1042b4(,%eax,4),%eax
  10141e:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    ticks++;
  101421:	a1 00 6d 10 00       	mov    0x106d00,%eax
  101426:	83 c0 01             	add    $0x1,%eax
  101429:	a3 00 6d 10 00       	mov    %eax,0x106d00
    lapiceoi();
  10142e:	e8 38 f3 ff ff       	call   10076b <lapiceoi>
    break;
  101433:	eb 7d                	jmp    1014b2 <trap+0xb2>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  101435:	e8 2e 10 00 00       	call   102468 <ideintr>
    lapiceoi();
  10143a:	e8 2c f3 ff ff       	call   10076b <lapiceoi>
    break;
  10143f:	eb 71                	jmp    1014b2 <trap+0xb2>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  101441:	e8 61 fa ff ff       	call   100ea7 <uartintr>
    lapiceoi();
  101446:	e8 20 f3 ff ff       	call   10076b <lapiceoi>
    break;
  10144b:	eb 65                	jmp    1014b2 <trap+0xb2>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  10144d:	8b 45 08             	mov    0x8(%ebp),%eax
  101450:	8b 70 28             	mov    0x28(%eax),%esi
            cpuid(), tf->cs, tf->eip);
  101453:	8b 45 08             	mov    0x8(%ebp),%eax
  101456:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  10145a:	0f b7 d8             	movzwl %ax,%ebx
  10145d:	e8 52 fd ff ff       	call   1011b4 <cpuid>
  101462:	56                   	push   %esi
  101463:	53                   	push   %ebx
  101464:	50                   	push   %eax
  101465:	68 58 42 10 00       	push   $0x104258
  10146a:	e8 81 ec ff ff       	call   1000f0 <cprintf>
  10146f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
  101472:	e8 f4 f2 ff ff       	call   10076b <lapiceoi>
    break;
  101477:	eb 39                	jmp    1014b2 <trap+0xb2>

  default:
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  101479:	e8 6b fe ff ff       	call   1012e9 <rcr2>
  10147e:	89 c3                	mov    %eax,%ebx
  101480:	8b 45 08             	mov    0x8(%ebp),%eax
  101483:	8b 70 28             	mov    0x28(%eax),%esi
  101486:	e8 29 fd ff ff       	call   1011b4 <cpuid>
  10148b:	8b 55 08             	mov    0x8(%ebp),%edx
  10148e:	8b 52 20             	mov    0x20(%edx),%edx
  101491:	83 ec 0c             	sub    $0xc,%esp
  101494:	53                   	push   %ebx
  101495:	56                   	push   %esi
  101496:	50                   	push   %eax
  101497:	52                   	push   %edx
  101498:	68 7c 42 10 00       	push   $0x10427c
  10149d:	e8 4e ec ff ff       	call   1000f0 <cprintf>
  1014a2:	83 c4 20             	add    $0x20,%esp
            tf->trapno, cpuid(), tf->eip, rcr2());
    panic("trap");
  1014a5:	83 ec 0c             	sub    $0xc,%esp
  1014a8:	68 ae 42 10 00       	push   $0x1042ae
  1014ad:	e8 07 ee ff ff       	call   1002b9 <panic>
  }
}
  1014b2:	90                   	nop
  1014b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1014b6:	5b                   	pop    %ebx
  1014b7:	5e                   	pop    %esi
  1014b8:	5d                   	pop    %ebp
  1014b9:	c3                   	ret    

001014ba <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  1014ba:	6a 00                	push   $0x0
  pushl $0
  1014bc:	6a 00                	push   $0x0
  jmp alltraps
  1014be:	e9 ed fd ff ff       	jmp    1012b0 <alltraps>

001014c3 <vector1>:
.globl vector1
vector1:
  pushl $0
  1014c3:	6a 00                	push   $0x0
  pushl $1
  1014c5:	6a 01                	push   $0x1
  jmp alltraps
  1014c7:	e9 e4 fd ff ff       	jmp    1012b0 <alltraps>

001014cc <vector2>:
.globl vector2
vector2:
  pushl $0
  1014cc:	6a 00                	push   $0x0
  pushl $2
  1014ce:	6a 02                	push   $0x2
  jmp alltraps
  1014d0:	e9 db fd ff ff       	jmp    1012b0 <alltraps>

001014d5 <vector3>:
.globl vector3
vector3:
  pushl $0
  1014d5:	6a 00                	push   $0x0
  pushl $3
  1014d7:	6a 03                	push   $0x3
  jmp alltraps
  1014d9:	e9 d2 fd ff ff       	jmp    1012b0 <alltraps>

001014de <vector4>:
.globl vector4
vector4:
  pushl $0
  1014de:	6a 00                	push   $0x0
  pushl $4
  1014e0:	6a 04                	push   $0x4
  jmp alltraps
  1014e2:	e9 c9 fd ff ff       	jmp    1012b0 <alltraps>

001014e7 <vector5>:
.globl vector5
vector5:
  pushl $0
  1014e7:	6a 00                	push   $0x0
  pushl $5
  1014e9:	6a 05                	push   $0x5
  jmp alltraps
  1014eb:	e9 c0 fd ff ff       	jmp    1012b0 <alltraps>

001014f0 <vector6>:
.globl vector6
vector6:
  pushl $0
  1014f0:	6a 00                	push   $0x0
  pushl $6
  1014f2:	6a 06                	push   $0x6
  jmp alltraps
  1014f4:	e9 b7 fd ff ff       	jmp    1012b0 <alltraps>

001014f9 <vector7>:
.globl vector7
vector7:
  pushl $0
  1014f9:	6a 00                	push   $0x0
  pushl $7
  1014fb:	6a 07                	push   $0x7
  jmp alltraps
  1014fd:	e9 ae fd ff ff       	jmp    1012b0 <alltraps>

00101502 <vector8>:
.globl vector8
vector8:
  pushl $8
  101502:	6a 08                	push   $0x8
  jmp alltraps
  101504:	e9 a7 fd ff ff       	jmp    1012b0 <alltraps>

00101509 <vector9>:
.globl vector9
vector9:
  pushl $0
  101509:	6a 00                	push   $0x0
  pushl $9
  10150b:	6a 09                	push   $0x9
  jmp alltraps
  10150d:	e9 9e fd ff ff       	jmp    1012b0 <alltraps>

00101512 <vector10>:
.globl vector10
vector10:
  pushl $10
  101512:	6a 0a                	push   $0xa
  jmp alltraps
  101514:	e9 97 fd ff ff       	jmp    1012b0 <alltraps>

00101519 <vector11>:
.globl vector11
vector11:
  pushl $11
  101519:	6a 0b                	push   $0xb
  jmp alltraps
  10151b:	e9 90 fd ff ff       	jmp    1012b0 <alltraps>

00101520 <vector12>:
.globl vector12
vector12:
  pushl $12
  101520:	6a 0c                	push   $0xc
  jmp alltraps
  101522:	e9 89 fd ff ff       	jmp    1012b0 <alltraps>

00101527 <vector13>:
.globl vector13
vector13:
  pushl $13
  101527:	6a 0d                	push   $0xd
  jmp alltraps
  101529:	e9 82 fd ff ff       	jmp    1012b0 <alltraps>

0010152e <vector14>:
.globl vector14
vector14:
  pushl $14
  10152e:	6a 0e                	push   $0xe
  jmp alltraps
  101530:	e9 7b fd ff ff       	jmp    1012b0 <alltraps>

00101535 <vector15>:
.globl vector15
vector15:
  pushl $0
  101535:	6a 00                	push   $0x0
  pushl $15
  101537:	6a 0f                	push   $0xf
  jmp alltraps
  101539:	e9 72 fd ff ff       	jmp    1012b0 <alltraps>

0010153e <vector16>:
.globl vector16
vector16:
  pushl $0
  10153e:	6a 00                	push   $0x0
  pushl $16
  101540:	6a 10                	push   $0x10
  jmp alltraps
  101542:	e9 69 fd ff ff       	jmp    1012b0 <alltraps>

00101547 <vector17>:
.globl vector17
vector17:
  pushl $17
  101547:	6a 11                	push   $0x11
  jmp alltraps
  101549:	e9 62 fd ff ff       	jmp    1012b0 <alltraps>

0010154e <vector18>:
.globl vector18
vector18:
  pushl $0
  10154e:	6a 00                	push   $0x0
  pushl $18
  101550:	6a 12                	push   $0x12
  jmp alltraps
  101552:	e9 59 fd ff ff       	jmp    1012b0 <alltraps>

00101557 <vector19>:
.globl vector19
vector19:
  pushl $0
  101557:	6a 00                	push   $0x0
  pushl $19
  101559:	6a 13                	push   $0x13
  jmp alltraps
  10155b:	e9 50 fd ff ff       	jmp    1012b0 <alltraps>

00101560 <vector20>:
.globl vector20
vector20:
  pushl $0
  101560:	6a 00                	push   $0x0
  pushl $20
  101562:	6a 14                	push   $0x14
  jmp alltraps
  101564:	e9 47 fd ff ff       	jmp    1012b0 <alltraps>

00101569 <vector21>:
.globl vector21
vector21:
  pushl $0
  101569:	6a 00                	push   $0x0
  pushl $21
  10156b:	6a 15                	push   $0x15
  jmp alltraps
  10156d:	e9 3e fd ff ff       	jmp    1012b0 <alltraps>

00101572 <vector22>:
.globl vector22
vector22:
  pushl $0
  101572:	6a 00                	push   $0x0
  pushl $22
  101574:	6a 16                	push   $0x16
  jmp alltraps
  101576:	e9 35 fd ff ff       	jmp    1012b0 <alltraps>

0010157b <vector23>:
.globl vector23
vector23:
  pushl $0
  10157b:	6a 00                	push   $0x0
  pushl $23
  10157d:	6a 17                	push   $0x17
  jmp alltraps
  10157f:	e9 2c fd ff ff       	jmp    1012b0 <alltraps>

00101584 <vector24>:
.globl vector24
vector24:
  pushl $0
  101584:	6a 00                	push   $0x0
  pushl $24
  101586:	6a 18                	push   $0x18
  jmp alltraps
  101588:	e9 23 fd ff ff       	jmp    1012b0 <alltraps>

0010158d <vector25>:
.globl vector25
vector25:
  pushl $0
  10158d:	6a 00                	push   $0x0
  pushl $25
  10158f:	6a 19                	push   $0x19
  jmp alltraps
  101591:	e9 1a fd ff ff       	jmp    1012b0 <alltraps>

00101596 <vector26>:
.globl vector26
vector26:
  pushl $0
  101596:	6a 00                	push   $0x0
  pushl $26
  101598:	6a 1a                	push   $0x1a
  jmp alltraps
  10159a:	e9 11 fd ff ff       	jmp    1012b0 <alltraps>

0010159f <vector27>:
.globl vector27
vector27:
  pushl $0
  10159f:	6a 00                	push   $0x0
  pushl $27
  1015a1:	6a 1b                	push   $0x1b
  jmp alltraps
  1015a3:	e9 08 fd ff ff       	jmp    1012b0 <alltraps>

001015a8 <vector28>:
.globl vector28
vector28:
  pushl $0
  1015a8:	6a 00                	push   $0x0
  pushl $28
  1015aa:	6a 1c                	push   $0x1c
  jmp alltraps
  1015ac:	e9 ff fc ff ff       	jmp    1012b0 <alltraps>

001015b1 <vector29>:
.globl vector29
vector29:
  pushl $0
  1015b1:	6a 00                	push   $0x0
  pushl $29
  1015b3:	6a 1d                	push   $0x1d
  jmp alltraps
  1015b5:	e9 f6 fc ff ff       	jmp    1012b0 <alltraps>

001015ba <vector30>:
.globl vector30
vector30:
  pushl $0
  1015ba:	6a 00                	push   $0x0
  pushl $30
  1015bc:	6a 1e                	push   $0x1e
  jmp alltraps
  1015be:	e9 ed fc ff ff       	jmp    1012b0 <alltraps>

001015c3 <vector31>:
.globl vector31
vector31:
  pushl $0
  1015c3:	6a 00                	push   $0x0
  pushl $31
  1015c5:	6a 1f                	push   $0x1f
  jmp alltraps
  1015c7:	e9 e4 fc ff ff       	jmp    1012b0 <alltraps>

001015cc <vector32>:
.globl vector32
vector32:
  pushl $0
  1015cc:	6a 00                	push   $0x0
  pushl $32
  1015ce:	6a 20                	push   $0x20
  jmp alltraps
  1015d0:	e9 db fc ff ff       	jmp    1012b0 <alltraps>

001015d5 <vector33>:
.globl vector33
vector33:
  pushl $0
  1015d5:	6a 00                	push   $0x0
  pushl $33
  1015d7:	6a 21                	push   $0x21
  jmp alltraps
  1015d9:	e9 d2 fc ff ff       	jmp    1012b0 <alltraps>

001015de <vector34>:
.globl vector34
vector34:
  pushl $0
  1015de:	6a 00                	push   $0x0
  pushl $34
  1015e0:	6a 22                	push   $0x22
  jmp alltraps
  1015e2:	e9 c9 fc ff ff       	jmp    1012b0 <alltraps>

001015e7 <vector35>:
.globl vector35
vector35:
  pushl $0
  1015e7:	6a 00                	push   $0x0
  pushl $35
  1015e9:	6a 23                	push   $0x23
  jmp alltraps
  1015eb:	e9 c0 fc ff ff       	jmp    1012b0 <alltraps>

001015f0 <vector36>:
.globl vector36
vector36:
  pushl $0
  1015f0:	6a 00                	push   $0x0
  pushl $36
  1015f2:	6a 24                	push   $0x24
  jmp alltraps
  1015f4:	e9 b7 fc ff ff       	jmp    1012b0 <alltraps>

001015f9 <vector37>:
.globl vector37
vector37:
  pushl $0
  1015f9:	6a 00                	push   $0x0
  pushl $37
  1015fb:	6a 25                	push   $0x25
  jmp alltraps
  1015fd:	e9 ae fc ff ff       	jmp    1012b0 <alltraps>

00101602 <vector38>:
.globl vector38
vector38:
  pushl $0
  101602:	6a 00                	push   $0x0
  pushl $38
  101604:	6a 26                	push   $0x26
  jmp alltraps
  101606:	e9 a5 fc ff ff       	jmp    1012b0 <alltraps>

0010160b <vector39>:
.globl vector39
vector39:
  pushl $0
  10160b:	6a 00                	push   $0x0
  pushl $39
  10160d:	6a 27                	push   $0x27
  jmp alltraps
  10160f:	e9 9c fc ff ff       	jmp    1012b0 <alltraps>

00101614 <vector40>:
.globl vector40
vector40:
  pushl $0
  101614:	6a 00                	push   $0x0
  pushl $40
  101616:	6a 28                	push   $0x28
  jmp alltraps
  101618:	e9 93 fc ff ff       	jmp    1012b0 <alltraps>

0010161d <vector41>:
.globl vector41
vector41:
  pushl $0
  10161d:	6a 00                	push   $0x0
  pushl $41
  10161f:	6a 29                	push   $0x29
  jmp alltraps
  101621:	e9 8a fc ff ff       	jmp    1012b0 <alltraps>

00101626 <vector42>:
.globl vector42
vector42:
  pushl $0
  101626:	6a 00                	push   $0x0
  pushl $42
  101628:	6a 2a                	push   $0x2a
  jmp alltraps
  10162a:	e9 81 fc ff ff       	jmp    1012b0 <alltraps>

0010162f <vector43>:
.globl vector43
vector43:
  pushl $0
  10162f:	6a 00                	push   $0x0
  pushl $43
  101631:	6a 2b                	push   $0x2b
  jmp alltraps
  101633:	e9 78 fc ff ff       	jmp    1012b0 <alltraps>

00101638 <vector44>:
.globl vector44
vector44:
  pushl $0
  101638:	6a 00                	push   $0x0
  pushl $44
  10163a:	6a 2c                	push   $0x2c
  jmp alltraps
  10163c:	e9 6f fc ff ff       	jmp    1012b0 <alltraps>

00101641 <vector45>:
.globl vector45
vector45:
  pushl $0
  101641:	6a 00                	push   $0x0
  pushl $45
  101643:	6a 2d                	push   $0x2d
  jmp alltraps
  101645:	e9 66 fc ff ff       	jmp    1012b0 <alltraps>

0010164a <vector46>:
.globl vector46
vector46:
  pushl $0
  10164a:	6a 00                	push   $0x0
  pushl $46
  10164c:	6a 2e                	push   $0x2e
  jmp alltraps
  10164e:	e9 5d fc ff ff       	jmp    1012b0 <alltraps>

00101653 <vector47>:
.globl vector47
vector47:
  pushl $0
  101653:	6a 00                	push   $0x0
  pushl $47
  101655:	6a 2f                	push   $0x2f
  jmp alltraps
  101657:	e9 54 fc ff ff       	jmp    1012b0 <alltraps>

0010165c <vector48>:
.globl vector48
vector48:
  pushl $0
  10165c:	6a 00                	push   $0x0
  pushl $48
  10165e:	6a 30                	push   $0x30
  jmp alltraps
  101660:	e9 4b fc ff ff       	jmp    1012b0 <alltraps>

00101665 <vector49>:
.globl vector49
vector49:
  pushl $0
  101665:	6a 00                	push   $0x0
  pushl $49
  101667:	6a 31                	push   $0x31
  jmp alltraps
  101669:	e9 42 fc ff ff       	jmp    1012b0 <alltraps>

0010166e <vector50>:
.globl vector50
vector50:
  pushl $0
  10166e:	6a 00                	push   $0x0
  pushl $50
  101670:	6a 32                	push   $0x32
  jmp alltraps
  101672:	e9 39 fc ff ff       	jmp    1012b0 <alltraps>

00101677 <vector51>:
.globl vector51
vector51:
  pushl $0
  101677:	6a 00                	push   $0x0
  pushl $51
  101679:	6a 33                	push   $0x33
  jmp alltraps
  10167b:	e9 30 fc ff ff       	jmp    1012b0 <alltraps>

00101680 <vector52>:
.globl vector52
vector52:
  pushl $0
  101680:	6a 00                	push   $0x0
  pushl $52
  101682:	6a 34                	push   $0x34
  jmp alltraps
  101684:	e9 27 fc ff ff       	jmp    1012b0 <alltraps>

00101689 <vector53>:
.globl vector53
vector53:
  pushl $0
  101689:	6a 00                	push   $0x0
  pushl $53
  10168b:	6a 35                	push   $0x35
  jmp alltraps
  10168d:	e9 1e fc ff ff       	jmp    1012b0 <alltraps>

00101692 <vector54>:
.globl vector54
vector54:
  pushl $0
  101692:	6a 00                	push   $0x0
  pushl $54
  101694:	6a 36                	push   $0x36
  jmp alltraps
  101696:	e9 15 fc ff ff       	jmp    1012b0 <alltraps>

0010169b <vector55>:
.globl vector55
vector55:
  pushl $0
  10169b:	6a 00                	push   $0x0
  pushl $55
  10169d:	6a 37                	push   $0x37
  jmp alltraps
  10169f:	e9 0c fc ff ff       	jmp    1012b0 <alltraps>

001016a4 <vector56>:
.globl vector56
vector56:
  pushl $0
  1016a4:	6a 00                	push   $0x0
  pushl $56
  1016a6:	6a 38                	push   $0x38
  jmp alltraps
  1016a8:	e9 03 fc ff ff       	jmp    1012b0 <alltraps>

001016ad <vector57>:
.globl vector57
vector57:
  pushl $0
  1016ad:	6a 00                	push   $0x0
  pushl $57
  1016af:	6a 39                	push   $0x39
  jmp alltraps
  1016b1:	e9 fa fb ff ff       	jmp    1012b0 <alltraps>

001016b6 <vector58>:
.globl vector58
vector58:
  pushl $0
  1016b6:	6a 00                	push   $0x0
  pushl $58
  1016b8:	6a 3a                	push   $0x3a
  jmp alltraps
  1016ba:	e9 f1 fb ff ff       	jmp    1012b0 <alltraps>

001016bf <vector59>:
.globl vector59
vector59:
  pushl $0
  1016bf:	6a 00                	push   $0x0
  pushl $59
  1016c1:	6a 3b                	push   $0x3b
  jmp alltraps
  1016c3:	e9 e8 fb ff ff       	jmp    1012b0 <alltraps>

001016c8 <vector60>:
.globl vector60
vector60:
  pushl $0
  1016c8:	6a 00                	push   $0x0
  pushl $60
  1016ca:	6a 3c                	push   $0x3c
  jmp alltraps
  1016cc:	e9 df fb ff ff       	jmp    1012b0 <alltraps>

001016d1 <vector61>:
.globl vector61
vector61:
  pushl $0
  1016d1:	6a 00                	push   $0x0
  pushl $61
  1016d3:	6a 3d                	push   $0x3d
  jmp alltraps
  1016d5:	e9 d6 fb ff ff       	jmp    1012b0 <alltraps>

001016da <vector62>:
.globl vector62
vector62:
  pushl $0
  1016da:	6a 00                	push   $0x0
  pushl $62
  1016dc:	6a 3e                	push   $0x3e
  jmp alltraps
  1016de:	e9 cd fb ff ff       	jmp    1012b0 <alltraps>

001016e3 <vector63>:
.globl vector63
vector63:
  pushl $0
  1016e3:	6a 00                	push   $0x0
  pushl $63
  1016e5:	6a 3f                	push   $0x3f
  jmp alltraps
  1016e7:	e9 c4 fb ff ff       	jmp    1012b0 <alltraps>

001016ec <vector64>:
.globl vector64
vector64:
  pushl $0
  1016ec:	6a 00                	push   $0x0
  pushl $64
  1016ee:	6a 40                	push   $0x40
  jmp alltraps
  1016f0:	e9 bb fb ff ff       	jmp    1012b0 <alltraps>

001016f5 <vector65>:
.globl vector65
vector65:
  pushl $0
  1016f5:	6a 00                	push   $0x0
  pushl $65
  1016f7:	6a 41                	push   $0x41
  jmp alltraps
  1016f9:	e9 b2 fb ff ff       	jmp    1012b0 <alltraps>

001016fe <vector66>:
.globl vector66
vector66:
  pushl $0
  1016fe:	6a 00                	push   $0x0
  pushl $66
  101700:	6a 42                	push   $0x42
  jmp alltraps
  101702:	e9 a9 fb ff ff       	jmp    1012b0 <alltraps>

00101707 <vector67>:
.globl vector67
vector67:
  pushl $0
  101707:	6a 00                	push   $0x0
  pushl $67
  101709:	6a 43                	push   $0x43
  jmp alltraps
  10170b:	e9 a0 fb ff ff       	jmp    1012b0 <alltraps>

00101710 <vector68>:
.globl vector68
vector68:
  pushl $0
  101710:	6a 00                	push   $0x0
  pushl $68
  101712:	6a 44                	push   $0x44
  jmp alltraps
  101714:	e9 97 fb ff ff       	jmp    1012b0 <alltraps>

00101719 <vector69>:
.globl vector69
vector69:
  pushl $0
  101719:	6a 00                	push   $0x0
  pushl $69
  10171b:	6a 45                	push   $0x45
  jmp alltraps
  10171d:	e9 8e fb ff ff       	jmp    1012b0 <alltraps>

00101722 <vector70>:
.globl vector70
vector70:
  pushl $0
  101722:	6a 00                	push   $0x0
  pushl $70
  101724:	6a 46                	push   $0x46
  jmp alltraps
  101726:	e9 85 fb ff ff       	jmp    1012b0 <alltraps>

0010172b <vector71>:
.globl vector71
vector71:
  pushl $0
  10172b:	6a 00                	push   $0x0
  pushl $71
  10172d:	6a 47                	push   $0x47
  jmp alltraps
  10172f:	e9 7c fb ff ff       	jmp    1012b0 <alltraps>

00101734 <vector72>:
.globl vector72
vector72:
  pushl $0
  101734:	6a 00                	push   $0x0
  pushl $72
  101736:	6a 48                	push   $0x48
  jmp alltraps
  101738:	e9 73 fb ff ff       	jmp    1012b0 <alltraps>

0010173d <vector73>:
.globl vector73
vector73:
  pushl $0
  10173d:	6a 00                	push   $0x0
  pushl $73
  10173f:	6a 49                	push   $0x49
  jmp alltraps
  101741:	e9 6a fb ff ff       	jmp    1012b0 <alltraps>

00101746 <vector74>:
.globl vector74
vector74:
  pushl $0
  101746:	6a 00                	push   $0x0
  pushl $74
  101748:	6a 4a                	push   $0x4a
  jmp alltraps
  10174a:	e9 61 fb ff ff       	jmp    1012b0 <alltraps>

0010174f <vector75>:
.globl vector75
vector75:
  pushl $0
  10174f:	6a 00                	push   $0x0
  pushl $75
  101751:	6a 4b                	push   $0x4b
  jmp alltraps
  101753:	e9 58 fb ff ff       	jmp    1012b0 <alltraps>

00101758 <vector76>:
.globl vector76
vector76:
  pushl $0
  101758:	6a 00                	push   $0x0
  pushl $76
  10175a:	6a 4c                	push   $0x4c
  jmp alltraps
  10175c:	e9 4f fb ff ff       	jmp    1012b0 <alltraps>

00101761 <vector77>:
.globl vector77
vector77:
  pushl $0
  101761:	6a 00                	push   $0x0
  pushl $77
  101763:	6a 4d                	push   $0x4d
  jmp alltraps
  101765:	e9 46 fb ff ff       	jmp    1012b0 <alltraps>

0010176a <vector78>:
.globl vector78
vector78:
  pushl $0
  10176a:	6a 00                	push   $0x0
  pushl $78
  10176c:	6a 4e                	push   $0x4e
  jmp alltraps
  10176e:	e9 3d fb ff ff       	jmp    1012b0 <alltraps>

00101773 <vector79>:
.globl vector79
vector79:
  pushl $0
  101773:	6a 00                	push   $0x0
  pushl $79
  101775:	6a 4f                	push   $0x4f
  jmp alltraps
  101777:	e9 34 fb ff ff       	jmp    1012b0 <alltraps>

0010177c <vector80>:
.globl vector80
vector80:
  pushl $0
  10177c:	6a 00                	push   $0x0
  pushl $80
  10177e:	6a 50                	push   $0x50
  jmp alltraps
  101780:	e9 2b fb ff ff       	jmp    1012b0 <alltraps>

00101785 <vector81>:
.globl vector81
vector81:
  pushl $0
  101785:	6a 00                	push   $0x0
  pushl $81
  101787:	6a 51                	push   $0x51
  jmp alltraps
  101789:	e9 22 fb ff ff       	jmp    1012b0 <alltraps>

0010178e <vector82>:
.globl vector82
vector82:
  pushl $0
  10178e:	6a 00                	push   $0x0
  pushl $82
  101790:	6a 52                	push   $0x52
  jmp alltraps
  101792:	e9 19 fb ff ff       	jmp    1012b0 <alltraps>

00101797 <vector83>:
.globl vector83
vector83:
  pushl $0
  101797:	6a 00                	push   $0x0
  pushl $83
  101799:	6a 53                	push   $0x53
  jmp alltraps
  10179b:	e9 10 fb ff ff       	jmp    1012b0 <alltraps>

001017a0 <vector84>:
.globl vector84
vector84:
  pushl $0
  1017a0:	6a 00                	push   $0x0
  pushl $84
  1017a2:	6a 54                	push   $0x54
  jmp alltraps
  1017a4:	e9 07 fb ff ff       	jmp    1012b0 <alltraps>

001017a9 <vector85>:
.globl vector85
vector85:
  pushl $0
  1017a9:	6a 00                	push   $0x0
  pushl $85
  1017ab:	6a 55                	push   $0x55
  jmp alltraps
  1017ad:	e9 fe fa ff ff       	jmp    1012b0 <alltraps>

001017b2 <vector86>:
.globl vector86
vector86:
  pushl $0
  1017b2:	6a 00                	push   $0x0
  pushl $86
  1017b4:	6a 56                	push   $0x56
  jmp alltraps
  1017b6:	e9 f5 fa ff ff       	jmp    1012b0 <alltraps>

001017bb <vector87>:
.globl vector87
vector87:
  pushl $0
  1017bb:	6a 00                	push   $0x0
  pushl $87
  1017bd:	6a 57                	push   $0x57
  jmp alltraps
  1017bf:	e9 ec fa ff ff       	jmp    1012b0 <alltraps>

001017c4 <vector88>:
.globl vector88
vector88:
  pushl $0
  1017c4:	6a 00                	push   $0x0
  pushl $88
  1017c6:	6a 58                	push   $0x58
  jmp alltraps
  1017c8:	e9 e3 fa ff ff       	jmp    1012b0 <alltraps>

001017cd <vector89>:
.globl vector89
vector89:
  pushl $0
  1017cd:	6a 00                	push   $0x0
  pushl $89
  1017cf:	6a 59                	push   $0x59
  jmp alltraps
  1017d1:	e9 da fa ff ff       	jmp    1012b0 <alltraps>

001017d6 <vector90>:
.globl vector90
vector90:
  pushl $0
  1017d6:	6a 00                	push   $0x0
  pushl $90
  1017d8:	6a 5a                	push   $0x5a
  jmp alltraps
  1017da:	e9 d1 fa ff ff       	jmp    1012b0 <alltraps>

001017df <vector91>:
.globl vector91
vector91:
  pushl $0
  1017df:	6a 00                	push   $0x0
  pushl $91
  1017e1:	6a 5b                	push   $0x5b
  jmp alltraps
  1017e3:	e9 c8 fa ff ff       	jmp    1012b0 <alltraps>

001017e8 <vector92>:
.globl vector92
vector92:
  pushl $0
  1017e8:	6a 00                	push   $0x0
  pushl $92
  1017ea:	6a 5c                	push   $0x5c
  jmp alltraps
  1017ec:	e9 bf fa ff ff       	jmp    1012b0 <alltraps>

001017f1 <vector93>:
.globl vector93
vector93:
  pushl $0
  1017f1:	6a 00                	push   $0x0
  pushl $93
  1017f3:	6a 5d                	push   $0x5d
  jmp alltraps
  1017f5:	e9 b6 fa ff ff       	jmp    1012b0 <alltraps>

001017fa <vector94>:
.globl vector94
vector94:
  pushl $0
  1017fa:	6a 00                	push   $0x0
  pushl $94
  1017fc:	6a 5e                	push   $0x5e
  jmp alltraps
  1017fe:	e9 ad fa ff ff       	jmp    1012b0 <alltraps>

00101803 <vector95>:
.globl vector95
vector95:
  pushl $0
  101803:	6a 00                	push   $0x0
  pushl $95
  101805:	6a 5f                	push   $0x5f
  jmp alltraps
  101807:	e9 a4 fa ff ff       	jmp    1012b0 <alltraps>

0010180c <vector96>:
.globl vector96
vector96:
  pushl $0
  10180c:	6a 00                	push   $0x0
  pushl $96
  10180e:	6a 60                	push   $0x60
  jmp alltraps
  101810:	e9 9b fa ff ff       	jmp    1012b0 <alltraps>

00101815 <vector97>:
.globl vector97
vector97:
  pushl $0
  101815:	6a 00                	push   $0x0
  pushl $97
  101817:	6a 61                	push   $0x61
  jmp alltraps
  101819:	e9 92 fa ff ff       	jmp    1012b0 <alltraps>

0010181e <vector98>:
.globl vector98
vector98:
  pushl $0
  10181e:	6a 00                	push   $0x0
  pushl $98
  101820:	6a 62                	push   $0x62
  jmp alltraps
  101822:	e9 89 fa ff ff       	jmp    1012b0 <alltraps>

00101827 <vector99>:
.globl vector99
vector99:
  pushl $0
  101827:	6a 00                	push   $0x0
  pushl $99
  101829:	6a 63                	push   $0x63
  jmp alltraps
  10182b:	e9 80 fa ff ff       	jmp    1012b0 <alltraps>

00101830 <vector100>:
.globl vector100
vector100:
  pushl $0
  101830:	6a 00                	push   $0x0
  pushl $100
  101832:	6a 64                	push   $0x64
  jmp alltraps
  101834:	e9 77 fa ff ff       	jmp    1012b0 <alltraps>

00101839 <vector101>:
.globl vector101
vector101:
  pushl $0
  101839:	6a 00                	push   $0x0
  pushl $101
  10183b:	6a 65                	push   $0x65
  jmp alltraps
  10183d:	e9 6e fa ff ff       	jmp    1012b0 <alltraps>

00101842 <vector102>:
.globl vector102
vector102:
  pushl $0
  101842:	6a 00                	push   $0x0
  pushl $102
  101844:	6a 66                	push   $0x66
  jmp alltraps
  101846:	e9 65 fa ff ff       	jmp    1012b0 <alltraps>

0010184b <vector103>:
.globl vector103
vector103:
  pushl $0
  10184b:	6a 00                	push   $0x0
  pushl $103
  10184d:	6a 67                	push   $0x67
  jmp alltraps
  10184f:	e9 5c fa ff ff       	jmp    1012b0 <alltraps>

00101854 <vector104>:
.globl vector104
vector104:
  pushl $0
  101854:	6a 00                	push   $0x0
  pushl $104
  101856:	6a 68                	push   $0x68
  jmp alltraps
  101858:	e9 53 fa ff ff       	jmp    1012b0 <alltraps>

0010185d <vector105>:
.globl vector105
vector105:
  pushl $0
  10185d:	6a 00                	push   $0x0
  pushl $105
  10185f:	6a 69                	push   $0x69
  jmp alltraps
  101861:	e9 4a fa ff ff       	jmp    1012b0 <alltraps>

00101866 <vector106>:
.globl vector106
vector106:
  pushl $0
  101866:	6a 00                	push   $0x0
  pushl $106
  101868:	6a 6a                	push   $0x6a
  jmp alltraps
  10186a:	e9 41 fa ff ff       	jmp    1012b0 <alltraps>

0010186f <vector107>:
.globl vector107
vector107:
  pushl $0
  10186f:	6a 00                	push   $0x0
  pushl $107
  101871:	6a 6b                	push   $0x6b
  jmp alltraps
  101873:	e9 38 fa ff ff       	jmp    1012b0 <alltraps>

00101878 <vector108>:
.globl vector108
vector108:
  pushl $0
  101878:	6a 00                	push   $0x0
  pushl $108
  10187a:	6a 6c                	push   $0x6c
  jmp alltraps
  10187c:	e9 2f fa ff ff       	jmp    1012b0 <alltraps>

00101881 <vector109>:
.globl vector109
vector109:
  pushl $0
  101881:	6a 00                	push   $0x0
  pushl $109
  101883:	6a 6d                	push   $0x6d
  jmp alltraps
  101885:	e9 26 fa ff ff       	jmp    1012b0 <alltraps>

0010188a <vector110>:
.globl vector110
vector110:
  pushl $0
  10188a:	6a 00                	push   $0x0
  pushl $110
  10188c:	6a 6e                	push   $0x6e
  jmp alltraps
  10188e:	e9 1d fa ff ff       	jmp    1012b0 <alltraps>

00101893 <vector111>:
.globl vector111
vector111:
  pushl $0
  101893:	6a 00                	push   $0x0
  pushl $111
  101895:	6a 6f                	push   $0x6f
  jmp alltraps
  101897:	e9 14 fa ff ff       	jmp    1012b0 <alltraps>

0010189c <vector112>:
.globl vector112
vector112:
  pushl $0
  10189c:	6a 00                	push   $0x0
  pushl $112
  10189e:	6a 70                	push   $0x70
  jmp alltraps
  1018a0:	e9 0b fa ff ff       	jmp    1012b0 <alltraps>

001018a5 <vector113>:
.globl vector113
vector113:
  pushl $0
  1018a5:	6a 00                	push   $0x0
  pushl $113
  1018a7:	6a 71                	push   $0x71
  jmp alltraps
  1018a9:	e9 02 fa ff ff       	jmp    1012b0 <alltraps>

001018ae <vector114>:
.globl vector114
vector114:
  pushl $0
  1018ae:	6a 00                	push   $0x0
  pushl $114
  1018b0:	6a 72                	push   $0x72
  jmp alltraps
  1018b2:	e9 f9 f9 ff ff       	jmp    1012b0 <alltraps>

001018b7 <vector115>:
.globl vector115
vector115:
  pushl $0
  1018b7:	6a 00                	push   $0x0
  pushl $115
  1018b9:	6a 73                	push   $0x73
  jmp alltraps
  1018bb:	e9 f0 f9 ff ff       	jmp    1012b0 <alltraps>

001018c0 <vector116>:
.globl vector116
vector116:
  pushl $0
  1018c0:	6a 00                	push   $0x0
  pushl $116
  1018c2:	6a 74                	push   $0x74
  jmp alltraps
  1018c4:	e9 e7 f9 ff ff       	jmp    1012b0 <alltraps>

001018c9 <vector117>:
.globl vector117
vector117:
  pushl $0
  1018c9:	6a 00                	push   $0x0
  pushl $117
  1018cb:	6a 75                	push   $0x75
  jmp alltraps
  1018cd:	e9 de f9 ff ff       	jmp    1012b0 <alltraps>

001018d2 <vector118>:
.globl vector118
vector118:
  pushl $0
  1018d2:	6a 00                	push   $0x0
  pushl $118
  1018d4:	6a 76                	push   $0x76
  jmp alltraps
  1018d6:	e9 d5 f9 ff ff       	jmp    1012b0 <alltraps>

001018db <vector119>:
.globl vector119
vector119:
  pushl $0
  1018db:	6a 00                	push   $0x0
  pushl $119
  1018dd:	6a 77                	push   $0x77
  jmp alltraps
  1018df:	e9 cc f9 ff ff       	jmp    1012b0 <alltraps>

001018e4 <vector120>:
.globl vector120
vector120:
  pushl $0
  1018e4:	6a 00                	push   $0x0
  pushl $120
  1018e6:	6a 78                	push   $0x78
  jmp alltraps
  1018e8:	e9 c3 f9 ff ff       	jmp    1012b0 <alltraps>

001018ed <vector121>:
.globl vector121
vector121:
  pushl $0
  1018ed:	6a 00                	push   $0x0
  pushl $121
  1018ef:	6a 79                	push   $0x79
  jmp alltraps
  1018f1:	e9 ba f9 ff ff       	jmp    1012b0 <alltraps>

001018f6 <vector122>:
.globl vector122
vector122:
  pushl $0
  1018f6:	6a 00                	push   $0x0
  pushl $122
  1018f8:	6a 7a                	push   $0x7a
  jmp alltraps
  1018fa:	e9 b1 f9 ff ff       	jmp    1012b0 <alltraps>

001018ff <vector123>:
.globl vector123
vector123:
  pushl $0
  1018ff:	6a 00                	push   $0x0
  pushl $123
  101901:	6a 7b                	push   $0x7b
  jmp alltraps
  101903:	e9 a8 f9 ff ff       	jmp    1012b0 <alltraps>

00101908 <vector124>:
.globl vector124
vector124:
  pushl $0
  101908:	6a 00                	push   $0x0
  pushl $124
  10190a:	6a 7c                	push   $0x7c
  jmp alltraps
  10190c:	e9 9f f9 ff ff       	jmp    1012b0 <alltraps>

00101911 <vector125>:
.globl vector125
vector125:
  pushl $0
  101911:	6a 00                	push   $0x0
  pushl $125
  101913:	6a 7d                	push   $0x7d
  jmp alltraps
  101915:	e9 96 f9 ff ff       	jmp    1012b0 <alltraps>

0010191a <vector126>:
.globl vector126
vector126:
  pushl $0
  10191a:	6a 00                	push   $0x0
  pushl $126
  10191c:	6a 7e                	push   $0x7e
  jmp alltraps
  10191e:	e9 8d f9 ff ff       	jmp    1012b0 <alltraps>

00101923 <vector127>:
.globl vector127
vector127:
  pushl $0
  101923:	6a 00                	push   $0x0
  pushl $127
  101925:	6a 7f                	push   $0x7f
  jmp alltraps
  101927:	e9 84 f9 ff ff       	jmp    1012b0 <alltraps>

0010192c <vector128>:
.globl vector128
vector128:
  pushl $0
  10192c:	6a 00                	push   $0x0
  pushl $128
  10192e:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  101933:	e9 78 f9 ff ff       	jmp    1012b0 <alltraps>

00101938 <vector129>:
.globl vector129
vector129:
  pushl $0
  101938:	6a 00                	push   $0x0
  pushl $129
  10193a:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  10193f:	e9 6c f9 ff ff       	jmp    1012b0 <alltraps>

00101944 <vector130>:
.globl vector130
vector130:
  pushl $0
  101944:	6a 00                	push   $0x0
  pushl $130
  101946:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  10194b:	e9 60 f9 ff ff       	jmp    1012b0 <alltraps>

00101950 <vector131>:
.globl vector131
vector131:
  pushl $0
  101950:	6a 00                	push   $0x0
  pushl $131
  101952:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  101957:	e9 54 f9 ff ff       	jmp    1012b0 <alltraps>

0010195c <vector132>:
.globl vector132
vector132:
  pushl $0
  10195c:	6a 00                	push   $0x0
  pushl $132
  10195e:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  101963:	e9 48 f9 ff ff       	jmp    1012b0 <alltraps>

00101968 <vector133>:
.globl vector133
vector133:
  pushl $0
  101968:	6a 00                	push   $0x0
  pushl $133
  10196a:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  10196f:	e9 3c f9 ff ff       	jmp    1012b0 <alltraps>

00101974 <vector134>:
.globl vector134
vector134:
  pushl $0
  101974:	6a 00                	push   $0x0
  pushl $134
  101976:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  10197b:	e9 30 f9 ff ff       	jmp    1012b0 <alltraps>

00101980 <vector135>:
.globl vector135
vector135:
  pushl $0
  101980:	6a 00                	push   $0x0
  pushl $135
  101982:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  101987:	e9 24 f9 ff ff       	jmp    1012b0 <alltraps>

0010198c <vector136>:
.globl vector136
vector136:
  pushl $0
  10198c:	6a 00                	push   $0x0
  pushl $136
  10198e:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  101993:	e9 18 f9 ff ff       	jmp    1012b0 <alltraps>

00101998 <vector137>:
.globl vector137
vector137:
  pushl $0
  101998:	6a 00                	push   $0x0
  pushl $137
  10199a:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  10199f:	e9 0c f9 ff ff       	jmp    1012b0 <alltraps>

001019a4 <vector138>:
.globl vector138
vector138:
  pushl $0
  1019a4:	6a 00                	push   $0x0
  pushl $138
  1019a6:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  1019ab:	e9 00 f9 ff ff       	jmp    1012b0 <alltraps>

001019b0 <vector139>:
.globl vector139
vector139:
  pushl $0
  1019b0:	6a 00                	push   $0x0
  pushl $139
  1019b2:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  1019b7:	e9 f4 f8 ff ff       	jmp    1012b0 <alltraps>

001019bc <vector140>:
.globl vector140
vector140:
  pushl $0
  1019bc:	6a 00                	push   $0x0
  pushl $140
  1019be:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  1019c3:	e9 e8 f8 ff ff       	jmp    1012b0 <alltraps>

001019c8 <vector141>:
.globl vector141
vector141:
  pushl $0
  1019c8:	6a 00                	push   $0x0
  pushl $141
  1019ca:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  1019cf:	e9 dc f8 ff ff       	jmp    1012b0 <alltraps>

001019d4 <vector142>:
.globl vector142
vector142:
  pushl $0
  1019d4:	6a 00                	push   $0x0
  pushl $142
  1019d6:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  1019db:	e9 d0 f8 ff ff       	jmp    1012b0 <alltraps>

001019e0 <vector143>:
.globl vector143
vector143:
  pushl $0
  1019e0:	6a 00                	push   $0x0
  pushl $143
  1019e2:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  1019e7:	e9 c4 f8 ff ff       	jmp    1012b0 <alltraps>

001019ec <vector144>:
.globl vector144
vector144:
  pushl $0
  1019ec:	6a 00                	push   $0x0
  pushl $144
  1019ee:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  1019f3:	e9 b8 f8 ff ff       	jmp    1012b0 <alltraps>

001019f8 <vector145>:
.globl vector145
vector145:
  pushl $0
  1019f8:	6a 00                	push   $0x0
  pushl $145
  1019fa:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  1019ff:	e9 ac f8 ff ff       	jmp    1012b0 <alltraps>

00101a04 <vector146>:
.globl vector146
vector146:
  pushl $0
  101a04:	6a 00                	push   $0x0
  pushl $146
  101a06:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  101a0b:	e9 a0 f8 ff ff       	jmp    1012b0 <alltraps>

00101a10 <vector147>:
.globl vector147
vector147:
  pushl $0
  101a10:	6a 00                	push   $0x0
  pushl $147
  101a12:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  101a17:	e9 94 f8 ff ff       	jmp    1012b0 <alltraps>

00101a1c <vector148>:
.globl vector148
vector148:
  pushl $0
  101a1c:	6a 00                	push   $0x0
  pushl $148
  101a1e:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  101a23:	e9 88 f8 ff ff       	jmp    1012b0 <alltraps>

00101a28 <vector149>:
.globl vector149
vector149:
  pushl $0
  101a28:	6a 00                	push   $0x0
  pushl $149
  101a2a:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  101a2f:	e9 7c f8 ff ff       	jmp    1012b0 <alltraps>

00101a34 <vector150>:
.globl vector150
vector150:
  pushl $0
  101a34:	6a 00                	push   $0x0
  pushl $150
  101a36:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  101a3b:	e9 70 f8 ff ff       	jmp    1012b0 <alltraps>

00101a40 <vector151>:
.globl vector151
vector151:
  pushl $0
  101a40:	6a 00                	push   $0x0
  pushl $151
  101a42:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  101a47:	e9 64 f8 ff ff       	jmp    1012b0 <alltraps>

00101a4c <vector152>:
.globl vector152
vector152:
  pushl $0
  101a4c:	6a 00                	push   $0x0
  pushl $152
  101a4e:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  101a53:	e9 58 f8 ff ff       	jmp    1012b0 <alltraps>

00101a58 <vector153>:
.globl vector153
vector153:
  pushl $0
  101a58:	6a 00                	push   $0x0
  pushl $153
  101a5a:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  101a5f:	e9 4c f8 ff ff       	jmp    1012b0 <alltraps>

00101a64 <vector154>:
.globl vector154
vector154:
  pushl $0
  101a64:	6a 00                	push   $0x0
  pushl $154
  101a66:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  101a6b:	e9 40 f8 ff ff       	jmp    1012b0 <alltraps>

00101a70 <vector155>:
.globl vector155
vector155:
  pushl $0
  101a70:	6a 00                	push   $0x0
  pushl $155
  101a72:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  101a77:	e9 34 f8 ff ff       	jmp    1012b0 <alltraps>

00101a7c <vector156>:
.globl vector156
vector156:
  pushl $0
  101a7c:	6a 00                	push   $0x0
  pushl $156
  101a7e:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  101a83:	e9 28 f8 ff ff       	jmp    1012b0 <alltraps>

00101a88 <vector157>:
.globl vector157
vector157:
  pushl $0
  101a88:	6a 00                	push   $0x0
  pushl $157
  101a8a:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  101a8f:	e9 1c f8 ff ff       	jmp    1012b0 <alltraps>

00101a94 <vector158>:
.globl vector158
vector158:
  pushl $0
  101a94:	6a 00                	push   $0x0
  pushl $158
  101a96:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  101a9b:	e9 10 f8 ff ff       	jmp    1012b0 <alltraps>

00101aa0 <vector159>:
.globl vector159
vector159:
  pushl $0
  101aa0:	6a 00                	push   $0x0
  pushl $159
  101aa2:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  101aa7:	e9 04 f8 ff ff       	jmp    1012b0 <alltraps>

00101aac <vector160>:
.globl vector160
vector160:
  pushl $0
  101aac:	6a 00                	push   $0x0
  pushl $160
  101aae:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  101ab3:	e9 f8 f7 ff ff       	jmp    1012b0 <alltraps>

00101ab8 <vector161>:
.globl vector161
vector161:
  pushl $0
  101ab8:	6a 00                	push   $0x0
  pushl $161
  101aba:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  101abf:	e9 ec f7 ff ff       	jmp    1012b0 <alltraps>

00101ac4 <vector162>:
.globl vector162
vector162:
  pushl $0
  101ac4:	6a 00                	push   $0x0
  pushl $162
  101ac6:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  101acb:	e9 e0 f7 ff ff       	jmp    1012b0 <alltraps>

00101ad0 <vector163>:
.globl vector163
vector163:
  pushl $0
  101ad0:	6a 00                	push   $0x0
  pushl $163
  101ad2:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  101ad7:	e9 d4 f7 ff ff       	jmp    1012b0 <alltraps>

00101adc <vector164>:
.globl vector164
vector164:
  pushl $0
  101adc:	6a 00                	push   $0x0
  pushl $164
  101ade:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  101ae3:	e9 c8 f7 ff ff       	jmp    1012b0 <alltraps>

00101ae8 <vector165>:
.globl vector165
vector165:
  pushl $0
  101ae8:	6a 00                	push   $0x0
  pushl $165
  101aea:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  101aef:	e9 bc f7 ff ff       	jmp    1012b0 <alltraps>

00101af4 <vector166>:
.globl vector166
vector166:
  pushl $0
  101af4:	6a 00                	push   $0x0
  pushl $166
  101af6:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  101afb:	e9 b0 f7 ff ff       	jmp    1012b0 <alltraps>

00101b00 <vector167>:
.globl vector167
vector167:
  pushl $0
  101b00:	6a 00                	push   $0x0
  pushl $167
  101b02:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  101b07:	e9 a4 f7 ff ff       	jmp    1012b0 <alltraps>

00101b0c <vector168>:
.globl vector168
vector168:
  pushl $0
  101b0c:	6a 00                	push   $0x0
  pushl $168
  101b0e:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  101b13:	e9 98 f7 ff ff       	jmp    1012b0 <alltraps>

00101b18 <vector169>:
.globl vector169
vector169:
  pushl $0
  101b18:	6a 00                	push   $0x0
  pushl $169
  101b1a:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  101b1f:	e9 8c f7 ff ff       	jmp    1012b0 <alltraps>

00101b24 <vector170>:
.globl vector170
vector170:
  pushl $0
  101b24:	6a 00                	push   $0x0
  pushl $170
  101b26:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  101b2b:	e9 80 f7 ff ff       	jmp    1012b0 <alltraps>

00101b30 <vector171>:
.globl vector171
vector171:
  pushl $0
  101b30:	6a 00                	push   $0x0
  pushl $171
  101b32:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  101b37:	e9 74 f7 ff ff       	jmp    1012b0 <alltraps>

00101b3c <vector172>:
.globl vector172
vector172:
  pushl $0
  101b3c:	6a 00                	push   $0x0
  pushl $172
  101b3e:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  101b43:	e9 68 f7 ff ff       	jmp    1012b0 <alltraps>

00101b48 <vector173>:
.globl vector173
vector173:
  pushl $0
  101b48:	6a 00                	push   $0x0
  pushl $173
  101b4a:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  101b4f:	e9 5c f7 ff ff       	jmp    1012b0 <alltraps>

00101b54 <vector174>:
.globl vector174
vector174:
  pushl $0
  101b54:	6a 00                	push   $0x0
  pushl $174
  101b56:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  101b5b:	e9 50 f7 ff ff       	jmp    1012b0 <alltraps>

00101b60 <vector175>:
.globl vector175
vector175:
  pushl $0
  101b60:	6a 00                	push   $0x0
  pushl $175
  101b62:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  101b67:	e9 44 f7 ff ff       	jmp    1012b0 <alltraps>

00101b6c <vector176>:
.globl vector176
vector176:
  pushl $0
  101b6c:	6a 00                	push   $0x0
  pushl $176
  101b6e:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  101b73:	e9 38 f7 ff ff       	jmp    1012b0 <alltraps>

00101b78 <vector177>:
.globl vector177
vector177:
  pushl $0
  101b78:	6a 00                	push   $0x0
  pushl $177
  101b7a:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  101b7f:	e9 2c f7 ff ff       	jmp    1012b0 <alltraps>

00101b84 <vector178>:
.globl vector178
vector178:
  pushl $0
  101b84:	6a 00                	push   $0x0
  pushl $178
  101b86:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  101b8b:	e9 20 f7 ff ff       	jmp    1012b0 <alltraps>

00101b90 <vector179>:
.globl vector179
vector179:
  pushl $0
  101b90:	6a 00                	push   $0x0
  pushl $179
  101b92:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  101b97:	e9 14 f7 ff ff       	jmp    1012b0 <alltraps>

00101b9c <vector180>:
.globl vector180
vector180:
  pushl $0
  101b9c:	6a 00                	push   $0x0
  pushl $180
  101b9e:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  101ba3:	e9 08 f7 ff ff       	jmp    1012b0 <alltraps>

00101ba8 <vector181>:
.globl vector181
vector181:
  pushl $0
  101ba8:	6a 00                	push   $0x0
  pushl $181
  101baa:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  101baf:	e9 fc f6 ff ff       	jmp    1012b0 <alltraps>

00101bb4 <vector182>:
.globl vector182
vector182:
  pushl $0
  101bb4:	6a 00                	push   $0x0
  pushl $182
  101bb6:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  101bbb:	e9 f0 f6 ff ff       	jmp    1012b0 <alltraps>

00101bc0 <vector183>:
.globl vector183
vector183:
  pushl $0
  101bc0:	6a 00                	push   $0x0
  pushl $183
  101bc2:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  101bc7:	e9 e4 f6 ff ff       	jmp    1012b0 <alltraps>

00101bcc <vector184>:
.globl vector184
vector184:
  pushl $0
  101bcc:	6a 00                	push   $0x0
  pushl $184
  101bce:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  101bd3:	e9 d8 f6 ff ff       	jmp    1012b0 <alltraps>

00101bd8 <vector185>:
.globl vector185
vector185:
  pushl $0
  101bd8:	6a 00                	push   $0x0
  pushl $185
  101bda:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  101bdf:	e9 cc f6 ff ff       	jmp    1012b0 <alltraps>

00101be4 <vector186>:
.globl vector186
vector186:
  pushl $0
  101be4:	6a 00                	push   $0x0
  pushl $186
  101be6:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  101beb:	e9 c0 f6 ff ff       	jmp    1012b0 <alltraps>

00101bf0 <vector187>:
.globl vector187
vector187:
  pushl $0
  101bf0:	6a 00                	push   $0x0
  pushl $187
  101bf2:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  101bf7:	e9 b4 f6 ff ff       	jmp    1012b0 <alltraps>

00101bfc <vector188>:
.globl vector188
vector188:
  pushl $0
  101bfc:	6a 00                	push   $0x0
  pushl $188
  101bfe:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  101c03:	e9 a8 f6 ff ff       	jmp    1012b0 <alltraps>

00101c08 <vector189>:
.globl vector189
vector189:
  pushl $0
  101c08:	6a 00                	push   $0x0
  pushl $189
  101c0a:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  101c0f:	e9 9c f6 ff ff       	jmp    1012b0 <alltraps>

00101c14 <vector190>:
.globl vector190
vector190:
  pushl $0
  101c14:	6a 00                	push   $0x0
  pushl $190
  101c16:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  101c1b:	e9 90 f6 ff ff       	jmp    1012b0 <alltraps>

00101c20 <vector191>:
.globl vector191
vector191:
  pushl $0
  101c20:	6a 00                	push   $0x0
  pushl $191
  101c22:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  101c27:	e9 84 f6 ff ff       	jmp    1012b0 <alltraps>

00101c2c <vector192>:
.globl vector192
vector192:
  pushl $0
  101c2c:	6a 00                	push   $0x0
  pushl $192
  101c2e:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  101c33:	e9 78 f6 ff ff       	jmp    1012b0 <alltraps>

00101c38 <vector193>:
.globl vector193
vector193:
  pushl $0
  101c38:	6a 00                	push   $0x0
  pushl $193
  101c3a:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  101c3f:	e9 6c f6 ff ff       	jmp    1012b0 <alltraps>

00101c44 <vector194>:
.globl vector194
vector194:
  pushl $0
  101c44:	6a 00                	push   $0x0
  pushl $194
  101c46:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  101c4b:	e9 60 f6 ff ff       	jmp    1012b0 <alltraps>

00101c50 <vector195>:
.globl vector195
vector195:
  pushl $0
  101c50:	6a 00                	push   $0x0
  pushl $195
  101c52:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  101c57:	e9 54 f6 ff ff       	jmp    1012b0 <alltraps>

00101c5c <vector196>:
.globl vector196
vector196:
  pushl $0
  101c5c:	6a 00                	push   $0x0
  pushl $196
  101c5e:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  101c63:	e9 48 f6 ff ff       	jmp    1012b0 <alltraps>

00101c68 <vector197>:
.globl vector197
vector197:
  pushl $0
  101c68:	6a 00                	push   $0x0
  pushl $197
  101c6a:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  101c6f:	e9 3c f6 ff ff       	jmp    1012b0 <alltraps>

00101c74 <vector198>:
.globl vector198
vector198:
  pushl $0
  101c74:	6a 00                	push   $0x0
  pushl $198
  101c76:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  101c7b:	e9 30 f6 ff ff       	jmp    1012b0 <alltraps>

00101c80 <vector199>:
.globl vector199
vector199:
  pushl $0
  101c80:	6a 00                	push   $0x0
  pushl $199
  101c82:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  101c87:	e9 24 f6 ff ff       	jmp    1012b0 <alltraps>

00101c8c <vector200>:
.globl vector200
vector200:
  pushl $0
  101c8c:	6a 00                	push   $0x0
  pushl $200
  101c8e:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  101c93:	e9 18 f6 ff ff       	jmp    1012b0 <alltraps>

00101c98 <vector201>:
.globl vector201
vector201:
  pushl $0
  101c98:	6a 00                	push   $0x0
  pushl $201
  101c9a:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  101c9f:	e9 0c f6 ff ff       	jmp    1012b0 <alltraps>

00101ca4 <vector202>:
.globl vector202
vector202:
  pushl $0
  101ca4:	6a 00                	push   $0x0
  pushl $202
  101ca6:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  101cab:	e9 00 f6 ff ff       	jmp    1012b0 <alltraps>

00101cb0 <vector203>:
.globl vector203
vector203:
  pushl $0
  101cb0:	6a 00                	push   $0x0
  pushl $203
  101cb2:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  101cb7:	e9 f4 f5 ff ff       	jmp    1012b0 <alltraps>

00101cbc <vector204>:
.globl vector204
vector204:
  pushl $0
  101cbc:	6a 00                	push   $0x0
  pushl $204
  101cbe:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  101cc3:	e9 e8 f5 ff ff       	jmp    1012b0 <alltraps>

00101cc8 <vector205>:
.globl vector205
vector205:
  pushl $0
  101cc8:	6a 00                	push   $0x0
  pushl $205
  101cca:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  101ccf:	e9 dc f5 ff ff       	jmp    1012b0 <alltraps>

00101cd4 <vector206>:
.globl vector206
vector206:
  pushl $0
  101cd4:	6a 00                	push   $0x0
  pushl $206
  101cd6:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  101cdb:	e9 d0 f5 ff ff       	jmp    1012b0 <alltraps>

00101ce0 <vector207>:
.globl vector207
vector207:
  pushl $0
  101ce0:	6a 00                	push   $0x0
  pushl $207
  101ce2:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  101ce7:	e9 c4 f5 ff ff       	jmp    1012b0 <alltraps>

00101cec <vector208>:
.globl vector208
vector208:
  pushl $0
  101cec:	6a 00                	push   $0x0
  pushl $208
  101cee:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  101cf3:	e9 b8 f5 ff ff       	jmp    1012b0 <alltraps>

00101cf8 <vector209>:
.globl vector209
vector209:
  pushl $0
  101cf8:	6a 00                	push   $0x0
  pushl $209
  101cfa:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  101cff:	e9 ac f5 ff ff       	jmp    1012b0 <alltraps>

00101d04 <vector210>:
.globl vector210
vector210:
  pushl $0
  101d04:	6a 00                	push   $0x0
  pushl $210
  101d06:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  101d0b:	e9 a0 f5 ff ff       	jmp    1012b0 <alltraps>

00101d10 <vector211>:
.globl vector211
vector211:
  pushl $0
  101d10:	6a 00                	push   $0x0
  pushl $211
  101d12:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  101d17:	e9 94 f5 ff ff       	jmp    1012b0 <alltraps>

00101d1c <vector212>:
.globl vector212
vector212:
  pushl $0
  101d1c:	6a 00                	push   $0x0
  pushl $212
  101d1e:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  101d23:	e9 88 f5 ff ff       	jmp    1012b0 <alltraps>

00101d28 <vector213>:
.globl vector213
vector213:
  pushl $0
  101d28:	6a 00                	push   $0x0
  pushl $213
  101d2a:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  101d2f:	e9 7c f5 ff ff       	jmp    1012b0 <alltraps>

00101d34 <vector214>:
.globl vector214
vector214:
  pushl $0
  101d34:	6a 00                	push   $0x0
  pushl $214
  101d36:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  101d3b:	e9 70 f5 ff ff       	jmp    1012b0 <alltraps>

00101d40 <vector215>:
.globl vector215
vector215:
  pushl $0
  101d40:	6a 00                	push   $0x0
  pushl $215
  101d42:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  101d47:	e9 64 f5 ff ff       	jmp    1012b0 <alltraps>

00101d4c <vector216>:
.globl vector216
vector216:
  pushl $0
  101d4c:	6a 00                	push   $0x0
  pushl $216
  101d4e:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  101d53:	e9 58 f5 ff ff       	jmp    1012b0 <alltraps>

00101d58 <vector217>:
.globl vector217
vector217:
  pushl $0
  101d58:	6a 00                	push   $0x0
  pushl $217
  101d5a:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  101d5f:	e9 4c f5 ff ff       	jmp    1012b0 <alltraps>

00101d64 <vector218>:
.globl vector218
vector218:
  pushl $0
  101d64:	6a 00                	push   $0x0
  pushl $218
  101d66:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  101d6b:	e9 40 f5 ff ff       	jmp    1012b0 <alltraps>

00101d70 <vector219>:
.globl vector219
vector219:
  pushl $0
  101d70:	6a 00                	push   $0x0
  pushl $219
  101d72:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  101d77:	e9 34 f5 ff ff       	jmp    1012b0 <alltraps>

00101d7c <vector220>:
.globl vector220
vector220:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $220
  101d7e:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  101d83:	e9 28 f5 ff ff       	jmp    1012b0 <alltraps>

00101d88 <vector221>:
.globl vector221
vector221:
  pushl $0
  101d88:	6a 00                	push   $0x0
  pushl $221
  101d8a:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  101d8f:	e9 1c f5 ff ff       	jmp    1012b0 <alltraps>

00101d94 <vector222>:
.globl vector222
vector222:
  pushl $0
  101d94:	6a 00                	push   $0x0
  pushl $222
  101d96:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  101d9b:	e9 10 f5 ff ff       	jmp    1012b0 <alltraps>

00101da0 <vector223>:
.globl vector223
vector223:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $223
  101da2:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  101da7:	e9 04 f5 ff ff       	jmp    1012b0 <alltraps>

00101dac <vector224>:
.globl vector224
vector224:
  pushl $0
  101dac:	6a 00                	push   $0x0
  pushl $224
  101dae:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  101db3:	e9 f8 f4 ff ff       	jmp    1012b0 <alltraps>

00101db8 <vector225>:
.globl vector225
vector225:
  pushl $0
  101db8:	6a 00                	push   $0x0
  pushl $225
  101dba:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  101dbf:	e9 ec f4 ff ff       	jmp    1012b0 <alltraps>

00101dc4 <vector226>:
.globl vector226
vector226:
  pushl $0
  101dc4:	6a 00                	push   $0x0
  pushl $226
  101dc6:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  101dcb:	e9 e0 f4 ff ff       	jmp    1012b0 <alltraps>

00101dd0 <vector227>:
.globl vector227
vector227:
  pushl $0
  101dd0:	6a 00                	push   $0x0
  pushl $227
  101dd2:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  101dd7:	e9 d4 f4 ff ff       	jmp    1012b0 <alltraps>

00101ddc <vector228>:
.globl vector228
vector228:
  pushl $0
  101ddc:	6a 00                	push   $0x0
  pushl $228
  101dde:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  101de3:	e9 c8 f4 ff ff       	jmp    1012b0 <alltraps>

00101de8 <vector229>:
.globl vector229
vector229:
  pushl $0
  101de8:	6a 00                	push   $0x0
  pushl $229
  101dea:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  101def:	e9 bc f4 ff ff       	jmp    1012b0 <alltraps>

00101df4 <vector230>:
.globl vector230
vector230:
  pushl $0
  101df4:	6a 00                	push   $0x0
  pushl $230
  101df6:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  101dfb:	e9 b0 f4 ff ff       	jmp    1012b0 <alltraps>

00101e00 <vector231>:
.globl vector231
vector231:
  pushl $0
  101e00:	6a 00                	push   $0x0
  pushl $231
  101e02:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  101e07:	e9 a4 f4 ff ff       	jmp    1012b0 <alltraps>

00101e0c <vector232>:
.globl vector232
vector232:
  pushl $0
  101e0c:	6a 00                	push   $0x0
  pushl $232
  101e0e:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  101e13:	e9 98 f4 ff ff       	jmp    1012b0 <alltraps>

00101e18 <vector233>:
.globl vector233
vector233:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $233
  101e1a:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  101e1f:	e9 8c f4 ff ff       	jmp    1012b0 <alltraps>

00101e24 <vector234>:
.globl vector234
vector234:
  pushl $0
  101e24:	6a 00                	push   $0x0
  pushl $234
  101e26:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  101e2b:	e9 80 f4 ff ff       	jmp    1012b0 <alltraps>

00101e30 <vector235>:
.globl vector235
vector235:
  pushl $0
  101e30:	6a 00                	push   $0x0
  pushl $235
  101e32:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  101e37:	e9 74 f4 ff ff       	jmp    1012b0 <alltraps>

00101e3c <vector236>:
.globl vector236
vector236:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $236
  101e3e:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  101e43:	e9 68 f4 ff ff       	jmp    1012b0 <alltraps>

00101e48 <vector237>:
.globl vector237
vector237:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $237
  101e4a:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  101e4f:	e9 5c f4 ff ff       	jmp    1012b0 <alltraps>

00101e54 <vector238>:
.globl vector238
vector238:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $238
  101e56:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  101e5b:	e9 50 f4 ff ff       	jmp    1012b0 <alltraps>

00101e60 <vector239>:
.globl vector239
vector239:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $239
  101e62:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  101e67:	e9 44 f4 ff ff       	jmp    1012b0 <alltraps>

00101e6c <vector240>:
.globl vector240
vector240:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $240
  101e6e:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  101e73:	e9 38 f4 ff ff       	jmp    1012b0 <alltraps>

00101e78 <vector241>:
.globl vector241
vector241:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $241
  101e7a:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  101e7f:	e9 2c f4 ff ff       	jmp    1012b0 <alltraps>

00101e84 <vector242>:
.globl vector242
vector242:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $242
  101e86:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  101e8b:	e9 20 f4 ff ff       	jmp    1012b0 <alltraps>

00101e90 <vector243>:
.globl vector243
vector243:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $243
  101e92:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  101e97:	e9 14 f4 ff ff       	jmp    1012b0 <alltraps>

00101e9c <vector244>:
.globl vector244
vector244:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $244
  101e9e:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  101ea3:	e9 08 f4 ff ff       	jmp    1012b0 <alltraps>

00101ea8 <vector245>:
.globl vector245
vector245:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $245
  101eaa:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  101eaf:	e9 fc f3 ff ff       	jmp    1012b0 <alltraps>

00101eb4 <vector246>:
.globl vector246
vector246:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $246
  101eb6:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  101ebb:	e9 f0 f3 ff ff       	jmp    1012b0 <alltraps>

00101ec0 <vector247>:
.globl vector247
vector247:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $247
  101ec2:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  101ec7:	e9 e4 f3 ff ff       	jmp    1012b0 <alltraps>

00101ecc <vector248>:
.globl vector248
vector248:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $248
  101ece:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  101ed3:	e9 d8 f3 ff ff       	jmp    1012b0 <alltraps>

00101ed8 <vector249>:
.globl vector249
vector249:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $249
  101eda:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  101edf:	e9 cc f3 ff ff       	jmp    1012b0 <alltraps>

00101ee4 <vector250>:
.globl vector250
vector250:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $250
  101ee6:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  101eeb:	e9 c0 f3 ff ff       	jmp    1012b0 <alltraps>

00101ef0 <vector251>:
.globl vector251
vector251:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $251
  101ef2:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  101ef7:	e9 b4 f3 ff ff       	jmp    1012b0 <alltraps>

00101efc <vector252>:
.globl vector252
vector252:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $252
  101efe:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  101f03:	e9 a8 f3 ff ff       	jmp    1012b0 <alltraps>

00101f08 <vector253>:
.globl vector253
vector253:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $253
  101f0a:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  101f0f:	e9 9c f3 ff ff       	jmp    1012b0 <alltraps>

00101f14 <vector254>:
.globl vector254
vector254:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $254
  101f16:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  101f1b:	e9 90 f3 ff ff       	jmp    1012b0 <alltraps>

00101f20 <vector255>:
.globl vector255
vector255:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $255
  101f22:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  101f27:	e9 84 f3 ff ff       	jmp    1012b0 <alltraps>

00101f2c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
  101f2c:	f3 0f 1e fb          	endbr32 
  101f30:	55                   	push   %ebp
  101f31:	89 e5                	mov    %esp,%ebp
  101f33:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  101f36:	c7 05 78 ac 10 00 68 	movl   $0x10ac68,0x10ac78
  101f3d:	ac 10 00 
  bcache.head.next = &bcache.head;
  101f40:	c7 05 7c ac 10 00 68 	movl   $0x10ac68,0x10ac7c
  101f47:	ac 10 00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  101f4a:	c7 45 fc 20 6d 10 00 	movl   $0x106d20,-0x4(%ebp)
  101f51:	eb 30                	jmp    101f83 <binit+0x57>
    b->next = bcache.head.next;
  101f53:	8b 15 7c ac 10 00    	mov    0x10ac7c,%edx
  101f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101f5c:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  101f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101f62:	c7 40 10 68 ac 10 00 	movl   $0x10ac68,0x10(%eax)
    bcache.head.next->prev = b;
  101f69:	a1 7c ac 10 00       	mov    0x10ac7c,%eax
  101f6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101f71:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  101f74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101f77:	a3 7c ac 10 00       	mov    %eax,0x10ac7c
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  101f7c:	81 45 fc 1c 02 00 00 	addl   $0x21c,-0x4(%ebp)
  101f83:	b8 68 ac 10 00       	mov    $0x10ac68,%eax
  101f88:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  101f8b:	72 c6                	jb     101f53 <binit+0x27>
  }
}
  101f8d:	90                   	nop
  101f8e:	90                   	nop
  101f8f:	c9                   	leave  
  101f90:	c3                   	ret    

00101f91 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  101f91:	f3 0f 1e fb          	endbr32 
  101f95:	55                   	push   %ebp
  101f96:	89 e5                	mov    %esp,%ebp
  101f98:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  101f9b:	a1 7c ac 10 00       	mov    0x10ac7c,%eax
  101fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101fa3:	eb 33                	jmp    101fd8 <bget+0x47>
    if(b->dev == dev && b->blockno == blockno){
  101fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fa8:	8b 40 04             	mov    0x4(%eax),%eax
  101fab:	39 45 08             	cmp    %eax,0x8(%ebp)
  101fae:	75 1f                	jne    101fcf <bget+0x3e>
  101fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fb3:	8b 40 08             	mov    0x8(%eax),%eax
  101fb6:	39 45 0c             	cmp    %eax,0xc(%ebp)
  101fb9:	75 14                	jne    101fcf <bget+0x3e>
      b->refcnt++;
  101fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  101fc1:	8d 50 01             	lea    0x1(%eax),%edx
  101fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fc7:	89 50 0c             	mov    %edx,0xc(%eax)
      return b;
  101fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fcd:	eb 7b                	jmp    10204a <bget+0xb9>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  101fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fd2:	8b 40 14             	mov    0x14(%eax),%eax
  101fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101fd8:	81 7d f4 68 ac 10 00 	cmpl   $0x10ac68,-0xc(%ebp)
  101fdf:	75 c4                	jne    101fa5 <bget+0x14>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  101fe1:	a1 78 ac 10 00       	mov    0x10ac78,%eax
  101fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101fe9:	eb 49                	jmp    102034 <bget+0xa3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
  101feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fee:	8b 40 0c             	mov    0xc(%eax),%eax
  101ff1:	85 c0                	test   %eax,%eax
  101ff3:	75 36                	jne    10202b <bget+0x9a>
  101ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ff8:	8b 00                	mov    (%eax),%eax
  101ffa:	83 e0 04             	and    $0x4,%eax
  101ffd:	85 c0                	test   %eax,%eax
  101fff:	75 2a                	jne    10202b <bget+0x9a>
      b->dev = dev;
  102001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102004:	8b 55 08             	mov    0x8(%ebp),%edx
  102007:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
  10200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10200d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102010:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
  102013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
  10201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10201f:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
      return b;
  102026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102029:	eb 1f                	jmp    10204a <bget+0xb9>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  10202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10202e:	8b 40 10             	mov    0x10(%eax),%eax
  102031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102034:	81 7d f4 68 ac 10 00 	cmpl   $0x10ac68,-0xc(%ebp)
  10203b:	75 ae                	jne    101feb <bget+0x5a>
    }
  }
  panic("bget: no buffers");
  10203d:	83 ec 0c             	sub    $0xc,%esp
  102040:	68 34 43 10 00       	push   $0x104334
  102045:	e8 6f e2 ff ff       	call   1002b9 <panic>
}
  10204a:	c9                   	leave  
  10204b:	c3                   	ret    

0010204c <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  10204c:	f3 0f 1e fb          	endbr32 
  102050:	55                   	push   %ebp
  102051:	89 e5                	mov    %esp,%ebp
  102053:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
  102056:	83 ec 08             	sub    $0x8,%esp
  102059:	ff 75 0c             	pushl  0xc(%ebp)
  10205c:	ff 75 08             	pushl  0x8(%ebp)
  10205f:	e8 2d ff ff ff       	call   101f91 <bget>
  102064:	83 c4 10             	add    $0x10,%esp
  102067:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
  10206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10206d:	8b 00                	mov    (%eax),%eax
  10206f:	83 e0 02             	and    $0x2,%eax
  102072:	85 c0                	test   %eax,%eax
  102074:	75 0e                	jne    102084 <bread+0x38>
    iderw(b);
  102076:	83 ec 0c             	sub    $0xc,%esp
  102079:	ff 75 f4             	pushl  -0xc(%ebp)
  10207c:	e8 7a 04 00 00       	call   1024fb <iderw>
  102081:	83 c4 10             	add    $0x10,%esp
  }
  return b;
  102084:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102087:	c9                   	leave  
  102088:	c3                   	ret    

00102089 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  102089:	f3 0f 1e fb          	endbr32 
  10208d:	55                   	push   %ebp
  10208e:	89 e5                	mov    %esp,%ebp
  102090:	83 ec 08             	sub    $0x8,%esp
  b->flags |= B_DIRTY;
  102093:	8b 45 08             	mov    0x8(%ebp),%eax
  102096:	8b 00                	mov    (%eax),%eax
  102098:	83 c8 04             	or     $0x4,%eax
  10209b:	89 c2                	mov    %eax,%edx
  10209d:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a0:	89 10                	mov    %edx,(%eax)
  iderw(b);
  1020a2:	83 ec 0c             	sub    $0xc,%esp
  1020a5:	ff 75 08             	pushl  0x8(%ebp)
  1020a8:	e8 4e 04 00 00       	call   1024fb <iderw>
  1020ad:	83 c4 10             	add    $0x10,%esp
}
  1020b0:	90                   	nop
  1020b1:	c9                   	leave  
  1020b2:	c3                   	ret    

001020b3 <bread_wr>:

struct buf* 
bread_wr(uint dev, uint blockno) {
  1020b3:	f3 0f 1e fb          	endbr32 
  1020b7:	55                   	push   %ebp
  1020b8:	89 e5                	mov    %esp,%ebp
  1020ba:	83 ec 18             	sub    $0x18,%esp
  // IMPLEMENT YOUR CODE HERE
  // same as bread
  struct buf *b;
  b = bget(dev, blockno);
  1020bd:	83 ec 08             	sub    $0x8,%esp
  1020c0:	ff 75 0c             	pushl  0xc(%ebp)
  1020c3:	ff 75 08             	pushl  0x8(%ebp)
  1020c6:	e8 c6 fe ff ff       	call   101f91 <bget>
  1020cb:	83 c4 10             	add    $0x10,%esp
  1020ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
  1020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1020d4:	8b 00                	mov    (%eax),%eax
  1020d6:	83 e0 02             	and    $0x2,%eax
  1020d9:	85 c0                	test   %eax,%eax
  1020db:	75 0e                	jne    1020eb <bread_wr+0x38>
    iderw(b);
  1020dd:	83 ec 0c             	sub    $0xc,%esp
  1020e0:	ff 75 f4             	pushl  -0xc(%ebp)
  1020e3:	e8 13 04 00 00       	call   1024fb <iderw>
  1020e8:	83 c4 10             	add    $0x10,%esp
  }
  our_bread(b);
  1020eb:	83 ec 0c             	sub    $0xc,%esp
  1020ee:	ff 75 f4             	pushl  -0xc(%ebp)
  1020f1:	e8 98 1f 00 00       	call   10408e <our_bread>
  1020f6:	83 c4 10             	add    $0x10,%esp

  return b;
  1020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1020fc:	c9                   	leave  
  1020fd:	c3                   	ret    

001020fe <brelse>:

// Release a buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  1020fe:	f3 0f 1e fb          	endbr32 
  102102:	55                   	push   %ebp
  102103:	89 e5                	mov    %esp,%ebp
  b->refcnt--;
  102105:	8b 45 08             	mov    0x8(%ebp),%eax
  102108:	8b 40 0c             	mov    0xc(%eax),%eax
  10210b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10210e:	8b 45 08             	mov    0x8(%ebp),%eax
  102111:	89 50 0c             	mov    %edx,0xc(%eax)
  if (b->refcnt == 0) {
  102114:	8b 45 08             	mov    0x8(%ebp),%eax
  102117:	8b 40 0c             	mov    0xc(%eax),%eax
  10211a:	85 c0                	test   %eax,%eax
  10211c:	75 47                	jne    102165 <brelse+0x67>
    // no one is waiting for it.
    b->next->prev = b->prev;
  10211e:	8b 45 08             	mov    0x8(%ebp),%eax
  102121:	8b 40 14             	mov    0x14(%eax),%eax
  102124:	8b 55 08             	mov    0x8(%ebp),%edx
  102127:	8b 52 10             	mov    0x10(%edx),%edx
  10212a:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev->next = b->next;
  10212d:	8b 45 08             	mov    0x8(%ebp),%eax
  102130:	8b 40 10             	mov    0x10(%eax),%eax
  102133:	8b 55 08             	mov    0x8(%ebp),%edx
  102136:	8b 52 14             	mov    0x14(%edx),%edx
  102139:	89 50 14             	mov    %edx,0x14(%eax)
    b->next = bcache.head.next;
  10213c:	8b 15 7c ac 10 00    	mov    0x10ac7c,%edx
  102142:	8b 45 08             	mov    0x8(%ebp),%eax
  102145:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  102148:	8b 45 08             	mov    0x8(%ebp),%eax
  10214b:	c7 40 10 68 ac 10 00 	movl   $0x10ac68,0x10(%eax)
    bcache.head.next->prev = b;
  102152:	a1 7c ac 10 00       	mov    0x10ac7c,%eax
  102157:	8b 55 08             	mov    0x8(%ebp),%edx
  10215a:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  10215d:	8b 45 08             	mov    0x8(%ebp),%eax
  102160:	a3 7c ac 10 00       	mov    %eax,0x10ac7c
  }
  102165:	90                   	nop
  102166:	5d                   	pop    %ebp
  102167:	c3                   	ret    

00102168 <inb>:
{
  102168:	55                   	push   %ebp
  102169:	89 e5                	mov    %esp,%ebp
  10216b:	83 ec 14             	sub    $0x14,%esp
  10216e:	8b 45 08             	mov    0x8(%ebp),%eax
  102171:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102175:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  102179:	89 c2                	mov    %eax,%edx
  10217b:	ec                   	in     (%dx),%al
  10217c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  10217f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  102183:	c9                   	leave  
  102184:	c3                   	ret    

00102185 <insl>:
{
  102185:	55                   	push   %ebp
  102186:	89 e5                	mov    %esp,%ebp
  102188:	57                   	push   %edi
  102189:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
  10218a:	8b 55 08             	mov    0x8(%ebp),%edx
  10218d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102190:	8b 45 10             	mov    0x10(%ebp),%eax
  102193:	89 cb                	mov    %ecx,%ebx
  102195:	89 df                	mov    %ebx,%edi
  102197:	89 c1                	mov    %eax,%ecx
  102199:	fc                   	cld    
  10219a:	f3 6d                	rep insl (%dx),%es:(%edi)
  10219c:	89 c8                	mov    %ecx,%eax
  10219e:	89 fb                	mov    %edi,%ebx
  1021a0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1021a3:	89 45 10             	mov    %eax,0x10(%ebp)
}
  1021a6:	90                   	nop
  1021a7:	5b                   	pop    %ebx
  1021a8:	5f                   	pop    %edi
  1021a9:	5d                   	pop    %ebp
  1021aa:	c3                   	ret    

001021ab <outb>:
{
  1021ab:	55                   	push   %ebp
  1021ac:	89 e5                	mov    %esp,%ebp
  1021ae:	83 ec 08             	sub    $0x8,%esp
  1021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1021b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1021b7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  1021bb:	89 d0                	mov    %edx,%eax
  1021bd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1021c0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  1021c4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1021c8:	ee                   	out    %al,(%dx)
}
  1021c9:	90                   	nop
  1021ca:	c9                   	leave  
  1021cb:	c3                   	ret    

001021cc <outsl>:
{
  1021cc:	55                   	push   %ebp
  1021cd:	89 e5                	mov    %esp,%ebp
  1021cf:	56                   	push   %esi
  1021d0:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
  1021d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1021d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1021d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1021da:	89 cb                	mov    %ecx,%ebx
  1021dc:	89 de                	mov    %ebx,%esi
  1021de:	89 c1                	mov    %eax,%ecx
  1021e0:	fc                   	cld    
  1021e1:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  1021e3:	89 c8                	mov    %ecx,%eax
  1021e5:	89 f3                	mov    %esi,%ebx
  1021e7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1021ea:	89 45 10             	mov    %eax,0x10(%ebp)
}
  1021ed:	90                   	nop
  1021ee:	5b                   	pop    %ebx
  1021ef:	5e                   	pop    %esi
  1021f0:	5d                   	pop    %ebp
  1021f1:	c3                   	ret    

001021f2 <noop>:

static inline void
noop(void)
{
  1021f2:	55                   	push   %ebp
  1021f3:	89 e5                	mov    %esp,%ebp
  asm volatile("nop");
  1021f5:	90                   	nop
}
  1021f6:	90                   	nop
  1021f7:	5d                   	pop    %ebp
  1021f8:	c3                   	ret    

001021f9 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
  1021f9:	f3 0f 1e fb          	endbr32 
  1021fd:	55                   	push   %ebp
  1021fe:	89 e5                	mov    %esp,%ebp
  102200:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY);
  102203:	90                   	nop
  102204:	68 f7 01 00 00       	push   $0x1f7
  102209:	e8 5a ff ff ff       	call   102168 <inb>
  10220e:	83 c4 04             	add    $0x4,%esp
  102211:	0f b6 c0             	movzbl %al,%eax
  102214:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102217:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10221a:	25 c0 00 00 00       	and    $0xc0,%eax
  10221f:	83 f8 40             	cmp    $0x40,%eax
  102222:	75 e0                	jne    102204 <idewait+0xb>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
  102224:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102228:	74 11                	je     10223b <idewait+0x42>
  10222a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10222d:	83 e0 21             	and    $0x21,%eax
  102230:	85 c0                	test   %eax,%eax
  102232:	74 07                	je     10223b <idewait+0x42>
    return -1;
  102234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102239:	eb 05                	jmp    102240 <idewait+0x47>
  return 0;
  10223b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102240:	c9                   	leave  
  102241:	c3                   	ret    

00102242 <ideinit>:

void
ideinit(void)
{
  102242:	f3 0f 1e fb          	endbr32 
  102246:	55                   	push   %ebp
  102247:	89 e5                	mov    %esp,%ebp
  102249:	83 ec 18             	sub    $0x18,%esp
  int i;

  // initlock(&idelock, "ide");
  ioapicenable(IRQ_IDE, ncpu - 1);
  10224c:	a1 e0 64 10 00       	mov    0x1064e0,%eax
  102251:	83 e8 01             	sub    $0x1,%eax
  102254:	83 ec 08             	sub    $0x8,%esp
  102257:	50                   	push   %eax
  102258:	6a 0e                	push   $0xe
  10225a:	e8 5c e3 ff ff       	call   1005bb <ioapicenable>
  10225f:	83 c4 10             	add    $0x10,%esp
  idewait(0);
  102262:	83 ec 0c             	sub    $0xc,%esp
  102265:	6a 00                	push   $0x0
  102267:	e8 8d ff ff ff       	call   1021f9 <idewait>
  10226c:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  10226f:	83 ec 08             	sub    $0x8,%esp
  102272:	68 f0 00 00 00       	push   $0xf0
  102277:	68 f6 01 00 00       	push   $0x1f6
  10227c:	e8 2a ff ff ff       	call   1021ab <outb>
  102281:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
  102284:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10228b:	eb 24                	jmp    1022b1 <ideinit+0x6f>
    if(inb(0x1f7) != 0){
  10228d:	83 ec 0c             	sub    $0xc,%esp
  102290:	68 f7 01 00 00       	push   $0x1f7
  102295:	e8 ce fe ff ff       	call   102168 <inb>
  10229a:	83 c4 10             	add    $0x10,%esp
  10229d:	84 c0                	test   %al,%al
  10229f:	74 0c                	je     1022ad <ideinit+0x6b>
      havedisk1 = 1;
  1022a1:	c7 05 2c 54 10 00 01 	movl   $0x1,0x10542c
  1022a8:	00 00 00 
      break;
  1022ab:	eb 0d                	jmp    1022ba <ideinit+0x78>
  for(i=0; i<1000; i++){
  1022ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1022b1:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  1022b8:	7e d3                	jle    10228d <ideinit+0x4b>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
  1022ba:	83 ec 08             	sub    $0x8,%esp
  1022bd:	68 e0 00 00 00       	push   $0xe0
  1022c2:	68 f6 01 00 00       	push   $0x1f6
  1022c7:	e8 df fe ff ff       	call   1021ab <outb>
  1022cc:	83 c4 10             	add    $0x10,%esp
}
  1022cf:	90                   	nop
  1022d0:	c9                   	leave  
  1022d1:	c3                   	ret    

001022d2 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  1022d2:	f3 0f 1e fb          	endbr32 
  1022d6:	55                   	push   %ebp
  1022d7:	89 e5                	mov    %esp,%ebp
  1022d9:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
  1022dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1022e0:	75 0d                	jne    1022ef <idestart+0x1d>
    panic("idestart");
  1022e2:	83 ec 0c             	sub    $0xc,%esp
  1022e5:	68 45 43 10 00       	push   $0x104345
  1022ea:	e8 ca df ff ff       	call   1002b9 <panic>
  if(b->blockno >= FSSIZE)
  1022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1022f2:	8b 40 08             	mov    0x8(%eax),%eax
  1022f5:	3d e7 03 00 00       	cmp    $0x3e7,%eax
  1022fa:	76 0d                	jbe    102309 <idestart+0x37>
    panic("incorrect blockno");
  1022fc:	83 ec 0c             	sub    $0xc,%esp
  1022ff:	68 4e 43 10 00       	push   $0x10434e
  102304:	e8 b0 df ff ff       	call   1002b9 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
  102309:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
  102310:	8b 45 08             	mov    0x8(%ebp),%eax
  102313:	8b 50 08             	mov    0x8(%eax),%edx
  102316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102319:	0f af c2             	imul   %edx,%eax
  10231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  10231f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102323:	75 07                	jne    10232c <idestart+0x5a>
  102325:	b8 20 00 00 00       	mov    $0x20,%eax
  10232a:	eb 05                	jmp    102331 <idestart+0x5f>
  10232c:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102331:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
  102334:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102338:	75 07                	jne    102341 <idestart+0x6f>
  10233a:	b8 30 00 00 00       	mov    $0x30,%eax
  10233f:	eb 05                	jmp    102346 <idestart+0x74>
  102341:	b8 c5 00 00 00       	mov    $0xc5,%eax
  102346:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
  102349:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
  10234d:	7e 0d                	jle    10235c <idestart+0x8a>
  10234f:	83 ec 0c             	sub    $0xc,%esp
  102352:	68 45 43 10 00       	push   $0x104345
  102357:	e8 5d df ff ff       	call   1002b9 <panic>

  idewait(0);
  10235c:	83 ec 0c             	sub    $0xc,%esp
  10235f:	6a 00                	push   $0x0
  102361:	e8 93 fe ff ff       	call   1021f9 <idewait>
  102366:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
  102369:	83 ec 08             	sub    $0x8,%esp
  10236c:	6a 00                	push   $0x0
  10236e:	68 f6 03 00 00       	push   $0x3f6
  102373:	e8 33 fe ff ff       	call   1021ab <outb>
  102378:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
  10237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10237e:	0f b6 c0             	movzbl %al,%eax
  102381:	83 ec 08             	sub    $0x8,%esp
  102384:	50                   	push   %eax
  102385:	68 f2 01 00 00       	push   $0x1f2
  10238a:	e8 1c fe ff ff       	call   1021ab <outb>
  10238f:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
  102392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102395:	0f b6 c0             	movzbl %al,%eax
  102398:	83 ec 08             	sub    $0x8,%esp
  10239b:	50                   	push   %eax
  10239c:	68 f3 01 00 00       	push   $0x1f3
  1023a1:	e8 05 fe ff ff       	call   1021ab <outb>
  1023a6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
  1023a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1023ac:	c1 f8 08             	sar    $0x8,%eax
  1023af:	0f b6 c0             	movzbl %al,%eax
  1023b2:	83 ec 08             	sub    $0x8,%esp
  1023b5:	50                   	push   %eax
  1023b6:	68 f4 01 00 00       	push   $0x1f4
  1023bb:	e8 eb fd ff ff       	call   1021ab <outb>
  1023c0:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
  1023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1023c6:	c1 f8 10             	sar    $0x10,%eax
  1023c9:	0f b6 c0             	movzbl %al,%eax
  1023cc:	83 ec 08             	sub    $0x8,%esp
  1023cf:	50                   	push   %eax
  1023d0:	68 f5 01 00 00       	push   $0x1f5
  1023d5:	e8 d1 fd ff ff       	call   1021ab <outb>
  1023da:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  1023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1023e0:	8b 40 04             	mov    0x4(%eax),%eax
  1023e3:	c1 e0 04             	shl    $0x4,%eax
  1023e6:	83 e0 10             	and    $0x10,%eax
  1023e9:	89 c2                	mov    %eax,%edx
  1023eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1023ee:	c1 f8 18             	sar    $0x18,%eax
  1023f1:	83 e0 0f             	and    $0xf,%eax
  1023f4:	09 d0                	or     %edx,%eax
  1023f6:	83 c8 e0             	or     $0xffffffe0,%eax
  1023f9:	0f b6 c0             	movzbl %al,%eax
  1023fc:	83 ec 08             	sub    $0x8,%esp
  1023ff:	50                   	push   %eax
  102400:	68 f6 01 00 00       	push   $0x1f6
  102405:	e8 a1 fd ff ff       	call   1021ab <outb>
  10240a:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
  10240d:	8b 45 08             	mov    0x8(%ebp),%eax
  102410:	8b 00                	mov    (%eax),%eax
  102412:	83 e0 04             	and    $0x4,%eax
  102415:	85 c0                	test   %eax,%eax
  102417:	74 35                	je     10244e <idestart+0x17c>
    outb(0x1f7, write_cmd);
  102419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10241c:	0f b6 c0             	movzbl %al,%eax
  10241f:	83 ec 08             	sub    $0x8,%esp
  102422:	50                   	push   %eax
  102423:	68 f7 01 00 00       	push   $0x1f7
  102428:	e8 7e fd ff ff       	call   1021ab <outb>
  10242d:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
  102430:	8b 45 08             	mov    0x8(%ebp),%eax
  102433:	83 c0 1c             	add    $0x1c,%eax
  102436:	83 ec 04             	sub    $0x4,%esp
  102439:	68 80 00 00 00       	push   $0x80
  10243e:	50                   	push   %eax
  10243f:	68 f0 01 00 00       	push   $0x1f0
  102444:	e8 83 fd ff ff       	call   1021cc <outsl>
  102449:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
  10244c:	eb 17                	jmp    102465 <idestart+0x193>
    outb(0x1f7, read_cmd);
  10244e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102451:	0f b6 c0             	movzbl %al,%eax
  102454:	83 ec 08             	sub    $0x8,%esp
  102457:	50                   	push   %eax
  102458:	68 f7 01 00 00       	push   $0x1f7
  10245d:	e8 49 fd ff ff       	call   1021ab <outb>
  102462:	83 c4 10             	add    $0x10,%esp
}
  102465:	90                   	nop
  102466:	c9                   	leave  
  102467:	c3                   	ret    

00102468 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
  102468:	f3 0f 1e fb          	endbr32 
  10246c:	55                   	push   %ebp
  10246d:	89 e5                	mov    %esp,%ebp
  10246f:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  if((b = idequeue) == 0){
  102472:	a1 28 54 10 00       	mov    0x105428,%eax
  102477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10247a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10247e:	74 78                	je     1024f8 <ideintr+0x90>
    return;
  }
  idequeue = b->qnext;
  102480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102483:	8b 40 18             	mov    0x18(%eax),%eax
  102486:	a3 28 54 10 00       	mov    %eax,0x105428

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
  10248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10248e:	8b 00                	mov    (%eax),%eax
  102490:	83 e0 04             	and    $0x4,%eax
  102493:	85 c0                	test   %eax,%eax
  102495:	75 27                	jne    1024be <ideintr+0x56>
  102497:	6a 01                	push   $0x1
  102499:	e8 5b fd ff ff       	call   1021f9 <idewait>
  10249e:	83 c4 04             	add    $0x4,%esp
  1024a1:	85 c0                	test   %eax,%eax
  1024a3:	78 19                	js     1024be <ideintr+0x56>
    insl(0x1f0, b->data, BSIZE/4);
  1024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024a8:	83 c0 1c             	add    $0x1c,%eax
  1024ab:	68 80 00 00 00       	push   $0x80
  1024b0:	50                   	push   %eax
  1024b1:	68 f0 01 00 00       	push   $0x1f0
  1024b6:	e8 ca fc ff ff       	call   102185 <insl>
  1024bb:	83 c4 0c             	add    $0xc,%esp

  b->flags |= B_VALID;
  1024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024c1:	8b 00                	mov    (%eax),%eax
  1024c3:	83 c8 02             	or     $0x2,%eax
  1024c6:	89 c2                	mov    %eax,%edx
  1024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024cb:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
  1024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024d0:	8b 00                	mov    (%eax),%eax
  1024d2:	83 e0 fb             	and    $0xfffffffb,%eax
  1024d5:	89 c2                	mov    %eax,%edx
  1024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024da:	89 10                	mov    %edx,(%eax)

  // Start disk on next buf in queue.
  if(idequeue != 0)
  1024dc:	a1 28 54 10 00       	mov    0x105428,%eax
  1024e1:	85 c0                	test   %eax,%eax
  1024e3:	74 14                	je     1024f9 <ideintr+0x91>
    idestart(idequeue);
  1024e5:	a1 28 54 10 00       	mov    0x105428,%eax
  1024ea:	83 ec 0c             	sub    $0xc,%esp
  1024ed:	50                   	push   %eax
  1024ee:	e8 df fd ff ff       	call   1022d2 <idestart>
  1024f3:	83 c4 10             	add    $0x10,%esp
  1024f6:	eb 01                	jmp    1024f9 <ideintr+0x91>
    return;
  1024f8:	90                   	nop
}
  1024f9:	c9                   	leave  
  1024fa:	c3                   	ret    

001024fb <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
  1024fb:	f3 0f 1e fb          	endbr32 
  1024ff:	55                   	push   %ebp
  102500:	89 e5                	mov    %esp,%ebp
  102502:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102505:	8b 45 08             	mov    0x8(%ebp),%eax
  102508:	8b 00                	mov    (%eax),%eax
  10250a:	83 e0 06             	and    $0x6,%eax
  10250d:	83 f8 02             	cmp    $0x2,%eax
  102510:	75 0d                	jne    10251f <iderw+0x24>
    panic("iderw: nothing to do");
  102512:	83 ec 0c             	sub    $0xc,%esp
  102515:	68 60 43 10 00       	push   $0x104360
  10251a:	e8 9a dd ff ff       	call   1002b9 <panic>
  if(b->dev != 0 && !havedisk1)
  10251f:	8b 45 08             	mov    0x8(%ebp),%eax
  102522:	8b 40 04             	mov    0x4(%eax),%eax
  102525:	85 c0                	test   %eax,%eax
  102527:	74 16                	je     10253f <iderw+0x44>
  102529:	a1 2c 54 10 00       	mov    0x10542c,%eax
  10252e:	85 c0                	test   %eax,%eax
  102530:	75 0d                	jne    10253f <iderw+0x44>
    panic("iderw: ide disk 1 not present");
  102532:	83 ec 0c             	sub    $0xc,%esp
  102535:	68 75 43 10 00       	push   $0x104375
  10253a:	e8 7a dd ff ff       	call   1002b9 <panic>

  // Append b to idequeue.
  b->qnext = 0;
  10253f:	8b 45 08             	mov    0x8(%ebp),%eax
  102542:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
  102549:	c7 45 f4 28 54 10 00 	movl   $0x105428,-0xc(%ebp)
  102550:	eb 0b                	jmp    10255d <iderw+0x62>
  102552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102555:	8b 00                	mov    (%eax),%eax
  102557:	83 c0 18             	add    $0x18,%eax
  10255a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102560:	8b 00                	mov    (%eax),%eax
  102562:	85 c0                	test   %eax,%eax
  102564:	75 ec                	jne    102552 <iderw+0x57>
    ;
  *pp = b;
  102566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102569:	8b 55 08             	mov    0x8(%ebp),%edx
  10256c:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
  10256e:	a1 28 54 10 00       	mov    0x105428,%eax
  102573:	39 45 08             	cmp    %eax,0x8(%ebp)
  102576:	75 15                	jne    10258d <iderw+0x92>
    idestart(b);
  102578:	83 ec 0c             	sub    $0xc,%esp
  10257b:	ff 75 08             	pushl  0x8(%ebp)
  10257e:	e8 4f fd ff ff       	call   1022d2 <idestart>
  102583:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102586:	eb 05                	jmp    10258d <iderw+0x92>
  {
    // Warning: If we do not call noop(), compiler generates code that does not
    // read "b->flags" again and therefore never come out of this while loop. 
    // "b->flags" is modified by the trap handler in ideintr().  
    noop();
  102588:	e8 65 fc ff ff       	call   1021f2 <noop>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  10258d:	8b 45 08             	mov    0x8(%ebp),%eax
  102590:	8b 00                	mov    (%eax),%eax
  102592:	83 e0 06             	and    $0x6,%eax
  102595:	83 f8 02             	cmp    $0x2,%eax
  102598:	75 ee                	jne    102588 <iderw+0x8d>
  }
}
  10259a:	90                   	nop
  10259b:	90                   	nop
  10259c:	c9                   	leave  
  10259d:	c3                   	ret    

0010259e <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
  10259e:	f3 0f 1e fb          	endbr32 
  1025a2:	55                   	push   %ebp
  1025a3:	89 e5                	mov    %esp,%ebp
  1025a5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
  1025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1025ab:	83 ec 08             	sub    $0x8,%esp
  1025ae:	6a 01                	push   $0x1
  1025b0:	50                   	push   %eax
  1025b1:	e8 96 fa ff ff       	call   10204c <bread>
  1025b6:	83 c4 10             	add    $0x10,%esp
  1025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
  1025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1025bf:	83 c0 1c             	add    $0x1c,%eax
  1025c2:	83 ec 04             	sub    $0x4,%esp
  1025c5:	6a 1c                	push   $0x1c
  1025c7:	50                   	push   %eax
  1025c8:	ff 75 0c             	pushl  0xc(%ebp)
  1025cb:	e8 07 ea ff ff       	call   100fd7 <memmove>
  1025d0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  1025d3:	83 ec 0c             	sub    $0xc,%esp
  1025d6:	ff 75 f4             	pushl  -0xc(%ebp)
  1025d9:	e8 20 fb ff ff       	call   1020fe <brelse>
  1025de:	83 c4 10             	add    $0x10,%esp
}
  1025e1:	90                   	nop
  1025e2:	c9                   	leave  
  1025e3:	c3                   	ret    

001025e4 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
  1025e4:	f3 0f 1e fb          	endbr32 
  1025e8:	55                   	push   %ebp
  1025e9:	89 e5                	mov    %esp,%ebp
  1025eb:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread_wr(dev, bno);
  1025ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  1025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1025f4:	83 ec 08             	sub    $0x8,%esp
  1025f7:	52                   	push   %edx
  1025f8:	50                   	push   %eax
  1025f9:	e8 b5 fa ff ff       	call   1020b3 <bread_wr>
  1025fe:	83 c4 10             	add    $0x10,%esp
  102601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
  102604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102607:	83 c0 1c             	add    $0x1c,%eax
  10260a:	83 ec 04             	sub    $0x4,%esp
  10260d:	68 00 02 00 00       	push   $0x200
  102612:	6a 00                	push   $0x0
  102614:	50                   	push   %eax
  102615:	e8 f6 e8 ff ff       	call   100f10 <memset>
  10261a:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  10261d:	83 ec 0c             	sub    $0xc,%esp
  102620:	ff 75 f4             	pushl  -0xc(%ebp)
  102623:	e8 c2 19 00 00       	call   103fea <log_write>
  102628:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  10262b:	83 ec 0c             	sub    $0xc,%esp
  10262e:	ff 75 f4             	pushl  -0xc(%ebp)
  102631:	e8 c8 fa ff ff       	call   1020fe <brelse>
  102636:	83 c4 10             	add    $0x10,%esp
}
  102639:	90                   	nop
  10263a:	c9                   	leave  
  10263b:	c3                   	ret    

0010263c <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
  10263c:	f3 0f 1e fb          	endbr32 
  102640:	55                   	push   %ebp
  102641:	89 e5                	mov    %esp,%ebp
  102643:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  102646:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
  10264d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102654:	e9 13 01 00 00       	jmp    10276c <balloc+0x130>
    bp = bread_wr(dev, BBLOCK(b, sb));
  102659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10265c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  102662:	85 c0                	test   %eax,%eax
  102664:	0f 48 c2             	cmovs  %edx,%eax
  102667:	c1 f8 0c             	sar    $0xc,%eax
  10266a:	89 c2                	mov    %eax,%edx
  10266c:	a1 b8 ae 10 00       	mov    0x10aeb8,%eax
  102671:	01 d0                	add    %edx,%eax
  102673:	83 ec 08             	sub    $0x8,%esp
  102676:	50                   	push   %eax
  102677:	ff 75 08             	pushl  0x8(%ebp)
  10267a:	e8 34 fa ff ff       	call   1020b3 <bread_wr>
  10267f:	83 c4 10             	add    $0x10,%esp
  102682:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  102685:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10268c:	e9 a6 00 00 00       	jmp    102737 <balloc+0xfb>
      m = 1 << (bi % 8);
  102691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102694:	99                   	cltd   
  102695:	c1 ea 1d             	shr    $0x1d,%edx
  102698:	01 d0                	add    %edx,%eax
  10269a:	83 e0 07             	and    $0x7,%eax
  10269d:	29 d0                	sub    %edx,%eax
  10269f:	ba 01 00 00 00       	mov    $0x1,%edx
  1026a4:	89 c1                	mov    %eax,%ecx
  1026a6:	d3 e2                	shl    %cl,%edx
  1026a8:	89 d0                	mov    %edx,%eax
  1026aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1026ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1026b0:	8d 50 07             	lea    0x7(%eax),%edx
  1026b3:	85 c0                	test   %eax,%eax
  1026b5:	0f 48 c2             	cmovs  %edx,%eax
  1026b8:	c1 f8 03             	sar    $0x3,%eax
  1026bb:	89 c2                	mov    %eax,%edx
  1026bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1026c0:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  1026c5:	0f b6 c0             	movzbl %al,%eax
  1026c8:	23 45 e8             	and    -0x18(%ebp),%eax
  1026cb:	85 c0                	test   %eax,%eax
  1026cd:	75 64                	jne    102733 <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
  1026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1026d2:	8d 50 07             	lea    0x7(%eax),%edx
  1026d5:	85 c0                	test   %eax,%eax
  1026d7:	0f 48 c2             	cmovs  %edx,%eax
  1026da:	c1 f8 03             	sar    $0x3,%eax
  1026dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1026e0:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  1026e5:	89 d1                	mov    %edx,%ecx
  1026e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1026ea:	09 ca                	or     %ecx,%edx
  1026ec:	89 d1                	mov    %edx,%ecx
  1026ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1026f1:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
        log_write(bp);
  1026f5:	83 ec 0c             	sub    $0xc,%esp
  1026f8:	ff 75 ec             	pushl  -0x14(%ebp)
  1026fb:	e8 ea 18 00 00       	call   103fea <log_write>
  102700:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
  102703:	83 ec 0c             	sub    $0xc,%esp
  102706:	ff 75 ec             	pushl  -0x14(%ebp)
  102709:	e8 f0 f9 ff ff       	call   1020fe <brelse>
  10270e:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
  102711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102717:	01 c2                	add    %eax,%edx
  102719:	8b 45 08             	mov    0x8(%ebp),%eax
  10271c:	83 ec 08             	sub    $0x8,%esp
  10271f:	52                   	push   %edx
  102720:	50                   	push   %eax
  102721:	e8 be fe ff ff       	call   1025e4 <bzero>
  102726:	83 c4 10             	add    $0x10,%esp
        return b + bi;
  102729:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10272f:	01 d0                	add    %edx,%eax
  102731:	eb 57                	jmp    10278a <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  102733:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102737:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
  10273e:	7f 17                	jg     102757 <balloc+0x11b>
  102740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102746:	01 d0                	add    %edx,%eax
  102748:	89 c2                	mov    %eax,%edx
  10274a:	a1 a0 ae 10 00       	mov    0x10aea0,%eax
  10274f:	39 c2                	cmp    %eax,%edx
  102751:	0f 82 3a ff ff ff    	jb     102691 <balloc+0x55>
      }
    }
    brelse(bp);
  102757:	83 ec 0c             	sub    $0xc,%esp
  10275a:	ff 75 ec             	pushl  -0x14(%ebp)
  10275d:	e8 9c f9 ff ff       	call   1020fe <brelse>
  102762:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
  102765:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  10276c:	8b 15 a0 ae 10 00    	mov    0x10aea0,%edx
  102772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102775:	39 c2                	cmp    %eax,%edx
  102777:	0f 87 dc fe ff ff    	ja     102659 <balloc+0x1d>
  }
  panic("balloc: out of blocks");
  10277d:	83 ec 0c             	sub    $0xc,%esp
  102780:	68 94 43 10 00       	push   $0x104394
  102785:	e8 2f db ff ff       	call   1002b9 <panic>
}
  10278a:	c9                   	leave  
  10278b:	c3                   	ret    

0010278c <bfree>:


// Free a disk block.
static void
bfree(int dev, uint b)
{
  10278c:	f3 0f 1e fb          	endbr32 
  102790:	55                   	push   %ebp
  102791:	89 e5                	mov    %esp,%ebp
  102793:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread_wr(dev, BBLOCK(b, sb));
  102796:	8b 45 0c             	mov    0xc(%ebp),%eax
  102799:	c1 e8 0c             	shr    $0xc,%eax
  10279c:	89 c2                	mov    %eax,%edx
  10279e:	a1 b8 ae 10 00       	mov    0x10aeb8,%eax
  1027a3:	01 c2                	add    %eax,%edx
  1027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1027a8:	83 ec 08             	sub    $0x8,%esp
  1027ab:	52                   	push   %edx
  1027ac:	50                   	push   %eax
  1027ad:	e8 01 f9 ff ff       	call   1020b3 <bread_wr>
  1027b2:	83 c4 10             	add    $0x10,%esp
  1027b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
  1027b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1027bb:	25 ff 0f 00 00       	and    $0xfff,%eax
  1027c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
  1027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027c6:	99                   	cltd   
  1027c7:	c1 ea 1d             	shr    $0x1d,%edx
  1027ca:	01 d0                	add    %edx,%eax
  1027cc:	83 e0 07             	and    $0x7,%eax
  1027cf:	29 d0                	sub    %edx,%eax
  1027d1:	ba 01 00 00 00       	mov    $0x1,%edx
  1027d6:	89 c1                	mov    %eax,%ecx
  1027d8:	d3 e2                	shl    %cl,%edx
  1027da:	89 d0                	mov    %edx,%eax
  1027dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
  1027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027e2:	8d 50 07             	lea    0x7(%eax),%edx
  1027e5:	85 c0                	test   %eax,%eax
  1027e7:	0f 48 c2             	cmovs  %edx,%eax
  1027ea:	c1 f8 03             	sar    $0x3,%eax
  1027ed:	89 c2                	mov    %eax,%edx
  1027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027f2:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  1027f7:	0f b6 c0             	movzbl %al,%eax
  1027fa:	23 45 ec             	and    -0x14(%ebp),%eax
  1027fd:	85 c0                	test   %eax,%eax
  1027ff:	75 0d                	jne    10280e <bfree+0x82>
    panic("freeing free block");
  102801:	83 ec 0c             	sub    $0xc,%esp
  102804:	68 aa 43 10 00       	push   $0x1043aa
  102809:	e8 ab da ff ff       	call   1002b9 <panic>
  bp->data[bi/8] &= ~m;
  10280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102811:	8d 50 07             	lea    0x7(%eax),%edx
  102814:	85 c0                	test   %eax,%eax
  102816:	0f 48 c2             	cmovs  %edx,%eax
  102819:	c1 f8 03             	sar    $0x3,%eax
  10281c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10281f:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  102824:	89 d1                	mov    %edx,%ecx
  102826:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102829:	f7 d2                	not    %edx
  10282b:	21 ca                	and    %ecx,%edx
  10282d:	89 d1                	mov    %edx,%ecx
  10282f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102832:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
  log_write(bp);
  102836:	83 ec 0c             	sub    $0xc,%esp
  102839:	ff 75 f4             	pushl  -0xc(%ebp)
  10283c:	e8 a9 17 00 00       	call   103fea <log_write>
  102841:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102844:	83 ec 0c             	sub    $0xc,%esp
  102847:	ff 75 f4             	pushl  -0xc(%ebp)
  10284a:	e8 af f8 ff ff       	call   1020fe <brelse>
  10284f:	83 c4 10             	add    $0x10,%esp
}
  102852:	90                   	nop
  102853:	c9                   	leave  
  102854:	c3                   	ret    

00102855 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
  102855:	f3 0f 1e fb          	endbr32 
  102859:	55                   	push   %ebp
  10285a:	89 e5                	mov    %esp,%ebp
  10285c:	57                   	push   %edi
  10285d:	56                   	push   %esi
  10285e:	53                   	push   %ebx
  10285f:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
  102862:	83 ec 08             	sub    $0x8,%esp
  102865:	68 a0 ae 10 00       	push   $0x10aea0
  10286a:	ff 75 08             	pushl  0x8(%ebp)
  10286d:	e8 2c fd ff ff       	call   10259e <readsb>
  102872:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
  102875:	a1 b8 ae 10 00       	mov    0x10aeb8,%eax
  10287a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10287d:	8b 3d b4 ae 10 00    	mov    0x10aeb4,%edi
  102883:	8b 35 b0 ae 10 00    	mov    0x10aeb0,%esi
  102889:	8b 1d ac ae 10 00    	mov    0x10aeac,%ebx
  10288f:	8b 0d a8 ae 10 00    	mov    0x10aea8,%ecx
  102895:	8b 15 a4 ae 10 00    	mov    0x10aea4,%edx
  10289b:	a1 a0 ae 10 00       	mov    0x10aea0,%eax
  1028a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  1028a3:	57                   	push   %edi
  1028a4:	56                   	push   %esi
  1028a5:	53                   	push   %ebx
  1028a6:	51                   	push   %ecx
  1028a7:	52                   	push   %edx
  1028a8:	50                   	push   %eax
  1028a9:	68 c0 43 10 00       	push   $0x1043c0
  1028ae:	e8 3d d8 ff ff       	call   1000f0 <cprintf>
  1028b3:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
  1028b6:	90                   	nop
  1028b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1028ba:	5b                   	pop    %ebx
  1028bb:	5e                   	pop    %esi
  1028bc:	5f                   	pop    %edi
  1028bd:	5d                   	pop    %ebp
  1028be:	c3                   	ret    

001028bf <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
  1028bf:	f3 0f 1e fb          	endbr32 
  1028c3:	55                   	push   %ebp
  1028c4:	89 e5                	mov    %esp,%ebp
  1028c6:	83 ec 28             	sub    $0x28,%esp
  1028c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028cc:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
  1028d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1028d7:	e9 9e 00 00 00       	jmp    10297a <ialloc+0xbb>
    bp = bread_wr(dev, IBLOCK(inum, sb));
  1028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028df:	c1 e8 03             	shr    $0x3,%eax
  1028e2:	89 c2                	mov    %eax,%edx
  1028e4:	a1 b4 ae 10 00       	mov    0x10aeb4,%eax
  1028e9:	01 d0                	add    %edx,%eax
  1028eb:	83 ec 08             	sub    $0x8,%esp
  1028ee:	50                   	push   %eax
  1028ef:	ff 75 08             	pushl  0x8(%ebp)
  1028f2:	e8 bc f7 ff ff       	call   1020b3 <bread_wr>
  1028f7:	83 c4 10             	add    $0x10,%esp
  1028fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
  1028fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102900:	8d 50 1c             	lea    0x1c(%eax),%edx
  102903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102906:	83 e0 07             	and    $0x7,%eax
  102909:	c1 e0 06             	shl    $0x6,%eax
  10290c:	01 d0                	add    %edx,%eax
  10290e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
  102911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102914:	0f b7 00             	movzwl (%eax),%eax
  102917:	66 85 c0             	test   %ax,%ax
  10291a:	75 4c                	jne    102968 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
  10291c:	83 ec 04             	sub    $0x4,%esp
  10291f:	6a 40                	push   $0x40
  102921:	6a 00                	push   $0x0
  102923:	ff 75 ec             	pushl  -0x14(%ebp)
  102926:	e8 e5 e5 ff ff       	call   100f10 <memset>
  10292b:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
  10292e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102931:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  102935:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
  102938:	83 ec 0c             	sub    $0xc,%esp
  10293b:	ff 75 f0             	pushl  -0x10(%ebp)
  10293e:	e8 a7 16 00 00       	call   103fea <log_write>
  102943:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
  102946:	83 ec 0c             	sub    $0xc,%esp
  102949:	ff 75 f0             	pushl  -0x10(%ebp)
  10294c:	e8 ad f7 ff ff       	call   1020fe <brelse>
  102951:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
  102954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102957:	83 ec 08             	sub    $0x8,%esp
  10295a:	50                   	push   %eax
  10295b:	ff 75 08             	pushl  0x8(%ebp)
  10295e:	e8 6c 01 00 00       	call   102acf <iget>
  102963:	83 c4 10             	add    $0x10,%esp
  102966:	eb 30                	jmp    102998 <ialloc+0xd9>
    }
    brelse(bp);
  102968:	83 ec 0c             	sub    $0xc,%esp
  10296b:	ff 75 f0             	pushl  -0x10(%ebp)
  10296e:	e8 8b f7 ff ff       	call   1020fe <brelse>
  102973:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
  102976:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10297a:	8b 15 a8 ae 10 00    	mov    0x10aea8,%edx
  102980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102983:	39 c2                	cmp    %eax,%edx
  102985:	0f 87 51 ff ff ff    	ja     1028dc <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
  10298b:	83 ec 0c             	sub    $0xc,%esp
  10298e:	68 13 44 10 00       	push   $0x104413
  102993:	e8 21 d9 ff ff       	call   1002b9 <panic>
}
  102998:	c9                   	leave  
  102999:	c3                   	ret    

0010299a <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
  10299a:	f3 0f 1e fb          	endbr32 
  10299e:	55                   	push   %ebp
  10299f:	89 e5                	mov    %esp,%ebp
  1029a1:	83 ec 18             	sub    $0x18,%esp
  if(ip->valid && ip->nlink == 0){
  1029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a7:	8b 40 0c             	mov    0xc(%eax),%eax
  1029aa:	85 c0                	test   %eax,%eax
  1029ac:	74 4a                	je     1029f8 <iput+0x5e>
  1029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  1029b5:	66 85 c0             	test   %ax,%ax
  1029b8:	75 3e                	jne    1029f8 <iput+0x5e>
    int r = ip->ref;
  1029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1029bd:	8b 40 08             	mov    0x8(%eax),%eax
  1029c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(r == 1){
  1029c3:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  1029c7:	75 2f                	jne    1029f8 <iput+0x5e>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
  1029c9:	83 ec 0c             	sub    $0xc,%esp
  1029cc:	ff 75 08             	pushl  0x8(%ebp)
  1029cf:	e8 d1 03 00 00       	call   102da5 <itrunc>
  1029d4:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
      iupdate(ip);
  1029e0:	83 ec 0c             	sub    $0xc,%esp
  1029e3:	ff 75 08             	pushl  0x8(%ebp)
  1029e6:	e8 1f 00 00 00       	call   102a0a <iupdate>
  1029eb:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
  1029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    }
  }
  ip->ref--;
  1029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029fb:	8b 40 08             	mov    0x8(%eax),%eax
  1029fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a01:	8b 45 08             	mov    0x8(%ebp),%eax
  102a04:	89 50 08             	mov    %edx,0x8(%eax)
}
  102a07:	90                   	nop
  102a08:	c9                   	leave  
  102a09:	c3                   	ret    

00102a0a <iupdate>:
// Copy a modified in-memory inode to disk.
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
void
iupdate(struct inode *ip)
{
  102a0a:	f3 0f 1e fb          	endbr32 
  102a0e:	55                   	push   %ebp
  102a0f:	89 e5                	mov    %esp,%ebp
  102a11:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread_wr(ip->dev, IBLOCK(ip->inum, sb));
  102a14:	8b 45 08             	mov    0x8(%ebp),%eax
  102a17:	8b 40 04             	mov    0x4(%eax),%eax
  102a1a:	c1 e8 03             	shr    $0x3,%eax
  102a1d:	89 c2                	mov    %eax,%edx
  102a1f:	a1 b4 ae 10 00       	mov    0x10aeb4,%eax
  102a24:	01 c2                	add    %eax,%edx
  102a26:	8b 45 08             	mov    0x8(%ebp),%eax
  102a29:	8b 00                	mov    (%eax),%eax
  102a2b:	83 ec 08             	sub    $0x8,%esp
  102a2e:	52                   	push   %edx
  102a2f:	50                   	push   %eax
  102a30:	e8 7e f6 ff ff       	call   1020b3 <bread_wr>
  102a35:	83 c4 10             	add    $0x10,%esp
  102a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  102a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a3e:	8d 50 1c             	lea    0x1c(%eax),%edx
  102a41:	8b 45 08             	mov    0x8(%ebp),%eax
  102a44:	8b 40 04             	mov    0x4(%eax),%eax
  102a47:	83 e0 07             	and    $0x7,%eax
  102a4a:	c1 e0 06             	shl    $0x6,%eax
  102a4d:	01 d0                	add    %edx,%eax
  102a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
  102a52:	8b 45 08             	mov    0x8(%ebp),%eax
  102a55:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  102a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a5c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  102a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a62:	0f b7 50 12          	movzwl 0x12(%eax),%edx
  102a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a69:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  102a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a70:	0f b7 50 14          	movzwl 0x14(%eax),%edx
  102a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a77:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  102a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7e:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  102a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a85:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  102a89:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8c:	8b 50 18             	mov    0x18(%eax),%edx
  102a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a92:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  102a95:	8b 45 08             	mov    0x8(%ebp),%eax
  102a98:	8d 50 1c             	lea    0x1c(%eax),%edx
  102a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a9e:	83 c0 0c             	add    $0xc,%eax
  102aa1:	83 ec 04             	sub    $0x4,%esp
  102aa4:	6a 34                	push   $0x34
  102aa6:	52                   	push   %edx
  102aa7:	50                   	push   %eax
  102aa8:	e8 2a e5 ff ff       	call   100fd7 <memmove>
  102aad:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  102ab0:	83 ec 0c             	sub    $0xc,%esp
  102ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  102ab6:	e8 2f 15 00 00       	call   103fea <log_write>
  102abb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102abe:	83 ec 0c             	sub    $0xc,%esp
  102ac1:	ff 75 f4             	pushl  -0xc(%ebp)
  102ac4:	e8 35 f6 ff ff       	call   1020fe <brelse>
  102ac9:	83 c4 10             	add    $0x10,%esp
}
  102acc:	90                   	nop
  102acd:	c9                   	leave  
  102ace:	c3                   	ret    

00102acf <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
struct inode*
iget(uint dev, uint inum)
{
  102acf:	f3 0f 1e fb          	endbr32 
  102ad3:	55                   	push   %ebp
  102ad4:	89 e5                	mov    %esp,%ebp
  102ad6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  // Is the inode already cached?
  empty = 0;
  102ad9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  102ae0:	c7 45 f4 c0 ae 10 00 	movl   $0x10aec0,-0xc(%ebp)
  102ae7:	eb 4d                	jmp    102b36 <iget+0x67>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aec:	8b 40 08             	mov    0x8(%eax),%eax
  102aef:	85 c0                	test   %eax,%eax
  102af1:	7e 29                	jle    102b1c <iget+0x4d>
  102af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af6:	8b 00                	mov    (%eax),%eax
  102af8:	39 45 08             	cmp    %eax,0x8(%ebp)
  102afb:	75 1f                	jne    102b1c <iget+0x4d>
  102afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b00:	8b 40 04             	mov    0x4(%eax),%eax
  102b03:	39 45 0c             	cmp    %eax,0xc(%ebp)
  102b06:	75 14                	jne    102b1c <iget+0x4d>
      ip->ref++;
  102b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b0b:	8b 40 08             	mov    0x8(%eax),%eax
  102b0e:	8d 50 01             	lea    0x1(%eax),%edx
  102b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b14:	89 50 08             	mov    %edx,0x8(%eax)
      return ip;
  102b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1a:	eb 64                	jmp    102b80 <iget+0xb1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  102b1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b20:	75 10                	jne    102b32 <iget+0x63>
  102b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b25:	8b 40 08             	mov    0x8(%eax),%eax
  102b28:	85 c0                	test   %eax,%eax
  102b2a:	75 06                	jne    102b32 <iget+0x63>
      empty = ip;
  102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  102b32:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
  102b36:	81 7d f4 60 be 10 00 	cmpl   $0x10be60,-0xc(%ebp)
  102b3d:	72 aa                	jb     102ae9 <iget+0x1a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
  102b3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b43:	75 0d                	jne    102b52 <iget+0x83>
    panic("iget: no inodes");
  102b45:	83 ec 0c             	sub    $0xc,%esp
  102b48:	68 25 44 10 00       	push   $0x104425
  102b4d:	e8 67 d7 ff ff       	call   1002b9 <panic>

  ip = empty;
  102b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
  102b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  102b5e:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
  102b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b66:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
  102b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b6c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
  102b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b76:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

  return ip;
  102b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102b80:	c9                   	leave  
  102b81:	c3                   	ret    

00102b82 <iread>:

// Reads the inode from disk if necessary.
void
iread(struct inode *ip)
{
  102b82:	f3 0f 1e fb          	endbr32 
  102b86:	55                   	push   %ebp
  102b87:	89 e5                	mov    %esp,%ebp
  102b89:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  102b8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b90:	74 0a                	je     102b9c <iread+0x1a>
  102b92:	8b 45 08             	mov    0x8(%ebp),%eax
  102b95:	8b 40 08             	mov    0x8(%eax),%eax
  102b98:	85 c0                	test   %eax,%eax
  102b9a:	7f 0d                	jg     102ba9 <iread+0x27>
    panic("iread");
  102b9c:	83 ec 0c             	sub    $0xc,%esp
  102b9f:	68 35 44 10 00       	push   $0x104435
  102ba4:	e8 10 d7 ff ff       	call   1002b9 <panic>

  if(ip->valid == 0){
  102ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bac:	8b 40 0c             	mov    0xc(%eax),%eax
  102baf:	85 c0                	test   %eax,%eax
  102bb1:	0f 85 cd 00 00 00    	jne    102c84 <iread+0x102>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  102bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bba:	8b 40 04             	mov    0x4(%eax),%eax
  102bbd:	c1 e8 03             	shr    $0x3,%eax
  102bc0:	89 c2                	mov    %eax,%edx
  102bc2:	a1 b4 ae 10 00       	mov    0x10aeb4,%eax
  102bc7:	01 c2                	add    %eax,%edx
  102bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcc:	8b 00                	mov    (%eax),%eax
  102bce:	83 ec 08             	sub    $0x8,%esp
  102bd1:	52                   	push   %edx
  102bd2:	50                   	push   %eax
  102bd3:	e8 74 f4 ff ff       	call   10204c <bread>
  102bd8:	83 c4 10             	add    $0x10,%esp
  102bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  102bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be1:	8d 50 1c             	lea    0x1c(%eax),%edx
  102be4:	8b 45 08             	mov    0x8(%ebp),%eax
  102be7:	8b 40 04             	mov    0x4(%eax),%eax
  102bea:	83 e0 07             	and    $0x7,%eax
  102bed:	c1 e0 06             	shl    $0x6,%eax
  102bf0:	01 d0                	add    %edx,%eax
  102bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
  102bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bf8:	0f b7 10             	movzwl (%eax),%edx
  102bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfe:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
  102c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c05:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  102c09:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0c:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
  102c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c13:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  102c17:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1a:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
  102c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c21:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  102c25:	8b 45 08             	mov    0x8(%ebp),%eax
  102c28:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
  102c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c2f:	8b 50 08             	mov    0x8(%eax),%edx
  102c32:	8b 45 08             	mov    0x8(%ebp),%eax
  102c35:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  102c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c3b:	8d 50 0c             	lea    0xc(%eax),%edx
  102c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c41:	83 c0 1c             	add    $0x1c,%eax
  102c44:	83 ec 04             	sub    $0x4,%esp
  102c47:	6a 34                	push   $0x34
  102c49:	52                   	push   %edx
  102c4a:	50                   	push   %eax
  102c4b:	e8 87 e3 ff ff       	call   100fd7 <memmove>
  102c50:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  102c53:	83 ec 0c             	sub    $0xc,%esp
  102c56:	ff 75 f4             	pushl  -0xc(%ebp)
  102c59:	e8 a0 f4 ff ff       	call   1020fe <brelse>
  102c5e:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
  102c61:	8b 45 08             	mov    0x8(%ebp),%eax
  102c64:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if(ip->type == 0)
  102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  102c72:	66 85 c0             	test   %ax,%ax
  102c75:	75 0d                	jne    102c84 <iread+0x102>
      panic("iread: no type");
  102c77:	83 ec 0c             	sub    $0xc,%esp
  102c7a:	68 3b 44 10 00       	push   $0x10443b
  102c7f:	e8 35 d6 ff ff       	call   1002b9 <panic>
  }
}
  102c84:	90                   	nop
  102c85:	c9                   	leave  
  102c86:	c3                   	ret    

00102c87 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  102c87:	f3 0f 1e fb          	endbr32 
  102c8b:	55                   	push   %ebp
  102c8c:	89 e5                	mov    %esp,%ebp
  102c8e:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  102c91:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
  102c95:	77 42                	ja     102cd9 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c9d:	83 c2 04             	add    $0x4,%edx
  102ca0:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102cab:	75 24                	jne    102cd1 <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
  102cad:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb0:	8b 00                	mov    (%eax),%eax
  102cb2:	83 ec 0c             	sub    $0xc,%esp
  102cb5:	50                   	push   %eax
  102cb6:	e8 81 f9 ff ff       	call   10263c <balloc>
  102cbb:	83 c4 10             	add    $0x10,%esp
  102cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cc7:	8d 4a 04             	lea    0x4(%edx),%ecx
  102cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ccd:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
  102cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd4:	e9 ca 00 00 00       	jmp    102da3 <bmap+0x11c>
  }
  bn -= NDIRECT;
  102cd9:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
  102cdd:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
  102ce1:	0f 87 af 00 00 00    	ja     102d96 <bmap+0x10f>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
  102ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cea:	8b 40 4c             	mov    0x4c(%eax),%eax
  102ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102cf4:	75 1d                	jne    102d13 <bmap+0x8c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
  102cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf9:	8b 00                	mov    (%eax),%eax
  102cfb:	83 ec 0c             	sub    $0xc,%esp
  102cfe:	50                   	push   %eax
  102cff:	e8 38 f9 ff ff       	call   10263c <balloc>
  102d04:	83 c4 10             	add    $0x10,%esp
  102d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d10:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread_wr(ip->dev, addr);
  102d13:	8b 45 08             	mov    0x8(%ebp),%eax
  102d16:	8b 00                	mov    (%eax),%eax
  102d18:	83 ec 08             	sub    $0x8,%esp
  102d1b:	ff 75 f4             	pushl  -0xc(%ebp)
  102d1e:	50                   	push   %eax
  102d1f:	e8 8f f3 ff ff       	call   1020b3 <bread_wr>
  102d24:	83 c4 10             	add    $0x10,%esp
  102d27:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  102d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d2d:	83 c0 1c             	add    $0x1c,%eax
  102d30:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
  102d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d40:	01 d0                	add    %edx,%eax
  102d42:	8b 00                	mov    (%eax),%eax
  102d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102d4b:	75 36                	jne    102d83 <bmap+0xfc>
      a[bn] = addr = balloc(ip->dev);
  102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d50:	8b 00                	mov    (%eax),%eax
  102d52:	83 ec 0c             	sub    $0xc,%esp
  102d55:	50                   	push   %eax
  102d56:	e8 e1 f8 ff ff       	call   10263c <balloc>
  102d5b:	83 c4 10             	add    $0x10,%esp
  102d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d6e:	01 c2                	add    %eax,%edx
  102d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d73:	89 02                	mov    %eax,(%edx)
      log_write(bp);
  102d75:	83 ec 0c             	sub    $0xc,%esp
  102d78:	ff 75 f0             	pushl  -0x10(%ebp)
  102d7b:	e8 6a 12 00 00       	call   103fea <log_write>
  102d80:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  102d83:	83 ec 0c             	sub    $0xc,%esp
  102d86:	ff 75 f0             	pushl  -0x10(%ebp)
  102d89:	e8 70 f3 ff ff       	call   1020fe <brelse>
  102d8e:	83 c4 10             	add    $0x10,%esp
    return addr;
  102d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d94:	eb 0d                	jmp    102da3 <bmap+0x11c>
  }

  panic("bmap: out of range");
  102d96:	83 ec 0c             	sub    $0xc,%esp
  102d99:	68 4a 44 10 00       	push   $0x10444a
  102d9e:	e8 16 d5 ff ff       	call   1002b9 <panic>
}
  102da3:	c9                   	leave  
  102da4:	c3                   	ret    

00102da5 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
  102da5:	f3 0f 1e fb          	endbr32 
  102da9:	55                   	push   %ebp
  102daa:	89 e5                	mov    %esp,%ebp
  102dac:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  102daf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102db6:	eb 45                	jmp    102dfd <itrunc+0x58>
    if(ip->addrs[i]){
  102db8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dbe:	83 c2 04             	add    $0x4,%edx
  102dc1:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102dc5:	85 c0                	test   %eax,%eax
  102dc7:	74 30                	je     102df9 <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
  102dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dcf:	83 c2 04             	add    $0x4,%edx
  102dd2:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  102dd9:	8b 12                	mov    (%edx),%edx
  102ddb:	83 ec 08             	sub    $0x8,%esp
  102dde:	50                   	push   %eax
  102ddf:	52                   	push   %edx
  102de0:	e8 a7 f9 ff ff       	call   10278c <bfree>
  102de5:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
  102de8:	8b 45 08             	mov    0x8(%ebp),%eax
  102deb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dee:	83 c2 04             	add    $0x4,%edx
  102df1:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
  102df8:	00 
  for(i = 0; i < NDIRECT; i++){
  102df9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102dfd:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
  102e01:	7e b5                	jle    102db8 <itrunc+0x13>
    }
  }

  if(ip->addrs[NDIRECT]){
  102e03:	8b 45 08             	mov    0x8(%ebp),%eax
  102e06:	8b 40 4c             	mov    0x4c(%eax),%eax
  102e09:	85 c0                	test   %eax,%eax
  102e0b:	0f 84 a1 00 00 00    	je     102eb2 <itrunc+0x10d>
    bp = bread_wr(ip->dev, ip->addrs[NDIRECT]);
  102e11:	8b 45 08             	mov    0x8(%ebp),%eax
  102e14:	8b 50 4c             	mov    0x4c(%eax),%edx
  102e17:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1a:	8b 00                	mov    (%eax),%eax
  102e1c:	83 ec 08             	sub    $0x8,%esp
  102e1f:	52                   	push   %edx
  102e20:	50                   	push   %eax
  102e21:	e8 8d f2 ff ff       	call   1020b3 <bread_wr>
  102e26:	83 c4 10             	add    $0x10,%esp
  102e29:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
  102e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e2f:	83 c0 1c             	add    $0x1c,%eax
  102e32:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
  102e35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102e3c:	eb 3c                	jmp    102e7a <itrunc+0xd5>
      if(a[j])
  102e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e4b:	01 d0                	add    %edx,%eax
  102e4d:	8b 00                	mov    (%eax),%eax
  102e4f:	85 c0                	test   %eax,%eax
  102e51:	74 23                	je     102e76 <itrunc+0xd1>
        bfree(ip->dev, a[j]);
  102e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e60:	01 d0                	add    %edx,%eax
  102e62:	8b 00                	mov    (%eax),%eax
  102e64:	8b 55 08             	mov    0x8(%ebp),%edx
  102e67:	8b 12                	mov    (%edx),%edx
  102e69:	83 ec 08             	sub    $0x8,%esp
  102e6c:	50                   	push   %eax
  102e6d:	52                   	push   %edx
  102e6e:	e8 19 f9 ff ff       	call   10278c <bfree>
  102e73:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
  102e76:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e7d:	83 f8 7f             	cmp    $0x7f,%eax
  102e80:	76 bc                	jbe    102e3e <itrunc+0x99>
    }
    brelse(bp);
  102e82:	83 ec 0c             	sub    $0xc,%esp
  102e85:	ff 75 ec             	pushl  -0x14(%ebp)
  102e88:	e8 71 f2 ff ff       	call   1020fe <brelse>
  102e8d:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
  102e90:	8b 45 08             	mov    0x8(%ebp),%eax
  102e93:	8b 40 4c             	mov    0x4c(%eax),%eax
  102e96:	8b 55 08             	mov    0x8(%ebp),%edx
  102e99:	8b 12                	mov    (%edx),%edx
  102e9b:	83 ec 08             	sub    $0x8,%esp
  102e9e:	50                   	push   %eax
  102e9f:	52                   	push   %edx
  102ea0:	e8 e7 f8 ff ff       	call   10278c <bfree>
  102ea5:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
  102ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  102eab:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
  102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb5:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
  102ebc:	83 ec 0c             	sub    $0xc,%esp
  102ebf:	ff 75 08             	pushl  0x8(%ebp)
  102ec2:	e8 43 fb ff ff       	call   102a0a <iupdate>
  102ec7:	83 c4 10             	add    $0x10,%esp
}
  102eca:	90                   	nop
  102ecb:	c9                   	leave  
  102ecc:	c3                   	ret    

00102ecd <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
  102ecd:	f3 0f 1e fb          	endbr32 
  102ed1:	55                   	push   %ebp
  102ed2:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
  102ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed7:	8b 00                	mov    (%eax),%eax
  102ed9:	89 c2                	mov    %eax,%edx
  102edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ede:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
  102ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee4:	8b 50 04             	mov    0x4(%eax),%edx
  102ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eea:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
  102eed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef0:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  102ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef7:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
  102efa:	8b 45 08             	mov    0x8(%ebp),%eax
  102efd:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  102f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f04:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
  102f08:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0b:	8b 50 18             	mov    0x18(%eax),%edx
  102f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f11:	89 50 10             	mov    %edx,0x10(%eax)
}
  102f14:	90                   	nop
  102f15:	5d                   	pop    %ebp
  102f16:	c3                   	ret    

00102f17 <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  102f17:	f3 0f 1e fb          	endbr32 
  102f1b:	55                   	push   %ebp
  102f1c:	89 e5                	mov    %esp,%ebp
  102f1e:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off || ip->nlink < 1)
  102f21:	8b 45 08             	mov    0x8(%ebp),%eax
  102f24:	8b 40 18             	mov    0x18(%eax),%eax
  102f27:	39 45 10             	cmp    %eax,0x10(%ebp)
  102f2a:	77 19                	ja     102f45 <readi+0x2e>
  102f2c:	8b 55 10             	mov    0x10(%ebp),%edx
  102f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  102f32:	01 d0                	add    %edx,%eax
  102f34:	39 45 10             	cmp    %eax,0x10(%ebp)
  102f37:	77 0c                	ja     102f45 <readi+0x2e>
  102f39:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  102f40:	66 85 c0             	test   %ax,%ax
  102f43:	7f 0a                	jg     102f4f <readi+0x38>
    return -1;
  102f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102f4a:	e9 c2 00 00 00       	jmp    103011 <readi+0xfa>
  if(off + n > ip->size)
  102f4f:	8b 55 10             	mov    0x10(%ebp),%edx
  102f52:	8b 45 14             	mov    0x14(%ebp),%eax
  102f55:	01 c2                	add    %eax,%edx
  102f57:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5a:	8b 40 18             	mov    0x18(%eax),%eax
  102f5d:	39 c2                	cmp    %eax,%edx
  102f5f:	76 0c                	jbe    102f6d <readi+0x56>
    n = ip->size - off;
  102f61:	8b 45 08             	mov    0x8(%ebp),%eax
  102f64:	8b 40 18             	mov    0x18(%eax),%eax
  102f67:	2b 45 10             	sub    0x10(%ebp),%eax
  102f6a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  102f6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102f74:	e9 89 00 00 00       	jmp    103002 <readi+0xeb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  102f79:	8b 45 10             	mov    0x10(%ebp),%eax
  102f7c:	c1 e8 09             	shr    $0x9,%eax
  102f7f:	83 ec 08             	sub    $0x8,%esp
  102f82:	50                   	push   %eax
  102f83:	ff 75 08             	pushl  0x8(%ebp)
  102f86:	e8 fc fc ff ff       	call   102c87 <bmap>
  102f8b:	83 c4 10             	add    $0x10,%esp
  102f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  102f91:	8b 12                	mov    (%edx),%edx
  102f93:	83 ec 08             	sub    $0x8,%esp
  102f96:	50                   	push   %eax
  102f97:	52                   	push   %edx
  102f98:	e8 af f0 ff ff       	call   10204c <bread>
  102f9d:	83 c4 10             	add    $0x10,%esp
  102fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  102fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  102fa6:	25 ff 01 00 00       	and    $0x1ff,%eax
  102fab:	ba 00 02 00 00       	mov    $0x200,%edx
  102fb0:	29 c2                	sub    %eax,%edx
  102fb2:	8b 45 14             	mov    0x14(%ebp),%eax
  102fb5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  102fb8:	39 c2                	cmp    %eax,%edx
  102fba:	0f 46 c2             	cmovbe %edx,%eax
  102fbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
  102fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc3:	8d 50 1c             	lea    0x1c(%eax),%edx
  102fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  102fc9:	25 ff 01 00 00       	and    $0x1ff,%eax
  102fce:	01 d0                	add    %edx,%eax
  102fd0:	83 ec 04             	sub    $0x4,%esp
  102fd3:	ff 75 ec             	pushl  -0x14(%ebp)
  102fd6:	50                   	push   %eax
  102fd7:	ff 75 0c             	pushl  0xc(%ebp)
  102fda:	e8 f8 df ff ff       	call   100fd7 <memmove>
  102fdf:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  102fe2:	83 ec 0c             	sub    $0xc,%esp
  102fe5:	ff 75 f0             	pushl  -0x10(%ebp)
  102fe8:	e8 11 f1 ff ff       	call   1020fe <brelse>
  102fed:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  102ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff3:	01 45 f4             	add    %eax,-0xc(%ebp)
  102ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff9:	01 45 10             	add    %eax,0x10(%ebp)
  102ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fff:	01 45 0c             	add    %eax,0xc(%ebp)
  103002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103005:	3b 45 14             	cmp    0x14(%ebp),%eax
  103008:	0f 82 6b ff ff ff    	jb     102f79 <readi+0x62>
  }
  return n;
  10300e:	8b 45 14             	mov    0x14(%ebp),%eax
}
  103011:	c9                   	leave  
  103012:	c3                   	ret    

00103013 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  103013:	f3 0f 1e fb          	endbr32 
  103017:	55                   	push   %ebp
  103018:	89 e5                	mov    %esp,%ebp
  10301a:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
  10301d:	8b 45 08             	mov    0x8(%ebp),%eax
  103020:	8b 40 18             	mov    0x18(%eax),%eax
  103023:	39 45 10             	cmp    %eax,0x10(%ebp)
  103026:	77 0d                	ja     103035 <writei+0x22>
  103028:	8b 55 10             	mov    0x10(%ebp),%edx
  10302b:	8b 45 14             	mov    0x14(%ebp),%eax
  10302e:	01 d0                	add    %edx,%eax
  103030:	39 45 10             	cmp    %eax,0x10(%ebp)
  103033:	76 0a                	jbe    10303f <writei+0x2c>
    return -1;
  103035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10303a:	e9 f3 00 00 00       	jmp    103132 <writei+0x11f>
  if(off + n > MAXFILE*BSIZE)
  10303f:	8b 55 10             	mov    0x10(%ebp),%edx
  103042:	8b 45 14             	mov    0x14(%ebp),%eax
  103045:	01 d0                	add    %edx,%eax
  103047:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10304c:	76 0a                	jbe    103058 <writei+0x45>
    return -1;
  10304e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103053:	e9 da 00 00 00       	jmp    103132 <writei+0x11f>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  103058:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10305f:	e9 97 00 00 00       	jmp    1030fb <writei+0xe8>
    bp = bread_wr(ip->dev, bmap(ip, off/BSIZE));
  103064:	8b 45 10             	mov    0x10(%ebp),%eax
  103067:	c1 e8 09             	shr    $0x9,%eax
  10306a:	83 ec 08             	sub    $0x8,%esp
  10306d:	50                   	push   %eax
  10306e:	ff 75 08             	pushl  0x8(%ebp)
  103071:	e8 11 fc ff ff       	call   102c87 <bmap>
  103076:	83 c4 10             	add    $0x10,%esp
  103079:	8b 55 08             	mov    0x8(%ebp),%edx
  10307c:	8b 12                	mov    (%edx),%edx
  10307e:	83 ec 08             	sub    $0x8,%esp
  103081:	50                   	push   %eax
  103082:	52                   	push   %edx
  103083:	e8 2b f0 ff ff       	call   1020b3 <bread_wr>
  103088:	83 c4 10             	add    $0x10,%esp
  10308b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  10308e:	8b 45 10             	mov    0x10(%ebp),%eax
  103091:	25 ff 01 00 00       	and    $0x1ff,%eax
  103096:	ba 00 02 00 00       	mov    $0x200,%edx
  10309b:	29 c2                	sub    %eax,%edx
  10309d:	8b 45 14             	mov    0x14(%ebp),%eax
  1030a0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1030a3:	39 c2                	cmp    %eax,%edx
  1030a5:	0f 46 c2             	cmovbe %edx,%eax
  1030a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
  1030ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ae:	8d 50 1c             	lea    0x1c(%eax),%edx
  1030b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b4:	25 ff 01 00 00       	and    $0x1ff,%eax
  1030b9:	01 d0                	add    %edx,%eax
  1030bb:	83 ec 04             	sub    $0x4,%esp
  1030be:	ff 75 ec             	pushl  -0x14(%ebp)
  1030c1:	ff 75 0c             	pushl  0xc(%ebp)
  1030c4:	50                   	push   %eax
  1030c5:	e8 0d df ff ff       	call   100fd7 <memmove>
  1030ca:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
  1030cd:	83 ec 0c             	sub    $0xc,%esp
  1030d0:	ff 75 f0             	pushl  -0x10(%ebp)
  1030d3:	e8 12 0f 00 00       	call   103fea <log_write>
  1030d8:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  1030db:	83 ec 0c             	sub    $0xc,%esp
  1030de:	ff 75 f0             	pushl  -0x10(%ebp)
  1030e1:	e8 18 f0 ff ff       	call   1020fe <brelse>
  1030e6:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1030e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030ec:	01 45 f4             	add    %eax,-0xc(%ebp)
  1030ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030f2:	01 45 10             	add    %eax,0x10(%ebp)
  1030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030f8:	01 45 0c             	add    %eax,0xc(%ebp)
  1030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030fe:	3b 45 14             	cmp    0x14(%ebp),%eax
  103101:	0f 82 5d ff ff ff    	jb     103064 <writei+0x51>
  }

  if(n > 0 && off > ip->size){
  103107:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  10310b:	74 22                	je     10312f <writei+0x11c>
  10310d:	8b 45 08             	mov    0x8(%ebp),%eax
  103110:	8b 40 18             	mov    0x18(%eax),%eax
  103113:	39 45 10             	cmp    %eax,0x10(%ebp)
  103116:	76 17                	jbe    10312f <writei+0x11c>
    ip->size = off;
  103118:	8b 45 08             	mov    0x8(%ebp),%eax
  10311b:	8b 55 10             	mov    0x10(%ebp),%edx
  10311e:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
  103121:	83 ec 0c             	sub    $0xc,%esp
  103124:	ff 75 08             	pushl  0x8(%ebp)
  103127:	e8 de f8 ff ff       	call   102a0a <iupdate>
  10312c:	83 c4 10             	add    $0x10,%esp
  }
  return n;
  10312f:	8b 45 14             	mov    0x14(%ebp),%eax
}
  103132:	c9                   	leave  
  103133:	c3                   	ret    

00103134 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  103134:	f3 0f 1e fb          	endbr32 
  103138:	55                   	push   %ebp
  103139:	89 e5                	mov    %esp,%ebp
  10313b:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
  10313e:	83 ec 04             	sub    $0x4,%esp
  103141:	6a 0e                	push   $0xe
  103143:	ff 75 0c             	pushl  0xc(%ebp)
  103146:	ff 75 08             	pushl  0x8(%ebp)
  103149:	e8 27 df ff ff       	call   101075 <strncmp>
  10314e:	83 c4 10             	add    $0x10,%esp
}
  103151:	c9                   	leave  
  103152:	c3                   	ret    

00103153 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  103153:	f3 0f 1e fb          	endbr32 
  103157:	55                   	push   %ebp
  103158:	89 e5                	mov    %esp,%ebp
  10315a:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
  10315d:	8b 45 08             	mov    0x8(%ebp),%eax
  103160:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103164:	66 83 f8 01          	cmp    $0x1,%ax
  103168:	74 0d                	je     103177 <dirlookup+0x24>
    panic("dirlookup not DIR");
  10316a:	83 ec 0c             	sub    $0xc,%esp
  10316d:	68 5d 44 10 00       	push   $0x10445d
  103172:	e8 42 d1 ff ff       	call   1002b9 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
  103177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10317e:	eb 7b                	jmp    1031fb <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103180:	6a 10                	push   $0x10
  103182:	ff 75 f4             	pushl  -0xc(%ebp)
  103185:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103188:	50                   	push   %eax
  103189:	ff 75 08             	pushl  0x8(%ebp)
  10318c:	e8 86 fd ff ff       	call   102f17 <readi>
  103191:	83 c4 10             	add    $0x10,%esp
  103194:	83 f8 10             	cmp    $0x10,%eax
  103197:	74 0d                	je     1031a6 <dirlookup+0x53>
      panic("dirlookup read");
  103199:	83 ec 0c             	sub    $0xc,%esp
  10319c:	68 6f 44 10 00       	push   $0x10446f
  1031a1:	e8 13 d1 ff ff       	call   1002b9 <panic>
    if(de.inum == 0)
  1031a6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1031aa:	66 85 c0             	test   %ax,%ax
  1031ad:	74 47                	je     1031f6 <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
  1031af:	83 ec 08             	sub    $0x8,%esp
  1031b2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1031b5:	83 c0 02             	add    $0x2,%eax
  1031b8:	50                   	push   %eax
  1031b9:	ff 75 0c             	pushl  0xc(%ebp)
  1031bc:	e8 73 ff ff ff       	call   103134 <namecmp>
  1031c1:	83 c4 10             	add    $0x10,%esp
  1031c4:	85 c0                	test   %eax,%eax
  1031c6:	75 2f                	jne    1031f7 <dirlookup+0xa4>
      // entry matches path element
      if(poff)
  1031c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031cc:	74 08                	je     1031d6 <dirlookup+0x83>
        *poff = off;
  1031ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1031d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031d4:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
  1031d6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1031da:	0f b7 c0             	movzwl %ax,%eax
  1031dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
  1031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e3:	8b 00                	mov    (%eax),%eax
  1031e5:	83 ec 08             	sub    $0x8,%esp
  1031e8:	ff 75 f0             	pushl  -0x10(%ebp)
  1031eb:	50                   	push   %eax
  1031ec:	e8 de f8 ff ff       	call   102acf <iget>
  1031f1:	83 c4 10             	add    $0x10,%esp
  1031f4:	eb 19                	jmp    10320f <dirlookup+0xbc>
      continue;
  1031f6:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
  1031f7:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  1031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fe:	8b 40 18             	mov    0x18(%eax),%eax
  103201:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103204:	0f 82 76 ff ff ff    	jb     103180 <dirlookup+0x2d>
    }
  }

  return 0;
  10320a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10320f:	c9                   	leave  
  103210:	c3                   	ret    

00103211 <dirlink>:


// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  103211:	f3 0f 1e fb          	endbr32 
  103215:	55                   	push   %ebp
  103216:	89 e5                	mov    %esp,%ebp
  103218:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  10321b:	83 ec 04             	sub    $0x4,%esp
  10321e:	6a 00                	push   $0x0
  103220:	ff 75 0c             	pushl  0xc(%ebp)
  103223:	ff 75 08             	pushl  0x8(%ebp)
  103226:	e8 28 ff ff ff       	call   103153 <dirlookup>
  10322b:	83 c4 10             	add    $0x10,%esp
  10322e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103231:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103235:	74 18                	je     10324f <dirlink+0x3e>
    iput(ip);
  103237:	83 ec 0c             	sub    $0xc,%esp
  10323a:	ff 75 f0             	pushl  -0x10(%ebp)
  10323d:	e8 58 f7 ff ff       	call   10299a <iput>
  103242:	83 c4 10             	add    $0x10,%esp
    return -1;
  103245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10324a:	e9 9c 00 00 00       	jmp    1032eb <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  10324f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103256:	eb 39                	jmp    103291 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10325b:	6a 10                	push   $0x10
  10325d:	50                   	push   %eax
  10325e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103261:	50                   	push   %eax
  103262:	ff 75 08             	pushl  0x8(%ebp)
  103265:	e8 ad fc ff ff       	call   102f17 <readi>
  10326a:	83 c4 10             	add    $0x10,%esp
  10326d:	83 f8 10             	cmp    $0x10,%eax
  103270:	74 0d                	je     10327f <dirlink+0x6e>
      panic("dirlink read");
  103272:	83 ec 0c             	sub    $0xc,%esp
  103275:	68 7e 44 10 00       	push   $0x10447e
  10327a:	e8 3a d0 ff ff       	call   1002b9 <panic>
    if(de.inum == 0)
  10327f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103283:	66 85 c0             	test   %ax,%ax
  103286:	74 18                	je     1032a0 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
  103288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10328b:	83 c0 10             	add    $0x10,%eax
  10328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103291:	8b 45 08             	mov    0x8(%ebp),%eax
  103294:	8b 50 18             	mov    0x18(%eax),%edx
  103297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329a:	39 c2                	cmp    %eax,%edx
  10329c:	77 ba                	ja     103258 <dirlink+0x47>
  10329e:	eb 01                	jmp    1032a1 <dirlink+0x90>
      break;
  1032a0:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
  1032a1:	83 ec 04             	sub    $0x4,%esp
  1032a4:	6a 0e                	push   $0xe
  1032a6:	ff 75 0c             	pushl  0xc(%ebp)
  1032a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1032ac:	83 c0 02             	add    $0x2,%eax
  1032af:	50                   	push   %eax
  1032b0:	e8 1a de ff ff       	call   1010cf <strncpy>
  1032b5:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
  1032b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1032bb:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032c2:	6a 10                	push   $0x10
  1032c4:	50                   	push   %eax
  1032c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1032c8:	50                   	push   %eax
  1032c9:	ff 75 08             	pushl  0x8(%ebp)
  1032cc:	e8 42 fd ff ff       	call   103013 <writei>
  1032d1:	83 c4 10             	add    $0x10,%esp
  1032d4:	83 f8 10             	cmp    $0x10,%eax
  1032d7:	74 0d                	je     1032e6 <dirlink+0xd5>
    panic("dirlink");
  1032d9:	83 ec 0c             	sub    $0xc,%esp
  1032dc:	68 8b 44 10 00       	push   $0x10448b
  1032e1:	e8 d3 cf ff ff       	call   1002b9 <panic>

  return 0;
  1032e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032eb:	c9                   	leave  
  1032ec:	c3                   	ret    

001032ed <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
  1032ed:	f3 0f 1e fb          	endbr32 
  1032f1:	55                   	push   %ebp
  1032f2:	89 e5                	mov    %esp,%ebp
  1032f4:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
  1032f7:	eb 04                	jmp    1032fd <skipelem+0x10>
    path++;
  1032f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  1032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103300:	0f b6 00             	movzbl (%eax),%eax
  103303:	3c 2f                	cmp    $0x2f,%al
  103305:	74 f2                	je     1032f9 <skipelem+0xc>
  if(*path == 0)
  103307:	8b 45 08             	mov    0x8(%ebp),%eax
  10330a:	0f b6 00             	movzbl (%eax),%eax
  10330d:	84 c0                	test   %al,%al
  10330f:	75 07                	jne    103318 <skipelem+0x2b>
    return 0;
  103311:	b8 00 00 00 00       	mov    $0x0,%eax
  103316:	eb 77                	jmp    10338f <skipelem+0xa2>
  s = path;
  103318:	8b 45 08             	mov    0x8(%ebp),%eax
  10331b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
  10331e:	eb 04                	jmp    103324 <skipelem+0x37>
    path++;
  103320:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
  103324:	8b 45 08             	mov    0x8(%ebp),%eax
  103327:	0f b6 00             	movzbl (%eax),%eax
  10332a:	3c 2f                	cmp    $0x2f,%al
  10332c:	74 0a                	je     103338 <skipelem+0x4b>
  10332e:	8b 45 08             	mov    0x8(%ebp),%eax
  103331:	0f b6 00             	movzbl (%eax),%eax
  103334:	84 c0                	test   %al,%al
  103336:	75 e8                	jne    103320 <skipelem+0x33>
  len = path - s;
  103338:	8b 45 08             	mov    0x8(%ebp),%eax
  10333b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  10333e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
  103341:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  103345:	7e 15                	jle    10335c <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
  103347:	83 ec 04             	sub    $0x4,%esp
  10334a:	6a 0e                	push   $0xe
  10334c:	ff 75 f4             	pushl  -0xc(%ebp)
  10334f:	ff 75 0c             	pushl  0xc(%ebp)
  103352:	e8 80 dc ff ff       	call   100fd7 <memmove>
  103357:	83 c4 10             	add    $0x10,%esp
  10335a:	eb 26                	jmp    103382 <skipelem+0x95>
  else {
    memmove(name, s, len);
  10335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335f:	83 ec 04             	sub    $0x4,%esp
  103362:	50                   	push   %eax
  103363:	ff 75 f4             	pushl  -0xc(%ebp)
  103366:	ff 75 0c             	pushl  0xc(%ebp)
  103369:	e8 69 dc ff ff       	call   100fd7 <memmove>
  10336e:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
  103371:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103374:	8b 45 0c             	mov    0xc(%ebp),%eax
  103377:	01 d0                	add    %edx,%eax
  103379:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
  10337c:	eb 04                	jmp    103382 <skipelem+0x95>
    path++;
  10337e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  103382:	8b 45 08             	mov    0x8(%ebp),%eax
  103385:	0f b6 00             	movzbl (%eax),%eax
  103388:	3c 2f                	cmp    $0x2f,%al
  10338a:	74 f2                	je     10337e <skipelem+0x91>
  return path;
  10338c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10338f:	c9                   	leave  
  103390:	c3                   	ret    

00103391 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  103391:	f3 0f 1e fb          	endbr32 
  103395:	55                   	push   %ebp
  103396:	89 e5                	mov    %esp,%ebp
  103398:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  ip = iget(ROOTDEV, ROOTINO);
  10339b:	83 ec 08             	sub    $0x8,%esp
  10339e:	6a 01                	push   $0x1
  1033a0:	6a 01                	push   $0x1
  1033a2:	e8 28 f7 ff ff       	call   102acf <iget>
  1033a7:	83 c4 10             	add    $0x10,%esp
  1033aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
  1033ad:	e9 90 00 00 00       	jmp    103442 <namex+0xb1>
    iread(ip);
  1033b2:	83 ec 0c             	sub    $0xc,%esp
  1033b5:	ff 75 f4             	pushl  -0xc(%ebp)
  1033b8:	e8 c5 f7 ff ff       	call   102b82 <iread>
  1033bd:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
  1033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  1033c7:	66 83 f8 01          	cmp    $0x1,%ax
  1033cb:	74 18                	je     1033e5 <namex+0x54>
      iput(ip);
  1033cd:	83 ec 0c             	sub    $0xc,%esp
  1033d0:	ff 75 f4             	pushl  -0xc(%ebp)
  1033d3:	e8 c2 f5 ff ff       	call   10299a <iput>
  1033d8:	83 c4 10             	add    $0x10,%esp
      return 0;
  1033db:	b8 00 00 00 00       	mov    $0x0,%eax
  1033e0:	e9 99 00 00 00       	jmp    10347e <namex+0xed>
    }
    if(nameiparent && *path == '\0'){
  1033e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033e9:	74 12                	je     1033fd <namex+0x6c>
  1033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ee:	0f b6 00             	movzbl (%eax),%eax
  1033f1:	84 c0                	test   %al,%al
  1033f3:	75 08                	jne    1033fd <namex+0x6c>
      // Stop one level early.
      return ip;
  1033f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033f8:	e9 81 00 00 00       	jmp    10347e <namex+0xed>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  1033fd:	83 ec 04             	sub    $0x4,%esp
  103400:	6a 00                	push   $0x0
  103402:	ff 75 10             	pushl  0x10(%ebp)
  103405:	ff 75 f4             	pushl  -0xc(%ebp)
  103408:	e8 46 fd ff ff       	call   103153 <dirlookup>
  10340d:	83 c4 10             	add    $0x10,%esp
  103410:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103417:	75 15                	jne    10342e <namex+0x9d>
      iput(ip);
  103419:	83 ec 0c             	sub    $0xc,%esp
  10341c:	ff 75 f4             	pushl  -0xc(%ebp)
  10341f:	e8 76 f5 ff ff       	call   10299a <iput>
  103424:	83 c4 10             	add    $0x10,%esp
      return 0;
  103427:	b8 00 00 00 00       	mov    $0x0,%eax
  10342c:	eb 50                	jmp    10347e <namex+0xed>
    }
    iput(ip);
  10342e:	83 ec 0c             	sub    $0xc,%esp
  103431:	ff 75 f4             	pushl  -0xc(%ebp)
  103434:	e8 61 f5 ff ff       	call   10299a <iput>
  103439:	83 c4 10             	add    $0x10,%esp
    ip = next;
  10343c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10343f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
  103442:	83 ec 08             	sub    $0x8,%esp
  103445:	ff 75 10             	pushl  0x10(%ebp)
  103448:	ff 75 08             	pushl  0x8(%ebp)
  10344b:	e8 9d fe ff ff       	call   1032ed <skipelem>
  103450:	83 c4 10             	add    $0x10,%esp
  103453:	89 45 08             	mov    %eax,0x8(%ebp)
  103456:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10345a:	0f 85 52 ff ff ff    	jne    1033b2 <namex+0x21>
  }
  if(nameiparent){
  103460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103464:	74 15                	je     10347b <namex+0xea>
    iput(ip);
  103466:	83 ec 0c             	sub    $0xc,%esp
  103469:	ff 75 f4             	pushl  -0xc(%ebp)
  10346c:	e8 29 f5 ff ff       	call   10299a <iput>
  103471:	83 c4 10             	add    $0x10,%esp
    return 0;
  103474:	b8 00 00 00 00       	mov    $0x0,%eax
  103479:	eb 03                	jmp    10347e <namex+0xed>
  }
  return ip;
  10347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10347e:	c9                   	leave  
  10347f:	c3                   	ret    

00103480 <namei>:

struct inode*
namei(char *path)
{
  103480:	f3 0f 1e fb          	endbr32 
  103484:	55                   	push   %ebp
  103485:	89 e5                	mov    %esp,%ebp
  103487:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
  10348a:	83 ec 04             	sub    $0x4,%esp
  10348d:	8d 45 ea             	lea    -0x16(%ebp),%eax
  103490:	50                   	push   %eax
  103491:	6a 00                	push   $0x0
  103493:	ff 75 08             	pushl  0x8(%ebp)
  103496:	e8 f6 fe ff ff       	call   103391 <namex>
  10349b:	83 c4 10             	add    $0x10,%esp
}
  10349e:	c9                   	leave  
  10349f:	c3                   	ret    

001034a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
  1034a0:	f3 0f 1e fb          	endbr32 
  1034a4:	55                   	push   %ebp
  1034a5:	89 e5                	mov    %esp,%ebp
  1034a7:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
  1034aa:	83 ec 04             	sub    $0x4,%esp
  1034ad:	ff 75 0c             	pushl  0xc(%ebp)
  1034b0:	6a 01                	push   $0x1
  1034b2:	ff 75 08             	pushl  0x8(%ebp)
  1034b5:	e8 d7 fe ff ff       	call   103391 <namex>
  1034ba:	83 c4 10             	add    $0x10,%esp
}
  1034bd:	c9                   	leave  
  1034be:	c3                   	ret    

001034bf <filealloc>:
} ftable;

// Allocate a file structure.
struct file*
filealloc(void)
{
  1034bf:	f3 0f 1e fb          	endbr32 
  1034c3:	55                   	push   %ebp
  1034c4:	89 e5                	mov    %esp,%ebp
  1034c6:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  for(f = ftable.file; f < ftable.file + NFILE; f++){
  1034c9:	c7 45 fc 60 be 10 00 	movl   $0x10be60,-0x4(%ebp)
  1034d0:	eb 1d                	jmp    1034ef <filealloc+0x30>
    if(f->ref == 0){
  1034d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1034d5:	8b 40 04             	mov    0x4(%eax),%eax
  1034d8:	85 c0                	test   %eax,%eax
  1034da:	75 0f                	jne    1034eb <filealloc+0x2c>
      f->ref = 1;
  1034dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1034df:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      return f;
  1034e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1034e9:	eb 13                	jmp    1034fe <filealloc+0x3f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
  1034eb:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
  1034ef:	b8 30 c6 10 00       	mov    $0x10c630,%eax
  1034f4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1034f7:	72 d9                	jb     1034d2 <filealloc+0x13>
    }
  }
  return 0;
  1034f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034fe:	c9                   	leave  
  1034ff:	c3                   	ret    

00103500 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  103500:	f3 0f 1e fb          	endbr32 
  103504:	55                   	push   %ebp
  103505:	89 e5                	mov    %esp,%ebp
  103507:	83 ec 08             	sub    $0x8,%esp
  if(f->ref < 1)
  10350a:	8b 45 08             	mov    0x8(%ebp),%eax
  10350d:	8b 40 04             	mov    0x4(%eax),%eax
  103510:	85 c0                	test   %eax,%eax
  103512:	7f 0d                	jg     103521 <filedup+0x21>
    panic("filedup");
  103514:	83 ec 0c             	sub    $0xc,%esp
  103517:	68 93 44 10 00       	push   $0x104493
  10351c:	e8 98 cd ff ff       	call   1002b9 <panic>
  f->ref++;
  103521:	8b 45 08             	mov    0x8(%ebp),%eax
  103524:	8b 40 04             	mov    0x4(%eax),%eax
  103527:	8d 50 01             	lea    0x1(%eax),%edx
  10352a:	8b 45 08             	mov    0x8(%ebp),%eax
  10352d:	89 50 04             	mov    %edx,0x4(%eax)
  return f;
  103530:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103533:	c9                   	leave  
  103534:	c3                   	ret    

00103535 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  103535:	f3 0f 1e fb          	endbr32 
  103539:	55                   	push   %ebp
  10353a:	89 e5                	mov    %esp,%ebp
  10353c:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  if(f->ref < 1)
  10353f:	8b 45 08             	mov    0x8(%ebp),%eax
  103542:	8b 40 04             	mov    0x4(%eax),%eax
  103545:	85 c0                	test   %eax,%eax
  103547:	7f 0d                	jg     103556 <fileclose+0x21>
    panic("fileclose");
  103549:	83 ec 0c             	sub    $0xc,%esp
  10354c:	68 9b 44 10 00       	push   $0x10449b
  103551:	e8 63 cd ff ff       	call   1002b9 <panic>
  if(--f->ref > 0){
  103556:	8b 45 08             	mov    0x8(%ebp),%eax
  103559:	8b 40 04             	mov    0x4(%eax),%eax
  10355c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10355f:	8b 45 08             	mov    0x8(%ebp),%eax
  103562:	89 50 04             	mov    %edx,0x4(%eax)
  103565:	8b 45 08             	mov    0x8(%ebp),%eax
  103568:	8b 40 04             	mov    0x4(%eax),%eax
  10356b:	85 c0                	test   %eax,%eax
  10356d:	7f 56                	jg     1035c5 <fileclose+0x90>
    return;
  }
  ff = *f;
  10356f:	8b 45 08             	mov    0x8(%ebp),%eax
  103572:	8b 10                	mov    (%eax),%edx
  103574:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103577:	8b 50 04             	mov    0x4(%eax),%edx
  10357a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10357d:	8b 50 08             	mov    0x8(%eax),%edx
  103580:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103583:	8b 50 0c             	mov    0xc(%eax),%edx
  103586:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103589:	8b 40 10             	mov    0x10(%eax),%eax
  10358c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
  10358f:	8b 45 08             	mov    0x8(%ebp),%eax
  103592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
  103599:	8b 45 08             	mov    0x8(%ebp),%eax
  10359c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(ff.type == FD_INODE){
  1035a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035a5:	83 f8 01             	cmp    $0x1,%eax
  1035a8:	75 1c                	jne    1035c6 <fileclose+0x91>
    begin_op();
  1035aa:	e8 f0 09 00 00       	call   103f9f <begin_op>
    iput(ff.ip);
  1035af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035b2:	83 ec 0c             	sub    $0xc,%esp
  1035b5:	50                   	push   %eax
  1035b6:	e8 df f3 ff ff       	call   10299a <iput>
  1035bb:	83 c4 10             	add    $0x10,%esp
    end_op();
  1035be:	e8 e6 09 00 00       	call   103fa9 <end_op>
  1035c3:	eb 01                	jmp    1035c6 <fileclose+0x91>
    return;
  1035c5:	90                   	nop
  }
}
  1035c6:	c9                   	leave  
  1035c7:	c3                   	ret    

001035c8 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  1035c8:	f3 0f 1e fb          	endbr32 
  1035cc:	55                   	push   %ebp
  1035cd:	89 e5                	mov    %esp,%ebp
  1035cf:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
  1035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d5:	8b 00                	mov    (%eax),%eax
  1035d7:	83 f8 01             	cmp    $0x1,%eax
  1035da:	75 2e                	jne    10360a <filestat+0x42>
    iread(f->ip);
  1035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1035df:	8b 40 0c             	mov    0xc(%eax),%eax
  1035e2:	83 ec 0c             	sub    $0xc,%esp
  1035e5:	50                   	push   %eax
  1035e6:	e8 97 f5 ff ff       	call   102b82 <iread>
  1035eb:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
  1035ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1035f1:	8b 40 0c             	mov    0xc(%eax),%eax
  1035f4:	83 ec 08             	sub    $0x8,%esp
  1035f7:	ff 75 0c             	pushl  0xc(%ebp)
  1035fa:	50                   	push   %eax
  1035fb:	e8 cd f8 ff ff       	call   102ecd <stati>
  103600:	83 c4 10             	add    $0x10,%esp
    return 0;
  103603:	b8 00 00 00 00       	mov    $0x0,%eax
  103608:	eb 05                	jmp    10360f <filestat+0x47>
  }
  return -1;
  10360a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10360f:	c9                   	leave  
  103610:	c3                   	ret    

00103611 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
  103611:	f3 0f 1e fb          	endbr32 
  103615:	55                   	push   %ebp
  103616:	89 e5                	mov    %esp,%ebp
  103618:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
  10361b:	8b 45 08             	mov    0x8(%ebp),%eax
  10361e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
  103622:	84 c0                	test   %al,%al
  103624:	75 07                	jne    10362d <fileread+0x1c>
    return -1;
  103626:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10362b:	eb 65                	jmp    103692 <fileread+0x81>
  if(f->type == FD_INODE){
  10362d:	8b 45 08             	mov    0x8(%ebp),%eax
  103630:	8b 00                	mov    (%eax),%eax
  103632:	83 f8 01             	cmp    $0x1,%eax
  103635:	75 4e                	jne    103685 <fileread+0x74>
    iread(f->ip);
  103637:	8b 45 08             	mov    0x8(%ebp),%eax
  10363a:	8b 40 0c             	mov    0xc(%eax),%eax
  10363d:	83 ec 0c             	sub    $0xc,%esp
  103640:	50                   	push   %eax
  103641:	e8 3c f5 ff ff       	call   102b82 <iread>
  103646:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  103649:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10364c:	8b 45 08             	mov    0x8(%ebp),%eax
  10364f:	8b 50 10             	mov    0x10(%eax),%edx
  103652:	8b 45 08             	mov    0x8(%ebp),%eax
  103655:	8b 40 0c             	mov    0xc(%eax),%eax
  103658:	51                   	push   %ecx
  103659:	52                   	push   %edx
  10365a:	ff 75 0c             	pushl  0xc(%ebp)
  10365d:	50                   	push   %eax
  10365e:	e8 b4 f8 ff ff       	call   102f17 <readi>
  103663:	83 c4 10             	add    $0x10,%esp
  103666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10366d:	7e 11                	jle    103680 <fileread+0x6f>
      f->off += r;
  10366f:	8b 45 08             	mov    0x8(%ebp),%eax
  103672:	8b 50 10             	mov    0x10(%eax),%edx
  103675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103678:	01 c2                	add    %eax,%edx
  10367a:	8b 45 08             	mov    0x8(%ebp),%eax
  10367d:	89 50 10             	mov    %edx,0x10(%eax)
    return r;
  103680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103683:	eb 0d                	jmp    103692 <fileread+0x81>
  }
  panic("fileread");
  103685:	83 ec 0c             	sub    $0xc,%esp
  103688:	68 a5 44 10 00       	push   $0x1044a5
  10368d:	e8 27 cc ff ff       	call   1002b9 <panic>
}
  103692:	c9                   	leave  
  103693:	c3                   	ret    

00103694 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
  103694:	f3 0f 1e fb          	endbr32 
  103698:	55                   	push   %ebp
  103699:	89 e5                	mov    %esp,%ebp
  10369b:	53                   	push   %ebx
  10369c:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
  10369f:	8b 45 08             	mov    0x8(%ebp),%eax
  1036a2:	0f b6 40 09          	movzbl 0x9(%eax),%eax
  1036a6:	84 c0                	test   %al,%al
  1036a8:	75 0a                	jne    1036b4 <filewrite+0x20>
    return -1;
  1036aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1036af:	e9 e2 00 00 00       	jmp    103796 <filewrite+0x102>
  if(f->type == FD_INODE){
  1036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b7:	8b 00                	mov    (%eax),%eax
  1036b9:	83 f8 01             	cmp    $0x1,%eax
  1036bc:	0f 85 c7 00 00 00    	jne    103789 <filewrite+0xf5>
    // write a few blocks at a time
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
  1036c2:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
  1036c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
  1036d0:	e9 91 00 00 00       	jmp    103766 <filewrite+0xd2>
      int n1 = n - i;
  1036d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1036db:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
  1036de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036e1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1036e4:	7e 06                	jle    1036ec <filewrite+0x58>
        n1 = max;
  1036e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036e9:	89 45 f0             	mov    %eax,-0x10(%ebp)

			begin_op();
  1036ec:	e8 ae 08 00 00       	call   103f9f <begin_op>
      iread(f->ip);
  1036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1036f4:	8b 40 0c             	mov    0xc(%eax),%eax
  1036f7:	83 ec 0c             	sub    $0xc,%esp
  1036fa:	50                   	push   %eax
  1036fb:	e8 82 f4 ff ff       	call   102b82 <iread>
  103700:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
  103703:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103706:	8b 45 08             	mov    0x8(%ebp),%eax
  103709:	8b 50 10             	mov    0x10(%eax),%edx
  10370c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10370f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103712:	01 c3                	add    %eax,%ebx
  103714:	8b 45 08             	mov    0x8(%ebp),%eax
  103717:	8b 40 0c             	mov    0xc(%eax),%eax
  10371a:	51                   	push   %ecx
  10371b:	52                   	push   %edx
  10371c:	53                   	push   %ebx
  10371d:	50                   	push   %eax
  10371e:	e8 f0 f8 ff ff       	call   103013 <writei>
  103723:	83 c4 10             	add    $0x10,%esp
  103726:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103729:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10372d:	7e 11                	jle    103740 <filewrite+0xac>
        f->off += r;
  10372f:	8b 45 08             	mov    0x8(%ebp),%eax
  103732:	8b 50 10             	mov    0x10(%eax),%edx
  103735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103738:	01 c2                	add    %eax,%edx
  10373a:	8b 45 08             	mov    0x8(%ebp),%eax
  10373d:	89 50 10             	mov    %edx,0x10(%eax)
      end_op();
  103740:	e8 64 08 00 00       	call   103fa9 <end_op>

      if(r < 0)
  103745:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103749:	78 29                	js     103774 <filewrite+0xe0>
        break;
      if(r != n1)
  10374b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10374e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103751:	74 0d                	je     103760 <filewrite+0xcc>
        panic("short filewrite");
  103753:	83 ec 0c             	sub    $0xc,%esp
  103756:	68 ae 44 10 00       	push   $0x1044ae
  10375b:	e8 59 cb ff ff       	call   1002b9 <panic>
      i += r;
  103760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103763:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
  103766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103769:	3b 45 10             	cmp    0x10(%ebp),%eax
  10376c:	0f 8c 63 ff ff ff    	jl     1036d5 <filewrite+0x41>
  103772:	eb 01                	jmp    103775 <filewrite+0xe1>
        break;
  103774:	90                   	nop
    }
    return i == n ? n : -1;
  103775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103778:	3b 45 10             	cmp    0x10(%ebp),%eax
  10377b:	75 05                	jne    103782 <filewrite+0xee>
  10377d:	8b 45 10             	mov    0x10(%ebp),%eax
  103780:	eb 14                	jmp    103796 <filewrite+0x102>
  103782:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103787:	eb 0d                	jmp    103796 <filewrite+0x102>
  }
  panic("filewrite");
  103789:	83 ec 0c             	sub    $0xc,%esp
  10378c:	68 be 44 10 00       	push   $0x1044be
  103791:	e8 23 cb ff ff       	call   1002b9 <panic>
}
  103796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  103799:	c9                   	leave  
  10379a:	c3                   	ret    

0010379b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
  10379b:	f3 0f 1e fb          	endbr32 
  10379f:	55                   	push   %ebp
  1037a0:	89 e5                	mov    %esp,%ebp
  1037a2:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  1037a5:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
  1037ac:	eb 40                	jmp    1037ee <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1037ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037b1:	6a 10                	push   $0x10
  1037b3:	50                   	push   %eax
  1037b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1037b7:	50                   	push   %eax
  1037b8:	ff 75 08             	pushl  0x8(%ebp)
  1037bb:	e8 57 f7 ff ff       	call   102f17 <readi>
  1037c0:	83 c4 10             	add    $0x10,%esp
  1037c3:	83 f8 10             	cmp    $0x10,%eax
  1037c6:	74 0d                	je     1037d5 <isdirempty+0x3a>
      panic("isdirempty: readi");
  1037c8:	83 ec 0c             	sub    $0xc,%esp
  1037cb:	68 c8 44 10 00       	push   $0x1044c8
  1037d0:	e8 e4 ca ff ff       	call   1002b9 <panic>
    if(de.inum != 0)
  1037d5:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  1037d9:	66 85 c0             	test   %ax,%ax
  1037dc:	74 07                	je     1037e5 <isdirempty+0x4a>
      return 0;
  1037de:	b8 00 00 00 00       	mov    $0x0,%eax
  1037e3:	eb 1b                	jmp    103800 <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  1037e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037e8:	83 c0 10             	add    $0x10,%eax
  1037eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1037ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1037f1:	8b 50 18             	mov    0x18(%eax),%edx
  1037f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037f7:	39 c2                	cmp    %eax,%edx
  1037f9:	77 b3                	ja     1037ae <isdirempty+0x13>
  }
  return 1;
  1037fb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  103800:	c9                   	leave  
  103801:	c3                   	ret    

00103802 <unlink>:

int
unlink(char* path, char* name)
{
  103802:	f3 0f 1e fb          	endbr32 
  103806:	55                   	push   %ebp
  103807:	89 e5                	mov    %esp,%ebp
  103809:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *dp;
  struct dirent de;
  uint off;

	begin_op();
  10380c:	e8 8e 07 00 00       	call   103f9f <begin_op>
  if((dp = nameiparent(path, name)) == 0){
  103811:	83 ec 08             	sub    $0x8,%esp
  103814:	ff 75 0c             	pushl  0xc(%ebp)
  103817:	ff 75 08             	pushl  0x8(%ebp)
  10381a:	e8 81 fc ff ff       	call   1034a0 <nameiparent>
  10381f:	83 c4 10             	add    $0x10,%esp
  103822:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103829:	75 0f                	jne    10383a <unlink+0x38>
    end_op();
  10382b:	e8 79 07 00 00       	call   103fa9 <end_op>
    return -1;
  103830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103835:	e9 8c 01 00 00       	jmp    1039c6 <unlink+0x1c4>
  }

  iread(dp);
  10383a:	83 ec 0c             	sub    $0xc,%esp
  10383d:	ff 75 f4             	pushl  -0xc(%ebp)
  103840:	e8 3d f3 ff ff       	call   102b82 <iread>
  103845:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
  103848:	83 ec 08             	sub    $0x8,%esp
  10384b:	68 da 44 10 00       	push   $0x1044da
  103850:	ff 75 0c             	pushl  0xc(%ebp)
  103853:	e8 dc f8 ff ff       	call   103134 <namecmp>
  103858:	83 c4 10             	add    $0x10,%esp
  10385b:	85 c0                	test   %eax,%eax
  10385d:	0f 84 47 01 00 00    	je     1039aa <unlink+0x1a8>
  103863:	83 ec 08             	sub    $0x8,%esp
  103866:	68 dc 44 10 00       	push   $0x1044dc
  10386b:	ff 75 0c             	pushl  0xc(%ebp)
  10386e:	e8 c1 f8 ff ff       	call   103134 <namecmp>
  103873:	83 c4 10             	add    $0x10,%esp
  103876:	85 c0                	test   %eax,%eax
  103878:	0f 84 2c 01 00 00    	je     1039aa <unlink+0x1a8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
  10387e:	83 ec 04             	sub    $0x4,%esp
  103881:	8d 45 dc             	lea    -0x24(%ebp),%eax
  103884:	50                   	push   %eax
  103885:	ff 75 0c             	pushl  0xc(%ebp)
  103888:	ff 75 f4             	pushl  -0xc(%ebp)
  10388b:	e8 c3 f8 ff ff       	call   103153 <dirlookup>
  103890:	83 c4 10             	add    $0x10,%esp
  103893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103896:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10389a:	0f 84 0d 01 00 00    	je     1039ad <unlink+0x1ab>
    goto bad;
  iread(ip);
  1038a0:	83 ec 0c             	sub    $0xc,%esp
  1038a3:	ff 75 f0             	pushl  -0x10(%ebp)
  1038a6:	e8 d7 f2 ff ff       	call   102b82 <iread>
  1038ab:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
  1038ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038b1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  1038b5:	66 85 c0             	test   %ax,%ax
  1038b8:	7f 0d                	jg     1038c7 <unlink+0xc5>
    panic("unlink: nlink < 1");
  1038ba:	83 ec 0c             	sub    $0xc,%esp
  1038bd:	68 df 44 10 00       	push   $0x1044df
  1038c2:	e8 f2 c9 ff ff       	call   1002b9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
  1038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  1038ce:	66 83 f8 01          	cmp    $0x1,%ax
  1038d2:	75 25                	jne    1038f9 <unlink+0xf7>
  1038d4:	83 ec 0c             	sub    $0xc,%esp
  1038d7:	ff 75 f0             	pushl  -0x10(%ebp)
  1038da:	e8 bc fe ff ff       	call   10379b <isdirempty>
  1038df:	83 c4 10             	add    $0x10,%esp
  1038e2:	85 c0                	test   %eax,%eax
  1038e4:	75 13                	jne    1038f9 <unlink+0xf7>
    iput(ip);
  1038e6:	83 ec 0c             	sub    $0xc,%esp
  1038e9:	ff 75 f0             	pushl  -0x10(%ebp)
  1038ec:	e8 a9 f0 ff ff       	call   10299a <iput>
  1038f1:	83 c4 10             	add    $0x10,%esp
    goto bad;
  1038f4:	e9 b5 00 00 00       	jmp    1039ae <unlink+0x1ac>
  }

  memset(&de, 0, sizeof(de));
  1038f9:	83 ec 04             	sub    $0x4,%esp
  1038fc:	6a 10                	push   $0x10
  1038fe:	6a 00                	push   $0x0
  103900:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103903:	50                   	push   %eax
  103904:	e8 07 d6 ff ff       	call   100f10 <memset>
  103909:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10390c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10390f:	6a 10                	push   $0x10
  103911:	50                   	push   %eax
  103912:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103915:	50                   	push   %eax
  103916:	ff 75 f4             	pushl  -0xc(%ebp)
  103919:	e8 f5 f6 ff ff       	call   103013 <writei>
  10391e:	83 c4 10             	add    $0x10,%esp
  103921:	83 f8 10             	cmp    $0x10,%eax
  103924:	74 0d                	je     103933 <unlink+0x131>
    panic("unlink: writei");
  103926:	83 ec 0c             	sub    $0xc,%esp
  103929:	68 f1 44 10 00       	push   $0x1044f1
  10392e:	e8 86 c9 ff ff       	call   1002b9 <panic>
  if(ip->type == T_DIR){
  103933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103936:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10393a:	66 83 f8 01          	cmp    $0x1,%ax
  10393e:	75 21                	jne    103961 <unlink+0x15f>
    dp->nlink--;
  103940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103943:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103947:	83 e8 01             	sub    $0x1,%eax
  10394a:	89 c2                	mov    %eax,%edx
  10394c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10394f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  103953:	83 ec 0c             	sub    $0xc,%esp
  103956:	ff 75 f4             	pushl  -0xc(%ebp)
  103959:	e8 ac f0 ff ff       	call   102a0a <iupdate>
  10395e:	83 c4 10             	add    $0x10,%esp
  }
  iput(dp);
  103961:	83 ec 0c             	sub    $0xc,%esp
  103964:	ff 75 f4             	pushl  -0xc(%ebp)
  103967:	e8 2e f0 ff ff       	call   10299a <iput>
  10396c:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
  10396f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103972:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103976:	83 e8 01             	sub    $0x1,%eax
  103979:	89 c2                	mov    %eax,%edx
  10397b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10397e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
  103982:	83 ec 0c             	sub    $0xc,%esp
  103985:	ff 75 f0             	pushl  -0x10(%ebp)
  103988:	e8 7d f0 ff ff       	call   102a0a <iupdate>
  10398d:	83 c4 10             	add    $0x10,%esp
  iput(ip);
  103990:	83 ec 0c             	sub    $0xc,%esp
  103993:	ff 75 f0             	pushl  -0x10(%ebp)
  103996:	e8 ff ef ff ff       	call   10299a <iput>
  10399b:	83 c4 10             	add    $0x10,%esp

  end_op();
  10399e:	e8 06 06 00 00       	call   103fa9 <end_op>
  return 0;
  1039a3:	b8 00 00 00 00       	mov    $0x0,%eax
  1039a8:	eb 1c                	jmp    1039c6 <unlink+0x1c4>
    goto bad;
  1039aa:	90                   	nop
  1039ab:	eb 01                	jmp    1039ae <unlink+0x1ac>
    goto bad;
  1039ad:	90                   	nop

bad:
  iput(dp);
  1039ae:	83 ec 0c             	sub    $0xc,%esp
  1039b1:	ff 75 f4             	pushl  -0xc(%ebp)
  1039b4:	e8 e1 ef ff ff       	call   10299a <iput>
  1039b9:	83 c4 10             	add    $0x10,%esp
  end_op();
  1039bc:	e8 e8 05 00 00       	call   103fa9 <end_op>
  return -1;
  1039c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1039c6:	c9                   	leave  
  1039c7:	c3                   	ret    

001039c8 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
  1039c8:	f3 0f 1e fb          	endbr32 
  1039cc:	55                   	push   %ebp
  1039cd:	89 e5                	mov    %esp,%ebp
  1039cf:	83 ec 38             	sub    $0x38,%esp
  1039d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1039d5:	8b 55 10             	mov    0x10(%ebp),%edx
  1039d8:	8b 45 14             	mov    0x14(%ebp),%eax
  1039db:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
  1039df:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  1039e3:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1039e7:	83 ec 08             	sub    $0x8,%esp
  1039ea:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1039ed:	50                   	push   %eax
  1039ee:	ff 75 08             	pushl  0x8(%ebp)
  1039f1:	e8 aa fa ff ff       	call   1034a0 <nameiparent>
  1039f6:	83 c4 10             	add    $0x10,%esp
  1039f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1039fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a00:	75 0a                	jne    103a0c <create+0x44>
    return 0;
  103a02:	b8 00 00 00 00       	mov    $0x0,%eax
  103a07:	e9 8e 01 00 00       	jmp    103b9a <create+0x1d2>
  iread(dp);
  103a0c:	83 ec 0c             	sub    $0xc,%esp
  103a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  103a12:	e8 6b f1 ff ff       	call   102b82 <iread>
  103a17:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
  103a1a:	83 ec 04             	sub    $0x4,%esp
  103a1d:	6a 00                	push   $0x0
  103a1f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103a22:	50                   	push   %eax
  103a23:	ff 75 f4             	pushl  -0xc(%ebp)
  103a26:	e8 28 f7 ff ff       	call   103153 <dirlookup>
  103a2b:	83 c4 10             	add    $0x10,%esp
  103a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a35:	74 50                	je     103a87 <create+0xbf>
    iput(dp);
  103a37:	83 ec 0c             	sub    $0xc,%esp
  103a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  103a3d:	e8 58 ef ff ff       	call   10299a <iput>
  103a42:	83 c4 10             	add    $0x10,%esp
    iread(ip);
  103a45:	83 ec 0c             	sub    $0xc,%esp
  103a48:	ff 75 f0             	pushl  -0x10(%ebp)
  103a4b:	e8 32 f1 ff ff       	call   102b82 <iread>
  103a50:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
  103a53:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
  103a58:	75 15                	jne    103a6f <create+0xa7>
  103a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a5d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103a61:	66 83 f8 02          	cmp    $0x2,%ax
  103a65:	75 08                	jne    103a6f <create+0xa7>
      return ip;
  103a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a6a:	e9 2b 01 00 00       	jmp    103b9a <create+0x1d2>
    iput(ip);
  103a6f:	83 ec 0c             	sub    $0xc,%esp
  103a72:	ff 75 f0             	pushl  -0x10(%ebp)
  103a75:	e8 20 ef ff ff       	call   10299a <iput>
  103a7a:	83 c4 10             	add    $0x10,%esp
    return 0;
  103a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  103a82:	e9 13 01 00 00       	jmp    103b9a <create+0x1d2>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  103a87:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
  103a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a8e:	8b 00                	mov    (%eax),%eax
  103a90:	83 ec 08             	sub    $0x8,%esp
  103a93:	52                   	push   %edx
  103a94:	50                   	push   %eax
  103a95:	e8 25 ee ff ff       	call   1028bf <ialloc>
  103a9a:	83 c4 10             	add    $0x10,%esp
  103a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103aa0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103aa4:	75 0d                	jne    103ab3 <create+0xeb>
    panic("create: ialloc");
  103aa6:	83 ec 0c             	sub    $0xc,%esp
  103aa9:	68 00 45 10 00       	push   $0x104500
  103aae:	e8 06 c8 ff ff       	call   1002b9 <panic>

  iread(ip);
  103ab3:	83 ec 0c             	sub    $0xc,%esp
  103ab6:	ff 75 f0             	pushl  -0x10(%ebp)
  103ab9:	e8 c4 f0 ff ff       	call   102b82 <iread>
  103abe:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
  103ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ac4:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
  103ac8:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
  103acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103acf:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
  103ad3:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
  103ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ada:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
  103ae0:	83 ec 0c             	sub    $0xc,%esp
  103ae3:	ff 75 f0             	pushl  -0x10(%ebp)
  103ae6:	e8 1f ef ff ff       	call   102a0a <iupdate>
  103aeb:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
  103aee:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
  103af3:	75 6a                	jne    103b5f <create+0x197>
    dp->nlink++;  // for ".."
  103af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103af8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103afc:	83 c0 01             	add    $0x1,%eax
  103aff:	89 c2                	mov    %eax,%edx
  103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b04:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  103b08:	83 ec 0c             	sub    $0xc,%esp
  103b0b:	ff 75 f4             	pushl  -0xc(%ebp)
  103b0e:	e8 f7 ee ff ff       	call   102a0a <iupdate>
  103b13:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  103b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b19:	8b 40 04             	mov    0x4(%eax),%eax
  103b1c:	83 ec 04             	sub    $0x4,%esp
  103b1f:	50                   	push   %eax
  103b20:	68 da 44 10 00       	push   $0x1044da
  103b25:	ff 75 f0             	pushl  -0x10(%ebp)
  103b28:	e8 e4 f6 ff ff       	call   103211 <dirlink>
  103b2d:	83 c4 10             	add    $0x10,%esp
  103b30:	85 c0                	test   %eax,%eax
  103b32:	78 1e                	js     103b52 <create+0x18a>
  103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b37:	8b 40 04             	mov    0x4(%eax),%eax
  103b3a:	83 ec 04             	sub    $0x4,%esp
  103b3d:	50                   	push   %eax
  103b3e:	68 dc 44 10 00       	push   $0x1044dc
  103b43:	ff 75 f0             	pushl  -0x10(%ebp)
  103b46:	e8 c6 f6 ff ff       	call   103211 <dirlink>
  103b4b:	83 c4 10             	add    $0x10,%esp
  103b4e:	85 c0                	test   %eax,%eax
  103b50:	79 0d                	jns    103b5f <create+0x197>
      panic("create dots");
  103b52:	83 ec 0c             	sub    $0xc,%esp
  103b55:	68 0f 45 10 00       	push   $0x10450f
  103b5a:	e8 5a c7 ff ff       	call   1002b9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
  103b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b62:	8b 40 04             	mov    0x4(%eax),%eax
  103b65:	83 ec 04             	sub    $0x4,%esp
  103b68:	50                   	push   %eax
  103b69:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103b6c:	50                   	push   %eax
  103b6d:	ff 75 f4             	pushl  -0xc(%ebp)
  103b70:	e8 9c f6 ff ff       	call   103211 <dirlink>
  103b75:	83 c4 10             	add    $0x10,%esp
  103b78:	85 c0                	test   %eax,%eax
  103b7a:	79 0d                	jns    103b89 <create+0x1c1>
    panic("create: dirlink");
  103b7c:	83 ec 0c             	sub    $0xc,%esp
  103b7f:	68 1b 45 10 00       	push   $0x10451b
  103b84:	e8 30 c7 ff ff       	call   1002b9 <panic>

  iput(dp);
  103b89:	83 ec 0c             	sub    $0xc,%esp
  103b8c:	ff 75 f4             	pushl  -0xc(%ebp)
  103b8f:	e8 06 ee ff ff       	call   10299a <iput>
  103b94:	83 c4 10             	add    $0x10,%esp

  return ip;
  103b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103b9a:	c9                   	leave  
  103b9b:	c3                   	ret    

00103b9c <open>:


struct file*
open(char* path, int omode)
{
  103b9c:	f3 0f 1e fb          	endbr32 
  103ba0:	55                   	push   %ebp
  103ba1:	89 e5                	mov    %esp,%ebp
  103ba3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  103ba6:	e8 f4 03 00 00       	call   103f9f <begin_op>

  if(omode & O_CREATE){
  103bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  103bae:	25 00 02 00 00       	and    $0x200,%eax
  103bb3:	85 c0                	test   %eax,%eax
  103bb5:	74 29                	je     103be0 <open+0x44>
    ip = create(path, T_FILE, 0, 0);
  103bb7:	6a 00                	push   $0x0
  103bb9:	6a 00                	push   $0x0
  103bbb:	6a 02                	push   $0x2
  103bbd:	ff 75 08             	pushl  0x8(%ebp)
  103bc0:	e8 03 fe ff ff       	call   1039c8 <create>
  103bc5:	83 c4 10             	add    $0x10,%esp
  103bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
  103bcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bcf:	75 73                	jne    103c44 <open+0xa8>
      end_op();
  103bd1:	e8 d3 03 00 00       	call   103fa9 <end_op>
      return 0;
  103bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  103bdb:	e9 eb 00 00 00       	jmp    103ccb <open+0x12f>
    }
  } else {
    if((ip = namei(path)) == 0){
  103be0:	83 ec 0c             	sub    $0xc,%esp
  103be3:	ff 75 08             	pushl  0x8(%ebp)
  103be6:	e8 95 f8 ff ff       	call   103480 <namei>
  103beb:	83 c4 10             	add    $0x10,%esp
  103bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bf5:	75 0f                	jne    103c06 <open+0x6a>
      end_op();
  103bf7:	e8 ad 03 00 00       	call   103fa9 <end_op>
      return 0;
  103bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  103c01:	e9 c5 00 00 00       	jmp    103ccb <open+0x12f>
    }
    iread(ip);
  103c06:	83 ec 0c             	sub    $0xc,%esp
  103c09:	ff 75 f4             	pushl  -0xc(%ebp)
  103c0c:	e8 71 ef ff ff       	call   102b82 <iread>
  103c11:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
  103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c17:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103c1b:	66 83 f8 01          	cmp    $0x1,%ax
  103c1f:	75 23                	jne    103c44 <open+0xa8>
  103c21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103c25:	74 1d                	je     103c44 <open+0xa8>
      iput(ip);
  103c27:	83 ec 0c             	sub    $0xc,%esp
  103c2a:	ff 75 f4             	pushl  -0xc(%ebp)
  103c2d:	e8 68 ed ff ff       	call   10299a <iput>
  103c32:	83 c4 10             	add    $0x10,%esp
      end_op();
  103c35:	e8 6f 03 00 00       	call   103fa9 <end_op>
      return 0;
  103c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  103c3f:	e9 87 00 00 00       	jmp    103ccb <open+0x12f>
    }
  }

  struct file* f;
  if((f = filealloc()) == 0) { 
  103c44:	e8 76 f8 ff ff       	call   1034bf <filealloc>
  103c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c50:	75 1a                	jne    103c6c <open+0xd0>
    iput(ip);
  103c52:	83 ec 0c             	sub    $0xc,%esp
  103c55:	ff 75 f4             	pushl  -0xc(%ebp)
  103c58:	e8 3d ed ff ff       	call   10299a <iput>
  103c5d:	83 c4 10             	add    $0x10,%esp
    end_op();
  103c60:	e8 44 03 00 00       	call   103fa9 <end_op>
    return 0;
  103c65:	b8 00 00 00 00       	mov    $0x0,%eax
  103c6a:	eb 5f                	jmp    103ccb <open+0x12f>
  }

  f->type = FD_INODE;
  103c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c6f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  f->ip = ip;
  103c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103c7b:	89 50 0c             	mov    %edx,0xc(%eax)
  f->off = 0;
  103c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c81:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  f->readable = !(omode & O_WRONLY);
  103c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  103c8b:	83 e0 01             	and    $0x1,%eax
  103c8e:	85 c0                	test   %eax,%eax
  103c90:	0f 94 c0             	sete   %al
  103c93:	89 c2                	mov    %eax,%edx
  103c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c98:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  103c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  103c9e:	83 e0 01             	and    $0x1,%eax
  103ca1:	85 c0                	test   %eax,%eax
  103ca3:	75 0a                	jne    103caf <open+0x113>
  103ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  103ca8:	83 e0 02             	and    $0x2,%eax
  103cab:	85 c0                	test   %eax,%eax
  103cad:	74 07                	je     103cb6 <open+0x11a>
  103caf:	b8 01 00 00 00       	mov    $0x1,%eax
  103cb4:	eb 05                	jmp    103cbb <open+0x11f>
  103cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  103cbb:	89 c2                	mov    %eax,%edx
  103cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cc0:	88 50 09             	mov    %dl,0x9(%eax)
  end_op();
  103cc3:	e8 e1 02 00 00       	call   103fa9 <end_op>
  return f;
  103cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103ccb:	c9                   	leave  
  103ccc:	c3                   	ret    

00103ccd <mkdir>:

int mkdir(char *path)
{
  103ccd:	f3 0f 1e fb          	endbr32 
  103cd1:	55                   	push   %ebp
  103cd2:	89 e5                	mov    %esp,%ebp
  103cd4:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  103cd7:	e8 c3 02 00 00       	call   103f9f <begin_op>
  if((ip = create(path, T_DIR, 0, 0)) == 0){
  103cdc:	6a 00                	push   $0x0
  103cde:	6a 00                	push   $0x0
  103ce0:	6a 01                	push   $0x1
  103ce2:	ff 75 08             	pushl  0x8(%ebp)
  103ce5:	e8 de fc ff ff       	call   1039c8 <create>
  103cea:	83 c4 10             	add    $0x10,%esp
  103ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103cf4:	75 0c                	jne    103d02 <mkdir+0x35>
    end_op();
  103cf6:	e8 ae 02 00 00       	call   103fa9 <end_op>
    return -1;
  103cfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103d00:	eb 18                	jmp    103d1a <mkdir+0x4d>
  }
  iput(ip);
  103d02:	83 ec 0c             	sub    $0xc,%esp
  103d05:	ff 75 f4             	pushl  -0xc(%ebp)
  103d08:	e8 8d ec ff ff       	call   10299a <iput>
  103d0d:	83 c4 10             	add    $0x10,%esp
  end_op();
  103d10:	e8 94 02 00 00       	call   103fa9 <end_op>
  return 0;
  103d15:	b8 00 00 00 00       	mov    $0x0,%eax
  103d1a:	c9                   	leave  
  103d1b:	c3                   	ret    

00103d1c <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
  103d1c:	f3 0f 1e fb          	endbr32 
  103d20:	55                   	push   %ebp
  103d21:	89 e5                	mov    %esp,%ebp
  103d23:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  readsb(dev, &sb);
  103d26:	83 ec 08             	sub    $0x8,%esp
  103d29:	8d 45 dc             	lea    -0x24(%ebp),%eax
  103d2c:	50                   	push   %eax
  103d2d:	ff 75 08             	pushl  0x8(%ebp)
  103d30:	e8 69 e8 ff ff       	call   10259e <readsb>
  103d35:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
  103d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d3b:	a3 40 c6 10 00       	mov    %eax,0x10c640
  log.size = sb.nlog;
  103d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103d43:	a3 44 c6 10 00       	mov    %eax,0x10c644
  log.dev = dev;
  103d48:	8b 45 08             	mov    0x8(%ebp),%eax
  103d4b:	a3 4c c6 10 00       	mov    %eax,0x10c64c
  recover_from_log();
  103d50:	e8 24 02 00 00       	call   103f79 <recover_from_log>
}
  103d55:	90                   	nop
  103d56:	c9                   	leave  
  103d57:	c3                   	ret    

00103d58 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
  103d58:	f3 0f 1e fb          	endbr32 
  103d5c:	55                   	push   %ebp
  103d5d:	89 e5                	mov    %esp,%ebp
  103d5f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  103d62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103d69:	eb 44                	jmp    103daf <install_trans+0x57>
    if (LOG_FLAG == 5) {
      if (tail == log.lh.n/2) panic("[UNDOLOG] Panic in install_trans type 5");
    }
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
  103d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d6e:	83 c0 04             	add    $0x4,%eax
  103d71:	8b 04 85 44 c6 10 00 	mov    0x10c644(,%eax,4),%eax
  103d78:	89 c2                	mov    %eax,%edx
  103d7a:	a1 4c c6 10 00       	mov    0x10c64c,%eax
  103d7f:	83 ec 08             	sub    $0x8,%esp
  103d82:	52                   	push   %edx
  103d83:	50                   	push   %eax
  103d84:	e8 c3 e2 ff ff       	call   10204c <bread>
  103d89:	83 c4 10             	add    $0x10,%esp
  103d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    bwrite(dbuf);  // write dst to disk
  103d8f:	83 ec 0c             	sub    $0xc,%esp
  103d92:	ff 75 f0             	pushl  -0x10(%ebp)
  103d95:	e8 ef e2 ff ff       	call   102089 <bwrite>
  103d9a:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
  103d9d:	83 ec 0c             	sub    $0xc,%esp
  103da0:	ff 75 f0             	pushl  -0x10(%ebp)
  103da3:	e8 56 e3 ff ff       	call   1020fe <brelse>
  103da8:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  103dab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103daf:	a1 50 c6 10 00       	mov    0x10c650,%eax
  103db4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103db7:	7c b2                	jl     103d6b <install_trans+0x13>
  }
}
  103db9:	90                   	nop
  103dba:	90                   	nop
  103dbb:	c9                   	leave  
  103dbc:	c3                   	ret    

00103dbd <our_install_trans>:

static void
our_install_trans(void)
{
  103dbd:	f3 0f 1e fb          	endbr32 
  103dc1:	55                   	push   %ebp
  103dc2:	89 e5                	mov    %esp,%ebp
  103dc4:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  103dc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103dce:	e9 95 00 00 00       	jmp    103e68 <our_install_trans+0xab>
    if (LOG_FLAG == 5) {
      if (tail == log.lh.n/2) panic("[UNDOLOG] Panic in install_trans type 5");
    }
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
  103dd3:	8b 15 40 c6 10 00    	mov    0x10c640,%edx
  103dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ddc:	01 d0                	add    %edx,%eax
  103dde:	83 c0 01             	add    $0x1,%eax
  103de1:	89 c2                	mov    %eax,%edx
  103de3:	a1 4c c6 10 00       	mov    0x10c64c,%eax
  103de8:	83 ec 08             	sub    $0x8,%esp
  103deb:	52                   	push   %edx
  103dec:	50                   	push   %eax
  103ded:	e8 5a e2 ff ff       	call   10204c <bread>
  103df2:	83 c4 10             	add    $0x10,%esp
  103df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
  103df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dfb:	83 c0 04             	add    $0x4,%eax
  103dfe:	8b 04 85 44 c6 10 00 	mov    0x10c644(,%eax,4),%eax
  103e05:	89 c2                	mov    %eax,%edx
  103e07:	a1 4c c6 10 00       	mov    0x10c64c,%eax
  103e0c:	83 ec 08             	sub    $0x8,%esp
  103e0f:	52                   	push   %edx
  103e10:	50                   	push   %eax
  103e11:	e8 36 e2 ff ff       	call   10204c <bread>
  103e16:	83 c4 10             	add    $0x10,%esp
  103e19:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
  103e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e1f:	8d 50 1c             	lea    0x1c(%eax),%edx
  103e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e25:	83 c0 1c             	add    $0x1c,%eax
  103e28:	83 ec 04             	sub    $0x4,%esp
  103e2b:	68 00 02 00 00       	push   $0x200
  103e30:	52                   	push   %edx
  103e31:	50                   	push   %eax
  103e32:	e8 a0 d1 ff ff       	call   100fd7 <memmove>
  103e37:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
  103e3a:	83 ec 0c             	sub    $0xc,%esp
  103e3d:	ff 75 ec             	pushl  -0x14(%ebp)
  103e40:	e8 44 e2 ff ff       	call   102089 <bwrite>
  103e45:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
  103e48:	83 ec 0c             	sub    $0xc,%esp
  103e4b:	ff 75 f0             	pushl  -0x10(%ebp)
  103e4e:	e8 ab e2 ff ff       	call   1020fe <brelse>
  103e53:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
  103e56:	83 ec 0c             	sub    $0xc,%esp
  103e59:	ff 75 ec             	pushl  -0x14(%ebp)
  103e5c:	e8 9d e2 ff ff       	call   1020fe <brelse>
  103e61:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  103e64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103e68:	a1 50 c6 10 00       	mov    0x10c650,%eax
  103e6d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103e70:	0f 8c 5d ff ff ff    	jl     103dd3 <our_install_trans+0x16>
  }
}
  103e76:	90                   	nop
  103e77:	90                   	nop
  103e78:	c9                   	leave  
  103e79:	c3                   	ret    

00103e7a <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  103e7a:	f3 0f 1e fb          	endbr32 
  103e7e:	55                   	push   %ebp
  103e7f:	89 e5                	mov    %esp,%ebp
  103e81:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  103e84:	a1 40 c6 10 00       	mov    0x10c640,%eax
  103e89:	89 c2                	mov    %eax,%edx
  103e8b:	a1 4c c6 10 00       	mov    0x10c64c,%eax
  103e90:	83 ec 08             	sub    $0x8,%esp
  103e93:	52                   	push   %edx
  103e94:	50                   	push   %eax
  103e95:	e8 b2 e1 ff ff       	call   10204c <bread>
  103e9a:	83 c4 10             	add    $0x10,%esp
  103e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
  103ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ea3:	83 c0 1c             	add    $0x1c,%eax
  103ea6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
  103ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103eac:	8b 00                	mov    (%eax),%eax
  103eae:	a3 50 c6 10 00       	mov    %eax,0x10c650
  for (i = 0; i < log.lh.n; i++) {
  103eb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103eba:	eb 1b                	jmp    103ed7 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
  103ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ec2:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
  103ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103ec9:	83 c2 04             	add    $0x4,%edx
  103ecc:	89 04 95 44 c6 10 00 	mov    %eax,0x10c644(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  103ed3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103ed7:	a1 50 c6 10 00       	mov    0x10c650,%eax
  103edc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103edf:	7c db                	jl     103ebc <read_head+0x42>
  }
  brelse(buf);
  103ee1:	83 ec 0c             	sub    $0xc,%esp
  103ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  103ee7:	e8 12 e2 ff ff       	call   1020fe <brelse>
  103eec:	83 c4 10             	add    $0x10,%esp
}
  103eef:	90                   	nop
  103ef0:	c9                   	leave  
  103ef1:	c3                   	ret    

00103ef2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  103ef2:	f3 0f 1e fb          	endbr32 
  103ef6:	55                   	push   %ebp
  103ef7:	89 e5                	mov    %esp,%ebp
  103ef9:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  103efc:	a1 40 c6 10 00       	mov    0x10c640,%eax
  103f01:	89 c2                	mov    %eax,%edx
  103f03:	a1 4c c6 10 00       	mov    0x10c64c,%eax
  103f08:	83 ec 08             	sub    $0x8,%esp
  103f0b:	52                   	push   %edx
  103f0c:	50                   	push   %eax
  103f0d:	e8 3a e1 ff ff       	call   10204c <bread>
  103f12:	83 c4 10             	add    $0x10,%esp
  103f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
  103f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f1b:	83 c0 1c             	add    $0x1c,%eax
  103f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
  103f21:	8b 15 50 c6 10 00    	mov    0x10c650,%edx
  103f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f2a:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
  103f2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103f33:	eb 1b                	jmp    103f50 <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
  103f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f38:	83 c0 04             	add    $0x4,%eax
  103f3b:	8b 0c 85 44 c6 10 00 	mov    0x10c644(,%eax,4),%ecx
  103f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103f48:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  103f4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103f50:	a1 50 c6 10 00       	mov    0x10c650,%eax
  103f55:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103f58:	7c db                	jl     103f35 <write_head+0x43>
  }
  bwrite(buf);
  103f5a:	83 ec 0c             	sub    $0xc,%esp
  103f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  103f60:	e8 24 e1 ff ff       	call   102089 <bwrite>
  103f65:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
  103f68:	83 ec 0c             	sub    $0xc,%esp
  103f6b:	ff 75 f0             	pushl  -0x10(%ebp)
  103f6e:	e8 8b e1 ff ff       	call   1020fe <brelse>
  103f73:	83 c4 10             	add    $0x10,%esp
}
  103f76:	90                   	nop
  103f77:	c9                   	leave  
  103f78:	c3                   	ret    

00103f79 <recover_from_log>:

static void
recover_from_log(void)
{
  103f79:	f3 0f 1e fb          	endbr32 
  103f7d:	55                   	push   %ebp
  103f7e:	89 e5                	mov    %esp,%ebp
  103f80:	83 ec 08             	sub    $0x8,%esp
  read_head();
  103f83:	e8 f2 fe ff ff       	call   103e7a <read_head>
  our_install_trans(); // if committed, copy from log to disk
  103f88:	e8 30 fe ff ff       	call   103dbd <our_install_trans>
  log.lh.n = 0;
  103f8d:	c7 05 50 c6 10 00 00 	movl   $0x0,0x10c650
  103f94:	00 00 00 
  write_head(); // clear the log
  103f97:	e8 56 ff ff ff       	call   103ef2 <write_head>
}
  103f9c:	90                   	nop
  103f9d:	c9                   	leave  
  103f9e:	c3                   	ret    

00103f9f <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
  103f9f:	f3 0f 1e fb          	endbr32 
  103fa3:	55                   	push   %ebp
  103fa4:	89 e5                	mov    %esp,%ebp
  
}
  103fa6:	90                   	nop
  103fa7:	5d                   	pop    %ebp
  103fa8:	c3                   	ret    

00103fa9 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  103fa9:	f3 0f 1e fb          	endbr32 
  103fad:	55                   	push   %ebp
  103fae:	89 e5                	mov    %esp,%ebp
  103fb0:	83 ec 08             	sub    $0x8,%esp
  // call commit w/o holding locks, since not allowed
  // to sleep with locks.
  commit();
  103fb3:	e8 03 00 00 00       	call   103fbb <commit>
}
  103fb8:	90                   	nop
  103fb9:	c9                   	leave  
  103fba:	c3                   	ret    

00103fbb <commit>:

/* DO NOT MODIFY THIS FUNCTION*/
static void
commit()
{
  103fbb:	f3 0f 1e fb          	endbr32 
  103fbf:	55                   	push   %ebp
  103fc0:	89 e5                	mov    %esp,%ebp
  103fc2:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
  103fc5:	a1 50 c6 10 00       	mov    0x10c650,%eax
  103fca:	85 c0                	test   %eax,%eax
  103fcc:	7e 19                	jle    103fe7 <commit+0x2c>
    if (PANIC_1) {
      panic("[UNDOLOG] Panic in commit type 1");
    }
    write_head();    // Write header to disk 
  103fce:	e8 1f ff ff ff       	call   103ef2 <write_head>
    if (PANIC_2) {
      panic("[UNDOLOG] Panic in commit type 2");
    }
    install_trans(); // Now install writes to home locations    
  103fd3:	e8 80 fd ff ff       	call   103d58 <install_trans>
    if (PANIC_3) {
      panic("[UNDOLOG] Panic in commit type 3");
    }
    log.lh.n = 0;
  103fd8:	c7 05 50 c6 10 00 00 	movl   $0x0,0x10c650
  103fdf:	00 00 00 
    write_head();    // Erase the transaction from the log 
  103fe2:	e8 0b ff ff ff       	call   103ef2 <write_head>
    if (PANIC_4) {
      panic("[UNDOLOG] Panic in commit type 4");
    }  
  }
}
  103fe7:	90                   	nop
  103fe8:	c9                   	leave  
  103fe9:	c3                   	ret    

00103fea <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
  103fea:	f3 0f 1e fb          	endbr32 
  103fee:	55                   	push   %ebp
  103fef:	89 e5                	mov    %esp,%ebp
  103ff1:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
  103ff4:	a1 50 c6 10 00       	mov    0x10c650,%eax
  103ff9:	83 f8 1d             	cmp    $0x1d,%eax
  103ffc:	7f 12                	jg     104010 <log_write+0x26>
  103ffe:	a1 50 c6 10 00       	mov    0x10c650,%eax
  104003:	8b 15 44 c6 10 00    	mov    0x10c644,%edx
  104009:	83 ea 01             	sub    $0x1,%edx
  10400c:	39 d0                	cmp    %edx,%eax
  10400e:	7c 0d                	jl     10401d <log_write+0x33>
    panic("too big a transaction");
  104010:	83 ec 0c             	sub    $0xc,%esp
  104013:	68 2b 45 10 00       	push   $0x10452b
  104018:	e8 9c c2 ff ff       	call   1002b9 <panic>

  for (i = 0; i < log.lh.n; i++) {
  10401d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104024:	eb 1d                	jmp    104043 <log_write+0x59>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
  104026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104029:	83 c0 04             	add    $0x4,%eax
  10402c:	8b 04 85 44 c6 10 00 	mov    0x10c644(,%eax,4),%eax
  104033:	89 c2                	mov    %eax,%edx
  104035:	8b 45 08             	mov    0x8(%ebp),%eax
  104038:	8b 40 08             	mov    0x8(%eax),%eax
  10403b:	39 c2                	cmp    %eax,%edx
  10403d:	74 10                	je     10404f <log_write+0x65>
  for (i = 0; i < log.lh.n; i++) {
  10403f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104043:	a1 50 c6 10 00       	mov    0x10c650,%eax
  104048:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10404b:	7c d9                	jl     104026 <log_write+0x3c>
  10404d:	eb 01                	jmp    104050 <log_write+0x66>
      break;
  10404f:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
  104050:	8b 45 08             	mov    0x8(%ebp),%eax
  104053:	8b 40 08             	mov    0x8(%eax),%eax
  104056:	89 c2                	mov    %eax,%edx
  104058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10405b:	83 c0 04             	add    $0x4,%eax
  10405e:	89 14 85 44 c6 10 00 	mov    %edx,0x10c644(,%eax,4)
  if (i == log.lh.n)
  104065:	a1 50 c6 10 00       	mov    0x10c650,%eax
  10406a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10406d:	75 0d                	jne    10407c <log_write+0x92>
    log.lh.n++;
  10406f:	a1 50 c6 10 00       	mov    0x10c650,%eax
  104074:	83 c0 01             	add    $0x1,%eax
  104077:	a3 50 c6 10 00       	mov    %eax,0x10c650
  b->flags |= B_DIRTY; // prevent eviction
  10407c:	8b 45 08             	mov    0x8(%ebp),%eax
  10407f:	8b 00                	mov    (%eax),%eax
  104081:	83 c8 04             	or     $0x4,%eax
  104084:	89 c2                	mov    %eax,%edx
  104086:	8b 45 08             	mov    0x8(%ebp),%eax
  104089:	89 10                	mov    %edx,(%eax)
}
  10408b:	90                   	nop
  10408c:	c9                   	leave  
  10408d:	c3                   	ret    

0010408e <our_bread>:

void 
our_bread(struct buf *b) {
  10408e:	f3 0f 1e fb          	endbr32 
  104092:	55                   	push   %ebp
  104093:	89 e5                	mov    %esp,%ebp
  104095:	83 ec 18             	sub    $0x18,%esp
  struct buf * bcopy = bread(log.dev, log.start + log.lh.n + 1);
  104098:	8b 15 40 c6 10 00    	mov    0x10c640,%edx
  10409e:	a1 50 c6 10 00       	mov    0x10c650,%eax
  1040a3:	01 d0                	add    %edx,%eax
  1040a5:	83 c0 01             	add    $0x1,%eax
  1040a8:	89 c2                	mov    %eax,%edx
  1040aa:	a1 4c c6 10 00       	mov    0x10c64c,%eax
  1040af:	83 ec 08             	sub    $0x8,%esp
  1040b2:	52                   	push   %edx
  1040b3:	50                   	push   %eax
  1040b4:	e8 93 df ff ff       	call   10204c <bread>
  1040b9:	83 c4 10             	add    $0x10,%esp
  1040bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(bcopy->data, b->data, BSIZE);
  1040bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1040c2:	8d 50 1c             	lea    0x1c(%eax),%edx
  1040c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040c8:	83 c0 1c             	add    $0x1c,%eax
  1040cb:	83 ec 04             	sub    $0x4,%esp
  1040ce:	68 00 02 00 00       	push   $0x200
  1040d3:	52                   	push   %edx
  1040d4:	50                   	push   %eax
  1040d5:	e8 fd ce ff ff       	call   100fd7 <memmove>
  1040da:	83 c4 10             	add    $0x10,%esp
  bwrite(bcopy);
  1040dd:	83 ec 0c             	sub    $0xc,%esp
  1040e0:	ff 75 f4             	pushl  -0xc(%ebp)
  1040e3:	e8 a1 df ff ff       	call   102089 <bwrite>
  1040e8:	83 c4 10             	add    $0x10,%esp
  brelse(bcopy);
  1040eb:	83 ec 0c             	sub    $0xc,%esp
  1040ee:	ff 75 f4             	pushl  -0xc(%ebp)
  1040f1:	e8 08 e0 ff ff       	call   1020fe <brelse>
  1040f6:	83 c4 10             	add    $0x10,%esp
  1040f9:	90                   	nop
  1040fa:	c9                   	leave  
  1040fb:	c3                   	ret    
