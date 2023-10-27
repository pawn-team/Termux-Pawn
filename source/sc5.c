/*  Pawn compiler - Error message system
 *  In fact a very simple system, using only 'panic mode'.
 *
 *  Copyright (c) ITB CompuPhase, 1997-2006
 *
 *  This software is provided "as-is", without any express or implied warranty.
 *  In no event will the authors be held liable for any damages arising from
 *  the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, subject to the following restrictions:
 *
 *  1.  The origin of this software must not be misrepresented; you must not
 *      claim that you wrote the original software. If you use this software in
 *      a product, an acknowledgment in the product documentation would be
 *      appreciated but is not required.
 *  2.  Altered source versions must be plainly marked as such, and must not be
 *      misrepresented as being the original software.
 *  3.  This notice may not be removed or altered from any source distribution.
 *
 *  Version: $Id: sc5.c 3579 2006-06-06 13:35:29Z thiadmer $
 */

#include <assert.h>
#if defined	__WIN32__ || defined _WIN32 || defined __MSDOS__
  #include <io.h>
#endif
#if defined LINUX || defined __GNUC__
  #include <unistd.h>
#endif
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>     /* ANSI standardized variable argument list functions */
#include <string.h>
#if defined FORTIFY
  #include <alloc/fortify.h>
#endif
#include "sc.h"

