#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <fcntl.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>

#define BUFSIZE 65535
#define MAXN 20
char readbuf[BUFSIZE], writebuf[2][BUFSIZE];
int writebuf_page = 0;
long writebuf_i = 0;

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
  int words = 1, words_per_phrase = 5;
  assert(words_per_phrase <= MAXN);

  int repeat_page = 0;
  long repeat_i = 0, repeat_target = 0;

  int word_page[MAXN];
  long word_i[MAXN];

  for (i = 0; i < MAXN; i++) {
    word_page[i] = 0;
    word_i[i] = 0;
  }

  char this_char = 0, last_char = 0;

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
            writechar(stdout, ' ');
            // if (words >= words_per_phrase) {
            //   writechar(stdout, '\n');
            // }
          }
          break;
        default:

          if (last_char == ' ') {
            // Bookmark the start of the word
            word_i[words % words_per_phrase] = writebuf_i;
            word_page[words % words_per_phrase] = writebuf_page;
            words++;

            dprintf(stdout, "1: %ld, 2: %ld, 3: %ld, 4: %ld, 5: %ld\n",
              word_i[0], word_i[1], word_i[2], word_i[3], word_i[4]);

            // After printing the first word in a line,
            // print the next n-1 words
            if (words > words_per_phrase) {
              repeat_i = word_i[words % words_per_phrase];
              repeat_page = word_page[words % words_per_phrase];

              // writechar(stdout, ' ');
              repeat_target = writebuf_i;
              while (repeat_i != repeat_target) {
                writechar(stdout, writebuf[repeat_page][repeat_i++]);
                if (repeat_i == BUFSIZE) {
                  repeat_i = 0;
                  repeat_page = !repeat_page;
                }
              }
              writechar(stdout, '\n');
            } else {
              // writechar(stdout, ' ');
            }
            // Acceptable character
            writechar(stdout, this_char);
          } else {
            // Acceptable character
            writechar(stdout, this_char);
          }
      }
      last_char = this_char;
    }
  }
  // Final clear write buf
  writechar(stdout, '\n');
  writeflush(stdout);
}
