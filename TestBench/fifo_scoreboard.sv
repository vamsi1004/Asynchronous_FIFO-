class fifo_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(fifo_scoreboard)
  
  wr_seq_item wr_item;
  rd_seq_item rd_item;
  
  uvm_tlm_analysis_fifo #(wr_seq_item) wr_scb_port;
  uvm_tlm_analysis_fifo #(rd_seq_item) rd_scb_port;
  
  bit [7:0] ref_fifo[$];  
  bit [7:0] exp_data; 
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
    int match_index;  
    if (write.winc) begin
      if (ref_fifo.size() == depth) begin
        if (!write.wfull) begin
          `uvm_error("SCOREBOARD", "DUT did not assert wfull when FIFO is full");
        end else begin
          `uvm_info("SCOREBOARD", "WRITE blocked due to FIFO full (as expected)", UVM_LOW);
        end
      end else begin
        if (write.wfull)
          `uvm_error("SCOREBOARD", "DUT asserted wfull before FIFO is actually full");

        ref_fifo.push_back(write.wdata);
        `uvm_info("SCOREBOARD", $sformatf("WRITE: Stored %0h (pool size=%0d)",
                                          write.wdata, ref_fifo.size()), UVM_MEDIUM);
      end
    end

    if (read.rinc) begin
      if (ref_fifo.size() == 0) begin
        if (!read.rempty) begin
          `uvm_error("SCOREBOARD", "DUT did not assert rempty when FIFO is empty");
        end else begin
          `uvm_info("SCOREBOARD", "READ blocked due to FIFO empty (as expected)", UVM_LOW);
        end
      end else begin
        if (read.rempty) begin
          `uvm_error("SCOREBOARD", "DUT asserted rempty before FIFO is actually empty");
        end

        match_index = -1;   
        foreach (ref_fifo[i]) begin
          if (ref_fifo[i] === read.rdata) begin
            match_index = i;
            break;
          end
        end

        if (match_index == -1) begin
          `uvm_error("SCOREBOARD",
                     $sformatf("DATA MISMATCH: Got %0h, not found in expected pool!",
                               read.rdata));
        end else begin
          exp_data = ref_fifo[match_index];
          ref_fifo.delete(match_index);  
          `uvm_info("SCOREBOARD",
                    $sformatf("READ: Matched %0h (pool size=%0d)",
                              exp_data, ref_fifo.size()), UVM_LOW);
        end
      end
    end
  endtask
endclass
