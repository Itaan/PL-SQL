create PROCEDURE       UPDATE_WIP_TRACKING(DATA IN VARCHAR2,
                                     RES OUT VARCHAR2) AS
/*-------------------------------------------------------------------------------
Prog no: SP0998
Note:
 *Modification Date : 2024-01-10 (V 1.1.1)
 *Programmer        : Oskar Szymorek
 *Application Form# : Developers of MES Systems for WRO IT (Day. 2)
 *Reason            : Homework_2
-------------------------------------------------------------------------------*/
C_PROG_NO       VARCHAR2(10) := 'SP0998';
C_PROG_NAME     VARCHAR2(20) := 'SFIS1.UPDATE_WIP_TRACKING';
C_SERIAL_NUMBER SFISM4.R_WIP_TRACKING_T.SERIAL_NUMBER%TYPE;
C_GROUP_NAME    VARCHAR2(10) := 'XYZ';

-- UPDATE GROUP
BEGIN
    SELECT SERIAL_NUMBER
    INTO C_SERIAL_NUMBER
    FROM SFISM4.R_WIP_TRACKING_T A
    WHERE (A.SERIAL_NUMBER = DATA)
      AND (ROWNUM = 1);

    IF (DATA IS NOT NULL) AND (DATA = C_SERIAL_NUMBER) THEN
        UPDATE SFISM4.R_WIP_TRACKING_T SET GROUP_NAME = C_GROUP_NAME WHERE SERIAL_NUMBER = DATA;
        RES := 'OK' || C_GROUP_NAME;
        RETURN;
    end if;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RES := 'NO SN';
        RETURN;
    WHEN OTHERS THEN
        RES := C_PROG_NO || ' ERR: E=' || SQLERRM();
END;
/

