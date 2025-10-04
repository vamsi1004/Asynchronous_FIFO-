class fifo_subscriber extends uvm_component;
  
  `uvm_component_utils(fifo_subscriber)
  
  uvm_tlm_analysis_fifo #(wr_seq_item) wr_cov_port;
  uvm_tlm_analysis_fifo #(rd_seq_item) rd_cov_port;
  
  wr_seq_item wr_item;
  rd_seq_item rd_item;
  
  real wr_cov_report;
  real rd_cov_report;
  
  covergroup cg1;
    write_data: coverpoint wr_item.wdata{
      bins data_first = {[0:127]};
      bins data_last = {[128:255]};
    }
    wfull: coverpoint wr_item.wfull{
      bins full_flag[] = {0,1};
    }
    winc: coverpoint wr_item.winc{
      bins winc[] = {0,1};
    }
  endgroup
  
  covergroup cg2;
    read_data: coverpoint rd_item.rdata{
      bins data_first = {[0:127]};
      bins data_last = {[128:255]};
    }
    rempty: coverpoint rd_item.rempty{
      bins empty_flag[] = {0,1};
    }
    rinc: coverpoint rd_item.rinc{
      bins rinc[] = {0,1};
    }
  endgroup
  
  function new(string name = "fifo_subscriber", uvm_component parent);
    super.new(name, parent);
    wr_cov_port = new("wr_cov_port",this);
    rd_cov_port = new("rd_cov_port",this); 
    cg1 = new;
    cg2 = new;
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
    wr_cov_port.get(wr_item);
    cg1.sample();
    rd_cov_port.get(rd_item);
    cg2.sample();
    end
  endtask
  
  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    wr_cov_report = cg1.get_coverage();
    rd_cov_report = cg2.get_coverage();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("get_name()",$sformatf("[WRITE] coverage = %0.2f",wr_cov_report),UVM_LOW);
    `uvm_info("get_name()",$sformatf("[READ] coverage = %0.2f",rd_cov_report),UVM_LOW);
  endfunction
  
endclass
