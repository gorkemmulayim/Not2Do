# Not2Do
An application that allows users to make and share "not to do's".


```bundle install```<br>
```sudo service postgresql start```<br>
```sudo su - postgres -c 'psql -c "CREATE USER dbuser WITH PASSWORD '\''123456'\'';"'```<br>
```rake db:create```<br>
```rake db:migrate```<br>

After above steps you should be able to run project through 'Run Project' button on Cloud9.
