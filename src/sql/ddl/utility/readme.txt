-- elenco tabelle CPASS
SELECT table_name
FROM information_schema.tables 
WHERE table_schema = 'cpass'
and table_type = 'BASE TABLE'

-- copiare nomi tabelle in table_names.txt


-- elenco viste CPASS
SELECT table_name
FROM information_schema.tables 
WHERE table_schema = 'cpass'
and table_type = 'VIEW'

-- copiare nomi viste in view_names.txt


-- da terminale cartella "utility" lanciare bash
D:\workspace-cpass\cpassdb\src\sql\ddl\utility>C:\java\Git\bin\bash.exe

-- lanciare create_sql_create.sh