static char *errmsg[] = {
/*001*/  "token esperado: \"%s\", mas encontrado \"%s\"\n",
/*002*/  "apenas um unico comando (ou expressao) pode seguir cada \"case\"\n",
/*003*/  "declaracao de uma variavel local deve aparecer em um bloco composto\n",
/*004*/  "funcao \"%s\" nao implementada\n",
/*005*/  "funcao nao pode ter argumentos\n",
/*006*/  "deve ser atribuido a um array\n",
/*007*/  "operador nao pode ser redefinido\n",
/*008*/  "deve ser uma expressao constante; assumido como zero\n",
/*009*/  "tamanho invalido de array (negativo, zero ou fora dos limites)\n",
/*010*/  "funcao ou declaracao invalida\n",
/*011*/  "deslocamento da pilha/endereco de dados deve ser multiplo do tamanho da celula\n",
/*012*/  "chamada de funcao invalida, nao e um endereco valido\n",
/*013*/  "sem ponto de entrada (nenhuma funcao publica)\n",
/*014*/  "declaracao invalida; nao esta em um switch\n",
/*015*/  "caso \"default\" deve ser o ultimo caso na declaracao switch\n",
/*016*/  "multiplos \"default\" em \"switch\"\n",
/*017*/  "simbolo \"%s\" indefinido\n",
/*018*/  "dados de inicializacao excedem o tamanho declarado\n",
/*019*/  "nao e um rotulo: \"%s\"\n",
/*020*/  "nome de simbolo invalido \"%s\"\n",
/*021*/  "simbolo ja definido: \"%s\"\n",
/*022*/  "deve ser lvalue (nao constante)\n",
/*023*/  "atribuicao de array deve ser atribuicao simples\n",
/*024*/  "\"break\" ou \"continue\" estao fora de contexto\n",
/*025*/  "cabecalho da funcao difere do prototipo\n",
/*026*/  "nenhum \"#if...\" correspondente\n",
/*027*/  "constante de caractere invalida\n",
/*028*/  "subscrito invalido (nao e um array ou muitos subscritos): \"%s\"\n",
/*029*/  "expressao invalida, assumida como zero\n",
/*030*/  "declaracao composta nao foi fechada no final do arquivo (iniciada na linha %d)\n",
/*031*/  "diretiva desconhecida\n",
/*032*/  "indice de array fora dos limites (variavel \"%s\")\n",
/*033*/  "array deve ser indexado (variavel \"%s\")\n",
/*034*/  "argumento nao possui um valor padrao (argumento %d)\n",
/*035*/  "incompatibilidade de tipo de argumento (argumento %d)\n",
/*036*/  "declaracao vazia\n",
/*037*/  "string invalida (possivelmente string nao terminada)\n",
/*038*/  "caracteres extras na linha\n",
/*039*/  "simbolo constante nao possui tamanho\n",
/*040*/  "rotulo \"case\" duplicado (valor %d)\n",
/*041*/  "reticencias invalidas, tamanho do array nao e conhecido\n",
/*042*/  "combinacao invalida de especificadores de classe\n",
/*043*/  "constante de caractere excede o intervalo para string compactada\n",
/*044*/  "parametros posicionais devem preceder todos os parametros nomeados\n",
/*045*/  "muitos argumentos de funcao\n",
/*046*/  "tamanho de array desconhecido (variavel \"%s\")\n",
/*047*/  "tamanhos de array nao correspondem, ou array de destino e muito pequeno\n",
/*048*/  "dimensoes de array nao correspondem\n",
/*049*/  "continuacao de linha invalida\n",
/*050*/  "intervalo invalido\n",
/*051*/  "subscrito invalido, use operadores \"[ ]\" nas dimensoes principais\n",
/*052*/  "arrays multidimensionais devem ser completamente inicializados\n",
/*053*/  "excedendo o numero maximo de dimensoes\n",
/*054*/  "chave de fechamento nao correspondente (\"}\")\n",
/*055*/  "inicio do corpo da funcao sem cabecalho de funcao\n",
/*056*/  "arrays, variaveis locais e argumentos de funcao nao podem ser publicos (variavel \"%s\")\n",
/*057*/  "expressao inacabada antes da diretiva do compilador\n",
/*058*/  "argumento duplicado; mesmo argumento e passado duas vezes\n",
/*059*/  "argumento de funcao nao pode ter um valor padrao (variavel \"%s\")\n",
/*060*/  "multiplas diretivas \"#else\" entre \"#if ... #endif\"\n",
/*061*/  "diretiva \"#elseif\" segue uma diretiva \"#else\"\n",
/*062*/  "numero de operandos nao corresponde ao operador\n",
/*063*/  "tag de resultado de funcao do operador \"%s\" deve ser \"%s\"\n",
/*064*/  "nao e possivel alterar operadores predefinidos\n",
/*065*/  "argumento de funcao pode ter apenas uma unica tag (argumento %d)\n",
/*066*/  "argumento de funcao nao pode ser um argumento de referencia ou um array (argumento \"%s\")\n",
/*067*/  "variavel nao pode ser uma referencia e um array ao mesmo tempo (variavel \"%s\")\n",
/*068*/  "precisao invalida de numero racional em #pragma\n",
/*069*/  "formato de numero racional ja definido\n",
/*070*/  "suporte a numeros racionais nao foi habilitado\n",
/*071*/  "operador definido pelo usuario deve ser declarado antes do uso (funcao \"%s\")\n",
/*072*/  "operador \"sizeof\" e invalido em simbolos \"funcao\"\n",
/*073*/  "argumento de funcao deve ser um array (argumento \"%s\")\n",
/*074*/  "padrao #define deve comecar com um caractere alfabetico\n",
/*075*/  "linha de entrada muito longa (apos substituicoes)\n",
/*076*/  "erro de sintaxe na expressao, ou chamada de funcao invalida\n",
/*077*/  "codificacao UTF-8 malformada, ou arquivo corrompido: %s\n",
/*078*/  "funcao usa tanto \"return\" quanto \"return <valor>\"\n",
/*079*/  "tipos de retorno inconsistentes (array e nao-array)\n",
/*080*/  "simbolo desconhecido, ou nao e um simbolo constante (simbolo \"%s\")\n",
/*081*/  "nao e possivel usar uma tag como valor padrao para um parametro de array indexado (simbolo \"%s\")\n",
/*082*/  "operadores definidos pelo usuario e funcoes nativas nao podem ter estados\n",
/*083*/  "uma funcao ou variavel so pode pertencer a um unico automato (simbolo \"%s\")\n",
/*084*/  "conflito de estado: um dos estados ja esta atribuido a outra implementacao (simbolo \"%s\")\n",
/*085*/  "nenhum estado definido para o simbolo \"%s\"\n",
/*086*/  "automato desconhecido \"%s\"\n",
/*087*/  "estado desconhecido \"%s\" para o automato \"%s\"\n",
/*088*/  "variaveis publicas e variaveis locais nao podem ter estados (simbolo \"%s\")\n",
/*089*/  "variaveis de estado nao podem ser inicializadas (simbolo \"%s\")\n",
/*090*/  "funcoes publicas nao podem retornar arrays (simbolo \"%s\")\n",
/*091*/  "constante ambigua; substituicao de tag e necessaria (simbolo \"%s\")\n",
/*092*/  "funcoes nao podem retornar arrays de tamanho desconhecido (simbolo \"%s\")\n",
/*093*/  "operador \"__addressof\" e invalido em expressoes de pre-processamento\n"
};

