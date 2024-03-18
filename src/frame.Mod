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
  
  columnName = ARRAY 32 OF CHAR;
  column = POINTER TO ARRAY OF cell; 
  matrix = POINTER TO ARRAY OF column; 

  frm* = POINTER TO frmDesc;
  frmDesc* = RECORD
    height-, width-: INTEGER;
    mtrx*: matrix; 
    columnNames*: POINTER TO ARRAY OF columnName;
    END;

PROCEDURE create*(w, h: INTEGER): frm;
VAR
  f: frm;
  i: INTEGER;
BEGIN
  NEW(f);
  f^.width := w; f^.height := h;

  NEW(f^.mtrx, h);
  i := 0;
  REPEAT
    NEW(f^.mtrx[i], w);
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

PROCEDURE nameColumn*(f: frm; i: INTEGER; name: ARRAY OF CHAR);
BEGIN
  f^.columnNames^[i] := name
END nameColumn;

END frame.
