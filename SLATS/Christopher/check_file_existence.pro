;Function designed to check the validity of an input file or directory.
; Returns error (-1) if file or directory does not exist
;
; input_name:        String containing either the file name or directory
; orig_direc:        String returned containing the preceeding directory before changing to a new direcory (defined by input_name)
; DIRECTORY:         Keyword indicating that input_name is a DIRECTORY and not a FILE.
; CREATE_DIRECTORY:  Keyword indicating to create a directory given the name contained in input_name (keyword DIRECTORY automatically set to TRUE)
; CHANGE_DIRECTORY:  Keyword indicating to change to the directory specified by input_name. The preceeding directory is copied to orig_direc and is passed back to calling routine if requested)
; _extra=e:          Other keywords used by routines within check_file_existence
;
FUNCTION check_file_existence, input_name, make_sub_direc=make_sub_direc,                               $
                                           orig_direc=orig_direc,                                       $
                                           DIRECTORY=DIRECTORY,                                         $
                                           CREATE_DIRECTORY=CREATE_DIRECTORY,                           $
                                           CHANGE_DIRECTORY=CHANGE_DIRECTORY,                           $
                                           SURPRESS_MSG=SURPRESS_MSG, _extra=e

  TRUE   =   1
  FALSE  =   0
  ERROR  =  -1
  UNDEF  =   0
  
  SNGL_ELEM  =  1

  ;First check the operating system currently in use
  curr_OS   =  !version.os  ;Get the current operating system (a string name)
  WIN_ID    =  '*win*'
  LINUX_ID  =  '*linux*'
  OSX_ID    =  '*darwin*'
  IF(STRMATCH(curr_OS, WIN_ID,   /FOLD_CASE)  EQ  TRUE)  THEN  direc_end_str  =  '\'
  IF(STRMATCH(curr_OS, LINUX_ID, /FOLD_CASE)  EQ  TRUE)  THEN  direc_end_str  =  '/'
  IF(STRMATCH(curr_OS, OSX_ID, /FOLD_CASE)  EQ  TRUE)    THEN  direc_end_str  =  '/'

  IF((KEYWORD_SET(CREATE_DIRECTORY)  EQ  TRUE)  AND  (KEYWORD_SET(DIRECTORY)  EQ  FALSE))  THEN  DIRECTORY  =  TRUE
  IF((KEYWORD_SET(CHANGE_DIRECTORY)  EQ  TRUE)  AND  (KEYWORD_SET(DIRECTORY)  EQ  FALSE))  THEN  DIRECTORY  =  TRUE


  IF(KEYWORD_SET(DIRECTORY)  EQ  TRUE)  THEN  BEGIN

    IF(N_ELEMENTS(input_name)  EQ  UNDEF)  THEN  BEGIN

      print, 'CHECK_FILE_EXISTENCE: Undefined or invalid input directory'
      print, ''
      RETURN, ERROR
    ENDIF ELSE IF(STRLEN(input_name)  EQ  FALSE)  THEN  BEGIN

      print, 'CHECK_FILE_EXISTANCE: Undefined or invalid input directory (STRLEN of input_name EQ 0)'
      print, ''
      RETURN, ERROR
    ENDIF ELSE BEGIN

      input_name  =  STRTRIM(input_name)
      IF(STRMID(input_name, 0, 1, /REVERSE_OFFSET)  NE  direc_end_str)  THEN  input_name = input_name + direc_end_str

      IF((FILE_TEST(input_name, /DIRECTORY)  EQ  FALSE)  AND  (KEYWORD_SET(CREATE_DIRECTORY)  EQ  FALSE))  THEN  BEGIN

        print, 'CHECK_FILE_EXISTENCE: Directory not found and not created (CREATE_DIRECTORY = FALSE):'
        print, input_name
        RETURN, ERROR

      ENDIF ELSE IF((FILE_TEST(input_name, /DIRECTORY)  EQ  FALSE)  AND  (KEYWORD_SET(CREATE_DIRECTORY)  EQ  TRUE))  THEN  BEGIN

        IF(N_ELEMENTS(make_sub_direc)  NE  UNDEF)  THEN  BEGIN

          make_sub_direc  =  STRTRIM(make_sub_direc)
          IF(STRMID(make_sub_direc, 0, 1, /REVERSE_OFFSET)  NE  direc_end_str)  THEN  make_sub_direc = make_sub_direc + direc_end_str

          tmp = input_name + make_sub_direc
          FILE_MKDIR, tmp
          IF(KEYWORD_SET(SURPRESS_MSG) EQ FALSE) THEN print, 'CHECK_FILE_EXISTENCE: Directory created ', tmp

          IF(KEYWORD_SET(CHANGE_DIRECTORY)) THEN cd, tmp, current=orig_direc
        ENDIF

        FILE_MKDIR, input_name
        IF(KEYWORD_SET(SURPRESS_MSG) EQ FALSE) THEN print, 'CHECK_FILE_EXISTENCE: Directory created ', input_name
        IF(KEYWORD_SET(CHANGE_DIRECTORY)) THEN cd, input_name, current=orig_direc

      ENDIF ELSE IF(N_ELEMENTS(make_sub_direc)  NE  UNDEF)  THEN  BEGIN

        IF(STRMID(make_sub_direc, 0, 1, /REVERSE_OFFSET)  NE  direc_end_str)  THEN  make_sub_direc = make_sub_direc + direc_end_str

        tmp = input_name + make_sub_direc
        FILE_MKDIR, tmp
        IF(KEYWORD_SET(SURPRESS_MSG) EQ FALSE) THEN print, 'CHECK_FILE_EXISTENCE: Directory created ', tmp

        IF(KEYWORD_SET(CHANGE_DIRECTORY)) THEN cd, tmp, current=orig_direc
      ENDIF ELSE BEGIN

        IF(KEYWORD_SET(SURPRESS_MSG) EQ FALSE) THEN print, 'CHECK_FILE_EXISTENCE: Directory exists ', input_name

        IF(KEYWORD_SET(CHANGE_DIRECTORY)) THEN cd, input_name, current=orig_direc

      ENDELSE
    ENDELSE

    RETURN, TRUE

  ENDIF ELSE BEGIN  ;ENDIF statement for section dealing with testing for the existance of a directory

    IF(N_ELEMENTS(input_name)  EQ  UNDEF)  THEN  BEGIN
      print, 'CHECK_FILE_EXISTENCE: input_name undefined. Returning...'
      RETURN, ERROR
    ENDIF

    IF(N_ELEMENTS(input_name)  EQ  SNGL_ELEM)  THEN  BEGIN
      IF(FILE_TEST(input_name)  EQ  TRUE) THEN RETURN, TRUE ELSE RETURN, ERROR
    ENDIF ELSE BEGIN
    
      chk_arr  =  INTARR(N_ELEMENTS(input_name))
      FOR i=0, N_ELEMENTS(input_name) -1 DO IF(FILE_TEST(input_name[i])  EQ  TRUE)  THEN  chk_arr[i]  =  TRUE      $
                                                                                    ELSE  chk_arr[i]  =  ERROR
      RETURN, chk_arr
    ENDELSE

  ENDELSE


END