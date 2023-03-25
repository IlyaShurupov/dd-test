`timescale 1ns / 1ps

/*
* automata:
*   States : Opened, Closed
*   Actions : Pay "0", Turn "1"
*   Transitions :
*     Closed -- Pay  --> Opened
*     Opened -- Turn --> Closed
*
* Any other transition is considered as dissalowed and dont affect the current state
*/


module GateBranchingAutomata(input currentState, input action, input clk, output reg newState);
    always @ (posedge clk) begin
        case (currentState)
            1'b0: begin
                if (action == 1'b0) begin
                   newState <= 1'b1;
                end
                else begin
                   newState <= currentState;
                end
            end
            1'b1: begin
                if (action == 1'b1) begin
                    newState <= 1'b0;
                end
                else begin
                    newState <= currentState;
                end
            end
        endcase
    end
endmodule

module memory_tb;

    reg state;
    reg action, clk; 
    wire newState;
    
    GateBranchingAutomata automata(state, action, clk, newState);
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end 
    
    initial begin     
        $display("States : Closed - 0, Opened - 1 ");
        $display("Actions : Pay - 0, Turn - 1 ");
        
        #0 action = 1; 
        #0 state = 1'b0;      
            
        
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