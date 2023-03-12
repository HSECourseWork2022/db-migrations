FROM alpine/git:2.36.3 AS gitclone
WORKDIR /
RUN git clone https://github.com/vishnubob/wait-for-it.git

FROM liquibase/liquibase:4.19.0
COPY --from=gitclone /wait-for-it ./wait-for-it
COPY /migrations /liquibase/changelog/

ENTRYPOINT env && ./wait-for-it/wait-for-it.sh ${DB_URL} -- \
liquibase --url=${JDBC_URL} --changeLogFile=changelog/changelog.xml \
--username=${USERNAME} --password=${PASSWORD} \
update