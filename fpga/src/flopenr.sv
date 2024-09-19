module flopenr #(
    parameter BITS = 'd4
) (
    input logic clk,
    nreset,
    enable,
    input logic [BITS-1:0] d,
    output logic [BITS-1:0] q
);

  always_ff @(posedge clk) begin
    if (~nreset) begin
      q <= '0;
    end else if (enable) begin
      q <= d;
    end
  end

endmodule
