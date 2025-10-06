class fifo_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(fifo_scoreboard)
  
  wr_seq_item wr_item;
  rd_seq_item rd_item;
  
  uvm_tlm_analysis_fifo #(wr_seq_item) wr_scb_port;
  uvm_tlm_analysis_fifo #(rd_seq_item) rd_scb_port;

  bit write_map [bit[7:0]]; 
  bit read_map  [bit[7:0]];  

  int depth = 16;

  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_scb_port = new("wr_port", this);
    rd_scb_port = new("rd_port", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
      wr_scb_port.get(wr_item);
      rd_scb_port.get(rd_item);
      compute(wr_item, rd_item);
    end
  endtask

  task compute(wr_seq_item write, rd_seq_item read);
    if (write.winc) begin
      if (write_map.num() == depth) begin
        if (!write.wfull) begin
          `uvm_error("SCOREBOARD", "DUT did not assert wfull when FIFO is full");end
        else begin
          `uvm_info("SCOREBOARD", "WRITE blocked due to FIFO full (as expected)", UVM_LOW);end
      end
      else begin
        write_map[write.wdata] = 1;
        `uvm_info("SCOREBOARD", 
          $sformatf("WRITE: Stored data %0h (entries=%0d)", write.wdata, write_map.num()), UVM_MEDIUM);
      end
    end
    if(read.rinc) begin
      if (write_map.num() == 0) begin
        if (!read.rempty) begin
          `uvm_error("SCOREBOARD", "DUT did not assert rempty when FIFO is empty");end
        else begin
          `uvm_info("SCOREBOARD", "READ blocked due to FIFO empty (as expected)", UVM_LOW);end
      end
      else begin        
        read_map[read.rdata] = 1;
        if (write_map.exists(read.rdata)) begin
          `uvm_info("SCOREBOARD",$sformatf("MATCH: Data %0h found in both write and read maps", read.rdata),UVM_LOW);
        end
        else begin
          `uvm_error("SCOREBOARD",$sformatf("DATA MISMATCH: Read %0h not found in write_map", read.rdata));
        end
      end
    end
  endtask
endclass