static char *fatalmsg[] = {
/*100*/  "nao foi possivel ler do arquivo: \"%s\"\n",
/*101*/  "nao foi possivel escrever no arquivo: \"%s\"\n",
/*102*/  "estouro de tabela: \"%s\"\n",
	/* a tabela pode ser: tabela de loop
 	 *                      tabela literal
	 *                      buffer de estágio
	 *                      tabela de opções (arquivo de resposta)
	 *                      tabela otimizadora de buracos de fechadura
	 */
/*103*/  "memoria insuficiente\n",
/*104*/  "instrução de montador invalida \"%s\"\n",
/*105*/  "estouro numerico, excedendo a capacidade\n",
/*106*/  "script compilado excede o tamanho maximo de memoria (%ld bytes)\n",
/*107*/  "muitas mensagens de erro em uma unica linha\n",
/*108*/  "arquivo de mapeamento de pagina de codigo nao encontrado\n",
/*109*/  "caminho invalido: \"%s\"\n",
/*110*/  "falha na assertiva: %s\n",
/*111*/  "erro personalizado: %s\n"
};

static char *warnmsg[] = {
/*200*/  "simbolo \"%s\" e reduzido para %d caracteres\n",
/*201*/  "redefinicao de constantes/macro (simbolo \"%s\")\n",
/*202*/  "numero de argumentos nao corresponde a definicao\n",
/*203*/  "simbolo nao foi utilizado: \"%s\"\n",
/*204*/  "simbolo recebe um valor que nao e utilizado: \"%s\"\n",
/*205*/  "codigo desnecessario: expressao constante e zero\n",
/*206*/  "teste desnecessario: expressao constante e diferente de zero\n",
/*207*/  "instrucao #pragma desconhecida\n",
/*208*/  "funcao com retorno de tag usado antes da definicao, forçando recompilacao\n",
/*209*/  "funcao \"%s\" deve retornar um valor\n",
/*210*/  "possivel uso de simbolo antes da inicializacao: \"%s\"\n",
/*211*/  "atribuicao de valor possivelmente nao intencional\n",
/*212*/  "operacao de bits possivelmente nao intencional\n",
/*213*/  "tag incompativel: esperava %s %s mas encontrei %s\n",
/*214*/  "possivelmente um argumento de array \"const\" era pretendido: \"%s\"\n",
/*215*/  "expressao sem efeito\n",
/*216*/  "comentario dentro de outro comentario\n",
/*217*/  "codigo desalinhado\n",
/*218*/  "prototipos de estilo antigo usados com ponto-e-virgula opcional\n",
/*219*/  "variavel local \"%s\" sobrepoe uma variavel em um nivel anterior ou global\n",
/*220*/  "expressao com substuicao de tag deve aparecer entre parenteses\n",
/*221*/  "nome do rotulo \"%s\" sobrepoe o nome da tag\n",
/*222*/  "numero de digitos excede precisao de numero racional\n",
/*223*/  "\"sizeof\" desnecessario: tamanho do argumento e sempre 1 (simbolo \"%s\")\n",
/*224*/  "tamanho de array indeterminado na expressao \"sizeof\" (simbolo \"%s\")\n",
/*225*/  "codigo inacessivel\n",
/*226*/  "uma variavel e atribuida a si mesma (simbolo \"%s\")\n",
/*227*/  "mais inicializadores que campos de enum\n",
/*228*/  "comprimento de inicializador excede tamanho do campo de enum\n",
/*229*/  "tag do indice e incompativel (simbolo \"%s\"): esperava %s mas encontrei %s\n",
/*230*/  "nenhuma implementacao para estado \"%s\" em funcao \"%s\", sem solucao alternativa\n",
/*231*/  "especificacao de estado em declaracao anterior foi ignorada\n",
/*232*/  "arquivo de saida e escrito, mas com codificacao compacta desativada\n",
/*233*/  "variavel de estado \"%s\" sobrepoe uma variavel global\n",
/*234*/  "funcao descontinuada (simbolo \"%s\") %s\n",
/*235*/  "funcao publica nao possui declaracao antecipada (simbolo \"%s\")\n",
/*236*/  "parametro desconhecido em substituicao (padrao #define incorreto)\n",
/*237*/  "aviso personalizado: %s\n",
/*238*/  "combinacao sem sentido de especificadores de classe (%s)\n",
/*239*/  "array/string literal passado a um parametro nao-constante\n"
};

