MODULE testFrame;
IMPORT Out, frame;

TYPE 

  strCell = POINTER TO strCellDesc;

  strCellDesc = RECORD(frame.cellDesc);
    string : ARRAY 16 OF CHAR
  END;

  intCell = POINTER TO intCellDesc;

  intCellDesc = RECORD(frame.cellDesc);
    int : INTEGER
    END;

PROCEDURE main;
VAR
  f:frame.frm;
  icell: intCell;
  scell: strCell;
BEGIN
  NEW(icell); NEW(scell);
  icell^.int := 2; scell^.string := "valod";
  f := frame.create(5, 10);
  frame.write(f, icell, 0, 0);
  frame.write(f, scell, 1, 1);
  f^.mtrx[2]^[2] := f^.mtrx[1]^[1];
  IF f^.mtrx[2]^[2] IS strCell THEN 
    Out.String(f^.mtrx[2]^[2](strCell)^.string); Out.Ln;
  ELSE
    Out.String("not a strCell"); Out.Ln;
  END;

END main;


BEGIN
main;

END testFrame.
