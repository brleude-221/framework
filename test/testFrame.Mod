MODULE testFrame;
IMPORT Out, frame;

PROCEDURE main;
VAR
  f:frame.frm;
  icell: frame.intCell;
  scell: frame.strCell;
BEGIN
  NEW(icell); NEW(scell);
  icell^.int := 2; scell^.string := "valod";
  f := frame.create(5, 10);
  frame.write(f, icell, 0, 0);
  frame.write(f, scell, 1, 1);
  f^.mtrx[2]^[2] := f^.mtrx[1]^[1];
  IF f^.mtrx[2]^[2] IS frame.strCell THEN 
    Out.String(f^.mtrx[2]^[2](frame.strCell)^.string); Out.Ln;
  ELSE
    Out.String("not a strCell"); Out.Ln;
  END;

  frame.nameColumn(f, 0, "chgitem");
  Out.String(f^.columnNames^[0]); Out.Ln;

END main;


BEGIN
  main;

END testFrame.
