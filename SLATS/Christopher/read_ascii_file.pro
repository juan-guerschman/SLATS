;Write a function that returns data from a ASCII file, irrespective of the number of fields
; in the file nor their data type
;    FUNCTION returns an array of structures containing the contents of the data file. Every structure within
;    the array of structures returned corresponds to a single line of data within the ASCII file. Each field in the
;    ASCII file (obtained from the header) has a corresponding field within the structure (contained in the array of structures).
;    FUNCTION returns ERROR if there are any errors that occur
;    FUNCTION returns a string containing the header string if this option (KEYWORD) is selected
; input_FN:         The ASCII input data file
; direc:            The directory of the input file (optional)
; N_COMMENTS:       The number of comment strings (lines). This DOES NOT include the HEADER string
; delim_char:       Delimiter character (type string). Defines the ASCII file delimiter. Default is ' ' (char. space)
; NO_HEADER:        KEYWORD indicating there is NO HEADER string in the ASCII file
; comment_str:      An output argument that will contain all the comment strings within the ASCII file
; header_str:       Selected if one wants the header to be returned, in addition to the contents of the data file
; field_arr:        Selected if one wants only certain fields to be returned (the specified fields in field_arr are
;                    a subset of all the fields contained in the file). Note that this argument can be used together
;                    with the keyword NO_HEADER (indicating there is no header in the file). In this case, field_arr
;                    can contain the names of all the fields in the array and is normally used when this information
;                    is absent from the data file. If no header information is available but the user wants to only
;                    extract certain fields, (s)he can do this by also specifying 'field_arr_ncol' (see below). This
;                    specifies the column (field) number corresponding to the fields specified in field_arr
;                    NOTE!!!!!! If header information is available and field_arr is specified (specifying a subset of data fields),
;                    The ORDER of the fields listed MUST match the order in the header file!
; input_data_FMT:   A format string to be used when reading in data. For large files, this will be much
;                     quicker than the multiple loops used to read in data where data conversions for each field
;                     must be applied for each line of code. This format string needs to be
;                     precisely specified for the input file but the function will still automatically
;                     identify all fields in the file
; SCI_FMT:          Indicates that the file contains data fields in scientific format. Thus, when testing
;                     if a field is a string, if only an 'E' or 'e' is present (along with +/-), the field is
;                     treated as a double/float. All fields that are in scientific format will be converted
;                     to a double/float
;                     irrespective of whether it is possible to convert to an integer/long
; fields_are_str:   Contains an array of strings. Each string contains a field particular within the header file of the ASCII file.
;                    Data corresponding to these specified fields will remain as strings in the output data
;                    structure irrespective of what the data is (i.e. if it is possible to convert the data
;                    to integers or floats). In these cases, the data in the file are kept as TYPE STRING
; fields_are_flt:   Same as fields_are_str. All selected fields will be set as type FLOAT
; fields_are_dbl:   Same as fields_are_str.
; fields_are_int:   Same as fields_are_str
; fields_are_long:  Same as fields_are_str
; field_type_ID:    Directly specify the data type via an ID that is defined in the program
;                     data_type  =  {INTEG_TYPE:                1,               $;
;                     LONG_TYPE:               2,               $;
;                     LONG64_TYPE:             3,               $;
;                     FLOAT_TYPE:              4,               $;
;                     DBL_TYPE:                5,               $;
;                     STR_TYPE:                6               $;
;                    }
; RETURN_FLOAT:     Indicates to return all data that are not integers as FLOATING point and not
;                    DOUBLE floating point (the default setting)
; RETURN_LONG:      Indicates to return all data that are identified as integers as LONG integers
; SURPRESS_MSG:      Indicates not to print any messages contained in READ_ASCII_FILE ONLY
; RETURN_HDR:       Only return header string, comment_str will also be returned if selected
; CONVERT_DATE:     A keyword indicating to convert the contents of a date field in the ASCII file into
;                    individual date fields (year, mth, day). The field in the input ASCII file can either
;                    be a string or a single integer (e.g. 20080101 or 2008-01-01)
;date_fld:           Used in conjunction with CONVERT_DATE. Contains the field in the input ASCII file that
;                    contains the date to be converted into separate date fields. If not defined, is automatically
;                    set to 'DATE' and checks if 'DATE' exists in the input ASCII file (after converting everything to capitals)
;                   If a date field in the input ASCII file can not be found (either using the default setting
;                    or defined field contained in date_fld), no date conversion will be produced and an error
;                    message will be displayed. HOWEVER, individual date fields will be present in the structure
;                    passed back by READ_ASCII_FILE. In this case, the values for the individual fields will be set to zero (0)
;addn_flds:         A STRUCTURE containing additional fields that will be added to the structure (array of structures)
;                    returned by READ_ASCII_FILE. By passing a structure (rather than a string array), the data type of each 
;                    additional field is already defined :)
;ALL_FLDS_STR:      A keyword indicating that all fields are to be returned as TYPE string
;field_col_no:      An index array listing the column number of all input fields contained in field _arr
;                   This is ONLY required if, when a header is NOT PRESENT in the input file, a subset of the
;                     total number of fields are to be extracted from the file. Thus, we can not do a string match
;                     between the required fields (specified in field_arr) and the fields listed in the header. This
;                     is how the array indices are to be determined but we can't do this if there is no header
;                   NOTE: One can specify both field_arr and field_col_no. In this case, field_arr is simply used
;                     for the field names and field_col_no is used to identify which columns apply to which field
;                     (May require that the keyword NO_HEADER be set to TRUE). If you are specifying the field_arr
;                     (field names), there is no need to read and interpret the header string of the ASCII file
;
;valid_field_indarr:     An index array that is used to indicate which fields in the header string are valid 
;                        (and relate to column data within the ASCII file). This is used if there are more header elements
;                        than there are columns of data (i.e. an incorrectly delimited header line such that the extracted number
;                        of data fields (header elements) does not match the number of columns within the ASCII file
;                        The default is to trim the number of extracted fields within the header file to match the number of
;                        columns of data in the ASCII file
;                        
;
;REMOVE_MULTIP_FIELDS:   A keyword indicating to remove multiple occurrences of fields (i.e. fields with the same name)
;                        Only the first occurrence of the field is retained. The other occurrences are removed and
;                        will not be present in the output returned by the function. If this keyword is set to false
;                        (or left undefined) and there are multiple occurrences of fields, their names are adjusted
;                        using a counter value.
;                        E.g. multiple occurrences of field 'var' becomes 'var_01, 'var_02', 'var_03', etc...
;uniq_comment_str:    A string (or substring) that identifies a line of text in an ASCII file. All preceding text
;                       above this line is ignored (even if data values are present but presumably not of interest)
;                       data after this line are considered valid data and are read in. If NO_HEADER is set to FALSE,
;                       it is assumed that the next line is a suitable header string
;N_DATA_TO_READ:      This is an optional number indicating the amount of data to read in after the header line. This
;                       is likely to be supplied together with 'uniq_comment_str' as it is likely only a section of the
;                       file is to be read in (unless the section of interest extends to the end of the file)
;CSV_FILE:            A keyword indicating that the input file is a CSV type file (comma separated values)
;                       Automatically sets the delimiter character to "," (delim_char = ",")'
;INPUT_HELP:          Prints out the function definition (all the possible input arguments) and exits
;INPUT_HELP_DETAIL:   Prints out a description of all the input arguments





;Write a function to return the possible type of variable (DOUBLE, INTEGER, STRING) contained in
; an input string
; input_str:           The input string to be tested as how it can be converted
; PRINT_MSG:           A Keyword indicating to print to screen the type of the variable contained in
;                       input_str
; RETURN_LONG:         Keyword indicating to return all integers as LONG integers
; RETURN_FLOAT:        Keyword indicating to return all fraction variables as FLOATING point,
;                       Default is DOUBLE
; SCI_FMT:             Keyword indicating to check to see if the contents contained in input_str
;                       is in fact a variable written in scientific format
; KEEP_WHITE_SPACES:   Keyword indicating NOT to clean up any space characters within the string. Normally they
;                       are removed
FUNCTION TEST_DATA_TYPE_IN_STR, input_str, PRINT_MSG=PRINT_MSG, RETURN_LONG=RETURN_LONG,       $
                                RETURN_FLOAT=RETURN_FLOAT, SCI_FMT=SCI_FMT, KEEP_WHITE_SPACES=KEEP_WHITE_SPACES

  TRUE  =  1
  FALSE =  0
  ERROR = -1
  UNDEF =  0

  ZERO_DIFF = 0

  data_type  =  {INTEG_TYPE:              1,               $;
                 LONG_TYPE:               2,               $;
                 LONG64_TYPE:             3,               $;
                 FLOAT_TYPE:              4,               $;
                 DBL_TYPE:                5,               $;
                 STR_TYPE:                6               $;
                }

  DCML_CHAR  =  '.'
  SNGL_ELEM  =  1
  FST_POS    =  0

  ;First we need to remove any white spaces in the input string (input_str) as they will be
  ; recognised as non-numeric characters. Unless otherwise specified, these white spaces should be removed
  IF(KEYWORD_SET(KEEP_WHITE_SPACES) EQ FALSE)  THEN  input_str  =  STRCOMPRESS(input_str, /REMOVE_ALL)

  ;First we must check if there are any non-numeric characters in the string
  ; (i.e. digits BUT ALSO including '.', '-', and '+')
  test_index  =  ISALGEBRAIC(input_str)
  tmp  =  WHERE(test_index  EQ  FALSE)
  IF(tmp[0]  NE  ERROR)  THEN BEGIN

    ;Now we must check to see if in fact input_str is in scientific notation
    ; and will therefore contain an 'e' or 'E'. These are compatible with integers and floats/doubles
    IF(KEYWORD_SET(SCI_FMT)  EQ  TRUE)  THEN  BEGIN
      temp_str    =  input_str
      temp_str    =  STRSPLIT(STRLOWCASE(temp_str), 'e', /EXTRACT)
      temp_str    =  STRJOIN(temp_str)
      test_index  =  ISALGEBRAIC(temp_str)
      tmp         =  WHERE(test_index  EQ  FALSE)
    ENDIF

    IF(tmp[0]  NE  ERROR)  THEN  BEGIN

      ;Variable type contained in input_str IS A STRING
      IF(KEYWORD_SET(PRINT_MSG) EQ TRUE) THEN print, 'STRING'
      RETURN, data_type.STR_TYPE
    ENDIF
  ENDIF

  ;Now we need to check for the character '-' and where it exists in the string
  ; If it exists in the first position, it is likely that the string is an integer
  ; If '-' appears elsewhere in the string or multiple times, then it is likely that
  ;  the string can only remain as a string (i.e. can not be converted into an integer/float/double
  ; We must also watch for whether the value contained in the input string is a number of scientific format
  IF(KEYWORD_SET(SCI_FMT)  EQ  TRUE)  THEN  BEGIN
    temp_str  =  input_str
    temp_str  =  STRSPLIT(STRLOWCASE(temp_str), 'e-', /EXTRACT)
    temp_str  =  STRJOIN(temp_str)
  ENDIF ELSE temp_str  =  input_str

  test_index  =  STRPOS(temp_str, '-')
  IF(test_index[0]  NE  ERROR)  THEN  BEGIN
    IF((N_ELEMENTS(test_index)  GT  SNGL_ELEM) OR (test_index[0]  NE  FST_POS))  THEN  BEGIN

      ;Variable type contained in input_str IS A STRING
      IF(KEYWORD_SET(PRINT_MSG) EQ TRUE) THEN print, 'STRING'
      RETURN, data_type.STR_TYPE
    ENDIF
  ENDIF

  ;We now check for the character '+' as is done directly above
  IF(KEYWORD_SET(SCI_FMT)  EQ  TRUE)  THEN  BEGIN
    temp_str  =  input_str
    temp_str  =  STRSPLIT(STRLOWCASE(temp_str), 'e+', /EXTRACT)
    temp_str  =  STRJOIN(temp_str)
  ENDIF ELSE temp_str  =  input_str

  test_index  =  STRPOS(temp_str, '+')
  IF(test_index[0]  NE  ERROR)  THEN  BEGIN
    IF((N_ELEMENTS(test_index)  GT  SNGL_ELEM) OR (test_index[0]  NE  FST_POS))  THEN  BEGIN

      ;Variable type contained in input_str IS A STRING
      IF(KEYWORD_SET(PRINT_MSG) EQ TRUE) THEN print, 'STRING'
      RETURN, data_type.STR_TYPE
    ENDIF
  ENDIF

  ;OK, now we think that the contents in 'input_str' can be converted into either a DOUBLE/FLOAT
  ; or an INTEGER/LONG
  ;We now look for a decimal point '.' to determine if the contents in input_str is an integer or not
  IS_A_LONG64  =  FALSE
  IS_A_LONG    =  FALSE
  IS_AN_INT    =  FALSE

  test_index  =  STRPOS(input_str, DCML_CHAR)
  IF(test_index[0]  EQ  ERROR)  THEN  BEGIN ;Indicates contents in input_str is an INTEGER/LONG

    ;Need to work out the size of the value contained in input_str so to determine the appopriate
    ; integer type (INT, LONG, LONG64) that is required
    z = LONG64(input_str) - LONG(input_str)
    IF(z  NE  ZERO_DIFF)  THEN  IS_A_LONG64  =  TRUE ELSE BEGIN
      z = LONG(input_str) - FIX(input_str)
      IF(z  NE  ZERO_DIFF)  THEN  IS_A_LONG  =  TRUE ELSE IS_AN_INT  =  TRUE
    ENDELSE

    IF((KEYWORD_SET(RETURN_LONG)  EQ  TRUE)  AND  (IS_A_LONG64 EQ FALSE)) THEN IS_A_LONG = TRUE

    IF(IS_A_LONG64 EQ TRUE) THEN BEGIN
      IF(KEYWORD_SET(PRINT_MSG) EQ TRUE) THEN print, 'LONG64'
      RETURN, data_type.LONG64_TYPE
    ENDIF
    IF(IS_A_LONG EQ TRUE) THEN BEGIN
      IF(KEYWORD_SET(PRINT_MSG) EQ TRUE) THEN print, 'LONG'
      RETURN, data_type.LONG_TYPE
    ENDIF
    IF(IS_AN_INT EQ TRUE) THEN BEGIN
      IF(KEYWORD_SET(PRINT_MSG) EQ TRUE) THEN print, 'INT'
      RETURN, data_type.INTEG_TYPE
    ENDIF

  ENDIF ELSE BEGIN

    IF(KEYWORD_SET(PRINT_MSG) EQ TRUE) THEN BEGIN
      IF(KEYWORD_SET(RETURN_FLOAT)  EQ  TRUE)  THEN  print, 'FLOAT' ELSE print, 'DOUBLE'
    ENDIF

    IF(KEYWORD_SET(RETURN_FLOAT)  EQ  FALSE) THEN RETURN, data_type.DBL_TYPE              $
                                             ELSE RETURN, data_type.FLOAT_TYPE
  ENDELSE

;  RETURN, ERROR ;Should never get here

END

; Simple function that generates a structure containing a variable of type 'field_type' and the
;  corresponging structure tag is the string field_tag
FUNCTION GENERATE_STRUCTURE, field_tag, field_type

  TRUE  =  1
  FALSE =  0
  ERROR = -1
  UNDEF =  0

  ZERO_DIFF = 0

  data_type  =  {INTEG_TYPE:              1,               $;
                 LONG_TYPE:               2,               $;
                 LONG64_TYPE:             3,               $;
                 FLOAT_TYPE:              4,               $;
                 DBL_TYPE:                5,               $;
                 STR_TYPE:                6               $;
                }

  IF((N_ELEMENTS(field_tag) EQ UNDEF)  OR                            $
     (N_ELEMENTS(field_type) EQ UNDEF)) THEN RETURN, ERROR

  field_tag  =  IDL_VALIDNAME(field_tag, /CONVERT_ALL)

  IF(field_type  EQ  data_type.INTEG_TYPE)   THEN  output_struc  =  CREATE_STRUCT(field_tag,  0)
  IF(field_type  EQ  data_type.LONG_TYPE)    THEN  output_struc  =  CREATE_STRUCT(field_tag,  0L)
  IF(field_type  EQ  data_type.LONG64_TYPE)  THEN  output_struc  =  CREATE_STRUCT(field_tag,  0L)
  IF(field_type  EQ  data_type.FLOAT_TYPE)   THEN  output_struc  =  CREATE_STRUCT(field_tag,  0.0)
  IF(field_type  EQ  data_type.DBL_TYPE)     THEN  output_struc  =  CREATE_STRUCT(field_tag,  0.0d)
  IF(field_type  EQ  data_type.STR_TYPE)     THEN  output_struc  =  CREATE_STRUCT(field_tag,  '')

  RETURN, output_struc
END

FUNCTION CONV_TYPE, input_str, var_type

  TRUE  =  1
  FALSE =  0
  ERROR = -1
  UNDEF =  0

  DEFAULT_NO_DATA  =  -999

  ZERO_DIFF = 0

  data_type  =  {INTEG_TYPE:              1,               $;
                 LONG_TYPE:               2,               $;
                 LONG64_TYPE:             3,               $;
                 FLOAT_TYPE:              4,               $;
                 DBL_TYPE:                5,               $;
                 STR_TYPE:                6               $;
                }

  IF((N_ELEMENTS(input_str) EQ UNDEF)  OR                            $
     (N_ELEMENTS(var_type) EQ UNDEF)) THEN RETURN, ERROR

  conver_OK  =  FALSE
  ON_IOERROR, error_status

  IF(var_type  EQ  data_type.INTEG_TYPE)   THEN  output_val  =  FIX(input_str)
  IF(var_type  EQ  data_type.LONG_TYPE)    THEN  output_val  =  LONG(input_str)
  IF(var_type  EQ  data_type.LONG64_TYPE)  THEN  output_val  =  LONG64(input_str)
  IF(var_type  EQ  data_type.FLOAT_TYPE)   THEN  output_val  =  FLOAT(input_str)
  IF(var_type  EQ  data_type.DBL_TYPE)     THEN  output_val  =  DOUBLE(input_str)
  IF(var_type  EQ  data_type.STR_TYPE)     THEN  output_val  =  STRING(input_str)

  conver_OK  =  TRUE

  error_status:IF(conver_OK  EQ  FALSE)  THEN  BEGIN

    IF(var_type  EQ  data_type.INTEG_TYPE)   THEN  output_val  =  DEFAULT_NO_DATA
    IF(var_type  EQ  data_type.LONG_TYPE)    THEN  output_val  =  LONG(DEFAULT_NO_DATA)
    IF(var_type  EQ  data_type.LONG64_TYPE)  THEN  output_val  =  LONG64(DEFAULT_NO_DATA)
    IF(var_type  EQ  data_type.FLOAT_TYPE)   THEN  output_val  =  FLOAT(DEFAULT_NO_DATA)
    IF(var_type  EQ  data_type.DBL_TYPE)     THEN  output_val  =  DOUBLE(DEFAULT_NO_DATA)
    IF(var_type  EQ  data_type.STR_TYPE)     THEN  output_val  =  STRING(DEFAULT_NO_DATA)

  ENDIF

  RETURN, output_val
END

;Function written to convert contents in the field 'DATE' into separate date fields
; NEED GAMAP functions
FUNCTION CONV_DATE, data_arr, date_fld

  TRUE  =  1
  FALSE =  0
  ERROR = -1
  UNDEF =  0

  STRING_TYPE  =  7
  INT_TYPE     =  2
  LONG_TYPE    =  3



  IF(N_ELEMENTS(date_fld) EQ UNDEF) THEN date_fld  =  'DATE'

  ;First we must identify the date field in data_arr
  fld_arr_tmp   =  TAG_NAMES(data_arr)
  date_fld_ind  =  WHERE(STRUPCASE(fld_arr_tmp)  EQ  STRUPCASE(date_fld))
  IF(date_fld_ind[0]  EQ  ERROR)  THEN  BEGIN
    print, 'READ_ASCII_FILE:CONV_DATE: Can not locate date field in data_arr'
    print, '                           date_fld: ', date_fld
    print, '                           Can not convert date_field into separate date fields'
    RETURN, ERROR
  ENDIF

  ;Now extract date field
  date_fld_arr  =  data_arr.(date_fld_ind)
  ;Now we need to remove any characters (-, ., /, _) within the string. First we test if
  ; date_fld_arr is type STRING
  type_test  =  SIZE(date_fld_arr, /TYPE)
  rmve_char_arr  =  ['-', '.', '/', '_']
  IF(type_test  EQ  STRING_TYPE)  THEN  BEGIN

    FOR i=0, N_ELEMENTS(rmve_char_arr) -1 DO BEGIN

      char_test  =  STRPOS(date_fld_arr[0], rmve_char_arr[i])
      IF(char_test[0]  NE  ERROR)  THEN  BEGIN
        date_fld_arr_tmp  =  STRREPL(date_fld_arr, rmve_char_arr[i], ' ')
        date_fld_arr_tmp  =  STRCOMPRESS(date_fld_arr_tmp, /REMOVE_ALL)
        date_fld_arr      =  date_fld_arr_tmp
        UNDEFINE, date_fld_arr_tmp
      ENDIF
    ENDFOR
  ENDIF

  ;Now we can convert the array date_fld_arr into separate date fields (YR, MTH, DAY)
  date_fld_arr  =  LONG(date_fld_arr)
  DATE2YMD, date_fld_arr, yr_arr, mth_arr, day_arr

  ;Now we copy the individual date fields into data_arr
  data_arr.year  =  yr_arr[*]
  data_arr.mth   =  mth_arr[*]
  data_arr.day   =  day_arr[*]

  RETURN, FALSE
END

PRO PRINT_HELP

  print, 'Input parameters for READ_ASCII_FILE...'
  print, ''

  print, ' FUNCTION READ_ASCII_FILE, input_FN, direc=direc, N_COMMENTS=N_COMMENTS, delim_char=delim_char,       $'
  print, '                           NO_HEADER=NO_HEADER, comment_str=comment_str, header_str=header_str,       $'
  print, '                           field_arr=field_arr, input_data_FMT=input_data_FMT, SCI_FMT=SCI_FMT,       $'
  print, '                           RETURN_FLOAT=RETURN_FLOAT, RETURN_LONG=RETURN_LONG,                        $'
  print, '                           SURPRESS_MSG=SURPRESS_MSG, RETURN_HDR=RETURN_HDR,                          $'
  print, '                           CONVERT_DATE=CONVERT_DATE, date_fld=date_fld, addn_fields=addn_fields,     $'
  print, '                           ALL_FLDS_STR=ALL_FLDS_STR, field_col_no=field_col_no,                      $'
  print, '                           REMOVE_MULTIP_FIELDS=REMOVE_MULTIP_FIELDS, N_DATA_TO_READ=N_DATA_TO_READ,  $'
  print, '                           uniq_comment_str=uniq_comment_str, fields_are_str=fields_are_str,          $'
  print, '                           fields_are_flt=fields_are_flt, fields_are_dbl=fields_are_dbl,              $'
  print, '                           fields_are_ind=fields_are_int, fields_are_long=fields_are_long,            $'
  print, '                           field_type_ID=field_type_ID, CSV_FILE=CSV_FILE, INPUT_HELP=INPUT_HELP,     $'
  print, '                           INPUT_HELP_DETAIL=INPUT_HELP_DETAIL'
  print, ''
  print, ''
END

PRO PRINT_HELP_DETAIL

  print, 'READ_ASCII_FILE help (more detail!)...'
  print, ''
  print, ''
  print, '    FUNCTION returns an array of structures containing the contents of the data file. Every structure within
  print, '    the array of structures returned corresponds to a single line of data within the ASCII file. Each field in the
  print, '    ASCII file (obtained from the header) has a corresponding field within the structure (contained in the array of structures).
  print, '    FUNCTION returns ERROR if there are any errors that occur
  print, '    FUNCTION returns a string containing the header string if this option (KEYWORD) is selected
  print, ' input_FN:         The ASCII input data file
  print, ' direc:            The directory of the input file (optional)
  print, ' N_COMMENTS:       The number of comment strings (lines). This DOES NOT include the HEADER string
  print, ' delim_char:       Delimiter character (type string). Defines the ASCII file delimiter. Default is " " (char. space)'
  print, ' NO_HEADER:        KEYWORD indicating there is NO HEADER string in the ASCII file
  print, ' comment_str:      An output argument that will contain all the comment strings within the ASCII file
  print, ' header_str:       Selected if one wants the header to be returned, in addition to the contents of the data file
  print, ' field_arr:        Selected if one wants only certain fields to be returned (the specified fields in field_arr are
  print, '                    a subset of all the fields contained in the file). Note that this argument can be used together
  print, '                    with the keyword NO_HEADER (indicating there is no header in the file). In this case, field_arr
  print, '                    can contain the names of all the fields in the array and is normally used when this information
  print, '                    is absent from the data file. If no header information is available but the user want to only
  print, '                    extract certain fields, (s)he can do this by also specifying "field_arr_ncol" (see below). This
  print, '                    specifies the column (field) number corresponding to the fields specified in field_arr
  print, '                    NOTE!!!!!! If header information is available and field_arr is specified (specifying a subset of data fields),
  print, '                    The ORDER of the fields listed MUST match the order in the header file!
  print, ' input_data_FMT:   A format string to be used when reading in data. For large files, this will be much
  print, '                     quicker than the multiple loops used to read in data where data conversions for each field
  print, '                     must be applied for each line of code. This format string needs to be
  print, '                     precisely specified for the input file but the function will still automatically
  print, '                     identify all fields in the file
  print, ' SCI_FMT:          Indicates that the file contains data fields in scientific format. Thus, when testing
  print, '                     if a field is a string, if only an "E" or "e" is present (along with +/-), the field is
  print, '                     treated as a double/float. All fields that are in scientific format will be converted
  print, '                     to a double/float
  print, '                     irrespective of whether it is possible to convert to an integer/long
  print, ' fields_are_str:   Contains an array of strings that contain fields within the header file of the ASCII file.
  print, '                    Data corresponding to these fields will remain as strings in the output data
  print, '                    structure irrespective of what the data is (i.e. if it is possible to convert the data
  print, '                    to integers or floats). In these cases, the data in the file are kept as TYPE STRING
  print, ' fields_are_flt:   Same as fields_are_str. All selected fields will be set as type FLOAT
  print, ' fields_are_dbl:   Same as fields_are_str.
  print, ' fields_are_int:   Same as fields_are_str
  print, ' fields_are_long:  Same as fields_are_str
  print, ' field_type_ID:    Directly specify the data type via an ID that is defined in the program
  print, '                     data_type  =  {INTEG_TYPE:                1,               $;
  print, '                     LONG_TYPE:               2,               $;
  print, '                     LONG64_TYPE:             3,               $;
  print, '                     FLOAT_TYPE:              4,               $;
  print, '                     DBL_TYPE:                5,               $;
  print, '                     STR_TYPE:                6               $;
  print, '                    }
  print, ' RETURN_FLOAT:     Indicates to return all data that are not integers as FLOATING point and not
  print, '                    DOUBLE floating point (the default setting)
  print, ' RETURN_LONG:      Indicates to return all data that are identified as integers as LONG integers
  print, ' SURPRESS_MSG:      Indicates not to print any messages contained in READ_ASCII_FILE ONLY
  print, ' RETURN_HDR:       Only return header string, comment_str will also be returned if selected
  print, ' CONVERT_DATE:     A keyword indicating to convert the contents of a date field in the ASCII file into
  print, '                    individual date fields (year, mth, day). The field in the input ASCII file can either
  print, '                    be a string or a single integer (e.g. 20080101 or 2008-01-01)
  print, 'date_fld:           Used in conjunction with CONVERT_DATE. Contains the field in the input ASCII file that
  print, '                    contains the date to be converted into separate date fields. If not defined, is automatically
  print, '                    set to "DATE" and checks if "DATE" exists in the input ASCII file (after converting everything to capitals)
  print, '                   If a date field in the input ASCII file can not be found (either using the default setting
  print, '                    or defined field contained in date_fld), no date conversion will be produced and an error
  print, '                    message will be displayed. HOWEVER, individual date fields will be present in the structure
  print, '                    passed back by READ_ASCII_FILE. In this case, the values for the individual fields will be set to zero (0)
  print, 'addn_flds:         A STRUCTURE containing additional fields that will be added to the structure (array of structures)
  print, '                    returned by READ_ASCII_FILE. By passing a structure (rather than a string array), the data type of each 
  print, '                    additional field is already defined :)
  print, 'ALL_FLDS_STR:      A keyword indicating that all fields are to be returned as TYPE string
  print, 'field_col_no:      An index array listing the column number of all input fields contained in field_arr
  print, '                   This is ONLY required if, when a header is NOT PRESENT in the input file, a subset of the
  print, '                     total number of fields are to be extracted from the file. Thus, we can not do a string match
  print, '                     between the required fields (specified in field_arr) and the fields listed in the header. This
  print, '                     is how the array indices are to be determined but we can not do this if there is no header
  print, '                   NOTE: One can specify both field_arr and field_col_no. In this case, field_arr is simply used
  print, '                     for the field names and field_col_no is used to identify which columns apply to which field
  print, '
  print, 'REMOVE_MULTIP_FIELDS:   A keyword indicating to remove multiple occurrences of fields (i.e. fields with the same name)
  print, '                        Only the first occurrence of the field is retained. The other occurrences are removed and
  print, '                        will not be present in the output returned by the function. If this keyword is set to false
  print, '                        (or left undefined) and there are multiple occurrences of fields, their names are adjusted
  print, '                        using a counter value.
  print, '                        E.g. multiple occurrences of field "var" becomes "var_01" "var_02", "var_03", etc...
  print, 'uniq_comment_str:    A string (or substring) that identifies a line of text in an ASCII file. All preceding text
  print, '                       above this line is ignored (even if data values are present but presumably not of interest)
  print, '                       data after this line are considered valid data and are read in. If NO_HEADER is set to FALSE,
  print, '                       it is assumed that the next line is a suitable header string
  print, 'N_DATA_TO_READ:      This is an optional number indicating the amount of data to read in after the header line. This
  print, '                       is likely to be supplied together with "uniq_comment_str" as it is likely only a section of the
  print, '                       file is to be read in (unless the section of interest extends to the end of the file)
  print, 'CSV_FILE:            A keyword indicating that the input file is a CSV type file (comma separated values)
  print, '                       Automatically sets the delimiter character to "," (delim_char = ",")'
  print, ''
  print, ''
  print, 'FUNCTION READ_ASCII_FILE, input_FN, direc=direc, N_COMMENTS=N_COMMENTS, delim_char=delim_char,       $
  print, '                          NO_HEADER=NO_HEADER, comment_str=comment_str, header_str=header_str,       $
  print, '                          field_arr=field_arr, input_data_FMT=input_data_FMT, SCI_FMT=SCI_FMT,       $
  print, '                          RETURN_FLOAT=RETURN_FLOAT, RETURN_LONG=RETURN_LONG,                        $
  print, '                          SURPRESS_MSG=SURPRESS_MSG, RETURN_HDR=RETURN_HDR,                          $
  print, '                          CONVERT_DATE=CONVERT_DATE, date_fld=date_fld, addn_fields=addn_fields,     $
  print, '                          ALL_FLDS_STR=ALL_FLDS_STR, field_col_no=field_col_no,                      $
  print, '                          REMOVE_MULTIP_FIELDS=REMOVE_MULTIP_FIELDS, N_DATA_TO_READ=N_DATA_TO_READ,  $
  print, '                          uniq_comment_str=uniq_comment_str, fields_are_str=fields_are_str,          $
  print, '                          fields_are_flt=fields_are_flt, fields_are_dbl=fields_are_dbl,              $
  print, '                          fields_are_ind=fields_are_int, fields_are_long=fields_are_long,            $
  print, '                          field_type_ID=field_type_ID, INPUT_HELP=INPUT_HELP,                        $
  print, '                          INPUT_HELP_DETAIL=INPUT_HELP_DETAIL

END



;__________________________________
;
FUNCTION READ_ASCII_FILE, input_FN, direc=direc, N_COMMENTS=N_COMMENTS, delim_char=delim_char,       $
                          NO_HEADER=NO_HEADER, comment_str=comment_str, header_str=header_str,       $
                          field_arr=field_arr, input_data_FMT=input_data_FMT, SCI_FMT=SCI_FMT,       $
                          RETURN_FLOAT=RETURN_FLOAT, RETURN_LONG=RETURN_LONG,                        $
                          SURPRESS_MSG=SURPRESS_MSG, RETURN_HDR=RETURN_HDR,                          $
                          CONVERT_DATE=CONVERT_DATE, date_fld=date_fld, addn_fields=addn_fields,     $
                          ALL_FLDS_STR=ALL_FLDS_STR, field_col_no=field_col_no,                      $
                          valid_field_indarr=valid_field_indarr,                                     $
                          REMOVE_MULTIP_FIELDS=REMOVE_MULTIP_FIELDS, N_DATA_TO_READ=N_DATA_TO_READ,  $
                          uniq_comment_str=uniq_comment_str, fields_are_str=fields_are_str,          $
                          fields_are_flt=fields_are_flt, fields_are_dbl=fields_are_dbl,              $
                          fields_are_ind=fields_are_int, fields_are_long=fields_are_long,            $
                          field_type_ID=field_type_ID, CSV_FILE=CSV_FILE, INPUT_HELP=INPUT_HELP,     $
                          HELP_DETAIL=HELP_DETAIL

  COMPILE_OPT DEFINT32
  FORWARD_FUNCTION TEST_DATA_TYPE_IN_STR, GENERATE_STRUCTURE, CONV_TYPE, CONV_DATE, PRINT_HELP, PRINT_HELP_DETAIL

  TRUE  =  1
  FALSE =  0
  ERROR = -1
  UNDEF =  0

  ELEM_100  =  100
  
  CSV_str   =  '.csv'

  data_type  =  {INTEG_TYPE:              1,               $;
                 LONG_TYPE:               2,               $;
                 LONG64_TYPE:             3,               $;
                 FLOAT_TYPE:              4,               $;
                 DBL_TYPE:                5,               $;
                 STR_TYPE:                6               $;
                }

  IF(KEYWORD_SET(INPUT_HELP)  EQ  TRUE)  THEN  BEGIN
    PRINT_HELP
    RETURN, TRUE
  ENDIF
  IF(KEYWORD_SET(HELP_DETAIL)  EQ  TRUE)  THEN  BEGIN
    PRINT_HELP_DETAIL
    RETURN, TRUE
  ENDIF

  ; We do this so input_FN isn't changed when returning to calling funciton
  IF(N_ELEMENTS(input_FN)  NE  UNDEF)  THEN  input_FN_tmp  =  input_FN

  ;Set some constants
  IF(N_ELEMENTS(delim_char)  EQ  UNDEF)  THEN  delim_char  =  ' '
  IF(N_ELEMENTS(N_COMMENTS)  EQ  UNDEF)  THEN  N_COMMENTS  =  0
  input_LUN = 0
    
  IF(N_ELEMENTS(input_FN_tmp)  EQ  UNDEF)  THEN  BEGIN
    print, 'READ_ASCII_FILE: input file (input_FN) undefined... RETURNING'
    RETURN, ERROR
  ENDIF
  IF(N_ELEMENTS(direc)  NE  UNDEF)  THEN  input_FN_tmp  =  direc  +  input_FN_tmp
  tmp  =  CHECK_FILE_EXISTENCE(input_FN_tmp, SURPRESS_MSG=SURPRESS_MSG)
  IF(tmp[0]  EQ  ERROR)  THEN  BEGIN
    print, 'READ_ASCII_FILE: Can not find input file: ', input_FN_tmp
    IF(N_ELEMENTS(direc)  NE  UNDEF)  THEN  BEGIN

      tmp  =  CHECK_FILE_EXISTENCE(direc, /DIRECTORY, SURPRESS_MSG=SURPRESS_MSG)
      IF(tmp[0]  EQ  ERROR)  THEN  BEGIN
        print, 'READ_ASCII_FILE: input directory (direc) not found: '
        print, '               ', direc
        print, '                Check directory...'
      ENDIF ELSE BEGIN
        print, 'READ_ASCII_FILE: input directory (direc) found. Check file...
      ENDELSE
    ENDIF
    print, '                 RETURNING...'
    RETURN, ERROR
  ENDIF
  
  ;Check if the input file is a CSV file (file extension: .csv)
  z  =  STRPOS(input_FN, CSV_str)
  IF(z[0]  NE  ERROR)  THEN  BEGIN
    delim_char  =  ','
    IF(KEYWORD_SET(SURPRESS_MSG)  NE  TRUE) THEN  BEGIN
      print, 'READ_ASCII_FILE: CSV file type detected in input file name (input_FN)'
      print, '                 Setting deliminator character to ","'
    ENDIF
  ENDIF
  IF(KEYWORD_SET(CSV_FILE)  EQ  TRUE)  THEN  delim_char  =  ','

  ;Set field_col_no to index from 0
  IF(N_ELEMENTS(field_col_no)  NE  UNDEF)  THEN  BEGIN
    IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN

      print, 'READ_ASCII_FILES: field_col_no specified. Field_col_no should index columns starting from 1 (not 0)!
      print, '                  If 1st column no. specified in field_col_no (as an index:0), field_col_no is'
      print, '                  ajusted so to be consistent! If not and user is indexing from 0, field_col_no must'
      print, '                  be adjusted to index from 1!'
      field_col_no[*]  =  field_col_no[*] -1
      z = WHERE(field_col_no[*]  LT  FALSE)
      IF(z[0]  NE  ERROR)  THEN  field_col_no[*]  =  field_col_no[*]  +  1
    ENDIF
  ENDIF

  IF((KEYWORD_SET(NO_HEADER)  EQ  TRUE)  AND  (N_ELEMENTS(field_arr)  EQ  FALSE))  THEN  BEGIN
;    print, 'READ_ASCII_FILE: Keyword NO_HEADER set to TRUE but field_arr UNDEFINED'
;    print, '                  i.e. not passed to function. Must have field_arr defined!!!'
;    print, '                 Returning...'
;    RETURN, ERROR

    IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN
      print, 'READ_ASCII_FILE: Keyword NO_HEADER set to TRUE but field_arr UNDEFINED'
      print, '                 Setting default date field labels (var_01, var_02, var_03 etc...)'
      print, ''
    ENDIF

    tmp_str  =  ''
    OPENR, input_LUN, input_FN_tmp, /GET_LUN
    FOR i=0, N_COMMENTS -1 DO readf, input_LUN, tmp_str
    READF, input_LUN, tmp_str
    CLOSE, input_LUN
    FREE_LUN, input_LUN

    tmp_strarr  =  STRSPLIT(tmp_str, delim_char, /EXTRACT)
    field_arr   =  STRARR(N_ELEMENTS(tmp_strarr))

    IF(N_ELEMENTS(field_arr)  GE  ELEM_100) THEN BEGIN

      FOR i=0, N_ELEMENTS(field_arr) -1 DO field_arr[i]  =  'var_' + STRING(i+1, FORMAT='(i3.3)')
    ENDIF ELSE FOR i=0, N_ELEMENTS(field_arr) -1 DO field_arr[i]  =  'var_' + STRING(i+1, FORMAT='(i2.2)')
  ENDIF

  ;First determine number of lines in ASCII file...
  TOTAL_NO_LINES  =  FILE_LINES(input_FN_tmp)


  ;Read input file
  OPENR, input_LUN, input_FN_tmp, /GET_LUN
  tmp_str  =  ''
  IF(N_ELEMENTS(N_COMMENTS)  NE  UNDEF)  THEN  BEGIN
    IF(N_COMMENTS  NE  0)  THEN  BEGIN
      comment_str  =  STRARR(N_COMMENTS)
      FOR i=0, N_COMMENTS -1 DO BEGIN
        READF, input_LUN, tmp_str
        comment_str[i]  =  tmp_str
      ENDFOR
    ENDIF ELSE comment_str  =  ''
  ENDIF ELSE IF(N_ELEMENTS(uniq_comment_str)  NE  UNDEF)  THEN  BEGIN

    str_found  =  FALSE
    N_COMMENTS =  0
    REPEAT BEGIN

      readf, input_LUN, tmp_str
      IF(STRMATCH(tmp_str, uniq_comment_str)  EQ  TRUE)  THEN  str_found   =  TRUE                $
                                                         ELSE  N_COMMENTS  =  N_COMMENTS  +1
    ENDREP UNTIL (str_found  EQ  TRUE)
  ENDIF

  header_str  =  ''
  ;Get the header string!!!
  IF(KEYWORD_SET(NO_HEADER)  EQ  FALSE)  THEN  BEGIN    ;BEGIN FIRST IF_STATEMENT
    READF, input_LUN, header_str

    ;Check to see if user has simply requested to return the header string!
    IF(KEYWORD_SET(RETURN_HDR)  EQ  TRUE)  THEN  BEGIN
      IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN
        print, 'Header_str: ', header_str
      ENDIF
      CLOSE, input_LUN
      FREE_LUN, input_LUN

      RETURN, header_str
    ENDIF
    NO_FIELDS  =  N_ELEMENTS(field_arr_all)


    field_arr_all  =  STRSPLIT(header_str, delim_char, /EXTRACT)
    ;Remove all white spaces in field_arr_all
    field_arr_all  =  STRCOMPRESS(field_arr_all, /REMOVE_ALL)

    ;Now check to see if there are any data fields with the same name (multiple occurrences!)
    order_of_occurrence     =  INTARR(N_ELEMENTS(field_arr_all))
    order_of_occurrence[*]  =  0
    FOR i=0, N_ELEMENTS(field_arr_all) -1 DO BEGIN

      n_occur  =  WHERE(STRCOMPRESS(field_arr_all, /REMOVE_ALL)  EQ  STRCOMPRESS(field_arr_all[i], /REMOVE_ALL))
      IF(N_ELEMENTS(n_occur)  GT  1)  THEN  BEGIN
        FOR j=0, N_ELEMENTS(n_occur) -1 DO BEGIN

          cntr_adjust    =  1
          IF(n_occur[j]  GE  i)  THEN  BEGIN

            order_of_occurrence[n_occur[j]]  =  order_of_occurrence[n_occur[j]]  +  cntr_adjust
            cntr_adjust  =  cntr_adjust + 1
          ENDIF

        ENDFOR
      ENDIF
    ENDFOR

    ; We only do the following steps if (removing multiple field occurrences or changing the field names)
    ; field_arr is not passed by the user (remains undefined at this stage)
    IF(N_ELEMENTS(field_arr)  EQ  UNDEF)  THEN  BEGIN

      IF(KEYWORD_SET(REMOVE_MULTIP_FIELDS)  EQ  FALSE)  THEN  BEGIN

        IF(N_ELEMENTS(field_arr_all)  GE  ELEM_100)  THEN  BEGIN

          FOR i=0, N_ELEMENTS(field_arr_all) -1 DO BEGIN

            IF(order_of_occurrence[i]  GT  0)  THEN                                                               $
              field_arr_all[i]  =  field_arr_all[i]  +  '_'  +  STRING(order_of_occurrence[i], FORMAT='(i3.3)')
          ENDFOR
        ENDIF ELSE BEGIN

          FOR i=0, N_ELEMENTS(field_arr_all) -1 DO BEGIN

            IF(order_of_occurrence[i]  GT  0)  THEN                                                               $
              field_arr_all[i]  =  field_arr_all[i]  +  '_'  +  STRING(order_of_occurrence[i], FORMAT='(i2.2)')
          ENDFOR
        ENDELSE
      ENDIF ELSE BEGIN

        tmp_ind  =  WHERE(order_of_occurrence  GT  1, complement=OK_ind); If a field occurs only once, its value in
                                                                       ; order_of_occurrence is 0. If its value is 1
                                                                       ; this indicates it is the FIRST of multiple
                                                                       ; occurences. If GT 1, it is the second (or more)
                                                                       ; occurrence (and therefore removed!)
        ; We now define field_arr as a subset of the total number of fields in the file
        IF(tmp_ind[0]  NE  ERROR)  THEN  field_arr  =  field_arr_all[OK_ind]
      ENDELSE
    ENDIF ELSE BEGIN

      ;Check if there are multiple occurrences of fields specified by the user within the total set of fields
      FOR i=0, N_ELEMENTS(field_arr) -1 DO BEGIN
        tmp_ind  =  WHERE(field_arr[i]  EQ  field_arr_all); At the first occurrence where there are identified
                                                          ; multiple occurences, exit with ERROR. Any field with
                                                          ; multiple occurences that is not specified by the user is ignored!
        IF(N_ELEMENTS(tmp_ind)  GT  1)  THEN  BEGIN

          print, 'READ_ASCII_FILE: Within the subset of fields specified by the user (field_arr),'
          print, '                  there exists multiple occurrences of a specified field within the total'
          print, '                  number of fields in the input ASCII file.
          print, '                 Field in question: ', field_arr[i]
          print, '                 RETURNING...
          RETURN, ERROR
        ENDIF
      ENDFOR
    ENDELSE

  ENDIF ;END FIRST IF_STATEMENT


  ;Now we have to get ONLY one string from the file that contains the first instance of the data
  ; contained in the file. We do this to determine the suitable data types for each field
  test_str  =  ''
  READF, input_LUN, test_str
  test_fld_arr  =  STRSPLIT(test_str, delim_char, /EXTRACT)
  
  ;Check to see if the number of data fields of test_fld_arr (entries for one line)  is NE to the TOTAL number of 
  ; identified fields from the header string. Do not do this if NO_HEADER is set to TRUE!
  IF(KEYWORD_SET(NO_HEADER)  EQ  FALSE) THEN  BEGIN
  
    ;If number of data fields (test_fld_arr) is LESS than the total number of extracted fields from the header string,
    ; the no. of extracted fields must be trimmed (either by default or using valid_field_indarr if DEFINED)
    IF(N_ELEMENTS(test_fld_arr)  LT  N_ELEMENTS(field_arr_all))  THEN  BEGIN
      IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN
        print, 'READ_ASCII_FILE: Number of data entries (columns) in first line of data LESS THAN the TOTAL number of extracted'
        print, '                  fields obtained from the header line.
        print, '                  Total no. of fields identified from header:            ', N_ELEMENTS(field_arr_all)
        print, '                  Total no. of data entries from first valid data line:  ', N_ELEMENTS(test_fld_arr)
        IF(N_ELEMENTS(valid_field_indarr)  EQ  UNDEF)  THEN  BEGIN
          print, '                   valid_field_indarr UNDEFINED. Will trim excess fields extracted from header line'
        ENDIF ELSE print, '                   valid_field_indarr DEFINED...
      ENDIF
            
      IF(N_ELEMENTS(valid_field_indarr)  NE  UNDEF)  THEN  BEGIN
      
        IF(N_ELEMENTS(valid_field_indarr)  NE  N_ELEMENTS(test_fld_arr))  THEN  BEGIN
          print, 'READ_ASCII_FILE: valid_field_indarr DEFINED but N. ELEM not equal to the numer of data entries (columns) in'
          print, '                  first line of data! valid_field_indarr needs to be correctly defined. RETURNING...'
          RETURN, ERROR
        ENDIF
        field_arr_all  =  field_arr_all[valid_field_indarr]
      ENDIF ELSE BEGIN
        valid_field_indarr  =  INDGEN(N_ELEMENTS(test_fld_arr))
        field_arr_all  =  field_arr_all[valid_field_indarr]
      ENDELSE
      
    ;If number of data fields (test_fld_arr) is GREATER THAN the total number of extracted fields from the header
    ; string, we must add additional header fields (default names) to match the actual nunber of data fields (columns)
    ENDIF ELSE IF(N_ELEMENTS(test_fld_arr)  GT  N_ELEMENTS(field_arr_all))  THEN  BEGIN
      IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN
        print, 'READ_ASCII_FILE: Number of data entries (columns) in first line of data GREATER THAN to the TOTAL number of extracted'
        print, '                  fields obtained from the header line.
        print, '                  Total no. of fields identified from header:            ', N_ELEMENTS(field_arr_all)
        print, '                  Total no. of data entries from first valid data line:  ', N_ELEMENTS(test_fld_arr)
        print, '                  Will add additional default field names
      ENDIF
      
      tot_n_flds  =  N_ELEMENTS(field_arr_all)
      tot_n_data  =  N_ELEMENTS(test_fld_arr)
      n_miss_flds =  tot_n_data - tot_n_flds
      FOR i=0, n_miss_flds -1 DO field_arr_all  =  [field_arr_all, 'var_' + STRING(i+1, FORMAT='(i3.3)')]
      NO_FIELDS  =  N_ELEMENTS(field_arr_all)
    ENDIF
  
  ENDIF ELSE BEGIN; END of IF(KEYWORD_SET(NO_HEADER)  EQ  FALSE) THEN  BEGIN

    ;If NO_HEADER is specified, use first line of data from ASCII file to setup the field_arr_all array
    ; (determine number of columns in data file and hence, number of fields contained in the ASCII file
    ;IF(KEYWORD_SET(NO_HEADER)  EQ  TRUE)  THEN  BEGIN
    field_arr_all  =  test_fld_arr
    NO_FIELDS      =  N_ELEMENTS(field_arr_all)

  ENDELSE

  ;Now test for the type of each field
  fld_type_arr  =  INTARR(N_ELEMENTS(test_fld_arr))
  FOR fld_cntr=0, N_ELEMENTS(test_fld_arr) -1 DO BEGIN

      ;IF(fld_cntr  EQ  6)  THEN  STOP, 'fld_cntr EQ 6'
      fld_type_arr[fld_cntr] = TEST_DATA_TYPE_IN_STR(test_fld_arr[fld_cntr], SCI_FMT=SCI_FMT,   $
                                          RETURN_FLOAT=RETURN_FLOAT, RETURN_LONG=RETURN_LONG)
  ENDFOR


  IF(N_ELEMENTS(field_arr)  EQ  UNDEF)  THEN  BEGIN; Field_arr is only undefined at this stage IF there is a header
                                                   ; contained in the ASCII file (field_arr_all is already defined)

    IF(N_ELEMENTS(field_col_no)  EQ  UNDEF)  THEN  BEGIN

      field_arr           =  field_arr_all
      field_match_ind     =  INDGEN(N_ELEMENTS(field_arr_all))
    ENDIF ELSE BEGIN

      field_arr           =  field_arr_all[field_col_no]
      field_match_ind     =  field_col_no
    ENDELSE

  ENDIF ELSE IF(KEYWORD_SET(NO_HEADER)  EQ  TRUE)  THEN  BEGIN;  BEGINNING 2nd IF_STATEMENT

    IF((N_ELEMENTS(field_arr))  NE  (N_ELEMENTS(field_arr_all))) THEN BEGIN

      IF(N_ELEMENTS(field_col_no)  EQ  UNDEF)  THEN  BEGIN

        print, 'READ_ASCII_FILE: field_col_no NOT defined. This index array is required as the number of'
        print, '                  specified input fields to be extracted is NOT EQUAL to the total number of fields'
        print, '                  contained in the input ASCII file. RETURNING...'
        CLOSE, input_LUN
        FREE_LUN, input_LUN
        RETURN, ERROR
      ENDIF ELSE IF(N_ELEMENTS(field_arr)  NE  N_ELEMENTS(field_col_no))  THEN  BEGIN
        print, 'READ_ASCII_FILE: Dim of field_col_no NOT EQUAL to field_arr. They are required to be equal!
        print, '                 RETURNING...'
        CLOSE, input_LUN
        FREE_LUN, input_LUN
        RETURN, ERROR
      ENDIF ELSE BEGIN

        match_ind        =   INTARR(N_ELEMENTS(field_arr_all))
        match_ind[*]     =   FALSE
        match_ind[field_col_no]  =  TRUE

        field_match_ind  =  WHERE(match_ind  EQ  TRUE)
        fld_type_arr     =  fld_type_arr[field_match_ind]
        test_fld_arr     =  test_fld_arr[field_match_ind]
        NO_FIELDS        =  N_ELEMENTS(field_arr)
      ENDELSE
    ENDIF ELSE BEGIN

      field_match_ind     =  INDGEN(N_ELEMENTS(field_arr))

      IF(N_ELEMENTS(field_col_no)  NE  UNDEF)  THEN  BEGIN

        MAX_NO_FLDS  =  N_ELEMENTS(field_arr)
        z            =  WHERE(field_col_no  GT  (MAX_NO_FLDS -1), complement=OK_ind)
        IF(z[0]  NE  ERROR)  THEN  BEGIN
          IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN
            print, 'READ_ASCII_FILE: Specified column number(s) are GREATER THAN the number of columns in ASCII file'
            print, '                 Removing these column numbers'
          ENDIF
          IF(OK_ind[0]  EQ  ERROR)  THEN  BEGIN
            print, 'READ_ASCII_FILE: All specified column number(s) do not exits in ASCII file (column nos. too big)'
            print, '                 RETURNING...'
            RETURN, ERROR
          ENDIF
          field_col_no  =  field_col_no[OK_ind]
        ENDIF

        field_match_ind   =  field_match_ind[field_col_no]
        field_arr_all     =  field_arr
        field_arr         =  field_arr_all[field_col_no]

        fld_type_arr      =  fld_type_arr[field_col_no]
        test_fld_arr      =  test_fld_arr[field_col_no]
        NO_FIELDS         =  N_ELEMENTS(field_arr)
      ENDIF
    ENDELSE

  ENDIF ELSE BEGIN;  END 2nd IF_STATEMENT

    IF(N_ELEMENTS(field_col_no)  EQ  UNDEF)  THEN  BEGIN

      match_ind          =  INTARR(N_ELEMENTS(field_arr_all))
      field_arr_pres     =  INTARR(N_ELEMENTS(field_arr))
      match_ind[*]       =  FALSE   ;This flag index array indicates which fields in the input file have been 
                                    ; identified with fields selected by user to be extracted
      field_arr_pres[*]  =  FALSE   ;This flag index array indicates if any fields specified by the user have NOT
                                    ; been identified in the header string of the input file 
      FOR i=0, N_ELEMENTS(field_arr) -1 DO BEGIN

        z = WHERE(field_arr[i]  EQ  field_arr_all)
        IF(z[0]  NE  ERROR)  THEN  BEGIN
        
          match_ind[z]       =  TRUE
          field_arr_pres[i]  =  TRUE
        ENDIF
      ENDFOR

      field_match_ind  =  WHERE(match_ind  EQ  TRUE)
      ;Check to see if any fields have been matched
      IF(field_match_ind[0]  EQ  ERROR)  THEN  BEGIN
        print, 'READ_ASCII_FILE: NO MATCHING fields within header file given the specified fields in field_arr'
        print, '                 field_arr: ', field_arr
        print, '                 hdr_flds:  ', field_arr_all
        print, '                RETURNING...'
        RETURN, ERROR
      ENDIF
      missing_fld_ind  =  WHERE(field_arr_pres  EQ  FALSE)
      IF(missing_fld_ind[0]  NE  ERROR)  THEN  BEGIN
        print, 'READ_ASCII_FILE: CERTAIN fields specified in field_arr by user NOT found in the header string of the input file'
        print, '                 field_arr: ', field_arr
        print, '            Not identified: ', field_arr[missing_fld_ind]
        print, '                 hdr_flds:  ', field_arr_all
        print, '                RETURNING...'
        RETURN, ERROR      
      ENDIF

      fld_type_arr     =  fld_type_arr[field_match_ind]
      test_fld_arr     =  test_fld_arr[field_match_ind]
      NO_FIELDS        =  N_ELEMENTS(field_arr)
    ENDIF ELSE BEGIN

      ;Instead of matching the elements of field_arr with field_arr_all to get the rignt column numbers
      ; (field_match_ind indices), we use these directly because the user has specified both
      ; field_arr and field_col_no.
      z = WHERE(field_col_no GT N_ELEMENTS(field_arr_all))
      IF(z[0]  NE  ERROR) THEN BEGIN
        print, 'READ_ASCII_FILE: Column numbers specified in field_col_no are GREATER THAN the number of columns'
        print, '                 (data fields) in the input ASCII file.'
        print, '     No. fields:  ', N_ELEMENTS(field_arr_all)
        print, '  All ASCII flds: ', field_arr_all
        print, '  field_col_no:   ', field_col_no
        print, '                  RETURNING...'
        RETURN, ERROR
      ENDIF

      IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN

        chk_arr = INTARR(N_ELEMENTS(field_arr))
        FOR i=0, N_ELEMENTS(field_arr) -1 DO chk_arr[i] = WHERE(field_arr[i]  EQ  field_arr_all)
        z = WHERE(chk_arr  EQ  ERROR)
        IF(z[0]  NE  ERROR)  THEN  BEGIN

          print, 'READ_ASCII_FILE: NOTE... specified field(s): ', field_arr[z]
          print, '                 Do NOT exist in the input ASCII file!
        ENDIF
      ENDIF

      field_match_ind  =  field_col_no
      fld_type_arr  =  fld_type_arr[field_match_ind]
      test_fld_arr  =  test_fld_arr[field_match_ind]
      NO_FIELDS     =  N_ELEMENTS(field_arr)
    ENDELSE
  ENDELSE


  ;The string array fields_are_str contains specific fields in the header file that require the
  ; correspoinging type to be strings
  field_no_arr  =  INDGEN(N_ELEMENTS(field_arr))
  IF(N_ELEMENTS(fields_are_str)  NE  UNDEF)  THEN  BEGIN

    FOR i=0, N_ELEMENTS(field_no_arr) -1 DO BEGIN
      FOR j=0, N_ELEMENTS(fields_are_str) -1 DO BEGIN
        IF(field_no_arr[i]  EQ  fields_are_str[j])  THEN  fld_type_arr[i]  =  data_type.STR_TYPE
      ENDFOR
    ENDFOR
  ENDIF
  ;Do the same with fields_are_flt
  IF(N_ELEMENTS(fields_are_flt)  NE  UNDEF)  THEN  BEGIN

    FOR i=0, N_ELEMENTS(field_no_arr) -1 DO BEGIN
      FOR j=0, N_ELEMENTS(fields_are_flt) -1 DO BEGIN
        IF(field_no_arr[i]  EQ  fields_are_flt[j])  THEN  fld_type_arr[i]  =  data_type.FLOAT_TYPE
      ENDFOR
    ENDFOR
  ENDIF
  ;Do the same with fields_are_dbl
  IF(N_ELEMENTS(fields_are_dbl)  NE  UNDEF)  THEN  BEGIN

    FOR i=0, N_ELEMENTS(field_no_arr) -1 DO BEGIN
      FOR j=0, N_ELEMENTS(fields_are_dbl) -1 DO BEGIN
        IF(field_no_arr[i]  EQ  fields_are_dbl[j])  THEN  fld_type_arr[i]  =  data_type.DBL_TYPE
      ENDFOR
    ENDFOR
  ENDIF
  ;Do the same with fields_are_int
  IF(N_ELEMENTS(fields_are_int)  NE  UNDEF)  THEN  BEGIN

    FOR i=0, N_ELEMENTS(field_no_arr) -1 DO BEGIN
      FOR j=0, N_ELEMENTS(fields_are_int) -1 DO BEGIN
        IF(field_no_arr[i]  EQ  fields_are_int[j])  THEN  fld_type_arr[i]  =  data_type.INTEG_TYPE
      ENDFOR
    ENDFOR
  ENDIF
  ;Do the same with fields_are_long
  IF(N_ELEMENTS(fields_are_long)  NE  UNDEF)  THEN  BEGIN

    FOR i=0, N_ELEMENTS(field_no_arr) -1 DO BEGIN
      FOR j=0, N_ELEMENTS(fields_are_long) -1 DO BEGIN
        IF(field_no_arr[i]  EQ  fields_are_long[j])  THEN  fld_type_arr[i]  =  data_type.LONG_TYPE
      ENDFOR
    ENDFOR
  ENDIF
  ; field_type_ID
  IF(N_ELEMENTS(field_type_ID)  NE  UNDEF)  THEN  BEGIN
    print, 'Need to write a bit of code. STOPPING...'
    STOP
  ENDIF

  IF(KEYWORD_SET(ALL_FLDS_STR)  EQ  TRUE)  THEN  fld_type_arr[*]  =  data_type.STR_TYPE

  ;Check for consistency bewtween field_arr and test_fld_arr
  IF(N_ELEMENTS(field_col_no)  EQ  UNDEF)  THEN  BEGIN

    IF(N_ELEMENTS(field_arr)  NE  N_ELEMENTS(test_fld_arr))  THEN  BEGIN

      print, 'READ_ASCII_FILE: The number of data fields in file is NOT EQUAL to the number of fields'
      print, '                 in the header line. Check ASCII file for consistency. Consider specifying'
      print, '                 the field column numbers that correspond to the header fields required'
      print, '                 (define input argument: field_col_no) and possibly field_arr if you do not'
      print, '                 want to extract all the fields contained in the header line of the ASCII file.'
      print, '   header_flds:             ', field_arr
      print, '   Number hdr flds:         ', N_ELEMENTS(field_arr)
      print, '   data_flds (1st line):    ', test_fld_arr
      print, '   Number data flds:        ', N_ELEMENTS(test_fld_arr)
      print, '                 RETURNING...'
      RETURN, ERROR
    ENDIF
  ENDIF ELSE BEGIN

    ;Check if test_fld_arr and field_arr have the same elements. If not, return with error
    IF(N_ELEMENTS(field_arr)  NE  N_ELEMENTS(test_fld_arr[field_col_no])) THEN BEGIN
      print, 'READ_ASCII_FILE: The number of data fields in file is NOT EQUAL to the number of fields'
      print, '                 requested to be extracted (via the specification of field_col_no). Check'
      print, '                 field_col_no specification and the ASCII file for consistency.'
      print, '   header_flds:             ', field_arr
      print, '   data_flds (1st line):    ', test_fld_arr[field_col_no]
      print, '                 RETURNING...'
      RETURN, ERROR
    ENDIF

    test_fld_arr  =  test_fld_arr[field_col_no]
  ENDELSE


  ;Now we have an array of strings (field_arr) that contains the names of all the fields (tags) that
  ; will be contained in the IDL STRUCTURE defined to contain the contents of each line of data in the
  ; ASCII file! From this structure, we will then create an array of structures that will be populated
  ; with the data from the ASCII file and passed back to the user.
  input_struc  =  GENERATE_STRUCTURE(field_arr[0], fld_type_arr[0])

  FOR fld_cntr=1, N_ELEMENTS(test_fld_arr) -1 DO BEGIN
    temp_struc   =  GENERATE_STRUCTURE(field_arr[fld_cntr], fld_type_arr[fld_cntr])
    input_struc  =  CREATE_STRUCT(input_struc, temp_struc)
  ENDFOR
  IF(KEYWORD_SET(CONVERT_DATE)  EQ  TRUE)  THEN  BEGIN
    temp_struct  =  {year:   0,  mth:  0,  day:  0}
    input_struc  =  CREATE_STRUCT(input_struc, temp_struct)
  ENDIF
  IF(N_ELEMENTS(addn_fields)  NE  FALSE)  THEN  BEGIN
  
    IF(SIZE(addn_fields, /TYPE)  NE  get_IDL_vartype_ID(/STRUCT_TYPE))  THEN  BEGIN
      print, 'READ_ASCII_FILE: addn_fields is required to be of type STRUCT.'
      print, '                 (i.e. a structure containing the required additional fields)'
      z  =  get_IDL_vartype_ID(IDL_var_ID=SIZE(addn_fields, /TYPE)); Pass IDL var type (ID) from SIZE to get_idl_vartype_ID
      print, '                 addn_fields is of IDL variable type (ID): ', z
      print, '                 RETURNING...'
      RETURN, ERROR
    ENDIF
  
    tmp   =   TAG_NAMES(addn_fields)
    IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  print, 'Additional fields added: ', tmp
    
    input_struc  =  CREATE_STRUCT(input_struc, addn_fields)
  ENDIF

  ;Now find the number of data points to be read in from file
  IF(KEYWORD_SET(NO_HEADER)  EQ  TRUE)  THEN  N_DATA_PTS  =  TOTAL_NO_LINES  -  N_COMMENTS      $
                                        ELSE  N_DATA_PTS  =  TOTAL_NO_LINES  -  N_COMMENTS  -1
                                              ;Take into account BOTH No. comments and header line

  IF(N_ELEMENTS(data_amt_to_read)  NE  UNDEF)  THEN  N_DATA_PTS  =  N_DATA_TO_READ

  ;Now we make an array of structures now that the data input data structure has been defined
  ASCII_data_arr  =  REPLICATE(input_struc, N_DATA_PTS)

  ;We have already read in one line of data from the ASCII file. Populate the first structure in
  ; ASCII_data_arr with these data from the first line in the ASCII file.
  FOR i=0, N_ELEMENTS(test_fld_arr) -1 DO ASCII_data_arr[0].(i)  =  CONV_TYPE(test_fld_arr[i],    $
                                                                              fld_type_arr[i])

  IF(N_ELEMENTS(input_data_FMT) EQ FALSE) THEN BEGIN

    FOR data_cntr=1, N_DATA_PTS -1 DO  BEGIN
      READF, input_LUN, test_str
      test_fld_arr  =  STRSPLIT(test_str, delim_char, /EXTRACT)

      test_fld_arr  =  test_fld_arr[field_match_ind]

      FOR i=0, N_ELEMENTS(test_fld_arr) -1 DO                           $
        ASCII_data_arr[data_cntr].(i)  =  CONV_TYPE(test_fld_arr[i],    $
                                                    fld_type_arr[i])
    ENDFOR
  ENDIF ELSE BEGIN

    ;User has passed and IDL format string! Use this to rapidly scan in the data. First we close and reopen
    ; the ASCII file
    CLOSE, input_LUN
    FREE_LUN, input_LUN
    OPENR, input_LUN, input_FN_tmp, /GET_LUN
    tmp_str  =  ''
    FOR i=0, N_COMMENTS -1 DO READF, input_LUN, tmp_str
    IF(KEYWORD_SET(NO_HEADER)  EQ  FALSE) THEN READF, input_LUN, tmp_str

    READF, input_LUN, ASCII_data_arr, FORMAT=input_data_FMT
  ENDELSE

  CLOSE, input_LUN
  FREE_LUN, input_LUN
  
  ;Remove any leading or trailing white spaces in any of the string fields. Flag set to 2 in STRTRIM
  IF(N_ELEMENTS(field_arr_all)  EQ  N_ELEMENTS(fld_type_arr))  THEN  BEGIN
    FOR i=0, N_ELEMENTS(field_arr_all) -1 DO BEGIN
      IF(fld_type_arr[i]  EQ  data_type.STR_TYPE)  THEN  ASCII_data_arr.(i)  =  STRTRIM(ASCII_data_arr.(i), 2)
    ENDFOR
  ENDIF ELSE BEGIN
    FOR i=0, N_ELEMENTS(fld_type_arr) -1 DO BEGIN
      IF(fld_type_arr[i]  EQ  data_type.STR_TYPE)  THEN  ASCII_data_arr.(i)  =  STRTRIM(ASCII_data_arr.(i), 2)
    ENDFOR  
  ENDELSE

  TOT_NO_FIELDS  =  N_ELEMENTS(field_arr_all)
  NO_FIELDS      =  N_ELEMENTS(field_arr)

  IF(KEYWORD_SET(SURPRESS_MSG)  EQ  FALSE)  THEN  BEGIN
    print, ''
    print, '******************* ******************* *******************'
    print, ''
    print, 'READ_ASCII_FILE: READ IN ALL DATA IN ASCII FILE: '
    print, input_FN_tmp
    print, ''
    print, 'No. of observations read:            ', N_ELEMENTS(ASCII_data_arr)
    print, 'Total. no. identified fields:        ', TOT_NO_FIELDS
    print, 'No. identified and extracted fields: ', NO_FIELDS
    print, ''
    print, 'Output data structure format:'
    print, ''
    help, ASCII_data_arr, /str
    print, ''
    print, '******************* ******************* *******************'
    print, ''
  ENDIF

  ;If keyword CONVERT_DATE is set to TRUE, call a function to convert the field containing date
  ; information into separate fields (YR, MTH, DAY) that are useful for numerical analysis
  IF(KEYWORD_SET(CONVERT_DATE)  EQ  TRUE)  THEN  tmp_test  =  CONV_DATE(ASCII_DATA_ARR, date_fld)


  RETURN, ASCII_data_arr

END
