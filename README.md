# sync_car

Sincronização do Metrô: funções de uma estação de metrô em C, usando threads POSIX, um mutex e variáveis de condição. Cada carro e cada passageiro é uma thread independente.

## Arquivos

- `sync_car.h`: declaração de `struct station` e dos protótipos das quatro funções.
- `sync_car.c`: implementação de `station_init`, `station_load_car`, `station_wait_for_car` e `station_on_board`.
- `sync_car-runner.c`: programa de teste fornecido pelo professor, contém a `main`.
- `Makefile`: compilação, execução do teste e limpeza.
- `evidencias.log`: gravação do terminal feita com `script`, com data, usuário, diretório, comandos e saídas da compilação e dos testes.
- `relatorio.pdf`: relatório da atividade.

## Sistema operacional

Implementado e testado em Ubuntu 26.04 LTS (WSL2 no Windows 11), com gcc 15.2.0 e GNU Make 4.4.1. O código usa somente POSIX threads e `pthread_mutex_*` / `pthread_cond_*`, então deve compilar também em outros Linux, Unix e macOS.

## Como compilar, executar e testar

```
make
./sync_car
```

O programa imprime uma linha por carro que entra e sai da estação e termina com `Looks good!` quando os 100 passageiros embarcam corretamente. O código de saída é 0 em caso de sucesso e 1 em caso de erro.

`make test` compila e executa o teste. `make clean` remove o executável e os objetos.

## Como funciona

A `struct station` guarda um único mutex, duas variáveis de condição e três contadores:

- `waiting`: passageiros esperando na plataforma.
- `free_seats`: assentos livres ainda não reservados no carro que está na estação (0 quando não há carro).
- `boarding`: passageiros que receberam assento mas ainda não chamaram `station_on_board`.

`station_wait_for_car` conta o passageiro como esperando e dorme em `car_arrived` até haver assento livre. Ao acordar, reserva o assento e retorna, sem esperar os outros, o que permite embarque simultâneo.

`station_load_car` publica a quantidade de assentos, acorda todos os passageiros com `pthread_cond_broadcast` e dorme em `passengers_seated` enquanto houver passageiros esperando com assento livre ou passageiros ainda embarcando. Quando nenhuma das duas condições vale, zera `free_seats` e retorna.

`station_on_board` decrementa `boarding` e, quando chega a zero, acorda o carro.

Não há espera ocupada: toda espera é feita em `pthread_cond_wait`, sempre dentro de um `while` que reavalia a condição.
