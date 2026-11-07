CC = gcc
CFLAGS = -Wall -O2 -pthread
TARGET = sync_car
OBJS = sync_car.o sync_car-runner.o
STRESS_RUNS ?= 100

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

%.o: %.c sync_car.h
	$(CC) $(CFLAGS) -c $< -o $@

test: $(TARGET)
	./$(TARGET)

stress: $(TARGET)
	for i in $$(seq 1 $(STRESS_RUNS)); do ./$(TARGET) > /dev/null || exit 1; done
	@echo "$(STRESS_RUNS) execucoes sem falha"

clean:
	rm -f $(TARGET) $(OBJS)

.PHONY: all test stress clean
