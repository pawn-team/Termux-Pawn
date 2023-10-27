/*  Pawn compiler driver
 *
 *  Function and variable definition and declaration, statement parser.
 *
 *  Copyright(c) ITB CompuPhase, 2006
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
 *    claim that you wrote the original software. If you use this software in
 *    a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 *  2.  Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 *  3.  This notice may not be removed or altered from any source distribution.
 *
 *  Version: $Id: pawncc.c 3612 2006-07-22 09:59:46Z thiadmer $
 */

#include "sc.h"

// added by DeviceBlack
// Reason: users complained about the amx file not being generated in the source folder of the pwn file by default
void insert_output(int *argc, char ***argv) {
  char *filepath = NULL;
  int has_output = 0;
  int arg = *argc;

  for(int x = 1; x < arg; x++) {
    if(strncmp((*argv)[x], "-o", 2) == 0) {
      has_output = 1;
    } else if((*argv)[x][0] != '-') {
      filepath = (*argv)[x];
    }
  }

  if(has_output == 0 && filepath != NULL) {
    char *orig = strrchr(filepath, '.');
    size_t mysize = orig - filepath;
    char *tmpstr;

    if(orig != NULL) {
      tmpstr = (char *)malloc(mysize + 1);
      strncpy(tmpstr, filepath, mysize);
      tmpstr[mysize] = '\0';
    } else {
      tmpstr = strdup(filepath);
    }

    char **new_argv = (char **)malloc(sizeof(char *) *(arg + 1));

    for(int i = 0; i < arg; i++) {
      new_argv[i] = (*argv)[i];
    }

    new_argv[arg] = (char *)malloc(strlen(tmpstr) + 4);
    snprintf(new_argv[arg], strlen(tmpstr) + 4, "-o:%s", tmpstr);
    free(tmpstr);

    (*argc)++;
    *argv = new_argv;
  }
}

int main(int argc, char *argv[]) {
  insert_output(&argc, &argv);
  return pc_compile(argc, argv);
}
