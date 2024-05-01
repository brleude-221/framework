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
      IF celll(frame.strCell)^.string = '""' THEN
        INC(cntNil);
      ELSE
        INC(cntStr);
      END;
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

PROCEDURE Merge(VAR arr: ARRAY OF LONGINT; low, mid, high: LONGINT);
VAR
  i, j, k: LONGINT;
  n1, n2: LONGINT;
  left, right: POINTER TO ARRAY OF LONGINT;
BEGIN
  (* Determine sizes of two subarrays *)
  n1 := mid - low + 1;
  n2 := high - mid;

  (* Create temporary arrays *)
  NEW(left, n1);
  NEW(right, n2);

  (* Copy data to temporary arrays *)
  FOR i := 0 TO n1 - 1 DO
    left[i] := arr[low + i];
  END;
  FOR j := 0 TO n2 - 1 DO
    right[j] := arr[mid + 1 + j];
  END;

  (* Merge the temporary arrays back into arr[low..high] *)
  i := 0; (* Initial index of first subarray *)
  j := 0; (* Initial index of second subarray *)
  k := low; (* Initial index of merged subarray *)
  WHILE (i < n1) & (j < n2) DO
    IF left[i] <= right[j] THEN
      arr[k] := left[i];
      INC(i);
    ELSE
      arr[k] := right[j];
      INC(j);
    END;
    INC(k);
  END;

  (* Copy remaining elements of left[] if any *)
  WHILE i < n1 DO
    arr[k] := left[i];
    INC(i);
    INC(k);
  END;

  (* Copy remaining elements of right[] if any *)
  WHILE j < n2 DO
    arr[k] := right[j];
    INC(j);
    INC(k);
  END;

  (* Free temporary arrays *)
END Merge;

(* Merge sort algorithm *)
PROCEDURE MergeSort(VAR arr: ARRAY OF LONGINT; low, high: LONGINT);
VAR
  mid: LONGINT;
BEGIN
  IF low < high THEN
    (* Find the middle point *)
    mid := (low + high) DIV 2;

    (* Sort first and second halves *)
    MergeSort(arr, low, mid);
    MergeSort(arr, mid + 1, high);

    (* Merge the sorted halves *)
    Merge(arr, low, mid, high);
  END;
END MergeSort;

PROCEDURE medianMinMax*(f: frame.frm; c: INTEGER);
VAR
    intArr: POINTER TO ARRAY OF LONGINT;
    celll: frame.cell;
    intCount: LONGINT;
    i: INTEGER;
    median: REAL;
BEGIN
    NEW(intArr, f^.height);
    intCount := 0;
    i := 0;
    REPEAT
      celll := frame.read(f, c, i);
      IF celll IS frame.intCell THEN
        (*Out.String("i = "); Out.Int(i, 0); Out.Ln;*)
        intArr[intCount] := celll(frame.intCell)^.int;
        INC(intCount);
      END;
      INC(i);
    UNTIL i = f^.height - 1;

    IF intCount = 0 THEN
      Out.String("No integer values found"); Out.Ln;
      ELSE
        IF intCount < f^.height - 1 THEN
          Out.String("Attention! Non integer values are present in the column"); Out.Ln;
        END;
        MergeSort(intArr^, 0, intCount);
        (*Out.String("int count = "); Out.Int(intCount, 0); Out.Ln;*)
        IF (intCount + 1) MOD 2 = 1 THEN
          median := intArr[(intCount + 1) DIV 2 + 1];
        ELSE
          median := (intArr[intCount DIV 2] + intArr[(intCount DIV 2) + 1]) / 2.0;
        END;
        
      (* 
      i := 0;  
      REPEAT
        Out.Int(intArr[i], 0); Out.Ln;
        INC(i);
      UNTIL i = LEN(intArr^);
      *)
      Out.String("Minimum Value = "); Out.Int(intArr^[0], 0); Out.Ln;
      Out.String("Maximum Value = "); Out.Int(intArr^[intCount], 0); Out.Ln;
      Out.String("median = "); Out.Real(median, 0); Out.Ln;
    END;
END medianMinMax;

PROCEDURE mode*(f: frame.frm; c: INTEGER);
VAR
    intArr: POINTER TO ARRAY OF LONGINT;
    celll: frame.cell;
    intCount: LONGINT;
    i: INTEGER;
    median: REAL;
    currentElement, maxElement, currentCount, maxCount: LONGINT;
