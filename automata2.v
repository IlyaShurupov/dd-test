`timescale 1ns / 1ps

/*
* Implementation assumes that after user pays and passes through the gate,
* he shall turn it back into the closed state manually. After gate is closed it requires new payment to pass.
* Otherwise, the gate can be opened once and each subsequent user can pass for free.
* 
* automata:
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

module GateMatrixAutomata(input[1:0] currentState, input action, input clk, output reg[1:0] newState);

    //  Memory layout of the transition matrix:
    //            PAY      TURN   
    //         +--------+---------+
    //  OPENED | OPENED | CLOSED  |
    //  CLOSED | PAYED  | CLOSED  |
    //  PAYED  | PAYED  | OPENED  |
    //         +--------+---------+ 

    reg [1:0] transitionMatrix[0:3][0:1];
    
    initial begin
        transitionMatrix[0][0] = 2'b00;
        transitionMatrix[0][1] = 2'b01;
        transitionMatrix[1][0] = 2'b10;
        transitionMatrix[1][1] = 2'b01;   
        transitionMatrix[2][0] = 2'b10;
        transitionMatrix[2][1] = 2'b00;
    end
    
    always @ (posedge clk) begin
        newState <= transitionMatrix[currentState][action];
    end
endmodule


module GateBranchingAutomata(input [1:0] currentState, input action, input clk, output reg[1:0] newState);
    always @ (posedge clk) begin
        case (currentState)
            2'b00: begin
                if (action == 1'b1) begin
                   newState <= 2'b01;
                end
                else begin
                   newState <= currentState;
                end
            end
            2'b01: begin
                if (action == 1'b0) begin
                    newState <= 2'b10;
                end
                else begin
                    newState <= currentState;
                end
            end
            2'b10: begin
                if (action == 1'b1) begin
                    newState <= 2'b00;
                end  
                else begin
                    newState <= currentState;
                end
            end
        endcase
    end
endmodule

module memory_tb;

    reg [1:0] state;
    reg action, clk; 
    wire [1:0] newState;
    
    GateMatrixAutomata automata(state, action, clk, newState);
    // GateBranchingAutomata automata(state, action, clk, newState);
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end 
    
    initial begin     
      
        #0 action = 1; 
        #0 state = 2'b01;      
            
        
        #20 $display("Current State %b - %b -> New State %b", state, action, newState); 
        action = 0; // PAY      
        state = newState; 
        
        #20 $display("Current State %b - %b -> New State %b", state, action, newState);     
        action = 1; // TURN      
        state = newState; 
        
        #20 $display("Current State %b - %b -> New State %b", state, action, newState);    
        action = 1; // TURN
        state = newState; 
            
        #20 $display("Current State %b - %b -> New State %b", state, action, newState);    
        action = 1; // TURN    
        state = newState;       
    end
    
endmodule