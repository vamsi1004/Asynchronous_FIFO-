interface fifo_interface (input logic wclk,rclk,wrst_n,rrst_n);
  logic [7:0] wdata;
  logic [7:0] rdata;
  logic winc;
  logic rinc;
  logic wfull;
  logic rempty;
  
  clocking wr_drv_cb @(posedge wclk);
  default input #0 output #0;
    output wdata;
    output winc;
    //input wfull;
  endclocking 
  
  clocking wr_mon_cb @(posedge wclk);
  default input #0 output #0;
    input wfull;
    input wdata;
    input winc;
  endclocking 
  
  clocking rd_drv_cb @(posedge rclk);
  default input #0 output #0;  
    output rinc;
    //input rempty;
  endclocking
  
  clocking rd_mon_cb @(posedge rclk);
  default input #0 output #0;
    input rempty;
    input rdata;
    input rinc;
  endclocking
  
  modport wr_drv(clocking wr_drv_cb);
  modport wr_mon(clocking wr_mon_cb);
  modport rd_drv(clocking rd_drv_cb);
  modport rd_mon(clocking rd_mon_cb);
    
    //Assertions 
    
//      property p1;
//     @(posedge wclk) disable iff(!wrst_n)
//       winc |=> !wfull;
//   endproperty
//   assert property(p1)
//     else $error("p1 FAILED: Write attempted when FIFO is FULL!");

  property p2;
    @(posedge wclk) disable iff(!wrst_n)
      (winc && wfull) |-> $stable(wdata);
  endproperty
  assert property(p2)
    else $error("p2 FAILED: Data changed during write when FULL!");

  property p3;
    @(posedge rclk) disable iff(!rrst_n)
      rinc |-> !rempty;
  endproperty
  assert property(p3)
    else $error("p3 FAILED: Read attempted when FIFO is EMPTY!");

  property p4;
    @(posedge rclk) disable iff(!rrst_n)
      (rinc && !rempty) |-> !$isunknown(rdata);
  endproperty
  assert property(p4)
    else $error("p4 FAILED: rdata is X/Z on valid read!");

  property p5;
    @(posedge wclk) disable iff(!wrst_n)
      !(wfull && rempty);
  endproperty
  assert property(p5)
    else $error("p5 FAILED: FIFO signaled FULL and EMPTY simultaneously!");
    
endinterface
