### Example

The following example shows how to use the v3 JavaScript client library to write line protocol strings to InfluxDB.

```javascript
import { InfluxDBClient } from "@influxdata/influxdb3-client";

/**
 * Set InfluxDB credentials.
 */
const host = "https://{{< influxdb/host >}}";
const database = "DATABASE_NAME";
const token = "DATABASE_TOKEN";

/**
 * Write line protocol to InfluxDB using the JavaScript client library.
 */
export async function writeLineProtocol() {
  /**
   * Instantiate an InfluxDBClient
   */
  const client = new InfluxDBClient({ host, token });

  /**
   * Define line protocol records to write.
   */
  const records = [
    `home,room=Living\\ Room temp=21.1,hum=35.9,co=0i 1641124000`,
    `home,room=Kitchen temp=21.0,hum=35.9,co=0i 1641124000`,
    `home,room=Living\\ Room temp=21.4,hum=35.9,co=0i 1641127600`,
    `home,room=Kitchen temp=23.0,hum=36.2,co=0 1641127600`,
    `home,room=Living\\ Room temp=21.8,hum=36.0,co=0i 1641131200`,
    `home,room=Kitchen temp=22.7,hum=36.1,co=0i 1641131200`,
    `home,room=Living\\ Room temp=22.2,hum=36.0,co=0i 1641134800`,
    `home,room=Kitchen temp=22.4,hum=36.0,co=0i 1641134800`,
    `home,room=Living\\ Room temp=22.2,hum=35.9,co=0i 1641138400`,
    `home,room=Kitchen temp=22.5,hum=36.0,co=0i 1641138400`,
    `home,room=Living\\ Room temp=22.4,hum=36.0,co=0i 1641142000`,
    `home,room=Kitchen temp=22.8,hum=36.5,co=1i 1641142000`,
    `home,room=Living\\ Room temp=22.3,hum=36.1,co=0i 1641145600`,
    `home,room=Kitchen temp=22.8,hum=36.3,co=1i 1641145600`,
    `home,room=Living\\ Room temp=22.3,hum=36.1,co=1i 1641149200`,
    `home,room=Kitchen temp=22.7,hum=36.2,co=3i 1641149200`,
    `home,room=Living\\ Room temp=22.4,hum=36.0,co=4i 1641152800`,
    `home,room=Kitchen temp=22.4,hum=36.0,co=7i 1641152800`,
    `home,room=Living\\ Room temp=22.6,hum=35.9,co=5i 1641156400`,
    `home,room=Kitchen temp=22.7,hum=36.0,co=9i 1641156400`,
    `home,room=Living\\ Room temp=22.8,hum=36.2,co=9i 1641160000`,
    `home,room=Kitchen temp=23.3,hum=36.9,co=18i 1641160000`,
    `home,room=Living\\ Room temp=22.5,hum=36.3,co=14i 1641163600`,
    `home,room=Kitchen temp=23.1,hum=36.6,co=22i 1641163600`,
    `home,room=Living\\ Room temp=22.2,hum=36.4,co=17i 1641167200`,
    `home,room=Kitchen temp=22.7,hum=36.5,co=26i 1641167200`,
  ];

  /**
   * Create an array that contains a separate write request for each record.
   */
  const writeRequests = records.map((record) => {
    return client.write(record, database, "", { precision: "s" })
    .then(() => `Data has been written successfully: ${record}`,
          () => `Failed writing data: ${record}`);
  });

  /**
   * Execute the promises stored in the array, wait for all of them to
   * complete, and then output the results.
   */  
  const writes = await Promise.allSettled(writeRequests);
  writes.forEach(write => console.log(write.value));

  /** Close the client to release resources. */
  await client.close();
}
```
