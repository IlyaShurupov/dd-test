/*
* Implementation assumes that after user pays and passes through the gate,
* he shall turn it back into the closed state manually. After gate is closed it requires new payment to pass.
* Otherwise, the gate can be opened once and each subsequent user can pass for free.
*
* Thus automata can be described as:
*   States : Opened, Closed, Payed
*   Actions : Pay, Turn
*   Transitions :
*     Closed -- Pay  --> Payed
*     Payed  -- Turn --> Opened
*     Payed  -- Pay  --> Payed   (allow user to lose his cash endlessly)
*     Opened -- Turn --> Closed
* 
* Any other transition is considered as dissalowed and dont affect the current state
*/

#include <stdio.h>

enum State { OPENED, CLOSED, PAYED, };
enum Action { PAY, TURN, };

int Transisions[3][2] = {
  { OPENED, CLOSED }, // Opened -- Turn --> Closed
  { PAYED, CLOSED }, // Closed -- Pay --> Payed
  { PAYED, OPENED }, // Payed  -- Pay  --> Payed, Payed -- Turn --> Opened
};

const char* ActionName[2] = { "Pay ", "Turn" };
const char* StateName[3] = { "Opened", "Closed", "Payed " };

State change_state(State currentState, Action action) {
  auto new_state = (State)Transisions[currentState][action];
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