static char *noticemsg[] = {
/*001*/  "; voce quis dizer \"%s\"?\n",
/*002*/  "; variavel de estado fora do escopo\n"
};

#define NUM_WARNINGS    (sizeof warnmsg / sizeof warnmsg[0])
static struct s_warnstack {
  unsigned char disable[(NUM_WARNINGS + 7) / 8]; /* 8 flags in a char */
  struct s_warnstack *next;
} warnstack;

static int errflag;
static int errstart;    /* line number at which the instruction started */
static int errline;     /* forced line number for the error message */
static int errwarn;

/*  error
 *
 *  Outputs an error message (note: msg is passed optionally).
 *  If an error is found, the variable "errflag" is set and subsequent
 *  errors are ignored until lex() finds a semicolumn or a keyword
 *  (lex() resets "errflag" in that case).
 *
 *  Global references: inpfname   (reffered to only)
 *                     fline      (reffered to only)
 *                     fcurrent   (reffered to only)
 *                     errflag    (altered)
 */
SC_FUNC int error(long number,...)
{
static char *prefix[3]={ "erro", "erro fatal", "aviso" };
static int lastline,errorcount;
static short lastfile;
  char *msg,*pre;
  va_list argptr;
  char string[128];
  int notice;

  /* split the error field between the real error/warning number and an optional
   * "notice" number
   */
  notice=(unsigned long)number >> (sizeof(long)*4);
  number&=(~(unsigned long)0) >> (sizeof(long)*4);
  assert(number>0 && number<300);

  /* errflag is reset on each semicolon.
   * In a two-pass compiler, an error should not be reported twice. Therefore
   * the error reporting is enabled only in the second pass (and only when
   * actually producing output). Fatal errors may never be ignored.
   */
  if ((errflag || sc_status!=statWRITE) && (number<100 || number>=200))
    return 0;

  /* also check for disabled warnings */
  if (number>=200) {
    int index=(number-200)/8;
    int mask=1 << ((number-200)%8);
    if ((warnstack.disable[index] & mask)!=0)
      return 0;
  } /* if */

  if (number<100) {
    assert(number>0 && number<(1+sizeof(errmsg)/sizeof(errmsg[0])));
    msg=errmsg[number-1];
    pre=prefix[0];
    errflag=TRUE;       /* set errflag (skip rest of erroneous expression) */
    errnum++;
  } else if (number<200) {
    assert(number>=100 && number<(100+sizeof(fatalmsg)/sizeof(fatalmsg[0])));
    msg=fatalmsg[number-100];
    pre=prefix[1];
    errnum++;           /* a fatal error also counts as an error */
  } else if (errwarn) {
    assert(number>=200 && number<(200+sizeof(warnmsg)/sizeof(warnmsg[0])));
    msg=warnmsg[number-200];
    pre=prefix[0];
    errflag=TRUE;
    errnum++;
  } else {
    assert(number>=200 && number<(200+sizeof(warnmsg)/sizeof(warnmsg[0])));
    msg=warnmsg[number-200];
    pre=prefix[2];
    warnnum++;
  } /* if */

  if (notice!=0) {
    assert(notice>0 && notice<(1+sizeof(noticemsg)/sizeof(noticemsg[0])) && noticemsg[notice-1][0]!='\0');
    strcpy(string,msg);
    strcpy(&string[strlen(string)-1],noticemsg[notice-1]);
    msg=string;
  } /* if */

  assert(errstart<=fline);
  if (errline>0)
    errstart=errline;
  else
    errline=fline;
  assert(errstart<=errline);
  va_start(argptr,number);
  if (errfname[0]=='\0') {
    int start=(errstart==errline) ? -1 : errstart;
    if (pc_error((int)number,msg,inpfname,start,errline,argptr)) {
      if (outf!=NULL) {
        pc_closeasm(outf,TRUE);
        outf=NULL;
      } /* if */
      longjmp(errbuf,3);        /* user abort */
    } /* if */
  } else {
    FILE *fp=fopen(errfname,"a");
    if (fp!=NULL) {
      if (errstart>=0 && errstart!=errline)
        fprintf(fp,"%s(%d -- %d) : %s %03d: ",inpfname,errstart,errline,pre,(int)number);
      else
        fprintf(fp,"%s(%d) : %s %03d: ",inpfname,errline,pre,(int)number);
      vfprintf(fp,msg,argptr);
      fclose(fp);
    } /* if */
  } /* if */
  va_end(argptr);

  if ((number>=100 && number<200) || errnum>25){
    if (errfname[0]=='\0') {
      va_start(argptr,number);
      pc_error(0,"\nCompilacao interrompida.\n\n",NULL,0,0,argptr);
      va_end(argptr);
    } /* if */
    if (outf!=NULL) {
      pc_closeasm(outf,TRUE);
      outf=NULL;
    } /* if */
    longjmp(errbuf,2);          /* fatal error, quit */
  } /* if */

  errline=-1;
  /* check whether we are seeing many errors on the same line */
  if ((errstart<0 && lastline!=fline) || lastline<errstart || lastline>fline || fcurrent!=lastfile)
    errorcount=0;
  lastline=fline;
  lastfile=fcurrent;
  if (number<200 || errwarn)
    errorcount++;
  if (errorcount>=3)
    error(107);         /* too many error/warning messages on one line */

  return 0;
}

