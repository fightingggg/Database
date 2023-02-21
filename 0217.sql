
-- Ŀ��3�� ��Ȱ�뿡 �������־ ���� �ַ� 1,2 version cursor ���ٰ� ��

-- ������ exception(����ó��)/ transaction /����sql

-- ql/sql ���� try catch �� ���� �ٷ� exception �� �����µ�  ������ �Ʒ��� ����


/*
    declare
    
    begin
    

    

    exception when ���ܸ�1 then ����ó��1 
              when ���ܸ�2 then ����ó��2
              ..
              when ���ܸ�n-1 then ����ó��n-1
              when others then ����ó��n
    end;
    /


    when others then �� ���� ���ǵ������� �� �� ��翹��ó���� ��.
    
    others �� java����
    
    try{
    
    } catch(Exception e){
    
    } finally {  } 
    
    ���� catch(Exception e) �� �����.

    �׳� ó������ ��� ���������� ����ó���� �ϰ������ 
    when others then ����ó��~ �� �ϸ� ��. �̷����ϸ� DB���� ����ó���� ���ߴ°���. �츮�� ����������
    ��� ������ ���� ��. �츮�� ����ó���� ��ü������ �ϴ°� �ƴ�
    �޸𸮸� �ݳ��Ѵٰų� �׷��� �� db�ȿ��� ��. �츮�� ��ó���� ���ϸ��. ���� ����ó���� ����� ����ó���ϴ°žƴϰ� �ý����� ���ִ°���.

    �߰��� ������ ���� �ڵ尡 exception ���� ��. �׸��� �ش��ϴ� ����ó���� ��. �׸��� ����.
    ����� �����̸��� �츮�� �ƴ°Ŷ� �� �ٸ�. �̰Ŵ� �������ϰ� ������
    ������ �������̾���.


    ��ü���� ������ ���� ����ó���� �ϰ������ 311p �����.
    when �̶� then ���̿� �� ���������
    
    ex)
    
    exception when zero_divide then ~
*/


declare 
    i number :=0;
begin
    i:=10/0;
    dbms_output.put_line('success');
    
exception when others then
    dbms_output.put_line('������ ����');
end;
/
-- ������ ������ exception ���� ����ȵǰ� ����. ���������� �����.
declare 
    i number :=0;
begin
    i:=10/0;
    dbms_output.put_line('success');
    
exception when zero_divide then
    dbms_output.put_line('������ ����2');
end;
/


-- ���ܸ� �ڱⰡ ����⵵ ���� 316-317p 
-- raise ���ܸ� �ϸ� ������ ���� �߻���Ŵ 
begin
    raise zero_divide;
end;
/
-- ������ ���� ���ܴ� ������ �߻���Ŵ


-- ���ܼ��� / ���ܹ߻� / ����ó�� 3�κ��� ���� ����� ���� ���ܸ� ���� Ȱ���ϴ� �κ���.



-- ����sql : sql ���� �ڵ����� ����°�. sql���� ���α׷� code�� �����ϴ°�.
/*
    ������� insert ��.
    
    insert into values(__, __, __) 
    ���� �ȿ� ���°��� ���� �ٲ����Ҷ�
    for�������µ�, ����sql �� ��.
    
*/



-- transcation / table ���� ��.
-- �����ð����� table �������ϴ°� �� 



-- table design ���̺� ���� - �׸��Ǻ��� 


-- ���� ���� �ʹ� ���̳����Ű��Ƽ� procedure �𸣴»�� ���Ƽ� �ٽü����ϰ� �Ϸ������Ѵٰ��Ͻ�.

