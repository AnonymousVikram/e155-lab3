/*
* File Author: Vikram Krishna (vkrishna@hmc.edu)
* File Created: September 14, 2024
* Summary: SystemVerilog to decode a 16 input keypad
*/

module keypadDecoder (
    input logic clk,
    nreset,
    input logic [3:0] rows,
    output logic [3:0] cols,
    keyInput,
    output logic keyInputValid
);
  typedef enum logic [1:0] {
    COL1,
    COL2,
    COL3,
    COL4
  } colscanstates_t;

  colscanstates_t curState, nextState;

  always_comb begin : colOutput
    case (curState)
      COL1: cols = 4'b1110;
      COL2: cols = 4'b1101;
      COL3: cols = 4'b1011;
      COL4: cols = 4'b0111;
      default: cols = 4'b1111;
    endcase
  end

  always_ff @(posedge clk) begin : stateController
    if (~nreset) begin
      curState  <= COL1;
      nextState <= COL1;
    end else begin
      case (curState)
        COL1: nextState <= rows == 4'b1111 ? COL2 : COL1;
        COL2: nextState <= rows == 4'b1111 ? COL3 : COL2;
        COL3: nextState <= rows == 4'b1111 ? COL4 : COL3;
        COL4: nextState <= rows == 4'b1111 ? COL1 : COL4;
      endcase
      curState <= nextState;
    end
  end

  always_comb begin : keyInputLogic
    case ({
      rows, cols
    })
      8'b1110_1110: begin
        keyInput = 4'h1;
        keyInputValid = 1;
      end
      8'b1110_1101: begin
        keyInput = 4'h2;
        keyInputValid = 1;
      end
      8'b1110_1011: begin
        keyInput = 4'h3;
        keyInputValid = 1;
      end
      8'b1110_0111: begin
        keyInput = 4'hA;
        keyInputValid = 1;
      end
      8'b1101_1110: begin
        keyInput = 4'h4;
        keyInputValid = 1;
      end
      8'b1101_1101: begin
        keyInput = 4'h5;
        keyInputValid = 1;
      end
      8'b1101_1011: begin
        keyInput = 4'h6;
        keyInputValid = 1;
      end
      8'b1101_0111: begin
        keyInput = 4'hB;
        keyInputValid = 1;
      end
      8'b1011_1110: begin
        keyInput = 4'h7;
        keyInputValid = 1;
      end
      8'b1011_1101: begin
        keyInput = 4'h8;
        keyInputValid = 1;
      end
      8'b1011_1011: begin
        keyInput = 4'h9;
        keyInputValid = 1;
      end
      8'b1011_0111: begin
        keyInput = 4'hC;
        keyInputValid = 1;
      end
      8'b0111_1110: begin
        keyInput = 4'hE;
        keyInputValid = 1;
      end
      8'b0111_1101: begin
        keyInput = 4'h0;
        keyInputValid = 1;
      end
      8'b0111_1011: begin
        keyInput = 4'hF;
        keyInputValid = 1;
      end
      8'b0111_0111: begin
        keyInput = 4'hD;
        keyInputValid = 1;
      end
      default: begin
        keyInput = 4'h8;
        keyInputValid = 0;
      end
    endcase
  end

endmodule
