module lab3_vk (
    input logic [3:0] rows,
    input logic nreset,
    output logic lSegEn,
    rSegEn,
    output logic [3:0] cols,
    output logic [6:0] seg
);

  //* Setting up HSOSC and clk
  logic clk;
  HSOSC #(
      .CLKHF_DIV(2'b00)
  )  // ensures 48MHz clock
      hf_osc (
      .CLKHFPU(1'b1),
      .CLKHFEN(1'b1),
      .CLKHF  (clk)
  );

  //* Slowing down the clk
  logic clkDiv240;  // 240Hz clock for seven segment display
  clockDivider #('d10000) clkDivMod240 (
      .clk(clk),
      .nreset(nreset),
      .clkDiv(clkDiv240)
  );

  logic clkDiv48;  // 48Hz clock for keypad
  clockDivider #('d500000) clkDivMod48 (
      .clk(clk),
      .nreset(nreset),
      .clkDiv(clkDiv48)
  );

  //* Setting up seven segment multiplexing using the divided clock signal
  assign lSegEn = clkDiv240;
  assign rSegEn = ~clkDiv240;

  logic [3:0] keyInput, curVal, oldVal;
  logic keyInputValid;

  //* Setting up the flops for the values
  flopenr #(
      .BITS('d4)
  ) valueFlop (
      .clk(clkDiv48),
      .nreset(nreset),
      .enable(keyInputValid),
      .d(keyInput),
      .q(curVal)
  );

  flopenr #(
      .BITS('d4)
  ) valueFlopOld (
      .clk(clkDiv48),
      .nreset(nreset),
      .enable(keyInputValid),
      .d(curVal),
      .q(oldVal)
  );

  //* Configuring the keypad decoder and FSM
  valueFSM valueFSMMod (
      .clk(clkDiv48),
      .nreset(nreset),
      .rows(rows),
      .curVal(curVal),
      .cols(cols),
      .keyInput(keyInput),
      .keyInputValid(keyInputValid)
  );

  //* Instantiate seven segment decoder
  logic [3:0] segDecoderInput;

  assign segDecoderInput = clkDiv240 ? curVal : oldVal;

  sevenSegmentDecoder sevenSegmentDecoderMod (
      .inputHex(segDecoderInput),
      .segments(seg)
  );


endmodule