/*

�Լ� / procedure ����

�Լ��� sql�ȿ����� ��� �����ϰ�, procedure �� �ۿ����� �ܵ����డ��
select f1(xxx) from .. insert into T values(f1(xxx),...) update T set col1=f1(xxxx)

���ν����� �ܰ������� ó���ϴ� �Ϸ��� �۾��� �� �� ��

�Ľ�Į �迭 ���� �Ű������� �����ʴ� ���ν����� �Լ��� ()�� ���� ������
 �׳��̸�����ߵ�
 �ٵ��Ű����� �޴¾ֵ��� ��ߵ�
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
    dbms_output.put_line('����� �ش��ϴ� ������ �����ϴ�');
          when others then
    dbms_output.put_line('�˼����� �����߻�');
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
                if c1%rowcount=0 then      -- rowcount :       <--- fetch �� ó���� row(record)�� ����. fetch �� �� ����� ���ึ��1������.
             dbms_output.put_line('�ش��ϴ� �����Ͱ� �����ϴ�'); end if;
        close c1;
        
--        if flag=0 then 
--            dbms_output.put_line('�ش��ϴ� �����Ͱ� �����ϴ�'); end if;
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
                if c1%rowcount=0 then      -- rowcount :       <--- fetch �� ó���� row(record)�� ����. fetch �� �� ����� ���ึ��1������.
             dbms_output.put_line('�ش��ϴ� �����Ͱ� �����ϴ�'); 
        end if;
--        z:=c%1%rowcount||'�� ���� ����߽��ϴ�';
        close c1;
        
--        if flag=0 then 
--            dbms_output.put_line('�ش��ϴ� �����Ͱ� �����ϴ�'); end if;
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
--end;      ���̺���� pl/sql �ȿ����� �ȵǳ���
--/


-- package �����  400p
/*
    package �� �������� �ִ� function�� procedure ���� ���°���. 400p ����. �Լ��� ���ν������� ���°�. 
    
    �����ϰ� ���߿� ��. �ణ ��ü�������ε�? cal.add / cal.minus �̷���ó��  �� object�����ſ�
    ������ �Լ����� ��� ��Ƴ���.

    ��Ű���̸�.�Լ��̸� / ��Ű���̸�.���ν����̸�  ���� ������.
    
    �ް��� ��Ը� �ƴϸ� ��Ű���� ���� �Ⱦ���.
*/


-- ���糯 �����ε�, Ȩ������ ������ �α��� ȸ������ / �Ǹ� / �α��ξ��̵� ��й�ȣ ��й�ȣȮ��~���ɺо�~ �װ� �ڹٽ�ũ��Ʈ�� �Ѱ� ��.
-- �����ϳ� 6���� 





-- ���̳��� SQL �� ��� �տ��� cursor �� �ؼ� ������� ����. �غ��� ���� ����̳��ٰ���.




                                    -- dynamic SQL ----

-- ����SQL ���پ˸� ql/sql �� ������ ¥��� �Ҽ��� �ִٰ� ��.
/*
        ���� �ϴ� ������ ���������� ������۾��� ����.
        symbolic data ó���ϴ°�. ����. �׷��ǵ����� dynamic SQL ���� ��.

        ������ʹ� DB �����̴ϱ� �ϰ��������� �ϼ�.
        �׷��� �˾ƾ���


        ���� sql �� sql���� ��������°���
        execute immediate 

*/


begin 

    select employee_id, emp_name, job_id
    from employees where job_id = 'AD_ASST';

end;
/
select employee_id, emp_name, job_id
from employees where job_id = 'AD_ASST';

-- ��ó���� �����ѵ�, dynamic sql�̿��ϸ�


declare
    str varchar2(200);
begin 
        -- ����ǥ ���������Ŵ� ���ڿ��ȿ��� ����ǥ���� ǥ���ϱ����ؼ�. DB�� ��������ǥ �ν��Ҷ� ������ �������� ���ڿ����� ��.
    str:='select employee_id, emp_name, job_id
    from employees where job_id = ''AD_ASST'' ';   
    execute immediate str;  -- str�ȿ��ٰ� ���ڿ��� selec~ ���ڿ��� ����ְ�, �����Ҷ��� execute immediate str; �ϸ� ���ڿ� ����sql���� ����ȴ�.
    -- ������ ����� ����ؾ��ϴµ�, ����� ��� �ұ�? �Ʒ�����
    
