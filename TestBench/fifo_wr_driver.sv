class fifo_wr_driver extends uvm_driver #(wr_seq_item);
  
  virtual fifo_interface.wr_drv vif;
  `uvm_component_utils(fifo_wr_driver)
  
  function new(string name = "fifo_wr_driver",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_interface)::get(this,"","password",vif))
      `uvm_fatal("WRITE_DRIVER","!!!No virtual interface!!!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
  
  task drive();
    @(posedge vif.wr_drv_cb)
    //     while(vif.wr_drv_cb.wfull)
//       begin 
//         @(posedge vif.wr_drv_cb);
//       end
    vif.wr_drv_cb.wdata <= req.wdata;
    vif.wr_drv_cb.winc <= req.winc;
    `uvm_info("WRITE_DRIVER",$sformatf("Driving from write driver"),UVM_LOW);
    req.print();
  endtask
endclass