SC_FUNC void errorset(int code,int line)
{
  switch (code) {
  case sRESET:
    errflag=FALSE;      /* start reporting errors */
    break;
  case sFORCESET:
    errflag=TRUE;       /* stop reporting errors */
    break;
  case sEXPRMARK:
    errstart=fline;     /* save start line number */
    break;
  case sEXPRRELEASE:
    errstart=-1;        /* forget start line number */
    errline=-1;
    break;
  case sSETPOS:
    errline=line;
    break;
  } /* switch */
}

/* pc_enablewarning()
 * Enables or disables a warning (errors cannot be disabled).
 * Initially all warnings are enabled. The compiler does this by setting bits
 * for the *disabled* warnings and relying on the array to be zero-initialized.
 *
 * Parameter enable can be:
 *  o  0 for disable
 *  o  1 for enable
 *  o  2 for toggle
 */
int pc_enablewarning(int number,int enable)
{
  int index;
  unsigned char mask;

  if (number<200)
    return FALSE;       /* errors and fatal errors cannot be disabled */
  number-=200;
  if (number>=NUM_WARNINGS)
    return FALSE;

  index=number/8;
  mask=(unsigned char)(1 << (number%8));
  switch (enable) {
  case 0:
    warnstack.disable[index] |= mask;
    break;
  case 1:
    warnstack.disable[index] &= (unsigned char)~mask;
    break;
  case 2:
    warnstack.disable[index] ^= mask;
    break;
  } /* switch */

  return TRUE;
}

/* pc_pushwarnings()
 * Saves currently disabled warnings, used to implement #pragma warning push
 */
int pc_pushwarnings()
{
  void *p;
  p=calloc(sizeof(struct s_warnstack),1);
  if (p==NULL) {
    error(103); /* insufficient memory */
    return FALSE;
  }
  memmove(p,&warnstack,sizeof(struct s_warnstack));
  warnstack.next=p;
  return TRUE;
}

/* pc_popwarnings()
 * This function is the reverse of pc_pushwarnings()
 */
int pc_popwarnings()
{
  void *p;
  if (warnstack.next==NULL)
    return FALSE; /* nothing to do */
  p=warnstack.next;
  memmove(&warnstack,p,sizeof(struct s_warnstack));
  free(p);
  return TRUE;
}

/* pc_seterrorwarnings()
 * Make warnings errors (or not).
 */
void pc_seterrorwarnings(int enable)
{
  errwarn = enable;
}

int pc_geterrorwarnings()
{
  return errwarn;
}

