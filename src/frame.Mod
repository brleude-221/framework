MODULE frame;

IMPORT Out;

TYPE 
  cell* = POINTER TO cellDesc;
  cellDesc* = RECORD 
    (* abstract *)
    END;

  strCell* = POINTER TO strCellDesc;
  strCellDesc* = RECORD(cellDesc)
    string*: ARRAY 16 OF CHAR
  END;

  intCell* = POINTER TO intCellDesc;
  intCellDesc* = RECORD(cellDesc)
    int*: INTEGER
  END;
  
  columnName* = ARRAY 32 OF CHAR;
  column = POINTER TO ARRAY OF cell; 
  matrix = POINTER TO ARRAY OF column; 
  cnames* = POINTER TO ARRAY OF columnName;
  frm* = POINTER TO frmDesc;
  frmDesc* = RECORD
    height-, width-: INTEGER;
    mtrx*: matrix; 
    columnNames*: cnames; 
    END;

PROCEDURE create*(w, h: INTEGER): frm;
VAR
  f: frm;
  i: INTEGER;
BEGIN
  NEW(f);
  f^.width := w; f^.height := h;

  NEW(f^.mtrx, w);
  i := 0;
  REPEAT
    NEW(f^.mtrx[i], h);
    Out.String("i="); Out.Int(i,0); Out.Ln;
    INC(i)
  UNTIL i = h;

  NEW(f^.columnNames, w);

  RETURN f;
END create;

PROCEDURE write*(f: frm; cl:cell; c, r: INTEGER);
BEGIN
  f^.mtrx[c]^[r] := cl
END write;

PROCEDURE read*(f: frm; c, r: INTEGER): cell;
BEGIN
  RETURN f^.mtrx[c]^[r]
END read;

(*
PROCEDURE nameColumn*(f: frm; i: INTEGER; name: ARRAY OF CHAR);
BEGIN
  f^.columnNames^[i] := name
END nameColumn;
*)

PROCEDURE nameColumns*(f: frm; VAR names: cnames);
VAR
  i: INTEGER;
BEGIN
  f^.columnNames := names;
END nameColumns;

PROCEDURE printDataFrame2*(f: frm);
VAR
  c, r: INTEGER;
  celll: cell;
BEGIN
  Out.Int(f^.width, 0); Out.Char('x'); Out.Int(f^.height, 0); Out.Ln;
  r := 0;
  REPEAT
    c := 0;
    REPEAT
         Out.Int(c, 0); Out.Char(' ');  Out.Int(r, 0); Out.Ln;
      celll := read(f, c, r);
      IF celll = NIL THEN
        Out.String("NIL"); Out.Ln;
      ELSIF celll IS strCell THEN
        Out.String(celll(strCell)^.string); Out.Ln;
      ELSIF celll IS intCell THEN
        Out.Int(celll(intCell)^.int, 0); Out.Ln;
      ELSE
        Out.String("Unknown cell type"); Out.Ln;
      END;
      Out.String(" ");
      INC(c)
    UNTIL c = f^.width; 
    Out.Ln;
    INC(r);
  UNTIL r = f^.height;
  Out.Ln;
END printDataFrame2;

PROCEDURE printDataFrame*(f: frm);
VAR
  c, r: INTEGER;
  celll: cell;
BEGIN
  FOR c := 0 TO (f^.height - 1) DO
    FOR r := 0 TO (f^.width - 1) DO
      (*Out.Int(c, 0);  Out.Int(r, 0); Out.Ln;*)
      celll := read(f, c, r);
      IF celll = NIL THEN
        Out.String("NIL");
      ELSE
        IF celll IS strCell THEN
          Out.String(celll(strCell)^.string);
        ELSIF celll IS intCell THEN
          Out.Int(celll(intCell)^.int, 0);
        ELSE
          Out.String("Unknown cell type");
        END;
      END;
      Out.String(" ");
    END;
    Out.Ln;
  END;
END printDataFrame;

END frame.
