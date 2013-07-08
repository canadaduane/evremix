#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <fcntl.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>

#define BUFSIZE 65535
char readbuf[BUFSIZE], writebuf[2][BUFSIZE];
int writebuf_page = 0, repeat_page = 0, next_repeat_page = 0;
long writebuf_i = 0, repeat_i = 0, next_repeat_i = 0, repeat_target = 0;

inline int letter(int c) {
  if (c >= 'A' && c <= 'Z') return c - 'A' + 'a';
  if (c >= 'a' && c <= 'z') return c;
  if (c == ' ' || c == '-') return ' ';
  return 0;
}

void writeflush(int fd) {
  if (writebuf_i > 0) {
    write(fd, writebuf[writebuf_page], writebuf_i);
    // Swap pages
    writebuf_page = !writebuf_page;
    // Start at beginning of page
    writebuf_i = 0;
  }
}

inline void writechar(int fd, char c) {
  writebuf[writebuf_page][writebuf_i++] = c;
  assert(writebuf_i <= BUFSIZE);
  if (writebuf_i == BUFSIZE) writeflush(fd);
}

int main(int argc, char* argv[]) {
  int stdin = open("/dev/stdin", O_RDONLY);
  int stdout = open("/dev/stdout", O_WRONLY);
  int bytes;
  long i;
  int words = 0, words_per_phrase = 5;

  char this_char = 0, last_char = 0;
  char inner_this_char = 0, inner_last_char = 0;

  while ((bytes = read(stdin, readbuf, BUFSIZE)) != 0) {
    for (i = 0; i < bytes; i++) {
      this_char = letter(readbuf[i]);
      switch(this_char) {
        case 0:
          // Skip the character
          break;
        case ' ':
          // Word delimiter
          if (last_char != ' ') {
            // This is the first space after a word
            words++;
            if (words == words_per_phrase) {
              words = 1;
              writechar(stdout, ' ');
              repeat_target = writebuf_i;
              writechar(stdout, '\n');
              while (repeat_i != repeat_target) {
                inner_this_char = writebuf[repeat_page][repeat_i++];
                if (repeat_i == BUFSIZE) {
                  repeat_i = 0;
                  repeat_page = !repeat_page;
                }
                if (inner_this_char != ' ' &&
                    inner_last_char == ' ') {
                  words++;
                  if (words == 2) {
                    writechar(stdout, '>');
                    next_repeat_i = repeat_i-1;
                    next_repeat_page = repeat_page;
                  }
                }
                writechar(stdout, inner_this_char);
                inner_last_char = inner_this_char;
              }
              repeat_i = next_repeat_i;
              repeat_page = next_repeat_page;
            } else {
              writechar(stdout, ' ');
            }
          }
          break;
        default:
          if (last_char == ' ' && words == 1) {
            writechar(stdout, '!');
            repeat_i = writebuf_i;
            repeat_page = writebuf_page;
          }
          // Acceptable character
          writechar(stdout, this_char);
      }
      last_char = this_char;
    }
  }
  // Final clear write buf
  writechar(stdout, '\n');
  writeflush(stdout);
}
