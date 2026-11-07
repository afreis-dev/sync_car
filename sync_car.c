#include <pthread.h>
#include "sync_car.h"

void station_init(struct station *station)
{
	pthread_mutex_init(&station->lock, NULL);
	pthread_cond_init(&station->car_arrived, NULL);
	pthread_cond_init(&station->passengers_seated, NULL);
	station->waiting = 0;
	station->free_seats = 0;
	station->boarding = 0;
}

void station_load_car(struct station *station, int count)
{
}

void station_wait_for_car(struct station *station)
{
}

void station_on_board(struct station *station)
{
}
