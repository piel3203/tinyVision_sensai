
module lsc_i2cm_himax(
input             clk    , // 48MHz clk
input             init   ,

input             scl_in ,
input             sda_in ,
output            scl_out,
output            sda_out,
output reg	  init_done,
input             resetn
);

parameter [6:0]	NUM_CMD = 7'd80;
parameter EN_ALT = 1;
parameter CONF_SEL = "QVGA";

// state machine
parameter [2:0] 
	S_IDLE  = 3'b000,
	S_RDOFF = 3'b001,
	S_RDDAT = 3'b010,
	S_RUN   = 3'b011,
	S_WAIT  = 3'b111;

reg     [2:0]   state;
reg     [2:0]   nstate;

reg	[6:0]	i2c_cnt;
wire		lsb_addr;
wire	[15:0]	i2c_cmd;
wire		i2c_set;
wire		i2c_done;
wire    [7:0]   i2c_rd_data;
wire            i2c_running;

reg		init_req;
reg	[1:0]	init_d;

reg	[15:0]	ofs_addr;

always @(posedge clk or negedge resetn)
begin
    if(resetn == 1'b0) 
	init_d <= 2'b0;
    else               
	init_d <= {init_d[0], init};
end

always @(posedge clk or negedge resetn)
begin
    if(resetn == 1'b0)             
	init_req <= 1'b1;
    else if(init_d == 2'b01)       
	init_req <= 1'b1;
    else if(state == S_IDLE)       
	init_req <= 1'b0;
end

always @(posedge clk or negedge resetn)
begin
    if(resetn == 1'b0) 
	state <= S_IDLE;
    else               
	state <= nstate;
end

always @(*)
begin
    case(state)
	S_IDLE :
	    nstate <= init_req ? S_RDOFF : S_IDLE;
	S_RDOFF:
	    nstate <= S_RDDAT;
	S_RDDAT:
	    nstate <= S_RUN;
	S_RUN:
	    nstate <= S_WAIT;
	S_WAIT:
	    nstate <= i2c_running ? S_WAIT : ((i2c_cnt == NUM_CMD) ? S_IDLE : S_RDOFF);
	default:
	    nstate <= S_IDLE ;
    endcase
end

assign i2c_set = (state == S_RUN);

always @(posedge clk or negedge resetn)
begin
    if(resetn == 1'b0)     
	i2c_cnt <= 7'd0;
    else if(state == S_IDLE) 
	i2c_cnt <= 7'd0;
    else if(i2c_done)
	i2c_cnt <= i2c_cnt + 7'd1;
end

assign lsb_addr = (state == S_RDDAT);

always @(posedge clk or negedge resetn)
begin
    if(resetn == 1'b0) 
	init_done <= 1'b0;
    else if(init_req == 1'b1)
	init_done <= 1'b0;
    else if(i2c_cnt == NUM_CMD)
	init_done <= 1'b1;
end

always @(posedge clk or negedge resetn)
begin
    if(resetn == 1'b0) 
	ofs_addr <= 16'b0;
    else if(state == S_RDDAT)
	ofs_addr <= i2c_cmd;
end

lsc_i2cm_16 u_lsc_i2cm(
    .clk     (clk           ),
    .enable  (1'b1          ),
    .rw      (1'b0          ),
    .run     (i2c_set       ),
    .interval(6'd30         ),
    .dev_addr(7'h24         ),
    .ofs_addr(ofs_addr      ),
    .wr_data (i2c_cmd[ 7: 0]),
    .scl_in  (scl_in        ),
    .sda_in  (sda_in        ),
    .scl_out (scl_out       ),
    .sda_out (sda_out       ),
    .running (i2c_running   ),
    .done    (i2c_done      ),
    .rd_data (i2c_rd_data   ),
    .resetn  (resetn        )
);

if(CONF_SEL == "QVGA")
begin
    sbram_256x16_himax u_ram256x16_himax (
	.wr_clk_i   (clk     ),
	.rd_clk_i   (clk     ),
	.wr_clk_en_i(1'b0    ),
	.rd_en_i    (1'b1    ),
	.rd_clk_en_i(1'b1    ),
	.wr_en_i    (1'b0    ),
	.wr_data_i  (16'b0   ),
	.wr_addr_i  (8'b0    ),
	.rd_addr_i  ({i2c_cnt, lsb_addr}),
	.rd_data_o  (i2c_cmd )
    );
end
else if(CONF_SEL == "QVGA_fixed")
begin
    rom_himax_cfg_qvga_fixed u_rom_himax_cfg (
	.clk_i     (clk     ),
	.clk_en_i  (1'b1    ),
	.wr_en_i   (1'b0    ),
	.wr_data_i (16'b0   ),
	.addr_i    ({i2c_cnt, lsb_addr}),
	.rd_data_o (i2c_cmd )
    );
end
else if(CONF_SEL == "QVGA_fixed_maxfps")
begin
    rom_himax_cfg_qvga_fixed_maxfps u_rom_himax_cfg (
	.clk_i     (clk     ),
	.clk_en_i  (1'b1    ),
	.wr_en_i   (1'b0    ),
	.wr_data_i (16'b0   ),
	.addr_i    ({i2c_cnt, lsb_addr}),
	.rd_data_o (i2c_cmd )
    );
end
/*
else if(CONF_SEL == "324x324_dim")
begin
    rom_himax_cfg_324_dim u_rom_himax_cfg (
	.clk_i     (clk     ),
	.clk_en_i  (1'b1    ),
	.wr_en_i   (1'b0    ),
	.wr_data_i (16'b0   ),
	.addr_i    ({i2c_cnt, lsb_addr}),
	.rd_data_o (i2c_cmd )
    );
end
else if(CONF_SEL == "324x324_dim_maxfps")
begin
    rom_himax_cfg_324_dim_maxfps u_rom_himax_cfg (
	.clk_i     (clk     ),
	.clk_en_i  (1'b1    ),
	.wr_en_i   (1'b0    ),
	.wr_data_i (16'b0   ),
	.addr_i    ({i2c_cnt, lsb_addr}),
	.rd_data_o (i2c_cmd )
    );
end
else // 324x324
begin
    rom_himax_cfg_324 u_rom_himax_cfg (
	.clk_i     (clk     ),
	.clk_en_i  (1'b1    ),
	.wr_en_i   (1'b0    ),
	.wr_data_i (16'b0   ),
	.addr_i    ({i2c_cnt, lsb_addr}),
	.rd_data_o (i2c_cmd )
    );
end*/
//endgenerate



endmodule
