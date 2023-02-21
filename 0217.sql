
-- 커서3은 재활용에 문제가있어서 쌤은 주로 1,2 version cursor 쓴다고 함

-- 오늘은 exception(예외처리)/ transaction /동적sql

-- ql/sql 에는 try catch 가 없고 바로 exception 이 나오는데  구조가 아래와 같음


/*
    declare
    
    begin
    

    

    exception when 예외명1 then 예외처리1 
              when 예외명2 then 예외처리2
              ..
              when 예외명n-1 then 예외처리n-1
              when others then 예외처리n
    end;
    /


    when others then 은 위에 정의되지않은 그 외 모든예외처리를 함.
    
    others 는 java에서
    
    try{
    
    } catch(Exception e){
    
    } finally {  } 
    
    에서 catch(Exception e) 랑 비슷함.

    그냥 처음부터 모든 오류에대한 예외처리를 하고싶으면 
    when others then 예외처리~ 만 하면 됨. 이렇게하면 DB한테 오류처리를 맞추는거임. 우리는 오류났을때
    어떻게 할지만 쓰면 됨. 우리가 예외처리를 구체적으로 하는건 아님
    메모리를 반납한다거나 그런건 다 db안에서 됨. 우리는 후처리만 정하면됨. 말이 예외처리지 사람이 예외처리하는거아니고 시스템이 해주는거임.

    중간에 오류가 나면 코드가 exception 으로 뜀. 그리고 해당하는 예외처리를 함. 그리고 끝남.
    참고로 예외이름이 우리가 아는거랑 좀 다름. 이거는 과제안하고 설명만함
    오늘은 과제많이안함.


    구체적인 오류에 대한 예외처리를 하고싶으면 311p 보면됨.
    when 이랑 then 사이에 그 오류명쓰면됨
    
    ex)
    
    exception when zero_divide then ~
*/


declare 
    i number :=0;
begin
    i:=10/0;
    dbms_output.put_line('success');
    
exception when others then
    dbms_output.put_line('나누기 오류');
end;
/
-- 에러가 없으면 exception 문은 실행안되고 끝남. 오류있으면 실행됨.
declare 
    i number :=0;
begin
    i:=10/0;
    dbms_output.put_line('success');
    
exception when zero_divide then
    dbms_output.put_line('나누기 오류2');
end;
/


-- 예외를 자기가 만들기도 가능 316-317p 
-- raise 예외명 하면 강제로 예외 발생시킴 
begin
    raise zero_divide;
end;
/
-- 본인이 만든 예외는 본인이 발생시킴


-- 예외선언 / 예외발생 / 예외처리 3부분이 내가 사용자 정의 예외를 만들어서 활용하는 부분임.



-- 동적sql : sql 문을 자동으로 만드는것. sql문을 프로그램 code로 생성하는것.
/*
    예를들어 insert 문.
    
    insert into values(__, __, __) 
    에서 안에 들어가는값이 매일 바뀌어야할때
    for문돌리는데, 동적sql 로 함.
    
*/



-- transcation / table 설계 함.
-- 다음시간에는 table 디자인하는거 함 



-- table design 테이블 설계 - 그림판보기 


-- 오늘 진도 너무 많이나간거같아서 procedure 모르는사람 많아서 다시설명하고 하루정리한다고하심.

/*

함수 / procedure 차이

함수는 sql안에서만 사용 가능하고, procedure 는 밖에서도 단독실행가능
select f1(xxx) from .. insert into T values(f1(xxx),...) update T set col1=f1(xxxx)

프로시져는 단계적으로 처리하는 일련의 작업을 할 때 씀

파스칼 계열 언어는 매개변수를 받지않는 프로시저나 함수에 ()를 쓰면 오류남
 그냥이름만써야됨
 근데매개변수 받는애들은 써야됨
*/

create or replace procedure p1(eid number)
is 
    name varchar2(80);
    sal number;
begin
    select emp_name, salary
    into name, sal
    from employees
    where employee_id = eid;
    dbms_output.put_line(eid||', '||name||', '||sal);
    
exception when no_data_found then
    dbms_output.put_line('사번에 해당하는 직원은 없습니다');
          when others then
    dbms_output.put_line('알수없는 오류발생');
end;
/
exec p1(90);
exec p1(100);


create or replace procedure p1(x number, y number)
is 
    cursor c1(a number, b number) is
        select emp_name, salary
        from employees
        where salary between a and b;
    name varchar2(80);
    sal number;
    flag number :=0;