--    select employee_id, emp_name, job_id
--    from employees where job_id='AD_ASST';        >> �̰� ���α׷��ȿ� sql���� �ھƳִ°���.
end;
/

--
declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    jid varchar2(80);
begin 
    -- ����ϱ�
    str:='select employee_id, emp_name, job_id     
    from employees where job_id = ''AD_ASST'' ';   
    execute immediate str into eid, ename, jid;                  -- ���� �������� into���� sql���� �ƴ� execute immediate �ڿ��ٰ� ����� 
    
    select employee_id, emp_name, job_id
      into eid, ename, jid
    from employees where job_id='AD_ASST';        -- into�� �� �޾Ƽ� ��°����ѵ�, ������ �������ұ� ���ڿ��̶� ���� �ȵ� into�ص�
    
    -- ����� �޾������� �غ��� �Ʒ���
    
end;
/


declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    jid varchar2(80);
begin 
    -- ����ϱ�
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
    -- sql �� ����ؼ� ������ Ȯ�θ��غ���
     select employee_id, emp_name, job_id
      into eid, ename, jid
    from employees where job_id='AD_ASST';               
    
    dbms_output.put_line(eid||', '||ename||', '||jid);
end;
/
-- ����!  �� �Ʒ� ��������.



-- ����: ����� 121���� ������ ���/�̸�/���� ����ϴ� DSQL �ۼ�
-- sql ���� ���� for�������鼭 �ٲ�µ� ���߿� �װ� ��¥ sql�̰�
-- ���� ���°� sql�� ���ڿ��ȿ� �ְ� �����ϴ� �����.
-- ���߿� using�� ��� �װ� ����sql��.
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


-- �̹����� using ��. 


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

-- using ��  where employee_id=121'; ���� 121 �̷��� �ٲٰ������ �� 

declare
    str varchar2(200);
    eid number;
    ename varchar2(80);
    sal number;
    jid varchar2(80);
begin
    eid:=124;
    str:='select emp_name, salary, job_id
        from employees where employee_id= :a';       -- :a �� symbol��. �� �ڸ��� using�� �Ἥ ���� �ִ� ù��° �ڸ���? �� �̷�����.
    execute immediate str into ename,sal ,jid using eid;   -- �׷����̰�, sql���� �ְ� eid���� :a�� �ְ� �������� eid, ename, sal�� 
                                                           -- �ִ´ٴ� �ǹ�.
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
        where job_id= :a and salary< :b and manager_id= :c ';       -- :a �� symbol��. �� �ڸ��� using�� �Ἥ ���� �ִ� ù��° �ڸ���? �� �̷�����.
    execute immediate str into eid ,ename,sal,jid using jid, sal, mid;   -- �׷����̰�, sql���� �ְ� eid���� :a�� �ְ� �������� eid, ename, sal�� 
                                                           -- �ִ´ٴ� �ǹ�.
    dbms_output.put_line(eid||', '||ename||', '||sal||', '||jid);  
end;
/

-- :a ~ :z ���� 26������ ����. 




--- �����ֺ��ʹ� Rdata �м���.
--- Spring �ٷ��ұ��ϴٰ� �������ϰ� Rdata ��. 

-- 439p insert�� �ۼ� a�� 3����. ������ ������ abc ������� ���ư�����.  �׳� �� a���غ���



-- Ȱ��

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
select * from dep_sal;  -- �̶�� �ڵ����� ���̺� data����־���. �ٸ������� �����Ѱɷδٰ� 




select department_name, count(*), sum(a.salary), c.emp_name
from    employees a, departments b, employees c
where a.department_id = b.department_id
and    b.manager_id = c.employee_id
group by b.department_name, b.manager_id, c.emp_name;





