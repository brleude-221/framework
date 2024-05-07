MODULE testStat;
IMPORT Out, Strings, IntStr := oocIntStr, frame, readcsv, writecsv, stats;

PROCEDURE main;
VAR
  f: frame.frm;
  i: INTEGER;

BEGIN
  f := frame.create();
  frame.setLoader(f, readcsv.ReadCSVFile);
  f.load(f, "p_time_in_ms.csv", TRUE);
  
  i := 0;
  Out.Char(' ');
  REPEAT
    Out.String(f^.columnNames^[i]); Out.Ln; 
    stats.mean(f, i); Out.Ln;
    INC(i);
  UNTIL i = f^.width;

  (*stats.frmStats(f);*)
END main;

BEGIN
  main;

END testStat.