begin
    open c1(x,y);
        loop
            fetch c1 into name, sal;
            exit when c1%notfound;
            flag:=flag+1;
            dbms_output.put_line(name||', '||sal);
        end loop;
                if c1%rowcount=0 then      -- rowcount :       <--- fetch 로 처리된 row(record)의 개수. fetch 한 번 제대로 실행마다1씩증가.
             dbms_output.put_line('해당하는 데이터가 없습니다'); end if;
        close c1;
        
--        if flag=0 then 
--            dbms_output.put_line('해당하는 데이터가 없습니다'); end if;
end;
/

exec p1(3000000,120000);
        
       


create or replace procedure p1(x number, y number, z varchar2)
is 
    cursor c1(a number, b number) is
        select emp_name, salary
        from employees
        where salary between a and b;
    name varchar2(80);
    sal number;
    flag number :=0;
begin
    open c1(x,y);
        loop
            fetch c1 into name, sal;
            exit when c1%notfound;
            flag:=flag+1;
            dbms_output.put_line(name||', '||sal);
        end loop;
                if c1%rowcount=0 then      -- rowcount :       <--- fetch 로 처리된 row(record)의 개수. fetch 한 번 제대로 실행마다1씩증가.
             dbms_output.put_line('해당하는 데이터가 없습니다'); 
        end if;
--        z:=c%1%rowcount||'개 행을 출력했습니다';
        close c1;
        
--        if flag=0 then 
--            dbms_output.put_line('해당하는 데이터가 없습니다'); end if;
end;
/


declare 
    n varchar2(80);
begin
    p1(9000,1000):=n;
    
end;
/


--
--begin
--create table t1(
--    ename varchar2(80)
--);
--
--end;      테이블생성 pl/sql 안에서는 안되나봄
--/


-- package 만들기  400p
/*
    package 는 연관성이 있는 function나 procedure 들을 묶는것임. 400p 참조. 함수와 프로시저들을 묶는것. 
    
    보관하고 나중에 씀. 약간 객체같은거인듯? cal.add / cal.minus 이런것처럼  한 object같은거에
    연관된 함수들을 모두 모아놓음.

    패키지이름.함수이름 / 패키지이름.프로시저이름  으로 실행함.
    
    앵간히 대규모가 아니면 패키지는 별로 안쓴다.
*/


-- 월욜날 시험인데, 홈페이지 나오고 로그인 회원가입 / 실명 / 로그인아이디 비밀번호 비밀번호확인~관심분야~ 그거 자바스크립트로 한거 냄.
-- 월요일날 6교시 





-- 다이나믹 SQL 은 사실 앞에서 cursor 를 해서 어렵지는 않음. 해볼까 쌤이 욕심이난다고함.




                                    -- dynamic SQL ----

-- 동적SQL 할줄알면 ql/sql 로 웹서비스 짜라고 할수도 있다고 함.
/*
        굳이 하는 이유는 스프링들어가면 비슷한작업이 있음.
        symbolic data 처리하는거. 있음. 그런의도에서 dynamic SQL 까지 함.

        여기부터는 DB 교양이니깐 하고싶은사람만 하셈.
        그래도 알아야지


        동적 sql 는 sql문이 만들어지는거임
        execute immediate 

*/


begin 

    select employee_id, emp_name, job_id
    from employees where job_id = 'AD_ASST';

end;
/
select employee_id, emp_name, job_id
from employees where job_id = 'AD_ASST';

-- 위처럼도 가능한데, dynamic sql이용하면


declare
    str varchar2(200);
begin 
        -- 따옴표 여러개쓴거는 문자열안에서 따옴표임을 표시하기위해서. DB가 작은따옴표 인식할때 어디부터 어디까지가 문자열인지 모름.
    str:='select employee_id, emp_name, job_id
    from employees where job_id = ''AD_ASST'' ';   
    execute immediate str;  -- str안에다가 문자열을 selec~ 문자열을 집어넣고, 실행할때는 execute immediate str; 하면 문자열 안의sql문이 실행된다.
    -- 실행한 결과를 출력해야하는데, 출력은 어떻게 할까? 아래에서
    
--    select employee_id, emp_name, job_id
--    from employees where job_id='AD_ASST';        >> 이건 프로그램안에 sql문을 박아넣는거임.
end;
/

--
declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    jid varchar2(80);
begin 
    -- 출력하기
    str:='select employee_id, emp_name, job_id     
    from employees where job_id = ''AD_ASST'' ';   
    execute immediate str into eid, ename, jid;                  -- 값을 받으려면 into문을 sql문이 아닌 execute immediate 뒤에다가 써야함 
    
    select employee_id, emp_name, job_id
      into eid, ename, jid
    from employees where job_id='AD_ASST';        -- into로 값 받아서 출력가능한데, 위에껀 어떻게출력할까 문자열이라서 값이 안들어감 into해도
    
    -- 제대로 받아졌는지 해보기 아래서
    
