001000$CONTROL POST85, BOUNDS, LINES=59, LIST                                   
001100******************************************************************        
001200* IMAGE data TO MySQL                                             060706MA
001300******************************************************************060614MA
001400*                                                                 060614MA
001500*                                                                 060614MA
001600 IDENTIFICATION DIVISION.                                                 
001700 PROGRAM-ID.     CLEANDSK.                                        060817MA
001800 AUTHOR.     MICHAEL ANDERSON.                                            
001900 DATE-COMPILED.                                                           
002000*                     COPYRIGHT 2007                                      
002100*            J3K Solutions All rights reserved.                           
002300*             FIX COPYLIB MANGLED IN TRANSFER                             
002400*                                                                         
002500 ENVIRONMENT DIVISION.                                                    
002600 CONFIGURATION SECTION.                                           060615MA
002700 SOURCE-COMPUTER. HP-3000.                                                
002800**  WITH DEBUGGING MODE                                                   
002900 OBJECT-COMPUTER. HP-3000.                                        060615MA
003000 SPECIAL-NAMES.                                                           
003100 CONDITION-CODE IS CC.                                                    
003200*                                                                         
003300 INPUT-OUTPUT SECTION.                                                    
003400 FILE-CONTROL.                                                            
003500*                                                                         
003600     SELECT EXTFILE1        ASSIGN TO "CPYTXT,,,,9000000".                
003900*                                                                         
004000 DATA DIVISION.                                                           
004100 FILE SECTION.                                                            
004200                                                                          
005000 FD  EXTFILE1 DATA RECORD IS EXT-REC                                      
005100     RECORD CONTAINS 256 CHARACTERS.                                      
005200 01  EXT-REC1.                                                            
005300     05  FILLER                PIC X(256).                                
005400                                                                          
005500 WORKING-STORAGE SECTION.                                         060615MA
017900 01 xx pic s9(9) comp VALUE 0.                                            
018000                                                                          
019300*=================================================================        
019600$PAGE  "Main logical flow"                                                
019700*=================================================================060620MA
019800 PROCEDURE DIVISION.                                                      
019900 BEGIN-0000.                                                              
020000     DISPLAY "CLNDSK Version 7.01, Copyright J3K Solutions".              
020010     DISPLAY " ".                                                         
020100     OPEN OUTPUT EXTFILE1.                                                
020200     PERFORM VARYING XX FROM 1 BY 1 UNTIL (XX > 1000000)                  
020340        move HIGH-VALUE to EXT-REC1                                       
020350        Write EXT-REC1                                                    
020360     END-PERFORM.                                                         
020400     STOP RUN.                                                    060620MA
025900                                                                          
