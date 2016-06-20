## build after patching # https://issues.apache.org/jira/browse/FLINK-3892
```bash
tools/change-scala-version.sh 2.11
mvn clean -Dmaven.test.skip -Dscala.version=2.11.7 -Dhadoop.version=2.7.2 -pl '!flink-test-utils' install
```

## run separated, referencing hadoop
```bash
docker run --name flnk --volumes-from hdp --link hdp flink
```

## run composed
external networking is used because of http://bugs.java.com/bugdatabase/view_bug.do?bug_id=5049974 workaround. docker uses underscores in network and host naming ... 
```bash
docker network create --driver overlay iot.net
docker-compose -p iot up
```

## elastic
### 1. Vytorenie indexu
```bash
curl -XPUT 'http://localhost:9200/iot-kura/' -d '{
    "settings": {
        "index": {
            "number_of_shards": 5,
            "number_of_replicas": 1
        }
    },
    "_all": {
        "enabled": false
    },
    "mappings": {
        "kura-entry": {
            "properties": {
                "device_id": {
                    "type": "string"
                },
                "unit": {
                    "type": "string"
                },
                "value": {
                    "type": "double"
                },
                "count": {
                    "type": "long"
                },
                "timestamp": {
                    "type": "date",
                    "format": "epoch_millis"
                },
                "location": {
                    "type": "geo_point"
                }
            }
        }
    }
}'
```

### 2. Kontrola, či index existuje:
`curl 'localhost:9200/_cat/indices?v'`

### 3. Pridanie zaznamu:
```bash
curl -XPOST 'http://localhost:9200/iot-kura/kura-entry?pretty' -d '{
    "timestamp": "1466079132988",
    "location": {
        "lat": 48.1458923,
        "lon": 17.1071373
    },
    "unit": "C",
    "count": "120",
    "value": "2.3313523654E10",
    "device_id": "kura.device.name"
}'
```