/* Implementation of Levenshtein distance, by Lorenzo Seidenari
 */
static int minimum(int a,int b,int c)
{
  int min=a;
  if(b<min)
    min=b;
  if(c<min)
    min=c;
  return min;
}

static int levenshtein_distance(const char *s,const char*t)
{
  //Step 1
  int k,i,j,cost,*d,distance;
  int n=strlen(s);
  int m=strlen(t);
  assert(n>0 && m>0);
  d=(int*)malloc((sizeof(int))*(m+1)*(n+1));
  m++;
  n++;
  //Step 2
  for (k=0;k<n;k++)
    d[k]=k;
  for (k=0;k<m;k++)
    d[k*n]=k;
  //Step 3 and 4
  for (i=1;i<n;i++) {
    for (j=1;j<m;j++) {
      //Step 5
      cost= (tolower(s[i-1])!=tolower(t[j-1]));
      //Step 6
      d[j*n+i]=minimum(d[(j-1)*n+i]+1,d[j*n+i-1]+1,d[(j-1)*n+i-1]+cost);
    } /* for */
  } /* for */
  distance=d[n*m-1];
  free(d);
  return distance;
}

static int get_max_dist(const char *name)
{
  int max_dist=strlen(name)/2; /* for short names, allow only a single edit */
  if (max_dist>MAX_EDIT_DIST)
    max_dist=MAX_EDIT_DIST;
  return max_dist;
}

static int find_closest_symbol_table(const char *name,const symbol *root,int symboltype,symbol **closest_sym)
{
  int dist,max_dist,closest_dist=INT_MAX;
  char symname[2*sNAMEMAX+16];
  symbol *sym;
  assert(closest_sym!=NULL);
  *closest_sym =NULL;
  assert(name!=NULL);
  max_dist=get_max_dist(name);
  for (sym=root->next; sym!=NULL; sym=sym->next) {
    if (sym->fnumber!=-1 && sym->fnumber!=fcurrent)
      continue;
    if ((sym->usage & uDEFINE)==0 && (sym->ident!=iFUNCTN || (sym->usage & (uNATIVE | uPROTOTYPED))!=uPROTOTYPED))
      continue;
    switch (sym->ident)
    {
    case iLABEL:
      if ((symboltype & esfLABEL)==0)
        continue;
      break;
    case iCONSTEXPR:
      if ((symboltype & esfCONST)==0)
        continue;
      break;
    case iVARIABLE:
    case iREFERENCE:
      if ((symboltype & esfVARIABLE)==0)
        continue;
      break;
    case iARRAY:
    case iREFARRAY:
      if ((symboltype & esfARRAY)==0)
        continue;
      break;
    case iFUNCTN:
    case iREFFUNC:
      if ((symboltype & (((sym->usage & uNATIVE)!=0) ? esfNATIVE : esfFUNCTION))==0)
        continue;
      break;
    default:
      assert(0);
    } /* switch */
    funcdisplayname(symname,sym->name);
    if (symname[0] == '\0')
      continue;
    dist=levenshtein_distance(name,symname);
    if (dist>max_dist || dist>=closest_dist)
      continue;
    *closest_sym=sym;
    closest_dist=dist;
    if (closest_dist<=1)
      break;
  } /* for */
  return closest_dist;
}

static symbol *find_closest_symbol(const char *name,int symboltype)
{
  symbol *symloc,*symglb;
  int distloc,distglb;

  if (sc_status==statFIRST)
    return NULL;
  assert(name!=NULL);
  if (name[0]=='\0')
    return NULL;
  distloc=find_closest_symbol_table(name,&loctab,symboltype,&symloc);
  if (distloc<=1)
    distglb=INT_MAX; /* don't bother searching in the global table */
  else
    distglb=find_closest_symbol_table(name,&glbtab,symboltype,&symglb);
  return (distglb<distloc) ? symglb : symloc;
}