BEGIN
    NEW(intArr, f^.height);
    intCount := 0;
    i := 0;
    REPEAT
      celll := frame.read(f, c, i);
      IF celll IS frame.intCell THEN
        (*Out.String("i = "); Out.Int(i, 0); Out.Ln;*)
        intArr[intCount] := celll(frame.intCell)^.int;
        INC(intCount);
      END;
      INC(i);
    UNTIL i = f^.height - 1;

    IF intCount = 0 THEN
      Out.String("No integer values found"); Out.Ln;
      ELSE
        IF intCount < f^.height - 1 THEN
          Out.String("Attention! Non integer values are present in the column"); Out.Ln;
        END;
        MergeSort(intArr^, 0, intCount);
        (*Out.String("int count = "); Out.Int(intCount, 0); Out.Ln;*)

        currentElement := intArr[0];
        maxElement := intArr[0];
        currentCount := 0;
        maxCount := 0;        

        i := 0;
        REPEAT
            IF intArr[i] = currentElement THEN
              INC(currentCount);
            ELSE
              IF currentCount > maxCount THEN
                maxElement := currentElement;
                maxCount := currentCount;
              END;
        
              currentElement := intArr[i];
              currentCount := 1;
            END;
          INC(i);
        UNTIL i = intCount + 1
      (* 
      i := 0;  
      REPEAT
        Out.Int(intArr[i], 0); Out.Ln;
        INC(i);
      UNTIL i = LEN(intArr^ + 1);
      *)
    END;

    IF currentCount > maxCount THEN
      maxElement := currentElement;
      maxCount := currentCount;
    END;

    IF maxCount # 1 THEN
      INC(maxCount)
    END;

    Out.String("Mode = "); Out.Int(maxElement, 0); Out.Ln;
    Out.String("Frequency of mode = "); Out.Int(maxCount, 0); Out.Ln;

END mode;

PROCEDURE colStats*(f: frame.frm; c: INTEGER);
VAR
  celll: frame.cell;
  i: INTEGER;
  cntInt, cntStr, cntNil: INTEGER;
  intSum, intCount: LONGINT;
  intArr: POINTER TO ARRAY OF LONGINT;
  median, mean: REAL;
  currentElement, maxElement, currentCount, maxCount: LONGINT;
  intSumReal: REAL;
BEGIN
  i := 0;
  cntInt := 0; cntStr := 0; cntNil := 0;
  intSum := 0; intCount := 0;
  currentElement := 0; maxElement := 0; currentCount := 0; maxCount := 0;

  NEW(intArr, f^.height);

  REPEAT
    celll := frame.read(f, c, i);
    IF celll IS frame.intCell THEN
      INC(cntInt);
      intSum := intSum + celll(frame.intCell)^.int;
      intArr[intCount] := celll(frame.intCell)^.int;
      INC(intCount);
    ELSIF celll = NIL THEN
      INC(cntNil);
    ELSIF celll IS frame.strCell THEN
      IF celll(frame.strCell)^.string = '""' THEN
        INC(cntNil);
      ELSE
        INC(cntStr);
      END;
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

  IF intCount = 0 THEN
    Out.String("No integer values found"); Out.Ln;
  ELSE
    IF intCount < f^.height THEN
      Out.String("Attention! Non-integer values are present in the column"); Out.Ln;
    END;

    MergeSort(intArr^, 0, intCount - 1);

    IF (intCount MOD 2) = 1 THEN
      median := intArr[intCount DIV 2];
    ELSE
      median := (intArr[intCount DIV 2] + intArr[(intCount DIV 2) - 1]) / 2.0;
    END;

    intSumReal := intSum;
    mean := intSumReal / intCount;

    Out.String("Sum = "); Out.Int(intSum, 0); Out.Ln;
    Out.String("Mean = "); Out.Real(mean, 0); Out.Ln;
    Out.String("Minimum Value = "); Out.Int(intArr^[0], 0); Out.Ln;
    Out.String("Maximum Value = "); Out.Int(intArr^[intCount - 1], 0); Out.Ln;
    Out.String("Median = "); Out.Real(median, 0); Out.Ln;

    currentElement := intArr[0];
    maxElement := intArr[0];

    i := 0;
        REPEAT
            IF intArr[i] = currentElement THEN
              INC(currentCount);
            ELSE
              IF currentCount > maxCount THEN
                maxElement := currentElement;
                maxCount := currentCount;
              END;
    
              currentElement := intArr[i];
              currentCount := 1;
            END;
          INC(i);
        UNTIL i = intCount;

    IF currentCount > maxCount THEN
      maxElement := currentElement;
      maxCount := currentCount;
    END;

    Out.String("Mode = "); Out.Int(maxElement, 0); Out.Ln;
    Out.String("Frequency of mode = "); Out.Int(maxCount, 0); Out.Ln;
  END;
END colStats;


PROCEDURE frmStats*(f: frame.frm);
VAR
  i: INTEGER;
BEGIN
  i := 0;
  REPEAT
    Out.String("Column"); Out.Int(i, 0); Out.Ln;
    colStats(f, i);
    Out.Ln;
    INC(i);
  UNTIL i = f^.width;
END frmStats;

END stats.