end;
/


declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    jid varchar2(80);
begin 
    -- 출력하기
    str:='select employee_id, emp_name, job_id     
    from employees where job_id = ''AD_ASST'' ';   
    execute immediate str into eid, ename, jid;                 
    
    dbms_output.put_line(eid||', '||ename||', '||jid);
end;
/
declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    jid varchar2(80);
begin 
    -- sql 로 출력해서 같은지 확인만해보기
     select employee_id, emp_name, job_id
      into eid, ename, jid
    from employees where job_id='AD_ASST';               
    
    dbms_output.put_line(eid||', '||ename||', '||jid);
end;
/
-- 같다!  위 아래 같은거임.



-- 과제: 사번이 121번인 직원의 사번/이름/월급 출력하는 DSQL 작성
-- sql 안의 값이 for문돌리면서 바뀌는데 나중에 그게 진짜 sql이고
-- 지금 배우는건 sql을 문자열안에 넣고 실행하는 방법임.
-- 나중에 using을 써야 그게 동적sql임.
select employee_id, emp_name, salary from employees where employee_id=121;

declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    sal number;
begin
    str:='select employee_id, emp_name, salary from employees where employee_id=121';
    execute immediate str into eid, ename, sal;

    dbms_output.put_line(eid||', '||ename||', '||sal);
end;


-- 이번에는 using 씀. 


declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    sal number;
begin
    str:='select employee_id, emp_name, salary
        from employees where employee_id=121';
    execute immediate str into eid, ename, sal;

    dbms_output.put_line(eid||', '||ename||', '||sal);
end;
/

-- using 은  where employee_id=121'; 에서 121 이런거 바꾸고싶을때 씀 

declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    sal number;
    jid varchar2(80);
begin
    eid:=124;
    str:='select emp_name, salary, job_id
        from employees where employee_id= :a';       -- :a 는 symbol임. 이 자리는 using을 써서 값을 넣는 첫번째 자리다? 뭐 이런뜻임.
    execute immediate str into ename,sal ,jid using eid;   -- 그러면이건, sql문이 있고 eid값을 :a에 넣고 실행결과를 eid, ename, sal에 
                                                           -- 넣는다는 의미.
    dbms_output.put_line(eid||', '||ename||', '||sal||', '||jid);
end;
/


declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    sal number;
    jid varchar2(80);
    mid number;
begin
    jid:='SA_REP';
    sal:=7000;
    mid:=148;
    str:='select employee_id, emp_name, salary, job_id
        from employees 
        where job_id= :a and salary< :b and manager_id= :c ';       -- :a 는 symbol임. 이 자리는 using을 써서 값을 넣는 첫번째 자리다? 뭐 이런뜻임.
    execute immediate str into eid ,ename,sal,jid using jid, sal, mid;   -- 그러면이건, sql문이 있고 eid값을 :a에 넣고 실행결과를 eid, ename, sal에 
                                                           -- 넣는다는 의미.
    dbms_output.put_line(eid||', '||ename||', '||sal||', '||jid);  
end;
/

-- :a ~ :z 까지 26개까지 가능. 




--- 다음주부터는 Rdata 분석함.
--- Spring 바로할까하다가 교양비슷하게 Rdata 함. 

-- 439p insert문 작성 a가 3개임. 순서만 맞으면 abc 상관없이 돌아가나봄.  그냥 다 a로해볼까



-- 활용

declare
    isql varchar2(200);
    
begin   -- version 3 cursor
    isql:='insert into dep_sal values(:a, :b, :c, :d)';

    for rec in (select b.department_name, 
                        count(*) cnt, 
                        sum(a.salary) sumsal, 
                        c.emp_name manager_name
                from    employees a, departments b, employees c
                where a.department_id = b.department_id
                and    b.manager_id = c.employee_id
                group by b.department_name, b.manager_id, c.emp_name 
                order by b.department_name)
    
    loop
        execute immediate isql using rec.department_name, rec.cnt, rec.sumsal, 
                                     rec.manager_name;
    end loop;
    
end;
/
create table dep_sal (
    dname varchar2(80),
    cnt number,
    total number,
    mname varchar2(80)
);
select * from dep_sal;  -- 이라믄 자동으로 테이블에 data집어넣어줌. 다른곳에서 추출한걸로다가 




select department_name, count(*), sum(a.salary), c.emp_name
from    employees a, departments b, employees c
where a.department_id = b.department_id
and    b.manager_id = c.employee_id
group by b.department_name, b.manager_id, c.emp_name;





