MODULE stats;

IMPORT frame, Out;

(*maybe its a good idea to eventually make it so we can reference a column by its name not only the index*)
PROCEDURE colTypeCellCnt*(f: frame.frm; c: INTEGER);
VAR
  celll: frame.cell;
  i: INTEGER;
  cntInt: INTEGER;
  cntStr: INTEGER;
  cntNil: INTEGER;
BEGIN
  i := 0;
  cntInt := 0; cntStr := 0; cntNil := 0;
  REPEAT
    celll := frame.read(f, c, i);
    IF celll IS frame.strCell THEN
      INC(cntStr);
    ELSIF celll IS frame.intCell THEN
      INC(cntInt);
    ELSIF celll = NIL THEN
      INC(cntNil)
    END;

    INC(i);
  UNTIL i = f^.height;

  IF (cntStr # 0) & (cntInt # 0) THEN
      Out.String("Attention! The column is not homogeneous"); Out.Ln;
    ELSIF cntStr > 0 THEN
      Out.String("Column type = string"); Out.Ln;
    ELSIF cntInt > 0 THEN
      Out.String("Column type = int"); Out.Ln;
    ELSE
      Out.String("The column is empty or has only NIL values"); Out.Ln;
  END;

  Out.String("Number of NIL = "); Out.Int(cntNil, 0); Out.Ln;
  Out.String("Number of Integers = "); Out.Int(cntInt, 0); Out.Ln;
  Out.String("Number of Strings = "); Out.Int(cntStr, 0); Out.Ln;
END colTypeCellCnt;

PROCEDURE mean*(f: frame.frm; c: INTEGER);
VAR
  celll: frame.cell;
  i: INTEGER;
  intCount: INTEGER;
  intSum: LONGINT;
  intSumReal: REAL;
  mean: REAL;
BEGIN
  i := 0;
  intCount := 0;
  intSum := 0;
  REPEAT
  celll := frame.read(f, c, i);
  IF celll IS frame.intCell THEN
    INC(intCount);
    intSum := intSum + celll(frame.intCell)^.int;
  END;
  INC(i);
  UNTIL i = f^.height;
  IF intCount = 0 THEN
  Out.String("No integer values found"); Out.Ln;
  ELSE
    IF i < f^.height  THEN
      Out.String("Attention! Non integer values are present in the column"); Out.Ln;
    END;
    intSumReal := intSum;
    mean := intSumReal / intCount;
    Out.String("sum = "); Out.Int(intSum, 0); Out.Ln;
    Out.String("mean = "); Out.Real(mean, 0); Out.Ln;
  END;

END mean;

END stats.

