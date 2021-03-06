001000$CONTROL USLINIT                                                          
001100  IDENTIFICATION DIVISION.                                                
001200  PROGRAM-ID. CL2HTML.                                                    
001300*                                                                         
001400***********************************************                           
001500* This program will read a COBOL copylib file                             
001600* and generate a byte stream HTML file that is                            
001700* self indexed.                                                           
001800***********************************************                           
001900*                                                                         
002000  AUTHOR. Shawn M. Gordon.                                                
002100  INSTALLATION. SMGA.                                                     
002200  DATE-WRITTEN. TUE, NOV 23, 1999.                                        
002300  DATE-COMPILED.                                                          
002400  ENVIRONMENT DIVISION.                                                   
002500  CONFIGURATION SECTION.                                                  
002600  SOURCE-COMPUTER. HP-3000.                                               
002700  OBJECT-COMPUTER. HP-3000.                                               
002800  SPECIAL-NAMES.                                                          
002900      CONDITION-CODE IS CC.                                               
003000  INPUT-OUTPUT SECTION.                                                   
003100  FILE-CONTROL.                                                           
003200      SELECT INFILE   ASSIGN TO DUMMY USING WS-COPYLIB.                   
003300      SELECT TEMPFILE ASSIGN TO "ZMHF83,,,,1000000".                      
003400  DATA DIVISION.                                                          
003500  FILE SECTION.                                                           
003600  FD INFILE                                                               
003700     RECORD CONTAINS 86 CHARACTERS.                                       
003800  01 INFILE-RECORD.                                                       
003900     03 IR-COBOL-CODE     PIC X(72).                                      
004000     03 IR-COPY-NAME      PIC X(08).                                      
004100     03                   PIC X(06).                                      
004200                                                                          
004300  FD TEMPFILE                                                             
004400     RECORD CONTAINS 100 CHARACTERS.                                      
004500  01 TEMPFILE-RECORD      PIC X(100).                                     
004600                                                                          
004700  WORKING-STORAGE SECTION.                                                
004800                                                                          
004900  01 S1                   PIC S9(4)  COMP VALUE 0.                        
005000  01 WS-COPYLIB           PIC X(26)  VALUE SPACES.                        
005100  01 DEST-FILE            PIC X(254) VALUE SPACES.                        
005200  01 SAVE-NAME            PIC X(08)  VALUE SPACES.                        
005300  01 ERR                  PIC S9(4)  COMP VALUE 0.                        
005400  01 ERR-LEN              PIC S9(4)  COMP VALUE 0.                        
005500  01 ERR-MSG              PIC X(78)  VALUE SPACES.                        
005600  01 DATE-BUFF            PIC X(27)  VALUE SPACES.                        
005700                                                                          
005800  01 INDEX-TABLE.                                                         
005900     03 IT-FORMAT-INDEX OCCURS 1000.                                      
006000        05 ITFI-ANCHOR    PIC X(100).                                     
006100                                                                          
006200  01 HPFOPEN-PARMS.                                                       
006300     03 HP-CONST-0        PIC S9(9)  COMP SYNC VALUE 0.                   
006400     03 HP-CONST-1        PIC S9(9)  COMP SYNC VALUE 1.                   
006500     03 HP-CONST-2        PIC S9(9)  COMP SYNC VALUE 2.                   
006600     03 HP-CONST-4        PIC S9(9)  COMP SYNC VALUE 4.                   
006700     03 HP-CONST-9        PIC S9(9)  COMP SYNC VALUE 9.                   
006800     03 HP-FILE-NAME      PIC X(256) VALUE SPACES.                        
006900     03 HP-FNUM-D         PIC S9(9)  COMP SYNC.                           
007000     03 HP-FNUM-D-REDEF REDEFINES HP-FNUM-D.                              
007100        05                PIC X(02).                                      
007200        05 HP-FNUM        PIC S9(4)  COMP.                                
007300     03 HP-STATUS         PIC S9(9)  COMP SYNC.                           
007400                                                                          
007500  PROCEDURE DIVISION.                                                     
007600  A1000-INIT.                                                             
007700      DISPLAY 'Begin run of CL2HTML @ ' TIME-OF-DAY.                      
007800      DISPLAY 'Enter COPYLIB file name to process: '                      
007900              NO ADVANCING.                                               
008000      ACCEPT WS-COPYLIB FREE.                                             
008100      IF WS-COPYLIB = SPACES                                              
008200         DISPLAY 'Early termination of CL2HTML @ ' TIME-OF-DAY            
008300         STOP RUN.                                                        
008400                                                                          
008500      DISPLAY 'Enter output file name: ' NO ADVANCING.                    
008600      ACCEPT DEST-FILE FREE.                                              
008700      IF DEST-FILE = SPACES                                               
008800         DISPLAY 'Early termination of CL2HTML @ ' TIME-OF-DAY            
008900         STOP RUN.                                                        
009000                                                                          
009100      OPEN  INPUT  INFILE                                                 
009200            OUTPUT TEMPFILE.                                              
009300                                                                          
009400* Need to have a delimiter at beginning and end of file name              
009500      INSPECT DEST-FILE TALLYING S1 FOR CHARACTERS BEFORE ' '.            
009600      MOVE '%'                       TO HP-FILE-NAME(1:1).                
009700      MOVE DEST-FILE(1:S1)           TO HP-FILE-NAME(2:).                 
009800      MOVE '%'                       TO HP-FILE-NAME(S1 + 2:1).           
009900                                                                          
010000* Now use HPFOPEN on the destination file.                                
010100      CALL INTRINSIC "HPFOPEN" USING HP-FNUM-D,                           
010200                                     HP-STATUS,                           
010300                                     2, HP-FILE-NAME,                     
010400                                     3, HP-CONST-4,                       
010500                                     5, HP-CONST-0,                       
010600                                     6, HP-CONST-9,                       
010700                                     7, HP-CONST-0,                       
010800                                    11, HP-CONST-1,                       
010900                                    13, HP-CONST-1,                       
011000                                    19, HP-CONST-1,                       
011100                                    41, HP-CONST-2,                       
011200                                    50, HP-CONST-1,                       
011300                                    53, HP-CONST-1,                       
011400                                    0.                                    
011500      IF HP-STATUS <> 0                                                   
011600         DISPLAY 'Error in HPFOPEN ' HP-STATUS                            
011700         STOP RUN.                                                        
011800                                                                          
012200                                                                          
012300      CALL INTRINSIC 'DATELINE' USING DATE-BUFF.                          
012400      MOVE SPACES                    TO INDEX-TABLE.                      
012500      STRING "<HTML><HEAD><TITLE>" DELIMITED BY SIZE                      
012600             WS-COPYLIB DELIMITED BY SPACES                               
012700             "</TITLE></HEAD>" DELIMITED BY SIZE                          
012800        INTO ITFI-ANCHOR(1).                                              
012900                                                                          
013000      STRING "<CENTER><H3>" DELIMITED BY SIZE                             
013100             WS-COPYLIB DELIMITED BY SPACES                               
013200             " Generated on " DATE-BUFF                                   
013300             "</H3></CENTER>" DELIMITED BY SIZE                           
013400        INTO ITFI-ANCHOR(2).                                              
013500                                                                          
013600      STRING "<P><H4><CENTER>CL2HTML Copylib to HTML convertor, "         
013700             "copyright 1999, " DELIMITED BY SIZE                         
013800        INTO ITFI-ANCHOR(3)                                               
013900                                                                          
014000      STRING "S.M.Gordon & Associates"                                    
014100             "</CENTER></H4><P><BR><UL>" DELIMITED BY SIZE                
014200        INTO ITFI-ANCHOR(4)                                               
014300                                                                          
014400      MOVE 4                         TO S1.                               
014500      MOVE "<PRE>"                   TO TEMPFILE-RECORD.                  
014600      WRITE TEMPFILE-RECORD.                                              
014700  A1000-EXIT.  EXIT.                                                      
014800                                                                          
014900  A1100-READ.                                                             
015000      READ INFILE                                                         
015100         AT END                                                           
015200        MOVE "</PRE>"                TO TEMPFILE-RECORD                   
015300        WRITE TEMPFILE-RECORD                                             
015400        GO TO B1000-INDEX.                                                
015500                                                                          
015600      IF IR-COPY-NAME <> SAVE-NAME                                        
015700         MOVE IR-COPY-NAME           TO SAVE-NAME                         
015800         ADD 1 TO S1                                                      
015900                                                                          
016000* write the html anchor tag in the body of the document.                  
016100         MOVE SPACES                 TO TEMPFILE-RECORD                   
016200         STRING '<P><A NAME="' DELIMITED BY SIZE                          
016300                IR-COPY-NAME DELIMITED BY SPACES                          
016400              '"></A><FONT SIZE="5"><B><CENTER>' DELIMITED BY SIZE        
016500                IR-COPY-NAME DELIMITED BY SPACES                          
016600                '</CENTER></B></FONT>' DELIMITED BY SIZE                  
016700           INTO TEMPFILE-RECORD                                           
016800           WRITE TEMPFILE-RECORD                                          
016900                                                                          
017000* Create the header html in our table for later dump to file.             
017100         STRING '<LI><A HREF="#' DELIMITED BY SIZE                        
017200                IR-COPY-NAME DELIMITED BY SPACES                          
017300                '">' DELIMITED BY SIZE                                    
017400                IR-COPY-NAME DELIMITED BY SPACES                          
017500                '</A>' DELIMITED BY SIZE                                  
017600           INTO ITFI-ANCHOR(S1).                                          
017700                                                                          
017800      MOVE SPACES                    TO TEMPFILE-RECORD.                  
017900      IF IR-COBOL-CODE(1:6) IS NUMERIC                                    
018000         STRING "<BR>" IR-COBOL-CODE(7:) DELIMITED BY SIZE                
018100                INTO TEMPFILE-RECORD                                      
018200      ELSE                                                                
018300         STRING "<BR>" IR-COBOL-CODE DELIMITED BY SIZE                    
018400                INTO TEMPFILE-RECORD.                                     
018500      WRITE TEMPFILE-RECORD.                                              
018600      GO TO A1100-READ.                                                   
018700  A1100-EXIT.  EXIT.                                                      
018800*                                                                         
018900  B1000-INDEX.                                                            
019000      CLOSE TEMPFILE.                                                     
019100      OPEN  INPUT  TEMPFILE.                                              
019200      ADD 1 TO S1.                                                        
019300      MOVE "</UL><PRE><BR>"          TO ITFI-ANCHOR(S1).                  
019400                                                                          
019500      PERFORM VARYING S1 FROM 1 BY 1 UNTIL ITFI-ANCHOR(S1) = SPACE        
019600         CALL INTRINSIC "FWRITE" USING HP-FNUM,                           
019700                                       ITFI-ANCHOR(S1),                   
019800                                       -80,                               
019900                                       0                                  
020000         IF CC <> 0                                                       
020100            CALL INTRINSIC 'FCHECK'  USING HP-FNUM, ERR                   
020200            CALL INTRINSIC 'FERRMSG' USING ERR, ERR-MSG, ERR-LEN          
020300            DISPLAY ERR-MSG                                               
020400            STOP RUN                                                      
020500         END-IF                                                           
020600      END-PERFORM.                                                        
020700                                                                          
020800  B1000-READ.                                                             
020900      READ TEMPFILE                                                       
021000         AT END                                                           
021100        GO TO C9000-EOJ.                                                  
021200                                                                          
021300      CALL INTRINSIC "FWRITE" USING HP-FNUM,                              
021400                                    TEMPFILE-RECORD,                      
021500                                    -80,                                  
021600                                    0.                                    
021700      IF CC <> 0                                                          
021800         CALL INTRINSIC 'FCHECK' USING HP-FNUM, ERR                       
021900         CALL INTRINSIC 'FERRMSG' USING ERR, ERR-MSG, ERR-LEN             
022000         DISPLAY ERR-MSG                                                  
022100         GO TO C9000-EOJ.                                                 
022200                                                                          
022300      GO TO B1000-READ.                                                   
022400  B1000-EXIT.  EXIT.                                                      
022500*                                                                         
022600  C9000-EOJ.                                                              
022700      CLOSE INFILE                                                        
022800            TEMPFILE.                                                     
022900      CALL INTRINSIC "FCLOSE" USING HP-FNUM, %1, 0.                       
023000                                                                          
023100      DISPLAY 'Normal termination of CL2HTML @ ' TIME-OF-DAY.             
023200      STOP RUN.                                                           
023300                                                                          
023400                                                                          
023500                                                                          
023600                                                                          
023700                                                                          
