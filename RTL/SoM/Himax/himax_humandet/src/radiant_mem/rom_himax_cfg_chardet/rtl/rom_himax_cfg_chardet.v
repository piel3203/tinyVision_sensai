
/*******************************************************************************
    Verilog netlist generated by IPGEN Radiant Software (64-bit) 1.1.0.165.1
    Soft IP Version: 1.0.0
    Mon May 13 14:20:34 2019
*******************************************************************************/
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module rom_himax_cfg_chardet (rd_clk_i, rd_en_i, rd_clk_en_i, rd_addr_i, rd_data_o) ;
    input rd_clk_i ; 
    input rd_en_i ; 
    input rd_clk_en_i ; 
    input [7:0] rd_addr_i ; 
    output [15:0] rd_data_o ; 
    rom_himax_cfg_chardet_ipgen_lscc_rom #(.FAMILY("iCE40UP"),.RADDR_DEPTH(256),.RDATA_WIDTH(16),.REGMODE("noreg"),.RADDR_WIDTH(8),.RESETMODE("sync"),.INIT_MODE("mem_file"),.INIT_FILE("misc/ram256x16_himax_324x324_chardet_rom_himax_cfg_chardet_copy.mem"),.INIT_FILE_FORMAT("hex")) lscc_rom_inst (.rd_clk_i(rd_clk_i), .rst_i(1'b0), .rd_en_i(rd_en_i), .rd_clk_en_i(rd_clk_en_i), .rd_out_clk_en_i(1'b1), .rd_addr_i(rd_addr_i[7:0]), .rd_data_o(rd_data_o[15:0])) ; 
endmodule



// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// -----------------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               : Radiant Software 1.1
// File                  : lscc_rom.v
// Title                 :
// Dependencies          :
// Description           : Implements a ROM implementing EBR.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.0.
// Author(s)             :
// Mod. Date             :
// Changes Made          : Initial release.
// =============================================================================
module rom_himax_cfg_chardet_ipgen_lscc_rom #(parameter RADDR_DEPTH = 1024, parameter RADDR_WIDTH = clog2(RADDR_DEPTH), parameter RDATA_WIDTH = 36, parameter REGMODE = "reg", parameter GSR = "", parameter RESETMODE = "sync", parameter INIT_FILE = "none", parameter INIT_FILE_FORMAT = "binary", parameter FAMILY = "", parameter MODULE_TYPE = "rom", parameter INIT_MODE = "none", parameter PIPELINES = 0, parameter ECC_ENABLE = "") (
    // -----------------------------------------------------------------------------
    // Input/Output Ports
    // -----------------------------------------------------------------------------
    input rd_clk_i, 
    input rst_i, 
    input rd_clk_en_i, 
    input rd_out_clk_en_i, 
    input rd_en_i, 
    input [(RADDR_WIDTH - 1):0] rd_addr_i, 
    output reg [(RDATA_WIDTH - 1):0] rd_data_o) ;
    // -----------------------------------------------------------------------------
    // Local Parameters
    // -----------------------------------------------------------------------------
    // Memory size = (addr_depth_a x data_width_a) = (addr_depth_b x data_width_b)
    localparam INITMODE = ((INIT_MODE == "none") ? 3 : ((INIT_MODE == "all_zero") ? 0 : ((INIT_MODE == "all_one") ? 1 : (((INIT_MODE == "mem_file") && ((INIT_FILE != "none") || (INIT_FILE != ""))) ? 2 : 3)))) ; 
    wire rd_en ; 
    // -----------------------------------------------------------------------------
    // Register Declarations
    // -----------------------------------------------------------------------------
    reg [(RDATA_WIDTH - 1):0] dataout_reg ; 
    (* syn_ramstyle="block_ram" *) reg [(RDATA_WIDTH - 1):0] mem [((2 ** RADDR_WIDTH) - 1):0] ; 
    // -----------------------------------------------------------------------------
    // Assign Statements
    // -----------------------------------------------------------------------------
    assign rd_en = (rd_en_i & rd_clk_en_i) ; 
    // -----------------------------------------------------------------------------
    // Initial Block
    // -----------------------------------------------------------------------------
    integer j ; 
    initial
        begin
            if (((INIT_MODE == "mem_file") && (INIT_FILE != "none"))) 
                begin
                    if ((INIT_FILE_FORMAT == "hex")) 
                        begin
                            $readmemh (INIT_FILE,mem,0,(RADDR_DEPTH - 1)) ;
                        end
                    else
                        begin
                            $readmemb (INIT_FILE,mem,0,(RADDR_DEPTH - 1)) ;
                        end
                end
        end
    // -----------------------------------------------------------------------------
    // Generate Sequential Blocks
    // -----------------------------------------------------------------------------
    generate
        if ((REGMODE == "noreg")) 
            begin : genblk1
                always
                    @(posedge rd_clk_i)
                    begin
                        if ((rd_en == 1'b1)) 
                            begin
                                rd_data_o <=  mem[rd_addr_i] ;
                            end
                    end
            end
    endgenerate
    generate
        if ((REGMODE == "reg")) 
            begin : genblk2
                always
                    @(posedge rd_clk_i)
                    begin
                        if ((rd_en == 1'b1)) 
                            begin
                                dataout_reg <=  mem[rd_addr_i] ;
                            end
                    end
                if ((RESETMODE == "sync")) 
                    begin : genblk1
                        always
                            @(posedge rd_clk_i)
                            begin
                                if ((rst_i == 1'b1)) 
                                    begin
                                        rd_data_o <=  'h0 ;
                                    end
                                else
                                    if ((rd_out_clk_en_i == 1'b1)) 
                                        begin
                                            rd_data_o <=  dataout_reg ;
                                        end
                            end
                    end
                if ((RESETMODE == "async")) 
                    begin : genblk2
                        always
                            @(posedge rd_clk_i or posedge rst_i)
                            begin
                                if ((rst_i == 1'b1)) 
                                    begin
                                        rd_data_o <=  'h0 ;
                                    end
                                else
                                    if ((rd_out_clk_en_i == 1'b1)) 
                                        begin
                                            rd_data_o <=  dataout_reg ;
                                        end
                            end
                    end
            end
    endgenerate
    //------------------------------------------------------------------------------
    // Function Definition
    //------------------------------------------------------------------------------
    function [31:0] clog2 ; 
        input [31:0] value ; 
        reg [31:0] num ; 
        begin
            num = (value - 1) ;
            for (clog2 = 0 ; (num > 0) ; clog2 = (clog2 + 1))
                num = (num >> 1) ;
        end
    endfunction
endmodule


