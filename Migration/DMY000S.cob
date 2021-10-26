*>$CONTROL POST85, BOUNDS, LINES=59, LIST, MAP, CROSSREF
 IDENTIFICATION DIVISION.                            
 PROGRAM-ID.     DMY000.                                
 ENVIRONMENT DIVISION.                                 
 DATA DIVISION.                                            
 WORKING-STORAGE SECTION.                            
*****************************************
 PROCEDURE DIVISION.                                    
 BEGIN-0000.                                                 
     CALL "SUB1".                                             
     CALL "SUB2".                                             
     CALL "SUB3".                                             
     CALL "SUB4".                                             
     CALL "SUB11".                                           
     STOP RUN.                                                  
 END PROGRAM DMY000.                                     
*>$TITLE "SUB1"                                                
*>$CONTROL RLFILE,LIST,DYNAMIC,BOUNDS,POST85  
 IDENTIFICATION DIVISION.                            
 PROGRAM-ID. SUB1.                                       
 ENVIRONMENT DIVISION.                                 
 DATA DIVISION.                                            
 WORKING-STORAGE SECTION.                            
 PROCEDURE DIVISION.                                    
 0-BEGIN.                                                     
     DISPLAY "SUB1 FROM DMY000".                     
     GOBACK.                                                     
 END PROGRAM SUB1.                                        
*>****************************************
*>$TITLE "SUB2"                                                
*>$CONTROL RLFILE,LIST,DYNAMIC,BOUNDS,POST85  
 IDENTIFICATION DIVISION.                            
 PROGRAM-ID. SUB2.                                       
 ENVIRONMENT DIVISION.                                 
 DATA DIVISION.                                            
 WORKING-STORAGE SECTION.                            
 PROCEDURE DIVISION.                                    
 0-BEGIN.                                                     
     DISPLAY "SUB2 FROM DMY000".                     
     GOBACK.                                                     
 END PROGRAM SUB2.                                        
*>****************************************
*>$TITLE "SUB3"                                                
*>$CONTROL RLFILE,LIST,DYNAMIC,BOUNDS,POST85  
 IDENTIFICATION DIVISION.                            
 PROGRAM-ID. SUB3.                                       
 ENVIRONMENT DIVISION.                                 
 DATA DIVISION.                                            
 WORKING-STORAGE SECTION.                            
 PROCEDURE DIVISION.                                    
 0-BEGIN.                                                     
     DISPLAY "SUB3 FROM DMY000 CALLING SUB2".
     CALL "SUB2".                                             
     GOBACK.                                                     
 END PROGRAM SUB3.                                        
                                                                  
