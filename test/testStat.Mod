MODULE testStat;
IMPORT Out, Strings, IntStr := oocIntStr, frame, readcsv, writecsv, stats;

PROCEDURE main;
VAR
  f: frame.frm;
  i: INTEGER;

BEGIN
  f := frame.create();
  frame.setLoader(f, readcsv.ReadCSVFile);
  f.load(f, "country_full.csv", TRUE);

  stats.frmStats(f);
END main;

BEGIN
  main;

END testStat.
