# MMIWG2S Backend

This is the backend for accepting requests from the mobile apps and save the submissions.

It is a single deploy application built with, node, expressjs, mongodb.


## Architecture

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW1wiTW9iaWxlIEFwcHMgKGlPU3xBbmRyb2lkKVwiXSAtLT58XCJQT1NUIHdpdGggKGltYWdlLCBuYW1lLCBlbWFpbClcInwgQihNTUlXRzJTIEJhY2tlbmQgb24gRE8pXG4gICAgQiAtLT58bW9uZ28gcGVyc2lzdHMgb24gaG9zdHwgRFtcIi9kYXRhL2RiIGhvc3Qgb2YgRE8gPGJyPiBTdG9yZXMgdGhlIChlbWFpbCwgbmFtZSwgaW1hZ2VfdXJsKVwiXVxuICAgIEIgLS0-IHxcIlN0cmlwcyB0aGUgaW1hZ2UgYW5kIHB1c2hlcyBpdCB0byB0aGUgYnVja2V0IDxicj4gYW5kIGNyZWF0ZXMgYSB1bmlxdWUgZmlsZW5hbWVcInwgUyhCYWNrQmxhemUgU3RvcmFnZSBidWNrZXQgc3RvcmVzIHRoZSBpbWFnZSlcbiAgICBCIC0tPiB8XCJXZWJzaXRlXCJ8RVtcIkNhbiBzZXJ2ZSByYW5kb20gaW1hZ2VzIGZyb20gdGhlIGJhY2tlbmQgPGJyPiB1c2lnbiB0aGUgQVBJXCJdIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW1wiTW9iaWxlIEFwcHMgKGlPU3xBbmRyb2lkKVwiXSAtLT58XCJQT1NUIHdpdGggKGltYWdlLCBuYW1lLCBlbWFpbClcInwgQihNTUlXRzJTIEJhY2tlbmQgb24gRE8pXG4gICAgQiAtLT58bW9uZ28gcGVyc2lzdHMgb24gaG9zdHwgRFtcIi9kYXRhL2RiIGhvc3Qgb2YgRE8gPGJyPiBTdG9yZXMgdGhlIChlbWFpbCwgbmFtZSwgaW1hZ2VfdXJsKVwiXVxuICAgIEIgLS0-IHxcIlN0cmlwcyB0aGUgaW1hZ2UgYW5kIHB1c2hlcyBpdCB0byB0aGUgYnVja2V0IDxicj4gYW5kIGNyZWF0ZXMgYSB1bmlxdWUgZmlsZW5hbWVcInwgUyhCYWNrQmxhemUgU3RvcmFnZSBidWNrZXQgc3RvcmVzIHRoZSBpbWFnZSlcbiAgICBCIC0tPiB8XCJXZWJzaXRlXCJ8RVtcIkNhbiBzZXJ2ZSByYW5kb20gaW1hZ2VzIGZyb20gdGhlIGJhY2tlbmQgPGJyPiB1c2lnbiB0aGUgQVBJXCJdIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)


## Endpoints

Accept submission

```
POST or PUT
/submission
params:
name
email
image
```

Get submissions
```
GET
/submissions
params:
number

```

Health check
```
GET
/health-check
```

## Notes

* Rate limits the submissions to an IP

## Schema

```
var submissionSchema = new Schema({
	'name' : String,
	'email' : String,
	'image_url' : String,
	'verified' : Boolean
});
```

## Deployment

Deployment is via `docker-compose`

```
docker-compose up -d
```

## Development

TODO