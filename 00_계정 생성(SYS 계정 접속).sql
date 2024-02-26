FR--한 줄 주석 : ctrl + /
/*범위 주석 : ctrl + shift + /
 
 *SQL 1개 실행 : CTRL+ENTER
 *SQL 여러개 실행 : (블럭 처리 후) ALT+X
 **/
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER KH_LSM IDENTIFIED BY KH1234;

--생성된 계정에 접속 + 기본 자원 관리 권한 추가하기
GRANT CONNECT, RESOURCE TO KH_LSM;

--객체 생성 공간 할당
ALTER USER KH_LSM
DEFAULT TABLESPACE SYSTEM
QUOTA UNLIMITED ON SYSTEM;