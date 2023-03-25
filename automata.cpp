/*
* States : Opened, Closed
* Actions : Pay, Turn
* Transitions :
*   Closed -- Pay  --> Opened
*   Opened  -- Turn --> Closed
*
* Any other transition is considered as dissalowed and dont affect the current state
*/

#include <stdio.h>

enum State { OPENED, CLOSED, };
enum Action { PAY, TURN, };

const char* ActionName[2] = { "Pay ", "Turn" };
const char* StateName[3] = { "Opened", "Closed" };

State change_state(State currentState, Action action) {
  State new_state = currentState;
  
  if (currentState == OPENED) {
    if (action == TURN) {
      new_state = CLOSED;
    }
  } else {
    if (action == PAY) {
      new_state = OPENED;
    }
  }

  printf("%s  -- %s --> %s\n", StateName[currentState], ActionName[action], StateName[new_state]);
  return new_state;
}

int main() {
  State state = CLOSED;
  state = change_state(state, PAY);
  state = change_state(state, TURN);
  state = change_state(state, TURN);
  state = change_state(state, TURN);
  state = change_state(state, PAY);
  state = change_state(state, TURN);
  state = change_state(state, TURN);
  state = change_state(state, PAY);
  state = change_state(state, PAY);
  state = change_state(state, PAY);
  state = change_state(state, TURN);
}
