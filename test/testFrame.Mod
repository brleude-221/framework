MODULE testFrame;
IMPORT Out, Strings, IntStr := oocIntStr, frame, readcsv, writecsv, stats;

PROCEDURE main;
VAR
  f, f1:frame.frm;
  icell: frame.intCell;
  scell: frame.strCell;
  columnNames: frame.cnames; strn: ARRAY 3 OF CHAR;
  i: INTEGER;

BEGIN
  (*
  NEW(icell); NEW(scell);
  icell^.int := 2; scell^.string := "valod";
  f := frame.create();
  frame.setSize(f, 5, 10);
  frame.write(f, icell, 0, 0);
  frame.write(f, icell, 1, 1);
  frame.write(f, scell, 2, 1);
  f^.mtrx[2]^[2] := f^.mtrx[1]^[1];
  f^.mtrx[0]^[1] := f^.mtrx[1]^[1];
  Out.String("populated"); Out.Ln;
  IF f^.mtrx[2]^[1] IS frame.strCell THEN
    Out.String("It is"); Out.Ln;
    Out.String(f^.mtrx[2]^[1](frame.strCell)^.string); Out.Ln;
    Out.String("yes it is"); Out.Ln;
  ELSE
    Out.String("not a strCell"); Out.Ln;
  END;

  NEW(columnNames, f^.width);
  i := 0;
  REPEAT
    Out.String("sdkjfhjbwaie"); Out.Ln;
    COPY("col ", columnNames[i]);
    IntStr.IntToStr(i, strn);
    Strings.Append (strn, columnNames[i]);
    INC(i);
  UNTIL i = LEN(f^.columnNames^);

  frame.setColNames(f, columnNames);
  (*
  frame.nameColumn(f, 0, "chgitem");
  Out.String(f^.columnNames^[0]); Out.Ln;
  *)

  

  Out.String("naming"); Out.Ln;
  frame.printDataFrame(f); Out.Ln;
  
  (*f^.loader := readcsv.ReadCSVFile;*)
*)
  f1 := frame.create();
  frame.setLoader(f1, readcsv.ReadCSVFile);
  f1.load(f1, "country_full.csv", TRUE);
  
  Out.String("printing column names"); Out.Ln;
  frame.printColumnNames(f1);
  Out.String("-----------------"); Out.Ln;
  Out.String("printing frame"); Out.Ln;
  frame.printDataFrame(f1); Out.Ln;
  Out.String("-----------------"); Out.Ln;

  writecsv.saveDataFrameToCSV(f1, "testSave.csv"); 

  stats.mean(f1, 3);
  stats.colTypeCellCnt(f1, 3);
  stats.median(f1, 3);  
  stats.median(f1, 8);
END main;


BEGIN
  main;

END testFrame.
