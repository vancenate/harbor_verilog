#!/bin/bash

# Reference solution for the router circuit task
# Creates solution_core.sv with correct implementation

cat > /workspace/solution_core.sv << 'EOF'
module solution_core #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  input  din_en,
  input  [1:0] addr,
  output logic [DATA_WIDTH-1:0] dout0,
  output logic [DATA_WIDTH-1:0] dout1,
  output logic [DATA_WIDTH-1:0] dout2,
  output logic [DATA_WIDTH-1:0] dout3
);

  assign dout0 = din_en && addr == 2'd0 ? din : '0;
  assign dout1 = din_en && addr == 2'd1 ? din : '0;
  assign dout2 = din_en && addr == 2'd2 ? din : '0;
  assign dout3 = din_en && addr == 2'd3 ? din : '0;

endmodule
EOF

echo "Created solution_core.sv in /workspace"