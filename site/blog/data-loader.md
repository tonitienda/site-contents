# Understanding the Dataloader

[Dataloader](https://github.com/graphql/dataloader) is one of the packages I find more useful and smart from the ones I have in my toolbox.

In this post we are going to navigate a simple but complex enough example to find out the need for a Dataloader.
After that we will implement a naive version of the dataloader to understand its beauty and how useful it is.

## About the project

We have data about libraries and their dependencies. We want to implement a tool that renders the tree of dependencies of a given library.
The tree should show the library and its dependencies, and the dependencies of the dependencies.

These are the dependencies of the libraries:

```text
WebRender depends on HttpClient, Utils, and Logger.
HttpClient depends on NetworkTools and Logger.
Utils depends on NetworkTools, CacheManager, and Logger.
NetworkTools depends on Logger.
CacheManager depends on Logger.
DatabaseConnector depends on NetworkTools and CacheManager.
AuthService depends on HttpClient and Logger.
ApiGateway depends on HttpClient and DatabaseConnector.
PaymentProcessor depends on DatabaseConnector and CacheManager.
Logger has no dependencies (it's a foundational library).
```

In JSON format:

```json
[
  {
    "name": "WebRender",
    "version": "1.0.0",
    "dependencies": [
      {
        "name": "HttpClient",
        "version": "2.1.0"
      },
      {
        "name": "Utils",
        "version": "3.0.0"
      },
      {
        "name": "Logger",
        "version": "1.2.0"
      }
    ]
  },
  {
    "name": "HttpClient",
    "version": "2.1.0",
    "dependencies": [
      {
        "name": "NetworkTools",
        "version": "1.5.0"
      },
      {
        "name": "Logger",
        "version": "1.2.0"
      }
    ]
  },
  {
    "name": "Utils",
    "version": "3.0.0",
    "dependencies": [
      {
        "name": "NetworkTools",
        "version": "1.5.0"
      },
      {
        "name": "CacheManager",
        "version": "4.2.0"
      },
      {
        "name": "Logger",
        "version": "1.2.0"
      }
    ]
  },
  {
    "name": "NetworkTools",
    "version": "1.5.0",
    "dependencies": [
      {
        "name": "Logger",
        "version": "1.2.0"
      }
    ]
  },
  {
    "name": "CacheManager",
    "version": "4.2.0",
    "dependencies": [
      {
        "name": "Logger",
        "version": "1.2.0"
      }
    ]
  },
  {
    "name": "DatabaseConnector",
    "version": "2.4.0",
    "dependencies": [
      {
        "name": "NetworkTools",
        "version": "1.5.0"
      },
      {
        "name": "CacheManager",
        "version": "4.2.0"
      }
    ]
  },
  {
    "name": "AuthService",
    "version": "1.1.0",
    "dependencies": [
      {
        "name": "HttpClient",
        "version": "2.1.0"
      },
      {
        "name": "Logger",
        "version": "1.2.0"
      }
    ]
  },
  {
    "name": "ApiGateway",
    "version": "3.3.0",
    "dependencies": [
      {
        "name": "HttpClient",
        "version": "2.1.0"
      },
      {
        "name": "DatabaseConnector",
        "version": "2.4.0"
      }
    ]
  },
  {
    "name": "PaymentProcessor",
    "version": "5.1.0",
    "dependencies": [
      {
        "name": "DatabaseConnector",
        "version": "2.4.0"
      },
      {
        "name": "CacheManager",
        "version": "4.2.0"
      }
    ]
  },
  {
    "name": "Logger",
    "version": "1.2.0",
    "dependencies": []
  }
]
```

This is the metadata of the libraries:

```json
[
  {
    "name": "WebRender",
    "owner": "WebDevCorp",
    "repo_url": "https://github.com/WebDevCorp/WebRender",
    "release_date": "2023-01-15",
    "license": "MIT",
    "maintainers": [
      "Alice Johnson",
      "Bob Smith"
    ]
  },
  {
    "name": "HttpClient",
    "owner": "NetToolsInc",
    "repo_url": "https://github.com/NetToolsInc/HttpClient",
    "release_date": "2022-09-30",
    "license": "Apache-2.0",
    "maintainers": [
      "Charlie Brown",
      "Dave White"
    ]
  },
  {
    "name": "Utils",
    "owner": "CoreUtils",
    "repo_url": "https://github.com/CoreUtils/Utils",
    "release_date": "2021-12-05",
    "license": "GPL-3.0",
    "maintainers": [
      "Eve Green",
      "Frank Black"
    ]
  },
  {
    "name": "NetworkTools",
    "owner": "NetToolsInc",
    "repo_url": "https://github.com/NetToolsInc/NetworkTools",
    "release_date": "2021-08-22",
    "license": "MIT",
    "maintainers": [
      "Grace Blue"
    ]
  },
  {
    "name": "CacheManager",
    "owner": "TechCore",
    "repo_url": "https://github.com/TechCore/CacheManager",
    "release_date": "2023-05-10",
    "license": "MIT",
    "maintainers": [
      "Hannah Red",
      "Ivy Gold"
    ]
  },
  {
    "name": "DatabaseConnector",
    "owner": "DatabaseTech",
    "repo_url": "https://github.com/DatabaseTech/DatabaseConnector",
    "release_date": "2022-11-20",
    "license": "Apache-2.0",
    "maintainers": [
      "Jack Silver"
    ]
  },
  {
    "name": "AuthService",
    "owner": "AuthCorp",
    "repo_url": "https://github.com/AuthCorp/AuthService",
    "release_date": "2023-03-14",
    "license": "MIT",
    "maintainers": [
      "Kevin Purple",
      "Lily Orange"
    ]
  },
  {
    "name": "ApiGateway",
    "owner": "GatewayTech",
    "repo_url": "https://github.com/GatewayTech/ApiGateway",
    "release_date": "2022-07-01",
    "license": "GPL-3.0",
    "maintainers": [
      "Mason Yellow"
    ]
  },
  {
    "name": "PaymentProcessor",
    "owner": "FinTechCo",
    "repo_url": "https://github.com/FinTechCo/PaymentProcessor",
    "release_date": "2023-02-17",
    "license": "MIT",
    "maintainers": [
      "Nina Blue",
      "Oscar Grey"
    ]
  },
  {
    "name": "Logger",
    "owner": "LoggerTools",
    "repo_url": "https://github.com/LoggerTools/Logger",
    "release_date": "2020-04-10",
    "license": "MIT",
    "maintainers": [
      "Paul Black"
    ]
  }
]
```

And this is the view we want to implement:![View](https://raw.githubusercontent.com/tsoobame/dataloader/main/view.png)



## Initial Setup

### Create the package

```shell
mkdir dataloader
cd dataloader
npm init -y
```

### Install express

```shell
npm install express
```

### Make the package a module to allow using import

We need to add
```json
  "type": "module",
```

to the package.json file.

### Create the files

```shell
touch src/index.js
```

### Create a basic server

```javascript
// src/index.js
import express from "express";

const app = express();

app.get("/", (req, res) => {
  res.send("Hello World");
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
```

### Run the server

```shell
node src/index.js
```

### Try it out

Open [http://localhost:3000](http://localhost:3000) in your browser.

You should see "Hello World".

## Data 

Save the data in json files like:

- data/dependencies.json
- data/metadata.json

## Step 1: Naive implementation

We are going to implement an endpoint (actually simulated) that returns the direct dependencies of one or more libraries.

Crete the file:

```shell
touch src/libraryService.js
```

Implement a fake service that returns data based on the json files we just created.
We are adding a delay to simulate a real service and we are logging the requests to the console
for debugging reasons.

```javascript
// src/libraryService.js
import dependencies from "../data/dependencies.json" with { type: "json" };
import metadata from "../data/metadata.json" with { type: "json" };

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

export async function getDependencies(names) {
  console.log(new Date(), "GET /dependencies?names=" + names.join(","));
  await sleep(200);
  return names.map((name) => dependencies.find((d) => d.name === name));
}

export async function getMetadata(names) {
  console.log(new Date(), "GET /metadata?names=" + names.join(","));
  await sleep(200);
  return names.map((name) => metadata.find((d) => d.name === name));
}
```

Let's add our resolver:

```shell
touch src/resolver.js
```

```javascript
// src/resolver.js
import { getDependencies, getMetadata } from "./libraryService.js";

export async function getDependenciesWithMetadata(names) {
  const libs = await getDependencies(names);

  for (const lib of libs) {
    lib.metadata = await getMetadata(lib.dependencies.map((d) => d.name));
    lib.dependencies = await getMetadata(
      lib.dependencies.map((dep) => dep.name)
    );
  }

  return libs;
}
```

Let's add a new endpoint to our server that returns the dependencies of a library:

```javascript
// src/index.js
import { getDependenciesWithMetadata } from "./resolver.js";
...
app.get("/dependencies", async (req, res) => {
  const names = req.query.names.split(",");
  const libs = await getDependenciesWithMetadata(names);

  res.json(libs);
});
...
```

Let's test it:

```shell
curl "http://localhost:3000/dependencies?names=WebRender,HttpClient"
```

You should see the dependencies of WebRender and HttpClient.
The log of the server will show:

```text
2025-02-05T17:13:27.910Z GET /dependencies?names=WebRender,HttpClient
2025-02-05T17:13:28.113Z GET /metadata?names=HttpClient,Utils,Logger
2025-02-05T17:13:28.317Z GET /metadata?names=HttpClient,Utils,Logger
2025-02-05T17:13:28.519Z GET /metadata?names=NetworkTools,Logger
2025-02-05T17:13:28.722Z GET /metadata?names=NetworkTools,Logger
```


### datasource.js

The datasource allows us to retrieve one or multiple users by id. Contract is not random, it is already based on the real dataloader so there will be minimal changes over the course of the post. Data is defined in a file within the project. Code is pretty simple:

```javascript
const users = require("./users.json");

const getUsersFromFile = (ids) =>
  ids.map((id) => users.find((u) => u.id === id));

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function loadMany(ids) {
  console.log(`GET /users?ids=${ids}`);

  await sleep(100);
  return getUsersFromFile(ids);
}

async function load(id) {
  const results = await loadMany([id]);
  return results[0];
}

module.exports = {
  load,
  loadMany,
};
```

The only interesting method is loadMany. We will print the requests to the simulated service so we can check the console. There will be a delay to resolve the promise, so we can simulate better and understand why dataloader is so good.

A very important requirement is that data needs to be returned to the caller in the right order and all elements need to be returned (same length of ids and results arrays). This will be clear when we put in place the dataloader.

### resolver.js

Resolver will use the datasource received by parameter to load friendship data about users. It can receive the levels of friends we want to get, so it will use a recursive approach to load friends of friends until all levels are fetched.

```javascript
async function getFriends(datasource, user, levels) {
  if (levels == 0) {
    return { id: user.id, name: user.name };
  }

  const friends = await datasource.loadMany(user.friends);

  return {
    ...user,
    friends: await Promise.all(
      friends.map((f) => getFriends(datasource, f, levels - 1))
    ),
  };
}

async function getUserWithFriends(datasource, id, levels = 1) {
  const user = await datasource.load(id);
  return getFriends(datasource, user, levels);
}

module.exports = { getUserWithFriends };
```

It uses a brute force approach on purpose. The code is simple but far away from being optimal. In one method it looks obvious, but sometimes, when we are building graphql or similar apis, or complex workflows we might be doing exactly this kind of brute force requests.

### view.js

Nothing advanced. Just render users friends in a nested way.

```javascript
function render(user) {
  return `<div style="padding-left: 12px;background-color:#def"> ${user.name} ${
    user.friends ? user.friends.map((u) => render(u)).join("") : ""
  } </div>`;
}

module.exports = {
  render,
};
```

### server.js

```javascript
const express = require("express");
const PORT = 3000;
const app = express();

const datasource = require("./datasource");
const resolver = require("./resolver");
const view = require("./view");

app.get(`/user-with-friends/:id`, async (req, res) => {
  const id = req.params.id;
  const levels = req.query.levels || 1;

  const user = await resolver.getUserWithFriends(datasource, id, levels);

  res.send(view.render(user));
});

app.listen(PORT, () => console.log(`Fakebook listening to ${PORT}`));
```

## Run

```shell
node index.js
```

## Test 1

We will render friends of user 1. Only 1 level:

```text
http://localhost:3000/user-with-friends/1
```

If we check in our console we will find:

```text
GET /users?ids=1
GET /users?ids=2,3
```

All good. We requested user 1 and their friends 2 and 3.

## Test 2

Let's try by loading 3 levels:

```text
http://localhost:3000/user-with-friends/1?levels=3
```

Things are getting interesting here:

```text
GET /users?ids=1
GET /users?ids=2,3
GET /users?ids=1,3
GET /users?ids=1,2,4
GET /users?ids=2,3
GET /users?ids=1,2,4
GET /users?ids=2,3
GET /users?ids=1,3
GET /users?ids=3,5
```

We are loading data for users 1,2,3,4,5 but we are doing 9 requests. We are requesting the same users again and again. We could easily improve the situation adding some sort of cache per request.

Cache per request
We are going to add a cache to the system. It will be empty at the start of each request, so we do not need to worry about expirations. The benefits will be:

Do not request the same resource twice to the remote source during the same request.
As side effect, if we try to get the same resource twice during the same request, we will get the same data. So mutations of the resources in between a request will not provide incoherent results.

### cache.js

Simple cache implementation:

```javascript
function make(loadManyFn) {
  const cache = {};

  async function loadMany(ids) {
    const notCachedIds = ids.filter((id) => !cache[id]);

    if (notCachedIds.length > 0) {
      const results = await loadManyFn(notCachedIds);
      notCachedIds.forEach((id, idx) => (cache[id] = results[idx]));
    }

    return ids.map((id) => cache[id]);
  }

  return {
    load: async (id) => {
      const results = await loadMany([id]);
      return results[0];
    },
    loadMany,
  };
}

module.exports = { make };
```

Cache needs a function to retrieve multiple data by id (or in general by a key). It will check the data that is cached and request only the ids that are not found.

Implements the same contract as datasource.

### server.js

Let's add this line to the server:

```javascript
const cache = require('./cache')
And replace this line:

const user = await resolver.getUserWithFriends(datasource, id, levels)
with:

const user = await resolver.getUserWithFriends(cache.make(datasource.loadMany), id, levels)
```

## Run

Let's run again the server and test the previous request:

```text
http://localhost:3000/user-with-friends/1?levels=3
```

```text
GET /users?ids=1
GET /users?ids=2,3
GET /users?ids=4
GET /users?ids=4
GET /users?ids=5
```

We could reduce the number of requests from 9 to 5, which is pretty good. But, what a momentwhat happened here? Why are we requesting id=4 twice?

If we unnest the request flow based on how nodejs works (and how we implemented our resolver) this is what happened:

```text
1 - Load user 1 => GET /users?ids=1
2 - Load friends of 1: [2,3]=> GET /users?ids=2,3
3.1. Load friends of 2: [1,3] => all cached
4.1. Load friends of 1 : [2,3] => all cached
4.2. Load friends of 3 : [1,2,4] => GET /users?ids=4
3.2. Load friends of 3: [1,2,4] => GET /users?ids=4
4.3. Load friends of 1: [2,3] => all cached
4.4. Load friends of 2: [1,3] => all cached
4.5. Load friends of 4: [3,5] => GET /users?ids=5
On 3.1 we had all friends of user 2 cached. So the code was straight to 4.2, than ran in parallel with 3.2. Both were waiting for the same user (4) and therefore made the same requests twice.
```

So with our simple cache, we did not reduce the requests to the minimun we wanted.

For example, if we did:

```javascript
const users = await Promise.all(load(1), load(1));
```

There would be 2 requests before the cache has data for id=1.

Let's fix this and produce the ideal:

```text
GET /users?ids=1
GET /users?ids=2,3
GET /users?ids=4
GET /users?ids=5
```

## Dataloader

Using nodejs `process.nextTick(...)` we can postpone the execution of a given function to the end of the current event loop cycle. It is useful to run a given function after all variables are initialized for example.

From nodejs documentation:

```text
By using process.nextTick() we guarantee that apiCall() always runs its callback after the rest of the user's code and before the event loop is allowed to proceed.
```

Using it we can accumulate all the keys that are being requested during the same cycle (3.2 and 4.2 in the example above) and request them at the end. In the next cycle we would accumulate again the ones that were depending in the previous ones and so on.

This simple version of dataloader incorporates also code to accomplish the cache:

```javascript
function make(loadManyFn) {
  const cache = {};
  let pending = [];
  let scheduled = false;
  function scheduleSearch() {
    if (pending.length > 0 && !scheduled) {
      scheduled = true;
      Promise.resolve().then(() =>
        process.nextTick(async () => {
          await runSearch();
          scheduled = false;
        })
      );
    }
  }

  async function runSearch() {
    const pendingCopy = pending.splice(0, pending.length);
    pending = [];

    if (pendingCopy.length > 0) {
      const results = await loadManyFn(pendingCopy.map((p) => p.id));
      pendingCopy.forEach(({ resolve }, idx) => resolve(results[idx]));
    }
  }

  async function loadMany(ids) {
    const notCachedIds = ids.filter((id) => !cache[id]);

    if (notCachedIds.length > 0) {
      notCachedIds.map((id) => {
        cache[id] = new Promise((resolve) => {
          pending.push({ id, resolve });
        });
      });

      scheduleSearch();
    }

    return Promise.all(ids.map((id) => cache[id]));
  }

  return {
    load: async (id) => {
      const results = await loadMany([id]);
      return results[0];
    },
    loadMany,
  };
}

module.exports = { make };
```

Ignoring the part of the cache, the important bits are:

### Accumulating requests

```javascript
notCachedIds.map((id) => {
  cache[id] = new Promise((resolve) => {
    pending.push({ id, resolve });
  });
});
```

We will add to the list of pending ids the ones that are not cached. We will keep the id and the resolve method, so we can resolve them afterwards with the right value. We cache the promise itself in the hashmap. This would allow us to cache also rejected promises for example. So we do not request over and over the same rejection. It is not used in this implementation, though.

### Scheduling the request

```javascript
function scheduleSearch() {
  if (pending.length > 0 && !scheduled) {
    scheduled = true;
    Promise.resolve().then(() =>
      process.nextTick(async () => {
        await runSearch();
        scheduled = false;
      })
    );
  }
}
```

That is where the magic happens. This function is short but is the most important one: We schedule/delay the request to the end of all the promises declarations.

### Executing the search

```javascript
async function runSearch() {
  const pendingCopy = pending.splice(0, pending.length);
  pending = [];

  if (pendingCopy.length > 0) {
    const results = await loadManyFn(pendingCopy.map((p) => p.id));
    pendingCopy.forEach(({ resolve }, idx) => resolve(results[idx]));
  }
}
```

Clone the ids (so they can be accumulated again after the search completes) and call the loadManyFn so we can resolve the promises we had pending. Remember the requirements of loadMany to return the data in the right order and all the elements ? This is where it is needed. We can reference the results by index and resolve the right pending promises.

Let's run it!

## Execution

Again the same request:

```text
http://localhost:3000/user-with-friends/1?levels=3
```

That produces the following output:

```text
GET /users?ids=1
GET /users?ids=2,3
GET /users?ids=4
GET /users?ids=5
```

Exactly what we wanted.

## Conclusion

- Dataloader is a great package that should be in all developers toolbox. Specially the ones implementing Graphql or similar Apis.

- The resolvers in this example could be optimized but sometimes our requests are on different files at different levels that depend on some conditions. With Dataloader we can keep our file structure and code readability without damaging our performance, both on response time to our client and on number of requests spawn within our mesh.

Are you using Dataloader? Do you know any tool that accomplishes something similar? Do you now any other packages that in your opinion should be in all nodejs devs toolbox?
