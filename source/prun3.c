/*  Command-line shell for the "Small" Abstract Machine.
 *
 *  Copyright (c) ITB CompuPhase, 2001-2005
 *
 *  This file may be freely used. No warranties of any kind.
 */

#if !defined FLOATPOINT
	#define FLOATPOINT
#endif

#include <stdio.h>
#include <stdlib.h>     /* for exit() */
#include <signal.h>
#include <string.h>     /* for memset() (on some compilers) */
#include <windows.h>
#include <excpt.h>
#include "amx.h"


#define CONSOLE
/*#define FIXEDPOINT*/

void core_Init(void);   /* two functions from AMX_CORE.C */
void core_Exit(void);

static int abortflagged = 0;
void sigabort(int sig)
{
  abortflagged=1;
  signal(sig,sigabort); /* re-install the signal handler */
}

int AMXAPI srun_AbortProc(AMX *amx)
{
  switch (amx->dbgcode) {
  case DBG_INIT:
    return AMX_ERR_NONE;
  case DBG_LINE:
    /* check whether an "abort" was requested */
    return abortflagged ? AMX_ERR_EXIT : AMX_ERR_NONE;
  default:
    return AMX_ERR_DEBUG;
  } /* switch */
}

size_t srun_ProgramSize(char *filename)
{
  FILE *fp;
  AMX_HEADER hdr;

  if ((fp=fopen(filename,"rb")) == NULL)
    return 0;
  fread(&hdr, sizeof hdr, 1, fp);
  fclose(fp);
  amx_Align32((unsigned long *)&hdr.stp);
  return hdr.stp;
}

int srun_LoadProgram(AMX *amx, char *filename, void *memblock)
{
  FILE *fp;
  AMX_HEADER hdr;

  if ((fp = fopen(filename, "rb")) == NULL )
    return AMX_ERR_NOTFOUND;
  fread(&hdr, sizeof hdr, 1, fp);
  amx_Align32((unsigned long *)&hdr.size);
  rewind(fp);
  fread(memblock, 1, (size_t)hdr.size, fp);
  fclose(fp);

  memset(amx, 0, sizeof *amx);
  amx_SetDebugHook(amx, srun_AbortProc);
  return amx_Init(amx, memblock);
}

DWORD srun_CommitMemory(struct _EXCEPTION_POINTERS *ep, void *memaddr, size_t memsize)
{
  void *virtaddr;
  int elemsize;

  /* handle only "access violation" exceptions */
  if (ep->ExceptionRecord->ExceptionCode != EXCEPTION_ACCESS_VIOLATION)
    return EXCEPTION_CONTINUE_SEARCH;

  /* check whether the exception occurred within the bounds of our program */
  virtaddr = (void*)ep->ExceptionRecord->ExceptionInformation[1];
  if (virtaddr < memaddr || virtaddr >= ((char*)memaddr + memsize))
    return EXCEPTION_CONTINUE_SEARCH;

  /* Small typically accesses elements in cells, so that is the default size
   * to commit. Then, one must check whether the "committed" block does not
   * exceed the allocate memory range.
   */
  elemsize = sizeof(cell);
  if ((char*)virtaddr + elemsize > (char*)memaddr + memsize)
    elemsize = ((char*)memaddr + memsize) - (char*)virtaddr;

  if (VirtualAlloc(virtaddr, elemsize, MEM_COMMIT, PAGE_READWRITE) == NULL)
    return EXCEPTION_CONTINUE_SEARCH;

  return EXCEPTION_CONTINUE_EXECUTION;
}

static int srun_RegisterNatives(AMX *amx)
{
  #if defined CONSOLE
    extern AMX_NATIVE_INFO console_Natives[];
  #endif
  #if defined DATETIME
    extern AMX_NATIVE_INFO time_Natives[];
  #endif
  #if defined FIXEDPOINT
    extern AMX_NATIVE_INFO fixed_Natives[];
  #endif
  #if defined FLOATPOINT
    extern AMX_NATIVE_INFO float_Natives[];
  #endif
  extern AMX_NATIVE_INFO core_Natives[];

  #if defined CONSOLE
    amx_Register(amx, console_Natives, -1);
  #endif
  #if defined DATETIME
    amx_Register(amx, time_Natives, -1);
  #endif
  #if defined FIXEDPOINT
    amx_Register(amx, fixed_Natives, -1);
  #endif
  #if defined FLOATPOINT
    amx_Register(amx, float_Natives, -1);
  #endif
  return amx_Register(amx, core_Natives, -1);
}

static void ErrorExit(char *message, int errorcode)
{
  printf(message, errorcode);
  printf("\n");
  exit(1);
}

int main(int argc,char *argv[])
{
  size_t memsize;
  void *program;
  AMX amx;
  cell ret = 0;
  int err;

  if (argc != 2 || (memsize = srun_ProgramSize(argv[1])) == 0)
    ErrorExit("Usage: SRUN <filename>\n\n"
              "The filename must include the extension", 0);

  program = VirtualAlloc(NULL, memsize, MEM_RESERVE, PAGE_READWRITE);
  if (program == NULL)
    ErrorExit("Failed to reserve memory", 0);

  __try {
    err = srun_LoadProgram(&amx, argv[1], program);
    if (err != AMX_ERR_NONE)
      ErrorExit("Load error %d (invalid file format or version mismatch)", err);

    signal(SIGINT,sigabort);
    core_Init();

    err = srun_RegisterNatives(&amx);
    if (err != AMX_ERR_NONE)
      ErrorExit("The program uses native functions that this run-time does not provide");

    err = amx_Exec(&amx, &ret, AMX_EXEC_MAIN, 0);
    while (err == AMX_ERR_SLEEP)
      err = amx_Exec(&amx, &ret, AMX_EXEC_CONT, 0);

    if (err != AMX_ERR_NONE)
      printf("Run time error %d on line %ld\n", err, amx.curline);
    else if (ret != 0)
      printf("%s returns %ld\n", argv[1], (long)ret);

  } __except (srun_CommitMemory(GetExceptionInformation(), program, memsize)) {
    /* nothing */
  } /* try */

  /* Decommitting memory that is not committed does not fail, so you can just
   * decommit all memory. Releasing memory that is partially committed fails,
   * even if you also include the MEM_RELEASE flag (tested on WIndows98), so
   * you must call VirtualFree twice in a row.
   */
  VirtualFree(program, memsize, MEM_DECOMMIT);
  VirtualFree(program, 0, MEM_RELEASE);

  core_Exit();
  return 0;
}
