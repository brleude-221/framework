MODULE testFrame;
IMPORT Out, frame, readcsv;

PROCEDURE main;
VAR
  f, f1:frame.frm;
  icell: frame.intCell;
  scell: frame.strCell;
  columnNames: frame.cnames;
BEGIN
  NEW(icell); NEW(scell);
  icell^.int := 2; scell^.string := "valod";
  f := frame.create();
  frame.setSize(f, 5, 10);
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
  frame.printDataFrame(f); Out.Ln;

  (*f^.loader := readcsv.ReadCSVFile;*)
  frame.setLoader(f, readcsv.ReadCSVFile);
  f.load(f, "country_full.csv");
  frame.printDataFrame(f); Out.Ln;
  
  (*
  f1 := frame.create();
  frame.setSize(f1, 11, 250);
  Out.String("after set size"); Out.Ln;

  NEW(columnNames, f1^.width);
  columnNames[0] := "v";
  columnNames[1] := "a";
  columnNames[2] := "l";
  columnNames[3] := "o";
  columnNames[4] := "d";
  columnNames[5] := "6";
  columnNames[6] := "7";
  columnNames[7] := "8";
  columnNames[8] := "9";
  columnNames[9] := "1";
  columnNames[10] := "2";

  Out.String("naming"); Out.Ln;
  frame.nameColumns(f1, columnNames);

  frame.printDataFrame(f1); Out.Ln;
  Out.String("before load"); Out.Ln;
  frame.setLoader(f1, readcsv.ReadCSVFile);
  f1.load(f1, "country_full.csv");
  Out.String("after load"); Out.Ln;
  Out.String("f^columnNames"); Out.Int(LEN(f1^.columnNames^), 0); Out.Ln;
  frame.printDataFrame(f1); Out.Ln;
  *)

END main;


BEGIN
  main;

END testFrame.