static constvalue *find_closest_automaton(const char *name)
{
  constvalue *ptr=sc_automaton_tab.first;
  constvalue *closest_match=NULL;
  int dist,max_dist,closest_dist=INT_MAX;

  assert(name!=NULL);
  max_dist=get_max_dist(name);
  while (ptr!=NULL) {
    if (ptr->name[0]!='\0') {
      dist=levenshtein_distance(name,ptr->name);
      if (dist<closest_dist && dist<=max_dist) {
        closest_match=ptr;
        closest_dist=dist;
        if (closest_dist<=1)
          break;
      } /* if */
    } /* if */
    ptr=ptr->next;
  } /* while */
  return closest_match;
}

static constvalue *find_closest_state(const char *name,int fsa)
{
  constvalue *ptr=sc_state_tab.first;
  constvalue *closest_match=NULL;
  int dist,max_dist,closest_dist=INT_MAX;

  assert(name!=NULL);
  max_dist=get_max_dist(name);
  while (ptr!=NULL) {
    if (ptr->index==fsa && ptr->name[0]!='\0') {
      dist=levenshtein_distance(name,ptr->name);
      if (dist<closest_dist && dist<=max_dist) {
        closest_match=ptr;
        closest_dist=dist;
        if (closest_dist<=1)
          break;
      } /* if */
    } /* if */
    ptr=ptr->next;
  } /* while */
  return closest_match;
}

static constvalue *find_closest_automaton_for_state(const char *statename,int fsa)
{
  constvalue *ptr=sc_state_tab.first;
  constvalue *closest_match=NULL;
  constvalue *automaton;
  const char *fsaname;
  int dist,max_dist,closest_dist=INT_MAX;

  assert(statename!=NULL);
  max_dist=get_max_dist(statename);
  automaton=automaton_findid(ptr->index);
  assert(automaton!=NULL);
  fsaname=automaton->name;
  while (ptr!=NULL) {
    if (fsa!=ptr->index && ptr->name[0]!='\0' && strcmp(statename,ptr->name)==0) {
      automaton=automaton_findid(ptr->index);
      assert(automaton!=NULL);
      dist=levenshtein_distance(fsaname,automaton->name);
      if (dist<closest_dist && dist<=max_dist) {
        closest_match=automaton;
        closest_dist=dist;
        if (closest_dist<=1)
          break;
      } /* if */
    } /* if */
    ptr=ptr->next;
  } /* while */
  return closest_match;
}

SC_FUNC int error_suggest(int number,const char *name,const char *name2,int type,int subtype)
{
  char string[sNAMEMAX*2+2]; /* for "<automaton>:<state>" */
  const char *closest_name=NULL;
  symbol *closest_sym;

  /* don't bother finding the closest names on errors
   * that aren't going to be shown on the 1'st pass
   */
  if ((errflag || sc_status!=statWRITE) && (number<100 || number>=200))
    return 0;

  if (type==estSYMBOL) {
  find_symbol:
    closest_sym=find_closest_symbol(name,subtype);
    if (closest_sym!=NULL) {
      closest_name=closest_sym->name;
      if ((subtype & esfVARIABLE)!=0 && closest_sym->states!=NULL && strcmp(closest_name,name)==0) {
        assert(number==17); /* undefined symbol */
        error(makelong(number,2),name);
        return 0;
      } /* if */
    } /* if */
  } else if (type==estNONSYMBOL) {
    if (tMIDDLE<subtype && subtype<=tLAST) {
      extern char *sc_tokens[];
      name=sc_tokens[subtype-tFIRST];
      subtype=esfVARCONST;
      goto find_symbol;
    } /* if */
  } else if (type==estAUTOMATON) {
    constvalue *closest_automaton=find_closest_automaton(name);
    if (closest_automaton!=NULL)
      closest_name=closest_automaton->name;
  } else if (type==estSTATE) {
    constvalue *closest_state=find_closest_state(name,subtype);
    if (closest_state!=NULL) {
      closest_name=closest_state->name;
    } else {
      constvalue *closest_automaton=find_closest_automaton_for_state(name,subtype);
      if (closest_automaton!=NULL) {
        sprintf(string,"%s:%s",closest_automaton->name,name);
        closest_name=string;
      } /* if */
    } /* if */
  } else {
    assert(0);
  } /* if */

  if (closest_name==NULL) {
    error(number,name,name2);
  } else if (name2!=NULL) {
    error(makelong(number,1),name,name2,closest_name);
  } else {
    error(makelong(number,1),name,closest_name);
  } /* if */
  return 0;
}
