To create the database : 
```bash
createdb <yourdatabasename>
```

to connect to it:
```bash
psql -d <yourdatabasename>
```

when connected you can run the init script
```psql
\i init_db.sql
```

then you can run the queries by doing
```psql
\i req.sql
```