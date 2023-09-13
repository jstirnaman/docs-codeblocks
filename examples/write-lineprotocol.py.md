### Example

The following example shows how to use the v3 Python client library to write line protocol strings to InfluxDB.

```python
from dotenv import dotenv_values
from influxdb_client_3 import InfluxDBClient3, InfluxDBError

def write_line_protocol():
    # Set the path to your .env file.
    config = dotenv_values(".env.influxdbv3")

    # Instantiate an InfluxDB client.
    client = InfluxDBClient3(
        host=config['INFLUX_HOST'],
        token=config['INFLUX_TOKEN'],
        database=config['INFLUX_DATABASE']
    )

    # Define line protocol to write.
    lines = [
        "home,room=Living\\ Room temp=21.1,hum=35.9,co=0i 1641110400",
        "home,room=Kitchen temp=21.0,hum=35.9,co=0i 1641110400",
        "home,room=Living\\ Room temp=21.4,hum=35.9,co=0i 1641114000",
        "home,room=Kitchen temp=23.0,hum=36.2,co=0i 1641114000",
        "home,room=Living\\ Room temp=21.8,hum=36.0,co=0i 1641117600",
        "home,room=Kitchen temp=22.7,hum=36.1,co=0i 1641117600",
        "home,room=Living\\ Room temp=22.2,hum=36.0,co=0i 1641121200",
        "home,room=Kitchen temp=22.4,hum=36.0,co=0i 1641121200",
        "home,room=Living\\ Room temp=22.2,hum=35.9,co=0i 1641124800",
        "home,room=Kitchen temp=22.5,hum=36.0,co=0i 1641124800",
        "home,room=Living\\ Room temp=22.4,hum=36.0,co=0i 1641128400",
        "home,room=Kitchen temp=22.8,hum=36.5,co=1i 1641128400",
        "home,room=Living\\ Room temp=22.3,hum=36.1,co=0i 1641132000",
        "home,room=Kitchen temp=22.8,hum=36.3,co=1i 1641132000",
        "home,room=Living\\ Room temp=22.3,hum=36.1,co=1i 1641135600",
        "home,room=Kitchen temp=22.7,hum=36.2,co=3i 1641135600",
        "home,room=Living\\ Room temp=22.4,hum=36.0,co=4i 1641139200",
        "home,room=Kitchen temp=22.4,hum=36.0,co=7i 1641139200",
        "home,room=Living\\ Room temp=22.6,hum=35.9,co=5i 1641142800",
        "home,room=Kitchen temp=22.7,hum=36.0,co=9i 1641142800",
        "home,room=Living\\ Room temp=22.8,hum=36.2,co=9i 1641146400",
        "home,room=Kitchen temp=23.3,hum=36.9,co=18i 1641146400",
        "home,room=Living\\ Room temp=22.5,hum=36.3,co=14i 1641150000",
        "home,room=Kitchen temp=23.1,hum=36.6,co=22i 1641150000",
        "home,room=Living\\ Room temp=22.2,hum=36.4,co=17i 1641153600",
        "home,room=Kitchen temp=22.7,hum=36.5,co=26i 1641153600"
    ]

    # Write line protocol to the database (bucket).
    # Because the line protocol contains timestamps in seconds, the call to write()# specifies write_precision='s'.
    response = client.write(lines, write_precision='s')
    client.close()

    assert response is None, "Error writing line protocol"
```