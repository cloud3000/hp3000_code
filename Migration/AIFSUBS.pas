$RLFILE ON$                                                                     
$standard_level 'hp_modcal'$                                                    
$optimize on$                                                                   
(* $global$ *)                                                                  
$assume 'LOCAL_GOTOS_ONLY'$                                                     
$assume 'LOCAL_ESCAPES_ONLY'$                                                   
$assume 'NO_HEAP_CHANGES'$                                                      
$assume 'NO_PARM_ADDRESSED'$                                                    
$SUBPROGRAM 'j3k_logon'$                                                        
program change_logon(input,output);                                             
const                                                                           
  maximum_array = 200;                                                          
 type                                                                           
   directory_name_type  = record                                                
                            user   : packed array[1..16] of char ;              
                            group  : packed array[1..16] of char ;              
                            account: packed array[1..16] of char ;              
                          end ;                                                 
                                                                                
   HPE_status           = record                                                
                             case boolean of                                    
                               true  : (all   :integer);                        
                               false : (info  :shortint;                        
                                        subsys:shortint);                       
                          end;                                                  
   pac16                = packed array [1..16]  of char;                        
   logon_cmd_type       = packed array [1..128] of char;                        
   logon_desc_type      = record                                                
                             job_name    : pac16;                               
                             acct_name   : pac16;                               
                             acct_pass   : pac16;                               
                             user_name   : pac16;                               
                             user_pass   : pac16;                               
                             group_name  : pac16;                               
                             group_pass  : pac16;                               
                          end ;                                                 
   status_type_2        = array [1..maximum_array] of HPE_status;               
var                                                                             
   item_array       : packed array [1..maximum_array]     of globalanyptr;      
   item_num_array   : packed array [1..maximum_array + 1] of integer;           
   item_status_array: status_type_2;                                            
 const                                                                          
   init_item_status_array = status_type_2                                       
                            [maximum_array of HPE_status [info  :0,             
                                                          subsys:0]];           
                                                                                
var                                                                             
  acct_pass     :pac16;                                                         
  group_pass    :pac16;                                                         
  user_pass     :pac16;                                                         
  directory_name: directory_name_type;                                          
                                                                                
$sysintr 'aifintr.pub.sys'$                                                     
procedure AIFACCTGET    ;intrinsic;                                             
procedure AIFCHANGELOGON;intrinsic;                                             
$sysintr 'sysintr.pub.sys'$                                                     
procedure GETPRIVMODE   ;intrinsic;                                             
procedure GETUSERMODE   ;intrinsic;                                             
                                                                                
PROCEDURE j3k_logon (var overall_status :HPE_status;                            
                        var logon_cmd      :logon_cmd_type;                     
                        var logon_desc     :logon_desc_type;                    
                        var options        :integer;                            
                        var error_status   :HPE_status;                         
                        var proc_no        :shortint);                          
                                                                                
label 100, 200, 300, 400, 999;                                                  
                                                                                
begin                                                                           
100:                                                                            
                                                                                
   GETPRIVMODE;                                                                 
   overall_status.all    := 0;                                                  
   item_num_array[1]     := 6202;                                               
   item_num_array[2]     := 0;                                                  
   proc_no               := 1;                                                  
(* Get ACCT password *)                                                         
   directory_name.account:=logon_desc.acct_name;                                
   directory_name.group  :=' ';                                                 
   directory_name.user   :=' ';                                                 
   acct_pass             :=logon_desc.acct_pass;                                
   item_array [1]        :=addr(acct_pass);                                     
                                                                                
   item_status_array     := init_item_status_array;                             
   AIFACCTGET(overall_status,                                                   
              item_num_array,                                                   
              item_array,                                                       
              item_status_array,                                                
              directory_name);                                                  
   if overall_status.all <> 0 then                                              
      goto 999;                                                                 
                                                                                
   goto 200;                                                                    
                                                                                
200:                                                                            
                                                                                
   overall_status.all   := 0;                                                   
   item_num_array[1]    := 6002;                                                
   item_num_array[2]    := 0;                                                   
   proc_no              := 2;                                                   
(* Get USER.ACCT password *)                                                    
   directory_name.account:=logon_desc.acct_name;                                
   directory_name.group  :=' ';                                                 
   directory_name.user   :=logon_desc.user_name;                                
                                                                                
   user_pass             :=logon_desc.user_pass;                                
   item_array [1]        :=addr(user_pass);                                     
                                                                                
   item_status_array    := init_item_status_array;                              
   AIFACCTGET(overall_status,                                                   
              item_num_array,                                                   
              item_array,                                                       
              item_status_array,                                                
              directory_name);                                                  
   if overall_status.all <> 0 then                                              
      goto 999;                                                                 
                                                                                
   goto 300;                                                                    
                                                                                
300:                                                                            
                                                                                
   if logon_desc.group_name = ' ' then                                          
      goto 400;                                                                 
                                                                                
   overall_status.all   := 0;                                                   
   item_num_array[1]    := 6102;                                                
   item_num_array[2]    := 0;                                                   
   proc_no              := 3;                                                   
(* Get GROUP.ACCT password *)                                                   
   directory_name.account:=logon_desc.acct_name;                                
   directory_name.group  :=logon_desc.group_name;                               
   directory_name.user   :=' ';                                                 
                                                                                
   group_pass            :=logon_desc.group_pass;                               
   item_array [1]        :=addr(group_pass);                                    
                                                                                
   item_status_array    := init_item_status_array;                              
   AIFACCTGET(overall_status,                                                   
              item_num_array,                                                   
              item_array,                                                       
              item_status_array,                                                
              directory_name);                                                  
   if overall_status.all <> 0 then                                              
      goto 999;                                                                 
                                                                                
   goto 400;                                                                    
                                                                                
400:                                                                            
                                                                                
   proc_no:= 4;                                                                 
   AIFCHANGELOGON(overall_status,                                               
                  logon_cmd,                                                    
                  logon_desc,                                                   
                  options,                                                      
                  error_status);                                                
   if overall_status.all <> 0 then                                              
      goto 999;                                                                 
                                                                                
   goto 999;                                                                    
                                                                                
999:                                                                            
   logon_desc.acct_pass :=acct_pass;                                            
   logon_desc.user_pass :=user_pass;                                            
   logon_desc.group_pass:=group_pass;                                           
   GETUSERMODE;                                                                 
end;                                                                            
                                                                                
begin                                                                           
end.                                                                            
