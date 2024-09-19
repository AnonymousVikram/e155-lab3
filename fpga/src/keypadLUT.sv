module keypadLUT (
    input logic clk,
    nreset,
    input logic [3:0] rows,
    cols,
    output logic validKeyCombo,
    output logic [3:0] keyInput
);

  always_ff @(posedge clk) begin : keyInputLogic
    if (~nreset) begin
      keyInput = 4'hx;
      validKeyCombo = 0;
    end else begin
      case ({
        rows, cols
      })
        8'b1110_1110: begin
          keyInput = 4'h1;
          validKeyCombo = 1;
        end
        8'b1110_1101: begin
          keyInput = 4'h2;
          validKeyCombo = 1;
        end
        8'b1110_1011: begin
          keyInput = 4'h3;
          validKeyCombo = 1;
        end
        8'b1110_0111: begin
          keyInput = 4'hA;
          validKeyCombo = 1;
        end
        8'b1101_1110: begin
          keyInput = 4'h4;
          validKeyCombo = 1;
        end
        8'b1101_1101: begin
          keyInput = 4'h5;
          validKeyCombo = 1;
        end
        8'b1101_1011: begin
          keyInput = 4'h6;
          validKeyCombo = 1;
        end
        8'b1101_0111: begin
          keyInput = 4'hB;
          validKeyCombo = 1;
        end
        8'b1011_1110: begin
          keyInput = 4'h7;
          validKeyCombo = 1;
        end
        8'b1011_1101: begin
          keyInput = 4'h8;
          validKeyCombo = 1;
        end
        8'b1011_1011: begin
          keyInput = 4'h9;
          validKeyCombo = 1;
        end
        8'b1011_0111: begin
          keyInput = 4'hC;
          validKeyCombo = 1;
        end
        8'b0111_1110: begin
          keyInput = 4'hE;
          validKeyCombo = 1;
        end
        8'b0111_1101: begin
          keyInput = 4'h0;
          validKeyCombo = 1;
        end
        8'b0111_1011: begin
          keyInput = 4'hF;
          validKeyCombo = 1;
        end
        8'b0111_0111: begin
          keyInput = 4'hD;
          validKeyCombo = 1;
        end
        default: begin
          keyInput = 4'hx;
          validKeyCombo = 0;
        end
      endcase
    end
  end
endmodule
