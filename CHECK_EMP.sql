PROCEDURE       CHECK_EMP
(DATA IN VARCHAR2,MYGROUP IN VARCHAR2,
RES OUT VARCHAR2, COMPANY_CODE IN VARCHAR2,PROFIT_CENTER IN VARCHAR2) IS
/*-------------------------------------------------------------------------------
Prog no: SP0656
Note:
 *Modification Date : 2023-10-29 (V 1.1.2)
 *Programmer        : Oskar Szymorek
 *Application Form# : [SAI072964]
 *Reason            : Log-in authentication
-------------------------------------------------------------------------------*/  
C_PROG_NO VARCHAR2(10) := 'SP0656';
C_PROG_NAME VARCHAR2(20) := 'SFIS1.CHECK_EMP';
C_COMPANY_CODE SFISM4.R107.COMPANY_CODE%TYPE := COMPANY_CODE;
C_PROFIT_CENTER SFISM4.R107.PROFIT_CENTER%TYPE := PROFIT_CENTER;
C_EMP SFIS1.C_EMP_DESC_T.EMP_NO%TYPE;
C_STATION SFISM4.R_WIP_TRACKING_T.STATION_NAME%TYPE;

BEGIN

    SELECT EMP_NO, STATION_NAME
    INTO C_EMP,C_STATION
    FROM SFIS1.C_EMP_DESC_T
    WHERE EMP_NO = DATA
      AND ROWNUM = 1
    GROUP BY EMP_NO, STATION_NAME;
    IF C_STATION = MYGROUP OR C_STATION IS NULL THEN
        RES := 'OK';

        BEGIN
            SELECT EMP_NO
            INTO c_emp
            FROM SFISM4.R_EMP_LOGIN_REC_T
            WHERE EMP_NO = DATA
              AND in_date = trunc(sysdate)
              AND rownum <= 1;
        EXCEPTION
            WHEN no_data_found then
                INSERT INTO SFISM4.R_EMP_LOGIN_REC_T (EMP_NO, PROG_NAME, FUNC_NAME, PASSWORD, STATUS, ERROR_MESSAGE,
                                                      IN_DATE, INPUT_TIMES, COMPANY_CODE, PROFIT_CENTER)
                VALUES (DATA, C_PROG_NO, C_PROG_NAME, 'NA', 'OK', 'NA', trunc(SYSDATE), '1', C_COMPANY_CODE,
                        C_PROFIT_CENTER);
                COMMIT;
        END;

    ELSE
        RES := ' NO AUTHORITY';
    END IF;
EXCEPTION
    WHEN OTHER THEN
        RES := ' NO EMP';
END;
/

