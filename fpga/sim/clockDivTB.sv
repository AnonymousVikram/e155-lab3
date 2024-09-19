`timescale 1 ns / 1 ns
module clockDivTB ();
  logic nreset;
  logic clkDiv, clkDivExpected;

  logic clk;

  int testCounter;
  int errors;
  logic [2:0] testVectors[20:0];

  clockDivider #('d1) dut (
      .clk(clk),
      .nreset(nreset),
      .clkDiv(clkDiv)
  );


  initial begin
    $display("reading test vectors");
    $readmemb("clockDivider.tv", testVectors);
    testCounter = 0;
    errors = 0;
    nreset = 0;
    #2;
    nreset = 1;
    #2;
  end

  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  always @(posedge clk) begin
    #1;
    {clkDivExpected} = testVectors[testCounter];
  end

  always @(negedge clk) begin
    #1;
    if (clkDiv !== clkDivExpected) begin
      $display("Error (test %d): ", errors);
      $display("outputs = %b Expected: (%b)", clkDiv, clkDivExpected);
      errors = errors + 1;
    end
    testCounter = testCounter + 1;
    if (testVectors[testCounter] === 1'bx) begin
      $display("%d tests completed with %d errors", testCounter, errors);
      $finish;
    end
  end
endmodule
