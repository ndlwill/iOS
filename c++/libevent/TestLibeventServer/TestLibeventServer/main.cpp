//
//  main.cpp
//  TestLibeventServer
//
//  Created by youdone-ndl on 2021/9/8.
//

#include <iostream>
#include <event2/event.h>

int main(int argc, char** argv)
{
    return 0;
}

// MARK: - test timer
/*
static int n_calls = 0;

void cb_func(evutil_socket_t fd, short what, void *arg)
{
    struct event *me = (struct event *)arg;

    printf("cb_func called %d times so far.\n", ++n_calls);

    if (n_calls > 10) event_del(me);
}

void run(struct event_base * base)
{
    struct timeval one_sec = {1, 0};
    struct event *ev;
    
    ev = event_new(base, -1, EV_PERSIST, cb_func, event_self_cbarg());
    event_add(ev, &one_sec);
    event_base_dispatch(base);
}

int main(int argc, const char * argv[]) {
    run(event_base_new());
    printf("=====finish=====\n");
    return 0;
}
*/
