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
char readbuf[BUFSIZE];
char words[MAXN][BUFSIZE];
int word_lengths[MAXN];

inline int letter(int c) {
  if (c >= 'A' && c <= 'Z') return c - 'A' + 'a';
  if (c >= 'a' && c <= 'z') return c;
  if (c == ' ' || c == '-') return ' ';
  return 0;
}

inline void word_print(int fd, int word_i, char trailing_char) {
  words[word_i][word_lengths[word_i]] = trailing_char;
  write(fd, words[word_i], word_lengths[word_i] + 1);
}

inline void word_addchar(int word_i, char c) {
  assert(word_i < BUFSIZE);
  words[word_i][word_lengths[word_i]++] = c;
}

inline void word_clear(int word_i) {
  word_lengths[word_i] = 0;
}

void print_words(int fd, int start_i, int max_i) {
  int j;
  for (j = 0; j < max_i; j++) {
    word_print(fd,
      (start_i + j) % max_i,
      j == max_i - 1 ? '\n' : ' ');
  }
}

int main(int argc, char* argv[]) {
  int stdin = open("/dev/stdin", O_RDONLY);
  int stdout = open("/dev/stdout", O_WRONLY);
  int bytes;
  long i, j;
  int words_per_phrase = 4;
  int word_i;
  int word_count = 0;

  assert(words_per_phrase <= MAXN);

  char this_char = 0, last_char = 0;

  while ((bytes = read(stdin, readbuf, BUFSIZE)) != 0) {
    for (i = 0; i < bytes; i++) {
      this_char = letter(readbuf[i]);
      if (this_char == ' ' || (bytes < BUFSIZE && i == bytes-1)) {
        // Word delimiter
        if (last_char != ' ') {
          word_count++;
          if (word_count >= words_per_phrase) {
            print_words(stdout, word_count, words_per_phrase);
            word_clear((word_count) % words_per_phrase);
          }
        }
      } else {
        word_addchar(word_count % words_per_phrase, this_char);
      }
      last_char = this_char;
    }
  }
}
