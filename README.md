## build after patching # https://issues.apache.org/jira/browse/FLINK-3892
```bash
tools/change-scala-version.sh 2.11
mvn clean -Dmaven.test.skip -Dscala.version=2.11.7 -Dhadoop.version=2.7.2 -pl '!flink-test-utils' install
```

## run: referecing hadoop
```bash
docker run --name flnk --volumes-from hdp --link hdp flink
```
