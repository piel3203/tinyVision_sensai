/*******************************************************************************
    Verilog netlist generated by IPGEN Radiant
    Soft IP Version: 1.0.0
    Wed Mar 20 11:12:28 2019
*******************************************************************************/
/*******************************************************************************
    Include IP core template files.
*******************************************************************************/
`include "core/lscc_ram_dq.v"
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module rom_himax_cfg_seq (clk_i, clk_en_i, wr_en_i, wr_data_i, addr_i,
    rd_data_o);
    input  clk_i;
    input  clk_en_i;
    input  wr_en_i;
    input  [15:0]  wr_data_i;
    input  [7:0]  addr_i;
    output  [15:0]  rd_data_o;
    lscc_ram_dq #(.ADDR_DEPTH(256),
        .DATA_WIDTH(16),
        .ADDR_WIDTH(8),
        .REGMODE("noreg"),
        .RESETMODE("sync"),
        .INIT_MODE("mem_file"),
        .INIT_FILE("misc/ram256x16_himax_324x324_seq_fps_rom_himax_cfg_seq_copy.mem"),
        .INIT_FILE_FORMAT("hex"))
    lscc_ram_dq_inst(.clk_i(clk_i),
        .rst_i(1'b0),
        .clk_en_i(clk_en_i),
        .rd_out_clk_en_i(1'b1),
        .wr_en_i(wr_en_i),
        .wr_data_i(wr_data_i),
        .addr_i(addr_i),
        .rd_data_o(rd_data_o));
endmodule