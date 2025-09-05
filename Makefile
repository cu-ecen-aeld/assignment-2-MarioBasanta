CC = gcc
CFLAGS = -Wall -Werror -g

WRITER_SRC = finder-app/writer.c
WRITER_OBJ = writer.o
WRITER_BIN = finder-app/writer

all: $(WRITER_BIN)

$(WRITER_BIN): $(WRITER_OBJ)
	$(CC) $(CFLAGS) -o $@ $^

$(WRITER_OBJ): $(WRITER_SRC)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(WRITER_BIN) $(WRITER_OBJ)

