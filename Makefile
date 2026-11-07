CC = gcc
CFLAGS = -Wall -O2 -pthread
TARGET = sync_car
OBJS = sync_car.o sync_car-runner.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

%.o: %.c sync_car.h
	$(CC) $(CFLAGS) -c $< -o $@

test: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) $(OBJS)

.PHONY: all test clean
