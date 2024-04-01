MODULE testFrame;
IMPORT Out, frame, readcsv;

PROCEDURE main;
VAR
  f:frame.frm;
  icell: frame.intCell;
  scell: frame.strCell;
  columnNames: frame.cnames;
BEGIN
  NEW(icell); NEW(scell);
  icell^.int := 2; scell^.string := "valod";
  f := frame.create(5, 10);
  NEW(columnNames, f^.width);
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

  (*
  frame.nameColumn(f, 0, "chgitem");
  Out.String(f^.columnNames^[0]); Out.Ln;
  *)

  columnNames[0] := "v";
  columnNames[1] := "a";
  columnNames[2] := "l";
  columnNames[3] := "o";
  columnNames[4] := "d";
  Out.String("naming"); Out.Ln;
  frame.nameColumns(f, columnNames);
  frame.loader := readcsv.ReadCSVFile;

  frame.load(frame, "country_full.csv")
  (*frame.printDataFrame(f); Out.Ln;*)
  frame.printDataFrame2(f); Out.Ln;

END main;


BEGIN
  main;

END testFrame.
